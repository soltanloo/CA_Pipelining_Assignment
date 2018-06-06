module ID_EXE_Reg (clk, rst, regWr_IN, memRd_IN, memWr_IN, aluOp_IN, cWr_IN, zWr_IN,
  immConst_IN, rd_IN, rs_IN, rt_IN, regData1_IN, regData2_IN, brDisp_IN, pcPlus1_IN,
  regWr_OUT, memRd_OUT, memWr_OUT, aluOp_OUT, cWr_OUT, zWr_OUT, immConst_OUT,
  rd_OUT, rs_OUT, rt_OUT, regData1_OUT, regData2_OUT, brDisp_OUT, pcPlus1_OUT,);

  input clk, rst, regWr_IN, memRd_IN, memWr_IN, cWr_IN, zWr_IN;
  input[2:0] rd_IN, rs_IN, rt_IN;
  input[3:0] aluOp_IN;
  input[7:0] immConst_IN, regData1_IN, regData2_IN, brDisp_IN;
  input[11:0] pcPlus1_IN;
  output regWr_OUT, memRd_OUT, memWr_OUT, cWr_OUT, zWr_OUT;
  output[2:0] rd_OUT, rs_OUT, rt_OUT;
  output[3:0] aluOp_OUT;
  output[7:0] immConst_OUT, regData1_OUT, regData2_OUT, brDisp_OUT;
  output[11:0] pcPlus1_OUT;

endmodule // ID_EXE_Reg
