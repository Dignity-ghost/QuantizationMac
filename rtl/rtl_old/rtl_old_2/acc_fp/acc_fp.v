module acc_fp(
   clk, rst_n,
   ops,
   mul_man, mul_exp, mul_sgn,
   result
);

input                clk, rst_n;

input    [15: 0]     ops;
input                mul_sgn;
input    [ 3: 0]     mul_exp;
input    [15: 0]     mul_man;

output   [15: 0]     result;

wire     [ 1: 0]     align_sgn;
wire     [ 3: 0]     align_exp;
wire     [15: 0]     align_man0;
wire     [15: 0]     align_man1;

acc_fp_align acc_fp_align (
   .ops(ops),
   .mul_sgn(mul_sgn),
   .mul_exp(mul_exp), 
   .mul_man(mul_man), 
   .align_sgn(align_sgn),
   .align_exp(align_exp),
   .align_man0(align_man0),
   .align_man1(align_man1)
);

reg      [ 1: 0]     q0_align_sgn;
reg      [ 3: 0]     q0_align_exp;
reg      [16: 0]     q0_align_man0;
reg      [16: 0]     q0_align_man1;

always @ ( posedge clk or negedge rst_n ) begin
   if ( ~rst_n ) begin
   q0_align_sgn      <= 'h0;
   q0_align_exp      <= 'h0;
   q0_align_man0     <= 'h0;
   q0_align_man1     <= 'h0;
   end else begin
   q0_align_sgn      <= align_sgn;
   q0_align_exp      <= align_exp;
   q0_align_man0     <= align_man0;
   q0_align_man1     <= align_man1;
   end
end

wire     [16: 0]     q0_align_man = q0_align_man0 + q0_align_man1;

reg      [ 1: 0]     q1_align_sgn;
reg      [ 3: 0]     q1_align_exp;
reg      [13: 0]     q1_align_man;


always @ ( posedge clk or negedge rst_n ) begin
   if ( ~rst_n ) begin
   q1_align_sgn               <= 'h0;
   q1_align_exp               <= 'h0;
   q1_align_man               <= 'h0;
   end else begin
   q1_align_sgn               <= q0_align_sgn;
   q1_align_exp               <= q0_align_exp;
   q1_align_man               <= q0_align_man;
   end
end

acc_fp_norm acc_fp_norm (
   .align_sgn(q1_align_sgn),
   .align_exp(q1_align_exp),
   .align_man(q1_align_man),
   .norm_result(result)
);

endmodule
