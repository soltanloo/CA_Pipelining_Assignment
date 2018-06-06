module cpu(clk, rst, start);
  input clk, rst, start;
  wire push, pop, memWriteEn, regWriteEn, immAndmem, stm, ldm, branch, jmp, ret, Cin, Zin,
    cWriteEn, zWriteEn, halt, pcEn;
  wire[4:0]opcodeFunc;
  wire[3:0]aluOp;
  wire[11:0] pc;

  controller CU(.clk(clk), .rst(rst), .start(start), .push(push), .pop(pop), .memWriteEn(memWriteEn), .regWriteEn(regWriteEn), .immAndmem(immAndmem),
   .stm(stm), .ldm(ldm), .branch(branch), .jmp(jmp), .ret(ret), .Cin(Cin), .Zin(Zin),
   .opcodeFunc(opcodeFunc), .aluOp(aluOp), .cWriteEn(cWriteEn), .zWriteEn(zWriteEn), .halt(halt), .pcEn(pcEn), .pc(pc));

   dataPath DP(.clk(clk), .rst(rst), .push(push), .pop(pop), .memWriteEn(memWriteEn), .regWriteEn(regWriteEn), .immAndmem(immAndmem),
    .stm(stm), .ldm(ldm), .branch(branch), .jmp(jmp), .ret(ret), .Cout(Cin), .Zout(Zin), .opcodeFunc(opcodeFunc),
    .aluOp(aluOp), .cWriteEn(cWriteEn), .zWriteEn(zWriteEn), .halt(halt), .pcEn(pcEn), .pcOut(pc));

endmodule
