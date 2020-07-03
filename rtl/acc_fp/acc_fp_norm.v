module acc_fp_norm (
   // Outputs
   norm_result,

   // Inputs
   align_sgn,
   align_exp,
   align_man
);




input    [ 1: 0]     align_sgn;
input    [ 3: 0]     align_exp;
input    [16: 0]     align_man;

output   [15: 0]     norm_result;




wire     [15: 0]     result_man_abosolute = align_man[16] ? -align_man[15:0] : align_man[15:0];

// leading-zero detect
integer                       i;
reg signed [ 3: 0]    result_man_norm_shift;
always @ * begin
   result_man_norm_shift = 0;
   for (i = 0; i < 16; i = i + 1) begin
      if (result_man_abosolute[i])
         result_man_norm_shift = 4'hf-i;
   end
end

wire     [11: 0]     result_man = (result_man_abosolute << result_man_norm_shift) >> 4;
wire     [ 3: 0]     result_exp = align_exp - result_man_norm_shift;

wire                 result_sgn_clamped = !(|result_man_abosolute) && align_sgn[1] ? 1'b0 : align_sgn[0] ^ align_man[16];
wire     [ 3: 0]     result_exp_clamped = !result_man[11] ? 0 : result_exp;
wire     [10: 0]     result_man_clamped = result_man[10:0];

assign               norm_result = {result_sgn_clamped, result_exp_clamped, result_man_clamped};

endmodule
