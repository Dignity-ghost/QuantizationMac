module tb_mul();

reg     [11: 0]     a, b;
wire    [23: 0]     r;

mul mul(
    .a  (   a   ),
    .b  (   b   ),
    .r  (   r   )
);

initial begin
    a = 12'hFFF;
    b = 12'hFFF;

end






endmodule