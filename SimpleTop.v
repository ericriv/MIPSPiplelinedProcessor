`timescale 1ns/1ps

module SimpleTop(clk, reset);

//inputs//
input clk, reset;

//IF wire declarations//
wire [31:0] PCout, PCin, NextPC, Instr, BMUXout, JMUXout;
wire HPCwrite;

//IFID wire declarations//
wire [31:0] IFID_Instr, IFID_PCout;
wire IFIDWrite;

//ID wire declarations//
wire [31:0] SEout, BS2out, JS2out, BPCout, R1out, R2out;
wire [1:0] ID_WB, ID_M;
wire [3:0] ID_EX;
wire [7:0] IDEXMUXout;
wire IFFlush, Jump, Branch, CPCWrite, Compout, nop;

//EX wire Declarations//
wire [31:0] EX_R1out, EX_R2out, EX_SE, op1MUXout, op2MUXout, ALUSrcMUXout, ALUout;
wire [1:0] EX_WB, EX_M;
wire [3:0] EX_EX, ALUC;
wire [4:0] EX_Rt, EX_Rd, EX_Rs, RegDestMUXout;
wire [1:0] ForwardA, ForwardB;
wire fz;

//MEM wire Declarations
wire [31:0] MEM_ALU, MEM_WD, DMout, WBMUXout;
wire [1:0] MEM_WB, MEM_M;
wire [4:0] MEM_Rd;

//WB wire Declarations
wire [31:0] WB_ALU, WB_DM;
wire [1:0] WB_WB;
wire [4:0] WB_Rd;


//instantiations//

//IF stage start//
MUX2to1 BMUX(.out(BMUXout), .a(NextPC), .b(BPCout), .op(Branch)); 
MUX2to1 JMUX(.out(JMUXout), .a(BMUXout), .b({NextPC[31:28],JS2out[27:0]}), .op(Jump)); 
PCReg PC(.out(PCout), .in(JMUXout), .clk, .reset, .write(HPCwrite));
Add32 PCPlus4(.sum(NextPC), .a(PCout), .b(32'h4));
InstructionMem IM(.out(Instr), .address(PCout));
//IF stage end//

IFID_Reg IFIDR(.INSTRout(IFID_Instr), .PCin(NextPC), .PCout(IFID_PCout), .INSTRin(Instr), .write(IFIDWrite), .clk, .rst(reset), .IFFlush);
													     
//ID stage start//
Control Cntrl(.WB(ID_WB), .M(ID_M), .EX(ID_EX), .Jump, .Branch, .Instruction(IFID_Instr[31:26]));
RegFile RF(.clk, .in(WBMUXout), .R1addr(IFID_Instr[25:21]), .R2addr(IFID_Instr[20:16]), .WRaddr(WB_Rd), .RegWrite(WB_WB[1]), .R1out, .R2out); 
Comparator Comp(.out(Compout), .a(R1out), .b(R2out));  
HazardUnit HazU(.IDEXMemRead(EX_M[1]), .EXMEMMemRead(MEM_M[1]), .EXMEMMemToReg(MEM_WB[0]), .IDEXRt(EX_Rt), .EXMEMRt(MEM_Rd),
           .IFIDRs(IFID_Instr[25:21]), .IFIDRt(IFID_Instr[20:16]), .branch(Branch), .compres(Compout),
	   .jump(Jump), .IFIDWrite, .PCWrite(HPCwrite), .nop, .IFFlush);
MUX2to1 #(.n(8)) IDEXMUX(.out(IDEXMUXout), .a({ID_WB, ID_M, ID_EX}), .b(8'b0), .op(nop));
SignExtend SE(.out(SEout), .in(IFID_Instr[15:0]));
shift2 BS2(.out(BS2out), .in(SEout));
shift2 JS2(.out(JS2out), .in({6'b0,IFID_Instr[25:0]}));
Add32 BPC(.sum(BPCout), .a(IFID_PCout), .b(BS2out));
//ID stage end//

IDEX_Reg IDEXR(.WBin(IDEXMUXout[7:6]),  .Min(IDEXMUXout[5:4]),  .EXin(IDEXMUXout[3:0]), .R1DATin(R1out), .R2DATin(R2out), 
		.SEin(SEout), .Rtin(IFID_Instr[20:16]), .Rdin(IFID_Instr[15:11]), .Rsin(IFID_Instr[25:21]), 
		.WBout(EX_WB), .Mout(EX_M), .EXout(EX_EX), .R1DATout(EX_R1out), .R2DATout(EX_R2out), .SEout(EX_SE),
		.Rtout(EX_Rt), .Rdout(EX_Rd), .Rsout(EX_Rs), .clk, .rst(reset));

//EX stage start//
MUX3to1 op1(.out(op1MUXout), .a(EX_R1out), .b(WBMUXout), .c(MEM_ALU), .op(ForwardA)); 
MUX3to1 op2(.out(op2MUXout), .a(EX_R2out), .b(WBMUXout), .c(MEM_ALU), .op(ForwardB));
 
MUX2to1 ALUSrcMUX(.out(ALUSrcMUXout), .a(op2MUXout), .b(EX_SE), .op(EX_EX[0]));
ALUControl ALUcont(.ALUop(EX_EX[2:1]), .Funct(EX_SE[5:0]), .Out(ALUC));

ALU alu(.out(ALUout), .flag_zero(fz), .a(op1MUXout), .b(ALUSrcMUXout), .op(ALUC));
ForwardingUnit FU(.IDEXRs(EX_Rs), .IDEXRt(EX_Rt), .EXMEMRegWrite(MEM_WB[1]), .EXMEMRd(MEM_Rd), .MEMWBRd(WB_Rd), .MEMWBRegWrite(WB_WB[1]), .ForwardA, .ForwardB);
MUX2to1 #(.n(5)) RegDestMUX(.out(RegDestMUXout), .a(EX_Rt), .b(EX_Rd), .op(EX_EX[3]));
//EX stage end//

EXMEM_Reg EXMEMR(.WBout(MEM_WB), .Mout(MEM_M), .ALUout(MEM_ALU), .WDout(MEM_WD), .Rdout(MEM_Rd), .WBin(EX_WB), .Min(EX_M), .ALUin(ALUout), .WDin(op2MUXout), .Rdin(RegDestMUXout), .clk, .rst(reset));

//MEM stage start//
DataMem DM(.out(DMout), .in(MEM_WD), .address(MEM_ALU), .write(MEM_M[0]), .clk);
//MEM stage end//

MEMWB_Reg MEMWBR(.WBout(WB_WB), .ADDout(WB_ALU), .DMout(WB_DM), .Rdout(WB_Rd), .WBin(MEM_WB), .ADDin(MEM_ALU), .DMin(DMout), .Rdin(MEM_Rd), .clk, .rst(reset));

//WB stage start//
MUX2to1 WBMUX(.out(WBMUXout), .a(WB_ALU), .b(WB_DM), .op(WB_WB[0]));
//WB stage end//



endmodule
