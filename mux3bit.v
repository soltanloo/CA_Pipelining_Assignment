module mux3bit (in1, in2, control, out);
  input[2:0] in1,in2;
  output[2:0] out;
  input control;
  assign out = (control) ? in2 : in1;
endmodule
