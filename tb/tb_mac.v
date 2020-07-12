module tb_mac();


// port **********************************************************
reg     [ 3: 0]     mode;
reg     [15: 0]     value, weight;
reg     [23: 0]     ints;   // int8 bias in
reg     [30: 0]     fps;    // fp16 bias in
wire    [23: 0]     intr;   // int8 result
wire    [30: 0]     fpr;    // fp16 bias out

// parameter *****************************************************
parameter                   mode_fp     = 0;
parameter                   mode_int_s  = 1;
parameter                   mode_int_m  = 2;
parameter                   mode_int_l  = 3;
parameter                   exp_zero    = 5'h0c;


mac mac(
    .mode(mode),
    .value(value),
    .weight(weight),
    .ints(ints),
    .fps(fps),
    .intr(intr),
    .fpr(fpr)
);

initial begin
    mode    =   1'b1 << mode_int_s;
    value   =   16'he678;
    weight  =   16'h6789;
    ints    =   24'h12345678;
    fps     =   { 5'h19, 13'h0c56 };
    #1
    mode    =   1'b1 << mode_int_m;
    #1
    mode    =   1'b1 << mode_int_l;
    #1
    mode    =   1'b1 << mode_fp;

end

endmodule