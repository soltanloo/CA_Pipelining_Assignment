module HazardDetectionUnit (ID_EXE_MemRd, ID_EXE_rd, IF_ID_rs, IF_ID_rt, opcode, branchTaken,
  IF_ID_Wr, PCWr, ID_EXE_Zero, flush);

  input ID_EXE_MemRd, branchTaken;
  input[2:0] ID_EXE_rd, IF_ID_rs, IF_ID_rt;
  input[4:0] opcode;
  output IF_ID_Wr, PCWr, ID_EXE_Zero, flush;

  assign loadHazard = (ID_EXE_MemRd) && ((ID_EXE_rd == IF_ID_rs) || (ID_EXE_rd == IF_ID_rt)) ? 1 : 0;
  assign IF_ID_Wr = loadHazard ? 0 : 1;
  assign PCWr = loadHazard ? 0 : (branchTaken ? 1 : 0);
  assign flush = branchTaken || opcode == 5'b11100 || opcode == 5'b11101 || opcode == 5'b11110;
  assign ID_EXE_Zero = flush || loadHazard;

endmodule // HazardDetectionUnit