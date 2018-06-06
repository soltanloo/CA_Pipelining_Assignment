module dataMemory(clk, rst, writeEn, address, readData, writeData);
  input clk, rst, writeEn;
  input[7:0] address, writeData;
  output[7:0] readData;
  reg[7:0] dataArray[255:0];
  integer i;
  always@(posedge clk, posedge rst) begin
    if(rst) begin
      for (i=0; i<=255; i=i+1) begin
        //dataArray[i] = 8'b0;
      end
    end
    else begin
      if(writeEn) begin
        dataArray[address] <= writeData;
      end
    end
  end
  initial begin
    dataArray[100] = 8'b00000001;
    dataArray[101] = 8'b00000001;
    dataArray[102] = 8'b00000010;
    dataArray[103] = 8'b00000011;
    dataArray[104] = 8'b00000100;
    dataArray[105] = 8'b00000101;
    dataArray[106] = 8'b00000110;
    dataArray[107] = 8'b00000111;
    dataArray[108] = 8'b00001000;
    dataArray[109] = 8'b00001001;
    dataArray[110] = 8'b00001010;
    dataArray[111] = 8'b00001011;
    dataArray[112] = 8'b00001100;
    dataArray[113] = 8'b00001101;
    dataArray[114] = 8'b00001110;
    dataArray[115] = 8'b00001111;
    dataArray[116] = 8'b00000001;
    dataArray[117] = 8'b00000001;
    dataArray[118] = 8'b00000001;
    dataArray[119] = 8'b00000001;
    dataArray[120] = 8'b00000001;
  end
  assign readData = dataArray[address];
endmodule
