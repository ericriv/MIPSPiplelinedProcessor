module IFID_Reg(INSTRout, PCin, PCout, INSTRin, write, clk, rst, IFFlush);

output [31:0] INSTRout, PCout;
input [31:0] INSTRin, PCin;
input clk, rst, IFFlush, write;
	
reg [63:0] state;
	
always @(posedge clk) begin
  if (rst == 1'b1)begin
    state <= 0;
  end
  else if (IFFlush == 1'b1)begin
    state <= {32'b0, PCin};
  end
  else begin
    if(write == 1'b1)
      state <= {INSTRin, PCin};
  end
		
end //always
	assign {INSTRout, PCout} = state;

endmodule
