module mux8bit3to1 (in1, in2, in3, sel, out);
  input [7:0] in1, in2, in3;
  input[1:0] sel;
  output reg [7:0] out;
  always @ (in1, in2, in3, sel) begin
    case(sel)
    0:begin out = in1; end
    1:begin out = in2; end
    2:begin out = in3; end
    endcase
  end
endmodule // mux8bit3to1
