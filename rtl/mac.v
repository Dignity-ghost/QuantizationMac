module mac(
    clk, rst_n,
    fp_sel,
    op1, op2, ops,
    result_int8,
    result_fp16

);

input               clk, rst_n;
input               fp_sel;
input   [15: 0]     op1, op2, ops;

output  [ 7: 0]     result_int8;
output  [15: 0]     result_fp16;


reg     [15: 0]     ops_1, ops_2;
always @(posedge clk or negedge rst_n) begin
if (~rst_n) begin
    ops_1 <= 16'h0;
    ops_2 <= 16'h0;
end else begin
    ops_1 <= ops;
    ops_2 <= ops_1;
end
end


wire    [15: 0]     man;
wire    [ 3: 0]     exp;
wire                sgn;

mul mul(
    .clk(clk), 
    .rst_n(rst_n),
    .fp_sel(fp_sel),
    .op1(op1), 
    .op2(op2),
    .man(man),
    .exp(exp),
    .sgn(sgn)
);

acc_int acc_int(
    .clk(clk), 
    .rst_n(rst_n),
    .r_mul({sgm,man[14:7]}),
    .ops_2(ops_2[7:0]),
    .result(result_int8)
);

acc_fp acc_fp(
   .clk(clk), 
   .rst_n(rst_n),
   .ops(ops_2),
   .mul_man(man), 
   .mul_exp(exp), 
   .mul_sgn(sgn),
   .result(result_fp16)
);

endmodule