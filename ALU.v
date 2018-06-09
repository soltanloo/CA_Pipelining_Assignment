module ALU(A, B, fn, sc, Cin, Y, Zero, Cout);

  input[7:0] A, B;
  input[3:0] fn;
  input[2:0] sc;
  input Cin;
  output[7:0] Y;
  output Zero, Cout;

  parameter [4:0] ADD = 4'b0000, ADDC = 4'b0001, SUB = 4'b0010, SUBC = 4'b0011, AND = 4'b0100, OR = 4'b0101,
  XOR = 4'b0110, MASK = 4'b0111, SHL = 4'b1000, SHR = 4'b1001, ROL = 4'b1010, ROR = 4'b1011;
  always @ ( A, B, fn, sc ) begin
    case(fn):
    ADD: {Cout, Y} <= A + B;
    ADDC: {Cout, Y} <= A + B + Cin;
    SUB: {Cout, Y} <= A - B;
    SUBC: {Cout, Y} <= A - B - Cin;
    AND: Y <= A & B;
    OR: Y <= A | B;
    XOR: Y <= A ^ B;
    MASK: Y <= A & (~B);
    SHL: {Cout, Y} <= A << sc;
    SHR: {Y, Cout} <= A >> sc;
    ROL: {Cout, Y} <= {A, A} << (8 - sc);
    ROR: {Y, Cout} <= {A, A} >> (8 - sc);
    default: begin Y <= Y; Zero <= Zero; Cout <= Cout; end
  end
  assign Z = (Y == 0);
endmodule
