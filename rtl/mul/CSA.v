module CSA(x,y,z,s,c);

input   x, y, z;
output  s, c;

assign  c = ( x & y ) | ( x & z ) | ( y & z );
assign  s = x ^ y ^ z;

endmodule 