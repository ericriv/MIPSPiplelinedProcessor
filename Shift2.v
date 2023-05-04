module shift2(out, in);

output [31:0] out;
input [31:0] in;

assign out = in << 2;


endmodule
