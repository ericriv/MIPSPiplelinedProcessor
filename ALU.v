module ALU(out, flag_zero, a, b, op);

output reg [31:0] out;
output reg flag_zero;
input [31:0] a, b;
input [3:0] op;

reg [31:0] HI, LO;

always@(*) begin
	case(op)
	0: out <= a & b;
	1: out <= a | b;
	2: out <= a + b;
	3: out <= HI;
	4: out <= LO;
	5: 
	begin
	{HI, LO} = a * b;
	out <= LO;
	end
	6: out <= a - b;
	7: 
	begin 
	if(a < b)
		out <= 32'b1;
	end
	8: 
	begin
	LO = a / b;
	HI = a % b;
	out <= LO;
	end
	12: out <= ~(a | b);
	default: out <= 32'b0;
	endcase

	if(out == 0)
		flag_zero <= 1'b1;
	else
		flag_zero <= 1'b0;

end // always


endmodule
