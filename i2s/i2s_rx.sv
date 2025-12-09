/* 
 * i2s receiver
 * Collects serial bits from i2s transmitter of ICS-43432 microphone
 * and outputs a 16-bit data
 *
 * Notes:
 * clk freq (~100MHz) >> sck freq (~3MHz)
 * only uses right channel of ICS-43432
 * simple valid/ready handshaking
 * 
 * 
*/
module i2s_rx
(
    input   clk,        // internal clock
    input   rst_n,
    input   ws,         // word select
    input   sck,        // serial clock
    input   sd,         // data

    output  reg [15:0]  dout,
    output  reg         dout_vld,
    input               dout_rdy
);

// -----------------------------------------------------------------------------
// synchronize ws and sck, sd quasi-static
reg     [1:0]   sync_ws, sync_sck;

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
    begin
        sync_ws     <= 0;
        sync_sck    <= 0;
    end
    else
    begin
        sync_ws     <= { sync_ws[0], ws };
        sync_sck    <= { sync_sck[0], sck };
    end

wire    synced_ws   = sync_ws[1];
wire    synced_sck  = sync_sck[1];

// -----------------------------------------------------------------------------
// rising edge detector of sck
reg     prev_synced_sck;

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        prev_synced_sck <= 0;
    else
        prev_synced_sck <= synced_sck;
        
wire    rise_sck    = ( synced_sck & ~prev_synced_sck );

// -----------------------------------------------------------------------------
// rising edge detector of ws ( use right channel )
reg     prev_synced_ws;

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        prev_synced_ws <= 0;
    else
        prev_synced_ws <= synced_ws;
        
wire    rise_ws    = ( synced_ws & ~prev_synced_ws );


// -----------------------------------------------------------------------------
// count sck rising edges
reg     [5:0]   cnt;        // count 0~63, don't care about cnt > 17

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        cnt     <= 0;
    else
    begin
        if ( rise_ws )
            cnt     <= 0;
        else if ( rise_sck )
            cnt     <= cnt + 1;
    end

// -----------------------------------------------------------------------------
// store 16 bits sent serially
always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        dout    <= 0;
    else
    begin
        if ( rise_sck & (cnt >= 1) & (cnt <= 16) )
            dout    <= { dout[14:0], sd };
    end

// -----------------------------------------------------------------------------
// handshake
always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        dout_vld    <= 0;
    else if ( dout_vld & dout_rdy )
        dout_vld    <= 0;
    else if ( ws & rise_sck & (cnt == 17) )
        dout_vld    <= 1;


endmodule
