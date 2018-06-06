module pc(clk, rst, countEn, in, out);
  input[11:0] in;
  output reg [11:0] out;
  input clk, rst, countEn;
  always @(posedge clk, posedge rst) begin
    if(rst) begin
      out <= 12'b0;
    end
    else begin
      if(countEn) begin
        out <= in;
      end
    end
  end
endmodule
