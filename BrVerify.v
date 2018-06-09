module BrVerify (opCode, Cin, Zin, BrTaken);
  input [4:0] opCode;
  input Cin, Zin;
  output reg BrTaken;
  always @ ( opCode, Cin, Zin ) begin
    BrTaken=0;
    case(opCode)
    5'b10100 : begin if(Zin)begin BrTaken=1; end  end
    5'b10101 : begin if(~Zin)begin BrTaken=1; end end
    5'b10110 : begin if(Cin)begin BrTaken=1; end  end
    5'b10111 : begin if(~Cin)begin BrTaken=1; end end
    default: BrTaken=0;
    endcase
  end
endmodule // BrVerify
