// Class for random bit generation

class myRand;
    rand    bit     [23:0]  rand_num;
    
    function new();
    endfunction

endclass

// -----------------------------------------------------------------------------
module i2s_rx_tb
(
);


// -----------------------------------------------------------------------------
// DUT connections


logic   clk;        // internal clock
logic   rst_n;
logic   ws;         // word select
logic   sck;        // serial clock
logic   sd;         // data
wire    [ 15 : 0 ]  dout;
wire                dout_vld;
logic               dout_rdy;

//------------------------------------------------------------------------------
// instantiate dut
i2s_rx DUT (
    .clk        ( clk       ),
    .rst_n      ( rst_n     ),
    .ws         ( ws        ),
    .sck        ( sck       ),
    .sd         ( sd        ),
    .dout       ( dout      ),
    .dout_vld   ( dout_vld  ),
    .dout_rdy   ( dout_rdy  )
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
// drive sck
initial
begin
    sck = 1;

    forever
    begin
        #165 sck  = ~sck;
    end
end

//------------------------------------------------------------------------------
// create queue of samples
bit [23:0] data_queue[$];
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

    $display( " START  SIMULATION" );
    rst_n       = 0;
    dout_rdy    = 0;
    ws          = 0;
    repeat( 2 )     @( negedge clk );
    rst_n       = 1;
    dout_rdy    = 1;      //TODO

    while ( data_queue.size() )
    begin
        repeat( 32 )    @( negedge sck );
        ws  = ~ws;      // right channel
        for ( int idx = 23; idx >= 0; idx-- )
        begin
            if ( idx == 8 )
            begin
                scoreboard_queue.push_back( data_queue[0][23:8] );
                $display( "Pushed to scoreboard_queue at time %t", $time );
            end

            @( negedge sck );
            sd  = data_queue[0][idx];
        end
        
        //scoreboard_queue.push_back( data_queue[0][23:8] );
        //$display( "Pushed to scoreboard_queue at time %t", $time );
        data_queue.pop_front();
    
        //dout_rdy    = 1;    //testing

        repeat( 8 )     @( negedge sck );
        //dout_rdy    = 0;    //testing
        ws  = ~ws;      // left channel
    end
    
    $display( "END OF SIMULATION" );
    $finish;
end


//------------------------------------------------------------------------------
// Scoreboarding

always @( posedge clk )
    if ( dout_vld & dout_rdy )
    begin
        assert( scoreboard_queue.size() )
        else
        begin
            $display( "ERROR at time %t: scoreboard_queue empty", $time );
            $finish;
        end

        assert( scoreboard_queue[0] == dout )
            $display( "PASS" );
        else
        begin
            $display( "ERROR at time %t: mismatch", $time );
            $display( "Expected: %b", scoreboard_queue[0] );
            $display( "Hardware: %b", dout );
        end

        scoreboard_queue.pop_front();
        $display( "Popped from scoreboard_queue at time %t", $time );
    end

//------------------------------------------------------------------------------




endmodule
