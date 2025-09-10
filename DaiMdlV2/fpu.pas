unit fpu;

interface
var
  Default8087CW: Word = $1332;{ Default 8087 control word.  FPU control
                                register is set to this value.
                                CAUTION:  Setting this to an invalid value
                                          could cause unpredictable behaiour. }

procedure Set8087CW(NewCW: Word);
function ArcTan2(Y, X: Extended): Extended;

implementation


function ArcTan2(Y, X: Extended): Extended;
asm
        FLD     Y
        FLD     X
        FPATAN
        FWAIT
end;

procedure Set8087CW(NewCW: Word);
asm
        MOV     Default8087CW,AX
        FLDCW   Default8087CW
end;

end.
