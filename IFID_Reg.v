module IFID_Reg(INSTRout, PCin, PCout, INSTRin, clk, rst);

output [31:0] INSTRout, PCout;
input [31:0] INSTRin, PCin;
input clk, rst;
	
reg [63:0] state;
	
always @(posedge clk) begin
  if (rst == 1'b1)begin
    state <= 0;
  end
  else begin
    state <= {INSTRin, PCin};
  end
		
end //always
	assign {INSTRout, PCout} = state;

endmodule
