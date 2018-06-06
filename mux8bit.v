module mux8bit(in1, in2, control, out);
  input[7:0] in1,in2;
  output[7:0] out;
  input control;
  assign out = (control) ? in2 : in1;
endmodule
