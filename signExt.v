module signExt(in, out);
  input[7:0] in;
  output[11:0] out;
  assign out = (in[7]) ? {5'b11111,in[6:0]} : {5'b00000,in[6:0]};
endmodule
