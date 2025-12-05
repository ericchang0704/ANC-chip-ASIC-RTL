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
    input   [7:0]       sck_period,        // half period counted by clk
    output  sck,        // serial clock
    output  ws,         // word select
    input   sd,         // data

    output  reg [15:0]  dout,
    output  reg         dout_vld,
    input               dout_rdy
);

// -----------------------------------------------------------------------------
// clock counters

// ccnt counts from 0 ~ (sck_period - 1)
// bcnt counts from 0 ~ 127

logic   [7:0]   ccnt;
logic   [6:0]   bcnt;

wire            bcnt_inc    = ((ccnt + 1) == sck_period);

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
    begin
        ccnt    <= 0;
        bcnt    <= 0;
    end
    else
    begin
        if ( bcnt_inc )
        begin
            ccnt    <= 0;
            bcnt    <= bcnt + 1;
        end
        else
        begin
            ccnt    <= ccnt + 1;
         // bcnt    <= bcnt;
        end
    end

wire    [4:0]   UNUSED_bcnt_idx;
assign  {ws, UNUSED_bcnt_idx, sck} = bcnt;

wire            rise_sck    = bcnt_inc & ~bcnt[0];


// -----------------------------------------------------------------------------
// store 16 bits sent serially
always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        dout    <= 0;
    else
    begin
        if ( rise_sck & (bcnt >= 66) & (bcnt <= 96) )
            dout    <= { dout[14:0], sd };
    end

// -----------------------------------------------------------------------------
// handshake
always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
        dout_vld    <= 0;
    else if ( dout_vld & dout_rdy )
        dout_vld    <= 0;
    else if ( ws & rise_sck & (bcnt == 98) )
        dout_vld    <= 1;


endmodule
