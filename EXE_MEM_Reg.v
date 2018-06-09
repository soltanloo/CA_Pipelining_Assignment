module EXE_MEM_Reg (clk, rst, regWr_IN, memWr_IN, memRd_IN, aluRes_IN, memWrData_IN, rd_IN,
  regWr_OUT, memWr_OUT, memRd_OUT, aluRes_OUT, memWrData_OUT, rd_OUT);

  input clk, rst, regWr_IN, memWr_IN, memRd_IN;
  input[2:0] rd_IN;
  input[7:0] aluRes_IN, memWrData_IN;
  output reg regWr_OUT, memWr_OUT, memRd_OUT;
  output reg[2:0] rd_OUT;
  output reg[7:0] aluRes_OUT, memWrData_OUT;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      {regWr_OUT, memWr_OUT, memRd_OUT, rd_OUT, aluRes_OUT, memWrData_OUT} <= 0;
    end
    else begin
      regWr_OUT <= regWr_IN; memWr_OUT <= memWr_IN; memRd_OUT <= memRd_IN;
      rd_OUT <= rd_IN; aluRes_OUT <= aluRes_IN; memWrData_OUT <= memWrData_IN;
    end
  end

endmodule // EXE_MEM_Reg
