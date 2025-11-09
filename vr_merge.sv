/*
 * valid/ready merge
 * Merges multiple (N) input nodes into a single output node
 *
 *
*/
module vr_merge

#(
    parameter   MERGE_N     = 8
)
(
    input   [ MERGE_N - 1 : 0 ]     i_en,

    // upstream interface
    input   [ MERGE_N - 1 : 0 ]     i_valid,
    output  [ MERGE_N - 1 : 0 ]     o_ready,

    // downstream interface
    output                          o_valid,
    input                           i_ready
);

wire    deal    = o_valid & i_ready;

assign  o_valid = &( i_valid | ~i_en ) & |i_en;     // &( i_valid bitwise-or not enabled ) and (at least one enabled)
assign  o_ready = { MERGE_N{ deal } } & i_en;

endmodule

