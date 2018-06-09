module MEM_WB_Reg (clk, rst, memRd_IN, regWr_IN, memReadData_IN, aluRes_IN, rd_IN,
  memRd_OUT, regWr_OUT, memReadData_OUT, aluRes_OUT, rd_OUT);

  input clk, rst, memRd_IN, regWr_IN;
  input[2:0] rd_IN;
  input[7:0] memReadData_IN, aluRes_IN;
  output reg memRd_OUT, regWr_OUT;
  output reg[2:0] rd_OUT;
  output reg[7:0] memReadData_OUT, aluRes_OUT;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      {memRd_OUT, regWr_OUT, rd_OUT, memReadData_OUT, aluRes_OUT} <= 0;
    end
    else begin
      memRd_OUT <= memRd_IN; regWr_OUT <= regWr_IN; rd_OUT <= rd_IN;
      memReadData_OUT <= memReadData_IN; aluRes_OUT <= aluRes_IN;
    end
  end

endmodule // MEM_WB_Reg
