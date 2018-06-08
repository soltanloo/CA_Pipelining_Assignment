module dataPath (clk, rst, start);
  input clk, rst, start;
  wire halt, stm, regMemWriteEn, push, pop, pcSel;
  wire[2:0] regMemReadReg2Addr, ID_EX_rsOut, ID_EX_rtOut, ID_EX_rdOut;
  wire[7:0] regMemOutData1, regMemOutData2, regMemInData, ID_EX_brDipsOut, ID_EX_regMemOutData1, ID_EX_regMemOutData2;
  wire[11:0] pcOut, pcIn, pcAdded1Wire, IF_ID_pcPlus1Out, stackOut, ID_EX_pcPlus1Out, signExtOut, pcBranchValue;
  wire[18:0] instMemOut, IF_ID_instOut;

//IF
  mux12bit4to1 PC_IN_MUX_(.in1(pcAdded1Wire), .in2(IF_ID_instOut[11:0]), .in3(stackOut), .in4(pcBranchValue), .sel(pcSel), .out(pcIn));
  pc PC(.clk(clk), .rst(rst), .loadEn(), .in(pcIn), .out(pcOut));
  adder12bit PC_INC_(.in1(12'b000000000001), .in2(pcOut), .out(pcAdded1Wire));
  instructionMemory INST_MEM_(.PC(pcOut), .outInst(instMemOut), .halt(halt));
  IF_ID_Reg IF_ID_(.clk(clk), .rst(rst), .flush, .IF_ID_Wr, .pcPlus1_IN(pcAdded1Wire), .instruction_IN(instMemOut), .pcPlus1_OUT(IF_ID_pcPlus1Out), .instruction_OUT(IF_ID_instOut));
//ID
  mux3bit REG_MEM_ADDR_MUX(.in1(IF_ID_instOut[7:5]), .in2(IF_ID_instOut[13:11]), .control(stm), .out(regMemReadReg2Addr));
  registerMemory REG_MEM_(.clk(clk), .rst(rst), .writeEn(regMemWriteEn), .readAdr1(IF_ID_instOut[10:8]),
   .readAdr2(regMemReadReg2Addr), .writeAdr(IF_ID_instOut[13:11]), .readData1(regMemOutData1), .readData2(regMemOutData2),
   .writeData(regMemInData));
  stack STACK_(.clk(clk), .rst(rst), .push(push), .pop(pop), .writeData(IF_ID_pcPlus1Out), .readData(stackOut));
  HazardDetectionUnit HAZARD_DETEC_UNIT_(ID_EXE_MemRd, ID_EXE_rd, IF_ID_rs, IF_ID_rt, opcode, branchTaken,
    IF_ID_Wr, PCWr, ID_EXE_Zero, flush);
  controller CU_(clk, rst, start, push, pop, memWriteEn, regWriteEn, immAndmem, stm, ldm, branch, jmp, ret, Cin, Zin,
     opcodeFunc, aluOp, cWriteEn, zWriteEn, halt, pcEn, pc);
  ID_EXE_Reg ID_EX_(.clk(clk), .rst(rst), .regWr_IN, memRd_IN, memWr_IN, aluOp_IN, cWr_IN, zWr_IN,
       immConst_IN, .rd_IN(IF_ID_instOut[13:11]), .rs_IN(IF_ID_instOut[7:5]), .rt_IN(IF_ID_instOut[10:8]), .regData1_IN(regMemOutData1), .regData2_IN(regMemOutData2), .brDisp_IN(IF_ID_instOut[7:0]), .pcPlus1_IN(IF_ID_pcPlus1Out),
       regWr_OUT, memRd_OUT, memWr_OUT, aluOp_OUT, cWr_OUT, zWr_OUT, immConst_OUT,
       .rd_OUT(ID_EX_rdOut), .rs_OUT(ID_EX_rsOut), .rt_OUT(ID_EX_rtOut), .regData1_OUT(ID_EX_regMemOutData1), .regData2_OUT(ID_EX_regMemOutData2), .brDisp_OUT(ID_EX_brDipsOut), .pcPlus1_OUT(ID_EX_pcPlus1Out));
//EX
  signExt SIGN_EXT_(.in(ID_EX_brDipsOut), .out(signExtOut));
  adder12bit BRANCH_ADDER_(.in1(signExtOut), .in2(ID_EX_pcPlus1Out), .out(pcBranchValue));
  mux8bit3to1 ALU_IN1_MUX_(.in1(ID_EX_regMemOutData1), .in2(), in3, sel, out);
  mux8bit3to1 ALU_IN2_FIRST_MUX_(.in1(ID_EX_regMemOutData2), in2, in3, sel, out);
  mux8bit ALU_IN2_SECOND_MUX_(in1, in2, control, out);
  ALU AlU_(.in1(regMemOutData1), .in2(aluInput), .cIn(cToAlu), .sc(instMemWire[7:5]), .aluOp(aluOp), .zero(aluToZ),
   .cOut(aluToC), .out(aluOutput));
  flipflop C_(.clk(clk), .rst(rst), .writeEn(cWriteEn), .in(aluToC), .out(cToAlu));
  flipflop Z_(.clk(clk), .rst(rst), .writeEn(zWriteEn), .in(aluToZ), .out(Zout));
  ForwardingUnit FWD_UNIT_(EXE_MEM_RegWr, MEM_WB_RegWr, MEM_WB_rd,
    MEM_WB_MemRd, EXE_MEM_MemWr, ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd, MemForward,
    forward1, forward2);
  EXE_MEM_Reg EX_MEM_(clk, rst, regWr_IN, memWr_IN, memRd_IN, aluRes_IN, memWrData_IN, rd_IN,
      regWr_OUT, memWr_OUT, memRd_OUT, aluRes_OUT, memWrData_OUT, rd_OUT);
//MEM
  mux8bit MEM_ADDR_MUX_(.in1(aluOutput), .in2(dataMemOutput), .control(ldm), .out(regMemInData));
  dataMemory DATA_MEM_(.clk(clk), .rst(rst), .writeEn(memWriteEn), .address(aluOutput), .readData(dataMemOutput),
   .writeData(regMemOutData2));
  MEM_WB_Reg MEM_WB_(clk, rst, memRd_IN, regWr_IN, memReadData_IN, aluRes_IN, rd_IN,
     memRd_OUT, regWr_OUT, memReadData_OUT, aluRes_OUT, rd_OUT);
//WB
  mux8bit WB_DATA_MUX_(in1, in2, control, out);
endmodule
