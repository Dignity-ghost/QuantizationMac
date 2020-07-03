module mul_exp(
    // Inputs
    clk, rst_n,
    exp1, exp2,
    // Outputs
    result
);

input               clk, rst_n;
input   [ 3: 0]     exp1, exp2;
output  [ 3: 0]     result;

reg     [ 3: 0]     exp_1;
reg     [ 3: 0]     exp_2;

always @(posedge clk or negedge rst_n)
if (~rst_n)     exp_1 <= 4'h0;
else            exp_1 <= exp1 + exp2;

always @(posedge clk or negedge rst_n)
if (~rst_n)     exp_2 <= 4'h0;
else            exp_2 <= { exp_1[1:0], exp_1[3:2] + 1'b1 };

assign result = exp_2;

endmodule