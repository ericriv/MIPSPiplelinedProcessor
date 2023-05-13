module ALUControl(ALUop, Funct, Out);

input [1:0] ALUop;
input [5:0] Funct;
output reg [3:0] Out;

always@(*) begin
  case(ALUop)
    0: Out <= 4'h2; //add
    1: Out <= 4'h6; //subtract
    2: begin
         case(Funct)
           6'h20: Out <= 4'h2; //add
           6'h22: Out <= 4'h6; //subtract
           6'h24: Out <= 4'h0; //and
           6'h25: Out <= 4'h1; //or
           6'h2a: Out <= 4'h7; //slt
           6'h27: Out <= 4'hc; //nor
           6'h10: Out <= 4'h3; //mfhi
           6'h12: Out <= 4'h4; //mflo
           6'h18: Out <= 4'h5; //mult
           6'h1a: Out <= 4'h8; //div
           default: Out <= Out;
         endcase
       end
    default: Out <= Out;
  endcase
end

endmodule

//need the mflo and mfhi