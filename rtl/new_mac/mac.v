module mac(
    //clk, rst_n, 
	mode,
    value, weight,
    ints, fps,
    intr, fpr, fpr_norm
);

// port **********************************************************
// input   wire                clk, rst_n;
input   wire    [ 1: 0]     mode;
input   wire    [15: 0]     value, weight;
input   wire    [23: 0]     ints;
input   wire    [30: 0]     fps;
output  wire    [23: 0]     intr;
output  wire    [30: 0]     fpr;
output  wire    [15: 0]     fpr_norm;

// parameter *****************************************************
parameter                   mode_fp     = 2'b00;
parameter                   mode_int_s  = 2'b01;
parameter                   mode_int_m  = 2'b10;
parameter                   mode_int_l  = 2'b11;
parameter                   exp_zero    = 5'h0c;

// logic *********************************************************
wire    signed      [12: 0]     mul_weight  =   ( weight == 16'h0       ) ? {          13'h0                                } :
                                                ( mode == mode_fp       ) ? {     weight[15],    ~weight[15], weight[10:0]  } :
                                                ( mode == mode_int_s    ) ? { {4{weight[7]}},   weight[ 7:0]                } :
                                                                            { {2{weight[7]}},   weight[ 7:0], 2'b0          } ;
wire    unsigned    [12: 0]     mul_value   =   ( value  == 16'h0       ) ? {          13'h0                                } :
                                                ( mode == mode_fp       ) ? {           1'b1,    value[11:0]                } :
                                                ( mode == mode_int_l    ) ? {           3'b0,    value[ 7:0], 2'b0          } :
                                                                            {           5'b0,    value[ 7:0]                } ;
wire    signed      [25: 0]     mul_result  =   mul_value * mul_weight ;

wire    signed      [ 3: 0]     exp_weight  =   ( mode == mode_fp ) ? weight[14:11] : 4'h0;
wire    signed      [ 3: 0]     exp_value   =   ( mode == mode_fp ) ? value[15:12]  : 4'h0;
wire    signed      [ 4: 0]     exp_mul_result = exp_value + exp_weight - exp_zero;
wire    signed      [ 4: 0]     fps_exp     =   fps[30:26];
wire    signed      [25: 0]     fps_man     =   fps[25:0];

assign                          intr        =   ints + mul_result[23:0];

wire    signed      [ 4: 0]     shift       =   exp_mul_result - fps_exp;
wire                            mul_lt_fps  =   ~shift[4];
wire    signed      [25: 0]     acc_mul     =   mul_result  >>> ( ~mul_lt_fps ? -shift : 0 );
wire    signed      [25: 0]     acc_fps     =   fps_man     >>> (  mul_lt_fps ?  shift : 0 );
wire    signed      [25: 0]     acc_fp_m    =   acc_mul + acc_fps ;

integer                         i;
reg     signed      [ 4: 0]     fpr_m_norm_shift;
always @* begin
    fpr_m_norm_shift = 0;
    for (i = 0; i < 25; i = i + 1) begin
        if (acc_fp_m[i] ^ acc_fp_m[25])
            fpr_m_norm_shift = 5'd24-i;
   end
end

wire    signed      [25: 0]     fpr_m       = acc_fp_m << fpr_m_norm_shift;
wire    unsigned    [ 4: 0]     fpr_e       = ( mul_lt_fps ? exp_mul_result : fps_exp ) - fpr_m_norm_shift;

assign                          fpr         =   { fpr_e, fpr_m };
assign                          fpr_norm    =   fpr_m[25] ? 16'h0 : { fpr_e[3:0], fpr_m[24] } ;




endmodule 