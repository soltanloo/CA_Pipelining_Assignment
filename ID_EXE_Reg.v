module ID_EXE_Reg (clk, rst, regWr_IN, memRd_IN, memWr_IN, aluOp_IN, cWr_IN, zWr_IN,
  immConst_IN, rd_IN, rs_IN, rt_IN, regData1_IN, regData2_IN, brDisp_IN, pcPlus1_IN,
  regWr_OUT, memRd_OUT, memWr_OUT, aluOp_OUT, cWr_OUT, zWr_OUT, immConst_OUT,
  rd_OUT, rs_OUT, rt_OUT, regData1_OUT, regData2_OUT, brDisp_OUT, pcPlus1_OUT, opCode_IN, opCode_OUT);

  input clk, rst, regWr_IN, memRd_IN, memWr_IN, cWr_IN, zWr_IN, immConst_IN;
  input[2:0] rd_IN, rs_IN, rt_IN;
  input[3:0] aluOp_IN;
  input[4:0] opCode_IN;
  input[7:0] regData1_IN, regData2_IN, brDisp_IN;
  input[11:0] pcPlus1_IN;
  output reg regWr_OUT, memRd_OUT, memWr_OUT, cWr_OUT, zWr_OUT, immConst_OUT;
  output reg[2:0] rd_OUT, rs_OUT, rt_OUT;
  output reg[3:0] aluOp_OUT;
  output reg[4:0] opCode_OUT;
  output reg[7:0]  regData1_OUT, regData2_OUT, brDisp_OUT;
  output reg[11:0] pcPlus1_OUT;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      {regWr_OUT, memRd_OUT, memWr_OUT, cWr_OUT, zWr_OUT, rd_OUT, rs_OUT, rt_OUT, aluOp_OUT,
      immConst_OUT, regData1_OUT, regData2_OUT, brDisp_OUT, pcPlus1_OUT, opCode_OUT} <= 0;
    end
    else begin
      regWr_OUT <= regWr_IN; memRd_OUT <= memRd_IN; memWr_OUT <= memWr_IN;
      cWr_OUT <= cWr_IN; zWr_OUT <= zWr_IN; rd_OUT <= rd_IN;
      rs_OUT <= rs_IN; rt_OUT <= rt_IN; aluOp_OUT <= aluOp_IN;
      immConst_OUT <= immConst_IN; regData1_OUT <= regData1_IN; regData2_OUT <= regData2_IN;
      brDisp_OUT <= brDisp_IN; pcPlus1_OUT <= pcPlus1_IN; opCode_OUT<=opCode_IN;
    end
  end

endmodule // ID_EXE_Reg
