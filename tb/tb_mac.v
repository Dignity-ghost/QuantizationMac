module tb_mac(

);

reg                 clk;
reg                 rst_n;
reg                 fp_sel;
reg     [15: 0]     op1;
reg     [15: 0]     op2;
reg     [15: 0]     ops;
wire    [ 7: 0]     result_int8;
wire    [15: 0]     result_fp16;




initial begin
    clk     =  1'b0;
    rst_n   =  1'b0;
    fp_sel  =  1'b0;
    #1
    op1     = 16'h0;
    op2     = 16'h0;
    ops     = 16'h0;
    #10
    rst_n   = 1'b1;
    op1 = 16'h20;
    op2 = 16'h20;
    ops = 16'h20;
    #5
    op1 = 16'h22;
    op2 = 16'h24;
    ops = 16'h26;
    #10
    op1 = 16'h34;
    op2 = 16'h55;
    ops = 16'h74;
end

always #5 clk = ~clk;


mac mac(
    .clk(clk), 
    .rst_n(rst_n),
    .fp_sel(fp_sel),
    .op1(op1), 
    .op2(op2), 
    .ops(ops),
    .result_int8(result_int8),
    .result_fp16(result_fp16)
);


endmodule