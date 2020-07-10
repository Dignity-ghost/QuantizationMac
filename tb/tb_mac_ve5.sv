module tb_mac();


// port **********************************************************
reg     [ 3: 0]     mode;
reg     [15: 0]     value, weight;
reg     [23: 0]     ints;   // int8 bias in
reg     [17: 0]     fps;    // fp16 bias in
wire    [23: 0]     intr;   // int8 result
wire    [17: 0]     fpr;    // fp16 bias out

bit [31: 0] weight_b, value_b, fps_b, fpr_b;

// parameter *****************************************************
parameter                   mode_fp     = 0;
parameter                   mode_int_s  = 1;
parameter                   mode_int_m  = 2;
parameter                   mode_int_l  = 3;
parameter                   exp_zero    = 5'h0c;


mac_ve5 mac(
    .mode(mode),
    .value(value),
    .weight(weight),
    .ints(ints),
    .fps(fps),
    .intr(intr),
    .fpr(fpr)
);

initial begin
    mode    =   'b0001;
    value   =   16'he678; // 5 / 11
    weight  =   16'h6789; // 1 / 4 / 11
    fps     =   { 5'h19, 13'h0c56 };

    // float32 1 / 8 / 23
    weight_b = $shortrealtobits(1.2);
    value_b = $shortrealtobits(1.2);
    fps_b = $shortrealtobits(1.2);
    weight = {weight_b[31], weight_b[30: 27], weight_b[22:12]};
    value  = {               value_b[30: 26],  value_b[22:12]};
    fps    = {                 fps_b[30: 26],    fps_b[22:10]};

    #100;
    fpr_b = $shortrealtobits(1.2*1.2+1.2);

    $display("\n weight : %h", weight);
    $display(" value  : %h", value);
    $display(" fps    : %h", fps);

    $display("\n\n\n");
    $display("  fpr: %f", fpr);
    $display("fpr_b: %f", {fpr_b[30: 26], fpr_b[22:10]});

end

endmodule