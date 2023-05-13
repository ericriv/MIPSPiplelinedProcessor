module MUX3to1(out, a, b, c, op);

parameter n = 32;

output reg [n-1:0] out;
input [n-1:0] a, b, c;
input [1:0] op;

always@(*) begin
  case(op)
    0: out <= a;
    1: out <= b;
    2: out <= c;
    default: out <= out;
  endcase
end

endmodule
