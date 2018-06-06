module HazardDetectionUnit (ID_EXE_MemRd, ID_EXE_rd, IF_ID_rs, IF_ID_rt, opcode,
  IF_ID_Wr, PCWr);

  input ID_EXE_MemRd;
  input[2:0] ID_EXE_rd, IF_ID_rs, IF_ID_rt;
  input[4:0] opcode;
  output IF_ID_Wr, PCWr;

endmodule // HazardDetectionUnit
