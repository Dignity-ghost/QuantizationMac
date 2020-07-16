module acc_fp_align (
   ops,
   mul_sgn, mul_exp, mul_man,
   align_sgn,
   align_exp,
   align_man0,
   align_man1
);

input    [15: 0]     ops;
input                mul_sgn;
input    [ 3: 0]     mul_exp;
input    [15: 0]     mul_man;

output   [ 1: 0]  align_sgn;
output   [ 3: 0]  align_exp;
output   [16: 0]  align_man0;
output   [16: 0]  align_man1;

wire              src0_sgn = ops[15];
wire     [ 3: 0]  src0_exp = ops[14:11];
wire     [12: 0]  src0_man = { 1'b0, |ops[14:0], ops[10:0] };

wire              src1_sgn = mul_sgn;
wire     [ 3: 0]  src1_exp = mul_exp;
wire     [16: 0]  src1_man = { 1'b0, mul_man };

wire     [ 4: 0]  src0_shift = src1_exp - src0_exp;
wire     [ 4: 0]  src1_shift = src0_exp - src1_exp;

wire     [ 3: 0]  src0_shift_clamped = src0_shift[4] ? 0 : src0_shift[3:0];
wire     [ 3: 0]  src1_shift_clamped = src1_shift[4] ? 0 : src1_shift[3:0];

wire     [12: 0]  src0_man_2comp = (  src1_shift[4] && (src0_sgn != src1_sgn) ) ? -src0_man : src0_man;
wire     [16: 0]  src1_man_2comp = ( !src1_shift[4] && (src0_sgn != src1_sgn) ) ? -src1_man : src1_man;

wire     [16: 0]  src0_man_shifted = { src0_man_2comp, 4'h0 } >>> src0_shift_clamped;
wire     [16: 0]  src1_man_shifted =   src1_man_2comp         >>> src1_shift_clamped;

assign            align_sgn = {src0_sgn != src1_sgn, src1_shift[4] ? src1_sgn : src0_sgn};
assign            align_exp = src1_shift[4] ? src1_exp : src0_exp;
assign            align_man0 = src0_man_shifted;
assign            align_man1 = src1_man_shifted;

endmodule
