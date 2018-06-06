module EXE_MEM_Reg (clk, rst, regWr_IN, memWr_IN, memRd_IN, aluRes_IN, memWrData_IN, rd_IN,
  regWr_OUT, memWr_OUT, memRd_OUT, aluRes_OUT, memWrData_OUT, rd_OUT);

  input clk, rst, regWr_IN, memWr_IN, memRd_IN;
  input[2:0] rd_IN;
  input[7:0] aluRes_IN, memWrData_IN;
  output regWr_OUT, memWr_OUT, memRd_OUT;
  output[2:0] rd_OUT;
  output[7:0] aluRes_OUT, memWrData_OUT;


endmodule // EXE_MEM_Reg
