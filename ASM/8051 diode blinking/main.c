    ORG         0
    TIME_30MS   EQU         65535-27650+1

    JMP         START

    ORG         0BH
    CPL         P2.2
    MOV         TH0,#HIGH   TIME_30MS
    MOV         TH0,#LOW    TIME_30MS
    RETI

START:
    MOV         TMOD,#00000001B
    SETB        TR0
    MOV         P2,#0
    MOV         TH0,#HIGH   TIME_30MS
    MOV         TL0,#LOW    TIME_30MS
    
    SETB        ET0
    SETB        EA
    
    SJMP        $
    
    END
