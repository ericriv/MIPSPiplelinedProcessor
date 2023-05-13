`timescale 1ns/1ps

module Add32(sum, a, b);

output [31:0] sum;
input [31:0] a, b;

assign sum = a + b;


endmodule
