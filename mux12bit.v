module mux12bit (in1, in2, control, out);
  input[11:0] in1,in2;
  output[11:0] out;
  input control;
  assign out = (control) ? in2 : in1;
endmodule
