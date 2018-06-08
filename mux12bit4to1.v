module mux12bit4to1 (in1, in2, in3, in4, sel, out);
  input [11:0] in1, in2, in3, in4;
  input[1:0] sel;
  output reg [11:0] out;
  always @ (in1, in2, in3, in4, sel) begin
    case(sel)
    0:begin out = in1 end
    1:begin out = in2 end
    2:begin out = in3 end
    3:begin out = in4 end
  end
endmodule // mux12bit4to1
