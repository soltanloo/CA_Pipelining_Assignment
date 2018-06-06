module flipflop(clk, rst, writeEn, in, out);
  input in, clk, rst, writeEn;
  output reg out;
  always @(posedge clk, posedge rst) begin
    if(rst) begin
      out <= 1'b0;
    end
    else begin
      if(writeEn) begin
        out <= in;
      end
    end
  end
endmodule
