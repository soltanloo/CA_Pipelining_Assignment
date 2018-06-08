module instructionMemory(PC, outInst, halt);
  input[11:0] PC;
  output [18:0] outInst;
  output halt;
  reg[18:0] insMemory[0:4095];
  assign outInst = insMemory[PC];
  assign halt = ~(|(currentIns));
/*
  initial
  begin
    insMemory[0] = 19'b0000011100000000000;
    insMemory[1] = 19'b0000000100000000000;
    insMemory[2] = 19'b0101001100100010100;
    insMemory[3] = 19'b1010000000000000110;
    insMemory[4] = 19'b1000001000101100100;
    insMemory[5] = 19'b0001001111101000000;
    insMemory[6] = 19'b1011100000000000001;
    insMemory[7] = 19'b0000011101000000000;
    insMemory[8] = 19'b0100000100100000001;
    insMemory[9] = 19'b1110000000000000010;
    insMemory[10] = 19'b0000000000000000000;
    insMemory[11] = 19'b0000000000000000000;
    insMemory[12] = 19'b0000000000000000000;
    insMemory[13] = 19'b0000000000000000000;
    insMemory[14] = 19'b0000000000000000000;
    insMemory[15] = 19'b0000000000000000000;
  end
*/
  initial begin
    insMemory[0] = 19'b1000000100001100100;
    insMemory[1] = 19'b1000001000001100110;
    insMemory[2] = 19'b0000001100101000000;
    insMemory[3] = 19'b1000101100001101000;
    insMemory[4] = 19'b1000000100001100101;
    insMemory[5] = 19'b1000001000001100111;
    insMemory[6] = 19'b0000101100101000000;
    insMemory[7] = 19'b1000101100001101001;
  end
endmodule
