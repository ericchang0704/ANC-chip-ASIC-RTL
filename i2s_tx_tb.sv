// Class for random bit generation

class myRand;
    rand    bit     [15:0]  rand_num;
    
    function new();
    endfunction

endclass

// -----------------------------------------------------------------------------
module i2s_tx_tb
(
);

localparam  PERIOD  = 20;

logic   clk;        // internal clock
logic   rst_n;
logic   [7:0]   bclk_period;        // half period counted by clk

logic           sample_vld;
logic   [15:0]  sample;

wire            lr_clk;
wire            bclk;
wire            dout;

assign bclk_period  = PERIOD;       // configurable

//------------------------------------------------------------------------------
// instantiate dut
i2s_tx DUT (
    .clk            ( clk           ),
    .rst_n          ( rst_n         ),
    .bclk_period    ( bclk_period   ),
    .sample_vld     ( sample_vld    ),
    .sample         ( sample        ),
    .lr_clk         ( lr_clk        ),
    .bclk           ( bclk          ),
    .dout           ( dout          )
);

// -----------------------------------------------------------------------------
// drive clk
initial
begin
    clk = 1;

    forever
    begin
        #5 clk  = ~clk;
    end
end

//------------------------------------------------------------------------------
// create queue of samples
bit [15:0] data_queue[$];
bit [15:0] scoreboard_queue[$];

localparam  SAMPLES = 10000;

initial
begin
    myRand  my_data;
    my_data = new();
    for ( int i = 0; i < SAMPLES; i++ )
    begin
        my_data.randomize();
        data_queue.push_back(my_data.rand_num);
    end
end

//------------------------------------------------------------------------------
// Drive DUT 

initial
begin
    $display( "START  SIMULATION" );
    rst_n       = 0;
    sample_vld  = 0;
    sample      = 0;
    repeat( 2 )     @( negedge clk );
    rst_n       = 1;

    while ( data_queue.size() )
    begin
        repeat ( (PERIOD * 64) - 1)      @( negedge clk );
        sample_vld  = 1;
        sample  = data_queue[0];
        @( negedge clk );
        sample_vld  = 0;
        scoreboard_queue.push_back( data_queue.pop_front() );
    end

    repeat( PERIOD * 66 )   @( negedge clk );

    assert( scoreboard_queue.size() == 0 )
    else
    begin
        $display( "ERROR: Data not fully driven out" );
    end
    $display( "END OF SIMULATION" );
    $finish;
end

//------------------------------------------------------------------------------
// Scoreboarding
reg     [4:0]  bclk_cnt;


always @( posedge bclk or negedge rst_n )
    if ( ~rst_n )
        bclk_cnt    <= 0;
    else
        bclk_cnt    <= ( bclk_cnt == 16 ) ? 0 : ( bclk_cnt + lr_clk );



always @( posedge bclk )
    if ( bclk_cnt > 0 )
    begin
        assert( scoreboard_queue[0][16 - bclk_cnt] == dout )
        else
        begin
            $display( "ERROR at time %t: mismatch", $time );
            $display( "Expected: %b", scoreboard_queue[0][16 - bclk_cnt] );
            $display( "Hardware: %b", dout );
            $finish;
        end

        if ( bclk_cnt == 16 )
            scoreboard_queue.pop_front();
    end

endmodule
