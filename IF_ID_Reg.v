module IF_ID_Reg (clk, rst, flush, IF_ID_Wr, pcPlus1_IN, instruction_IN,
  pcPlus1_OUT, instruction_OUT);

  input clk, rst, flush, IF_ID_Wr;
  input[11:0] pcPlus1_IN;
  input[18:0] instruction_IN;
  output[11:0] pcPlus1_OUT;
  output[18:0] instruction_OUT;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      {pcPlus1_OUT, instruction_OUT} <= 0;
    end
    else begin
      pcPlus1_OUT <= pcPlus1_IN; instruction_OUT <= instruction_IN;
    end
  end

endmodule // IF_ID_Reg
