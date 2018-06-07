module ForwardingUnit (EXE_MEM_RegWr, MEM_WB_RegWr, MEM_WB_rd,
  MEM_WB_MemRd, EXE_MEM_MemWr, ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd, MemForward,
  forward1, forward2);

  input EXE_MEM_RegWr, MEM_WB_RegWr, MEM_WB_MemRd, EXE_MEM_MemWr;
  input[2:0] MEM_WB_rd, ID_EXE_rs, ID_EXE_rt, EXE_MEM_rd;
  output[1:0] forward1, forward2
  output MemForward;

  assign MemForward = (EXE_MEM_MemWr && MEM_WB_MemRd) && (MEM_WB_rd == EXE_MEM_rd) ? 1 : 0;
  assign forward1 = ((ID_EXE_rs == EXE_MEM_rd) && (EXE_MEM_RegWr)) ? 2'b10 :
    (MEM_WB_RegWr && (MEM_WB_rd == ID_EXE_rs) && ((EXE_MEM_rd != ID_EXE_rs) || EXE_MEM_RegWr == 0) ? 2'b01 : 2'b00);
  assign forward2 = ((ID_EXE_rt == EXE_MEM_rd) && (EXE_MEM_RegWr)) ? 2'b10 :
    (MEM_WB_RegWr && (MEM_WB_rd == ID_EXE_rt) && ((EXE_MEM_rd != ID_EXE_rt) || EXE_MEM_RegWr == 0) ? 2'b01 : 2'b00);
  
endmodule // ForwardingUnit
