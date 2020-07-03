module mul(
    clk, rst_n,
    fp_sel,
    op1, op2,
    man, exp, sgn
);

input               clk, rst_n;
input               fp_sel;
input   [15: 0]     op1, op2;
output  [15: 0]     man;
output  [ 3: 0]     exp;
output              sgn;


mul_man_ctrl mul_man_ctrl(
    .clk(clk), 
    .rst_n(rst_n),
    .op1( fp_sel ? { |op1[14:0], op1[10:0] } : { op1[6:0], 5'h0 } ), 
    .op2( fp_sel ? { |op2[14:0], op2[10:0] } : { op2[6:0], 5'h0 } ),
    .result(man)
);

mul_exp mul_exp(
    .clk(clk), 
    .rst_n(rst_n),
    .exp1( fp_sel ? op1[14:11] : 4'h0 ),
    .exp2( fp_sel ? op1[14:11] : 4'h0 ),
    .result(exp)
);

reg                 sgn_1;
reg                 sgn_2;
assign  sgn = sgn_2;
always  @(posedge clk or negedge rst_n)
if (~rst_n) begin   
    sgn_1 <= 1'b0; 
    sgn_2 <= 1'b0; 
end else begin   
    sgn_1 <= fp_sel ? ( op1[15] ^ op2[15] ) : ( op1[7] ^ op2[7] );
    sgn_2 <= sgn_1; 
end






endmodule