module TB();
  reg clk=0,rst=0,start;
  CPU UUT(.clk(clk), .rst(rst), .start(start));
  initial begin
    #100
    rst=1;
    #100
    rst=0;
    #100
    start=0;
    clk=1;
    #100
    clk=0;
    #100
    start=1;
    clk=1;
    #100
    clk=0;
    #100
    start=0;
    #100
    clk=1;
    #100
    clk=0;
  end
  initial begin
    repeat(500) #100 clk=~clk;
  end
endmodule
