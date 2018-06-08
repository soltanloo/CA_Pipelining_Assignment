module dataPath (clk, rst);


//IF
  mux12bit4to1 PC_IN_MUX_(in1, in2, in3, in4, sel, out);
  pc PC(.clk(clk), .rst(rst), .loadEn(), .in(), .out());
  adder12bit PC_INC_(.in1(12'b000000000001), .in2(pcWire), .out(pcAdded1Wire));
  instructionMemory INST_MEM_(.PC(pcWire), .dataPathOut(instMemWire), .CuOut(opcodeFunc), .halt(halt));
  IF_ID_Reg IF_ID_(clk, rst, flush, IF_ID_Wr, pcPlus1_IN, instruction_IN, pcPlus1_OUT, instruction_OUT);
//ID
  mux3bit REG_MEM_ADDR_MUX(in1, in2, control, out);
  registerMemory REG_MEM_(.clk(clk), .rst(rst), .writeEn(regWriteEn), .readAdr1(instMemWire[10:8]),
   .readAdr2(instMemInpMuxOutputWire), .writeAdr(instMemWire[13:11]), .readData1(regMemOutData1), .readData2(regMemOutData2),
   .writeData(regMemInData));
  stack STACK_(.clk(clk), .rst(rst), .push(push), .pop(pop), .writeData(pcAdded1Wire), .readData(stackReadedWire));
  HazardDetectionUnit HAZARD_DETEC_UNIT_(ID_EXE_MemRd, ID_EXE_rd, IF_ID_rs, IF_ID_rt, opcode, branchTaken,
    IF_ID_Wr, PCWr, ID_EXE_Zero, flush);
  controller CU_(clk, rst, start, push, pop, memWriteEn, regWriteEn, immAndmem, stm, ldm, branch, jmp, ret, Cin, Zin,
     opcodeFunc, aluOp, cWriteEn, zWriteEn, halt, pcEn, pc);
  ID_EXE_Reg ID_EX_(clk, rst, regWr_IN, memRd_IN, memWr_IN, aluOp_IN, cWr_IN, zWr_IN,
       immConst_IN, rd_IN, rs_IN, rt_IN, regData1_IN, regData2_IN, brDisp_IN, pcPlus1_IN,
       regWr_OUT, memRd_OUT, memWr_OUT, aluOp_OUT, cWr_OUT, zWr_OUT, immConst_OUT,
       rd_OUT, rs_OUT, rt_OUT, regData1_OUT, regData2_OUT, brDisp_OUT, pcPlus1_OUT,);
//EX
  signExt SIGN_EXT_(.in(instMemWire[7:0]), .out(signExtOut));
  adder12bit BRANCH_ADDER_(in1, in2, out);
  mux8bit3to1 ALU_IN1_MUX_(in1, in2, in3, sel, out);
  mux8bit3to1 ALU_IN2_FIRST_MUX_(in1, in2, in3, sel, out);
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
