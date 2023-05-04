module Comparator(out, a, b);

output reg out;
input [31:0] a, b;

always@(*) begin
  if(a == b) begin
    out = 1'b1;
  end
  else begin
    out = 1'b0;
  end
end

endmodule
