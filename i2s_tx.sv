/* 
 * i2s transmitter
 * Outputs a 16-bit data serially to MAX98357A
 *
 * Notes:
 * clk freq (~100MHz) >> sck freq (~3MHz)
 * only uses right channel of ICS-43432
 * simple valid/ready handshaking
 * 
 * 
*/
module i2s_tx
(
    input   clk,        // internal clock
    input   rst_n,
    input   [7:0]   bclk_period,        // half period counted by clk

    input           sample_vld,
    input   [15:0]  sample,

    output  reg     lr_clk,
    output  reg     bclk,
    output  reg     dout

);

// -----------------------------------------------------------------------------
// Make sure first sample does not come in the middle of right channel

reg     start_n;

always @( posedge clk )
    if ( ~rst_n )
        start_n <= 1;
    else if ( fifo_rd_vld & start_n )
        start_n <= 0;

// -----------------------------------------------------------------------------
// FIFO in case new sample arrives before previous sample is fully sent out
wire            fifo_rd_vld;
logic           fifo_rd_rdy;

wire    [15:0]  fifo_dout;

vr_fifo #(
    .D_WIDTH    ( 16    ),
    .D_DEPTH    ( 4     )
) input_fifo (
    .clk        ( clk           ),
    .rst_n      ( rst_n         ),
    .wr_vld     ( sample_vld    ),
    .wr_rdy     (               ),
    .wr_data    ( sample        ),
    .rd_vld     ( fifo_rd_vld   ),
    .rd_rdy     ( fifo_rd_rdy   ),
    .rd_data    ( fifo_dout     ),
    .cnt        (               )   // not needed
);


// -----------------------------------------------------------------------------
// clock counters

// ccnt counts from 0 ~ (bclk_period - 1)
// bcnt counts from 0 ~ 63

logic   [7:0]   ccnt;
logic   [5:0]   bcnt;

wire            bcnt_inc    = ((ccnt + 1) == bclk_period);

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
    begin
        ccnt    <= 0;
        bcnt    <= 0;
    end
    else if ( ~start_n )
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

wire    [3:0]   bcnt_idx;
assign  {lr_clk, bcnt_idx, bclk}    = bcnt;

wire            bclk_fall   = bcnt_inc &  bcnt[0];

// -----------------------------------------------------------------------------
// updating dout

always @( posedge clk or negedge rst_n )
    if ( ~rst_n )
    begin
        dout        <= 0;
        fifo_rd_rdy <= 0;
    end
    else if ( bclk_fall )
    begin
        dout    <= fifo_dout[ 15 - bcnt_idx ];     // (15 - x) is like x's one's complement so fifo_data[ ~bcnt[4:1] ] also works but less readable
        fifo_rd_rdy <= (bcnt == 63);
    end
    else
    begin
     // dout        <= dout;
        fifo_rd_rdy <= 0;
    end

endmodule
