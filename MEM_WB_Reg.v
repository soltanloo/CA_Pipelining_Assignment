module MEM_WB_Reg (clk, rst, memRd_IN, regWr_IN, memReadData_IN, aluRes_IN, rd_IN,
  memRd_OUT, regWr_OUT, memReadData_OUT, aluRes_OUT, rd_OUT);

  input clk, rst, memRd_IN, regWr_IN;
  input[2:0] rd_IN;
  input[7:0] memReadData_IN, aluRes_IN;
  output memRd_OUT, regWr_OUT;
  output[2:0] rd_OUT;
  output[7:0] memReadData_OUT, aluRes_OUT;

endmodule // MEM_WB_Reg
