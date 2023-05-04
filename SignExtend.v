module SignExtend(out, in);

output reg [31:0] out;
input [15:0] in;

always@(*) begin
  if(in[15] == 1'b1) begin
    out = {16'hFFFF, in};
  end
  else begin
    out = {16'b0, in};
  end
end


endmodule
