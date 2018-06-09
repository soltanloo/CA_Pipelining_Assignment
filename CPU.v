module CPU (clk, rst, start);
  input clk, rst, start;
  wire halt, stm, regMemWriteEn, push, pop, pcSel, aluToC, cToAlu, aluToZ, Zout, cWriteEn, zWriteEn, memWriteEn,
  immAndmem, ldm, ID_EX_regWrOut, ID_EX_memRdOut, ID_EX_memWrOut, ID_EX_cWrOut, ID_EX_zWrOut, ID_EX_immConstOut,
  EX_MEM_regWrOut, EX_MEM_memWrOut, EX_MEM_memRdOut, pcWriteEn, MemForwardWire, forward1wire, forward2wire, hazardSignal, flushSignal, IF_ID_WrOut;
  wire[3:0] aluOp, ID_EX_aluOpOut;
  wire[4:0] ID_EX_opCodeOut;
  wire[2:0] regMemReadReg2Addr, ID_EX_rsOut, ID_EX_rtOut, ID_EX_rdOut, EX_MEM_rdOut, MEM_WB_rdOut;
  wire[7:0] regMemOutData1, regMemOutData2, regMemInData, ID_EX_brDipsOut, ID_EX_regMemOutData1, ID_EX_regMemOutData2,
  aluIn1MuxOut, aluIn2FirstMuxOut, aluIn2SecondMuxOut, EX_MEM_aluResOut, EX_MEM_memWrDataOut,  dataMemAddr,
  dataMemOutput, MEM_WB_aluResOut, MEM_WB_memReadDataOut;
  wire[11:0] pcOut, pcIn, pcAdded1Wire, IF_ID_pcPlus1Out, stackOut, ID_EX_pcPlus1Out, signExtOut, pcBranchValue;
  wire[18:0] instMemOut, IF_ID_instOut;

//IF
  mux12bit4to1 PC_IN_MUX_(.in1(pcAdded1Wire), .in2(IF_ID_instOut[11:0]), .in3(stackOut), .in4(pcBranchValue), .sel(pcSel), .out(pcIn));
  pc PC(.clk(clk), .rst(rst), .loadEn(pcWriteEn), .in(pcIn), .out(pcOut));
  adder12bit PC_INC_(.in1(12'b000000000001), .in2(pcOut), .out(pcAdded1Wire));
  instructionMemory INST_MEM_(.PC(pcOut), .outInst(instMemOut), .halt(halt));
  IF_ID_Reg IF_ID_(.clk(clk), .rst(rst), .flush(flushSignal), .IF_ID_Wr(IF_ID_WrOut), .pcPlus1_IN(pcAdded1Wire), .instruction_IN(instMemOut), .pcPlus1_OUT(IF_ID_pcPlus1Out), .instruction_OUT(IF_ID_instOut));
//ID
  mux3bit REG_MEM_ADDR_MUX(.in1(IF_ID_instOut[7:5]), .in2(IF_ID_instOut[13:11]), .control(stm), .out(regMemReadReg2Addr));
  registerMemory REG_MEM_(.clk(clk), .rst(rst), .writeEn(MEM_WB_regWrOut), .readAdr1(IF_ID_instOut[10:8]),
   .readAdr2(regMemReadReg2Addr), .writeAdr(IF_ID_instOut[13:11]), .readData1(regMemOutData1), .readData2(regMemOutData2),
   .writeData(regMemInData));
  stack STACK_(.clk(clk), .rst(rst), .push(push), .pop(pop), .writeData(IF_ID_pcPlus1Out), .readData(stackOut));
  HazardDetectionUnit HAZARD_DETEC_UNIT_(.ID_EXE_MemRd(ID_EX_memRdOut), .ID_EXE_rd(ID_EX_rdOut), .IF_ID_rs(IF_ID_rs), .IF_ID_rt(IF_ID_rt), .opcode(IF_ID_instOut[18:14]), .branchTaken(),
    .IF_ID_Wr(IF_ID_WrOut), .PCWr(pcWriteEn), .ID_EXE_Zero(hazardSignal), .flush(flushSignal));
  controller CU_(.clk(clk), .rst(rst), .start(start), .push(push), .pop(pop), .memWriteEn(memWriteEn), .regWriteEn(regMemWriteEn), .immAndmem(immAndmem), .stm(stm), .ldm(ldm), .Cin(cToAlu), .Zin(Zout),
     .opcodeFunc(IF_ID_instOut[18:14]), .aluOp(aluOp), .cWriteEn(cWriteEn), .zWriteEn(zWriteEn), .halt(halt), .pc(IF_ID_pcPlus1Out), .hazard(hazardSignal));
  ID_EXE_Reg ID_EX_(.clk(clk), .rst(rst), .regWr_IN(regMemWriteEn), .memRd_IN(ldm), .memWr_IN(memWriteEn), .aluOp_IN(aluOp), .cWr_IN(cWriteEn), .zWr_IN(zWriteEn),
       .immConst_IN(immAndmem), .rd_IN(IF_ID_instOut[13:11]), .rs_IN(IF_ID_instOut[7:5]), .rt_IN(IF_ID_instOut[10:8]), .regData1_IN(regMemOutData1), .regData2_IN(regMemOutData2), .brDisp_IN(IF_ID_instOut[7:0]), .pcPlus1_IN(IF_ID_pcPlus1Out),
       .regWr_OUT(ID_EX_regWrOut), .memRd_OUT(ID_EX_memRdOut), .memWr_OUT(ID_EX_memWrOut), .aluOp_OUT(ID_EX_aluOpOut), .cWr_OUT(ID_EX_cWrOut), .zWr_OUT(ID_EX_zWrOut), .immConst_OUT(ID_EX_immConstOut),
       .rd_OUT(ID_EX_rdOut), .rs_OUT(ID_EX_rsOut), .rt_OUT(ID_EX_rtOut), .regData1_OUT(ID_EX_regMemOutData1), .regData2_OUT(ID_EX_regMemOutData2), .brDisp_OUT(ID_EX_brDipsOut), .pcPlus1_OUT(ID_EX_pcPlus1Out), .opCode_IN(IF_ID_instOut[18:14]), .opCode_OUT(ID_EX_opCodeOut));
//EXE
  signExt SIGN_EXT_(.in(ID_EX_brDipsOut), .out(signExtOut));
  adder12bit BRANCH_ADDER_(.in1(signExtOut), .in2(ID_EX_pcPlus1Out), .out(pcBranchValue));
  mux8bit3to1 ALU_IN1_MUX_(.in1(ID_EX_regMemOutData1), .in2(regMemInData), .in3(EX_MEM_aluResOut), .sel(forward1), .out(aluIn1MuxOut));
  mux8bit3to1 ALU_IN2_FIRST_MUX_(.in1(ID_EX_regMemOutData2), .in2(regMemInData), .in3(EX_MEM_aluResOut), .sel(forward2), .out(aluIn2FirstMuxOut));
  mux8bit ALU_IN2_SECOND_MUX_(.in1(aluIn2FirstMuxOut), .in2(ID_EX_brDipsOut), .control(ID_EX_immConstOut), .out(aluIn2SecondMuxOut));
  ALU AlU_(.A(aluIn1MuxOut), .B(aluIn2SecondMuxOut), .fn(ID_EX_aluOpOut), .sc(ID_EX_rsOut), .Cin(cToAlu), .Y(aluOutput), .Zero(aluToZ), .Cout(aluToC));
  flipflop C_(.clk(clk), .rst(rst), .writeEn(ID_EX_cWrOut), .in(aluToC), .out(cToAlu));
  flipflop Z_(.clk(clk), .rst(rst), .writeEn(ID_EX_zWrOut), .in(aluToZ), .out(Zout));
  ForwardingUnit FWD_UNIT_(.EXE_MEM_RegWr(EX_MEM_regWrOut), .MEM_WB_RegWr(MEM_WB_regWrOut), .MEM_WB_rd(MEM_WB_rdOut),
    .MEM_WB_MemRd(MEM_WB_memRdOut), .EXE_MEM_MemWr(EX_MEM_memWrOut), .ID_EXE_rs(ID_EX_rsOut), .ID_EXE_rt(ID_EX_rtOut), .EXE_MEM_rd(EX_MEM_rdOut), .MemForward(MemForwardWire),
    .forward1(forward1wire), .forward2(forward2wire));
  EXE_MEM_Reg EX_MEM_(.clk(clk), .rst(rst), .regWr_IN(ID_EX_regWrOut), .memWr_IN(ID_EX_memWrOut), .memRd_IN(ID_EX_memRdOut), .aluRes_IN(aluOutput), .memWrData_IN(ID_EX_regMemOutData2), .rd_IN(ID_EX_rdOut),
      .regWr_OUT(EX_MEM_regWrOut), .memWr_OUT(EX_MEM_memWrOut), .memRd_OUT(EX_MEM_memRdOut), .aluRes_OUT(EX_MEM_aluResOut), .memWrData_OUT(EX_MEM_memWrDataOut), .rd_OUT(EX_MEM_rdOut));
//MEM
  mux8bit MEM_ADDR_MUX_(.in1(EX_MEM_aluResOut), .in2(MEM_WB_memReadDataOut), .control(MemForwardWire), .out(dataMemAddr));
  dataMemory DATA_MEM_(.clk(clk), .rst(rst), .writeEn(EX_MEM_memWrOut), .address(dataMemAddr), .readData(dataMemOutput),
   .writeData(EX_MEM_memWrDataOut));
  MEM_WB_Reg MEM_WB_(.clk(clk), .rst(rst), .memRd_IN(EX_MEM_memRdOut), .regWr_IN(EX_MEM_regWrOut), .memReadData_IN(dataMemOutput), .aluRes_IN(EX_MEM_aluResOut), .rd_IN(EX_MEM_rdOut),
     .memRd_OUT(MEM_WB_memRdOut), .regWr_OUT(MEM_WB_regWrOut), .memReadData_OUT(MEM_WB_memReadDataOut), .aluRes_OUT(MEM_WB_aluResOut), .rd_OUT(MEM_WB_rdOut));
//WB
  mux8bit WB_DATA_MUX_(.in1(MEM_WB_aluResOut), .in2(MEM_WB_memReadDataOut), .control(MEM_WB_memRdOut), .out(regMemInData));
endmodule
