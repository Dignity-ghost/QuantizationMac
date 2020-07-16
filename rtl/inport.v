module inport(int8,ints,inport_mode);

input       [ 7: 0]     int8;
input       [ 2: 0]     inport_mode;
output reg  [27: 0]     ints;

always @* begin
    case (inport_mode)
    3'h1: ints = { 19'h0, int8, 1'h0 };
    3'h2: ints = { 18'h0, int8, 2'h0 };
    3'h3: ints = { 17'h0, int8, 3'h0 };
    3'h4: ints = { 16'h0, int8, 4'h0 };
    3'h5: ints = { 15'h0, int8, 5'h0 };
    default: ints = { 14'h0, int8, 6'h0 };
    endcase
end

endmodule