module ALU(out, flag_zero, a, b, op);

output reg [31:0] out;
output reg flag_zero;
input [31:0] a, b;
input [3:0] op;

always@(*) begin
  case(op)
    0: out <= a & b;
    1: out <= a | b;
    2: out <= a + b;
    3: out <= 32'hFFFFFFFF;
    4: out <= 32'h0;
    5: out <= a * b;
    6: out <= a - b;
    7: begin 
         if(a < b)
           out <= 32'b1;
       end
    8: out <= a / b;
   12: out <= ~(a | b);
    default: out <= 32'b0;
  endcase

  if(out == 0)
    flag_zero <= 1'b1;
  else
    flag_zero <= 1'b0;

end


endmodule
