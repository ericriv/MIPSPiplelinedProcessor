module EXMEM_Reg(WBout, Mout, ALUout, WDout, Rdout, WBin, Min, ALUin, WDin, Rdin, clk, rst);

output [31:0] ALUout, WDout;
output [4:0] Rdout;
output [1:0] WBout;
output [1:0] Mout;
input [31:0] ALUin, WDin;
input [4:0] Rdin;
input [1:0] WBin; 
input [1:0] Min;
input clk, rst;
	
reg [72:0] state;
	
always @(posedge clk) begin
  if (rst == 1'b1)begin
    state <= 0;
  end
  else begin
    state <= {WBin, Min, ALUin, WDin, Rdin};
  end
		
end //always

assign {WBout, Mout, ALUout, WDout, Rdout} = state;

endmodule
