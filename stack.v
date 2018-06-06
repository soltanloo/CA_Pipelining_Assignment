module stack(clk, rst, push, pop, writeData, readData);
  input clk, rst, push, pop;
  input[11:0] writeData;
  output[11:0] readData;
  reg[11:0] stackArray[7:0];
  reg[2:0] pointer;
  integer i;
  always@(posedge clk, posedge rst) begin
    if(rst) begin
      for (i=0; i<=7; i=i+1) begin
        stackArray[i] = 12'b0;
      end
      pointer = 3'b0;
    end
    else begin
      if(push) begin
        stackArray[pointer] <= writeData;
        if(pointer < 7) begin
          pointer = pointer + 1;
        end
      end
      else begin
        if(pop) begin
          if(pointer < 0) begin
            pointer = pointer - 1;
          end
        end
      end
    end
  end
  assign readData = stackArray[pointer];
endmodule
