module ALUControl(ALUop, Funct, Out);

input [1:0] ALUop;
input [5:0] Funct;
output reg [3:0] Out;

always@(*) begin
  case(ALUop)
    0: Out <= 4'h2;
    1: Out <= 4'h6;
    2: begin
         case(Funct)
           32: Out <= 4'h2;
           34: Out <= 4'h6;
           36: Out <= 4'h0;
           37: Out <= 4'h1;
           42: Out <= 4'h7;
           default: Out <= Out;
         endcase
       end
    default: Out <= Out;
  endcase
end

endmodule
