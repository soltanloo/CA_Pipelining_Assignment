module dataPath (clk, rst, push, pop, memWriteEn, regWriteEn, immAndmem, stm, ldm, branch, jmp, ret, Cout, Zout, opcodeFunc,
  aluOp, cWriteEn, zWriteEn, halt, pcEn, pcOut);
    input clk, rst, push, pop, memWriteEn, regWriteEn, immAndmem, stm, ldm, branch, jmp, ret, cWriteEn, zWriteEn, pcEn;
    input[3:0] aluOp;
    output Cout, Zout, halt;
    output[4:0] opcodeFunc;
    output[11:0] pcOut;
    wire[11:0] pcWire, pcAdded1Wire, signExtOut, branchAddedPcWire, branchAddedOrPcWire, jmpAddrOrBranchAddedPc,
     stackReadedWire, pcInputWire;
    wire[13:0] instMemWire;
    wire[2:0] instMemInpMuxOutputWire;
    wire[7:0] regMemOutData1, regMemOutData2, regMemInData, aluInput, aluOutput, dataMemOutput;
    wire aluToC, cToAlu, aluToZ;
    assign pcOut = pcWire;

    pc PC(.clk(clk), .rst(rst), .countEn(pcEn), .in(pcInputWire), .out(pcWire));
    instructionMemory INST_MEM(.PC(pcWire), .dataPathOut(instMemWire), .CuOut(opcodeFunc), .halt(halt));
    mux3bit READ2_ADR_MUX(.in1(instMemWire[7:5]), .in2(instMemWire[13:11]), .control(stm), .out(instMemInpMuxOutputWire));
    registerMemory REG_MEM(.clk(clk), .rst(rst), .writeEn(regWriteEn), .readAdr1(instMemWire[10:8]),
     .readAdr2(instMemInpMuxOutputWire), .writeAdr(instMemWire[13:11]), .readData1(regMemOutData1), .readData2(regMemOutData2),
     .writeData(regMemInData));
    mux8bit RegMEM_TO_ALU_MUX(.in1(regMemOutData2), .in2(instMemWire[7:0]), .control(immAndmem), .out(aluInput));
    ALU AlU(.in1(regMemOutData1), .in2(aluInput), .cIn(cToAlu), .sc(instMemWire[7:5]), .aluOp(aluOp), .zero(aluToZ),
     .cOut(aluToC), .out(aluOutput));
    flipflop C(.clk(clk), .rst(rst), .writeEn(cWriteEn), .in(aluToC), .out(cToAlu));
    assign Cout = cToAlu;
    flipflop Z(.clk(clk), .rst(rst), .writeEn(zWriteEn), .in(aluToZ), .out(Zout));
    dataMemory DATA_MEM(.clk(clk), .rst(rst), .writeEn(memWriteEn), .address(aluOutput), .readData(dataMemOutput),
     .writeData(regMemOutData2));
    mux8bit MEM_ALU_TO_RegMem_MUX(.in1(aluOutput), .in2(dataMemOutput), .control(ldm), .out(regMemInData));
    stack STACK(.clk(clk), .rst(rst), .push(push), .pop(pop), .writeData(pcAdded1Wire), .readData(stackReadedWire));
    adder12bit PC_ADD1(.in1(12'b000000000001), .in2(pcWire), .out(pcAdded1Wire));
    signExt SIGN_EXT(.in(instMemWire[7:0]), .out(signExtOut));
    adder12bit BrADR_ADDER(.in1(signExtOut), .in2(pcAdded1Wire), .out(branchAddedPcWire));
    mux12bit BrADDER_PC_MUX(.in1(pcAdded1Wire), .in2(branchAddedPcWire), .control(branch), .out(branchAddedOrPcWire));
    mux12bit PrevMUX_DirectADR_MUX(.in1(branchAddedOrPcWire), .in2(instMemWire[11:0]), .control(jmp), .out(jmpAddrOrBranchAddedPc));
    mux12bit PrevMUX_STACK_MUX(.in1(jmpAddrOrBranchAddedPc), .in2(stackReadedWire), .control(ret), .out(pcInputWire));
endmodule
