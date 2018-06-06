module controller(clk, rst, start, push, pop,
   memWriteEn, regWriteEn, immAndmem,
   stm, ldm, branch, jmp, ret, Cin, Zin,
   opcodeFunc, aluOp, cWriteEn, zWriteEn,
   halt, pcEn, pc);
  input[4:0] opcodeFunc;
  input clk, rst, start, halt, Cin, Zin;
  input[11:0] pc;
  output reg push, pop,
     memWriteEn, regWriteEn, immAndmem,
     stm, ldm, branch, jmp, ret, cWriteEn, zWriteEn, pcEn;
  output reg[3:0] aluOp;
  reg[1:0] ps, ns;
  parameter [1:0] IDLE=0, starting=1, computing=2;

  always@(ps, start, halt) begin
    ns= IDLE;
    case(ps)
      IDLE: ns = (start)? starting:IDLE;
      starting: ns = (start)? starting:computing;
      computing: ns = (halt)? IDLE:computing;
      default: ns = IDLE;
    endcase
  end

  always@(ps, start, halt, pc) begin
    push=0; pop=0;
    memWriteEn=0; regWriteEn=0; immAndmem=0; pcEn=0;
    stm=0; ldm=0; branch=0; jmp=0; ret=0; cWriteEn=0; zWriteEn=0;
    aluOp= 4'b0000;
    case(ps)
      IDLE: begin end
      starting: begin  end
      computing:begin
        pcEn=1;
        case(opcodeFunc)
        5'b00000 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0000; end
        5'b00001 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0001; end
        5'b00010 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0010; end
        5'b00011 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0011; end
        5'b00100 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0100; end
        5'b00101 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0101; end
        5'b00110 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0110; end
        5'b00111 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0111; end
        5'b01000 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0000; immAndmem=1; end
        5'b01001 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0001; immAndmem=1; end
        5'b01010 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0010; immAndmem=1; end
        5'b01011 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0011; immAndmem=1; end
        5'b01100 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0100; immAndmem=1; end
        5'b01101 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0101; immAndmem=1; end
        5'b01110 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0110; immAndmem=1; end
        5'b01111 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b0111; immAndmem=1; end
        5'b11000 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b1000; end
        5'b11001 : begin regWriteEn=1; cWriteEn=1; zWriteEn=1; aluOp= 4'b1001; end
        5'b11010 : begin regWriteEn=1; zWriteEn=1; aluOp= 4'b1010; end
        5'b11011 : begin regWriteEn=1; zWriteEn=1; aluOp= 4'b1011; end
        5'b10000 : begin regWriteEn=1; immAndmem=1; ldm=1; aluOp=4'b0000; end
        5'b10001 : begin memWriteEn=1; immAndmem=1; stm=1; aluOp=4'b0000; end
        5'b10100 : begin branch =  Zin;  end
        5'b10101 : begin branch = ~Zin; end
        5'b10110 : begin branch =  Cin;  end
        5'b10111 : begin branch = ~Cin; end
        5'b11100 : begin jmp=1; end
        5'b11101 : begin jmp=1; push=1; end
        5'b11110 : begin pop=1; ret=1; end
        endcase
      end
  endcase
  end

  always @ (posedge clk) begin
    ps <= ns;
  end

endmodule
