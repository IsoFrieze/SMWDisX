    ORG $0F8000

MusicSamples:
    dw SampleData-MusicSamples-4
    dw SamplePtrTable

    dw Sample00, Sample00+$24
    dw Sample01, Sample01+$24
    dw Sample02, Sample02+$EA
    dw Sample03, Sample03+$129
    dw Sample04, Sample04+$24
    dw Sample05, Sample05+$129
    dw Sample06, Sample06
    dw Sample07, Sample07+$627
    dw Sample08, Sample08+$24
    dw Sample09, Sample09+$C2A
    dw Sample0A, Sample0A
    dw Sample0B, Sample0B
    dw Sample0C, Sample0C+$24
    dw Sample0D, Sample0D+$29A
    dw Sample0E, Sample0E+$A71
    dw Sample0F, Sample0F
    dw Sample10, Sample10
    dw Sample11, Sample11+$510
    dw Sample12, Sample12
    dw Sample13, Sample13

SampleData:
    dw SampleData_End-SampleData-4
    dw SampleTable

    base SampleTable
Sample00:
    incbin "samples/Sample00.brr"
Sample01:
    incbin "samples/Sample01.brr"
Sample02:
    incbin "samples/Sample02.brr"
Sample03:
    incbin "samples/Sample03.brr"
Sample04:
    incbin "samples/Sample04.brr"
Sample05:
    incbin "samples/Sample05.brr"
Sample06:
    incbin "samples/Sample06.brr"
Sample07:
    incbin "samples/Sample07.brr"
Sample08:
    incbin "samples/Sample08.brr"
Sample09:
    incbin "samples/Sample09.brr"
Sample0A:
    incbin "samples/Sample0A.brr"
Sample0B:
    incbin "samples/Sample0B.brr"
Sample0C:
    incbin "samples/Sample0C.brr"
Sample0D:
    incbin "samples/Sample0D.brr"
Sample0E:
    incbin "samples/Sample0E.brr"
Sample0F:
    incbin "samples/Sample0F.brr"
Sample10:
    incbin "samples/Sample10.brr"
Sample11:
    incbin "samples/Sample11.brr"
Sample12:
    incbin "samples/Sample12.brr"
Sample13:
    incbin "samples/Sample13.brr"

    base off

SampleData_End:
    dw $0000,SPCEngine

    db $18,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$00,$00,$00,$00

    %insert_empty($1070,$1070,$1070,$1070,$1070)