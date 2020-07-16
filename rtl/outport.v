module outport(int8,intr,outport_mode);

input       [27: 0]     intr;
input       [ 2: 0]     outport_mode;
output reg  [ 7: 0]     int8;

always @* begin
    case (outport_mode)
    3'h0: int8 = intr[10:3];
    3'h1: int8 = intr[13:6];
    3'h2: int8 = intr[14:7];
    3'h3: int8 = intr[15:8];
    3'h4: int8 = intr[16:9];
    default: int8 = intr[17:10];
    endcase
end

endmodule