module mul_man_ctrl(
    clk, rst_n,
    op1, op2,
    result
);

input               clk, rst_n;
input   [11: 0]     op1, op2;
output  [15: 0]     result;

wire    [23: 0]     mid_a_1_wire;
wire    [18: 0]     mid_b_1_wire;

//reg     [11: 0]     op1_0, op2_0;
//always @(posedge clk or negedge rst_n)
//if (~rst_n) begin
//    op1_0 <= 12'h000;
//    op2_0 <= 12'h000;
//end else begin
//    op1_0 <= op1;
//    op2_0 <= op2;
//end

mul_man_comp mul_man_comp(
    .op1(op1), 
    .op2(op2),
    .result_a(mid_a_1_wire),
    .result_b(mid_b_1_wire)
);

reg     [23: 0]     mid_a_1;
reg     [18: 0]     mid_b_1;

always @(posedge clk or negedge rst_n)
if (~rst_n) begin
    mid_a_1 <= 23'h0;
    mid_b_1 <= 18'h0;
end else begin
    mid_a_1 <= mid_a_1_wire;
    mid_b_1 <= mid_b_1_wire;
end

reg     [23: 0]     result_2;
wire    [23: 0]     result_2_wire;

assign result_2_wire[ 4: 0] = mid_a_1_wire[ 4:0];
assign result_2_wire[23: 5] = mid_a_1_wire[23:5] + mid_b_1_wire;

always @(posedge clk or negedge rst_n)
if (~rst_n)     result_2 <= 23'h0;
else            result_2 <= result_2_wire;

assign  result = result_2[23:8];


endmodule