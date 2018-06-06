module ForwardingUnit (EXE_MEM_RegWr, MEM_WB_RegWr, MEM_WB_rd,
  MEM_WB_MemRd, EXE_MEM_MemWr, ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd, MemForward,
  forward);

  input EXE_MEM_RegWr, MEM_WB_RegWr, MEM_WB_MemRd, EXE_MEM_MemWr;
  input[2:0] MEM_WB_rd, ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd;
  output forward, MemForward;

  
endmodule // ForwardingUnit
