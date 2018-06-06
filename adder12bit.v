module adder12bit (in1, in2, out);
  input [11:0] in1, in2;
  output[11:0] out;
  assign out = (in1[11]) ? in2 +(~(in1)+1) : in2 + in1;
endmodule
