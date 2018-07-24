DATA_038000:          .db $13,$14,$15,$16,$17,$18,$19     ;; 038000               ;
                                                          ;;                      ;
DATA_038007:          .db $F0,$F8,$FC,$00,$04,$08,$10     ;; 038007               ;
                                                          ;;                      ;
DATA_03800E:          .db $A0,$D0,$C0,$D0                 ;; 03800E               ;
                                                          ;;                      ;
Football:             JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_038016:          LDA RAM_SpritesLocked               ;; 038016 : A5 9D       ;
CODE_038018:          BNE Return038086                    ;; 038018 : D0 6C       ;
CODE_03801A:          JSR.W SubOffscreen0Bnk3             ;; 03801A : 20 5D B8    ;
CODE_03801D:          JSL.L SprSpr+MarioSprRts            ;; 03801D : 22 3A 80 01 ;
CODE_038021:          LDA.W $1540,X                       ;; 038021 : BD 40 15    ;
CODE_038024:          BEQ CODE_03802D                     ;; 038024 : F0 07       ;
CODE_038026:          DEC A                               ;; 038026 : 3A          ;
CODE_038027:          BNE CODE_038031                     ;; 038027 : D0 08       ;
CODE_038029:          JSL.L CODE_01AB6F                   ;; 038029 : 22 6F AB 01 ;
CODE_03802D:          JSL.L UpdateSpritePos               ;; 03802D : 22 2A 80 01 ;
CODE_038031:          LDA.W RAM_SprObjStatus,X            ;; 038031 : BD 88 15    ; \ Branch if not touching object 
CODE_038034:          AND.B #$03                          ;; 038034 : 29 03       ;  | 
CODE_038036:          BEQ CODE_03803F                     ;; 038036 : F0 07       ; / 
CODE_038038:          LDA RAM_SpriteSpeedX,X              ;; 038038 : B5 B6       ;
CODE_03803A:          EOR.B #$FF                          ;; 03803A : 49 FF       ;
CODE_03803C:          INC A                               ;; 03803C : 1A          ;
CODE_03803D:          STA RAM_SpriteSpeedX,X              ;; 03803D : 95 B6       ;
CODE_03803F:          LDA.W RAM_SprObjStatus,X            ;; 03803F : BD 88 15    ;
CODE_038042:          AND.B #$08                          ;; 038042 : 29 08       ;
CODE_038044:          BEQ CODE_038048                     ;; 038044 : F0 02       ;
CODE_038046:          STZ RAM_SpriteSpeedY,X              ;; 038046 : 74 AA       ; Sprite Y Speed = 0 
CODE_038048:          LDA.W RAM_SprObjStatus,X            ;; 038048 : BD 88 15    ; \ Branch if not on ground 
CODE_03804B:          AND.B #$04                          ;; 03804B : 29 04       ;  | 
CODE_03804D:          BEQ Return038086                    ;; 03804D : F0 37       ; / 
CODE_03804F:          LDA.W $1540,X                       ;; 03804F : BD 40 15    ;
CODE_038052:          BNE Return038086                    ;; 038052 : D0 32       ;
CODE_038054:          LDA.W RAM_SpritePal,X               ;; 038054 : BD F6 15    ;
CODE_038057:          EOR.B #$40                          ;; 038057 : 49 40       ;
CODE_038059:          STA.W RAM_SpritePal,X               ;; 038059 : 9D F6 15    ;
CODE_03805C:          JSL.L GetRand                       ;; 03805C : 22 F9 AC 01 ;
CODE_038060:          AND.B #$03                          ;; 038060 : 29 03       ;
CODE_038062:          TAY                                 ;; 038062 : A8          ;
CODE_038063:          LDA.W DATA_03800E,Y                 ;; 038063 : B9 0E 80    ;
CODE_038066:          STA RAM_SpriteSpeedY,X              ;; 038066 : 95 AA       ;
CODE_038068:          LDY.W $15B8,X                       ;; 038068 : BC B8 15    ;
CODE_03806B:          INY                                 ;; 03806B : C8          ;
CODE_03806C:          INY                                 ;; 03806C : C8          ;
CODE_03806D:          INY                                 ;; 03806D : C8          ;
CODE_03806E:          LDA.W DATA_038007,Y                 ;; 03806E : B9 07 80    ;
CODE_038071:          CLC                                 ;; 038071 : 18          ;
CODE_038072:          ADC RAM_SpriteSpeedX,X              ;; 038072 : 75 B6       ;
CODE_038074:          BPL CODE_03807E                     ;; 038074 : 10 08       ;
CODE_038076:          CMP.B #$E0                          ;; 038076 : C9 E0       ;
CODE_038078:          BCS CODE_038084                     ;; 038078 : B0 0A       ;
CODE_03807A:          LDA.B #$E0                          ;; 03807A : A9 E0       ;
CODE_03807C:          BRA CODE_038084                     ;; 03807C : 80 06       ;
                                                          ;;                      ;
CODE_03807E:          CMP.B #$20                          ;; 03807E : C9 20       ;
CODE_038080:          BCC CODE_038084                     ;; 038080 : 90 02       ;
ADDR_038082:          LDA.B #$20                          ;; 038082 : A9 20       ;
CODE_038084:          STA RAM_SpriteSpeedX,X              ;; 038084 : 95 B6       ;
Return038086:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
BigBooBoss:           JSL.L CODE_038398                   ;; ?QPWZ? : 22 98 83 03 ;
CODE_03808B:          JSL.L CODE_038239                   ;; 03808B : 22 39 82 03 ;
CODE_03808F:          LDA.W $14C8,X                       ;; 03808F : BD C8 14    ;
CODE_038092:          BNE CODE_0380A2                     ;; 038092 : D0 0E       ;
CODE_038094:          INC.W $13C6                         ;; 038094 : EE C6 13    ;
CODE_038097:          LDA.B #$FF                          ;; 038097 : A9 FF       ;
CODE_038099:          STA.W $1493                         ;; 038099 : 8D 93 14    ;
CODE_03809C:          LDA.B #$0B                          ;; 03809C : A9 0B       ;
CODE_03809E:          STA.W $1DFB                         ;; 03809E : 8D FB 1D    ; / Change music 
Return0380A1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0380A2:          CMP.B #$08                          ;; 0380A2 : C9 08       ;
CODE_0380A4:          BNE Return0380D4                    ;; 0380A4 : D0 2E       ;
CODE_0380A6:          LDA RAM_SpritesLocked               ;; 0380A6 : A5 9D       ;
CODE_0380A8:          BNE Return0380D4                    ;; 0380A8 : D0 2A       ;
CODE_0380AA:          LDA RAM_SpriteState,X               ;; 0380AA : B5 C2       ;
CODE_0380AC:          JSL.L ExecutePtr                    ;; 0380AC : 22 DF 86 00 ;
                                                          ;;                      ;
BooBossPtrs:          .dw CODE_0380BE                     ;; ?QPWZ? : BE 80       ;
                      .dw CODE_0380D5                     ;; ?QPWZ? : D5 80       ;
                      .dw CODE_038119                     ;; ?QPWZ? : 19 81       ;
                      .dw CODE_03818B                     ;; ?QPWZ? : 8B 81       ;
                      .dw CODE_0381BC                     ;; ?QPWZ? : BC 81       ;
                      .dw CODE_038106                     ;; ?QPWZ? : 06 81       ;
                      .dw CODE_0381D3                     ;; ?QPWZ? : D3 81       ;
                                                          ;;                      ;
CODE_0380BE:          LDA.B #$03                          ;; 0380BE : A9 03       ;
CODE_0380C0:          STA.W $1602,X                       ;; 0380C0 : 9D 02 16    ;
CODE_0380C3:          INC.W $1570,X                       ;; 0380C3 : FE 70 15    ;
CODE_0380C6:          LDA.W $1570,X                       ;; 0380C6 : BD 70 15    ;
CODE_0380C9:          CMP.B #$90                          ;; 0380C9 : C9 90       ;
CODE_0380CB:          BNE Return0380D4                    ;; 0380CB : D0 07       ;
CODE_0380CD:          LDA.B #$08                          ;; 0380CD : A9 08       ;
CODE_0380CF:          STA.W $1540,X                       ;; 0380CF : 9D 40 15    ;
CODE_0380D2:          INC RAM_SpriteState,X               ;; 0380D2 : F6 C2       ;
Return0380D4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0380D5:          LDA.W $1540,X                       ;; 0380D5 : BD 40 15    ;
CODE_0380D8:          BNE Return0380F9                    ;; 0380D8 : D0 1F       ;
CODE_0380DA:          LDA.B #$08                          ;; 0380DA : A9 08       ;
CODE_0380DC:          STA.W $1540,X                       ;; 0380DC : 9D 40 15    ;
CODE_0380DF:          INC.W $190B                         ;; 0380DF : EE 0B 19    ;
CODE_0380E2:          LDA.W $190B                         ;; 0380E2 : AD 0B 19    ;
CODE_0380E5:          CMP.B #$02                          ;; 0380E5 : C9 02       ;
CODE_0380E7:          BNE CODE_0380EE                     ;; 0380E7 : D0 05       ;
CODE_0380E9:          LDY.B #$10                          ;; 0380E9 : A0 10       ; \ Play sound effect 
CODE_0380EB:          STY.W $1DF9                         ;; 0380EB : 8C F9 1D    ; / 
CODE_0380EE:          CMP.B #$07                          ;; 0380EE : C9 07       ;
CODE_0380F0:          BNE Return0380F9                    ;; 0380F0 : D0 07       ;
CODE_0380F2:          INC RAM_SpriteState,X               ;; 0380F2 : F6 C2       ;
CODE_0380F4:          LDA.B #$40                          ;; 0380F4 : A9 40       ;
CODE_0380F6:          STA.W $1540,X                       ;; 0380F6 : 9D 40 15    ;
Return0380F9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0380FA:          .db $FF,$01                         ;; 0380FA               ;
                                                          ;;                      ;
DATA_0380FC:          .db $F0,$10                         ;; 0380FC               ;
                                                          ;;                      ;
DATA_0380FE:          .db $0C,$F4                         ;; 0380FE               ;
                                                          ;;                      ;
DATA_038100:          .db $01,$FF                         ;; 038100               ;
                                                          ;;                      ;
DATA_038102:          .db $01,$02,$02,$01                 ;; 038102               ;
                                                          ;;                      ;
CODE_038106:          LDA.W $1540,X                       ;; 038106 : BD 40 15    ;
CODE_038109:          BNE CODE_038112                     ;; 038109 : D0 07       ;
CODE_03810B:          STZ RAM_SpriteState,X               ;; 03810B : 74 C2       ;
CODE_03810D:          LDA.B #$40                          ;; 03810D : A9 40       ;
CODE_03810F:          STA.W $1570,X                       ;; 03810F : 9D 70 15    ;
CODE_038112:          LDA.B #$03                          ;; 038112 : A9 03       ;
CODE_038114:          STA.W $1602,X                       ;; 038114 : 9D 02 16    ;
CODE_038117:          BRA CODE_03811F                     ;; 038117 : 80 06       ;
                                                          ;;                      ;
CODE_038119:          STZ.W $1602,X                       ;; 038119 : 9E 02 16    ;
CODE_03811C:          JSR.W CODE_0381E4                   ;; 03811C : 20 E4 81    ;
CODE_03811F:          LDA.W $15AC,X                       ;; 03811F : BD AC 15    ;
CODE_038122:          BNE CODE_038132                     ;; 038122 : D0 0E       ;
CODE_038124:          JSR.W SubHorzPosBnk3                ;; 038124 : 20 17 B8    ;
CODE_038127:          TYA                                 ;; 038127 : 98          ;
CODE_038128:          CMP.W RAM_SpriteDir,X               ;; 038128 : DD 7C 15    ;
CODE_03812B:          BEQ CODE_03814A                     ;; 03812B : F0 1D       ;
CODE_03812D:          LDA.B #$1F                          ;; 03812D : A9 1F       ;
CODE_03812F:          STA.W $15AC,X                       ;; 03812F : 9D AC 15    ;
CODE_038132:          CMP.B #$10                          ;; 038132 : C9 10       ;
CODE_038134:          BNE CODE_038140                     ;; 038134 : D0 0A       ;
CODE_038136:          PHA                                 ;; 038136 : 48          ;
CODE_038137:          LDA.W RAM_SpriteDir,X               ;; 038137 : BD 7C 15    ;
CODE_03813A:          EOR.B #$01                          ;; 03813A : 49 01       ;
CODE_03813C:          STA.W RAM_SpriteDir,X               ;; 03813C : 9D 7C 15    ;
CODE_03813F:          PLA                                 ;; 03813F : 68          ;
CODE_038140:          LSR                                 ;; 038140 : 4A          ;
CODE_038141:          LSR                                 ;; 038141 : 4A          ;
CODE_038142:          LSR                                 ;; 038142 : 4A          ;
CODE_038143:          TAY                                 ;; 038143 : A8          ;
CODE_038144:          LDA.W DATA_038102,Y                 ;; 038144 : B9 02 81    ;
CODE_038147:          STA.W $1602,X                       ;; 038147 : 9D 02 16    ;
CODE_03814A:          LDA RAM_FrameCounterB               ;; 03814A : A5 14       ;
CODE_03814C:          AND.B #$07                          ;; 03814C : 29 07       ;
CODE_03814E:          BNE CODE_038166                     ;; 03814E : D0 16       ;
CODE_038150:          LDA.W $151C,X                       ;; 038150 : BD 1C 15    ;
CODE_038153:          AND.B #$01                          ;; 038153 : 29 01       ;
CODE_038155:          TAY                                 ;; 038155 : A8          ;
CODE_038156:          LDA RAM_SpriteSpeedX,X              ;; 038156 : B5 B6       ;
CODE_038158:          CLC                                 ;; 038158 : 18          ;
CODE_038159:          ADC.W DATA_0380FA,Y                 ;; 038159 : 79 FA 80    ;
CODE_03815C:          STA RAM_SpriteSpeedX,X              ;; 03815C : 95 B6       ;
CODE_03815E:          CMP.W DATA_0380FC,Y                 ;; 03815E : D9 FC 80    ;
CODE_038161:          BNE CODE_038166                     ;; 038161 : D0 03       ;
CODE_038163:          INC.W $151C,X                       ;; 038163 : FE 1C 15    ;
CODE_038166:          LDA RAM_FrameCounterB               ;; 038166 : A5 14       ;
CODE_038168:          AND.B #$07                          ;; 038168 : 29 07       ;
CODE_03816A:          BNE CODE_038182                     ;; 03816A : D0 16       ;
CODE_03816C:          LDA.W $1528,X                       ;; 03816C : BD 28 15    ;
CODE_03816F:          AND.B #$01                          ;; 03816F : 29 01       ;
CODE_038171:          TAY                                 ;; 038171 : A8          ;
CODE_038172:          LDA RAM_SpriteSpeedY,X              ;; 038172 : B5 AA       ;
CODE_038174:          CLC                                 ;; 038174 : 18          ;
CODE_038175:          ADC.W DATA_038100,Y                 ;; 038175 : 79 00 81    ;
CODE_038178:          STA RAM_SpriteSpeedY,X              ;; 038178 : 95 AA       ;
CODE_03817A:          CMP.W DATA_0380FE,Y                 ;; 03817A : D9 FE 80    ;
CODE_03817D:          BNE CODE_038182                     ;; 03817D : D0 03       ;
CODE_03817F:          INC.W $1528,X                       ;; 03817F : FE 28 15    ;
CODE_038182:          JSL.L UpdateXPosNoGrvty             ;; 038182 : 22 22 80 01 ;
CODE_038186:          JSL.L UpdateYPosNoGrvty             ;; 038186 : 22 1A 80 01 ;
Return03818A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03818B:          LDA.W $1540,X                       ;; 03818B : BD 40 15    ;
CODE_03818E:          BNE CODE_0381AE                     ;; 03818E : D0 1E       ;
CODE_038190:          INC RAM_SpriteState,X               ;; 038190 : F6 C2       ;
CODE_038192:          LDA.B #$08                          ;; 038192 : A9 08       ;
CODE_038194:          STA.W $1540,X                       ;; 038194 : 9D 40 15    ;
CODE_038197:          JSL.L LoadSpriteTables              ;; 038197 : 22 8B F7 07 ;
CODE_03819B:          INC.W $1534,X                       ;; 03819B : FE 34 15    ;
CODE_03819E:          LDA.W $1534,X                       ;; 03819E : BD 34 15    ;
CODE_0381A1:          CMP.B #$03                          ;; 0381A1 : C9 03       ;
CODE_0381A3:          BNE Return0381AD                    ;; 0381A3 : D0 08       ;
CODE_0381A5:          LDA.B #$06                          ;; 0381A5 : A9 06       ;
CODE_0381A7:          STA RAM_SpriteState,X               ;; 0381A7 : 95 C2       ;
CODE_0381A9:          JSL.L KillMostSprites               ;; 0381A9 : 22 C8 A6 03 ;
Return0381AD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381AE:          AND.B #$0E                          ;; 0381AE : 29 0E       ;
CODE_0381B0:          EOR.W RAM_SpritePal,X               ;; 0381B0 : 5D F6 15    ;
CODE_0381B3:          STA.W RAM_SpritePal,X               ;; 0381B3 : 9D F6 15    ;
CODE_0381B6:          LDA.B #$03                          ;; 0381B6 : A9 03       ;
CODE_0381B8:          STA.W $1602,X                       ;; 0381B8 : 9D 02 16    ;
Return0381BB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381BC:          LDA.W $1540,X                       ;; 0381BC : BD 40 15    ;
CODE_0381BF:          BNE Return0381D2                    ;; 0381BF : D0 11       ;
CODE_0381C1:          LDA.B #$08                          ;; 0381C1 : A9 08       ;
CODE_0381C3:          STA.W $1540,X                       ;; 0381C3 : 9D 40 15    ;
CODE_0381C6:          DEC.W $190B                         ;; 0381C6 : CE 0B 19    ;
CODE_0381C9:          BNE Return0381D2                    ;; 0381C9 : D0 07       ;
CODE_0381CB:          INC RAM_SpriteState,X               ;; 0381CB : F6 C2       ;
CODE_0381CD:          LDA.B #$C0                          ;; 0381CD : A9 C0       ;
CODE_0381CF:          STA.W $1540,X                       ;; 0381CF : 9D 40 15    ;
Return0381D2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381D3:          LDA.B #$02                          ;; 0381D3 : A9 02       ; \ Sprite status = Killed 
CODE_0381D5:          STA.W $14C8,X                       ;; 0381D5 : 9D C8 14    ; / 
CODE_0381D8:          STZ RAM_SpriteSpeedX,X              ;; 0381D8 : 74 B6       ; Sprite X Speed = 0 
CODE_0381DA:          LDA.B #$D0                          ;; 0381DA : A9 D0       ;
CODE_0381DC:          STA RAM_SpriteSpeedY,X              ;; 0381DC : 95 AA       ;
CODE_0381DE:          LDA.B #$23                          ;; 0381DE : A9 23       ; \ Play sound effect 
CODE_0381E0:          STA.W $1DF9                         ;; 0381E0 : 8D F9 1D    ; / 
Return0381E3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381E4:          LDY.B #$0B                          ;; 0381E4 : A0 0B       ;
CODE_0381E6:          LDA.W $14C8,Y                       ;; 0381E6 : B9 C8 14    ;
CODE_0381E9:          CMP.B #$09                          ;; 0381E9 : C9 09       ;
CODE_0381EB:          BEQ CODE_0381F5                     ;; 0381EB : F0 08       ;
CODE_0381ED:          CMP.B #$0A                          ;; 0381ED : C9 0A       ;
CODE_0381EF:          BEQ CODE_0381F5                     ;; 0381EF : F0 04       ;
CODE_0381F1:          DEY                                 ;; 0381F1 : 88          ;
CODE_0381F2:          BPL CODE_0381E6                     ;; 0381F2 : 10 F2       ;
Return0381F4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381F5:          PHX                                 ;; 0381F5 : DA          ;
CODE_0381F6:          TYX                                 ;; 0381F6 : BB          ;
CODE_0381F7:          JSL.L GetSpriteClippingB            ;; 0381F7 : 22 E5 B6 03 ;
CODE_0381FB:          PLX                                 ;; 0381FB : FA          ;
CODE_0381FC:          JSL.L GetSpriteClippingA            ;; 0381FC : 22 9F B6 03 ;
CODE_038200:          JSL.L CheckForContact               ;; 038200 : 22 2B B7 03 ;
CODE_038204:          BCC CODE_0381F1                     ;; 038204 : 90 EB       ;
CODE_038206:          LDA.B #$03                          ;; 038206 : A9 03       ;
CODE_038208:          STA RAM_SpriteState,X               ;; 038208 : 95 C2       ;
CODE_03820A:          LDA.B #$40                          ;; 03820A : A9 40       ;
CODE_03820C:          STA.W $1540,X                       ;; 03820C : 9D 40 15    ;
CODE_03820F:          PHX                                 ;; 03820F : DA          ;
CODE_038210:          TYX                                 ;; 038210 : BB          ;
CODE_038211:          STZ.W $14C8,X                       ;; 038211 : 9E C8 14    ;
CODE_038214:          LDA RAM_SpriteXLo,X                 ;; 038214 : B5 E4       ;
CODE_038216:          STA RAM_BlockYLo                    ;; 038216 : 85 9A       ;
CODE_038218:          LDA.W RAM_SpriteXHi,X               ;; 038218 : BD E0 14    ;
CODE_03821B:          STA RAM_BlockYHi                    ;; 03821B : 85 9B       ;
CODE_03821D:          LDA RAM_SpriteYLo,X                 ;; 03821D : B5 D8       ;
CODE_03821F:          STA RAM_BlockXLo                    ;; 03821F : 85 98       ;
CODE_038221:          LDA.W RAM_SpriteYHi,X               ;; 038221 : BD D4 14    ;
CODE_038224:          STA RAM_BlockXHi                    ;; 038224 : 85 99       ;
CODE_038226:          PHB                                 ;; 038226 : 8B          ;
CODE_038227:          LDA.B #$02                          ;; 038227 : A9 02       ;
CODE_038229:          PHA                                 ;; 038229 : 48          ;
CODE_03822A:          PLB                                 ;; 03822A : AB          ;
CODE_03822B:          LDA.B #$FF                          ;; 03822B : A9 FF       ;
CODE_03822D:          JSL.L ShatterBlock                  ;; 03822D : 22 63 86 02 ;
CODE_038231:          PLB                                 ;; 038231 : AB          ;
CODE_038232:          PLX                                 ;; 038232 : FA          ;
CODE_038233:          LDA.B #$28                          ;; 038233 : A9 28       ; \ Play sound effect 
CODE_038235:          STA.W $1DFC                         ;; 038235 : 8D FC 1D    ; / 
Return038238:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038239:          LDY.B #$24                          ;; 038239 : A0 24       ;
CODE_03823B:          STY $40                             ;; 03823B : 84 40       ;
CODE_03823D:          LDA.W $190B                         ;; 03823D : AD 0B 19    ;
CODE_038240:          CMP.B #$08                          ;; 038240 : C9 08       ;
CODE_038242:          DEC A                               ;; 038242 : 3A          ;
CODE_038243:          BCS CODE_03824A                     ;; 038243 : B0 05       ;
CODE_038245:          LDY.B #$34                          ;; 038245 : A0 34       ;
CODE_038247:          STY $40                             ;; 038247 : 84 40       ;
CODE_038249:          INC A                               ;; 038249 : 1A          ;
CODE_03824A:          ASL                                 ;; 03824A : 0A          ;
CODE_03824B:          ASL                                 ;; 03824B : 0A          ;
CODE_03824C:          ASL                                 ;; 03824C : 0A          ;
CODE_03824D:          ASL                                 ;; 03824D : 0A          ;
CODE_03824E:          TAX                                 ;; 03824E : AA          ;
CODE_03824F:          STZ $00                             ;; 03824F : 64 00       ;
CODE_038251:          LDY.W $0681                         ;; 038251 : AC 81 06    ;
CODE_038254:          LDA.L BooBossPals,X                 ;; 038254 : BF 82 B9 03 ;
CODE_038258:          STA.W $0684,Y                       ;; 038258 : 99 84 06    ;
CODE_03825B:          INY                                 ;; 03825B : C8          ;
CODE_03825C:          INX                                 ;; 03825C : E8          ;
CODE_03825D:          INC $00                             ;; 03825D : E6 00       ;
CODE_03825F:          LDA $00                             ;; 03825F : A5 00       ;
CODE_038261:          CMP.B #$10                          ;; 038261 : C9 10       ;
CODE_038263:          BNE CODE_038254                     ;; 038263 : D0 EF       ;
CODE_038265:          LDX.W $0681                         ;; 038265 : AE 81 06    ;
CODE_038268:          LDA.B #$10                          ;; 038268 : A9 10       ;
CODE_03826A:          STA.W $0682,X                       ;; 03826A : 9D 82 06    ;
CODE_03826D:          LDA.B #$F0                          ;; 03826D : A9 F0       ;
CODE_03826F:          STA.W $0683,X                       ;; 03826F : 9D 83 06    ;
CODE_038272:          STZ.W $0694,X                       ;; 038272 : 9E 94 06    ;
CODE_038275:          TXA                                 ;; 038275 : 8A          ;
CODE_038276:          CLC                                 ;; 038276 : 18          ;
CODE_038277:          ADC.B #$12                          ;; 038277 : 69 12       ;
CODE_038279:          STA.W $0681                         ;; 038279 : 8D 81 06    ;
CODE_03827C:          LDX.W $15E9                         ;; 03827C : AE E9 15    ; X = Sprite index 
Return03827F:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BigBooDispX:          .db $08,$08,$20,$00,$00,$00,$00,$10 ;; ?QPWZ?               ;
                      .db $10,$10,$10,$20,$20,$20,$20,$30 ;; ?QPWZ?               ;
                      .db $30,$30,$30,$FD,$0C,$0C,$27,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$10,$10,$10,$10,$1F ;; ?QPWZ?               ;
                      .db $20,$20,$1F,$2E,$2E,$2C,$2C,$FB ;; ?QPWZ?               ;
                      .db $12,$12,$30,$00,$00,$00,$00,$10 ;; ?QPWZ?               ;
                      .db $10,$10,$10,$1F,$20,$20,$1F,$2E ;; ?QPWZ?               ;
                      .db $2E,$2E,$2E,$F8,$11,$FF,$08,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$10,$10,$10,$10 ;; ?QPWZ?               ;
                      .db $20,$20,$20,$20,$30,$30,$30,$30 ;; ?QPWZ?               ;
BigBooDispY:          .db $12,$22,$18,$00,$10,$20,$30,$00 ;; ?QPWZ?               ;
                      .db $10,$20,$30,$00,$10,$20,$30,$00 ;; ?QPWZ?               ;
                      .db $10,$20,$30,$18,$16,$16,$12,$22 ;; ?QPWZ?               ;
                      .db $00,$10,$20,$30,$00,$10,$20,$30 ;; ?QPWZ?               ;
                      .db $00,$10,$20,$30,$00,$10,$20,$30 ;; ?QPWZ?               ;
BigBooTiles:          .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82 ;; ?QPWZ?               ;
                      .db $A2,$A2,$82,$84,$A4,$C4,$E4,$86 ;; ?QPWZ?               ;
                      .db $A6,$C6,$E6,$E8,$C0,$E0,$E8,$80 ;; ?QPWZ?               ;
                      .db $A0,$A0,$80,$82,$A2,$A2,$82,$84 ;; ?QPWZ?               ;
                      .db $A4,$C4,$E4,$86,$A6,$C6,$E6,$E8 ;; ?QPWZ?               ;
                      .db $C0,$E0,$E8,$80,$A0,$A0,$80,$82 ;; ?QPWZ?               ;
                      .db $A2,$A2,$82,$84,$A4,$A4,$84,$86 ;; ?QPWZ?               ;
                      .db $A6,$A6,$86,$E8,$E8,$E8,$C2,$E2 ;; ?QPWZ?               ;
                      .db $80,$A0,$A0,$80,$82,$A2,$A2,$82 ;; ?QPWZ?               ;
                      .db $84,$A4,$C4,$E4,$86,$A6,$C6,$E6 ;; ?QPWZ?               ;
BigBooGfxProp:        .db $00,$00,$40,$00,$00,$80,$80,$00 ;; ?QPWZ?               ;
                      .db $00,$80,$80,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$40,$00 ;; ?QPWZ?               ;
                      .db $00,$80,$80,$00,$00,$80,$80,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$40,$00,$00,$80,$80,$00 ;; ?QPWZ?               ;
                      .db $00,$80,$80,$00,$00,$80,$80,$00 ;; ?QPWZ?               ;
                      .db $00,$80,$80,$00,$00,$40,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$80,$80,$00,$00,$80,$80 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038398:          PHB                                 ;; 038398 : 8B          ; Wrapper 
CODE_038399:          PHK                                 ;; 038399 : 4B          ;
CODE_03839A:          PLB                                 ;; 03839A : AB          ;
CODE_03839B:          JSR.W CODE_0383A0                   ;; 03839B : 20 A0 83    ;
CODE_03839E:          PLB                                 ;; 03839E : AB          ;
Return03839F:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_0383A0:          LDA RAM_SpriteNum,X                 ;; 0383A0 : B5 9E       ;
CODE_0383A2:          CMP.B #$37                          ;; 0383A2 : C9 37       ;
CODE_0383A4:          BNE CODE_0383C2                     ;; 0383A4 : D0 1C       ;
CODE_0383A6:          LDA.B #$00                          ;; 0383A6 : A9 00       ;
CODE_0383A8:          LDY RAM_SpriteState,X               ;; 0383A8 : B4 C2       ;
CODE_0383AA:          BEQ CODE_0383BA                     ;; 0383AA : F0 0E       ;
CODE_0383AC:          LDA.B #$06                          ;; 0383AC : A9 06       ;
CODE_0383AE:          LDY.W $1558,X                       ;; 0383AE : BC 58 15    ;
CODE_0383B1:          BEQ CODE_0383BA                     ;; 0383B1 : F0 07       ;
CODE_0383B3:          TYA                                 ;; 0383B3 : 98          ;
CODE_0383B4:          AND.B #$04                          ;; 0383B4 : 29 04       ;
CODE_0383B6:          LSR                                 ;; 0383B6 : 4A          ;
CODE_0383B7:          LSR                                 ;; 0383B7 : 4A          ;
CODE_0383B8:          ADC.B #$02                          ;; 0383B8 : 69 02       ;
CODE_0383BA:          STA.W $1602,X                       ;; 0383BA : 9D 02 16    ;
CODE_0383BD:          JSL.L GenericSprGfxRt2              ;; 0383BD : 22 B2 90 01 ;
Return0383C1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0383C2:          JSR.W GetDrawInfoBnk3               ;; 0383C2 : 20 60 B7    ;
CODE_0383C5:          LDA.W $1602,X                       ;; 0383C5 : BD 02 16    ;
CODE_0383C8:          STA $06                             ;; 0383C8 : 85 06       ;
CODE_0383CA:          ASL                                 ;; 0383CA : 0A          ;
CODE_0383CB:          ASL                                 ;; 0383CB : 0A          ;
CODE_0383CC:          STA $03                             ;; 0383CC : 85 03       ;
CODE_0383CE:          ASL                                 ;; 0383CE : 0A          ;
CODE_0383CF:          ASL                                 ;; 0383CF : 0A          ;
CODE_0383D0:          ADC $03                             ;; 0383D0 : 65 03       ;
CODE_0383D2:          STA $02                             ;; 0383D2 : 85 02       ;
CODE_0383D4:          LDA.W RAM_SpriteDir,X               ;; 0383D4 : BD 7C 15    ;
CODE_0383D7:          STA $04                             ;; 0383D7 : 85 04       ;
CODE_0383D9:          LDA.W RAM_SpritePal,X               ;; 0383D9 : BD F6 15    ;
CODE_0383DC:          STA $05                             ;; 0383DC : 85 05       ;
CODE_0383DE:          LDX.B #$00                          ;; 0383DE : A2 00       ;
CODE_0383E0:          PHX                                 ;; 0383E0 : DA          ;
CODE_0383E1:          LDX $02                             ;; 0383E1 : A6 02       ;
CODE_0383E3:          LDA.W BigBooTiles,X                 ;; 0383E3 : BD F8 82    ;
CODE_0383E6:          STA.W OAM_Tile,Y                    ;; 0383E6 : 99 02 03    ;
CODE_0383E9:          LDA $04                             ;; 0383E9 : A5 04       ;
CODE_0383EB:          LSR                                 ;; 0383EB : 4A          ;
CODE_0383EC:          LDA.W BigBooGfxProp,X               ;; 0383EC : BD 48 83    ;
CODE_0383EF:          ORA $05                             ;; 0383EF : 05 05       ;
CODE_0383F1:          BCS CODE_0383F5                     ;; 0383F1 : B0 02       ;
CODE_0383F3:          EOR.B #$40                          ;; 0383F3 : 49 40       ;
CODE_0383F5:          ORA $64                             ;; 0383F5 : 05 64       ;
CODE_0383F7:          STA.W OAM_Prop,Y                    ;; 0383F7 : 99 03 03    ;
CODE_0383FA:          LDA.W BigBooDispX,X                 ;; 0383FA : BD 80 82    ;
CODE_0383FD:          BCS CODE_038405                     ;; 0383FD : B0 06       ;
CODE_0383FF:          EOR.B #$FF                          ;; 0383FF : 49 FF       ;
CODE_038401:          INC A                               ;; 038401 : 1A          ;
CODE_038402:          CLC                                 ;; 038402 : 18          ;
CODE_038403:          ADC.B #$28                          ;; 038403 : 69 28       ;
CODE_038405:          CLC                                 ;; 038405 : 18          ;
CODE_038406:          ADC $00                             ;; 038406 : 65 00       ;
CODE_038408:          STA.W OAM_DispX,Y                   ;; 038408 : 99 00 03    ;
CODE_03840B:          PLX                                 ;; 03840B : FA          ;
CODE_03840C:          PHX                                 ;; 03840C : DA          ;
CODE_03840D:          LDA $06                             ;; 03840D : A5 06       ;
CODE_03840F:          CMP.B #$03                          ;; 03840F : C9 03       ;
CODE_038411:          BCC CODE_038418                     ;; 038411 : 90 05       ;
CODE_038413:          TXA                                 ;; 038413 : 8A          ;
CODE_038414:          CLC                                 ;; 038414 : 18          ;
CODE_038415:          ADC.B #$14                          ;; 038415 : 69 14       ;
CODE_038417:          TAX                                 ;; 038417 : AA          ;
CODE_038418:          LDA $01                             ;; 038418 : A5 01       ;
CODE_03841A:          CLC                                 ;; 03841A : 18          ;
CODE_03841B:          ADC.W BigBooDispY,X                 ;; 03841B : 7D D0 82    ;
CODE_03841E:          STA.W OAM_DispY,Y                   ;; 03841E : 99 01 03    ;
CODE_038421:          PLX                                 ;; 038421 : FA          ;
CODE_038422:          INY                                 ;; 038422 : C8          ;
CODE_038423:          INY                                 ;; 038423 : C8          ;
CODE_038424:          INY                                 ;; 038424 : C8          ;
CODE_038425:          INY                                 ;; 038425 : C8          ;
CODE_038426:          INC $02                             ;; 038426 : E6 02       ;
CODE_038428:          INX                                 ;; 038428 : E8          ;
CODE_038429:          CPX.B #$14                          ;; 038429 : E0 14       ;
CODE_03842B:          BNE CODE_0383E0                     ;; 03842B : D0 B3       ;
CODE_03842D:          LDX.W $15E9                         ;; 03842D : AE E9 15    ; X = Sprite index 
CODE_038430:          LDA.W $1602,X                       ;; 038430 : BD 02 16    ;
CODE_038433:          CMP.B #$03                          ;; 038433 : C9 03       ;
CODE_038435:          BNE CODE_03844B                     ;; 038435 : D0 14       ;
CODE_038437:          LDA.W $1558,X                       ;; 038437 : BD 58 15    ;
CODE_03843A:          BEQ CODE_03844B                     ;; 03843A : F0 0F       ;
ADDR_03843C:          LDY.W RAM_SprOAMIndex,X             ;; 03843C : BC EA 15    ; Y = Index into sprite OAM 
ADDR_03843F:          LDA.W OAM_DispY,Y                   ;; 03843F : B9 01 03    ;
ADDR_038442:          CLC                                 ;; 038442 : 18          ;
ADDR_038443:          ADC.B #$05                          ;; 038443 : 69 05       ;
ADDR_038445:          STA.W OAM_DispY,Y                   ;; 038445 : 99 01 03    ;
ADDR_038448:          STA.W OAM_Tile2DispY,Y              ;; 038448 : 99 05 03    ;
CODE_03844B:          LDA.B #$13                          ;; 03844B : A9 13       ;
CODE_03844D:          LDY.B #$02                          ;; 03844D : A0 02       ;
CODE_03844F:          JSL.L FinishOAMWrite                ;; 03844F : 22 B3 B7 01 ;
Return038453:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GreyFallingPlat:      JSR.W CODE_038492                   ;; ?QPWZ? : 20 92 84    ;
CODE_038457:          LDA RAM_SpritesLocked               ;; 038457 : A5 9D       ;
CODE_038459:          BNE Return038489                    ;; 038459 : D0 2E       ;
CODE_03845B:          JSR.W SubOffscreen0Bnk3             ;; 03845B : 20 5D B8    ;
CODE_03845E:          LDA RAM_SpriteSpeedY,X              ;; 03845E : B5 AA       ;
CODE_038460:          BEQ CODE_038476                     ;; 038460 : F0 14       ;
CODE_038462:          LDA.W $1540,X                       ;; 038462 : BD 40 15    ;
CODE_038465:          BNE CODE_038472                     ;; 038465 : D0 0B       ;
CODE_038467:          LDA RAM_SpriteSpeedY,X              ;; 038467 : B5 AA       ;
CODE_038469:          CMP.B #$40                          ;; 038469 : C9 40       ;
CODE_03846B:          BPL CODE_038472                     ;; 03846B : 10 05       ;
CODE_03846D:          CLC                                 ;; 03846D : 18          ;
CODE_03846E:          ADC.B #$02                          ;; 03846E : 69 02       ;
CODE_038470:          STA RAM_SpriteSpeedY,X              ;; 038470 : 95 AA       ;
CODE_038472:          JSL.L UpdateYPosNoGrvty             ;; 038472 : 22 1A 80 01 ;
CODE_038476:          JSL.L InvisBlkMainRt                ;; 038476 : 22 4F B4 01 ;
CODE_03847A:          BCC Return038489                    ;; 03847A : 90 0D       ;
CODE_03847C:          LDA RAM_SpriteSpeedY,X              ;; 03847C : B5 AA       ;
CODE_03847E:          BNE Return038489                    ;; 03847E : D0 09       ;
CODE_038480:          LDA.B #$03                          ;; 038480 : A9 03       ;
CODE_038482:          STA RAM_SpriteSpeedY,X              ;; 038482 : 95 AA       ;
CODE_038484:          LDA.B #$18                          ;; 038484 : A9 18       ;
CODE_038486:          STA.W $1540,X                       ;; 038486 : 9D 40 15    ;
Return038489:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FallingPlatDispX:     .db $00,$10,$20,$30                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FallingPlatTiles:     .db $60,$61,$61,$62                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038492:          JSR.W GetDrawInfoBnk3               ;; 038492 : 20 60 B7    ;
CODE_038495:          PHX                                 ;; 038495 : DA          ;
CODE_038496:          LDX.B #$03                          ;; 038496 : A2 03       ;
CODE_038498:          LDA $00                             ;; 038498 : A5 00       ;
CODE_03849A:          CLC                                 ;; 03849A : 18          ;
CODE_03849B:          ADC.W FallingPlatDispX,X            ;; 03849B : 7D 8A 84    ;
CODE_03849E:          STA.W OAM_DispX,Y                   ;; 03849E : 99 00 03    ;
CODE_0384A1:          LDA $01                             ;; 0384A1 : A5 01       ;
CODE_0384A3:          STA.W OAM_DispY,Y                   ;; 0384A3 : 99 01 03    ;
CODE_0384A6:          LDA.W FallingPlatTiles,X            ;; 0384A6 : BD 8E 84    ;
CODE_0384A9:          STA.W OAM_Tile,Y                    ;; 0384A9 : 99 02 03    ;
CODE_0384AC:          LDA.B #$03                          ;; 0384AC : A9 03       ;
CODE_0384AE:          ORA $64                             ;; 0384AE : 05 64       ;
CODE_0384B0:          STA.W OAM_Prop,Y                    ;; 0384B0 : 99 03 03    ;
CODE_0384B3:          INY                                 ;; 0384B3 : C8          ;
CODE_0384B4:          INY                                 ;; 0384B4 : C8          ;
CODE_0384B5:          INY                                 ;; 0384B5 : C8          ;
CODE_0384B6:          INY                                 ;; 0384B6 : C8          ;
CODE_0384B7:          DEX                                 ;; 0384B7 : CA          ;
CODE_0384B8:          BPL CODE_038498                     ;; 0384B8 : 10 DE       ;
CODE_0384BA:          PLX                                 ;; 0384BA : FA          ;
CODE_0384BB:          LDY.B #$02                          ;; 0384BB : A0 02       ;
CODE_0384BD:          LDA.B #$03                          ;; 0384BD : A9 03       ;
CODE_0384BF:          JSL.L FinishOAMWrite                ;; 0384BF : 22 B3 B7 01 ;
Return0384C3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BlurpMaxSpeedY:       .db $04,$FC                         ;; ?QPWZ?               ;
                                                          ;;                      ;
BlurpSpeedX:          .db $08,$F8                         ;; ?QPWZ?               ;
                                                          ;;                      ;
BlurpAccelY:          .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
Blurp:                JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_0384CE:          LDY.W RAM_SprOAMIndex,X             ;; 0384CE : BC EA 15    ; Y = Index into sprite OAM 
CODE_0384D1:          LDA.W RAM_FrameCounterB             ;; 0384D1 : AD 14 00    ;
CODE_0384D4:          LSR                                 ;; 0384D4 : 4A          ;
CODE_0384D5:          LSR                                 ;; 0384D5 : 4A          ;
CODE_0384D6:          LSR                                 ;; 0384D6 : 4A          ;
CODE_0384D7:          CLC                                 ;; 0384D7 : 18          ;
CODE_0384D8:          ADC.W $15E9                         ;; 0384D8 : 6D E9 15    ;
CODE_0384DB:          LSR                                 ;; 0384DB : 4A          ;
CODE_0384DC:          LDA.B #$A2                          ;; 0384DC : A9 A2       ;
CODE_0384DE:          BCC CODE_0384E2                     ;; 0384DE : 90 02       ;
CODE_0384E0:          LDA.B #$EC                          ;; 0384E0 : A9 EC       ;
CODE_0384E2:          STA.W OAM_Tile,Y                    ;; 0384E2 : 99 02 03    ;
CODE_0384E5:          LDA.W $14C8,X                       ;; 0384E5 : BD C8 14    ;
CODE_0384E8:          CMP.B #$08                          ;; 0384E8 : C9 08       ;
CODE_0384EA:          BEQ CODE_0384F5                     ;; 0384EA : F0 09       ;
CODE_0384EC:          LDA.W OAM_Prop,Y                    ;; 0384EC : B9 03 03    ;
CODE_0384EF:          ORA.B #$80                          ;; 0384EF : 09 80       ;
CODE_0384F1:          STA.W OAM_Prop,Y                    ;; 0384F1 : 99 03 03    ;
Return0384F4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0384F5:          LDA RAM_SpritesLocked               ;; 0384F5 : A5 9D       ;
CODE_0384F7:          BNE Return03852A                    ;; 0384F7 : D0 31       ;
CODE_0384F9:          JSR.W SubOffscreen0Bnk3             ;; 0384F9 : 20 5D B8    ;
CODE_0384FC:          LDA RAM_FrameCounterB               ;; 0384FC : A5 14       ;
CODE_0384FE:          AND.B #$03                          ;; 0384FE : 29 03       ;
CODE_038500:          BNE CODE_038516                     ;; 038500 : D0 14       ;
CODE_038502:          LDA RAM_SpriteState,X               ;; 038502 : B5 C2       ;
CODE_038504:          AND.B #$01                          ;; 038504 : 29 01       ;
CODE_038506:          TAY                                 ;; 038506 : A8          ;
CODE_038507:          LDA RAM_SpriteSpeedY,X              ;; 038507 : B5 AA       ;
CODE_038509:          CLC                                 ;; 038509 : 18          ;
CODE_03850A:          ADC.W BlurpAccelY,Y                 ;; 03850A : 79 C8 84    ;
CODE_03850D:          STA RAM_SpriteSpeedY,X              ;; 03850D : 95 AA       ;
CODE_03850F:          CMP.W BlurpMaxSpeedY,Y              ;; 03850F : D9 C4 84    ;
CODE_038512:          BNE CODE_038516                     ;; 038512 : D0 02       ;
CODE_038514:          INC RAM_SpriteState,X               ;; 038514 : F6 C2       ;
CODE_038516:          LDY.W RAM_SpriteDir,X               ;; 038516 : BC 7C 15    ;
CODE_038519:          LDA.W BlurpSpeedX,Y                 ;; 038519 : B9 C6 84    ;
CODE_03851C:          STA RAM_SpriteSpeedX,X              ;; 03851C : 95 B6       ;
CODE_03851E:          JSL.L UpdateXPosNoGrvty             ;; 03851E : 22 22 80 01 ;
CODE_038522:          JSL.L UpdateYPosNoGrvty             ;; 038522 : 22 1A 80 01 ;
CODE_038526:          JSL.L SprSpr+MarioSprRts            ;; 038526 : 22 3A 80 01 ;
Return03852A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
PorcuPuffAccel:       .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
PorcuPuffMaxSpeed:    .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
PorcuPuffer:          JSR.W CODE_0385A3                   ;; ?QPWZ? : 20 A3 85    ;
CODE_038532:          LDA RAM_SpritesLocked               ;; 038532 : A5 9D       ;
CODE_038534:          BNE Return038586                    ;; 038534 : D0 50       ;
CODE_038536:          LDA.W $14C8,X                       ;; 038536 : BD C8 14    ;
CODE_038539:          CMP.B #$08                          ;; 038539 : C9 08       ;
CODE_03853B:          BNE Return038586                    ;; 03853B : D0 49       ;
CODE_03853D:          JSR.W SubOffscreen0Bnk3             ;; 03853D : 20 5D B8    ;
CODE_038540:          JSL.L SprSpr+MarioSprRts            ;; 038540 : 22 3A 80 01 ;
CODE_038544:          JSR.W SubHorzPosBnk3                ;; 038544 : 20 17 B8    ;
CODE_038547:          TYA                                 ;; 038547 : 98          ;
CODE_038548:          STA.W RAM_SpriteDir,X               ;; 038548 : 9D 7C 15    ;
CODE_03854B:          LDA RAM_FrameCounterB               ;; 03854B : A5 14       ;
CODE_03854D:          AND.B #$03                          ;; 03854D : 29 03       ;
CODE_03854F:          BNE CODE_03855E                     ;; 03854F : D0 0D       ;
CODE_038551:          LDA RAM_SpriteSpeedX,X              ;; 038551 : B5 B6       ; \ Branch if at max speed 
CODE_038553:          CMP.W PorcuPuffMaxSpeed,Y           ;; 038553 : D9 2D 85    ;  | 
CODE_038556:          BEQ CODE_03855E                     ;; 038556 : F0 06       ; / 
CODE_038558:          CLC                                 ;; 038558 : 18          ; \ Otherwise, accelerate 
CODE_038559:          ADC.W PorcuPuffAccel,Y              ;; 038559 : 79 2B 85    ;  | 
CODE_03855C:          STA RAM_SpriteSpeedX,X              ;; 03855C : 95 B6       ; / 
CODE_03855E:          LDA RAM_SpriteSpeedX,X              ;; 03855E : B5 B6       ;
CODE_038560:          PHA                                 ;; 038560 : 48          ;
CODE_038561:          LDA.W $17BD                         ;; 038561 : AD BD 17    ;
CODE_038564:          ASL                                 ;; 038564 : 0A          ;
CODE_038565:          ASL                                 ;; 038565 : 0A          ;
CODE_038566:          ASL                                 ;; 038566 : 0A          ;
CODE_038567:          CLC                                 ;; 038567 : 18          ;
CODE_038568:          ADC RAM_SpriteSpeedX,X              ;; 038568 : 75 B6       ;
CODE_03856A:          STA RAM_SpriteSpeedX,X              ;; 03856A : 95 B6       ;
CODE_03856C:          JSL.L UpdateXPosNoGrvty             ;; 03856C : 22 22 80 01 ;
CODE_038570:          PLA                                 ;; 038570 : 68          ;
CODE_038571:          STA RAM_SpriteSpeedX,X              ;; 038571 : 95 B6       ;
CODE_038573:          JSL.L CODE_019138                   ;; 038573 : 22 38 91 01 ;
CODE_038577:          LDY.B #$04                          ;; 038577 : A0 04       ;
CODE_038579:          LDA.W $164A,X                       ;; 038579 : BD 4A 16    ;
CODE_03857C:          BEQ CODE_038580                     ;; 03857C : F0 02       ;
CODE_03857E:          LDY.B #$FC                          ;; 03857E : A0 FC       ;
CODE_038580:          STY RAM_SpriteSpeedY,X              ;; 038580 : 94 AA       ;
CODE_038582:          JSL.L UpdateYPosNoGrvty             ;; 038582 : 22 1A 80 01 ;
Return038586:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
PocruPufferDispX:     .db $F8,$08,$F8,$08,$08,$F8,$08,$F8 ;; ?QPWZ?               ;
PocruPufferDispY:     .db $F8,$F8,$08,$08                 ;; ?QPWZ?               ;
                                                          ;;                      ;
PocruPufferTiles:     .db $86,$C0,$A6,$C2,$86,$C0,$A6,$8A ;; ?QPWZ?               ;
PocruPufferGfxProp:   .db $0D,$0D,$0D,$0D,$4D,$4D,$4D,$4D ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_0385A3:          JSR.W GetDrawInfoBnk3               ;; 0385A3 : 20 60 B7    ;
CODE_0385A6:          LDA RAM_FrameCounterB               ;; 0385A6 : A5 14       ;
CODE_0385A8:          AND.B #$04                          ;; 0385A8 : 29 04       ;
CODE_0385AA:          STA $03                             ;; 0385AA : 85 03       ;
CODE_0385AC:          LDA.W RAM_SpriteDir,X               ;; 0385AC : BD 7C 15    ;
CODE_0385AF:          STA $02                             ;; 0385AF : 85 02       ;
CODE_0385B1:          PHX                                 ;; 0385B1 : DA          ;
CODE_0385B2:          LDX.B #$03                          ;; 0385B2 : A2 03       ;
CODE_0385B4:          LDA $01                             ;; 0385B4 : A5 01       ;
CODE_0385B6:          CLC                                 ;; 0385B6 : 18          ;
CODE_0385B7:          ADC.W PocruPufferDispY,X            ;; 0385B7 : 7D 8F 85    ;
CODE_0385BA:          STA.W OAM_DispY,Y                   ;; 0385BA : 99 01 03    ;
CODE_0385BD:          PHX                                 ;; 0385BD : DA          ;
CODE_0385BE:          LDA $02                             ;; 0385BE : A5 02       ;
CODE_0385C0:          BNE CODE_0385C6                     ;; 0385C0 : D0 04       ;
CODE_0385C2:          TXA                                 ;; 0385C2 : 8A          ;
CODE_0385C3:          ORA.B #$04                          ;; 0385C3 : 09 04       ;
CODE_0385C5:          TAX                                 ;; 0385C5 : AA          ;
CODE_0385C6:          LDA $00                             ;; 0385C6 : A5 00       ;
CODE_0385C8:          CLC                                 ;; 0385C8 : 18          ;
CODE_0385C9:          ADC.W PocruPufferDispX,X            ;; 0385C9 : 7D 87 85    ;
CODE_0385CC:          STA.W OAM_DispX,Y                   ;; 0385CC : 99 00 03    ;
CODE_0385CF:          LDA.W PocruPufferGfxProp,X          ;; 0385CF : BD 9B 85    ;
CODE_0385D2:          ORA $64                             ;; 0385D2 : 05 64       ;
CODE_0385D4:          STA.W OAM_Prop,Y                    ;; 0385D4 : 99 03 03    ;
CODE_0385D7:          PLA                                 ;; 0385D7 : 68          ;
CODE_0385D8:          PHA                                 ;; 0385D8 : 48          ;
CODE_0385D9:          ORA $03                             ;; 0385D9 : 05 03       ;
CODE_0385DB:          TAX                                 ;; 0385DB : AA          ;
CODE_0385DC:          LDA.W PocruPufferTiles,X            ;; 0385DC : BD 93 85    ;
CODE_0385DF:          STA.W OAM_Tile,Y                    ;; 0385DF : 99 02 03    ;
CODE_0385E2:          PLX                                 ;; 0385E2 : FA          ;
CODE_0385E3:          INY                                 ;; 0385E3 : C8          ;
CODE_0385E4:          INY                                 ;; 0385E4 : C8          ;
CODE_0385E5:          INY                                 ;; 0385E5 : C8          ;
CODE_0385E6:          INY                                 ;; 0385E6 : C8          ;
CODE_0385E7:          DEX                                 ;; 0385E7 : CA          ;
CODE_0385E8:          BPL CODE_0385B4                     ;; 0385E8 : 10 CA       ;
CODE_0385EA:          PLX                                 ;; 0385EA : FA          ;
CODE_0385EB:          LDY.B #$02                          ;; 0385EB : A0 02       ;
CODE_0385ED:          LDA.B #$03                          ;; 0385ED : A9 03       ;
CODE_0385EF:          JSL.L FinishOAMWrite                ;; 0385EF : 22 B3 B7 01 ;
Return0385F3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FlyingBlockSpeedY:    .db $08,$F8                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FlyingTurnBlocks:     JSR.W CODE_0386A8                   ;; ?QPWZ? : 20 A8 86    ;
CODE_0385F9:          LDA RAM_SpritesLocked               ;; 0385F9 : A5 9D       ;
CODE_0385FB:          BNE Return038675                    ;; 0385FB : D0 78       ;
CODE_0385FD:          LDA.W $1B9A                         ;; 0385FD : AD 9A 1B    ;
CODE_038600:          BEQ CODE_038629                     ;; 038600 : F0 27       ;
CODE_038602:          LDA.W $1534,X                       ;; 038602 : BD 34 15    ;
CODE_038605:          INC.W $1534,X                       ;; 038605 : FE 34 15    ;
CODE_038608:          AND.B #$01                          ;; 038608 : 29 01       ;
CODE_03860A:          BNE CODE_03861E                     ;; 03860A : D0 12       ;
CODE_03860C:          DEC.W $1602,X                       ;; 03860C : DE 02 16    ;
CODE_03860F:          LDA.W $1602,X                       ;; 03860F : BD 02 16    ;
CODE_038612:          CMP.B #$FF                          ;; 038612 : C9 FF       ;
CODE_038614:          BNE CODE_03861E                     ;; 038614 : D0 08       ;
CODE_038616:          LDA.B #$FF                          ;; 038616 : A9 FF       ;
CODE_038618:          STA.W $1602,X                       ;; 038618 : 9D 02 16    ;
CODE_03861B:          INC.W RAM_SpriteDir,X               ;; 03861B : FE 7C 15    ;
CODE_03861E:          LDA.W RAM_SpriteDir,X               ;; 03861E : BD 7C 15    ;
CODE_038621:          AND.B #$01                          ;; 038621 : 29 01       ;
CODE_038623:          TAY                                 ;; 038623 : A8          ;
CODE_038624:          LDA.W FlyingBlockSpeedY,Y           ;; 038624 : B9 F4 85    ;
CODE_038627:          STA RAM_SpriteSpeedY,X              ;; 038627 : 95 AA       ;
CODE_038629:          LDA RAM_SpriteSpeedY,X              ;; 038629 : B5 AA       ;
CODE_03862B:          PHA                                 ;; 03862B : 48          ;
CODE_03862C:          LDY.W $151C,X                       ;; 03862C : BC 1C 15    ;
CODE_03862F:          BNE CODE_038636                     ;; 03862F : D0 05       ;
CODE_038631:          EOR.B #$FF                          ;; 038631 : 49 FF       ;
CODE_038633:          INC A                               ;; 038633 : 1A          ;
CODE_038634:          STA RAM_SpriteSpeedY,X              ;; 038634 : 95 AA       ;
CODE_038636:          JSL.L UpdateYPosNoGrvty             ;; 038636 : 22 1A 80 01 ;
CODE_03863A:          PLA                                 ;; 03863A : 68          ;
CODE_03863B:          STA RAM_SpriteSpeedY,X              ;; 03863B : 95 AA       ;
CODE_03863D:          LDA.W $1B9A                         ;; 03863D : AD 9A 1B    ;
CODE_038640:          STA RAM_SpriteSpeedX,X              ;; 038640 : 95 B6       ;
CODE_038642:          JSL.L UpdateXPosNoGrvty             ;; 038642 : 22 22 80 01 ;
CODE_038646:          STA.W $1528,X                       ;; 038646 : 9D 28 15    ;
CODE_038649:          JSL.L InvisBlkMainRt                ;; 038649 : 22 4F B4 01 ;
CODE_03864D:          BCC Return038675                    ;; 03864D : 90 26       ;
CODE_03864F:          LDA.W $1B9A                         ;; 03864F : AD 9A 1B    ;
CODE_038652:          BNE Return038675                    ;; 038652 : D0 21       ;
CODE_038654:          LDA.B #$08                          ;; 038654 : A9 08       ;
CODE_038656:          STA.W $1B9A                         ;; 038656 : 8D 9A 1B    ;
CODE_038659:          LDA.B #$7F                          ;; 038659 : A9 7F       ;
CODE_03865B:          STA.W $1602,X                       ;; 03865B : 9D 02 16    ;
CODE_03865E:          LDY.B #$09                          ;; 03865E : A0 09       ;
CODE_038660:          CPY.W $15E9                         ;; 038660 : CC E9 15    ;
CODE_038663:          BEQ CODE_03866C                     ;; 038663 : F0 07       ;
CODE_038665:          LDA.W RAM_SpriteNum,Y               ;; 038665 : B9 9E 00    ;
CODE_038668:          CMP.B #$C1                          ;; 038668 : C9 C1       ;
CODE_03866A:          BEQ CODE_038670                     ;; 03866A : F0 04       ;
CODE_03866C:          DEY                                 ;; 03866C : 88          ;
CODE_03866D:          BPL CODE_038660                     ;; 03866D : 10 F1       ;
ADDR_03866F:          INY                                 ;; 03866F : C8          ;
CODE_038670:          LDA.B #$7F                          ;; 038670 : A9 7F       ;
CODE_038672:          STA.W $1602,Y                       ;; 038672 : 99 02 16    ;
Return038675:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ForestPlatDispX:      .db $00,$10,$20,$F2,$2E,$00,$10,$20 ;; ?QPWZ?               ;
                      .db $FA,$2E                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatDispY:      .db $00,$00,$00,$F6,$F6,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $FE,$FE                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatTiles:      .db $40,$40,$40,$C6,$C6,$40,$40,$40 ;; ?QPWZ?               ;
                      .db $5D,$5D                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatGfxProp:    .db $32,$32,$32,$72,$32,$32,$32,$32 ;; ?QPWZ?               ;
                      .db $72,$32                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatTileSize:   .db $02,$02,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_0386A8:          JSR.W GetDrawInfoBnk3               ;; 0386A8 : 20 60 B7    ;
CODE_0386AB:          LDY.W RAM_SprOAMIndex,X             ;; 0386AB : BC EA 15    ; Y = Index into sprite OAM 
CODE_0386AE:          LDA RAM_FrameCounterB               ;; 0386AE : A5 14       ;
CODE_0386B0:          LSR                                 ;; 0386B0 : 4A          ;
CODE_0386B1:          AND.B #$04                          ;; 0386B1 : 29 04       ;
CODE_0386B3:          BEQ CODE_0386B6                     ;; 0386B3 : F0 01       ;
CODE_0386B5:          INC A                               ;; 0386B5 : 1A          ;
CODE_0386B6:          STA $02                             ;; 0386B6 : 85 02       ;
CODE_0386B8:          PHX                                 ;; 0386B8 : DA          ;
CODE_0386B9:          LDX.B #$04                          ;; 0386B9 : A2 04       ;
CODE_0386BB:          STX $06                             ;; 0386BB : 86 06       ;
CODE_0386BD:          TXA                                 ;; 0386BD : 8A          ;
CODE_0386BE:          CLC                                 ;; 0386BE : 18          ;
CODE_0386BF:          ADC $02                             ;; 0386BF : 65 02       ;
CODE_0386C1:          TAX                                 ;; 0386C1 : AA          ;
CODE_0386C2:          LDA $00                             ;; 0386C2 : A5 00       ;
CODE_0386C4:          CLC                                 ;; 0386C4 : 18          ;
CODE_0386C5:          ADC.W ForestPlatDispX,X             ;; 0386C5 : 7D 76 86    ;
CODE_0386C8:          STA.W OAM_DispX,Y                   ;; 0386C8 : 99 00 03    ;
CODE_0386CB:          LDA $01                             ;; 0386CB : A5 01       ;
CODE_0386CD:          CLC                                 ;; 0386CD : 18          ;
CODE_0386CE:          ADC.W ForestPlatDispY,X             ;; 0386CE : 7D 80 86    ;
CODE_0386D1:          STA.W OAM_DispY,Y                   ;; 0386D1 : 99 01 03    ;
CODE_0386D4:          LDA.W ForestPlatTiles,X             ;; 0386D4 : BD 8A 86    ;
CODE_0386D7:          STA.W OAM_Tile,Y                    ;; 0386D7 : 99 02 03    ;
CODE_0386DA:          LDA.W ForestPlatGfxProp,X           ;; 0386DA : BD 94 86    ;
CODE_0386DD:          STA.W OAM_Prop,Y                    ;; 0386DD : 99 03 03    ;
CODE_0386E0:          PHY                                 ;; 0386E0 : 5A          ;
CODE_0386E1:          TYA                                 ;; 0386E1 : 98          ;
CODE_0386E2:          LSR                                 ;; 0386E2 : 4A          ;
CODE_0386E3:          LSR                                 ;; 0386E3 : 4A          ;
CODE_0386E4:          TAY                                 ;; 0386E4 : A8          ;
CODE_0386E5:          LDA.W ForestPlatTileSize,X          ;; 0386E5 : BD 9E 86    ;
CODE_0386E8:          STA.W OAM_TileSize,Y                ;; 0386E8 : 99 60 04    ;
CODE_0386EB:          PLY                                 ;; 0386EB : 7A          ;
CODE_0386EC:          INY                                 ;; 0386EC : C8          ;
CODE_0386ED:          INY                                 ;; 0386ED : C8          ;
CODE_0386EE:          INY                                 ;; 0386EE : C8          ;
CODE_0386EF:          INY                                 ;; 0386EF : C8          ;
CODE_0386F0:          LDX $06                             ;; 0386F0 : A6 06       ;
CODE_0386F2:          DEX                                 ;; 0386F2 : CA          ;
CODE_0386F3:          BPL CODE_0386BB                     ;; 0386F3 : 10 C6       ;
CODE_0386F5:          PLX                                 ;; 0386F5 : FA          ;
CODE_0386F6:          LDY.B #$FF                          ;; 0386F6 : A0 FF       ;
CODE_0386F8:          LDA.B #$04                          ;; 0386F8 : A9 04       ;
CODE_0386FA:          JSL.L FinishOAMWrite                ;; 0386FA : 22 B3 B7 01 ;
Return0386FE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GrayLavaPlatform:     JSR.W CODE_03873A                   ;; ?QPWZ? : 20 3A 87    ;
CODE_038702:          LDA RAM_SpritesLocked               ;; 038702 : A5 9D       ;
CODE_038704:          BNE Return038733                    ;; 038704 : D0 2D       ;
CODE_038706:          JSR.W SubOffscreen0Bnk3             ;; 038706 : 20 5D B8    ;
CODE_038709:          LDA.W $1540,X                       ;; 038709 : BD 40 15    ;
CODE_03870C:          DEC A                               ;; 03870C : 3A          ;
CODE_03870D:          BNE CODE_03871B                     ;; 03870D : D0 0C       ;
CODE_03870F:          LDY.W RAM_SprIndexInLvl,X           ;; 03870F : BC 1A 16    ; \ 
CODE_038712:          LDA.B #$00                          ;; 038712 : A9 00       ;  | Allow sprite to be reloaded by level loading routine 
CODE_038714:          STA.W RAM_SprLoadStatus,Y           ;; 038714 : 99 38 19    ; / 
CODE_038717:          STZ.W $14C8,X                       ;; 038717 : 9E C8 14    ;
Return03871A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03871B:          JSL.L UpdateYPosNoGrvty             ;; 03871B : 22 1A 80 01 ;
CODE_03871F:          JSL.L InvisBlkMainRt                ;; 03871F : 22 4F B4 01 ;
CODE_038723:          BCC Return038733                    ;; 038723 : 90 0E       ;
CODE_038725:          LDA.W $1540,X                       ;; 038725 : BD 40 15    ;
CODE_038728:          BNE Return038733                    ;; 038728 : D0 09       ;
CODE_03872A:          LDA.B #$06                          ;; 03872A : A9 06       ;
CODE_03872C:          STA RAM_SpriteSpeedY,X              ;; 03872C : 95 AA       ;
CODE_03872E:          LDA.B #$40                          ;; 03872E : A9 40       ;
CODE_038730:          STA.W $1540,X                       ;; 038730 : 9D 40 15    ;
Return038733:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
LavaPlatTiles:        .db $85,$86,$85                     ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_038737:          .db $43,$03,$03                     ;; 038737               ;
                                                          ;;                      ;
CODE_03873A:          JSR.W GetDrawInfoBnk3               ;; 03873A : 20 60 B7    ;
CODE_03873D:          PHX                                 ;; 03873D : DA          ;
CODE_03873E:          LDX.B #$02                          ;; 03873E : A2 02       ;
CODE_038740:          LDA $00                             ;; 038740 : A5 00       ;
CODE_038742:          STA.W OAM_DispX,Y                   ;; 038742 : 99 00 03    ;
CODE_038745:          CLC                                 ;; 038745 : 18          ;
CODE_038746:          ADC.B #$10                          ;; 038746 : 69 10       ;
CODE_038748:          STA $00                             ;; 038748 : 85 00       ;
CODE_03874A:          LDA $01                             ;; 03874A : A5 01       ;
CODE_03874C:          STA.W OAM_DispY,Y                   ;; 03874C : 99 01 03    ;
CODE_03874F:          LDA.W LavaPlatTiles,X               ;; 03874F : BD 34 87    ;
CODE_038752:          STA.W OAM_Tile,Y                    ;; 038752 : 99 02 03    ;
CODE_038755:          LDA.W DATA_038737,X                 ;; 038755 : BD 37 87    ;
CODE_038758:          ORA $64                             ;; 038758 : 05 64       ;
CODE_03875A:          STA.W OAM_Prop,Y                    ;; 03875A : 99 03 03    ;
CODE_03875D:          INY                                 ;; 03875D : C8          ;
CODE_03875E:          INY                                 ;; 03875E : C8          ;
CODE_03875F:          INY                                 ;; 03875F : C8          ;
CODE_038760:          INY                                 ;; 038760 : C8          ;
CODE_038761:          DEX                                 ;; 038761 : CA          ;
CODE_038762:          BPL CODE_038740                     ;; 038762 : 10 DC       ;
CODE_038764:          PLX                                 ;; 038764 : FA          ;
CODE_038765:          LDY.B #$02                          ;; 038765 : A0 02       ;
CODE_038767:          LDA.B #$02                          ;; 038767 : A9 02       ;
CODE_038769:          JSL.L FinishOAMWrite                ;; 038769 : 22 B3 B7 01 ;
Return03876D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MegaMoleSpeed:        .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMole:             JSR.W MegaMoleGfxRt                 ;; ?QPWZ? : 20 3F 88    ; Graphics routine		       
CODE_038773:          LDA.W $14C8,X                       ;; 038773 : BD C8 14    ; \ 			       
CODE_038776:          CMP.B #$08                          ;; 038776 : C9 08       ;  | If status != 8, return	       
CODE_038778:          BNE Return038733                    ;; 038778 : D0 B9       ; /				       
CODE_03877A:          JSR.W SubOffscreen3Bnk3             ;; 03877A : 20 4F B8    ; Handle off screen situation      
CODE_03877D:          LDY.W RAM_SpriteDir,X               ;; 03877D : BC 7C 15    ; \ Set x speed based on direction 
CODE_038780:          LDA.W MegaMoleSpeed,Y               ;; 038780 : B9 6E 87    ;  |			       
CODE_038783:          STA RAM_SpriteSpeedX,X              ;; 038783 : 95 B6       ; /				       
CODE_038785:          LDA RAM_SpritesLocked               ;; 038785 : A5 9D       ; \ If sprites locked, return      
CODE_038787:          BNE Return038733                    ;; 038787 : D0 AA       ; /                                
CODE_038789:          LDA.W RAM_SprObjStatus,X            ;; 038789 : BD 88 15    ;
CODE_03878C:          AND.B #$04                          ;; 03878C : 29 04       ;
CODE_03878E:          PHA                                 ;; 03878E : 48          ;
CODE_03878F:          JSL.L UpdateSpritePos               ;; 03878F : 22 2A 80 01 ; Update position based on speed values 
CODE_038793:          JSL.L SprSprInteract                ;; 038793 : 22 32 80 01 ; Interact with other sprites 
CODE_038797:          LDA.W RAM_SprObjStatus,X            ;; 038797 : BD 88 15    ; \ Branch if not on ground 
CODE_03879A:          AND.B #$04                          ;; 03879A : 29 04       ;  | 
CODE_03879C:          BEQ MegaMoleInAir                   ;; 03879C : F0 05       ; / 
CODE_03879E:          STZ RAM_SpriteSpeedY,X              ;; 03879E : 74 AA       ; Sprite Y Speed = 0 
CODE_0387A0:          PLA                                 ;; 0387A0 : 68          ;
CODE_0387A1:          BRA MegaMoleOnGround                ;; 0387A1 : 80 0F       ;
                                                          ;;                      ;
MegaMoleInAir:        PLA                                 ;; ?QPWZ? : 68          ;
CODE_0387A4:          BEQ MegaMoleWasInAir                ;; 0387A4 : F0 05       ;
CODE_0387A6:          LDA.B #$0A                          ;; 0387A6 : A9 0A       ;
CODE_0387A8:          STA.W $1540,X                       ;; 0387A8 : 9D 40 15    ;
MegaMoleWasInAir:     LDA.W $1540,X                       ;; ?QPWZ? : BD 40 15    ;
CODE_0387AE:          BEQ MegaMoleOnGround                ;; 0387AE : F0 02       ;
CODE_0387B0:          STZ RAM_SpriteSpeedY,X              ;; 0387B0 : 74 AA       ; Sprite Y Speed = 0 
MegaMoleOnGround:     LDY.W $15AC,X                       ;; ?QPWZ? : BC AC 15    ; \								   
CODE_0387B5:          LDA.W RAM_SprObjStatus,X            ;; 0387B5 : BD 88 15    ; | If Mega Mole is in contact with an object...		   
CODE_0387B8:          AND.B #$03                          ;; 0387B8 : 29 03       ; |								   
CODE_0387BA:          BEQ CODE_0387CD                     ;; 0387BA : F0 11       ; |								   
CODE_0387BC:          CPY.B #$00                          ;; 0387BC : C0 00       ; |    ... and timer hasn't been set (time until flip == 0)... 
CODE_0387BE:          BNE CODE_0387C5                     ;; 0387BE : D0 05       ; |								   
CODE_0387C0:          LDA.B #$10                          ;; 0387C0 : A9 10       ; |    ... set time until flip				   
CODE_0387C2:          STA.W $15AC,X                       ;; 0387C2 : 9D AC 15    ; /								   
CODE_0387C5:          LDA.W RAM_SpriteDir,X               ;; 0387C5 : BD 7C 15    ; \ Flip the temp direction status				   
CODE_0387C8:          EOR.B #$01                          ;; 0387C8 : 49 01       ; |								   
CODE_0387CA:          STA.W RAM_SpriteDir,X               ;; 0387CA : 9D 7C 15    ; /								   
CODE_0387CD:          CPY.B #$00                          ;; 0387CD : C0 00       ; \ If time until flip == 0...				   
CODE_0387CF:          BNE CODE_0387D7                     ;; 0387CF : D0 06       ; |								   
CODE_0387D1:          LDA.W RAM_SpriteDir,X               ;; 0387D1 : BD 7C 15    ; |    ...update the direction status used by the gfx routine  
CODE_0387D4:          STA.W $151C,X                       ;; 0387D4 : 9D 1C 15    ; /                                                            
CODE_0387D7:          JSL.L MarioSprInteract              ;; 0387D7 : 22 DC A7 01 ; Check for mario/Mega Mole contact 
CODE_0387DB:          BCC Return03882A                    ;; 0387DB : 90 4D       ; (Carry set = contact) 
CODE_0387DD:          JSR.W SubVertPosBnk3                ;; 0387DD : 20 29 B8    ;
CODE_0387E0:          LDA $0E                             ;; 0387E0 : A5 0E       ;
CODE_0387E2:          CMP.B #$D8                          ;; 0387E2 : C9 D8       ;
CODE_0387E4:          BPL MegaMoleContact                 ;; 0387E4 : 10 38       ;
CODE_0387E6:          LDA RAM_MarioSpeedY                 ;; 0387E6 : A5 7D       ;
CODE_0387E8:          BMI Return03882A                    ;; 0387E8 : 30 40       ;
CODE_0387EA:          LDA.B #$01                          ;; 0387EA : A9 01       ; \ Set "on sprite" flag				     
CODE_0387EC:          STA.W $1471                         ;; 0387EC : 8D 71 14    ; /							     
CODE_0387EF:          LDA.B #$06                          ;; 0387EF : A9 06       ; \ Set riding Mega Mole				     
CODE_0387F1:          STA.W RAM_DisableInter,X            ;; 0387F1 : 9D 4C 15    ; / 						     
CODE_0387F4:          STZ RAM_MarioSpeedY                 ;; 0387F4 : 64 7D       ; Y speed = 0					     
CODE_0387F6:          LDA.B #$D6                          ;; 0387F6 : A9 D6       ; \							     
CODE_0387F8:          LDY.W RAM_OnYoshi                   ;; 0387F8 : AC 7A 18    ; | Mario's y position += C6 or D6 depending if on yoshi 
CODE_0387FB:          BEQ MegaMoleNoYoshi                 ;; 0387FB : F0 02       ; |							     
CODE_0387FD:          LDA.B #$C6                          ;; 0387FD : A9 C6       ; |							     
MegaMoleNoYoshi:      CLC                                 ;; ?QPWZ? : 18          ; |							     
CODE_038800:          ADC RAM_SpriteYLo,X                 ;; 038800 : 75 D8       ; |							     
CODE_038802:          STA RAM_MarioYPos                   ;; 038802 : 85 96       ; |							     
CODE_038804:          LDA.W RAM_SpriteYHi,X               ;; 038804 : BD D4 14    ; |							     
CODE_038807:          ADC.B #$FF                          ;; 038807 : 69 FF       ; |							     
CODE_038809:          STA RAM_MarioYPosHi                 ;; 038809 : 85 97       ; /							     
CODE_03880B:          LDY.B #$00                          ;; 03880B : A0 00       ; \ 						     
CODE_03880D:          LDA.W $1491                         ;; 03880D : AD 91 14    ; | $1491 == 01 or FF, depending on direction	     
CODE_038810:          BPL CODE_038813                     ;; 038810 : 10 01       ; | Set mario's new x position			     
CODE_038812:          DEY                                 ;; 038812 : 88          ; |							     
CODE_038813:          CLC                                 ;; 038813 : 18          ; |							     
CODE_038814:          ADC RAM_MarioXPos                   ;; 038814 : 65 94       ; |							     
CODE_038816:          STA RAM_MarioXPos                   ;; 038816 : 85 94       ; |							     
CODE_038818:          TYA                                 ;; 038818 : 98          ; |							     
CODE_038819:          ADC RAM_MarioXPosHi                 ;; 038819 : 65 95       ; |							     
CODE_03881B:          STA RAM_MarioXPosHi                 ;; 03881B : 85 95       ;  /							   
Return03881D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
MegaMoleContact:      LDA.W RAM_DisableInter,X            ;; ?QPWZ? : BD 4C 15    ; \ If riding Mega Mole...				     
CODE_038821:          ORA.W $15D0,X                       ;; 038821 : 1D D0 15    ; |   ...or Mega Mole being eaten...		     
CODE_038824:          BNE Return03882A                    ;; 038824 : D0 04       ; /   ...return					     
CODE_038826:          JSL.L HurtMario                     ;; 038826 : 22 B7 F5 00 ; Hurt mario					     
Return03882A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MegaMoleTileDispX:    .db $00,$10,$00,$10,$10,$00,$10,$00 ;; ?QPWZ?               ;
MegaMoleTileDispY:    .db $F0,$F0,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMoleTiles:        .db $C6,$C8,$E6,$E8,$CA,$CC,$EA,$EC ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMoleGfxRt:        JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_038842:          LDA.W $151C,X                       ;; 038842 : BD 1C 15    ; \ $02 = direction						      
CODE_038845:          STA $02                             ;; 038845 : 85 02       ; / 							      
CODE_038847:          LDA RAM_FrameCounterB               ;; 038847 : A5 14       ; \ 							      
CODE_038849:          LSR                                 ;; 038849 : 4A          ; |								      
CODE_03884A:          LSR                                 ;; 03884A : 4A          ; |								      
CODE_03884B:          NOP                                 ;; 03884B : EA          ; |								      
CODE_03884C:          CLC                                 ;; 03884C : 18          ; |								      
CODE_03884D:          ADC.W $15E9                         ;; 03884D : 6D E9 15    ; |								      
CODE_038850:          AND.B #$01                          ;; 038850 : 29 01       ; |								      
CODE_038852:          ASL                                 ;; 038852 : 0A          ; |								      
CODE_038853:          ASL                                 ;; 038853 : 0A          ; |								      
CODE_038854:          STA $03                             ;; 038854 : 85 03       ; | $03 = index to frame start (0 or 4)			      
CODE_038856:          PHX                                 ;; 038856 : DA          ; /								      
CODE_038857:          LDX.B #$03                          ;; 038857 : A2 03       ; Run loop 4 times, cuz 4 tiles per frame			      
MegaMoleGfxLoopSt:    PHX                                 ;; ?QPWZ? : DA          ; Push, current tile					      
CODE_03885A:          LDA $02                             ;; 03885A : A5 02       ; \								      
CODE_03885C:          BNE MegaMoleFaceLeft                ;; 03885C : D0 04       ; | If facing right, index to frame end += 4		      
CODE_03885E:          INX                                 ;; 03885E : E8          ; |								      
CODE_03885F:          INX                                 ;; 03885F : E8          ; |								      
CODE_038860:          INX                                 ;; 038860 : E8          ; |								      
CODE_038861:          INX                                 ;; 038861 : E8          ; /								      
MegaMoleFaceLeft:     LDA $00                             ;; ?QPWZ? : A5 00       ; \ Tile x position = sprite x location ($00) + tile displacement 
CODE_038864:          CLC                                 ;; 038864 : 18          ; |								      
CODE_038865:          ADC.W MegaMoleTileDispX,X           ;; 038865 : 7D 2B 88    ; |								      
CODE_038868:          STA.W OAM_DispX,Y                   ;; 038868 : 99 00 03    ; /								      
CODE_03886B:          PLX                                 ;; 03886B : FA          ; \ Pull, X = index to frame end				      
CODE_03886C:          LDA $01                             ;; 03886C : A5 01       ; |								      
CODE_03886E:          CLC                                 ;; 03886E : 18          ; | Tile y position = sprite y location ($01) + tile displacement 
CODE_03886F:          ADC.W MegaMoleTileDispY,X           ;; 03886F : 7D 33 88    ; |						    
CODE_038872:          STA.W OAM_DispY,Y                   ;; 038872 : 99 01 03    ; /						    
CODE_038875:          PHX                                 ;; 038875 : DA          ; \ Set current tile			    
CODE_038876:          TXA                                 ;; 038876 : 8A          ; | X = index of frame start + current tile	    
CODE_038877:          CLC                                 ;; 038877 : 18          ; |						    
CODE_038878:          ADC $03                             ;; 038878 : 65 03       ; |						    
CODE_03887A:          TAX                                 ;; 03887A : AA          ; |						    
CODE_03887B:          LDA.W MegaMoleTiles,X               ;; 03887B : BD 37 88    ; |						    
CODE_03887E:          STA.W OAM_Tile,Y                    ;; 03887E : 99 02 03    ; /						    
CODE_038881:          LDA.B #$01                          ;; 038881 : A9 01       ; Tile properties xyppccct, format		    
CODE_038883:          LDX $02                             ;; 038883 : A6 02       ; \ If direction == 0...			    
CODE_038885:          BNE MegaMoleGfxNoFlip               ;; 038885 : D0 02       ; |						    
CODE_038887:          ORA.B #$40                          ;; 038887 : 09 40       ; /    ...flip tile				    
MegaMoleGfxNoFlip:    ORA $64                             ;; ?QPWZ? : 05 64       ; Add in tile priority of level		    
CODE_03888B:          STA.W OAM_Prop,Y                    ;; 03888B : 99 03 03    ; Store tile properties			    
CODE_03888E:          PLX                                 ;; 03888E : FA          ; \ Pull, current tile			    
CODE_03888F:          INY                                 ;; 03888F : C8          ; | Increase index to sprite tile map ($300)... 
CODE_038890:          INY                                 ;; 038890 : C8          ; |    ...we wrote 4 bytes    
CODE_038891:          INY                                 ;; 038891 : C8          ; |    ...so increment 4 times 
CODE_038892:          INY                                 ;; 038892 : C8          ; |     
CODE_038893:          DEX                                 ;; 038893 : CA          ; | Go to next tile of frame and loop	    
CODE_038894:          BPL MegaMoleGfxLoopSt               ;; 038894 : 10 C3       ; /                                             
CODE_038896:          PLX                                 ;; 038896 : FA          ; Pull, X = sprite index			    
CODE_038897:          LDY.B #$02                          ;; 038897 : A0 02       ; \ Will write 02 to $0460 (all 16x16 tiles) 
CODE_038899:          LDA.B #$03                          ;; 038899 : A9 03       ; | A = number of tiles drawn - 1		    
CODE_03889B:          JSL.L FinishOAMWrite                ;; 03889B : 22 B3 B7 01 ; / Don't draw if offscreen			    
Return03889F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BatTiles:             .db $AE,$C0,$E8                     ;; ?QPWZ?               ;
                                                          ;;                      ;
Swooper:              JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_0388A7:          LDY.W RAM_SprOAMIndex,X             ;; 0388A7 : BC EA 15    ; Y = Index into sprite OAM 
CODE_0388AA:          PHX                                 ;; 0388AA : DA          ;
CODE_0388AB:          LDA.W $1602,X                       ;; 0388AB : BD 02 16    ;
CODE_0388AE:          TAX                                 ;; 0388AE : AA          ;
CODE_0388AF:          LDA.W BatTiles,X                    ;; 0388AF : BD A0 88    ;
CODE_0388B2:          STA.W OAM_Tile,Y                    ;; 0388B2 : 99 02 03    ;
CODE_0388B5:          PLX                                 ;; 0388B5 : FA          ;
CODE_0388B6:          LDA.W $14C8,X                       ;; 0388B6 : BD C8 14    ;
CODE_0388B9:          CMP.B #$08                          ;; 0388B9 : C9 08       ;
CODE_0388BB:          BEQ CODE_0388C0                     ;; 0388BB : F0 03       ;
CODE_0388BD:          JMP.W CODE_0384EC                   ;; 0388BD : 4C EC 84    ;
                                                          ;;                      ;
CODE_0388C0:          LDA RAM_SpritesLocked               ;; 0388C0 : A5 9D       ;
CODE_0388C2:          BNE Return0388DF                    ;; 0388C2 : D0 1B       ;
CODE_0388C4:          JSR.W SubOffscreen0Bnk3             ;; 0388C4 : 20 5D B8    ;
CODE_0388C7:          JSL.L SprSpr+MarioSprRts            ;; 0388C7 : 22 3A 80 01 ;
CODE_0388CB:          JSL.L UpdateXPosNoGrvty             ;; 0388CB : 22 22 80 01 ;
CODE_0388CF:          JSL.L UpdateYPosNoGrvty             ;; 0388CF : 22 1A 80 01 ;
CODE_0388D3:          LDA RAM_SpriteState,X               ;; 0388D3 : B5 C2       ;
CODE_0388D5:          JSL.L ExecutePtr                    ;; 0388D5 : 22 DF 86 00 ;
                                                          ;;                      ;
SwooperPtrs:          .dw CODE_0388E4                     ;; ?QPWZ? : E4 88       ;
                      .dw CODE_038905                     ;; ?QPWZ? : 05 89       ;
                      .dw CODE_038936                     ;; ?QPWZ? : 36 89       ;
                                                          ;;                      ;
Return0388DF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0388E0:          .db $10,$F0                         ;; 0388E0               ;
                                                          ;;                      ;
DATA_0388E2:          .db $01,$FF                         ;; 0388E2               ;
                                                          ;;                      ;
CODE_0388E4:          LDA.W RAM_OffscreenHorz,X           ;; 0388E4 : BD A0 15    ;
CODE_0388E7:          BNE Return038904                    ;; 0388E7 : D0 1B       ;
CODE_0388E9:          JSR.W SubHorzPosBnk3                ;; 0388E9 : 20 17 B8    ;
CODE_0388EC:          LDA $0F                             ;; 0388EC : A5 0F       ;
CODE_0388EE:          CLC                                 ;; 0388EE : 18          ;
CODE_0388EF:          ADC.B #$50                          ;; 0388EF : 69 50       ;
CODE_0388F1:          CMP.B #$A0                          ;; 0388F1 : C9 A0       ;
CODE_0388F3:          BCS Return038904                    ;; 0388F3 : B0 0F       ;
CODE_0388F5:          INC RAM_SpriteState,X               ;; 0388F5 : F6 C2       ;
CODE_0388F7:          TYA                                 ;; 0388F7 : 98          ;
CODE_0388F8:          STA.W RAM_SpriteDir,X               ;; 0388F8 : 9D 7C 15    ;
CODE_0388FB:          LDA.B #$20                          ;; 0388FB : A9 20       ;
CODE_0388FD:          STA RAM_SpriteSpeedY,X              ;; 0388FD : 95 AA       ;
CODE_0388FF:          LDA.B #$26                          ;; 0388FF : A9 26       ; \ Play sound effect 
CODE_038901:          STA.W $1DFC                         ;; 038901 : 8D FC 1D    ; / 
Return038904:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038905:          LDA RAM_FrameCounter                ;; 038905 : A5 13       ;
CODE_038907:          AND.B #$03                          ;; 038907 : 29 03       ;
CODE_038909:          BNE CODE_038915                     ;; 038909 : D0 0A       ;
CODE_03890B:          LDA RAM_SpriteSpeedY,X              ;; 03890B : B5 AA       ;
CODE_03890D:          BEQ CODE_038915                     ;; 03890D : F0 06       ;
CODE_03890F:          DEC RAM_SpriteSpeedY,X              ;; 03890F : D6 AA       ;
CODE_038911:          BNE CODE_038915                     ;; 038911 : D0 02       ;
CODE_038913:          INC RAM_SpriteState,X               ;; 038913 : F6 C2       ;
CODE_038915:          LDA RAM_FrameCounter                ;; 038915 : A5 13       ;
CODE_038917:          AND.B #$03                          ;; 038917 : 29 03       ;
CODE_038919:          BNE CODE_03892B                     ;; 038919 : D0 10       ;
CODE_03891B:          LDY.W RAM_SpriteDir,X               ;; 03891B : BC 7C 15    ;
CODE_03891E:          LDA RAM_SpriteSpeedX,X              ;; 03891E : B5 B6       ;
CODE_038920:          CMP.W DATA_0388E0,Y                 ;; 038920 : D9 E0 88    ;
CODE_038923:          BEQ CODE_03892B                     ;; 038923 : F0 06       ;
CODE_038925:          CLC                                 ;; 038925 : 18          ;
CODE_038926:          ADC.W DATA_0388E2,Y                 ;; 038926 : 79 E2 88    ;
CODE_038929:          STA RAM_SpriteSpeedX,X              ;; 038929 : 95 B6       ;
CODE_03892B:          LDA RAM_FrameCounterB               ;; 03892B : A5 14       ;
CODE_03892D:          AND.B #$04                          ;; 03892D : 29 04       ;
CODE_03892F:          LSR                                 ;; 03892F : 4A          ;
CODE_038930:          LSR                                 ;; 038930 : 4A          ;
CODE_038931:          INC A                               ;; 038931 : 1A          ;
CODE_038932:          STA.W $1602,X                       ;; 038932 : 9D 02 16    ;
Return038935:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038936:          LDA RAM_FrameCounter                ;; 038936 : A5 13       ;
CODE_038938:          AND.B #$01                          ;; 038938 : 29 01       ;
CODE_03893A:          BNE CODE_038952                     ;; 03893A : D0 16       ;
CODE_03893C:          LDA.W $151C,X                       ;; 03893C : BD 1C 15    ;
CODE_03893F:          AND.B #$01                          ;; 03893F : 29 01       ;
CODE_038941:          TAY                                 ;; 038941 : A8          ;
CODE_038942:          LDA RAM_SpriteSpeedY,X              ;; 038942 : B5 AA       ;
CODE_038944:          CLC                                 ;; 038944 : 18          ;
CODE_038945:          ADC.W BlurpAccelY,Y                 ;; 038945 : 79 C8 84    ;
CODE_038948:          STA RAM_SpriteSpeedY,X              ;; 038948 : 95 AA       ;
CODE_03894A:          CMP.W BlurpMaxSpeedY,Y              ;; 03894A : D9 C4 84    ;
CODE_03894D:          BNE CODE_038952                     ;; 03894D : D0 03       ;
CODE_03894F:          INC.W $151C,X                       ;; 03894F : FE 1C 15    ;
CODE_038952:          BRA CODE_038915                     ;; 038952 : 80 C1       ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038954:          .db $20,$E0                         ;; 038954               ;
                                                          ;;                      ;
DATA_038956:          .db $02,$FE                         ;; 038956               ;
                                                          ;;                      ;
SlidingKoopa:         LDA.B #$00                          ;; ?QPWZ? : A9 00       ;
CODE_03895A:          LDY RAM_SpriteSpeedX,X              ;; 03895A : B4 B6       ;
CODE_03895C:          BEQ CODE_038964                     ;; 03895C : F0 06       ;
CODE_03895E:          BPL CODE_038961                     ;; 03895E : 10 01       ;
CODE_038960:          INC A                               ;; 038960 : 1A          ;
CODE_038961:          STA.W RAM_SpriteDir,X               ;; 038961 : 9D 7C 15    ;
CODE_038964:          JSL.L GenericSprGfxRt2              ;; 038964 : 22 B2 90 01 ;
CODE_038968:          LDY.W RAM_SprOAMIndex,X             ;; 038968 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03896B:          LDA.W $1558,X                       ;; 03896B : BD 58 15    ;
CODE_03896E:          CMP.B #$01                          ;; 03896E : C9 01       ;
CODE_038970:          BNE CODE_038983                     ;; 038970 : D0 11       ;
CODE_038972:          LDA.W RAM_SpriteDir,X               ;; 038972 : BD 7C 15    ;
CODE_038975:          PHA                                 ;; 038975 : 48          ;
CODE_038976:          LDA.B #$02                          ;; 038976 : A9 02       ;
CODE_038978:          STA RAM_SpriteNum,X                 ;; 038978 : 95 9E       ;
CODE_03897A:          JSL.L InitSpriteTables              ;; 03897A : 22 D2 F7 07 ;
CODE_03897E:          PLA                                 ;; 03897E : 68          ;
CODE_03897F:          STA.W RAM_SpriteDir,X               ;; 03897F : 9D 7C 15    ;
CODE_038982:          SEC                                 ;; 038982 : 38          ;
CODE_038983:          LDA.B #$86                          ;; 038983 : A9 86       ;
CODE_038985:          BCC CODE_038989                     ;; 038985 : 90 02       ;
CODE_038987:          LDA.B #$E0                          ;; 038987 : A9 E0       ;
CODE_038989:          STA.W OAM_Tile,Y                    ;; 038989 : 99 02 03    ;
CODE_03898C:          LDA.W $14C8,X                       ;; 03898C : BD C8 14    ;
CODE_03898F:          CMP.B #$08                          ;; 03898F : C9 08       ;
CODE_038991:          BNE Return0389FE                    ;; 038991 : D0 6B       ;
CODE_038993:          JSR.W SubOffscreen0Bnk3             ;; 038993 : 20 5D B8    ;
CODE_038996:          JSL.L SprSpr+MarioSprRts            ;; 038996 : 22 3A 80 01 ;
CODE_03899A:          LDA RAM_SpritesLocked               ;; 03899A : A5 9D       ;
CODE_03899C:          ORA.W $1540,X                       ;; 03899C : 1D 40 15    ;
CODE_03899F:          ORA.W $1558,X                       ;; 03899F : 1D 58 15    ;
CODE_0389A2:          BNE Return0389FE                    ;; 0389A2 : D0 5A       ;
CODE_0389A4:          JSL.L UpdateSpritePos               ;; 0389A4 : 22 2A 80 01 ;
CODE_0389A8:          LDA.W RAM_SprObjStatus,X            ;; 0389A8 : BD 88 15    ; \ Branch if not on ground 
CODE_0389AB:          AND.B #$04                          ;; 0389AB : 29 04       ;  | 
CODE_0389AD:          BEQ Return0389FE                    ;; 0389AD : F0 4F       ; / 
CODE_0389AF:          JSR.W CODE_0389FF                   ;; 0389AF : 20 FF 89    ;
CODE_0389B2:          LDY.B #$00                          ;; 0389B2 : A0 00       ;
CODE_0389B4:          LDA RAM_SpriteSpeedX,X              ;; 0389B4 : B5 B6       ;
CODE_0389B6:          BEQ CODE_0389CC                     ;; 0389B6 : F0 14       ;
CODE_0389B8:          BPL CODE_0389BD                     ;; 0389B8 : 10 03       ;
CODE_0389BA:          EOR.B #$FF                          ;; 0389BA : 49 FF       ;
CODE_0389BC:          INC A                               ;; 0389BC : 1A          ;
CODE_0389BD:          STA $00                             ;; 0389BD : 85 00       ;
CODE_0389BF:          LDA.W $15B8,X                       ;; 0389BF : BD B8 15    ;
CODE_0389C2:          BEQ CODE_0389CC                     ;; 0389C2 : F0 08       ;
CODE_0389C4:          LDY $00                             ;; 0389C4 : A4 00       ;
CODE_0389C6:          EOR RAM_SpriteSpeedX,X              ;; 0389C6 : 55 B6       ;
CODE_0389C8:          BPL CODE_0389CC                     ;; 0389C8 : 10 02       ;
CODE_0389CA:          LDY.B #$D0                          ;; 0389CA : A0 D0       ;
CODE_0389CC:          STY RAM_SpriteSpeedY,X              ;; 0389CC : 94 AA       ;
CODE_0389CE:          LDA RAM_FrameCounter                ;; 0389CE : A5 13       ;
CODE_0389D0:          AND.B #$01                          ;; 0389D0 : 29 01       ;
CODE_0389D2:          BNE Return0389FE                    ;; 0389D2 : D0 2A       ;
CODE_0389D4:          LDA.W $15B8,X                       ;; 0389D4 : BD B8 15    ;
CODE_0389D7:          BNE CODE_0389EC                     ;; 0389D7 : D0 13       ;
CODE_0389D9:          LDA RAM_SpriteSpeedX,X              ;; 0389D9 : B5 B6       ;
CODE_0389DB:          BNE CODE_0389E3                     ;; 0389DB : D0 06       ;
CODE_0389DD:          LDA.B #$20                          ;; 0389DD : A9 20       ;
CODE_0389DF:          STA.W $1558,X                       ;; 0389DF : 9D 58 15    ;
Return0389E2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389E3:          BPL CODE_0389E9                     ;; 0389E3 : 10 04       ;
CODE_0389E5:          INC RAM_SpriteSpeedX,X              ;; 0389E5 : F6 B6       ;
CODE_0389E7:          INC RAM_SpriteSpeedX,X              ;; 0389E7 : F6 B6       ;
CODE_0389E9:          DEC RAM_SpriteSpeedX,X              ;; 0389E9 : D6 B6       ;
Return0389EB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389EC:          ASL                                 ;; 0389EC : 0A          ;
CODE_0389ED:          ROL                                 ;; 0389ED : 2A          ;
CODE_0389EE:          AND.B #$01                          ;; 0389EE : 29 01       ;
CODE_0389F0:          TAY                                 ;; 0389F0 : A8          ;
CODE_0389F1:          LDA RAM_SpriteSpeedX,X              ;; 0389F1 : B5 B6       ;
CODE_0389F3:          CMP.W DATA_038954,Y                 ;; 0389F3 : D9 54 89    ;
CODE_0389F6:          BEQ Return0389FE                    ;; 0389F6 : F0 06       ;
CODE_0389F8:          CLC                                 ;; 0389F8 : 18          ;
CODE_0389F9:          ADC.W DATA_038956,Y                 ;; 0389F9 : 79 56 89    ;
CODE_0389FC:          STA RAM_SpriteSpeedX,X              ;; 0389FC : 95 B6       ;
Return0389FE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389FF:          LDA RAM_SpriteSpeedX,X              ;; 0389FF : B5 B6       ;
CODE_038A01:          BEQ Return038A20                    ;; 038A01 : F0 1D       ;
CODE_038A03:          LDA RAM_FrameCounter                ;; 038A03 : A5 13       ;
CODE_038A05:          AND.B #$03                          ;; 038A05 : 29 03       ;
CODE_038A07:          BNE Return038A20                    ;; 038A07 : D0 17       ;
CODE_038A09:          LDA.B #$04                          ;; 038A09 : A9 04       ;
CODE_038A0B:          STA $00                             ;; 038A0B : 85 00       ;
CODE_038A0D:          LDA.B #$0A                          ;; 038A0D : A9 0A       ;
CODE_038A0F:          STA $01                             ;; 038A0F : 85 01       ;
CODE_038A11:          JSR.W IsSprOffScreenBnk3            ;; 038A11 : 20 FB B8    ;
CODE_038A14:          BNE Return038A20                    ;; 038A14 : D0 0A       ;
CODE_038A16:          LDY.B #$03                          ;; 038A16 : A0 03       ;
CODE_038A18:          LDA.W $17C0,Y                       ;; 038A18 : B9 C0 17    ;
CODE_038A1B:          BEQ CODE_038A21                     ;; 038A1B : F0 04       ;
CODE_038A1D:          DEY                                 ;; 038A1D : 88          ;
CODE_038A1E:          BPL CODE_038A18                     ;; 038A1E : 10 F8       ;
Return038A20:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038A21:          LDA.B #$03                          ;; 038A21 : A9 03       ;
CODE_038A23:          STA.W $17C0,Y                       ;; 038A23 : 99 C0 17    ;
CODE_038A26:          LDA RAM_SpriteXLo,X                 ;; 038A26 : B5 E4       ;
CODE_038A28:          CLC                                 ;; 038A28 : 18          ;
CODE_038A29:          ADC $00                             ;; 038A29 : 65 00       ;
CODE_038A2B:          STA.W $17C8,Y                       ;; 038A2B : 99 C8 17    ;
CODE_038A2E:          LDA RAM_SpriteYLo,X                 ;; 038A2E : B5 D8       ;
CODE_038A30:          CLC                                 ;; 038A30 : 18          ;
CODE_038A31:          ADC $01                             ;; 038A31 : 65 01       ;
CODE_038A33:          STA.W $17C4,Y                       ;; 038A33 : 99 C4 17    ;
CODE_038A36:          LDA.B #$13                          ;; 038A36 : A9 13       ;
CODE_038A38:          STA.W $17CC,Y                       ;; 038A38 : 99 CC 17    ;
Return038A3B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
BowserStatue:         JSR.W BowserStatueGfx               ;; ?QPWZ? : 20 3D 8B    ;
CODE_038A3F:          LDA RAM_SpritesLocked               ;; 038A3F : A5 9D       ;
CODE_038A41:          BNE Return038A68                    ;; 038A41 : D0 25       ;
CODE_038A43:          JSR.W SubOffscreen0Bnk3             ;; 038A43 : 20 5D B8    ;
CODE_038A46:          LDA RAM_SpriteState,X               ;; 038A46 : B5 C2       ;
CODE_038A48:          JSL.L ExecutePtr                    ;; 038A48 : 22 DF 86 00 ;
                                                          ;;                      ;
BowserStatuePtrs:     .dw CODE_038A57                     ;; ?QPWZ? : 57 8A       ;
                      .dw CODE_038A54                     ;; ?QPWZ? : 54 8A       ;
                      .dw CODE_038A69                     ;; ?QPWZ? : 69 8A       ;
                      .dw CODE_038A54                     ;; ?QPWZ? : 54 8A       ;
                                                          ;;                      ;
CODE_038A54:          JSR.W CODE_038ACB                   ;; 038A54 : 20 CB 8A    ;
CODE_038A57:          JSL.L InvisBlkMainRt                ;; 038A57 : 22 4F B4 01 ;
CODE_038A5B:          JSL.L UpdateSpritePos               ;; 038A5B : 22 2A 80 01 ;
CODE_038A5F:          LDA.W RAM_SprObjStatus,X            ;; 038A5F : BD 88 15    ; \ Branch if not on ground 
CODE_038A62:          AND.B #$04                          ;; 038A62 : 29 04       ;  | 
CODE_038A64:          BEQ Return038A68                    ;; 038A64 : F0 02       ; / 
CODE_038A66:          STZ RAM_SpriteSpeedY,X              ;; 038A66 : 74 AA       ; Sprite Y Speed = 0 
Return038A68:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038A69:          ASL.W RAM_Tweaker167A,X             ;; 038A69 : 1E 7A 16    ;
CODE_038A6C:          LSR.W RAM_Tweaker167A,X             ;; 038A6C : 5E 7A 16    ;
CODE_038A6F:          JSL.L MarioSprInteract              ;; 038A6F : 22 DC A7 01 ;
CODE_038A73:          STZ.W $1602,X                       ;; 038A73 : 9E 02 16    ;
CODE_038A76:          LDA RAM_SpriteSpeedY,X              ;; 038A76 : B5 AA       ;
CODE_038A78:          CMP.B #$10                          ;; 038A78 : C9 10       ;
CODE_038A7A:          BPL CODE_038A7F                     ;; 038A7A : 10 03       ;
CODE_038A7C:          INC.W $1602,X                       ;; 038A7C : FE 02 16    ;
CODE_038A7F:          JSL.L UpdateSpritePos               ;; 038A7F : 22 2A 80 01 ;
CODE_038A83:          LDA.W RAM_SprObjStatus,X            ;; 038A83 : BD 88 15    ; \ Branch if not touching object 
CODE_038A86:          AND.B #$03                          ;; 038A86 : 29 03       ;  | 
CODE_038A88:          BEQ CODE_038A99                     ;; 038A88 : F0 0F       ; / 
ADDR_038A8A:          LDA RAM_SpriteSpeedX,X              ;; 038A8A : B5 B6       ;
ADDR_038A8C:          EOR.B #$FF                          ;; 038A8C : 49 FF       ;
ADDR_038A8E:          INC A                               ;; 038A8E : 1A          ;
ADDR_038A8F:          STA RAM_SpriteSpeedX,X              ;; 038A8F : 95 B6       ;
ADDR_038A91:          LDA.W RAM_SpriteDir,X               ;; 038A91 : BD 7C 15    ;
ADDR_038A94:          EOR.B #$01                          ;; 038A94 : 49 01       ;
ADDR_038A96:          STA.W RAM_SpriteDir,X               ;; 038A96 : 9D 7C 15    ;
CODE_038A99:          LDA.W RAM_SprObjStatus,X            ;; 038A99 : BD 88 15    ; \ Branch if not on ground 
CODE_038A9C:          AND.B #$04                          ;; 038A9C : 29 04       ;  | 
CODE_038A9E:          BEQ Return038AC6                    ;; 038A9E : F0 26       ; / 
CODE_038AA0:          LDA.B #$10                          ;; 038AA0 : A9 10       ;
CODE_038AA2:          STA RAM_SpriteSpeedY,X              ;; 038AA2 : 95 AA       ;
CODE_038AA4:          STZ RAM_SpriteSpeedX,X              ;; 038AA4 : 74 B6       ; Sprite X Speed = 0 
CODE_038AA6:          LDA.W $1540,X                       ;; 038AA6 : BD 40 15    ;
CODE_038AA9:          BEQ CODE_038AC1                     ;; 038AA9 : F0 16       ;
CODE_038AAB:          DEC A                               ;; 038AAB : 3A          ;
CODE_038AAC:          BNE Return038AC6                    ;; 038AAC : D0 18       ;
CODE_038AAE:          LDA.B #$C0                          ;; 038AAE : A9 C0       ;
CODE_038AB0:          STA RAM_SpriteSpeedY,X              ;; 038AB0 : 95 AA       ;
CODE_038AB2:          JSR.W SubHorzPosBnk3                ;; 038AB2 : 20 17 B8    ;
CODE_038AB5:          TYA                                 ;; 038AB5 : 98          ;
CODE_038AB6:          STA.W RAM_SpriteDir,X               ;; 038AB6 : 9D 7C 15    ;
CODE_038AB9:          LDA.W BwsrStatueSpeed,Y             ;; 038AB9 : B9 BF 8A    ;
CODE_038ABC:          STA RAM_SpriteSpeedX,X              ;; 038ABC : 95 B6       ;
Return038ABE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwsrStatueSpeed:      .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038AC1:          LDA.B #$30                          ;; 038AC1 : A9 30       ;
CODE_038AC3:          STA.W $1540,X                       ;; 038AC3 : 9D 40 15    ;
Return038AC6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwserFireDispXLo:     .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
BwserFireDispXHi:     .db $00,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038ACB:          TXA                                 ;; 038ACB : 8A          ;
CODE_038ACC:          ASL                                 ;; 038ACC : 0A          ;
CODE_038ACD:          ASL                                 ;; 038ACD : 0A          ;
CODE_038ACE:          ADC RAM_FrameCounter                ;; 038ACE : 65 13       ;
CODE_038AD0:          AND.B #$7F                          ;; 038AD0 : 29 7F       ;
CODE_038AD2:          BNE Return038B24                    ;; 038AD2 : D0 50       ;
CODE_038AD4:          JSL.L FindFreeSprSlot               ;; 038AD4 : 22 E4 A9 02 ; \ Return if no free slots 
CODE_038AD8:          BMI Return038B24                    ;; 038AD8 : 30 4A       ; / 
CODE_038ADA:          LDA.B #$17                          ;; 038ADA : A9 17       ; \ Play sound effect 
CODE_038ADC:          STA.W $1DFC                         ;; 038ADC : 8D FC 1D    ; / 
CODE_038ADF:          LDA.B #$08                          ;; 038ADF : A9 08       ; \ Sprite status = Normal 
CODE_038AE1:          STA.W $14C8,Y                       ;; 038AE1 : 99 C8 14    ; / 
CODE_038AE4:          LDA.B #$B3                          ;; 038AE4 : A9 B3       ; \ Sprite = Bowser Statue Fireball 
CODE_038AE6:          STA.W RAM_SpriteNum,Y               ;; 038AE6 : 99 9E 00    ; / 
CODE_038AE9:          LDA RAM_SpriteXLo,X                 ;; 038AE9 : B5 E4       ;
CODE_038AEB:          STA $00                             ;; 038AEB : 85 00       ;
CODE_038AED:          LDA.W RAM_SpriteXHi,X               ;; 038AED : BD E0 14    ;
CODE_038AF0:          STA $01                             ;; 038AF0 : 85 01       ;
CODE_038AF2:          PHX                                 ;; 038AF2 : DA          ;
CODE_038AF3:          LDA.W RAM_SpriteDir,X               ;; 038AF3 : BD 7C 15    ;
CODE_038AF6:          TAX                                 ;; 038AF6 : AA          ;
CODE_038AF7:          LDA $00                             ;; 038AF7 : A5 00       ;
CODE_038AF9:          CLC                                 ;; 038AF9 : 18          ;
CODE_038AFA:          ADC.W BwserFireDispXLo,X            ;; 038AFA : 7D C7 8A    ;
CODE_038AFD:          STA.W RAM_SpriteXLo,Y               ;; 038AFD : 99 E4 00    ;
CODE_038B00:          LDA $01                             ;; 038B00 : A5 01       ;
CODE_038B02:          ADC.W BwserFireDispXHi,X            ;; 038B02 : 7D C9 8A    ;
CODE_038B05:          STA.W RAM_SpriteXHi,Y               ;; 038B05 : 99 E0 14    ;
CODE_038B08:          TYX                                 ;; 038B08 : BB          ; \ Reset sprite tables 
CODE_038B09:          JSL.L InitSpriteTables              ;; 038B09 : 22 D2 F7 07 ;  | 
CODE_038B0D:          PLX                                 ;; 038B0D : FA          ; / 
CODE_038B0E:          LDA RAM_SpriteYLo,X                 ;; 038B0E : B5 D8       ;
CODE_038B10:          SEC                                 ;; 038B10 : 38          ;
CODE_038B11:          SBC.B #$02                          ;; 038B11 : E9 02       ;
CODE_038B13:          STA.W RAM_SpriteYLo,Y               ;; 038B13 : 99 D8 00    ;
CODE_038B16:          LDA.W RAM_SpriteYHi,X               ;; 038B16 : BD D4 14    ;
CODE_038B19:          SBC.B #$00                          ;; 038B19 : E9 00       ;
CODE_038B1B:          STA.W RAM_SpriteYHi,Y               ;; 038B1B : 99 D4 14    ;
CODE_038B1E:          LDA.W RAM_SpriteDir,X               ;; 038B1E : BD 7C 15    ;
CODE_038B21:          STA.W RAM_SpriteDir,Y               ;; 038B21 : 99 7C 15    ;
Return038B24:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwsrStatueDispX:      .db $08,$F8,$00,$00,$08,$00         ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueDispY:      .db $10,$F8,$00                     ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueTiles:      .db $56,$30,$41,$56,$30,$35         ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueTileSize:   .db $00,$02,$02                     ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueGfxProp:    .db $00,$00,$00,$40,$40,$40         ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserStatueGfx:      JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_038B40:          LDA.W $1602,X                       ;; 038B40 : BD 02 16    ;
CODE_038B43:          STA $04                             ;; 038B43 : 85 04       ;
CODE_038B45:          EOR.B #$01                          ;; 038B45 : 49 01       ;
CODE_038B47:          DEC A                               ;; 038B47 : 3A          ;
CODE_038B48:          STA $03                             ;; 038B48 : 85 03       ;
CODE_038B4A:          LDA.W RAM_SpritePal,X               ;; 038B4A : BD F6 15    ;
CODE_038B4D:          STA $05                             ;; 038B4D : 85 05       ;
CODE_038B4F:          LDA.W RAM_SpriteDir,X               ;; 038B4F : BD 7C 15    ;
CODE_038B52:          STA $02                             ;; 038B52 : 85 02       ;
CODE_038B54:          PHX                                 ;; 038B54 : DA          ;
CODE_038B55:          LDX.B #$02                          ;; 038B55 : A2 02       ;
CODE_038B57:          PHX                                 ;; 038B57 : DA          ;
CODE_038B58:          LDA $02                             ;; 038B58 : A5 02       ;
CODE_038B5A:          BNE CODE_038B5F                     ;; 038B5A : D0 03       ;
CODE_038B5C:          INX                                 ;; 038B5C : E8          ;
CODE_038B5D:          INX                                 ;; 038B5D : E8          ;
CODE_038B5E:          INX                                 ;; 038B5E : E8          ;
CODE_038B5F:          LDA $00                             ;; 038B5F : A5 00       ;
CODE_038B61:          CLC                                 ;; 038B61 : 18          ;
CODE_038B62:          ADC.W BwsrStatueDispX,X             ;; 038B62 : 7D 25 8B    ;
CODE_038B65:          STA.W OAM_DispX,Y                   ;; 038B65 : 99 00 03    ;
CODE_038B68:          LDA.W BwsrStatueGfxProp,X           ;; 038B68 : BD 37 8B    ;
CODE_038B6B:          ORA $05                             ;; 038B6B : 05 05       ;
CODE_038B6D:          ORA $64                             ;; 038B6D : 05 64       ;
CODE_038B6F:          STA.W OAM_Prop,Y                    ;; 038B6F : 99 03 03    ;
CODE_038B72:          PLX                                 ;; 038B72 : FA          ;
CODE_038B73:          LDA $01                             ;; 038B73 : A5 01       ;
CODE_038B75:          CLC                                 ;; 038B75 : 18          ;
CODE_038B76:          ADC.W BwsrStatueDispY,X             ;; 038B76 : 7D 2B 8B    ;
CODE_038B79:          STA.W OAM_DispY,Y                   ;; 038B79 : 99 01 03    ;
CODE_038B7C:          PHX                                 ;; 038B7C : DA          ;
CODE_038B7D:          LDA $04                             ;; 038B7D : A5 04       ;
CODE_038B7F:          BEQ CODE_038B84                     ;; 038B7F : F0 03       ;
CODE_038B81:          INX                                 ;; 038B81 : E8          ;
CODE_038B82:          INX                                 ;; 038B82 : E8          ;
CODE_038B83:          INX                                 ;; 038B83 : E8          ;
CODE_038B84:          LDA.W BwsrStatueTiles,X             ;; 038B84 : BD 2E 8B    ;
CODE_038B87:          STA.W OAM_Tile,Y                    ;; 038B87 : 99 02 03    ;
CODE_038B8A:          PLX                                 ;; 038B8A : FA          ;
CODE_038B8B:          PHY                                 ;; 038B8B : 5A          ;
CODE_038B8C:          TYA                                 ;; 038B8C : 98          ;
CODE_038B8D:          LSR                                 ;; 038B8D : 4A          ;
CODE_038B8E:          LSR                                 ;; 038B8E : 4A          ;
CODE_038B8F:          TAY                                 ;; 038B8F : A8          ;
CODE_038B90:          LDA.W BwsrStatueTileSize,X          ;; 038B90 : BD 34 8B    ;
CODE_038B93:          STA.W OAM_TileSize,Y                ;; 038B93 : 99 60 04    ;
CODE_038B96:          PLY                                 ;; 038B96 : 7A          ;
CODE_038B97:          INY                                 ;; 038B97 : C8          ;
CODE_038B98:          INY                                 ;; 038B98 : C8          ;
CODE_038B99:          INY                                 ;; 038B99 : C8          ;
CODE_038B9A:          INY                                 ;; 038B9A : C8          ;
CODE_038B9B:          DEX                                 ;; 038B9B : CA          ;
CODE_038B9C:          CPX $03                             ;; 038B9C : E4 03       ;
CODE_038B9E:          BNE CODE_038B57                     ;; 038B9E : D0 B7       ;
CODE_038BA0:          PLX                                 ;; 038BA0 : FA          ;
CODE_038BA1:          LDY.B #$FF                          ;; 038BA1 : A0 FF       ;
CODE_038BA3:          LDA.B #$02                          ;; 038BA3 : A9 02       ;
CODE_038BA5:          JSL.L FinishOAMWrite                ;; 038BA5 : 22 B3 B7 01 ;
Return038BA9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038BAA:          .db $20,$20,$20,$20,$20,$20,$20,$20 ;; 038BAA               ;
                      .db $20,$20,$20,$20,$20,$20,$20,$20 ;; ?QPWZ?               ;
                      .db $20,$1F,$1E,$1D,$1C,$1B,$1A,$19 ;; ?QPWZ?               ;
                      .db $18,$17,$16,$15,$14,$13,$12,$11 ;; ?QPWZ?               ;
                      .db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09 ;; ?QPWZ?               ;
                      .db $08,$07,$06,$05,$04,$03,$02,$01 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $01,$02,$03,$04,$05,$06,$07,$08 ;; ?QPWZ?               ;
                      .db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10 ;; ?QPWZ?               ;
                      .db $11,$12,$13,$14,$15,$16,$17,$18 ;; ?QPWZ?               ;
                      .db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20 ;; ?QPWZ?               ;
                      .db $20,$20,$20,$20,$20,$20,$20,$20 ;; ?QPWZ?               ;
                      .db $20,$20,$20,$20,$20,$20,$20,$20 ;; ?QPWZ?               ;
DATA_038C2A:          .db $00,$F8,$00,$08                 ;; 038C2A               ;
                                                          ;;                      ;
Return038C2E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CarrotTopLift:        JSR.W CarrotTopLiftGfx              ;; ?QPWZ? : 20 24 8D    ;
CODE_038C32:          LDA RAM_SpritesLocked               ;; 038C32 : A5 9D       ;
CODE_038C34:          BNE Return038C2E                    ;; 038C34 : D0 F8       ;
CODE_038C36:          JSR.W SubOffscreen0Bnk3             ;; 038C36 : 20 5D B8    ;
CODE_038C39:          LDA.W $1540,X                       ;; 038C39 : BD 40 15    ;
CODE_038C3C:          BNE CODE_038C45                     ;; 038C3C : D0 07       ;
CODE_038C3E:          INC RAM_SpriteState,X               ;; 038C3E : F6 C2       ;
CODE_038C40:          LDA.B #$80                          ;; 038C40 : A9 80       ;
CODE_038C42:          STA.W $1540,X                       ;; 038C42 : 9D 40 15    ;
CODE_038C45:          LDA RAM_SpriteState,X               ;; 038C45 : B5 C2       ;
CODE_038C47:          AND.B #$03                          ;; 038C47 : 29 03       ;
CODE_038C49:          TAY                                 ;; 038C49 : A8          ;
CODE_038C4A:          LDA.W DATA_038C2A,Y                 ;; 038C4A : B9 2A 8C    ;
CODE_038C4D:          STA RAM_SpriteSpeedX,X              ;; 038C4D : 95 B6       ;
CODE_038C4F:          LDA RAM_SpriteSpeedX,X              ;; 038C4F : B5 B6       ;
CODE_038C51:          LDY RAM_SpriteNum,X                 ;; 038C51 : B4 9E       ;
CODE_038C53:          CPY.B #$B8                          ;; 038C53 : C0 B8       ;
CODE_038C55:          BEQ CODE_038C5A                     ;; 038C55 : F0 03       ;
CODE_038C57:          EOR.B #$FF                          ;; 038C57 : 49 FF       ;
CODE_038C59:          INC A                               ;; 038C59 : 1A          ;
CODE_038C5A:          STA RAM_SpriteSpeedY,X              ;; 038C5A : 95 AA       ;
CODE_038C5C:          JSL.L UpdateYPosNoGrvty             ;; 038C5C : 22 1A 80 01 ;
CODE_038C60:          LDA RAM_SpriteXLo,X                 ;; 038C60 : B5 E4       ;
CODE_038C62:          STA.W $151C,X                       ;; 038C62 : 9D 1C 15    ;
CODE_038C65:          JSL.L UpdateXPosNoGrvty             ;; 038C65 : 22 22 80 01 ;
CODE_038C69:          JSR.W CODE_038CE4                   ;; 038C69 : 20 E4 8C    ;
CODE_038C6C:          JSL.L GetSpriteClippingA            ;; 038C6C : 22 9F B6 03 ;
CODE_038C70:          JSL.L CheckForContact               ;; 038C70 : 22 2B B7 03 ;
CODE_038C74:          BCC Return038CE3                    ;; 038C74 : 90 6D       ;
CODE_038C76:          LDA RAM_MarioSpeedY                 ;; 038C76 : A5 7D       ;
CODE_038C78:          BMI Return038CE3                    ;; 038C78 : 30 69       ;
CODE_038C7A:          LDA RAM_MarioXPos                   ;; 038C7A : A5 94       ;
CODE_038C7C:          SEC                                 ;; 038C7C : 38          ;
CODE_038C7D:          SBC.W $151C,X                       ;; 038C7D : FD 1C 15    ;
CODE_038C80:          CLC                                 ;; 038C80 : 18          ;
CODE_038C81:          ADC.B #$1C                          ;; 038C81 : 69 1C       ;
CODE_038C83:          LDY RAM_SpriteNum,X                 ;; 038C83 : B4 9E       ;
CODE_038C85:          CPY.B #$B8                          ;; 038C85 : C0 B8       ;
CODE_038C87:          BNE CODE_038C8C                     ;; 038C87 : D0 03       ;
CODE_038C89:          CLC                                 ;; 038C89 : 18          ;
CODE_038C8A:          ADC.B #$38                          ;; 038C8A : 69 38       ;
CODE_038C8C:          TAY                                 ;; 038C8C : A8          ;
CODE_038C8D:          LDA.W RAM_OnYoshi                   ;; 038C8D : AD 7A 18    ;
CODE_038C90:          CMP.B #$01                          ;; 038C90 : C9 01       ;
CODE_038C92:          LDA.B #$20                          ;; 038C92 : A9 20       ;
CODE_038C94:          BCC CODE_038C98                     ;; 038C94 : 90 02       ;
ADDR_038C96:          LDA.B #$30                          ;; 038C96 : A9 30       ;
CODE_038C98:          CLC                                 ;; 038C98 : 18          ;
CODE_038C99:          ADC RAM_MarioYPos                   ;; 038C99 : 65 96       ;
CODE_038C9B:          STA $00                             ;; 038C9B : 85 00       ;
CODE_038C9D:          LDA RAM_SpriteYLo,X                 ;; 038C9D : B5 D8       ;
CODE_038C9F:          CLC                                 ;; 038C9F : 18          ;
CODE_038CA0:          ADC.W DATA_038BAA,Y                 ;; 038CA0 : 79 AA 8B    ;
CODE_038CA3:          CMP $00                             ;; 038CA3 : C5 00       ;
CODE_038CA5:          BPL Return038CE3                    ;; 038CA5 : 10 3C       ;
CODE_038CA7:          LDA.W RAM_OnYoshi                   ;; 038CA7 : AD 7A 18    ;
CODE_038CAA:          CMP.B #$01                          ;; 038CAA : C9 01       ;
CODE_038CAC:          LDA.B #$1D                          ;; 038CAC : A9 1D       ;
CODE_038CAE:          BCC CODE_038CB2                     ;; 038CAE : 90 02       ;
ADDR_038CB0:          LDA.B #$2D                          ;; 038CB0 : A9 2D       ;
CODE_038CB2:          STA $00                             ;; 038CB2 : 85 00       ;
CODE_038CB4:          LDA RAM_SpriteYLo,X                 ;; 038CB4 : B5 D8       ;
CODE_038CB6:          CLC                                 ;; 038CB6 : 18          ;
CODE_038CB7:          ADC.W DATA_038BAA,Y                 ;; 038CB7 : 79 AA 8B    ;
CODE_038CBA:          PHP                                 ;; 038CBA : 08          ;
CODE_038CBB:          SEC                                 ;; 038CBB : 38          ;
CODE_038CBC:          SBC $00                             ;; 038CBC : E5 00       ;
CODE_038CBE:          STA RAM_MarioYPos                   ;; 038CBE : 85 96       ;
CODE_038CC0:          LDA.W RAM_SpriteYHi,X               ;; 038CC0 : BD D4 14    ;
CODE_038CC3:          SBC.B #$00                          ;; 038CC3 : E9 00       ;
CODE_038CC5:          PLP                                 ;; 038CC5 : 28          ;
CODE_038CC6:          ADC.B #$00                          ;; 038CC6 : 69 00       ;
CODE_038CC8:          STA RAM_MarioYPosHi                 ;; 038CC8 : 85 97       ;
CODE_038CCA:          STZ RAM_MarioSpeedY                 ;; 038CCA : 64 7D       ;
CODE_038CCC:          LDA.B #$01                          ;; 038CCC : A9 01       ;
CODE_038CCE:          STA.W $1471                         ;; 038CCE : 8D 71 14    ;
CODE_038CD1:          LDY.B #$00                          ;; 038CD1 : A0 00       ;
CODE_038CD3:          LDA.W $1491                         ;; 038CD3 : AD 91 14    ;
CODE_038CD6:          BPL CODE_038CD9                     ;; 038CD6 : 10 01       ;
CODE_038CD8:          DEY                                 ;; 038CD8 : 88          ;
CODE_038CD9:          CLC                                 ;; 038CD9 : 18          ;
CODE_038CDA:          ADC RAM_MarioXPos                   ;; 038CDA : 65 94       ;
CODE_038CDC:          STA RAM_MarioXPos                   ;; 038CDC : 85 94       ;
CODE_038CDE:          TYA                                 ;; 038CDE : 98          ;
CODE_038CDF:          ADC RAM_MarioXPosHi                 ;; 038CDF : 65 95       ;
CODE_038CE1:          STA RAM_MarioXPosHi                 ;; 038CE1 : 85 95       ;
Return038CE3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038CE4:          LDA RAM_MarioXPos                   ;; 038CE4 : A5 94       ;
CODE_038CE6:          CLC                                 ;; 038CE6 : 18          ;
CODE_038CE7:          ADC.B #$04                          ;; 038CE7 : 69 04       ;
CODE_038CE9:          STA $00                             ;; 038CE9 : 85 00       ;
CODE_038CEB:          LDA RAM_MarioXPosHi                 ;; 038CEB : A5 95       ;
CODE_038CED:          ADC.B #$00                          ;; 038CED : 69 00       ;
CODE_038CEF:          STA $08                             ;; 038CEF : 85 08       ;
CODE_038CF1:          LDA.B #$08                          ;; 038CF1 : A9 08       ;
CODE_038CF3:          STA $02                             ;; 038CF3 : 85 02       ;
CODE_038CF5:          STA $03                             ;; 038CF5 : 85 03       ;
CODE_038CF7:          LDA.B #$20                          ;; 038CF7 : A9 20       ;
CODE_038CF9:          LDY.W RAM_OnYoshi                   ;; 038CF9 : AC 7A 18    ;
CODE_038CFC:          BEQ CODE_038D00                     ;; 038CFC : F0 02       ;
ADDR_038CFE:          LDA.B #$30                          ;; 038CFE : A9 30       ;
CODE_038D00:          CLC                                 ;; 038D00 : 18          ;
CODE_038D01:          ADC RAM_MarioYPos                   ;; 038D01 : 65 96       ;
CODE_038D03:          STA $01                             ;; 038D03 : 85 01       ;
CODE_038D05:          LDA RAM_MarioYPosHi                 ;; 038D05 : A5 97       ;
CODE_038D07:          ADC.B #$00                          ;; 038D07 : 69 00       ;
CODE_038D09:          STA $09                             ;; 038D09 : 85 09       ;
Return038D0B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DiagPlatDispX:        .db $10,$00,$10,$00,$10,$00         ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatDispY:        .db $00,$10,$10,$00,$10,$10         ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatTiles:        .db $E4,$E0,$E2,$E4,$E0,$E2         ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatGfxProp:      .db $0B,$0B,$0B,$4B,$4B,$4B         ;; ?QPWZ?               ;
                                                          ;;                      ;
CarrotTopLiftGfx:     JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_038D27:          PHX                                 ;; 038D27 : DA          ;
CODE_038D28:          LDA RAM_SpriteNum,X                 ;; 038D28 : B5 9E       ;
CODE_038D2A:          CMP.B #$B8                          ;; 038D2A : C9 B8       ;
CODE_038D2C:          LDX.B #$02                          ;; 038D2C : A2 02       ;
CODE_038D2E:          STX $02                             ;; 038D2E : 86 02       ;
CODE_038D30:          BCC CODE_038D34                     ;; 038D30 : 90 02       ;
CODE_038D32:          LDX.B #$05                          ;; 038D32 : A2 05       ;
CODE_038D34:          LDA $00                             ;; 038D34 : A5 00       ;
CODE_038D36:          CLC                                 ;; 038D36 : 18          ;
CODE_038D37:          ADC.W DiagPlatDispX,X               ;; 038D37 : 7D 0C 8D    ;
CODE_038D3A:          STA.W OAM_DispX,Y                   ;; 038D3A : 99 00 03    ;
CODE_038D3D:          LDA $01                             ;; 038D3D : A5 01       ;
CODE_038D3F:          CLC                                 ;; 038D3F : 18          ;
CODE_038D40:          ADC.W DiagPlatDispY,X               ;; 038D40 : 7D 12 8D    ;
CODE_038D43:          STA.W OAM_DispY,Y                   ;; 038D43 : 99 01 03    ;
CODE_038D46:          LDA.W DiagPlatTiles,X               ;; 038D46 : BD 18 8D    ;
CODE_038D49:          STA.W OAM_Tile,Y                    ;; 038D49 : 99 02 03    ;
CODE_038D4C:          LDA.W DiagPlatGfxProp,X             ;; 038D4C : BD 1E 8D    ;
CODE_038D4F:          ORA $64                             ;; 038D4F : 05 64       ;
CODE_038D51:          STA.W OAM_Prop,Y                    ;; 038D51 : 99 03 03    ;
CODE_038D54:          INY                                 ;; 038D54 : C8          ;
CODE_038D55:          INY                                 ;; 038D55 : C8          ;
CODE_038D56:          INY                                 ;; 038D56 : C8          ;
CODE_038D57:          INY                                 ;; 038D57 : C8          ;
CODE_038D58:          DEX                                 ;; 038D58 : CA          ;
CODE_038D59:          DEC $02                             ;; 038D59 : C6 02       ;
CODE_038D5B:          BPL CODE_038D34                     ;; 038D5B : 10 D7       ;
CODE_038D5D:          PLX                                 ;; 038D5D : FA          ;
CODE_038D5E:          LDY.B #$02                          ;; 038D5E : A0 02       ;
CODE_038D60:          TYA                                 ;; 038D60 : 98          ;
CODE_038D61:          JSL.L FinishOAMWrite                ;; 038D61 : 22 B3 B7 01 ;
Return038D65:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038D66:          .db $00,$04,$07,$08,$08,$07,$04,$00 ;; 038D66               ;
                      .db $00                             ;; ?QPWZ?               ;
                                                          ;;                      ;
InfoBox:              JSL.L InvisBlkMainRt                ;; ?QPWZ? : 22 4F B4 01 ;
CODE_038D73:          JSR.W SubOffscreen0Bnk3             ;; 038D73 : 20 5D B8    ;
CODE_038D76:          LDA.W $1558,X                       ;; 038D76 : BD 58 15    ;
CODE_038D79:          CMP.B #$01                          ;; 038D79 : C9 01       ;
CODE_038D7B:          BNE CODE_038D93                     ;; 038D7B : D0 16       ;
CODE_038D7D:          LDA.B #$22                          ;; 038D7D : A9 22       ; \ Play sound effect 
CODE_038D7F:          STA.W $1DFC                         ;; 038D7F : 8D FC 1D    ; / 
CODE_038D82:          STZ.W $1558,X                       ;; 038D82 : 9E 58 15    ;
CODE_038D85:          STZ RAM_SpriteState,X               ;; 038D85 : 74 C2       ;
CODE_038D87:          LDA RAM_SpriteXLo,X                 ;; 038D87 : B5 E4       ;
CODE_038D89:          LSR                                 ;; 038D89 : 4A          ;
CODE_038D8A:          LSR                                 ;; 038D8A : 4A          ;
CODE_038D8B:          LSR                                 ;; 038D8B : 4A          ;
CODE_038D8C:          LSR                                 ;; 038D8C : 4A          ;
CODE_038D8D:          AND.B #$01                          ;; 038D8D : 29 01       ;
CODE_038D8F:          INC A                               ;; 038D8F : 1A          ;
CODE_038D90:          STA.W $1426                         ;; 038D90 : 8D 26 14    ;
CODE_038D93:          LDA.W $1558,X                       ;; 038D93 : BD 58 15    ;
CODE_038D96:          LSR                                 ;; 038D96 : 4A          ;
CODE_038D97:          TAY                                 ;; 038D97 : A8          ;
CODE_038D98:          LDA RAM_ScreenBndryYLo              ;; 038D98 : A5 1C       ;
CODE_038D9A:          PHA                                 ;; 038D9A : 48          ;
CODE_038D9B:          CLC                                 ;; 038D9B : 18          ;
CODE_038D9C:          ADC.W DATA_038D66,Y                 ;; 038D9C : 79 66 8D    ;
CODE_038D9F:          STA RAM_ScreenBndryYLo              ;; 038D9F : 85 1C       ;
CODE_038DA1:          LDA RAM_ScreenBndryYHi              ;; 038DA1 : A5 1D       ;
CODE_038DA3:          PHA                                 ;; 038DA3 : 48          ;
CODE_038DA4:          ADC.B #$00                          ;; 038DA4 : 69 00       ;
CODE_038DA6:          STA RAM_ScreenBndryYHi              ;; 038DA6 : 85 1D       ;
CODE_038DA8:          JSL.L GenericSprGfxRt2              ;; 038DA8 : 22 B2 90 01 ;
CODE_038DAC:          LDY.W RAM_SprOAMIndex,X             ;; 038DAC : BC EA 15    ; Y = Index into sprite OAM 
CODE_038DAF:          LDA.B #$C0                          ;; 038DAF : A9 C0       ;
CODE_038DB1:          STA.W OAM_Tile,Y                    ;; 038DB1 : 99 02 03    ;
CODE_038DB4:          PLA                                 ;; 038DB4 : 68          ;
CODE_038DB5:          STA RAM_ScreenBndryYHi              ;; 038DB5 : 85 1D       ;
CODE_038DB7:          PLA                                 ;; 038DB7 : 68          ;
CODE_038DB8:          STA RAM_ScreenBndryYLo              ;; 038DB8 : 85 1C       ;
Return038DBA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
TimedLift:            JSR.W TimedPlatformGfx              ;; ?QPWZ? : 20 12 8E    ;
CODE_038DBE:          LDA RAM_SpritesLocked               ;; 038DBE : A5 9D       ;
CODE_038DC0:          BNE Return038DEF                    ;; 038DC0 : D0 2D       ;
CODE_038DC2:          JSR.W SubOffscreen0Bnk3             ;; 038DC2 : 20 5D B8    ;
CODE_038DC5:          LDA RAM_FrameCounter                ;; 038DC5 : A5 13       ;
CODE_038DC7:          AND.B #$00                          ;; 038DC7 : 29 00       ;
CODE_038DC9:          BNE CODE_038DD7                     ;; 038DC9 : D0 0C       ;
CODE_038DCB:          LDA RAM_SpriteState,X               ;; 038DCB : B5 C2       ;
CODE_038DCD:          BEQ CODE_038DD7                     ;; 038DCD : F0 08       ;
CODE_038DCF:          LDA.W $1570,X                       ;; 038DCF : BD 70 15    ;
CODE_038DD2:          BEQ CODE_038DD7                     ;; 038DD2 : F0 03       ;
CODE_038DD4:          DEC.W $1570,X                       ;; 038DD4 : DE 70 15    ;
CODE_038DD7:          LDA.W $1570,X                       ;; 038DD7 : BD 70 15    ;
CODE_038DDA:          BEQ CODE_038DF0                     ;; 038DDA : F0 14       ;
CODE_038DDC:          JSL.L UpdateXPosNoGrvty             ;; 038DDC : 22 22 80 01 ;
CODE_038DE0:          STA.W $1528,X                       ;; 038DE0 : 9D 28 15    ;
CODE_038DE3:          JSL.L InvisBlkMainRt                ;; 038DE3 : 22 4F B4 01 ;
CODE_038DE7:          BCC Return038DEF                    ;; 038DE7 : 90 06       ;
CODE_038DE9:          LDA.B #$10                          ;; 038DE9 : A9 10       ;
CODE_038DEB:          STA RAM_SpriteSpeedX,X              ;; 038DEB : 95 B6       ;
CODE_038DED:          STA RAM_SpriteState,X               ;; 038DED : 95 C2       ;
Return038DEF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038DF0:          JSL.L UpdateSpritePos               ;; 038DF0 : 22 2A 80 01 ;
CODE_038DF4:          LDA.W $1491                         ;; 038DF4 : AD 91 14    ;
CODE_038DF7:          STA.W $1528,X                       ;; 038DF7 : 9D 28 15    ;
CODE_038DFA:          JSL.L InvisBlkMainRt                ;; 038DFA : 22 4F B4 01 ;
Return038DFE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
TimedPlatDispX:       .db $00,$10,$0C                     ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatDispY:       .db $00,$00,$04                     ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatTiles:       .db $C4,$C4,$00                     ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatGfxProp:     .db $0B,$4B,$0B                     ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatTileSize:    .db $02,$02,$00                     ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatNumTiles:    .db $B6,$B5,$B4,$B3                 ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatformGfx:     JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_038E15:          LDA.W $1570,X                       ;; 038E15 : BD 70 15    ;
CODE_038E18:          PHX                                 ;; 038E18 : DA          ;
CODE_038E19:          PHA                                 ;; 038E19 : 48          ;
CODE_038E1A:          LSR                                 ;; 038E1A : 4A          ;
CODE_038E1B:          LSR                                 ;; 038E1B : 4A          ;
CODE_038E1C:          LSR                                 ;; 038E1C : 4A          ;
CODE_038E1D:          LSR                                 ;; 038E1D : 4A          ;
CODE_038E1E:          LSR                                 ;; 038E1E : 4A          ;
CODE_038E1F:          LSR                                 ;; 038E1F : 4A          ;
CODE_038E20:          TAX                                 ;; 038E20 : AA          ;
CODE_038E21:          LDA.W TimedPlatNumTiles,X           ;; 038E21 : BD 0E 8E    ;
CODE_038E24:          STA $02                             ;; 038E24 : 85 02       ;
CODE_038E26:          LDX.B #$02                          ;; 038E26 : A2 02       ;
CODE_038E28:          PLA                                 ;; 038E28 : 68          ;
CODE_038E29:          CMP.B #$08                          ;; 038E29 : C9 08       ;
CODE_038E2B:          BCS CODE_038E2E                     ;; 038E2B : B0 01       ;
CODE_038E2D:          DEX                                 ;; 038E2D : CA          ;
CODE_038E2E:          LDA $00                             ;; 038E2E : A5 00       ;
CODE_038E30:          CLC                                 ;; 038E30 : 18          ;
CODE_038E31:          ADC.W TimedPlatDispX,X              ;; 038E31 : 7D FF 8D    ;
CODE_038E34:          STA.W OAM_DispX,Y                   ;; 038E34 : 99 00 03    ;
CODE_038E37:          LDA $01                             ;; 038E37 : A5 01       ;
CODE_038E39:          CLC                                 ;; 038E39 : 18          ;
CODE_038E3A:          ADC.W TimedPlatDispY,X              ;; 038E3A : 7D 02 8E    ;
CODE_038E3D:          STA.W OAM_DispY,Y                   ;; 038E3D : 99 01 03    ;
CODE_038E40:          LDA.W TimedPlatTiles,X              ;; 038E40 : BD 05 8E    ;
CODE_038E43:          CPX.B #$02                          ;; 038E43 : E0 02       ;
CODE_038E45:          BNE CODE_038E49                     ;; 038E45 : D0 02       ;
CODE_038E47:          LDA $02                             ;; 038E47 : A5 02       ;
CODE_038E49:          STA.W OAM_Tile,Y                    ;; 038E49 : 99 02 03    ;
CODE_038E4C:          LDA.W TimedPlatGfxProp,X            ;; 038E4C : BD 08 8E    ;
CODE_038E4F:          ORA $64                             ;; 038E4F : 05 64       ;
CODE_038E51:          STA.W OAM_Prop,Y                    ;; 038E51 : 99 03 03    ;
CODE_038E54:          PHY                                 ;; 038E54 : 5A          ;
CODE_038E55:          TYA                                 ;; 038E55 : 98          ;
CODE_038E56:          LSR                                 ;; 038E56 : 4A          ;
CODE_038E57:          LSR                                 ;; 038E57 : 4A          ;
CODE_038E58:          TAY                                 ;; 038E58 : A8          ;
CODE_038E59:          LDA.W TimedPlatTileSize,X           ;; 038E59 : BD 0B 8E    ;
CODE_038E5C:          STA.W OAM_TileSize,Y                ;; 038E5C : 99 60 04    ;
CODE_038E5F:          PLY                                 ;; 038E5F : 7A          ;
CODE_038E60:          INY                                 ;; 038E60 : C8          ;
CODE_038E61:          INY                                 ;; 038E61 : C8          ;
CODE_038E62:          INY                                 ;; 038E62 : C8          ;
CODE_038E63:          INY                                 ;; 038E63 : C8          ;
CODE_038E64:          DEX                                 ;; 038E64 : CA          ;
CODE_038E65:          BPL CODE_038E2E                     ;; 038E65 : 10 C7       ;
CODE_038E67:          PLX                                 ;; 038E67 : FA          ;
CODE_038E68:          LDY.B #$FF                          ;; 038E68 : A0 FF       ;
CODE_038E6A:          LDA.B #$02                          ;; 038E6A : A9 02       ;
CODE_038E6C:          JSL.L FinishOAMWrite                ;; 038E6C : 22 B3 B7 01 ;
Return038E70:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
GreyMoveBlkSpeed:     .db $00,$F0,$00,$10                 ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkTiming:    .db $40,$50,$40,$50                 ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyCastleBlock:      JSR.W CODE_038EB4                   ;; ?QPWZ? : 20 B4 8E    ;
CODE_038E7C:          LDA RAM_SpritesLocked               ;; 038E7C : A5 9D       ;
CODE_038E7E:          BNE Return038EA7                    ;; 038E7E : D0 27       ;
CODE_038E80:          LDA.W $1540,X                       ;; 038E80 : BD 40 15    ;
CODE_038E83:          BNE CODE_038E92                     ;; 038E83 : D0 0D       ;
CODE_038E85:          INC RAM_SpriteState,X               ;; 038E85 : F6 C2       ;
CODE_038E87:          LDA RAM_SpriteState,X               ;; 038E87 : B5 C2       ;
CODE_038E89:          AND.B #$03                          ;; 038E89 : 29 03       ;
CODE_038E8B:          TAY                                 ;; 038E8B : A8          ;
CODE_038E8C:          LDA.W GreyMoveBlkTiming,Y           ;; 038E8C : B9 75 8E    ;
CODE_038E8F:          STA.W $1540,X                       ;; 038E8F : 9D 40 15    ;
CODE_038E92:          LDA RAM_SpriteState,X               ;; 038E92 : B5 C2       ;
CODE_038E94:          AND.B #$03                          ;; 038E94 : 29 03       ;
CODE_038E96:          TAY                                 ;; 038E96 : A8          ;
CODE_038E97:          LDA.W GreyMoveBlkSpeed,Y            ;; 038E97 : B9 71 8E    ;
CODE_038E9A:          STA RAM_SpriteSpeedX,X              ;; 038E9A : 95 B6       ;
CODE_038E9C:          JSL.L UpdateXPosNoGrvty             ;; 038E9C : 22 22 80 01 ;
CODE_038EA0:          STA.W $1528,X                       ;; 038EA0 : 9D 28 15    ;
CODE_038EA3:          JSL.L InvisBlkMainRt                ;; 038EA3 : 22 4F B4 01 ;
Return038EA7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
GreyMoveBlkDispX:     .db $00,$10,$00,$10                 ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkDispY:     .db $00,$00,$10,$10                 ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkTiles:     .db $CC,$CE,$EC,$EE                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038EB4:          JSR.W GetDrawInfoBnk3               ;; 038EB4 : 20 60 B7    ;
CODE_038EB7:          PHX                                 ;; 038EB7 : DA          ;
CODE_038EB8:          LDX.B #$03                          ;; 038EB8 : A2 03       ;
CODE_038EBA:          LDA $00                             ;; 038EBA : A5 00       ;
CODE_038EBC:          CLC                                 ;; 038EBC : 18          ;
CODE_038EBD:          ADC.W GreyMoveBlkDispX,X            ;; 038EBD : 7D A8 8E    ;
CODE_038EC0:          STA.W OAM_DispX,Y                   ;; 038EC0 : 99 00 03    ;
CODE_038EC3:          LDA $01                             ;; 038EC3 : A5 01       ;
CODE_038EC5:          CLC                                 ;; 038EC5 : 18          ;
CODE_038EC6:          ADC.W GreyMoveBlkDispY,X            ;; 038EC6 : 7D AC 8E    ;
CODE_038EC9:          STA.W OAM_DispY,Y                   ;; 038EC9 : 99 01 03    ;
CODE_038ECC:          LDA.W GreyMoveBlkTiles,X            ;; 038ECC : BD B0 8E    ;
CODE_038ECF:          STA.W OAM_Tile,Y                    ;; 038ECF : 99 02 03    ;
CODE_038ED2:          LDA.B #$03                          ;; 038ED2 : A9 03       ;
CODE_038ED4:          ORA $64                             ;; 038ED4 : 05 64       ;
CODE_038ED6:          STA.W OAM_Prop,Y                    ;; 038ED6 : 99 03 03    ;
CODE_038ED9:          INY                                 ;; 038ED9 : C8          ;
CODE_038EDA:          INY                                 ;; 038EDA : C8          ;
CODE_038EDB:          INY                                 ;; 038EDB : C8          ;
CODE_038EDC:          INY                                 ;; 038EDC : C8          ;
CODE_038EDD:          DEX                                 ;; 038EDD : CA          ;
CODE_038EDE:          BPL CODE_038EBA                     ;; 038EDE : 10 DA       ;
CODE_038EE0:          PLX                                 ;; 038EE0 : FA          ;
CODE_038EE1:          LDY.B #$02                          ;; 038EE1 : A0 02       ;
CODE_038EE3:          LDA.B #$03                          ;; 038EE3 : A9 03       ;
CODE_038EE5:          JSL.L FinishOAMWrite                ;; 038EE5 : 22 B3 B7 01 ;
Return038EE9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
StatueFireSpeed:      .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireball:       JSR.W StatueFireballGfx             ;; ?QPWZ? : 20 1B 8F    ;
CODE_038EEF:          LDA RAM_SpritesLocked               ;; 038EEF : A5 9D       ;
CODE_038EF1:          BNE Return038F06                    ;; 038EF1 : D0 13       ;
CODE_038EF3:          JSR.W SubOffscreen0Bnk3             ;; 038EF3 : 20 5D B8    ;
CODE_038EF6:          JSL.L MarioSprInteract              ;; 038EF6 : 22 DC A7 01 ;
CODE_038EFA:          LDY.W RAM_SpriteDir,X               ;; 038EFA : BC 7C 15    ;
CODE_038EFD:          LDA.W StatueFireSpeed,Y             ;; 038EFD : B9 EA 8E    ;
CODE_038F00:          STA RAM_SpriteSpeedX,X              ;; 038F00 : 95 B6       ;
CODE_038F02:          JSL.L UpdateXPosNoGrvty             ;; 038F02 : 22 22 80 01 ;
Return038F06:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
StatueFireDispX:      .db $08,$00,$00,$08                 ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireTiles:      .db $32,$50,$33,$34,$32,$50,$33,$34 ;; ?QPWZ?               ;
StatueFireGfxProp:    .db $09,$09,$09,$09,$89,$89,$89,$89 ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireballGfx:    JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_038F1E:          LDA.W RAM_SpriteDir,X               ;; 038F1E : BD 7C 15    ;
CODE_038F21:          ASL                                 ;; 038F21 : 0A          ;
CODE_038F22:          STA $02                             ;; 038F22 : 85 02       ;
CODE_038F24:          LDA RAM_FrameCounterB               ;; 038F24 : A5 14       ;
CODE_038F26:          LSR                                 ;; 038F26 : 4A          ;
CODE_038F27:          AND.B #$03                          ;; 038F27 : 29 03       ;
CODE_038F29:          ASL                                 ;; 038F29 : 0A          ;
CODE_038F2A:          STA $03                             ;; 038F2A : 85 03       ;
CODE_038F2C:          PHX                                 ;; 038F2C : DA          ;
CODE_038F2D:          LDX.B #$01                          ;; 038F2D : A2 01       ;
CODE_038F2F:          LDA $01                             ;; 038F2F : A5 01       ;
CODE_038F31:          STA.W OAM_DispY,Y                   ;; 038F31 : 99 01 03    ;
CODE_038F34:          PHX                                 ;; 038F34 : DA          ;
CODE_038F35:          TXA                                 ;; 038F35 : 8A          ;
CODE_038F36:          ORA $02                             ;; 038F36 : 05 02       ;
CODE_038F38:          TAX                                 ;; 038F38 : AA          ;
CODE_038F39:          LDA $00                             ;; 038F39 : A5 00       ;
CODE_038F3B:          CLC                                 ;; 038F3B : 18          ;
CODE_038F3C:          ADC.W StatueFireDispX,X             ;; 038F3C : 7D 07 8F    ;
CODE_038F3F:          STA.W OAM_DispX,Y                   ;; 038F3F : 99 00 03    ;
CODE_038F42:          PLA                                 ;; 038F42 : 68          ;
CODE_038F43:          PHA                                 ;; 038F43 : 48          ;
CODE_038F44:          ORA $03                             ;; 038F44 : 05 03       ;
CODE_038F46:          TAX                                 ;; 038F46 : AA          ;
CODE_038F47:          LDA.W StatueFireTiles,X             ;; 038F47 : BD 0B 8F    ;
CODE_038F4A:          STA.W OAM_Tile,Y                    ;; 038F4A : 99 02 03    ;
CODE_038F4D:          LDA.W StatueFireGfxProp,X           ;; 038F4D : BD 13 8F    ;
CODE_038F50:          LDX $02                             ;; 038F50 : A6 02       ;
CODE_038F52:          BNE CODE_038F56                     ;; 038F52 : D0 02       ;
ADDR_038F54:          EOR.B #$40                          ;; 038F54 : 49 40       ;
CODE_038F56:          ORA $64                             ;; 038F56 : 05 64       ;
CODE_038F58:          STA.W OAM_Prop,Y                    ;; 038F58 : 99 03 03    ;
CODE_038F5B:          PLX                                 ;; 038F5B : FA          ;
CODE_038F5C:          INY                                 ;; 038F5C : C8          ;
CODE_038F5D:          INY                                 ;; 038F5D : C8          ;
CODE_038F5E:          INY                                 ;; 038F5E : C8          ;
CODE_038F5F:          INY                                 ;; 038F5F : C8          ;
CODE_038F60:          DEX                                 ;; 038F60 : CA          ;
CODE_038F61:          BPL CODE_038F2F                     ;; 038F61 : 10 CC       ;
CODE_038F63:          PLX                                 ;; 038F63 : FA          ;
CODE_038F64:          LDY.B #$00                          ;; 038F64 : A0 00       ;
CODE_038F66:          LDA.B #$01                          ;; 038F66 : A9 01       ;
CODE_038F68:          JSL.L FinishOAMWrite                ;; 038F68 : 22 B3 B7 01 ;
Return038F6C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BooStreamFrntTiles:   .db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C ;; ?QPWZ?               ;
                                                          ;;                      ;
ReflectingFireball:   JSR.W CODE_038FF2                   ;; ?QPWZ? : 20 F2 8F    ;
CODE_038F78:          BRA CODE_038FA4                     ;; 038F78 : 80 2A       ;
                                                          ;;                      ;
BooStream:            LDA.B #$00                          ;; ?QPWZ? : A9 00       ;
CODE_038F7C:          LDY RAM_SpriteSpeedX,X              ;; 038F7C : B4 B6       ;
CODE_038F7E:          BPL CODE_038F81                     ;; 038F7E : 10 01       ;
CODE_038F80:          INC A                               ;; 038F80 : 1A          ;
CODE_038F81:          STA.W RAM_SpriteDir,X               ;; 038F81 : 9D 7C 15    ;
CODE_038F84:          JSL.L GenericSprGfxRt2              ;; 038F84 : 22 B2 90 01 ;
CODE_038F88:          LDY.W RAM_SprOAMIndex,X             ;; 038F88 : BC EA 15    ; Y = Index into sprite OAM 
CODE_038F8B:          LDA RAM_FrameCounterB               ;; 038F8B : A5 14       ;
CODE_038F8D:          LSR                                 ;; 038F8D : 4A          ;
CODE_038F8E:          LSR                                 ;; 038F8E : 4A          ;
CODE_038F8F:          LSR                                 ;; 038F8F : 4A          ;
CODE_038F90:          LSR                                 ;; 038F90 : 4A          ;
CODE_038F91:          AND.B #$01                          ;; 038F91 : 29 01       ;
CODE_038F93:          STA $00                             ;; 038F93 : 85 00       ;
CODE_038F95:          TXA                                 ;; 038F95 : 8A          ;
CODE_038F96:          AND.B #$03                          ;; 038F96 : 29 03       ;
CODE_038F98:          ASL                                 ;; 038F98 : 0A          ;
CODE_038F99:          ORA $00                             ;; 038F99 : 05 00       ;
CODE_038F9B:          PHX                                 ;; 038F9B : DA          ;
CODE_038F9C:          TAX                                 ;; 038F9C : AA          ;
CODE_038F9D:          LDA.W BooStreamFrntTiles,X          ;; 038F9D : BD 6D 8F    ;
CODE_038FA0:          STA.W OAM_Tile,Y                    ;; 038FA0 : 99 02 03    ;
CODE_038FA3:          PLX                                 ;; 038FA3 : FA          ;
CODE_038FA4:          LDA.W $14C8,X                       ;; 038FA4 : BD C8 14    ;
CODE_038FA7:          CMP.B #$08                          ;; 038FA7 : C9 08       ;
CODE_038FA9:          BNE Return038FF1                    ;; 038FA9 : D0 46       ;
CODE_038FAB:          LDA RAM_SpritesLocked               ;; 038FAB : A5 9D       ;
CODE_038FAD:          BNE Return038FF1                    ;; 038FAD : D0 42       ;
CODE_038FAF:          TXA                                 ;; 038FAF : 8A          ;
CODE_038FB0:          EOR RAM_FrameCounterB               ;; 038FB0 : 45 14       ;
CODE_038FB2:          AND.B #$07                          ;; 038FB2 : 29 07       ;
CODE_038FB4:          ORA.W RAM_OffscreenVert,X           ;; 038FB4 : 1D 6C 18    ;
CODE_038FB7:          BNE CODE_038FC2                     ;; 038FB7 : D0 09       ;
CODE_038FB9:          LDA RAM_SpriteNum,X                 ;; 038FB9 : B5 9E       ;
CODE_038FBB:          CMP.B #$B0                          ;; 038FBB : C9 B0       ;
CODE_038FBD:          BNE CODE_038FC2                     ;; 038FBD : D0 03       ;
CODE_038FBF:          JSR.W CODE_039020                   ;; 038FBF : 20 20 90    ;
CODE_038FC2:          JSL.L UpdateYPosNoGrvty             ;; 038FC2 : 22 1A 80 01 ;
CODE_038FC6:          JSL.L UpdateXPosNoGrvty             ;; 038FC6 : 22 22 80 01 ;
CODE_038FCA:          JSL.L CODE_019138                   ;; 038FCA : 22 38 91 01 ;
CODE_038FCE:          LDA.W RAM_SprObjStatus,X            ;; 038FCE : BD 88 15    ; \ Branch if not touching object 
CODE_038FD1:          AND.B #$03                          ;; 038FD1 : 29 03       ;  | 
CODE_038FD3:          BEQ CODE_038FDC                     ;; 038FD3 : F0 07       ; / 
CODE_038FD5:          LDA RAM_SpriteSpeedX,X              ;; 038FD5 : B5 B6       ;
CODE_038FD7:          EOR.B #$FF                          ;; 038FD7 : 49 FF       ;
CODE_038FD9:          INC A                               ;; 038FD9 : 1A          ;
CODE_038FDA:          STA RAM_SpriteSpeedX,X              ;; 038FDA : 95 B6       ;
CODE_038FDC:          LDA.W RAM_SprObjStatus,X            ;; 038FDC : BD 88 15    ;
CODE_038FDF:          AND.B #$0C                          ;; 038FDF : 29 0C       ;
CODE_038FE1:          BEQ CODE_038FEA                     ;; 038FE1 : F0 07       ;
CODE_038FE3:          LDA RAM_SpriteSpeedY,X              ;; 038FE3 : B5 AA       ;
CODE_038FE5:          EOR.B #$FF                          ;; 038FE5 : 49 FF       ;
CODE_038FE7:          INC A                               ;; 038FE7 : 1A          ;
CODE_038FE8:          STA RAM_SpriteSpeedY,X              ;; 038FE8 : 95 AA       ;
CODE_038FEA:          JSL.L MarioSprInteract              ;; 038FEA : 22 DC A7 01 ;
CODE_038FEE:          JSR.W SubOffscreen0Bnk3             ;; 038FEE : 20 5D B8    ;
Return038FF1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038FF2:          JSL.L GenericSprGfxRt2              ;; 038FF2 : 22 B2 90 01 ;
CODE_038FF6:          LDA RAM_FrameCounterB               ;; 038FF6 : A5 14       ;
CODE_038FF8:          LSR                                 ;; 038FF8 : 4A          ;
CODE_038FF9:          LSR                                 ;; 038FF9 : 4A          ;
CODE_038FFA:          LDA.B #$04                          ;; 038FFA : A9 04       ;
CODE_038FFC:          BCC CODE_038FFF                     ;; 038FFC : 90 01       ;
CODE_038FFE:          ASL                                 ;; 038FFE : 0A          ;
CODE_038FFF:          LDY RAM_SpriteSpeedX,X              ;; 038FFF : B4 B6       ;
CODE_039001:          BPL CODE_039005                     ;; 039001 : 10 02       ;
CODE_039003:          EOR.B #$40                          ;; 039003 : 49 40       ;
CODE_039005:          LDY RAM_SpriteSpeedY,X              ;; 039005 : B4 AA       ;
CODE_039007:          BMI CODE_03900B                     ;; 039007 : 30 02       ;
CODE_039009:          EOR.B #$80                          ;; 039009 : 49 80       ;
CODE_03900B:          STA $00                             ;; 03900B : 85 00       ;
CODE_03900D:          LDY.W RAM_SprOAMIndex,X             ;; 03900D : BC EA 15    ; Y = Index into sprite OAM 
CODE_039010:          LDA.B #$AC                          ;; 039010 : A9 AC       ;
CODE_039012:          STA.W OAM_Tile,Y                    ;; 039012 : 99 02 03    ;
CODE_039015:          LDA.W OAM_Prop,Y                    ;; 039015 : B9 03 03    ;
CODE_039018:          AND.B #$31                          ;; 039018 : 29 31       ;
CODE_03901A:          ORA $00                             ;; 03901A : 05 00       ;
CODE_03901C:          STA.W OAM_Prop,Y                    ;; 03901C : 99 03 03    ;
Return03901F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039020:          LDY.B #$0B                          ;; 039020 : A0 0B       ;
CODE_039022:          LDA.W $17F0,Y                       ;; 039022 : B9 F0 17    ;
CODE_039025:          BEQ CODE_039037                     ;; 039025 : F0 10       ;
CODE_039027:          DEY                                 ;; 039027 : 88          ;
CODE_039028:          BPL CODE_039022                     ;; 039028 : 10 F8       ;
ADDR_03902A:          DEC.W $185D                         ;; 03902A : CE 5D 18    ;
ADDR_03902D:          BPL ADDR_039034                     ;; 03902D : 10 05       ;
ADDR_03902F:          LDA.B #$0B                          ;; 03902F : A9 0B       ;
ADDR_039031:          STA.W $185D                         ;; 039031 : 8D 5D 18    ;
ADDR_039034:          LDY.W $185D                         ;; 039034 : AC 5D 18    ;
CODE_039037:          LDA.B #$0A                          ;; 039037 : A9 0A       ;
CODE_039039:          STA.W $17F0,Y                       ;; 039039 : 99 F0 17    ;
CODE_03903C:          LDA RAM_SpriteXLo,X                 ;; 03903C : B5 E4       ;
CODE_03903E:          STA.W $1808,Y                       ;; 03903E : 99 08 18    ;
CODE_039041:          LDA.W RAM_SpriteXHi,X               ;; 039041 : BD E0 14    ;
CODE_039044:          STA.W $18EA,Y                       ;; 039044 : 99 EA 18    ;
CODE_039047:          LDA RAM_SpriteYLo,X                 ;; 039047 : B5 D8       ;
CODE_039049:          STA.W $17FC,Y                       ;; 039049 : 99 FC 17    ;
CODE_03904C:          LDA.W RAM_SpriteYHi,X               ;; 03904C : BD D4 14    ;
CODE_03904F:          STA.W $1814,Y                       ;; 03904F : 99 14 18    ;
CODE_039052:          LDA.B #$30                          ;; 039052 : A9 30       ;
CODE_039054:          STA.W $1850,Y                       ;; 039054 : 99 50 18    ;
CODE_039057:          LDA RAM_SpriteSpeedX,X              ;; 039057 : B5 B6       ;
CODE_039059:          STA.W $182C,Y                       ;; 039059 : 99 2C 18    ;
Return03905C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishinBooAccelX:      .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooMaxSpeedX:   .db $20,$E0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooAccelY:      .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooMaxSpeedY:   .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBoo:            JSR.W FishinBooGfx                  ;; ?QPWZ? : 20 80 91    ;
CODE_039068:          LDA RAM_SpritesLocked               ;; 039068 : A5 9D       ;
CODE_03906A:          BNE Return0390EA                    ;; 03906A : D0 7E       ;
CODE_03906C:          JSL.L MarioSprInteract              ;; 03906C : 22 DC A7 01 ;
CODE_039070:          JSR.W SubHorzPosBnk3                ;; 039070 : 20 17 B8    ;
CODE_039073:          STZ.W $1602,X                       ;; 039073 : 9E 02 16    ;
CODE_039076:          LDA.W $15AC,X                       ;; 039076 : BD AC 15    ;
CODE_039079:          BEQ CODE_039086                     ;; 039079 : F0 0B       ;
CODE_03907B:          INC.W $1602,X                       ;; 03907B : FE 02 16    ;
CODE_03907E:          CMP.B #$10                          ;; 03907E : C9 10       ;
CODE_039080:          BNE CODE_039086                     ;; 039080 : D0 04       ;
CODE_039082:          TYA                                 ;; 039082 : 98          ;
CODE_039083:          STA.W RAM_SpriteDir,X               ;; 039083 : 9D 7C 15    ;
CODE_039086:          TXA                                 ;; 039086 : 8A          ;
CODE_039087:          ASL                                 ;; 039087 : 0A          ;
CODE_039088:          ASL                                 ;; 039088 : 0A          ;
CODE_039089:          ASL                                 ;; 039089 : 0A          ;
CODE_03908A:          ASL                                 ;; 03908A : 0A          ;
CODE_03908B:          ADC RAM_FrameCounter                ;; 03908B : 65 13       ;
CODE_03908D:          AND.B #$3F                          ;; 03908D : 29 3F       ;
CODE_03908F:          ORA.W $15AC,X                       ;; 03908F : 1D AC 15    ;
CODE_039092:          BNE CODE_039099                     ;; 039092 : D0 05       ;
CODE_039094:          LDA.B #$20                          ;; 039094 : A9 20       ;
CODE_039096:          STA.W $15AC,X                       ;; 039096 : 9D AC 15    ;
CODE_039099:          LDA.W $18BF                         ;; 039099 : AD BF 18    ;
CODE_03909C:          BEQ CODE_0390A2                     ;; 03909C : F0 04       ;
ADDR_03909E:          TYA                                 ;; 03909E : 98          ;
ADDR_03909F:          EOR.B #$01                          ;; 03909F : 49 01       ;
ADDR_0390A1:          TAY                                 ;; 0390A1 : A8          ;
CODE_0390A2:          LDA RAM_SpriteSpeedX,X              ;; 0390A2 : B5 B6       ; \ If not at max X speed, accelerate 
CODE_0390A4:          CMP.W FishinBooMaxSpeedX,Y          ;; 0390A4 : D9 5F 90    ;  | 
CODE_0390A7:          BEQ CODE_0390AF                     ;; 0390A7 : F0 06       ;  | 
CODE_0390A9:          CLC                                 ;; 0390A9 : 18          ;  | 
CODE_0390AA:          ADC.W FishinBooAccelX,Y             ;; 0390AA : 79 5D 90    ;  | 
CODE_0390AD:          STA RAM_SpriteSpeedX,X              ;; 0390AD : 95 B6       ; / 
CODE_0390AF:          LDA RAM_FrameCounter                ;; 0390AF : A5 13       ;
CODE_0390B1:          AND.B #$01                          ;; 0390B1 : 29 01       ;
CODE_0390B3:          BNE CODE_0390C9                     ;; 0390B3 : D0 14       ;
CODE_0390B5:          LDA RAM_SpriteState,X               ;; 0390B5 : B5 C2       ;
CODE_0390B7:          AND.B #$01                          ;; 0390B7 : 29 01       ;
CODE_0390B9:          TAY                                 ;; 0390B9 : A8          ;
CODE_0390BA:          LDA RAM_SpriteSpeedY,X              ;; 0390BA : B5 AA       ;
CODE_0390BC:          CLC                                 ;; 0390BC : 18          ;
CODE_0390BD:          ADC.W FishinBooAccelY,Y             ;; 0390BD : 79 61 90    ;
CODE_0390C0:          STA RAM_SpriteSpeedY,X              ;; 0390C0 : 95 AA       ;
CODE_0390C2:          CMP.W FishinBooMaxSpeedY,Y          ;; 0390C2 : D9 63 90    ;
CODE_0390C5:          BNE CODE_0390C9                     ;; 0390C5 : D0 02       ;
CODE_0390C7:          INC RAM_SpriteState,X               ;; 0390C7 : F6 C2       ;
CODE_0390C9:          LDA RAM_SpriteSpeedX,X              ;; 0390C9 : B5 B6       ;
CODE_0390CB:          PHA                                 ;; 0390CB : 48          ;
CODE_0390CC:          LDY.W $18BF                         ;; 0390CC : AC BF 18    ;
CODE_0390CF:          BNE CODE_0390DC                     ;; 0390CF : D0 0B       ;
CODE_0390D1:          LDA.W $17BD                         ;; 0390D1 : AD BD 17    ;
CODE_0390D4:          ASL                                 ;; 0390D4 : 0A          ;
CODE_0390D5:          ASL                                 ;; 0390D5 : 0A          ;
CODE_0390D6:          ASL                                 ;; 0390D6 : 0A          ;
CODE_0390D7:          CLC                                 ;; 0390D7 : 18          ;
CODE_0390D8:          ADC RAM_SpriteSpeedX,X              ;; 0390D8 : 75 B6       ;
CODE_0390DA:          STA RAM_SpriteSpeedX,X              ;; 0390DA : 95 B6       ;
CODE_0390DC:          JSL.L UpdateXPosNoGrvty             ;; 0390DC : 22 22 80 01 ;
CODE_0390E0:          PLA                                 ;; 0390E0 : 68          ;
CODE_0390E1:          STA RAM_SpriteSpeedX,X              ;; 0390E1 : 95 B6       ;
CODE_0390E3:          JSL.L UpdateYPosNoGrvty             ;; 0390E3 : 22 1A 80 01 ;
CODE_0390E7:          JSR.W CODE_0390F3                   ;; 0390E7 : 20 F3 90    ;
Return0390EA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0390EB:          .db $1A,$14,$EE,$F8                 ;; 0390EB               ;
                                                          ;;                      ;
DATA_0390EF:          .db $00,$00,$FF,$FF                 ;; 0390EF               ;
                                                          ;;                      ;
CODE_0390F3:          LDA.W RAM_SpriteDir,X               ;; 0390F3 : BD 7C 15    ;
CODE_0390F6:          ASL                                 ;; 0390F6 : 0A          ;
CODE_0390F7:          ADC.W $1602,X                       ;; 0390F7 : 7D 02 16    ;
CODE_0390FA:          TAY                                 ;; 0390FA : A8          ;
CODE_0390FB:          LDA RAM_SpriteXLo,X                 ;; 0390FB : B5 E4       ;
CODE_0390FD:          CLC                                 ;; 0390FD : 18          ;
CODE_0390FE:          ADC.W DATA_0390EB,Y                 ;; 0390FE : 79 EB 90    ;
CODE_039101:          STA $04                             ;; 039101 : 85 04       ;
CODE_039103:          LDA.W RAM_SpriteXHi,X               ;; 039103 : BD E0 14    ;
CODE_039106:          ADC.W DATA_0390EF,Y                 ;; 039106 : 79 EF 90    ;
CODE_039109:          STA $0A                             ;; 039109 : 85 0A       ;
CODE_03910B:          LDA.B #$04                          ;; 03910B : A9 04       ;
CODE_03910D:          STA $06                             ;; 03910D : 85 06       ;
CODE_03910F:          STA $07                             ;; 03910F : 85 07       ;
CODE_039111:          LDA RAM_SpriteYLo,X                 ;; 039111 : B5 D8       ;
CODE_039113:          CLC                                 ;; 039113 : 18          ;
CODE_039114:          ADC.B #$47                          ;; 039114 : 69 47       ;
CODE_039116:          STA $05                             ;; 039116 : 85 05       ;
CODE_039118:          LDA.W RAM_SpriteYHi,X               ;; 039118 : BD D4 14    ;
CODE_03911B:          ADC.B #$00                          ;; 03911B : 69 00       ;
CODE_03911D:          STA $0B                             ;; 03911D : 85 0B       ;
CODE_03911F:          JSL.L GetMarioClipping              ;; 03911F : 22 64 B6 03 ;
CODE_039123:          JSL.L CheckForContact               ;; 039123 : 22 2B B7 03 ;
CODE_039127:          BCC Return03912D                    ;; 039127 : 90 04       ;
ADDR_039129:          JSL.L HurtMario                     ;; 039129 : 22 B7 F5 00 ;
Return03912D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishinBooDispX:       .db $FB,$05,$00,$F2,$FD,$03,$EA,$EA ;; ?QPWZ?               ;
                      .db $EA,$EA,$FB,$05,$00,$FA,$FD,$03 ;; ?QPWZ?               ;
                      .db $F2,$F2,$F2,$F2,$FB,$05,$00,$0E ;; ?QPWZ?               ;
                      .db $03,$FD,$16,$16,$16,$16,$FB,$05 ;; ?QPWZ?               ;
                      .db $00,$06,$03,$FD,$0E,$0E,$0E,$0E ;; ?QPWZ?               ;
FishinBooDispY:       .db $0B,$0B,$00,$03,$0F,$0F,$13,$23 ;; ?QPWZ?               ;
                      .db $33,$43                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooTiles1:      .db $60,$60,$64,$8A,$60,$60,$AC,$AC ;; ?QPWZ?               ;
                      .db $AC,$CE                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooGfxProp:     .db $04,$04,$0D,$09,$04,$04,$0D,$0D ;; ?QPWZ?               ;
                      .db $0D,$07                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooTiles2:      .db $CC,$CE,$CC,$CE                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_039178:          .db $00,$00,$40,$40                 ;; 039178               ;
                                                          ;;                      ;
DATA_03917C:          .db $00,$40,$C0,$80                 ;; 03917C               ;
                                                          ;;                      ;
FishinBooGfx:         JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_039183:          LDA.W $1602,X                       ;; 039183 : BD 02 16    ;
CODE_039186:          STA $04                             ;; 039186 : 85 04       ;
CODE_039188:          LDA.W RAM_SpriteDir,X               ;; 039188 : BD 7C 15    ;
CODE_03918B:          STA $02                             ;; 03918B : 85 02       ;
CODE_03918D:          PHX                                 ;; 03918D : DA          ;
CODE_03918E:          PHY                                 ;; 03918E : 5A          ;
CODE_03918F:          LDX.B #$09                          ;; 03918F : A2 09       ;
CODE_039191:          LDA $01                             ;; 039191 : A5 01       ;
CODE_039193:          CLC                                 ;; 039193 : 18          ;
CODE_039194:          ADC.W FishinBooDispY,X              ;; 039194 : 7D 56 91    ;
CODE_039197:          STA.W OAM_DispY,Y                   ;; 039197 : 99 01 03    ;
CODE_03919A:          STZ $03                             ;; 03919A : 64 03       ;
CODE_03919C:          LDA.W FishinBooTiles1,X             ;; 03919C : BD 60 91    ;
CODE_03919F:          CPX.B #$09                          ;; 03919F : E0 09       ;
CODE_0391A1:          BNE CODE_0391B4                     ;; 0391A1 : D0 11       ;
CODE_0391A3:          LDA RAM_FrameCounterB               ;; 0391A3 : A5 14       ;
CODE_0391A5:          LSR                                 ;; 0391A5 : 4A          ;
CODE_0391A6:          LSR                                 ;; 0391A6 : 4A          ;
CODE_0391A7:          PHX                                 ;; 0391A7 : DA          ;
CODE_0391A8:          AND.B #$03                          ;; 0391A8 : 29 03       ;
CODE_0391AA:          TAX                                 ;; 0391AA : AA          ;
CODE_0391AB:          LDA.W DATA_039178,X                 ;; 0391AB : BD 78 91    ;
CODE_0391AE:          STA $03                             ;; 0391AE : 85 03       ;
CODE_0391B0:          LDA.W FishinBooTiles2,X             ;; 0391B0 : BD 74 91    ;
CODE_0391B3:          PLX                                 ;; 0391B3 : FA          ;
CODE_0391B4:          STA.W OAM_Tile,Y                    ;; 0391B4 : 99 02 03    ;
CODE_0391B7:          LDA $02                             ;; 0391B7 : A5 02       ;
CODE_0391B9:          CMP.B #$01                          ;; 0391B9 : C9 01       ;
CODE_0391BB:          LDA.W FishinBooGfxProp,X            ;; 0391BB : BD 6A 91    ;
CODE_0391BE:          EOR $03                             ;; 0391BE : 45 03       ;
CODE_0391C0:          ORA $64                             ;; 0391C0 : 05 64       ;
CODE_0391C2:          BCS CODE_0391C6                     ;; 0391C2 : B0 02       ;
CODE_0391C4:          EOR.B #$40                          ;; 0391C4 : 49 40       ;
CODE_0391C6:          STA.W OAM_Prop,Y                    ;; 0391C6 : 99 03 03    ;
CODE_0391C9:          PHX                                 ;; 0391C9 : DA          ;
CODE_0391CA:          LDA $04                             ;; 0391CA : A5 04       ;
CODE_0391CC:          BEQ CODE_0391D3                     ;; 0391CC : F0 05       ;
CODE_0391CE:          TXA                                 ;; 0391CE : 8A          ;
CODE_0391CF:          CLC                                 ;; 0391CF : 18          ;
CODE_0391D0:          ADC.B #$0A                          ;; 0391D0 : 69 0A       ;
CODE_0391D2:          TAX                                 ;; 0391D2 : AA          ;
CODE_0391D3:          LDA $02                             ;; 0391D3 : A5 02       ;
CODE_0391D5:          BNE CODE_0391DC                     ;; 0391D5 : D0 05       ;
CODE_0391D7:          TXA                                 ;; 0391D7 : 8A          ;
CODE_0391D8:          CLC                                 ;; 0391D8 : 18          ;
CODE_0391D9:          ADC.B #$14                          ;; 0391D9 : 69 14       ;
CODE_0391DB:          TAX                                 ;; 0391DB : AA          ;
CODE_0391DC:          LDA $00                             ;; 0391DC : A5 00       ;
CODE_0391DE:          CLC                                 ;; 0391DE : 18          ;
CODE_0391DF:          ADC.W FishinBooDispX,X              ;; 0391DF : 7D 2E 91    ;
CODE_0391E2:          STA.W OAM_DispX,Y                   ;; 0391E2 : 99 00 03    ;
CODE_0391E5:          PLX                                 ;; 0391E5 : FA          ;
CODE_0391E6:          INY                                 ;; 0391E6 : C8          ;
CODE_0391E7:          INY                                 ;; 0391E7 : C8          ;
CODE_0391E8:          INY                                 ;; 0391E8 : C8          ;
CODE_0391E9:          INY                                 ;; 0391E9 : C8          ;
CODE_0391EA:          DEX                                 ;; 0391EA : CA          ;
CODE_0391EB:          BPL CODE_039191                     ;; 0391EB : 10 A4       ;
CODE_0391ED:          LDA RAM_FrameCounterB               ;; 0391ED : A5 14       ;
CODE_0391EF:          LSR                                 ;; 0391EF : 4A          ;
CODE_0391F0:          LSR                                 ;; 0391F0 : 4A          ;
CODE_0391F1:          LSR                                 ;; 0391F1 : 4A          ;
CODE_0391F2:          AND.B #$03                          ;; 0391F2 : 29 03       ;
CODE_0391F4:          TAX                                 ;; 0391F4 : AA          ;
CODE_0391F5:          PLY                                 ;; 0391F5 : 7A          ;
CODE_0391F6:          LDA.W DATA_03917C,X                 ;; 0391F6 : BD 7C 91    ;
CODE_0391F9:          EOR.W $0313,Y                       ;; 0391F9 : 59 13 03    ;
CODE_0391FC:          STA.W $0313,Y                       ;; 0391FC : 99 13 03    ;
CODE_0391FF:          STA.W $0327,Y                       ;; 0391FF : 99 27 03    ;
CODE_039202:          EOR.B #$C0                          ;; 039202 : 49 C0       ;
CODE_039204:          STA.W $0317,Y                       ;; 039204 : 99 17 03    ;
CODE_039207:          STA.W $0323,Y                       ;; 039207 : 99 23 03    ;
CODE_03920A:          PLX                                 ;; 03920A : FA          ;
CODE_03920B:          LDY.B #$02                          ;; 03920B : A0 02       ;
CODE_03920D:          LDA.B #$09                          ;; 03920D : A9 09       ;
CODE_03920F:          JSL.L FinishOAMWrite                ;; 03920F : 22 B3 B7 01 ;
Return039213:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
FallingSpike:         JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_039218:          LDY.W RAM_SprOAMIndex,X             ;; 039218 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03921B:          LDA.B #$E0                          ;; 03921B : A9 E0       ;
CODE_03921D:          STA.W OAM_Tile,Y                    ;; 03921D : 99 02 03    ;
CODE_039220:          LDA.W OAM_DispY,Y                   ;; 039220 : B9 01 03    ;
CODE_039223:          DEC A                               ;; 039223 : 3A          ;
CODE_039224:          STA.W OAM_DispY,Y                   ;; 039224 : 99 01 03    ;
CODE_039227:          LDA.W $1540,X                       ;; 039227 : BD 40 15    ;
CODE_03922A:          BEQ CODE_039237                     ;; 03922A : F0 0B       ;
CODE_03922C:          LSR                                 ;; 03922C : 4A          ;
CODE_03922D:          LSR                                 ;; 03922D : 4A          ;
CODE_03922E:          AND.B #$01                          ;; 03922E : 29 01       ;
CODE_039230:          CLC                                 ;; 039230 : 18          ;
CODE_039231:          ADC.W OAM_DispX,Y                   ;; 039231 : 79 00 03    ;
CODE_039234:          STA.W OAM_DispX,Y                   ;; 039234 : 99 00 03    ;
CODE_039237:          LDA RAM_SpritesLocked               ;; 039237 : A5 9D       ;
CODE_039239:          BNE CODE_03926C                     ;; 039239 : D0 31       ;
CODE_03923B:          JSR.W SubOffscreen0Bnk3             ;; 03923B : 20 5D B8    ;
CODE_03923E:          JSL.L UpdateSpritePos               ;; 03923E : 22 2A 80 01 ;
CODE_039242:          LDA RAM_SpriteState,X               ;; 039242 : B5 C2       ;
CODE_039244:          JSL.L ExecutePtr                    ;; 039244 : 22 DF 86 00 ;
                                                          ;;                      ;
FallingSpikePtrs:     .dw CODE_03924C                     ;; ?QPWZ? : 4C 92       ;
                      .dw CODE_039262                     ;; ?QPWZ? : 62 92       ;
                                                          ;;                      ;
CODE_03924C:          STZ RAM_SpriteSpeedY,X              ;; 03924C : 74 AA       ; Sprite Y Speed = 0 
CODE_03924E:          JSR.W SubHorzPosBnk3                ;; 03924E : 20 17 B8    ;
CODE_039251:          LDA $0F                             ;; 039251 : A5 0F       ;
CODE_039253:          CLC                                 ;; 039253 : 18          ;
CODE_039254:          ADC.B #$40                          ;; 039254 : 69 40       ;
CODE_039256:          CMP.B #$80                          ;; 039256 : C9 80       ;
CODE_039258:          BCS Return039261                    ;; 039258 : B0 07       ;
CODE_03925A:          INC RAM_SpriteState,X               ;; 03925A : F6 C2       ;
CODE_03925C:          LDA.B #$40                          ;; 03925C : A9 40       ;
CODE_03925E:          STA.W $1540,X                       ;; 03925E : 9D 40 15    ;
Return039261:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039262:          LDA.W $1540,X                       ;; 039262 : BD 40 15    ;
CODE_039265:          BNE CODE_03926C                     ;; 039265 : D0 05       ;
CODE_039267:          JSL.L MarioSprInteract              ;; 039267 : 22 DC A7 01 ;
Return03926B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03926C:          STZ RAM_SpriteSpeedY,X              ;; 03926C : 74 AA       ; Sprite Y Speed = 0 
Return03926E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
CrtEatBlkSpeedX:      .db $10,$F0,$00,$00,$00             ;; ?QPWZ?               ;
                                                          ;;                      ;
CrtEatBlkSpeedY:      .db $00,$00,$10,$F0,$00             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_039279:          .db $00,$00,$01,$00,$02,$00,$00,$00 ;; 039279               ;
                      .db $03,$00,$00                     ;; ?QPWZ?               ;
                                                          ;;                      ;
CreateEatBlock:       JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_039288:          LDY.W RAM_SprOAMIndex,X             ;; 039288 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03928B:          LDA.W OAM_DispY,Y                   ;; 03928B : B9 01 03    ;
CODE_03928E:          DEC A                               ;; 03928E : 3A          ;
CODE_03928F:          STA.W OAM_DispY,Y                   ;; 03928F : 99 01 03    ;
CODE_039292:          LDA.B #$2E                          ;; 039292 : A9 2E       ;
CODE_039294:          STA.W OAM_Tile,Y                    ;; 039294 : 99 02 03    ;
CODE_039297:          LDA.W OAM_Prop,Y                    ;; 039297 : B9 03 03    ;
CODE_03929A:          AND.B #$3F                          ;; 03929A : 29 3F       ;
CODE_03929C:          STA.W OAM_Prop,Y                    ;; 03929C : 99 03 03    ;
CODE_03929F:          LDY.B #$02                          ;; 03929F : A0 02       ;
CODE_0392A1:          LDA.B #$00                          ;; 0392A1 : A9 00       ;
CODE_0392A3:          JSL.L FinishOAMWrite                ;; 0392A3 : 22 B3 B7 01 ;
CODE_0392A7:          LDY.B #$04                          ;; 0392A7 : A0 04       ;
CODE_0392A9:          LDA.W $1909                         ;; 0392A9 : AD 09 19    ;
CODE_0392AC:          CMP.B #$FF                          ;; 0392AC : C9 FF       ;
CODE_0392AE:          BEQ CODE_0392C0                     ;; 0392AE : F0 10       ;
CODE_0392B0:          LDA RAM_FrameCounter                ;; 0392B0 : A5 13       ;
CODE_0392B2:          AND.B #$03                          ;; 0392B2 : 29 03       ;
CODE_0392B4:          ORA RAM_SpritesLocked               ;; 0392B4 : 05 9D       ;
CODE_0392B6:          BNE CODE_0392BD                     ;; 0392B6 : D0 05       ;
CODE_0392B8:          LDA.B #$04                          ;; 0392B8 : A9 04       ; \ Play sound effect 
CODE_0392BA:          STA.W $1DFA                         ;; 0392BA : 8D FA 1D    ; / 
CODE_0392BD:          LDY.W RAM_SpriteDir,X               ;; 0392BD : BC 7C 15    ;
CODE_0392C0:          LDA RAM_SpritesLocked               ;; 0392C0 : A5 9D       ;
CODE_0392C2:          BNE Return03932B                    ;; 0392C2 : D0 67       ;
CODE_0392C4:          LDA.W CrtEatBlkSpeedX,Y             ;; 0392C4 : B9 6F 92    ;
CODE_0392C7:          STA RAM_SpriteSpeedX,X              ;; 0392C7 : 95 B6       ;
CODE_0392C9:          LDA.W CrtEatBlkSpeedY,Y             ;; 0392C9 : B9 74 92    ;
CODE_0392CC:          STA RAM_SpriteSpeedY,X              ;; 0392CC : 95 AA       ;
CODE_0392CE:          JSL.L UpdateYPosNoGrvty             ;; 0392CE : 22 1A 80 01 ;
CODE_0392D2:          JSL.L UpdateXPosNoGrvty             ;; 0392D2 : 22 22 80 01 ;
CODE_0392D6:          STZ.W $1528,X                       ;; 0392D6 : 9E 28 15    ;
CODE_0392D9:          JSL.L InvisBlkMainRt                ;; 0392D9 : 22 4F B4 01 ;
CODE_0392DD:          LDA.W $1909                         ;; 0392DD : AD 09 19    ;
CODE_0392E0:          CMP.B #$FF                          ;; 0392E0 : C9 FF       ;
CODE_0392E2:          BEQ Return03932B                    ;; 0392E2 : F0 47       ;
CODE_0392E4:          LDA RAM_SpriteYLo,X                 ;; 0392E4 : B5 D8       ;
CODE_0392E6:          ORA RAM_SpriteXLo,X                 ;; 0392E6 : 15 E4       ;
CODE_0392E8:          AND.B #$0F                          ;; 0392E8 : 29 0F       ;
CODE_0392EA:          BNE Return03932B                    ;; 0392EA : D0 3F       ;
CODE_0392EC:          LDA.W $151C,X                       ;; 0392EC : BD 1C 15    ;
CODE_0392EF:          BNE CODE_03932C                     ;; 0392EF : D0 3B       ;
CODE_0392F1:          DEC.W $1570,X                       ;; 0392F1 : DE 70 15    ;
CODE_0392F4:          BMI CODE_0392F8                     ;; 0392F4 : 30 02       ;
CODE_0392F6:          BNE CODE_03931F                     ;; 0392F6 : D0 27       ;
CODE_0392F8:          LDY.W $0DB3                         ;; 0392F8 : AC B3 0D    ;
CODE_0392FB:          LDA.W $1F11,Y                       ;; 0392FB : B9 11 1F    ;
CODE_0392FE:          CMP.B #$01                          ;; 0392FE : C9 01       ;
CODE_039300:          LDY.W $1534,X                       ;; 039300 : BC 34 15    ;
CODE_039303:          INC.W $1534,X                       ;; 039303 : FE 34 15    ;
CODE_039306:          LDA.W CrtEatBlkData1,Y              ;; 039306 : B9 A4 93    ;
CODE_039309:          BCS CODE_03930E                     ;; 039309 : B0 03       ;
CODE_03930B:          LDA.W CrtEatBlkData2,Y              ;; 03930B : B9 EF 93    ;
CODE_03930E:          STA.W $1602,X                       ;; 03930E : 9D 02 16    ;
CODE_039311:          PHA                                 ;; 039311 : 48          ;
CODE_039312:          LSR                                 ;; 039312 : 4A          ;
CODE_039313:          LSR                                 ;; 039313 : 4A          ;
CODE_039314:          LSR                                 ;; 039314 : 4A          ;
CODE_039315:          LSR                                 ;; 039315 : 4A          ;
CODE_039316:          STA.W $1570,X                       ;; 039316 : 9D 70 15    ;
CODE_039319:          PLA                                 ;; 039319 : 68          ;
CODE_03931A:          AND.B #$03                          ;; 03931A : 29 03       ;
CODE_03931C:          STA.W RAM_SpriteDir,X               ;; 03931C : 9D 7C 15    ;
CODE_03931F:          LDA.B #$0D                          ;; 03931F : A9 0D       ;
CODE_039321:          JSR.W GenTileFromSpr1               ;; 039321 : 20 8B 93    ;
CODE_039324:          LDA.W $1602,X                       ;; 039324 : BD 02 16    ;
CODE_039327:          CMP.B #$FF                          ;; 039327 : C9 FF       ;
CODE_039329:          BEQ CODE_039387                     ;; 039329 : F0 5C       ;
Return03932B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03932C:          LDA.B #$02                          ;; 03932C : A9 02       ;
CODE_03932E:          JSR.W GenTileFromSpr1               ;; 03932E : 20 8B 93    ;
CODE_039331:          LDA.B #$01                          ;; 039331 : A9 01       ;
CODE_039333:          STA RAM_SpriteSpeedX,X              ;; 039333 : 95 B6       ;
CODE_039335:          STA RAM_SpriteSpeedY,X              ;; 039335 : 95 AA       ;
CODE_039337:          JSL.L CODE_019138                   ;; 039337 : 22 38 91 01 ;
CODE_03933B:          LDA.W RAM_SprObjStatus,X            ;; 03933B : BD 88 15    ;
CODE_03933E:          PHA                                 ;; 03933E : 48          ;
CODE_03933F:          LDA.B #$FF                          ;; 03933F : A9 FF       ;
CODE_039341:          STA RAM_SpriteSpeedX,X              ;; 039341 : 95 B6       ;
CODE_039343:          STA RAM_SpriteSpeedY,X              ;; 039343 : 95 AA       ;
CODE_039345:          LDA RAM_SpriteXLo,X                 ;; 039345 : B5 E4       ;
CODE_039347:          PHA                                 ;; 039347 : 48          ;
CODE_039348:          SEC                                 ;; 039348 : 38          ;
CODE_039349:          SBC.B #$01                          ;; 039349 : E9 01       ;
CODE_03934B:          STA RAM_SpriteXLo,X                 ;; 03934B : 95 E4       ;
CODE_03934D:          LDA.W RAM_SpriteXHi,X               ;; 03934D : BD E0 14    ;
CODE_039350:          PHA                                 ;; 039350 : 48          ;
CODE_039351:          SBC.B #$00                          ;; 039351 : E9 00       ;
CODE_039353:          STA.W RAM_SpriteXHi,X               ;; 039353 : 9D E0 14    ;
CODE_039356:          LDA RAM_SpriteYLo,X                 ;; 039356 : B5 D8       ;
CODE_039358:          PHA                                 ;; 039358 : 48          ;
CODE_039359:          SEC                                 ;; 039359 : 38          ;
CODE_03935A:          SBC.B #$01                          ;; 03935A : E9 01       ;
CODE_03935C:          STA RAM_SpriteYLo,X                 ;; 03935C : 95 D8       ;
CODE_03935E:          LDA.W RAM_SpriteYHi,X               ;; 03935E : BD D4 14    ;
CODE_039361:          PHA                                 ;; 039361 : 48          ;
CODE_039362:          SBC.B #$00                          ;; 039362 : E9 00       ;
CODE_039364:          STA.W RAM_SpriteYHi,X               ;; 039364 : 9D D4 14    ;
CODE_039367:          JSL.L CODE_019138                   ;; 039367 : 22 38 91 01 ;
CODE_03936B:          PLA                                 ;; 03936B : 68          ;
CODE_03936C:          STA.W RAM_SpriteYHi,X               ;; 03936C : 9D D4 14    ;
CODE_03936F:          PLA                                 ;; 03936F : 68          ;
CODE_039370:          STA RAM_SpriteYLo,X                 ;; 039370 : 95 D8       ;
CODE_039372:          PLA                                 ;; 039372 : 68          ;
CODE_039373:          STA.W RAM_SpriteXHi,X               ;; 039373 : 9D E0 14    ;
CODE_039376:          PLA                                 ;; 039376 : 68          ;
CODE_039377:          STA RAM_SpriteXLo,X                 ;; 039377 : 95 E4       ;
CODE_039379:          PLA                                 ;; 039379 : 68          ;
CODE_03937A:          ORA.W RAM_SprObjStatus,X            ;; 03937A : 1D 88 15    ;
CODE_03937D:          BEQ CODE_039387                     ;; 03937D : F0 08       ;
CODE_03937F:          TAY                                 ;; 03937F : A8          ;
CODE_039380:          LDA.W DATA_039279,Y                 ;; 039380 : B9 79 92    ;
CODE_039383:          STA.W RAM_SpriteDir,X               ;; 039383 : 9D 7C 15    ;
Return039386:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039387:          STZ.W $14C8,X                       ;; 039387 : 9E C8 14    ;
Return03938A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GenTileFromSpr1:      STA RAM_BlockBlock                  ;; ?QPWZ? : 85 9C       ; $9C = tile to generate 
CODE_03938D:          LDA RAM_SpriteXLo,X                 ;; 03938D : B5 E4       ; \ $9A = Sprite X position 
CODE_03938F:          STA RAM_BlockYLo                    ;; 03938F : 85 9A       ;  | for block creation 
CODE_039391:          LDA.W RAM_SpriteXHi,X               ;; 039391 : BD E0 14    ;  | 
CODE_039394:          STA RAM_BlockYHi                    ;; 039394 : 85 9B       ; / 
CODE_039396:          LDA RAM_SpriteYLo,X                 ;; 039396 : B5 D8       ; \ $98 = Sprite Y position 
CODE_039398:          STA RAM_BlockXLo                    ;; 039398 : 85 98       ;  | for block creation 
CODE_03939A:          LDA.W RAM_SpriteYHi,X               ;; 03939A : BD D4 14    ;  | 
CODE_03939D:          STA RAM_BlockXHi                    ;; 03939D : 85 99       ; / 
CODE_03939F:          JSL.L GenerateTile                  ;; 03939F : 22 B0 BE 00 ; Generate the tile 
Return0393A3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
CrtEatBlkData1:       .db $10,$13,$10,$13,$10,$13,$10,$13 ;; ?QPWZ?               ;
                      .db $10,$13,$10,$13,$10,$13,$10,$13 ;; ?QPWZ?               ;
                      .db $F0,$F0,$20,$12,$10,$12,$10,$12 ;; ?QPWZ?               ;
                      .db $10,$12,$10,$12,$10,$12,$10,$12 ;; ?QPWZ?               ;
                      .db $D0,$C3,$F1,$21,$22,$F1,$F1,$51 ;; ?QPWZ?               ;
                      .db $43,$10,$13,$10,$13,$10,$13,$F0 ;; ?QPWZ?               ;
                      .db $F0,$F0,$60,$32,$60,$32,$71,$32 ;; ?QPWZ?               ;
                      .db $60,$32,$61,$32,$70,$33,$10,$33 ;; ?QPWZ?               ;
                      .db $10,$33,$10,$33,$10,$33,$F0,$10 ;; ?QPWZ?               ;
                      .db $F2,$52,$FF                     ;; ?QPWZ?               ;
                                                          ;;                      ;
CrtEatBlkData2:       .db $80,$13,$10,$13,$10,$13,$10,$13 ;; ?QPWZ?               ;
                      .db $60,$23,$20,$23,$B0,$22,$A1,$22 ;; ?QPWZ?               ;
                      .db $A0,$22,$A1,$22,$C0,$13,$10,$13 ;; ?QPWZ?               ;
                      .db $10,$13,$10,$13,$10,$13,$10,$13 ;; ?QPWZ?               ;
                      .db $10,$13,$F0,$F0,$F0,$52,$50,$33 ;; ?QPWZ?               ;
                      .db $50,$32,$50,$33,$50,$22,$50,$33 ;; ?QPWZ?               ;
                      .db $F0,$50,$82,$FF                 ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodenSpike:          JSR.W WoodSpikeGfx                  ;; ?QPWZ? : 20 CF 94    ;
CODE_039426:          LDA RAM_SpritesLocked               ;; 039426 : A5 9D       ;
CODE_039428:          BNE Return039440                    ;; 039428 : D0 16       ;
CODE_03942A:          JSR.W SubOffscreen0Bnk3             ;; 03942A : 20 5D B8    ;
CODE_03942D:          JSR.W CODE_039488                   ;; 03942D : 20 88 94    ;
CODE_039430:          LDA RAM_SpriteState,X               ;; 039430 : B5 C2       ;
CODE_039432:          AND.B #$03                          ;; 039432 : 29 03       ;
CODE_039434:          JSL.L ExecutePtr                    ;; 039434 : 22 DF 86 00 ;
                                                          ;;                      ;
WoodenSpikePtrs:      .dw CODE_039458                     ;; ?QPWZ? : 58 94       ;
                      .dw CODE_03944E                     ;; ?QPWZ? : 4E 94       ;
                      .dw CODE_039441                     ;; ?QPWZ? : 41 94       ;
                      .dw CODE_03946B                     ;; ?QPWZ? : 6B 94       ;
                                                          ;;                      ;
Return039440:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039441:          LDA.W $1540,X                       ;; 039441 : BD 40 15    ;
CODE_039444:          BEQ CODE_03944A                     ;; 039444 : F0 04       ;
CODE_039446:          LDA.B #$20                          ;; 039446 : A9 20       ;
CODE_039448:          BRA CODE_039475                     ;; 039448 : 80 2B       ;
                                                          ;;                      ;
CODE_03944A:          LDA.B #$30                          ;; 03944A : A9 30       ;
CODE_03944C:          BRA SetTimerNextState               ;; 03944C : 80 17       ;
                                                          ;;                      ;
CODE_03944E:          LDA.W $1540,X                       ;; 03944E : BD 40 15    ;
CODE_039451:          BNE Return039457                    ;; 039451 : D0 04       ;
CODE_039453:          LDA.B #$18                          ;; 039453 : A9 18       ;
CODE_039455:          BRA SetTimerNextState               ;; 039455 : 80 0E       ;
                                                          ;;                      ;
Return039457:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039458:          LDA.W $1540,X                       ;; 039458 : BD 40 15    ;
CODE_03945B:          BEQ CODE_039463                     ;; 03945B : F0 06       ;
CODE_03945D:          LDA.B #$F0                          ;; 03945D : A9 F0       ;
CODE_03945F:          JSR.W CODE_039475                   ;; 03945F : 20 75 94    ;
Return039462:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039463:          LDA.B #$30                          ;; 039463 : A9 30       ;
SetTimerNextState:    STA.W $1540,X                       ;; ?QPWZ? : 9D 40 15    ;
CODE_039468:          INC RAM_SpriteState,X               ;; 039468 : F6 C2       ; Goto next state 
Return03946A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03946B:          LDA.W $1540,X                       ;; 03946B : BD 40 15    ; \ If stall timer us up, 
CODE_03946E:          BNE Return039474                    ;; 03946E : D0 04       ;  | reset it to #$2F... 
CODE_039470:          LDA.B #$2F                          ;; 039470 : A9 2F       ;  | 
CODE_039472:          BRA SetTimerNextState               ;; 039472 : 80 F1       ;  | ...and goto next state 
                                                          ;;                      ;
Return039474:         RTS                                 ;; ?QPWZ? : 60          ; / 
                                                          ;;                      ;
CODE_039475:          LDY.W $151C,X                       ;; 039475 : BC 1C 15    ;
CODE_039478:          BEQ CODE_03947D                     ;; 039478 : F0 03       ;
CODE_03947A:          EOR.B #$FF                          ;; 03947A : 49 FF       ;
CODE_03947C:          INC A                               ;; 03947C : 1A          ;
CODE_03947D:          STA RAM_SpriteSpeedY,X              ;; 03947D : 95 AA       ;
CODE_03947F:          JSL.L UpdateYPosNoGrvty             ;; 03947F : 22 1A 80 01 ;
Return039483:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_039484:          .db $01,$FF                         ;; 039484               ;
                                                          ;;                      ;
DATA_039486:          .db $00,$FF                         ;; 039486               ;
                                                          ;;                      ;
CODE_039488:          JSL.L MarioSprInteract              ;; 039488 : 22 DC A7 01 ;
CODE_03948C:          BCC Return0394B0                    ;; 03948C : 90 22       ;
CODE_03948E:          JSR.W SubHorzPosBnk3                ;; 03948E : 20 17 B8    ;
CODE_039491:          LDA $0F                             ;; 039491 : A5 0F       ;
CODE_039493:          CLC                                 ;; 039493 : 18          ;
CODE_039494:          ADC.B #$04                          ;; 039494 : 69 04       ;
CODE_039496:          CMP.B #$08                          ;; 039496 : C9 08       ;
CODE_039498:          BCS CODE_03949F                     ;; 039498 : B0 05       ;
CODE_03949A:          JSL.L HurtMario                     ;; 03949A : 22 B7 F5 00 ;
Return03949E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03949F:          LDA RAM_MarioXPos                   ;; 03949F : A5 94       ;
CODE_0394A1:          CLC                                 ;; 0394A1 : 18          ;
CODE_0394A2:          ADC.W DATA_039484,Y                 ;; 0394A2 : 79 84 94    ;
CODE_0394A5:          STA RAM_MarioXPos                   ;; 0394A5 : 85 94       ;
CODE_0394A7:          LDA RAM_MarioXPosHi                 ;; 0394A7 : A5 95       ;
CODE_0394A9:          ADC.W DATA_039486,Y                 ;; 0394A9 : 79 86 94    ;
CODE_0394AC:          STA RAM_MarioXPosHi                 ;; 0394AC : 85 95       ;
CODE_0394AE:          STZ RAM_MarioSpeedX                 ;; 0394AE : 64 7B       ;
Return0394B0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
WoodSpikeDispY:       .db $00,$10,$20,$30,$40,$40,$30,$20 ;; ?QPWZ?               ;
                      .db $10,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeTiles:       .db $6A,$6A,$6A,$6A,$4A,$6A,$6A,$6A ;; ?QPWZ?               ;
                      .db $6A,$4A                         ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeGfxProp:     .db $81,$81,$81,$81,$81,$01,$01,$01 ;; ?QPWZ?               ;
                      .db $01,$01                         ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeGfx:         JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_0394D2:          STZ $02                             ;; 0394D2 : 64 02       ; \ Set $02 based on sprite number 
CODE_0394D4:          LDA RAM_SpriteNum,X                 ;; 0394D4 : B5 9E       ;  | 
CODE_0394D6:          CMP.B #$AD                          ;; 0394D6 : C9 AD       ;  | 
CODE_0394D8:          BNE CODE_0394DE                     ;; 0394D8 : D0 04       ;  | 
CODE_0394DA:          LDA.B #$05                          ;; 0394DA : A9 05       ;  | 
CODE_0394DC:          STA $02                             ;; 0394DC : 85 02       ; / 
CODE_0394DE:          PHX                                 ;; 0394DE : DA          ;
CODE_0394DF:          LDX.B #$04                          ;; 0394DF : A2 04       ; Draw 4 tiles: 
WoodSpikeGfxLoopSt:   PHX                                 ;; ?QPWZ? : DA          ;
CODE_0394E2:          TXA                                 ;; 0394E2 : 8A          ;
CODE_0394E3:          CLC                                 ;; 0394E3 : 18          ;
CODE_0394E4:          ADC $02                             ;; 0394E4 : 65 02       ;
CODE_0394E6:          TAX                                 ;; 0394E6 : AA          ;
CODE_0394E7:          LDA $00                             ;; 0394E7 : A5 00       ; \ Set X 
CODE_0394E9:          STA.W OAM_DispX,Y                   ;; 0394E9 : 99 00 03    ; / 
CODE_0394EC:          LDA $01                             ;; 0394EC : A5 01       ; \ Set Y 
CODE_0394EE:          CLC                                 ;; 0394EE : 18          ;  | 
CODE_0394EF:          ADC.W WoodSpikeDispY,X              ;; 0394EF : 7D B1 94    ;  | 
CODE_0394F2:          STA.W OAM_DispY,Y                   ;; 0394F2 : 99 01 03    ; / 
CODE_0394F5:          LDA.W WoodSpikeTiles,X              ;; 0394F5 : BD BB 94    ; \ Set tile 
CODE_0394F8:          STA.W OAM_Tile,Y                    ;; 0394F8 : 99 02 03    ; / 
CODE_0394FB:          LDA.W WoodSpikeGfxProp,X            ;; 0394FB : BD C5 94    ; \ Set gfs properties 
CODE_0394FE:          STA.W OAM_Prop,Y                    ;; 0394FE : 99 03 03    ; / 
CODE_039501:          INY                                 ;; 039501 : C8          ; \ We wrote 4 times, so increase index by 4 
CODE_039502:          INY                                 ;; 039502 : C8          ;  | 
CODE_039503:          INY                                 ;; 039503 : C8          ;  | 
CODE_039504:          INY                                 ;; 039504 : C8          ; / 
CODE_039505:          PLX                                 ;; 039505 : FA          ;
CODE_039506:          DEX                                 ;; 039506 : CA          ;
CODE_039507:          BPL WoodSpikeGfxLoopSt              ;; 039507 : 10 D8       ;
CODE_039509:          PLX                                 ;; 039509 : FA          ;
CODE_03950A:          LDY.B #$02                          ;; 03950A : A0 02       ; \ Wrote 5 16x16 tiles... 
CODE_03950C:          LDA.B #$04                          ;; 03950C : A9 04       ;  | 
CODE_03950E:          JSL.L FinishOAMWrite                ;; 03950E : 22 B3 B7 01 ; / 
Return039512:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
RexSpeed:             .db $08,$F8,$10,$F0                 ;; ?QPWZ?               ;
                                                          ;;                      ;
RexMainRt:            JSR.W RexGfxRt                      ;; ?QPWZ? : 20 7E 96    ; Draw Rex gfx							        
CODE_03951A:          LDA.W $14C8,X                       ;; 03951A : BD C8 14    ; \ If Rex status != 8...						        
CODE_03951D:          CMP.B #$08                          ;; 03951D : C9 08       ;  |   ... not (killed with spin jump [4] or star [2])		        
CODE_03951F:          BNE RexReturn                       ;; 03951F : D0 12       ; /    ... return							        
CODE_039521:          LDA RAM_SpritesLocked               ;; 039521 : A5 9D       ; \ If sprites locked...						        
CODE_039523:          BNE RexReturn                       ;; 039523 : D0 0E       ; /    ... return							        
CODE_039525:          LDA.W $1558,X                       ;; 039525 : BD 58 15    ; \ If Rex not defeated (timer to show remains > 0)...		        
CODE_039528:          BEQ RexAlive                        ;; 039528 : F0 0A       ; /    ... goto RexAlive						        
CODE_03952A:          STA.W $15D0,X                       ;; 03952A : 9D D0 15    ; \ 								        
CODE_03952D:          DEC A                               ;; 03952D : 3A          ;  |   If Rex remains don't disappear next frame...			        
CODE_03952E:          BNE RexReturn                       ;; 03952E : D0 03       ; /    ... return							        
CODE_039530:          STZ.W $14C8,X                       ;; 039530 : 9E C8 14    ; This is the last frame to show remains, so set Rex status = 0 
RexReturn:            RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexAlive:             JSR.W SubOffscreen0Bnk3             ;; ?QPWZ? : 20 5D B8    ; Only process Rex while on screen		    
CODE_039537:          INC.W $1570,X                       ;; 039537 : FE 70 15    ; Increment number of frames Rex has been on sc 
CODE_03953A:          LDA.W $1570,X                       ;; 03953A : BD 70 15    ; \ Calculate which frame to show:		    
CODE_03953D:          LSR                                 ;; 03953D : 4A          ;  | 					    
CODE_03953E:          LSR                                 ;; 03953E : 4A          ;  | 					    
CODE_03953F:          LDY RAM_SpriteState,X               ;; 03953F : B4 C2       ;  | Number of hits determines if smushed	    
CODE_039541:          BEQ CODE_03954A                     ;; 039541 : F0 07       ;  |						    
CODE_039543:          AND.B #$01                          ;; 039543 : 29 01       ;  | Update every 8 cycles if smushed	    
CODE_039545:          CLC                                 ;; 039545 : 18          ;  |						    
CODE_039546:          ADC.B #$03                          ;; 039546 : 69 03       ;  | Show smushed frame			    
CODE_039548:          BRA CODE_03954D                     ;; 039548 : 80 03       ;  |						    
                                                          ;;                      ;
CODE_03954A:          LSR                                 ;; 03954A : 4A          ;  | 					    
CODE_03954B:          AND.B #$01                          ;; 03954B : 29 01       ;  | Update every 16 cycles if normal	    
CODE_03954D:          STA.W $1602,X                       ;; 03954D : 9D 02 16    ; / Write frame to show			    
CODE_039550:          LDA.W RAM_SprObjStatus,X            ;; 039550 : BD 88 15    ; \  If sprite is not on ground...		    
CODE_039553:          AND.B #$04                          ;; 039553 : 29 04       ;  |    ...(4 = on ground) ...		    
CODE_039555:          BEQ RexInAir                        ;; 039555 : F0 12       ; /     ...goto IN_AIR			    
CODE_039557:          LDA.B #$10                          ;; 039557 : A9 10       ; \  Y speed = 10				    
CODE_039559:          STA RAM_SpriteSpeedY,X              ;; 039559 : 95 AA       ; /						    
CODE_03955B:          LDY.W RAM_SpriteDir,X               ;; 03955B : BC 7C 15    ; Load, y = Rex direction, as index for speed   
CODE_03955E:          LDA RAM_SpriteState,X               ;; 03955E : B5 C2       ; \ If hits on Rex == 0...			    
CODE_039560:          BEQ RexNoAdjustSpeed                ;; 039560 : F0 02       ; /    ...goto DONT_ADJUST_SPEED		    
CODE_039562:          INY                                 ;; 039562 : C8          ; \ Increment y twice...			    
CODE_039563:          INY                                 ;; 039563 : C8          ; /    ...in order to get speed for smushed Rex 
RexNoAdjustSpeed:     LDA.W RexSpeed,Y                    ;; ?QPWZ? : B9 13 95    ; \ Load x speed from ROM...		    
CODE_039567:          STA RAM_SpriteSpeedX,X              ;; 039567 : 95 B6       ; /    ...and store it			    
RexInAir:             LDA.W $1FE2,X                       ;; ?QPWZ? : BD E2 1F    ; \ If time to show half-smushed Rex > 0...	    
CODE_03956C:          BNE RexHalfSmushed                  ;; 03956C : D0 04       ; /    ...goto HALF_SMUSHED			    
CODE_03956E:          JSL.L UpdateSpritePos               ;; 03956E : 22 2A 80 01 ; Update position based on speed values	    
RexHalfSmushed:       LDA.W RAM_SprObjStatus,X            ;; ?QPWZ? : BD 88 15    ; \ If Rex is touching the side of an object... 
CODE_039575:          AND.B #$03                          ;; 039575 : 29 03       ;  |					        
CODE_039577:          BEQ CODE_039581                     ;; 039577 : F0 08       ;  |					        
CODE_039579:          LDA.W RAM_SpriteDir,X               ;; 039579 : BD 7C 15    ;  |					        
CODE_03957C:          EOR.B #$01                          ;; 03957C : 49 01       ;  |    ... change Rex direction	        
CODE_03957E:          STA.W RAM_SpriteDir,X               ;; 03957E : 9D 7C 15    ; /					        
CODE_039581:          JSL.L SprSprInteract                ;; 039581 : 22 32 80 01 ; Interact with other sprites	        
CODE_039585:          JSL.L MarioSprInteract              ;; 039585 : 22 DC A7 01 ; Check for mario/Rex contact 
CODE_039589:          BCC NoRexContact                    ;; 039589 : 90 52       ; (carry set = mario/Rex contact)	        
CODE_03958B:          LDA.W $1490                         ;; 03958B : AD 90 14    ; \ If mario star timer > 0 ...	        
CODE_03958E:          BNE RexStarKill                     ;; 03958E : D0 62       ; /    ... goto HAS_STAR		        
CODE_039590:          LDA.W RAM_DisableInter,X            ;; 039590 : BD 4C 15    ; \ If Rex invincibility timer > 0 ...      
CODE_039593:          BNE NoRexContact                    ;; 039593 : D0 48       ; /    ... goto NO_CONTACT		        
CODE_039595:          LDA.B #$08                          ;; 039595 : A9 08       ; \ Rex invincibility timer = $08	        
CODE_039597:          STA.W RAM_DisableInter,X            ;; 039597 : 9D 4C 15    ; /					        
CODE_03959A:          LDA RAM_MarioSpeedY                 ;; 03959A : A5 7D       ; \  If mario's y speed < 10 ...	        
CODE_03959C:          CMP.B #$10                          ;; 03959C : C9 10       ;  |   ... Rex will hurt mario	        
CODE_03959E:          BMI RexWins                         ;; 03959E : 30 2A       ; /    				        
MarioBeatsRex:        JSR.W RexPoints                     ;; ?QPWZ? : 20 28 96    ; Give mario points			        
CODE_0395A3:          JSL.L BoostMarioSpeed               ;; 0395A3 : 22 33 AA 01 ; Set mario speed			        
CODE_0395A7:          JSL.L DisplayContactGfx             ;; 0395A7 : 22 99 AB 01 ; Display contact graphic		        
CODE_0395AB:          LDA.W RAM_IsSpinJump                ;; 0395AB : AD 0D 14    ; \  If mario is spin jumping...	        
CODE_0395AE:          ORA.W RAM_OnYoshi                   ;; 0395AE : 0D 7A 18    ;  |    ... or on yoshi ...		        
CODE_0395B1:          BNE RexSpinKill                     ;; 0395B1 : D0 2B       ; /     ... goto SPIN_KILL		        
CODE_0395B3:          INC RAM_SpriteState,X               ;; 0395B3 : F6 C2       ; Increment Rex hit counter		        
CODE_0395B5:          LDA RAM_SpriteState,X               ;; 0395B5 : B5 C2       ; \  If Rex hit counter == 2	        
CODE_0395B7:          CMP.B #$02                          ;; 0395B7 : C9 02       ;  |   				        
CODE_0395B9:          BNE SmushRex                        ;; 0395B9 : D0 06       ;  |				        
CODE_0395BB:          LDA.B #$20                          ;; 0395BB : A9 20       ;  |    ... time to show defeated Rex = $20 
CODE_0395BD:          STA.W $1558,X                       ;; 0395BD : 9D 58 15    ; / 
Return0395C0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SmushRex:             LDA.B #$0C                          ;; ?QPWZ? : A9 0C       ; \ Time to show semi-squashed Rex = $0C 
CODE_0395C3:          STA.W $1FE2,X                       ;; 0395C3 : 9D E2 1F    ; /					     
CODE_0395C6:          STZ.W RAM_Tweaker1662,X             ;; 0395C6 : 9E 62 16    ; Change clipping area for squashed Rex  
Return0395C9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexWins:              LDA.W $1497                         ;; ?QPWZ? : AD 97 14    ; \ If mario is invincible...	  
CODE_0395CD:          ORA.W RAM_OnYoshi                   ;; 0395CD : 0D 7A 18    ;  |  ... or mario on yoshi...	  
CODE_0395D0:          BNE NoRexContact                    ;; 0395D0 : D0 0B       ; /   ... return			  
CODE_0395D2:          JSR.W SubHorzPosBnk3                ;; 0395D2 : 20 17 B8    ; \  Set new Rex direction		  
CODE_0395D5:          TYA                                 ;; 0395D5 : 98          ;  |  				  
CODE_0395D6:          STA.W RAM_SpriteDir,X               ;; 0395D6 : 9D 7C 15    ; /					  
CODE_0395D9:          JSL.L HurtMario                     ;; 0395D9 : 22 B7 F5 00 ; Hurt mario			  
NoRexContact:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexSpinKill:          LDA.B #$04                          ;; ?QPWZ? : A9 04       ; \ Rex status = 4 (being killed by spin jump)   
CODE_0395E0:          STA.W $14C8,X                       ;; 0395E0 : 9D C8 14    ; /   					     
CODE_0395E3:          LDA.B #$1F                          ;; 0395E3 : A9 1F       ; \ Set spin jump animation timer		     
CODE_0395E5:          STA.W $1540,X                       ;; 0395E5 : 9D 40 15    ; /						     
CODE_0395E8:          JSL.L CODE_07FC3B                   ;; 0395E8 : 22 3B FC 07 ; Show star animation			     
CODE_0395EC:          LDA.B #$08                          ;; 0395EC : A9 08       ; \ 
CODE_0395EE:          STA.W $1DF9                         ;; 0395EE : 8D F9 1D    ; / Play sound effect 
Return0395F1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexStarKill:          LDA.B #$02                          ;; ?QPWZ? : A9 02       ; \ Rex status = 2 (being killed by star)			   
ADDR_0395F4:          STA.W $14C8,X                       ;; 0395F4 : 9D C8 14    ; /								   
ADDR_0395F7:          LDA.B #$D0                          ;; 0395F7 : A9 D0       ; \ Set y speed						   
ADDR_0395F9:          STA RAM_SpriteSpeedY,X              ;; 0395F9 : 95 AA       ; /								   
ADDR_0395FB:          JSR.W SubHorzPosBnk3                ;; 0395FB : 20 17 B8    ; Get new Rex direction					   
ADDR_0395FE:          LDA.W RexKilledSpeed,Y              ;; 0395FE : B9 25 96    ; \ Set x speed based on Rex direction			   
ADDR_039601:          STA RAM_SpriteSpeedX,X              ;; 039601 : 95 B6       ; /								   
ADDR_039603:          INC.W $18D2                         ;; 039603 : EE D2 18    ; Increment number consecutive enemies killed		   
ADDR_039606:          LDA.W $18D2                         ;; 039606 : AD D2 18    ; \								   
ADDR_039609:          CMP.B #$08                          ;; 039609 : C9 08       ;  | If consecutive enemies stomped >= 8, reset to 8		   
ADDR_03960B:          BCC ADDR_039612                     ;; 03960B : 90 05       ;  |								   
ADDR_03960D:          LDA.B #$08                          ;; 03960D : A9 08       ;  |								   
ADDR_03960F:          STA.W $18D2                         ;; 03960F : 8D D2 18    ; /   							   
ADDR_039612:          JSL.L GivePoints                    ;; 039612 : 22 E5 AC 02 ; Give mario points						   
ADDR_039616:          LDY.W $18D2                         ;; 039616 : AC D2 18    ; \ 							   
ADDR_039619:          CPY.B #$08                          ;; 039619 : C0 08       ;  | If consecutive enemies stomped < 8 ...			   
ADDR_03961B:          BCS Return039623                    ;; 03961B : B0 06       ;  |								   
ADDR_03961D:          LDA.W $7FFF,Y                       ;; 03961D : B9 FF 7F    ;  |    ... play sound effect				   
ADDR_039620:          STA.W $1DF9                         ;; 039620 : 8D F9 1D    ; / Play sound effect 
Return039623:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
Return039624:         RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
                                                          ;;                      ;
RexKilledSpeed:       .db $F0,$10                         ;; ?QPWZ?               ;
                                                          ;;                      ;
Return039627:         RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
RexPoints:            PHY                                 ;; ?QPWZ? : 5A          ;
CODE_039629:          LDA.W $1697                         ;; 039629 : AD 97 16    ;
CODE_03962C:          CLC                                 ;; 03962C : 18          ;
CODE_03962D:          ADC.W $1626,X                       ;; 03962D : 7D 26 16    ;
CODE_039630:          INC.W $1697                         ;; 039630 : EE 97 16    ; Increase consecutive enemies stomped		       
CODE_039633:          TAY                                 ;; 039633 : A8          ;  							     
CODE_039634:          INY                                 ;; 039634 : C8          ;  							     
CODE_039635:          CPY.B #$08                          ;; 039635 : C0 08       ; \ If consecutive enemies stomped >= 8 ...		       
CODE_039637:          BCS CODE_03963F                     ;; 039637 : B0 06       ; /    ... don't play sound 			       
CODE_039639:          LDA.W $7FFF,Y                       ;; 039639 : B9 FF 7F    ; \  
CODE_03963C:          STA.W $1DF9                         ;; 03963C : 8D F9 1D    ; / Play sound effect 
CODE_03963F:          TYA                                 ;; 03963F : 98          ; \							       
CODE_039640:          CMP.B #$08                          ;; 039640 : C9 08       ;  | If consecutive enemies stomped >= 8, reset to 8       
CODE_039642:          BCC CODE_039646                     ;; 039642 : 90 02       ;  |						       
ADDR_039644:          LDA.B #$08                          ;; 039644 : A9 08       ; /							       
CODE_039646:          JSL.L GivePoints                    ;; 039646 : 22 E5 AC 02 ; Give mario points					       
CODE_03964A:          PLY                                 ;; 03964A : 7A          ;  							     
Return03964B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
RexTileDispX:         .db $FC,$00,$FC,$00,$FE,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$08,$04,$00,$04,$00 ;; ?QPWZ?               ;
                      .db $02,$00,$00,$00,$00,$00,$08,$00 ;; ?QPWZ?               ;
RexTileDispY:         .db $F1,$00,$F0,$00,$F8,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$08,$08                 ;; ?QPWZ?               ;
                                                          ;;                      ;
RexTiles:             .db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C ;; ?QPWZ?               ;
                      .db $A8,$A8,$A2,$B2                 ;; ?QPWZ?               ;
                                                          ;;                      ;
RexGfxProp:           .db $47,$07                         ;; ?QPWZ?               ;
                                                          ;;                      ;
RexGfxRt:             LDA.W $1558,X                       ;; ?QPWZ? : BD 58 15    ; \ If time to show Rex remains > 0...							  
CODE_039681:          BEQ RexGfxAlive                     ;; 039681 : F0 05       ;  |												  
CODE_039683:          LDA.B #$05                          ;; 039683 : A9 05       ;  |    ...set Rex frame = 5 (fully squashed)						  
CODE_039685:          STA.W $1602,X                       ;; 039685 : 9D 02 16    ; /												  
RexGfxAlive:          LDA.W $1FE2,X                       ;; ?QPWZ? : BD E2 1F    ; \ If time to show half smushed Rex > 0...							  
CODE_03968B:          BEQ RexNotHalfSmushed               ;; 03968B : F0 05       ;  |												  
CODE_03968D:          LDA.B #$02                          ;; 03968D : A9 02       ;  |    ...set Rex frame = 2 (half smushed)							  
CODE_03968F:          STA.W $1602,X                       ;; 03968F : 9D 02 16    ; /												  
RexNotHalfSmushed:    JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ; Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
CODE_039695:          LDA.W $1602,X                       ;; 039695 : BD 02 16    ; \												  
CODE_039698:          ASL                                 ;; 039698 : 0A          ;  | $03 = index to frame start (frame to show * 2 tile per frame)				  
CODE_039699:          STA $03                             ;; 039699 : 85 03       ; /												  
CODE_03969B:          LDA.W RAM_SpriteDir,X               ;; 03969B : BD 7C 15    ; \ $02 = sprite direction									  
CODE_03969E:          STA $02                             ;; 03969E : 85 02       ; /												  
CODE_0396A0:          PHX                                 ;; 0396A0 : DA          ; Push sprite index										  
CODE_0396A1:          LDX.B #$01                          ;; 0396A1 : A2 01       ; Loop counter = (number of tiles per frame) - 1						  
RexGfxLoopStart:      PHX                                 ;; ?QPWZ? : DA          ; Push current tile number									  
CODE_0396A4:          TXA                                 ;; 0396A4 : 8A          ; \ X = index to horizontal displacement							  
CODE_0396A5:          ORA $03                             ;; 0396A5 : 05 03       ; / get index of tile (index to first tile of frame + current tile number)			  
CODE_0396A7:          PHA                                 ;; 0396A7 : 48          ; Push index of current tile								  
CODE_0396A8:          LDX $02                             ;; 0396A8 : A6 02       ; \ If facing right...									  
CODE_0396AA:          BNE RexFaceLeft                     ;; 0396AA : D0 03       ;  |												  
CODE_0396AC:          CLC                                 ;; 0396AC : 18          ;  |    											  
CODE_0396AD:          ADC.B #$0C                          ;; 0396AD : 69 0C       ; /    ...use row 2 of horizontal tile displacement table					  
RexFaceLeft:          TAX                                 ;; ?QPWZ? : AA          ; \ 											  
CODE_0396B0:          LDA $00                             ;; 0396B0 : A5 00       ;  | Tile x position = sprite x location ($00) + tile displacement				  
CODE_0396B2:          CLC                                 ;; 0396B2 : 18          ;  |												  
CODE_0396B3:          ADC.W RexTileDispX,X                ;; 0396B3 : 7D 4C 96    ;  |												  
CODE_0396B6:          STA.W OAM_DispX,Y                   ;; 0396B6 : 99 00 03    ; /												  
CODE_0396B9:          PLX                                 ;; 0396B9 : FA          ; \ Pull, X = index to vertical displacement and tilemap					  
CODE_0396BA:          LDA $01                             ;; 0396BA : A5 01       ;  | Tile y position = sprite y location ($01) + tile displacement				  
CODE_0396BC:          CLC                                 ;; 0396BC : 18          ;  |												  
CODE_0396BD:          ADC.W RexTileDispY,X                ;; 0396BD : 7D 64 96    ;  |												  
CODE_0396C0:          STA.W OAM_DispY,Y                   ;; 0396C0 : 99 01 03    ; /												  
CODE_0396C3:          LDA.W RexTiles,X                    ;; 0396C3 : BD 70 96    ; \ Store tile										  
CODE_0396C6:          STA.W OAM_Tile,Y                    ;; 0396C6 : 99 02 03    ; / 											  
CODE_0396C9:          LDX $02                             ;; 0396C9 : A6 02       ; \												  
CODE_0396CB:          LDA.W RexGfxProp,X                  ;; 0396CB : BD 7C 96    ;  | Get tile properties using sprite direction						  
CODE_0396CE:          ORA $64                             ;; 0396CE : 05 64       ;  | Level properties 
CODE_0396D0:          STA.W OAM_Prop,Y                    ;; 0396D0 : 99 03 03    ; / Store tile properties									  
CODE_0396D3:          TYA                                 ;; 0396D3 : 98          ; \ Get index to sprite property map ($460)...						  
CODE_0396D4:          LSR                                 ;; 0396D4 : 4A          ;  |    ...we use the sprite OAM index...							  
CODE_0396D5:          LSR                                 ;; 0396D5 : 4A          ;  |    ...and divide by 4 because a 16x16 tile is 4 8x8 tiles				  
CODE_0396D6:          LDX $03                             ;; 0396D6 : A6 03       ;  | If index of frame start is > 0A 							  
CODE_0396D8:          CPX.B #$0A                          ;; 0396D8 : E0 0A       ;  |												  
CODE_0396DA:          TAX                                 ;; 0396DA : AA          ;  | 
CODE_0396DB:          LDA.B #$00                          ;; 0396DB : A9 00       ;  |     ...show only an 8x8 tile			   
CODE_0396DD:          BCS Rex8x8Tile                      ;; 0396DD : B0 02       ;  |							   
CODE_0396DF:          LDA.B #$02                          ;; 0396DF : A9 02       ;  | Else show a full 16 x 16 tile			   
Rex8x8Tile:           STA.W OAM_TileSize,X                ;; ?QPWZ? : 9D 60 04    ; /							   
CODE_0396E4:          PLX                                 ;; 0396E4 : FA          ; \ Pull, X = current tile of the frame we're drawing  
CODE_0396E5:          INY                                 ;; 0396E5 : C8          ;  | Increase index to sprite tile map ($300)...	   
CODE_0396E6:          INY                                 ;; 0396E6 : C8          ;  |    ...we wrote 4 times...			   
CODE_0396E7:          INY                                 ;; 0396E7 : C8          ;  |    ...so increment 4 times			  
CODE_0396E8:          INY                                 ;; 0396E8 : C8          ;  | 
CODE_0396E9:          DEX                                 ;; 0396E9 : CA          ;  | Go to next tile of frame and loop		   
CODE_0396EA:          BPL RexGfxLoopStart                 ;; 0396EA : 10 B7       ; / 						   
CODE_0396EC:          PLX                                 ;; 0396EC : FA          ; Pull, X = sprite index				   
CODE_0396ED:          LDY.B #$FF                          ;; 0396ED : A0 FF       ; \ FF because we already wrote size to $0460    		   
CODE_0396EF:          LDA.B #$01                          ;; 0396EF : A9 01       ;  | A = number of tiles drawn - 1			   
CODE_0396F1:          JSL.L FinishOAMWrite                ;; 0396F1 : 22 B3 B7 01 ; / Don't draw if offscreen				   
Return0396F5:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
Fishbone:             JSR.W FishboneGfx                   ;; ?QPWZ? : 20 8C 97    ;
CODE_0396F9:          LDA RAM_SpritesLocked               ;; 0396F9 : A5 9D       ;
CODE_0396FB:          BNE Return03972A                    ;; 0396FB : D0 2D       ;
CODE_0396FD:          JSR.W SubOffscreen0Bnk3             ;; 0396FD : 20 5D B8    ;
CODE_039700:          JSL.L MarioSprInteract              ;; 039700 : 22 DC A7 01 ;
CODE_039704:          JSL.L UpdateXPosNoGrvty             ;; 039704 : 22 22 80 01 ;
CODE_039708:          TXA                                 ;; 039708 : 8A          ;
CODE_039709:          ASL                                 ;; 039709 : 0A          ;
CODE_03970A:          ASL                                 ;; 03970A : 0A          ;
CODE_03970B:          ASL                                 ;; 03970B : 0A          ;
CODE_03970C:          ASL                                 ;; 03970C : 0A          ;
CODE_03970D:          ADC RAM_FrameCounter                ;; 03970D : 65 13       ;
CODE_03970F:          AND.B #$7F                          ;; 03970F : 29 7F       ;
CODE_039711:          BNE CODE_039720                     ;; 039711 : D0 0D       ;
CODE_039713:          JSL.L GetRand                       ;; 039713 : 22 F9 AC 01 ;
CODE_039717:          AND.B #$01                          ;; 039717 : 29 01       ;
CODE_039719:          BNE CODE_039720                     ;; 039719 : D0 05       ;
CODE_03971B:          LDA.B #$0C                          ;; 03971B : A9 0C       ;
CODE_03971D:          STA.W $1558,X                       ;; 03971D : 9D 58 15    ;
CODE_039720:          LDA RAM_SpriteState,X               ;; 039720 : B5 C2       ;
CODE_039722:          JSL.L ExecutePtr                    ;; 039722 : 22 DF 86 00 ;
                                                          ;;                      ;
FishbonePtrs:         .dw CODE_03972F                     ;; ?QPWZ? : 2F 97       ;
                      .dw CODE_03975E                     ;; ?QPWZ? : 5E 97       ;
                                                          ;;                      ;
Return03972A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishboneMaxSpeed:     .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneAcceler:      .db $01,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03972F:          INC.W $1570,X                       ;; 03972F : FE 70 15    ;
CODE_039732:          LDA.W $1570,X                       ;; 039732 : BD 70 15    ;
CODE_039735:          NOP                                 ;; 039735 : EA          ;
CODE_039736:          LSR                                 ;; 039736 : 4A          ;
CODE_039737:          AND.B #$01                          ;; 039737 : 29 01       ;
CODE_039739:          STA.W $1602,X                       ;; 039739 : 9D 02 16    ;
CODE_03973C:          LDA.W $1540,X                       ;; 03973C : BD 40 15    ;
CODE_03973F:          BEQ CODE_039756                     ;; 03973F : F0 15       ;
CODE_039741:          AND.B #$01                          ;; 039741 : 29 01       ;
CODE_039743:          BNE Return039755                    ;; 039743 : D0 10       ;
CODE_039745:          LDY.W RAM_SpriteDir,X               ;; 039745 : BC 7C 15    ;
CODE_039748:          LDA RAM_SpriteSpeedX,X              ;; 039748 : B5 B6       ;
CODE_03974A:          CMP.W FishboneMaxSpeed,Y            ;; 03974A : D9 2B 97    ;
CODE_03974D:          BEQ Return039755                    ;; 03974D : F0 06       ;
CODE_03974F:          CLC                                 ;; 03974F : 18          ;
CODE_039750:          ADC.W FishboneAcceler,Y             ;; 039750 : 79 2D 97    ;
CODE_039753:          STA RAM_SpriteSpeedX,X              ;; 039753 : 95 B6       ;
Return039755:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039756:          INC RAM_SpriteState,X               ;; 039756 : F6 C2       ;
CODE_039758:          LDA.B #$30                          ;; 039758 : A9 30       ;
CODE_03975A:          STA.W $1540,X                       ;; 03975A : 9D 40 15    ;
Return03975D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03975E:          STZ.W $1602,X                       ;; 03975E : 9E 02 16    ;
CODE_039761:          LDA.W $1540,X                       ;; 039761 : BD 40 15    ;
CODE_039764:          BEQ CODE_039776                     ;; 039764 : F0 10       ;
CODE_039766:          AND.B #$03                          ;; 039766 : 29 03       ;
CODE_039768:          BNE Return039775                    ;; 039768 : D0 0B       ;
CODE_03976A:          LDA RAM_SpriteSpeedX,X              ;; 03976A : B5 B6       ;
CODE_03976C:          BEQ Return039775                    ;; 03976C : F0 07       ;
CODE_03976E:          BPL CODE_039773                     ;; 03976E : 10 03       ;
CODE_039770:          INC RAM_SpriteSpeedX,X              ;; 039770 : F6 B6       ;
Return039772:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039773:          DEC RAM_SpriteSpeedX,X              ;; 039773 : D6 B6       ;
Return039775:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039776:          STZ RAM_SpriteState,X               ;; 039776 : 74 C2       ;
CODE_039778:          LDA.B #$30                          ;; 039778 : A9 30       ;
CODE_03977A:          STA.W $1540,X                       ;; 03977A : 9D 40 15    ;
Return03977D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishboneDispX:        .db $F8,$F8,$10,$10                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneDispY:        .db $00,$08                         ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneGfxProp:      .db $4D,$CD,$0D,$8D                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneTailTiles:    .db $A3,$A3,$B3,$B3                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneGfx:          JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ;
CODE_039790:          LDY.W RAM_SprOAMIndex,X             ;; 039790 : BC EA 15    ; Y = Index into sprite OAM 
CODE_039793:          LDA.W $1558,X                       ;; 039793 : BD 58 15    ;
CODE_039796:          CMP.B #$01                          ;; 039796 : C9 01       ;
CODE_039798:          LDA.B #$A6                          ;; 039798 : A9 A6       ;
CODE_03979A:          BCC CODE_03979E                     ;; 03979A : 90 02       ;
CODE_03979C:          LDA.B #$A8                          ;; 03979C : A9 A8       ;
CODE_03979E:          STA.W OAM_Tile,Y                    ;; 03979E : 99 02 03    ;
CODE_0397A1:          JSR.W GetDrawInfoBnk3               ;; 0397A1 : 20 60 B7    ;
CODE_0397A4:          LDA.W RAM_SpriteDir,X               ;; 0397A4 : BD 7C 15    ;
CODE_0397A7:          ASL                                 ;; 0397A7 : 0A          ;
CODE_0397A8:          STA $02                             ;; 0397A8 : 85 02       ;
CODE_0397AA:          LDA.W $1602,X                       ;; 0397AA : BD 02 16    ;
CODE_0397AD:          ASL                                 ;; 0397AD : 0A          ;
CODE_0397AE:          STA $03                             ;; 0397AE : 85 03       ;
CODE_0397B0:          LDA.W RAM_SprOAMIndex,X             ;; 0397B0 : BD EA 15    ;
CODE_0397B3:          CLC                                 ;; 0397B3 : 18          ;
CODE_0397B4:          ADC.B #$04                          ;; 0397B4 : 69 04       ;
CODE_0397B6:          STA.W RAM_SprOAMIndex,X             ;; 0397B6 : 9D EA 15    ;
CODE_0397B9:          TAY                                 ;; 0397B9 : A8          ;
CODE_0397BA:          PHX                                 ;; 0397BA : DA          ;
CODE_0397BB:          LDX.B #$01                          ;; 0397BB : A2 01       ;
CODE_0397BD:          LDA $01                             ;; 0397BD : A5 01       ;
CODE_0397BF:          CLC                                 ;; 0397BF : 18          ;
CODE_0397C0:          ADC.W FishboneDispY,X               ;; 0397C0 : 7D 82 97    ;
CODE_0397C3:          STA.W OAM_DispY,Y                   ;; 0397C3 : 99 01 03    ;
CODE_0397C6:          PHX                                 ;; 0397C6 : DA          ;
CODE_0397C7:          TXA                                 ;; 0397C7 : 8A          ;
CODE_0397C8:          ORA $02                             ;; 0397C8 : 05 02       ;
CODE_0397CA:          TAX                                 ;; 0397CA : AA          ;
CODE_0397CB:          LDA $00                             ;; 0397CB : A5 00       ;
CODE_0397CD:          CLC                                 ;; 0397CD : 18          ;
CODE_0397CE:          ADC.W FishboneDispX,X               ;; 0397CE : 7D 7E 97    ;
CODE_0397D1:          STA.W OAM_DispX,Y                   ;; 0397D1 : 99 00 03    ;
CODE_0397D4:          LDA.W FishboneGfxProp,X             ;; 0397D4 : BD 84 97    ;
CODE_0397D7:          ORA $64                             ;; 0397D7 : 05 64       ;
CODE_0397D9:          STA.W OAM_Prop,Y                    ;; 0397D9 : 99 03 03    ;
CODE_0397DC:          PLA                                 ;; 0397DC : 68          ;
CODE_0397DD:          PHA                                 ;; 0397DD : 48          ;
CODE_0397DE:          ORA $03                             ;; 0397DE : 05 03       ;
CODE_0397E0:          TAX                                 ;; 0397E0 : AA          ;
CODE_0397E1:          LDA.W FishboneTailTiles,X           ;; 0397E1 : BD 88 97    ;
CODE_0397E4:          STA.W OAM_Tile,Y                    ;; 0397E4 : 99 02 03    ;
CODE_0397E7:          PLX                                 ;; 0397E7 : FA          ;
CODE_0397E8:          INY                                 ;; 0397E8 : C8          ;
CODE_0397E9:          INY                                 ;; 0397E9 : C8          ;
CODE_0397EA:          INY                                 ;; 0397EA : C8          ;
CODE_0397EB:          INY                                 ;; 0397EB : C8          ;
CODE_0397EC:          DEX                                 ;; 0397EC : CA          ;
CODE_0397ED:          BPL CODE_0397BD                     ;; 0397ED : 10 CE       ;
CODE_0397EF:          PLX                                 ;; 0397EF : FA          ;
CODE_0397F0:          LDY.B #$00                          ;; 0397F0 : A0 00       ;
CODE_0397F2:          LDA.B #$02                          ;; 0397F2 : A9 02       ;
CODE_0397F4:          JSL.L FinishOAMWrite                ;; 0397F4 : 22 B3 B7 01 ;
Return0397F8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0397F9:          STA $01                             ;; 0397F9 : 85 01       ;
CODE_0397FB:          PHX                                 ;; 0397FB : DA          ;
CODE_0397FC:          PHY                                 ;; 0397FC : 5A          ;
CODE_0397FD:          JSR.W SubVertPosBnk3                ;; 0397FD : 20 29 B8    ;
CODE_039800:          STY $02                             ;; 039800 : 84 02       ;
CODE_039802:          LDA $0E                             ;; 039802 : A5 0E       ;
CODE_039804:          BPL CODE_03980B                     ;; 039804 : 10 05       ;
CODE_039806:          EOR.B #$FF                          ;; 039806 : 49 FF       ;
CODE_039808:          CLC                                 ;; 039808 : 18          ;
CODE_039809:          ADC.B #$01                          ;; 039809 : 69 01       ;
CODE_03980B:          STA $0C                             ;; 03980B : 85 0C       ;
CODE_03980D:          JSR.W SubHorzPosBnk3                ;; 03980D : 20 17 B8    ;
CODE_039810:          STY $03                             ;; 039810 : 84 03       ;
CODE_039812:          LDA $0F                             ;; 039812 : A5 0F       ;
CODE_039814:          BPL CODE_03981B                     ;; 039814 : 10 05       ;
CODE_039816:          EOR.B #$FF                          ;; 039816 : 49 FF       ;
CODE_039818:          CLC                                 ;; 039818 : 18          ;
CODE_039819:          ADC.B #$01                          ;; 039819 : 69 01       ;
CODE_03981B:          STA $0D                             ;; 03981B : 85 0D       ;
CODE_03981D:          LDY.B #$00                          ;; 03981D : A0 00       ;
CODE_03981F:          LDA $0D                             ;; 03981F : A5 0D       ;
CODE_039821:          CMP $0C                             ;; 039821 : C5 0C       ;
CODE_039823:          BCS CODE_03982E                     ;; 039823 : B0 09       ;
CODE_039825:          INY                                 ;; 039825 : C8          ;
CODE_039826:          PHA                                 ;; 039826 : 48          ;
CODE_039827:          LDA $0C                             ;; 039827 : A5 0C       ;
CODE_039829:          STA $0D                             ;; 039829 : 85 0D       ;
CODE_03982B:          PLA                                 ;; 03982B : 68          ;
CODE_03982C:          STA $0C                             ;; 03982C : 85 0C       ;
CODE_03982E:          LDA.B #$00                          ;; 03982E : A9 00       ;
CODE_039830:          STA $0B                             ;; 039830 : 85 0B       ;
CODE_039832:          STA $00                             ;; 039832 : 85 00       ;
CODE_039834:          LDX $01                             ;; 039834 : A6 01       ;
CODE_039836:          LDA $0B                             ;; 039836 : A5 0B       ;
CODE_039838:          CLC                                 ;; 039838 : 18          ;
CODE_039839:          ADC $0C                             ;; 039839 : 65 0C       ;
CODE_03983B:          CMP $0D                             ;; 03983B : C5 0D       ;
CODE_03983D:          BCC CODE_039843                     ;; 03983D : 90 04       ;
CODE_03983F:          SBC $0D                             ;; 03983F : E5 0D       ;
CODE_039841:          INC $00                             ;; 039841 : E6 00       ;
CODE_039843:          STA $0B                             ;; 039843 : 85 0B       ;
CODE_039845:          DEX                                 ;; 039845 : CA          ;
CODE_039846:          BNE CODE_039836                     ;; 039846 : D0 EE       ;
CODE_039848:          TYA                                 ;; 039848 : 98          ;
CODE_039849:          BEQ CODE_039855                     ;; 039849 : F0 0A       ;
CODE_03984B:          LDA $00                             ;; 03984B : A5 00       ;
CODE_03984D:          PHA                                 ;; 03984D : 48          ;
CODE_03984E:          LDA $01                             ;; 03984E : A5 01       ;
CODE_039850:          STA $00                             ;; 039850 : 85 00       ;
CODE_039852:          PLA                                 ;; 039852 : 68          ;
CODE_039853:          STA $01                             ;; 039853 : 85 01       ;
CODE_039855:          LDA $00                             ;; 039855 : A5 00       ;
CODE_039857:          LDY $02                             ;; 039857 : A4 02       ;
CODE_039859:          BEQ CODE_039862                     ;; 039859 : F0 07       ;
CODE_03985B:          EOR.B #$FF                          ;; 03985B : 49 FF       ;
CODE_03985D:          CLC                                 ;; 03985D : 18          ;
CODE_03985E:          ADC.B #$01                          ;; 03985E : 69 01       ;
CODE_039860:          STA $00                             ;; 039860 : 85 00       ;
CODE_039862:          LDA $01                             ;; 039862 : A5 01       ;
CODE_039864:          LDY $03                             ;; 039864 : A4 03       ;
CODE_039866:          BEQ CODE_03986F                     ;; 039866 : F0 07       ;
CODE_039868:          EOR.B #$FF                          ;; 039868 : 49 FF       ;
CODE_03986A:          CLC                                 ;; 03986A : 18          ;
CODE_03986B:          ADC.B #$01                          ;; 03986B : 69 01       ;
CODE_03986D:          STA $01                             ;; 03986D : 85 01       ;
CODE_03986F:          PLY                                 ;; 03986F : 7A          ;
CODE_039870:          PLX                                 ;; 039870 : FA          ;
Return039871:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorInit:           CPX.B #$07                          ;; ?QPWZ? : E0 07       ;
CODE_039874:          BNE CODE_03987E                     ;; 039874 : D0 08       ;
CODE_039876:          LDA.B #$04                          ;; 039876 : A9 04       ;
CODE_039878:          STA RAM_SpriteState,X               ;; 039878 : 95 C2       ;
CODE_03987A:          JSL.L CODE_03DD7D                   ;; 03987A : 22 7D DD 03 ;
CODE_03987E:          JSL.L GetRand                       ;; 03987E : 22 F9 AC 01 ;
CODE_039882:          STA.W $1570,X                       ;; 039882 : 9D 70 15    ;
Return039885:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorStartPosLo:     .db $00,$80,$00,$80                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorStartPosHi:     .db $00,$00,$01,$01                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReboundSpeedX:        .db $20,$E0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
Reznor:               INC.W $140F                         ;; ?QPWZ? : EE 0F 14    ;
CODE_039893:          LDA RAM_SpritesLocked               ;; 039893 : A5 9D       ;
CODE_039895:          BEQ ReznorNotLocked                 ;; 039895 : F0 03       ;
CODE_039897:          JMP.W DrawReznor                    ;; 039897 : 4C 7B 9A    ;
                                                          ;;                      ;
ReznorNotLocked:      CPX.B #$07                          ;; ?QPWZ? : E0 07       ;
CODE_03989C:          BNE CODE_039910                     ;; 03989C : D0 72       ;
CODE_03989E:          PHX                                 ;; 03989E : DA          ;
CODE_03989F:          JSL.L CODE_03D70C                   ;; 03989F : 22 0C D7 03 ; Break bridge when necessary 
ReznorSignCode:       LDA.B #$80                          ;; ?QPWZ? : A9 80       ; \ Set radius for Reznor sign rotation 
CODE_0398A5:          STA $2A                             ;; 0398A5 : 85 2A       ;  | 
CODE_0398A7:          STZ $2B                             ;; 0398A7 : 64 2B       ; / 
CODE_0398A9:          LDX.B #$00                          ;; 0398A9 : A2 00       ;
CODE_0398AB:          LDA.B #$C0                          ;; 0398AB : A9 C0       ; \ X position of Reznor sign 
CODE_0398AD:          STA RAM_SpriteXLo                   ;; 0398AD : 85 E4       ;  | 
CODE_0398AF:          STZ.W RAM_SpriteXHi                 ;; 0398AF : 9C E0 14    ; / 
CODE_0398B2:          LDA.B #$B2                          ;; 0398B2 : A9 B2       ; \ Y position of Reznor sign 
CODE_0398B4:          STA RAM_SpriteYLo                   ;; 0398B4 : 85 D8       ;  | 
CODE_0398B6:          STZ.W RAM_SpriteYHi                 ;; 0398B6 : 9C D4 14    ; / 
CODE_0398B9:          LDA.B #$2C                          ;; 0398B9 : A9 2C       ;
CODE_0398BB:          STA.W $1BA2                         ;; 0398BB : 8D A2 1B    ;
CODE_0398BE:          JSL.L CODE_03DEDF                   ;; 0398BE : 22 DF DE 03 ; Applies position changes to Reznor sign 
CODE_0398C2:          PLX                                 ;; 0398C2 : FA          ; Pull, X = sprite index 
CODE_0398C3:          REP #$20                            ;; 0398C3 : C2 20       ; Accum (16 bit) 
CODE_0398C5:          LDA $36                             ;; 0398C5 : A5 36       ; \ Rotate 1 frame around the circle (clockwise) 
CODE_0398C7:          CLC                                 ;; 0398C7 : 18          ;  | $37,36 = 0 to 1FF, denotes circle position 
CODE_0398C8:          ADC.W #$0001                        ;; 0398C8 : 69 01 00    ;  | 
CODE_0398CB:          AND.W #$01FF                        ;; 0398CB : 29 FF 01    ;  | 
CODE_0398CE:          STA $36                             ;; 0398CE : 85 36       ; / 
CODE_0398D0:          SEP #$20                            ;; 0398D0 : E2 20       ; Accum (8 bit) 
CODE_0398D2:          CPX.B #$07                          ;; 0398D2 : E0 07       ;
CODE_0398D4:          BNE CODE_039910                     ;; 0398D4 : D0 3A       ;
CODE_0398D6:          LDA.W $163E,X                       ;; 0398D6 : BD 3E 16    ; \ Branch if timer to trigger level isn't set 
CODE_0398D9:          BEQ ReznorNoLevelEnd                ;; 0398D9 : F0 11       ; / 
CODE_0398DB:          DEC A                               ;; 0398DB : 3A          ;
CODE_0398DC:          BNE CODE_039910                     ;; 0398DC : D0 32       ;
CODE_0398DE:          DEC.W $13C6                         ;; 0398DE : CE C6 13    ; Prevent mario from walking at level end 
CODE_0398E1:          LDA.B #$FF                          ;; 0398E1 : A9 FF       ; \ Set time before return to overworld 
CODE_0398E3:          STA.W $1493                         ;; 0398E3 : 8D 93 14    ; / 
CODE_0398E6:          LDA.B #$0B                          ;; 0398E6 : A9 0B       ; \ 
CODE_0398E8:          STA.W $1DFB                         ;; 0398E8 : 8D FB 1D    ; / Play sound effect 
Return0398EB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorNoLevelEnd:     LDA.W RAM_Reznor4Dead               ;; ?QPWZ? : AD 23 15    ; \ 
CODE_0398EF:          CLC                                 ;; 0398EF : 18          ;  | 
CODE_0398F0:          ADC.W RAM_Reznor3Dead               ;; 0398F0 : 6D 22 15    ;  | 
CODE_0398F3:          ADC.W RAM_Reznor2Dead               ;; 0398F3 : 6D 21 15    ;  | 
CODE_0398F6:          ADC.W RAM_Reznor1Dead               ;; 0398F6 : 6D 20 15    ;  | 
CODE_0398F9:          CMP.B #$04                          ;; 0398F9 : C9 04       ;  | 
CODE_0398FB:          BNE CODE_039910                     ;; 0398FB : D0 13       ;  | 
CODE_0398FD:          LDA.B #$90                          ;; 0398FD : A9 90       ;  | Set time to trigger level if all Reznors are dead 
CODE_0398FF:          STA.W $163E,X                       ;; 0398FF : 9D 3E 16    ; / 
CODE_039902:          JSL.L KillMostSprites               ;; 039902 : 22 C8 A6 03 ;
CODE_039906:          LDY.B #$07                          ;; 039906 : A0 07       ; \ Zero out extended sprite table 
CODE_039908:          LDA.B #$00                          ;; 039908 : A9 00       ;  | 
CODE_03990A:          STA.W RAM_ExSpriteNum,Y             ;; 03990A : 99 0B 17    ;  | 
CODE_03990D:          DEY                                 ;; 03990D : 88          ;  | 
CODE_03990E:          BPL CODE_03990A                     ;; 03990E : 10 FA       ; / 
CODE_039910:          LDA.W $14C8,X                       ;; 039910 : BD C8 14    ;
CODE_039913:          CMP.B #$08                          ;; 039913 : C9 08       ;
CODE_039915:          BEQ CODE_03991A                     ;; 039915 : F0 03       ;
CODE_039917:          JMP.W DrawReznor                    ;; 039917 : 4C 7B 9A    ;
                                                          ;;                      ;
CODE_03991A:          TXA                                 ;; 03991A : 8A          ; \ Load Y with Reznor number (0-3)				  
CODE_03991B:          AND.B #$03                          ;; 03991B : 29 03       ;  |							  
CODE_03991D:          TAY                                 ;; 03991D : A8          ; /								  
CODE_03991E:          LDA $36                             ;; 03991E : A5 36       ; \								  
CODE_039920:          CLC                                 ;; 039920 : 18          ;  |							  
CODE_039921:          ADC.W ReznorStartPosLo,Y            ;; 039921 : 79 86 98    ;  |							  
CODE_039924:          STA $00                             ;; 039924 : 85 00       ;  | $01,00 = 0-1FF, position Reznors on the circle		  
CODE_039926:          LDA $37                             ;; 039926 : A5 37       ;  |							  
CODE_039928:          ADC.W ReznorStartPosHi,Y            ;; 039928 : 79 8A 98    ;  |							  
CODE_03992B:          AND.B #$01                          ;; 03992B : 29 01       ;  |							  
CODE_03992D:          STA $01                             ;; 03992D : 85 01       ; /								  
CODE_03992F:          REP #$30                            ;; 03992F : C2 30       ; \   Index (16 bit) Accum (16 bit)  ; Index (16 bit) Accum (16 bit) 
CODE_039931:          LDA $00                             ;; 039931 : A5 00       ;  | Make Reznors turn clockwise rather than counter clockwise 
CODE_039933:          EOR.W #$01FF                        ;; 039933 : 49 FF 01    ;  | ($01,00 = -1 * $01,00)					 							  
CODE_039936:          INC A                               ;; 039936 : 1A          ;  |							  
CODE_039937:          STA $00                             ;; 039937 : 85 00       ; /                                                           
CODE_039939:          CLC                                 ;; 039939 : 18          ;
CODE_03993A:          ADC.W #$0080                        ;; 03993A : 69 80 00    ;
CODE_03993D:          AND.W #$01FF                        ;; 03993D : 29 FF 01    ;
CODE_039940:          STA $02                             ;; 039940 : 85 02       ;
CODE_039942:          LDA $00                             ;; 039942 : A5 00       ;
CODE_039944:          AND.W #$00FF                        ;; 039944 : 29 FF 00    ;
CODE_039947:          ASL                                 ;; 039947 : 0A          ;
CODE_039948:          TAX                                 ;; 039948 : AA          ;
CODE_039949:          LDA.L CircleCoords,X                ;; 039949 : BF DB F7 07 ;
CODE_03994D:          STA $04                             ;; 03994D : 85 04       ;
CODE_03994F:          LDA $02                             ;; 03994F : A5 02       ;
CODE_039951:          AND.W #$00FF                        ;; 039951 : 29 FF 00    ;
CODE_039954:          ASL                                 ;; 039954 : 0A          ;
CODE_039955:          TAX                                 ;; 039955 : AA          ;
CODE_039956:          LDA.L CircleCoords,X                ;; 039956 : BF DB F7 07 ;
CODE_03995A:          STA $06                             ;; 03995A : 85 06       ;
CODE_03995C:          SEP #$30                            ;; 03995C : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_03995E:          LDA $04                             ;; 03995E : A5 04       ;
CODE_039960:          STA.W $4202                         ;; 039960 : 8D 02 42    ; Multiplicand A
CODE_039963:          LDA.B #$38                          ;; 039963 : A9 38       ;
CODE_039965:          LDY $05                             ;; 039965 : A4 05       ;
CODE_039967:          BNE CODE_039978                     ;; 039967 : D0 0F       ;
CODE_039969:          STA.W $4203                         ;; 039969 : 8D 03 42    ; Multplier B
CODE_03996C:          NOP                                 ;; 03996C : EA          ;
CODE_03996D:          NOP                                 ;; 03996D : EA          ;
CODE_03996E:          NOP                                 ;; 03996E : EA          ;
CODE_03996F:          NOP                                 ;; 03996F : EA          ;
CODE_039970:          ASL.W $4216                         ;; 039970 : 0E 16 42    ; Product/Remainder Result (Low Byte)
CODE_039973:          LDA.W $4217                         ;; 039973 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_039976:          ADC.B #$00                          ;; 039976 : 69 00       ;
CODE_039978:          LSR $01                             ;; 039978 : 46 01       ;
CODE_03997A:          BCC CODE_03997F                     ;; 03997A : 90 03       ;
CODE_03997C:          EOR.B #$FF                          ;; 03997C : 49 FF       ;
CODE_03997E:          INC A                               ;; 03997E : 1A          ;
CODE_03997F:          STA $04                             ;; 03997F : 85 04       ;
CODE_039981:          LDA $06                             ;; 039981 : A5 06       ;
CODE_039983:          STA.W $4202                         ;; 039983 : 8D 02 42    ; Multiplicand A
CODE_039986:          LDA.B #$38                          ;; 039986 : A9 38       ;
CODE_039988:          LDY $07                             ;; 039988 : A4 07       ;
CODE_03998A:          BNE CODE_03999B                     ;; 03998A : D0 0F       ;
CODE_03998C:          STA.W $4203                         ;; 03998C : 8D 03 42    ; Multplier B
CODE_03998F:          NOP                                 ;; 03998F : EA          ;
CODE_039990:          NOP                                 ;; 039990 : EA          ;
CODE_039991:          NOP                                 ;; 039991 : EA          ;
CODE_039992:          NOP                                 ;; 039992 : EA          ;
CODE_039993:          ASL.W $4216                         ;; 039993 : 0E 16 42    ; Product/Remainder Result (Low Byte)
CODE_039996:          LDA.W $4217                         ;; 039996 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_039999:          ADC.B #$00                          ;; 039999 : 69 00       ;
CODE_03999B:          LSR $03                             ;; 03999B : 46 03       ;
CODE_03999D:          BCC CODE_0399A2                     ;; 03999D : 90 03       ;
CODE_03999F:          EOR.B #$FF                          ;; 03999F : 49 FF       ;
CODE_0399A1:          INC A                               ;; 0399A1 : 1A          ;
CODE_0399A2:          STA $06                             ;; 0399A2 : 85 06       ;
CODE_0399A4:          LDX.W $15E9                         ;; 0399A4 : AE E9 15    ; X = sprite index 
CODE_0399A7:          LDA RAM_SpriteXLo,X                 ;; 0399A7 : B5 E4       ;
CODE_0399A9:          PHA                                 ;; 0399A9 : 48          ;
CODE_0399AA:          STZ $00                             ;; 0399AA : 64 00       ;
CODE_0399AC:          LDA $04                             ;; 0399AC : A5 04       ;
CODE_0399AE:          BPL CODE_0399B2                     ;; 0399AE : 10 02       ;
CODE_0399B0:          DEC $00                             ;; 0399B0 : C6 00       ;
CODE_0399B2:          CLC                                 ;; 0399B2 : 18          ;
CODE_0399B3:          ADC $2A                             ;; 0399B3 : 65 2A       ;
CODE_0399B5:          PHP                                 ;; 0399B5 : 08          ;
CODE_0399B6:          CLC                                 ;; 0399B6 : 18          ;
CODE_0399B7:          ADC.B #$40                          ;; 0399B7 : 69 40       ;
CODE_0399B9:          STA RAM_SpriteXLo,X                 ;; 0399B9 : 95 E4       ;
CODE_0399BB:          LDA $2B                             ;; 0399BB : A5 2B       ;
CODE_0399BD:          ADC.B #$00                          ;; 0399BD : 69 00       ;
CODE_0399BF:          PLP                                 ;; 0399BF : 28          ;
CODE_0399C0:          ADC $00                             ;; 0399C0 : 65 00       ;
CODE_0399C2:          STA.W RAM_SpriteXHi,X               ;; 0399C2 : 9D E0 14    ;
CODE_0399C5:          PLA                                 ;; 0399C5 : 68          ;
CODE_0399C6:          SEC                                 ;; 0399C6 : 38          ;
CODE_0399C7:          SBC RAM_SpriteXLo,X                 ;; 0399C7 : F5 E4       ;
CODE_0399C9:          EOR.B #$FF                          ;; 0399C9 : 49 FF       ;
CODE_0399CB:          INC A                               ;; 0399CB : 1A          ;
CODE_0399CC:          STA.W $1528,X                       ;; 0399CC : 9D 28 15    ;
CODE_0399CF:          STZ $01                             ;; 0399CF : 64 01       ;
CODE_0399D1:          LDA $06                             ;; 0399D1 : A5 06       ;
CODE_0399D3:          BPL CODE_0399D7                     ;; 0399D3 : 10 02       ;
CODE_0399D5:          DEC $01                             ;; 0399D5 : C6 01       ;
CODE_0399D7:          CLC                                 ;; 0399D7 : 18          ;
CODE_0399D8:          ADC $2C                             ;; 0399D8 : 65 2C       ;
CODE_0399DA:          PHP                                 ;; 0399DA : 08          ;
CODE_0399DB:          ADC.B #$20                          ;; 0399DB : 69 20       ;
CODE_0399DD:          STA RAM_SpriteYLo,X                 ;; 0399DD : 95 D8       ;
CODE_0399DF:          LDA $2D                             ;; 0399DF : A5 2D       ;
CODE_0399E1:          ADC.B #$00                          ;; 0399E1 : 69 00       ;
CODE_0399E3:          PLP                                 ;; 0399E3 : 28          ;
CODE_0399E4:          ADC $01                             ;; 0399E4 : 65 01       ;
CODE_0399E6:          STA.W RAM_SpriteYHi,X               ;; 0399E6 : 9D D4 14    ;
CODE_0399E9:          LDA.W $151C,X                       ;; 0399E9 : BD 1C 15    ; \ If a Reznor is dead, make it's platform standable 
CODE_0399EC:          BEQ ReznorAlive                     ;; 0399EC : F0 07       ;  | 
CODE_0399EE:          JSL.L InvisBlkMainRt                ;; 0399EE : 22 4F B4 01 ;  | 
CODE_0399F2:          JMP.W DrawReznor                    ;; 0399F2 : 4C 7B 9A    ; / 
                                                          ;;                      ;
ReznorAlive:          LDA RAM_FrameCounter                ;; ?QPWZ? : A5 13       ; \ Don't try to spit fire if turning 
CODE_0399F7:          AND.B #$00                          ;; 0399F7 : 29 00       ;  | 
CODE_0399F9:          ORA.W $15AC,X                       ;; 0399F9 : 1D AC 15    ;  | 
CODE_0399FC:          BNE NoSetRznrFireTime               ;; 0399FC : D0 12       ; / 
CODE_0399FE:          INC.W $1570,X                       ;; 0399FE : FE 70 15    ;
CODE_039A01:          LDA.W $1570,X                       ;; 039A01 : BD 70 15    ;
CODE_039A04:          CMP.B #$00                          ;; 039A04 : C9 00       ;
CODE_039A06:          BNE NoSetRznrFireTime               ;; 039A06 : D0 08       ;
CODE_039A08:          STZ.W $1570,X                       ;; 039A08 : 9E 70 15    ;
CODE_039A0B:          LDA.B #$40                          ;; 039A0B : A9 40       ; \ Set time to show firing graphic = 0A 
CODE_039A0D:          STA.W $1558,X                       ;; 039A0D : 9D 58 15    ; / 
NoSetRznrFireTime:    TXA                                 ;; ?QPWZ? : 8A          ;
CODE_039A11:          ASL                                 ;; 039A11 : 0A          ;
CODE_039A12:          ASL                                 ;; 039A12 : 0A          ;
CODE_039A13:          ASL                                 ;; 039A13 : 0A          ;
CODE_039A14:          ASL                                 ;; 039A14 : 0A          ;
CODE_039A15:          ADC RAM_FrameCounterB               ;; 039A15 : 65 14       ;
CODE_039A17:          AND.B #$3F                          ;; 039A17 : 29 3F       ;
CODE_039A19:          ORA.W $1558,X                       ;; 039A19 : 1D 58 15    ; Firing 
CODE_039A1C:          ORA.W $15AC,X                       ;; 039A1C : 1D AC 15    ; Turning 
CODE_039A1F:          BNE NoSetRenrTurnTime               ;; 039A1F : D0 16       ;
CODE_039A21:          LDA.W RAM_SpriteDir,X               ;; 039A21 : BD 7C 15    ; \ if direction has changed since last frame...		   
CODE_039A24:          PHA                                 ;; 039A24 : 48          ;  |							   
CODE_039A25:          JSR.W SubHorzPosBnk3                ;; 039A25 : 20 17 B8    ;  |							   
CODE_039A28:          TYA                                 ;; 039A28 : 98          ;  |							   
CODE_039A29:          STA.W RAM_SpriteDir,X               ;; 039A29 : 9D 7C 15    ;  |							   
CODE_039A2C:          PLA                                 ;; 039A2C : 68          ;  |							   
CODE_039A2D:          CMP.W RAM_SpriteDir,X               ;; 039A2D : DD 7C 15    ;  |							   
CODE_039A30:          BEQ NoSetRenrTurnTime               ;; 039A30 : F0 05       ;  |							   
CODE_039A32:          LDA.B #$0A                          ;; 039A32 : A9 0A       ;  | ...set time to show turning graphic = 0A		   
CODE_039A34:          STA.W $15AC,X                       ;; 039A34 : 9D AC 15    ; /								   
NoSetRenrTurnTime:    LDA.W RAM_DisableInter,X            ;; ?QPWZ? : BD 4C 15    ; \ If disable interaction timer > 0, just draw Reznor	   
CODE_039A3A:          BNE DrawReznor                      ;; 039A3A : D0 3F       ; /								   
CODE_039A3C:          JSL.L MarioSprInteract              ;; 039A3C : 22 DC A7 01 ; \ Interact with mario					   
CODE_039A40:          BCC DrawReznor                      ;; 039A40 : 90 39       ; / If no contact, just draw Reznor				   
CODE_039A42:          LDA.B #$08                          ;; 039A42 : A9 08       ; \ Disable interaction timer = 08				   
CODE_039A44:          STA.W RAM_DisableInter,X            ;; 039A44 : 9D 4C 15    ; / (eg. after hitting Reznor, or getting bounced by platform) 
CODE_039A47:          LDA RAM_MarioYPos                   ;; 039A47 : A5 96       ; \ Compare y positions to see if mario hit Reznor		   
CODE_039A49:          SEC                                 ;; 039A49 : 38          ;  |							   
CODE_039A4A:          SBC RAM_SpriteYLo,X                 ;; 039A4A : F5 D8       ;  |							   
CODE_039A4C:          CMP.B #$ED                          ;; 039A4C : C9 ED       ;  |							   
CODE_039A4E:          BMI HitReznor                       ;; 039A4E : 30 27       ; /								   
CODE_039A50:          CMP.B #$F2                          ;; 039A50 : C9 F2       ; \ See if mario hit side of the platform			   
CODE_039A52:          BMI HitPlatSide                     ;; 039A52 : 30 19       ;  |							   
CODE_039A54:          LDA RAM_MarioSpeedY                 ;; 039A54 : A5 7D       ;  |							   
CODE_039A56:          BPL HitPlatSide                     ;; 039A56 : 10 15       ; /								   
HitPlatBottom:        LDA.B #$29                          ;; ?QPWZ? : A9 29       ; ??Something about boosting mario on platform?? 
CODE_039A5A:          STA.W RAM_Tweaker1662,X             ;; 039A5A : 9D 62 16    ;  								   
CODE_039A5D:          LDA.B #$0F                          ;; 039A5D : A9 0F       ; \ Time to bounce platform = 0F				   
CODE_039A5F:          STA.W $1564,X                       ;; 039A5F : 9D 64 15    ; /								   
CODE_039A62:          LDA.B #$10                          ;; 039A62 : A9 10       ; \ Set mario's y speed to rebound down off platform	   
CODE_039A64:          STA RAM_MarioSpeedY                 ;; 039A64 : 85 7D       ; /								   
CODE_039A66:          LDA.B #$01                          ;; 039A66 : A9 01       ; \ 
CODE_039A68:          STA.W $1DF9                         ;; 039A68 : 8D F9 1D    ; / Play sound effect 
CODE_039A6B:          BRA DrawReznor                      ;; 039A6B : 80 0E       ;
                                                          ;;                      ;
HitPlatSide:          JSR.W SubHorzPosBnk3                ;; ?QPWZ? : 20 17 B8    ; \ Set mario to bounce back				   
CODE_039A70:          LDA.W ReboundSpeedX,Y               ;; 039A70 : B9 8E 98    ;  | (hit side of platform?)				   
CODE_039A73:          STA RAM_MarioSpeedX                 ;; 039A73 : 85 7B       ;  |							   
CODE_039A75:          BRA DrawReznor                      ;; 039A75 : 80 04       ; /                                                            
                                                          ;;                      ;
HitReznor:            JSL.L HurtMario                     ;; ?QPWZ? : 22 B7 F5 00 ; Hurt Mario 
DrawReznor:           STZ.W $1602,X                       ;; ?QPWZ? : 9E 02 16    ; Set normal image 
CODE_039A7E:          LDA.W RAM_SpriteDir,X               ;; 039A7E : BD 7C 15    ;
CODE_039A81:          PHA                                 ;; 039A81 : 48          ;
CODE_039A82:          LDY.W $15AC,X                       ;; 039A82 : BC AC 15    ;
CODE_039A85:          BEQ ReznorNoTurning                 ;; 039A85 : F0 0E       ;
CODE_039A87:          CPY.B #$05                          ;; 039A87 : C0 05       ;
CODE_039A89:          BCC ReznorTurning                   ;; 039A89 : 90 05       ;
CODE_039A8B:          EOR.B #$01                          ;; 039A8B : 49 01       ;
CODE_039A8D:          STA.W RAM_SpriteDir,X               ;; 039A8D : 9D 7C 15    ;
ReznorTurning:        LDA.B #$02                          ;; ?QPWZ? : A9 02       ; \ Set turning image 
CODE_039A92:          STA.W $1602,X                       ;; 039A92 : 9D 02 16    ; / 
ReznorNoTurning:      LDA.W $1558,X                       ;; ?QPWZ? : BD 58 15    ; \ Shoot fire if "time to show firing image" == 20	        
CODE_039A98:          BEQ ReznorNoFiring                  ;; 039A98 : F0 0C       ;  |						        
CODE_039A9A:          CMP.B #$20                          ;; 039A9A : C9 20       ;  | (shows image for 20 frames after the fireball is shot) 
CODE_039A9C:          BNE ReznorFiring                    ;; 039A9C : D0 03       ;  |						        
CODE_039A9E:          JSR.W ReznorFireRt                  ;; 039A9E : 20 F8 9A    ; /							        
ReznorFiring:         LDA.B #$01                          ;; ?QPWZ? : A9 01       ; \ Set firing image				        
CODE_039AA3:          STA.W $1602,X                       ;; 039AA3 : 9D 02 16    ; /							        
ReznorNoFiring:       JSR.W ReznorGfxRt                   ;; ?QPWZ? : 20 75 9B    ; Draw Reznor                                               
CODE_039AA9:          PLA                                 ;; 039AA9 : 68          ;
CODE_039AAA:          STA.W RAM_SpriteDir,X               ;; 039AAA : 9D 7C 15    ;
CODE_039AAD:          LDA RAM_SpritesLocked               ;; 039AAD : A5 9D       ; \ If sprites locked, or mario already killed the Reznor on the platform, return		   
CODE_039AAF:          ORA.W $151C,X                       ;; 039AAF : 1D 1C 15    ;  |											   
CODE_039AB2:          BNE Return039AF7                    ;; 039AB2 : D0 43       ; /												   
CODE_039AB4:          LDA.W $1564,X                       ;; 039AB4 : BD 64 15    ; \ If time to bounce platform != 0C, return						   
CODE_039AB7:          CMP.B #$0C                          ;; 039AB7 : C9 0C       ;  | (causes delay between start of boucing platform and killing Reznor)			   
CODE_039AB9:          BNE Return039AF7                    ;; 039AB9 : D0 3C       ; /												   
KillReznor:           LDA.B #$03                          ;; ?QPWZ? : A9 03       ; \ 
CODE_039ABD:          STA.W $1DF9                         ;; 039ABD : 8D F9 1D    ; / Play sound effect 
CODE_039AC0:          STZ.W $1558,X                       ;; 039AC0 : 9E 58 15    ; Prevent from throwing fire after death							   
CODE_039AC3:          INC.W $151C,X                       ;; 039AC3 : FE 1C 15    ; Record a hit on Reznor									   
CODE_039AC6:          JSL.L FindFreeSprSlot               ;; 039AC6 : 22 E4 A9 02 ; \ Load Y with a free sprite index for dead Reznor						   
CODE_039ACA:          BMI Return039AF7                    ;; 039ACA : 30 2B       ; / Return if no free index									   
CODE_039ACC:          LDA.B #$02                          ;; 039ACC : A9 02       ; \ Set status to being killed								   
CODE_039ACE:          STA.W $14C8,Y                       ;; 039ACE : 99 C8 14    ; /												   
CODE_039AD1:          LDA.B #$A9                          ;; 039AD1 : A9 A9       ; \ Sprite to use for dead Reznor								   
CODE_039AD3:          STA.W RAM_SpriteNum,Y               ;; 039AD3 : 99 9E 00    ; /												   
CODE_039AD6:          LDA RAM_SpriteXLo,X                 ;; 039AD6 : B5 E4       ; \ Transfer x position to dead Reznor							   
CODE_039AD8:          STA.W RAM_SpriteXLo,Y               ;; 039AD8 : 99 E4 00    ;  |											   
CODE_039ADB:          LDA.W RAM_SpriteXHi,X               ;; 039ADB : BD E0 14    ;  |											   
CODE_039ADE:          STA.W RAM_SpriteXHi,Y               ;; 039ADE : 99 E0 14    ; /												   
CODE_039AE1:          LDA RAM_SpriteYLo,X                 ;; 039AE1 : B5 D8       ; \ Transfer y position to dead Reznor							   
CODE_039AE3:          STA.W RAM_SpriteYLo,Y               ;; 039AE3 : 99 D8 00    ;  |											   
CODE_039AE6:          LDA.W RAM_SpriteYHi,X               ;; 039AE6 : BD D4 14    ;  |											   
CODE_039AE9:          STA.W RAM_SpriteYHi,Y               ;; 039AE9 : 99 D4 14    ; /												   
CODE_039AEC:          PHX                                 ;; 039AEC : DA          ; \ 											   
CODE_039AED:          TYX                                 ;; 039AED : BB          ;  | Before: X must have index of sprite being generated					   
CODE_039AEE:          JSL.L InitSpriteTables              ;; 039AEE : 22 D2 F7 07 ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables 
CODE_039AF2:          LDA.B #$C0                          ;; 039AF2 : A9 C0       ; \ Set y speed for Reznor's bounce off the platform					   
CODE_039AF4:          STA RAM_SpriteSpeedY,X              ;; 039AF4 : 95 AA       ; /												   
CODE_039AF6:          PLX                                 ;; 039AF6 : FA          ; pull, X = sprite index                                                                       
Return039AF7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorFireRt:         LDY.B #$07                          ;; ?QPWZ? : A0 07       ; \ find a free extended sprite slot, return if all full 
CODE_039AFA:          LDA.W RAM_ExSpriteNum,Y             ;; 039AFA : B9 0B 17    ;  | 
CODE_039AFD:          BEQ FoundRznrFireSlot               ;; 039AFD : F0 04       ;  | 
CODE_039AFF:          DEY                                 ;; 039AFF : 88          ;  | 
CODE_039B00:          BPL CODE_039AFA                     ;; 039B00 : 10 F8       ;  | 
Return039B02:         RTS                                 ;; ?QPWZ? : 60          ; / Return if no free slots 
                                                          ;;                      ;
FoundRznrFireSlot:    LDA.B #$10                          ;; ?QPWZ? : A9 10       ; \ 
CODE_039B05:          STA.W $1DF9                         ;; 039B05 : 8D F9 1D    ; / Play sound effect 
CODE_039B08:          LDA.B #$02                          ;; 039B08 : A9 02       ; \ Extended sprite = Reznor fireball 
CODE_039B0A:          STA.W RAM_ExSpriteNum,Y             ;; 039B0A : 99 0B 17    ; / 
CODE_039B0D:          LDA RAM_SpriteXLo,X                 ;; 039B0D : B5 E4       ;
CODE_039B0F:          PHA                                 ;; 039B0F : 48          ;
CODE_039B10:          SEC                                 ;; 039B10 : 38          ;
CODE_039B11:          SBC.B #$08                          ;; 039B11 : E9 08       ;
CODE_039B13:          STA.W RAM_ExSpriteXLo,Y             ;; 039B13 : 99 1F 17    ;
CODE_039B16:          STA RAM_SpriteXLo,X                 ;; 039B16 : 95 E4       ;
CODE_039B18:          LDA.W RAM_SpriteXHi,X               ;; 039B18 : BD E0 14    ;
CODE_039B1B:          SBC.B #$00                          ;; 039B1B : E9 00       ;
CODE_039B1D:          STA.W RAM_ExSpriteXHi,Y             ;; 039B1D : 99 33 17    ;
CODE_039B20:          LDA RAM_SpriteYLo,X                 ;; 039B20 : B5 D8       ;
CODE_039B22:          PHA                                 ;; 039B22 : 48          ;
CODE_039B23:          SEC                                 ;; 039B23 : 38          ;
CODE_039B24:          SBC.B #$14                          ;; 039B24 : E9 14       ;
CODE_039B26:          STA RAM_SpriteYLo,X                 ;; 039B26 : 95 D8       ;
CODE_039B28:          STA.W RAM_ExSpriteYLo,Y             ;; 039B28 : 99 15 17    ;
CODE_039B2B:          LDA.W RAM_SpriteYHi,X               ;; 039B2B : BD D4 14    ;
CODE_039B2E:          PHA                                 ;; 039B2E : 48          ;
CODE_039B2F:          SBC.B #$00                          ;; 039B2F : E9 00       ;
CODE_039B31:          STA.W RAM_ExSpriteYHi,Y             ;; 039B31 : 99 29 17    ;
CODE_039B34:          STA.W RAM_SpriteYHi,X               ;; 039B34 : 9D D4 14    ;
CODE_039B37:          LDA.B #$10                          ;; 039B37 : A9 10       ;
CODE_039B39:          JSR.W CODE_0397F9                   ;; 039B39 : 20 F9 97    ;
CODE_039B3C:          PLA                                 ;; 039B3C : 68          ;
CODE_039B3D:          STA.W RAM_SpriteYHi,X               ;; 039B3D : 9D D4 14    ;
CODE_039B40:          PLA                                 ;; 039B40 : 68          ;
CODE_039B41:          STA RAM_SpriteYLo,X                 ;; 039B41 : 95 D8       ;
CODE_039B43:          PLA                                 ;; 039B43 : 68          ;
CODE_039B44:          STA RAM_SpriteXLo,X                 ;; 039B44 : 95 E4       ;
CODE_039B46:          LDA $00                             ;; 039B46 : A5 00       ;
CODE_039B48:          STA.W RAM_ExSprSpeedY,Y             ;; 039B48 : 99 3D 17    ;
CODE_039B4B:          LDA $01                             ;; 039B4B : A5 01       ;
CODE_039B4D:          STA.W RAM_ExSprSpeedX,Y             ;; 039B4D : 99 47 17    ;
Return039B50:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorTileDispX:      .db $00,$F0,$00,$F0,$F0,$00,$F0,$00 ;; ?QPWZ?               ;
ReznorTileDispY:      .db $E0,$E0,$F0,$F0                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorTiles:          .db $40,$42,$60,$62,$44,$46,$64,$66 ;; ?QPWZ?               ;
                      .db $28,$28,$48,$48                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorPal:            .db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F ;; ?QPWZ?               ;
                      .db $7F,$3F,$7F,$3F                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorGfxRt:          LDA.W $151C,X                       ;; ?QPWZ? : BD 1C 15    ; \ if the reznor is dead, only draw the platform			  
CODE_039B78:          BNE DrawReznorPlats                 ;; 039B78 : D0 65       ; /									  
CODE_039B7A:          JSR.W GetDrawInfoBnk3               ;; 039B7A : 20 60 B7    ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
CODE_039B7D:          LDA.W $1602,X                       ;; 039B7D : BD 02 16    ; \ $03 = index to frame start (frame to show * 4 tiles per frame)	  
CODE_039B80:          ASL                                 ;; 039B80 : 0A          ;  | 								  
CODE_039B81:          ASL                                 ;; 039B81 : 0A          ;  |								  
CODE_039B82:          STA $03                             ;; 039B82 : 85 03       ; /									  
CODE_039B84:          LDA.W RAM_SpriteDir,X               ;; 039B84 : BD 7C 15    ; \ $02 = direction index						  
CODE_039B87:          ASL                                 ;; 039B87 : 0A          ;  |								  
CODE_039B88:          ASL                                 ;; 039B88 : 0A          ;  |								  
CODE_039B89:          STA $02                             ;; 039B89 : 85 02       ; /                                                                   
CODE_039B8B:          PHX                                 ;; 039B8B : DA          ;
CODE_039B8C:          LDX.B #$03                          ;; 039B8C : A2 03       ;
RznrGfxLoopStart:     PHX                                 ;; ?QPWZ? : DA          ;
CODE_039B8F:          LDA $03                             ;; 039B8F : A5 03       ;
CODE_039B91:          CMP.B #$08                          ;; 039B91 : C9 08       ;
CODE_039B93:          BCS CODE_039B99                     ;; 039B93 : B0 04       ;
CODE_039B95:          TXA                                 ;; 039B95 : 8A          ;
CODE_039B96:          ORA $02                             ;; 039B96 : 05 02       ;
CODE_039B98:          TAX                                 ;; 039B98 : AA          ;
CODE_039B99:          LDA $00                             ;; 039B99 : A5 00       ;
CODE_039B9B:          CLC                                 ;; 039B9B : 18          ;
CODE_039B9C:          ADC.W ReznorTileDispX,X             ;; 039B9C : 7D 51 9B    ;
CODE_039B9F:          STA.W OAM_DispX,Y                   ;; 039B9F : 99 00 03    ;
CODE_039BA2:          PLX                                 ;; 039BA2 : FA          ;
CODE_039BA3:          LDA $01                             ;; 039BA3 : A5 01       ;
CODE_039BA5:          CLC                                 ;; 039BA5 : 18          ;
CODE_039BA6:          ADC.W ReznorTileDispY,X             ;; 039BA6 : 7D 59 9B    ;
CODE_039BA9:          STA.W OAM_DispY,Y                   ;; 039BA9 : 99 01 03    ;
CODE_039BAC:          PHX                                 ;; 039BAC : DA          ;
CODE_039BAD:          TXA                                 ;; 039BAD : 8A          ;
CODE_039BAE:          ORA $03                             ;; 039BAE : 05 03       ;
CODE_039BB0:          TAX                                 ;; 039BB0 : AA          ;
CODE_039BB1:          LDA.W ReznorTiles,X                 ;; 039BB1 : BD 5D 9B    ; \ set tile					  
CODE_039BB4:          STA.W OAM_Tile,Y                    ;; 039BB4 : 99 02 03    ; /							  
CODE_039BB7:          LDA.W ReznorPal,X                   ;; 039BB7 : BD 69 9B    ; \ set palette/properties				  
CODE_039BBA:          CPX.B #$08                          ;; 039BBA : E0 08       ;  | if turning, don't flip				  
CODE_039BBC:          BCS NoReznorGfxFlip                 ;; 039BBC : B0 06       ;  | 						  
CODE_039BBE:          LDX $02                             ;; 039BBE : A6 02       ;  | if direction = 0, don't flip			  
CODE_039BC0:          BNE NoReznorGfxFlip                 ;; 039BC0 : D0 02       ;  |						  
CODE_039BC2:          EOR.B #$40                          ;; 039BC2 : 49 40       ;  |						  
NoReznorGfxFlip:      STA.W OAM_Prop,Y                    ;; ?QPWZ? : 99 03 03    ; /							  
CODE_039BC7:          PLX                                 ;; 039BC7 : FA          ; \ pull, X = current tile of the frame we're drawing 
CODE_039BC8:          INY                                 ;; 039BC8 : C8          ;  | Increase index to sprite tile map ($300)...	  
CODE_039BC9:          INY                                 ;; 039BC9 : C8          ;  |    ...we wrote 4 bytes...			  
CODE_039BCA:          INY                                 ;; 039BCA : C8          ;  |    ...so increment 4 times			  
CODE_039BCB:          INY                                 ;; 039BCB : C8          ;  |    						  
CODE_039BCC:          DEX                                 ;; 039BCC : CA          ;  | Go to next tile of frame and loop		  
CODE_039BCD:          BPL RznrGfxLoopStart                ;; 039BCD : 10 BF       ; / 						  
CODE_039BCF:          PLX                                 ;; 039BCF : FA          ; \							  
CODE_039BD0:          LDY.B #$02                          ;; 039BD0 : A0 02       ;  | Y = 02 (All 16x16 tiles)			  
CODE_039BD2:          LDA.B #$03                          ;; 039BD2 : A9 03       ;  | A = number of tiles drawn - 1			  
CODE_039BD4:          JSL.L FinishOAMWrite                ;; 039BD4 : 22 B3 B7 01 ; / Don't draw if offscreen                           
CODE_039BD8:          LDA.W $14C8,X                       ;; 039BD8 : BD C8 14    ;
CODE_039BDB:          CMP.B #$02                          ;; 039BDB : C9 02       ;
CODE_039BDD:          BEQ Return039BE2                    ;; 039BDD : F0 03       ;
DrawReznorPlats:      JSR.W ReznorPlatGfxRt               ;; ?QPWZ? : 20 EB 9B    ;
Return039BE2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorPlatDispY:      .db $00,$03,$04,$05,$05,$04,$03,$00 ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorPlatGfxRt:      LDA.W RAM_SprOAMIndex,X             ;; ?QPWZ? : BD EA 15    ;
CODE_039BEE:          CLC                                 ;; 039BEE : 18          ;
CODE_039BEF:          ADC.B #$10                          ;; 039BEF : 69 10       ;
CODE_039BF1:          STA.W RAM_SprOAMIndex,X             ;; 039BF1 : 9D EA 15    ;
CODE_039BF4:          JSR.W GetDrawInfoBnk3               ;; 039BF4 : 20 60 B7    ;
CODE_039BF7:          LDA.W $1564,X                       ;; 039BF7 : BD 64 15    ;
CODE_039BFA:          LSR                                 ;; 039BFA : 4A          ;
CODE_039BFB:          PHY                                 ;; 039BFB : 5A          ;
CODE_039BFC:          TAY                                 ;; 039BFC : A8          ;
CODE_039BFD:          LDA.W ReznorPlatDispY,Y             ;; 039BFD : B9 E3 9B    ;
CODE_039C00:          STA $02                             ;; 039C00 : 85 02       ;
CODE_039C02:          PLY                                 ;; 039C02 : 7A          ;
CODE_039C03:          LDA $00                             ;; 039C03 : A5 00       ;
CODE_039C05:          STA.W OAM_Tile2DispX,Y              ;; 039C05 : 99 04 03    ;
CODE_039C08:          SEC                                 ;; 039C08 : 38          ;
CODE_039C09:          SBC.B #$10                          ;; 039C09 : E9 10       ;
CODE_039C0B:          STA.W OAM_DispX,Y                   ;; 039C0B : 99 00 03    ;
CODE_039C0E:          LDA $01                             ;; 039C0E : A5 01       ;
CODE_039C10:          SEC                                 ;; 039C10 : 38          ;
CODE_039C11:          SBC $02                             ;; 039C11 : E5 02       ;
CODE_039C13:          STA.W OAM_DispY,Y                   ;; 039C13 : 99 01 03    ;
CODE_039C16:          STA.W OAM_Tile2DispY,Y              ;; 039C16 : 99 05 03    ;
CODE_039C19:          LDA.B #$4E                          ;; 039C19 : A9 4E       ; \ Tile of reznor platform...     
CODE_039C1B:          STA.W OAM_Tile,Y                    ;; 039C1B : 99 02 03    ;  | ...store left side	       
CODE_039C1E:          STA.W OAM_Tile2,Y                   ;; 039C1E : 99 06 03    ; /  ...store right side	       
CODE_039C21:          LDA.B #$33                          ;; 039C21 : A9 33       ; \ Palette of reznor platform...  
CODE_039C23:          STA.W OAM_Prop,Y                    ;; 039C23 : 99 03 03    ;  |			       
CODE_039C26:          ORA.B #$40                          ;; 039C26 : 09 40       ;  | ...flip right side	       
CODE_039C28:          STA.W OAM_Tile2Prop,Y               ;; 039C28 : 99 07 03    ; /				       
CODE_039C2B:          LDY.B #$02                          ;; 039C2B : A0 02       ; \				       
CODE_039C2D:          LDA.B #$01                          ;; 039C2D : A9 01       ;  | A = number of tiles drawn - 1 
CODE_039C2F:          JSL.L FinishOAMWrite                ;; 039C2F : 22 B3 B7 01 ; / Don't draw if offscreen        
Return039C33:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
InvisBlk+DinosMain:   LDA RAM_SpriteNum,X                 ;; ?QPWZ? : B5 9E       ; \ Branch if sprite isn't "Invisible solid block" 
CODE_039C36:          CMP.B #$6D                          ;; 039C36 : C9 6D       ;  | 
CODE_039C38:          BNE DinoMainRt                      ;; 039C38 : D0 05       ; / 
CODE_039C3A:          JSL.L InvisBlkMainRt                ;; 039C3A : 22 4F B4 01 ; \ Call "Invisible solid block" routine 
Return039C3E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
DinoMainRt:           PHB                                 ;; ?QPWZ? : 8B          ;
CODE_039C40:          PHK                                 ;; 039C40 : 4B          ;
CODE_039C41:          PLB                                 ;; 039C41 : AB          ;
CODE_039C42:          JSR.W DinoMainSubRt                 ;; 039C42 : 20 47 9C    ;
CODE_039C45:          PLB                                 ;; 039C45 : AB          ;
Return039C46:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
DinoMainSubRt:        JSR.W DinoGfxRt                     ;; ?QPWZ? : 20 49 9E    ;
CODE_039C4A:          LDA RAM_SpritesLocked               ;; 039C4A : A5 9D       ;
CODE_039C4C:          BNE Return039CA3                    ;; 039C4C : D0 55       ;
CODE_039C4E:          LDA.W $14C8,X                       ;; 039C4E : BD C8 14    ;
CODE_039C51:          CMP.B #$08                          ;; 039C51 : C9 08       ;
CODE_039C53:          BNE Return039CA3                    ;; 039C53 : D0 4E       ;
CODE_039C55:          JSR.W SubOffscreen0Bnk3             ;; 039C55 : 20 5D B8    ;
CODE_039C58:          JSL.L MarioSprInteract              ;; 039C58 : 22 DC A7 01 ;
CODE_039C5C:          JSL.L UpdateSpritePos               ;; 039C5C : 22 2A 80 01 ;
CODE_039C60:          LDA RAM_SpriteState,X               ;; 039C60 : B5 C2       ;
CODE_039C62:          JSL.L ExecutePtr                    ;; 039C62 : 22 DF 86 00 ;
                                                          ;;                      ;
RhinoStatePtrs:       .dw CODE_039CA8                     ;; ?QPWZ? : A8 9C       ;
                      .dw CODE_039D41                     ;; ?QPWZ? : 41 9D       ;
                      .dw CODE_039D41                     ;; ?QPWZ? : 41 9D       ;
                      .dw CODE_039C74                     ;; ?QPWZ? : 74 9C       ;
                                                          ;;                      ;
DATA_039C6E:          .db $00,$FE,$02                     ;; 039C6E               ;
                                                          ;;                      ;
DATA_039C71:          .db $00,$FF,$00                     ;; 039C71               ;
                                                          ;;                      ;
CODE_039C74:          LDA RAM_SpriteSpeedY,X              ;; 039C74 : B5 AA       ;
CODE_039C76:          BMI CODE_039C89                     ;; 039C76 : 30 11       ;
CODE_039C78:          STZ RAM_SpriteState,X               ;; 039C78 : 74 C2       ;
CODE_039C7A:          LDA.W RAM_SprObjStatus,X            ;; 039C7A : BD 88 15    ; \ Branch if not touching object 
CODE_039C7D:          AND.B #$03                          ;; 039C7D : 29 03       ;  | 
CODE_039C7F:          BEQ CODE_039C89                     ;; 039C7F : F0 08       ; / 
CODE_039C81:          LDA.W RAM_SpriteDir,X               ;; 039C81 : BD 7C 15    ;
CODE_039C84:          EOR.B #$01                          ;; 039C84 : 49 01       ;
CODE_039C86:          STA.W RAM_SpriteDir,X               ;; 039C86 : 9D 7C 15    ;
CODE_039C89:          STZ.W $1602,X                       ;; 039C89 : 9E 02 16    ;
CODE_039C8C:          LDA.W RAM_SprObjStatus,X            ;; 039C8C : BD 88 15    ;
CODE_039C8F:          AND.B #$03                          ;; 039C8F : 29 03       ;
CODE_039C91:          TAY                                 ;; 039C91 : A8          ;
CODE_039C92:          LDA RAM_SpriteXLo,X                 ;; 039C92 : B5 E4       ;
CODE_039C94:          CLC                                 ;; 039C94 : 18          ;
CODE_039C95:          ADC.W DATA_039C6E,Y                 ;; 039C95 : 79 6E 9C    ;
CODE_039C98:          STA RAM_SpriteXLo,X                 ;; 039C98 : 95 E4       ;
CODE_039C9A:          LDA.W RAM_SpriteXHi,X               ;; 039C9A : BD E0 14    ;
CODE_039C9D:          ADC.W DATA_039C71,Y                 ;; 039C9D : 79 71 9C    ;
CODE_039CA0:          STA.W RAM_SpriteXHi,X               ;; 039CA0 : 9D E0 14    ;
Return039CA3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoSpeed:            .db $08,$F8,$10,$F0                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_039CA8:          LDA.W RAM_SprObjStatus,X            ;; 039CA8 : BD 88 15    ; \ Branch if not on ground 
CODE_039CAB:          AND.B #$04                          ;; 039CAB : 29 04       ;  | 
CODE_039CAD:          BEQ CODE_039C89                     ;; 039CAD : F0 DA       ; / 
CODE_039CAF:          LDA.W $1540,X                       ;; 039CAF : BD 40 15    ;
CODE_039CB2:          BNE CODE_039CC8                     ;; 039CB2 : D0 14       ;
CODE_039CB4:          LDA RAM_SpriteNum,X                 ;; 039CB4 : B5 9E       ;
CODE_039CB6:          CMP.B #$6E                          ;; 039CB6 : C9 6E       ;
CODE_039CB8:          BEQ CODE_039CC8                     ;; 039CB8 : F0 0E       ;
CODE_039CBA:          LDA.B #$FF                          ;; 039CBA : A9 FF       ; \ Set fire breathing timer 
CODE_039CBC:          STA.W $1540,X                       ;; 039CBC : 9D 40 15    ; / 
CODE_039CBF:          JSL.L GetRand                       ;; 039CBF : 22 F9 AC 01 ;
CODE_039CC3:          AND.B #$01                          ;; 039CC3 : 29 01       ;
CODE_039CC5:          INC A                               ;; 039CC5 : 1A          ;
CODE_039CC6:          STA RAM_SpriteState,X               ;; 039CC6 : 95 C2       ;
CODE_039CC8:          TXA                                 ;; 039CC8 : 8A          ;
CODE_039CC9:          ASL                                 ;; 039CC9 : 0A          ;
CODE_039CCA:          ASL                                 ;; 039CCA : 0A          ;
CODE_039CCB:          ASL                                 ;; 039CCB : 0A          ;
CODE_039CCC:          ASL                                 ;; 039CCC : 0A          ;
CODE_039CCD:          ADC RAM_FrameCounterB               ;; 039CCD : 65 14       ;
CODE_039CCF:          AND.B #$3F                          ;; 039CCF : 29 3F       ;
CODE_039CD1:          BNE CODE_039CDA                     ;; 039CD1 : D0 07       ;
CODE_039CD3:          JSR.W SubHorzPosBnk3                ;; 039CD3 : 20 17 B8    ; \ If not facing mario, change directions 
CODE_039CD6:          TYA                                 ;; 039CD6 : 98          ;  | 
CODE_039CD7:          STA.W RAM_SpriteDir,X               ;; 039CD7 : 9D 7C 15    ; / 
CODE_039CDA:          LDA.B #$10                          ;; 039CDA : A9 10       ;
CODE_039CDC:          STA RAM_SpriteSpeedY,X              ;; 039CDC : 95 AA       ;
CODE_039CDE:          LDY.W RAM_SpriteDir,X               ;; 039CDE : BC 7C 15    ; \ Set x speed for rhino based on direction and sprite number 
CODE_039CE1:          LDA RAM_SpriteNum,X                 ;; 039CE1 : B5 9E       ;  | 
CODE_039CE3:          CMP.B #$6E                          ;; 039CE3 : C9 6E       ;  | 
CODE_039CE5:          BEQ CODE_039CE9                     ;; 039CE5 : F0 02       ;  | 
CODE_039CE7:          INY                                 ;; 039CE7 : C8          ;  | 
CODE_039CE8:          INY                                 ;; 039CE8 : C8          ;  | 
CODE_039CE9:          LDA.W DinoSpeed,Y                   ;; 039CE9 : B9 A4 9C    ;  | 
CODE_039CEC:          STA RAM_SpriteSpeedX,X              ;; 039CEC : 95 B6       ; / 
CODE_039CEE:          JSR.W DinoSetGfxFrame               ;; 039CEE : 20 EF 9D    ;
CODE_039CF1:          LDA.W RAM_SprObjStatus,X            ;; 039CF1 : BD 88 15    ; \ Branch if not touching object 
CODE_039CF4:          AND.B #$03                          ;; 039CF4 : 29 03       ;  | 
CODE_039CF6:          BEQ Return039D00                    ;; 039CF6 : F0 08       ; / 
CODE_039CF8:          LDA.B #$C0                          ;; 039CF8 : A9 C0       ;
CODE_039CFA:          STA RAM_SpriteSpeedY,X              ;; 039CFA : 95 AA       ;
CODE_039CFC:          LDA.B #$03                          ;; 039CFC : A9 03       ;
CODE_039CFE:          STA RAM_SpriteState,X               ;; 039CFE : 95 C2       ;
Return039D00:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoFlameTable:       .db $41,$42,$42,$32,$22,$12,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$02,$02,$02,$02,$12 ;; ?QPWZ?               ;
                      .db $22,$32,$42,$42,$42,$42,$41,$41 ;; ?QPWZ?               ;
                      .db $41,$43,$43,$33,$23,$13,$03,$03 ;; ?QPWZ?               ;
                      .db $03,$03,$03,$03,$03,$03,$03,$03 ;; ?QPWZ?               ;
                      .db $03,$03,$03,$03,$03,$03,$03,$13 ;; ?QPWZ?               ;
                      .db $23,$33,$43,$43,$43,$43,$41,$41 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_039D41:          STZ RAM_SpriteSpeedX,X              ;; 039D41 : 74 B6       ; Sprite X Speed = 0 
CODE_039D43:          LDA.W $1540,X                       ;; 039D43 : BD 40 15    ;
CODE_039D46:          BNE DinoFlameTimerSet               ;; 039D46 : D0 09       ;
CODE_039D48:          STZ RAM_SpriteState,X               ;; 039D48 : 74 C2       ;
CODE_039D4A:          LDA.B #$40                          ;; 039D4A : A9 40       ;
CODE_039D4C:          STA.W $1540,X                       ;; 039D4C : 9D 40 15    ;
CODE_039D4F:          LDA.B #$00                          ;; 039D4F : A9 00       ;
DinoFlameTimerSet:    CMP.B #$C0                          ;; ?QPWZ? : C9 C0       ;
CODE_039D53:          BNE CODE_039D5A                     ;; 039D53 : D0 05       ;
CODE_039D55:          LDY.B #$17                          ;; 039D55 : A0 17       ; \ Play sound effect 
CODE_039D57:          STY.W $1DFC                         ;; 039D57 : 8C FC 1D    ; / 
CODE_039D5A:          LSR                                 ;; 039D5A : 4A          ;
CODE_039D5B:          LSR                                 ;; 039D5B : 4A          ;
CODE_039D5C:          LSR                                 ;; 039D5C : 4A          ;
CODE_039D5D:          LDY RAM_SpriteState,X               ;; 039D5D : B4 C2       ;
CODE_039D5F:          CPY.B #$02                          ;; 039D5F : C0 02       ;
CODE_039D61:          BNE CODE_039D66                     ;; 039D61 : D0 03       ;
CODE_039D63:          CLC                                 ;; 039D63 : 18          ;
CODE_039D64:          ADC.B #$20                          ;; 039D64 : 69 20       ;
CODE_039D66:          TAY                                 ;; 039D66 : A8          ;
CODE_039D67:          LDA.W DinoFlameTable,Y              ;; 039D67 : B9 01 9D    ;
CODE_039D6A:          PHA                                 ;; 039D6A : 48          ;
CODE_039D6B:          AND.B #$0F                          ;; 039D6B : 29 0F       ;
CODE_039D6D:          STA.W $1602,X                       ;; 039D6D : 9D 02 16    ;
CODE_039D70:          PLA                                 ;; 039D70 : 68          ;
CODE_039D71:          LSR                                 ;; 039D71 : 4A          ;
CODE_039D72:          LSR                                 ;; 039D72 : 4A          ;
CODE_039D73:          LSR                                 ;; 039D73 : 4A          ;
CODE_039D74:          LSR                                 ;; 039D74 : 4A          ;
CODE_039D75:          STA.W $151C,X                       ;; 039D75 : 9D 1C 15    ;
CODE_039D78:          BNE Return039D9D                    ;; 039D78 : D0 23       ;
CODE_039D7A:          LDA RAM_SpriteNum,X                 ;; 039D7A : B5 9E       ;
CODE_039D7C:          CMP.B #$6E                          ;; 039D7C : C9 6E       ;
CODE_039D7E:          BEQ Return039D9D                    ;; 039D7E : F0 1D       ;
CODE_039D80:          TXA                                 ;; 039D80 : 8A          ;
CODE_039D81:          EOR RAM_FrameCounter                ;; 039D81 : 45 13       ;
CODE_039D83:          AND.B #$03                          ;; 039D83 : 29 03       ;
CODE_039D85:          BNE Return039D9D                    ;; 039D85 : D0 16       ;
CODE_039D87:          JSR.W DinoFlameClipping             ;; 039D87 : 20 B6 9D    ;
CODE_039D8A:          JSL.L GetMarioClipping              ;; 039D8A : 22 64 B6 03 ;
CODE_039D8E:          JSL.L CheckForContact               ;; 039D8E : 22 2B B7 03 ;
CODE_039D92:          BCC Return039D9D                    ;; 039D92 : 90 09       ;
ADDR_039D94:          LDA.W $1490                         ;; 039D94 : AD 90 14    ; \ Branch if Mario has star 
ADDR_039D97:          BNE Return039D9D                    ;; 039D97 : D0 04       ; / 
ADDR_039D99:          JSL.L HurtMario                     ;; 039D99 : 22 B7 F5 00 ;
Return039D9D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoFlame1:           .db $DC,$02,$10,$02                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame2:           .db $FF,$00,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame3:           .db $24,$0C,$24,$0C                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame4:           .db $02,$DC,$02,$DC                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame5:           .db $00,$FF,$00,$FF                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame6:           .db $0C,$24,$0C,$24                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlameClipping:    LDA.W $1602,X                       ;; ?QPWZ? : BD 02 16    ;
CODE_039DB9:          SEC                                 ;; 039DB9 : 38          ;
CODE_039DBA:          SBC.B #$02                          ;; 039DBA : E9 02       ;
CODE_039DBC:          TAY                                 ;; 039DBC : A8          ;
CODE_039DBD:          LDA.W RAM_SpriteDir,X               ;; 039DBD : BD 7C 15    ;
CODE_039DC0:          BNE CODE_039DC4                     ;; 039DC0 : D0 02       ;
CODE_039DC2:          INY                                 ;; 039DC2 : C8          ;
CODE_039DC3:          INY                                 ;; 039DC3 : C8          ;
CODE_039DC4:          LDA RAM_SpriteXLo,X                 ;; 039DC4 : B5 E4       ;
CODE_039DC6:          CLC                                 ;; 039DC6 : 18          ;
CODE_039DC7:          ADC.W DinoFlame1,Y                  ;; 039DC7 : 79 9E 9D    ;
CODE_039DCA:          STA $04                             ;; 039DCA : 85 04       ;
CODE_039DCC:          LDA.W RAM_SpriteXHi,X               ;; 039DCC : BD E0 14    ;
CODE_039DCF:          ADC.W DinoFlame2,Y                  ;; 039DCF : 79 A2 9D    ;
CODE_039DD2:          STA $0A                             ;; 039DD2 : 85 0A       ;
CODE_039DD4:          LDA.W DinoFlame3,Y                  ;; 039DD4 : B9 A6 9D    ;
CODE_039DD7:          STA $06                             ;; 039DD7 : 85 06       ;
CODE_039DD9:          LDA RAM_SpriteYLo,X                 ;; 039DD9 : B5 D8       ;
CODE_039DDB:          CLC                                 ;; 039DDB : 18          ;
CODE_039DDC:          ADC.W DinoFlame4,Y                  ;; 039DDC : 79 AA 9D    ;
CODE_039DDF:          STA $05                             ;; 039DDF : 85 05       ;
CODE_039DE1:          LDA.W RAM_SpriteYHi,X               ;; 039DE1 : BD D4 14    ;
CODE_039DE4:          ADC.W DinoFlame5,Y                  ;; 039DE4 : 79 AE 9D    ;
CODE_039DE7:          STA $0B                             ;; 039DE7 : 85 0B       ;
CODE_039DE9:          LDA.W DinoFlame6,Y                  ;; 039DE9 : B9 B2 9D    ;
CODE_039DEC:          STA $07                             ;; 039DEC : 85 07       ;
Return039DEE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
DinoSetGfxFrame:      INC.W $1570,X                       ;; ?QPWZ? : FE 70 15    ;
CODE_039DF2:          LDA.W $1570,X                       ;; 039DF2 : BD 70 15    ;
CODE_039DF5:          AND.B #$08                          ;; 039DF5 : 29 08       ;
CODE_039DF7:          LSR                                 ;; 039DF7 : 4A          ;
CODE_039DF8:          LSR                                 ;; 039DF8 : 4A          ;
CODE_039DF9:          LSR                                 ;; 039DF9 : 4A          ;
CODE_039DFA:          STA.W $1602,X                       ;; 039DFA : 9D 02 16    ;
Return039DFD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoTorchTileDispX:   .db $D8,$E0,$EC,$F8,$00,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchTileDispY:   .db $00,$00,$00,$00,$00,$D8,$E0,$EC ;; ?QPWZ?               ;
                      .db $F8,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlameTiles:       .db $80,$82,$84,$86,$00,$88,$8A,$8C ;; ?QPWZ?               ;
                      .db $8E,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchGfxProp:     .db $09,$05,$05,$05,$0F             ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchTiles:       .db $EA,$AA,$C4,$C6                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoRhinoTileDispX:   .db $F8,$08,$F8,$08,$08,$F8,$08,$F8 ;; ?QPWZ?               ;
DinoRhinoGfxProp:     .db $2F,$2F,$2F,$2F,$6F,$6F,$6F,$6F ;; ?QPWZ?               ;
DinoRhinoTileDispY:   .db $F0,$F0,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoRhinoTiles:       .db $C0,$C2,$E4,$E6,$C0,$C2,$E0,$E2 ;; ?QPWZ?               ;
                      .db $C8,$CA,$E8,$E2,$CC,$CE,$EC,$EE ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoGfxRt:            JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_039E4C:          LDA.W RAM_SpriteDir,X               ;; 039E4C : BD 7C 15    ;
CODE_039E4F:          STA $02                             ;; 039E4F : 85 02       ;
CODE_039E51:          LDA.W $1602,X                       ;; 039E51 : BD 02 16    ;
CODE_039E54:          STA $04                             ;; 039E54 : 85 04       ;
CODE_039E56:          LDA RAM_SpriteNum,X                 ;; 039E56 : B5 9E       ;
CODE_039E58:          CMP.B #$6F                          ;; 039E58 : C9 6F       ;
CODE_039E5A:          BEQ CODE_039EA9                     ;; 039E5A : F0 4D       ;
CODE_039E5C:          PHX                                 ;; 039E5C : DA          ;
CODE_039E5D:          LDX.B #$03                          ;; 039E5D : A2 03       ;
CODE_039E5F:          STX $0F                             ;; 039E5F : 86 0F       ;
CODE_039E61:          LDA $02                             ;; 039E61 : A5 02       ;
CODE_039E63:          CMP.B #$01                          ;; 039E63 : C9 01       ;
CODE_039E65:          BCS CODE_039E6C                     ;; 039E65 : B0 05       ;
CODE_039E67:          TXA                                 ;; 039E67 : 8A          ;
CODE_039E68:          CLC                                 ;; 039E68 : 18          ;
CODE_039E69:          ADC.B #$04                          ;; 039E69 : 69 04       ;
CODE_039E6B:          TAX                                 ;; 039E6B : AA          ;
CODE_039E6C:          LDA.W DinoRhinoGfxProp,X            ;; 039E6C : BD 2D 9E    ;
CODE_039E6F:          STA.W OAM_Prop,Y                    ;; 039E6F : 99 03 03    ;
CODE_039E72:          LDA.W DinoRhinoTileDispX,X          ;; 039E72 : BD 25 9E    ;
CODE_039E75:          CLC                                 ;; 039E75 : 18          ;
CODE_039E76:          ADC $00                             ;; 039E76 : 65 00       ;
CODE_039E78:          STA.W OAM_DispX,Y                   ;; 039E78 : 99 00 03    ;
CODE_039E7B:          LDA $04                             ;; 039E7B : A5 04       ;
CODE_039E7D:          CMP.B #$01                          ;; 039E7D : C9 01       ;
CODE_039E7F:          LDX $0F                             ;; 039E7F : A6 0F       ;
CODE_039E81:          LDA.W DinoRhinoTileDispY,X          ;; 039E81 : BD 35 9E    ;
CODE_039E84:          ADC $01                             ;; 039E84 : 65 01       ;
CODE_039E86:          STA.W OAM_DispY,Y                   ;; 039E86 : 99 01 03    ;
CODE_039E89:          LDA $04                             ;; 039E89 : A5 04       ;
CODE_039E8B:          ASL                                 ;; 039E8B : 0A          ;
CODE_039E8C:          ASL                                 ;; 039E8C : 0A          ;
CODE_039E8D:          ADC $0F                             ;; 039E8D : 65 0F       ;
CODE_039E8F:          TAX                                 ;; 039E8F : AA          ;
CODE_039E90:          LDA.W DinoRhinoTiles,X              ;; 039E90 : BD 39 9E    ;
CODE_039E93:          STA.W OAM_Tile,Y                    ;; 039E93 : 99 02 03    ;
CODE_039E96:          INY                                 ;; 039E96 : C8          ;
CODE_039E97:          INY                                 ;; 039E97 : C8          ;
CODE_039E98:          INY                                 ;; 039E98 : C8          ;
CODE_039E99:          INY                                 ;; 039E99 : C8          ;
CODE_039E9A:          LDX $0F                             ;; 039E9A : A6 0F       ;
CODE_039E9C:          DEX                                 ;; 039E9C : CA          ;
CODE_039E9D:          BPL CODE_039E5F                     ;; 039E9D : 10 C0       ;
CODE_039E9F:          PLX                                 ;; 039E9F : FA          ;
CODE_039EA0:          LDA.B #$03                          ;; 039EA0 : A9 03       ;
CODE_039EA2:          LDY.B #$02                          ;; 039EA2 : A0 02       ;
CODE_039EA4:          JSL.L FinishOAMWrite                ;; 039EA4 : 22 B3 B7 01 ;
Return039EA8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039EA9:          LDA.W $151C,X                       ;; 039EA9 : BD 1C 15    ;
CODE_039EAC:          STA $03                             ;; 039EAC : 85 03       ;
CODE_039EAE:          LDA.W $1602,X                       ;; 039EAE : BD 02 16    ;
CODE_039EB1:          STA $04                             ;; 039EB1 : 85 04       ;
CODE_039EB3:          PHX                                 ;; 039EB3 : DA          ;
CODE_039EB4:          LDA RAM_FrameCounterB               ;; 039EB4 : A5 14       ;
CODE_039EB6:          AND.B #$02                          ;; 039EB6 : 29 02       ;
CODE_039EB8:          ASL                                 ;; 039EB8 : 0A          ;
CODE_039EB9:          ASL                                 ;; 039EB9 : 0A          ;
CODE_039EBA:          ASL                                 ;; 039EBA : 0A          ;
CODE_039EBB:          ASL                                 ;; 039EBB : 0A          ;
CODE_039EBC:          ASL                                 ;; 039EBC : 0A          ;
CODE_039EBD:          LDX $04                             ;; 039EBD : A6 04       ;
CODE_039EBF:          CPX.B #$03                          ;; 039EBF : E0 03       ;
CODE_039EC1:          BEQ CODE_039EC4                     ;; 039EC1 : F0 01       ;
CODE_039EC3:          ASL                                 ;; 039EC3 : 0A          ;
CODE_039EC4:          STA $05                             ;; 039EC4 : 85 05       ;
CODE_039EC6:          LDX.B #$04                          ;; 039EC6 : A2 04       ;
CODE_039EC8:          STX $06                             ;; 039EC8 : 86 06       ;
CODE_039ECA:          LDA $04                             ;; 039ECA : A5 04       ;
CODE_039ECC:          CMP.B #$03                          ;; 039ECC : C9 03       ;
CODE_039ECE:          BNE CODE_039ED5                     ;; 039ECE : D0 05       ;
CODE_039ED0:          TXA                                 ;; 039ED0 : 8A          ;
CODE_039ED1:          CLC                                 ;; 039ED1 : 18          ;
CODE_039ED2:          ADC.B #$05                          ;; 039ED2 : 69 05       ;
CODE_039ED4:          TAX                                 ;; 039ED4 : AA          ;
CODE_039ED5:          PHX                                 ;; 039ED5 : DA          ;
CODE_039ED6:          LDA.W DinoTorchTileDispX,X          ;; 039ED6 : BD FE 9D    ;
CODE_039ED9:          LDX $02                             ;; 039ED9 : A6 02       ;
CODE_039EDB:          BNE CODE_039EE0                     ;; 039EDB : D0 03       ;
CODE_039EDD:          EOR.B #$FF                          ;; 039EDD : 49 FF       ;
CODE_039EDF:          INC A                               ;; 039EDF : 1A          ;
CODE_039EE0:          PLX                                 ;; 039EE0 : FA          ;
CODE_039EE1:          CLC                                 ;; 039EE1 : 18          ;
CODE_039EE2:          ADC $00                             ;; 039EE2 : 65 00       ;
CODE_039EE4:          STA.W OAM_DispX,Y                   ;; 039EE4 : 99 00 03    ;
CODE_039EE7:          LDA.W DinoTorchTileDispY,X          ;; 039EE7 : BD 08 9E    ;
CODE_039EEA:          CLC                                 ;; 039EEA : 18          ;
CODE_039EEB:          ADC $01                             ;; 039EEB : 65 01       ;
CODE_039EED:          STA.W OAM_DispY,Y                   ;; 039EED : 99 01 03    ;
CODE_039EF0:          LDA $06                             ;; 039EF0 : A5 06       ;
CODE_039EF2:          CMP.B #$04                          ;; 039EF2 : C9 04       ;
CODE_039EF4:          BNE CODE_039EFD                     ;; 039EF4 : D0 07       ;
CODE_039EF6:          LDX $04                             ;; 039EF6 : A6 04       ;
CODE_039EF8:          LDA.W DinoTorchTiles,X              ;; 039EF8 : BD 21 9E    ;
CODE_039EFB:          BRA CODE_039F00                     ;; 039EFB : 80 03       ;
                                                          ;;                      ;
CODE_039EFD:          LDA.W DinoFlameTiles,X              ;; 039EFD : BD 12 9E    ;
CODE_039F00:          STA.W OAM_Tile,Y                    ;; 039F00 : 99 02 03    ;
CODE_039F03:          LDA.B #$00                          ;; 039F03 : A9 00       ;
CODE_039F05:          LDX $02                             ;; 039F05 : A6 02       ;
CODE_039F07:          BNE CODE_039F0B                     ;; 039F07 : D0 02       ;
CODE_039F09:          ORA.B #$40                          ;; 039F09 : 09 40       ;
CODE_039F0B:          LDX $06                             ;; 039F0B : A6 06       ;
CODE_039F0D:          CPX.B #$04                          ;; 039F0D : E0 04       ;
CODE_039F0F:          BEQ CODE_039F13                     ;; 039F0F : F0 02       ;
CODE_039F11:          EOR $05                             ;; 039F11 : 45 05       ;
CODE_039F13:          ORA.W DinoTorchGfxProp,X            ;; 039F13 : 1D 1C 9E    ;
CODE_039F16:          ORA $64                             ;; 039F16 : 05 64       ;
CODE_039F18:          STA.W OAM_Prop,Y                    ;; 039F18 : 99 03 03    ;
CODE_039F1B:          INY                                 ;; 039F1B : C8          ;
CODE_039F1C:          INY                                 ;; 039F1C : C8          ;
CODE_039F1D:          INY                                 ;; 039F1D : C8          ;
CODE_039F1E:          INY                                 ;; 039F1E : C8          ;
CODE_039F1F:          DEX                                 ;; 039F1F : CA          ;
CODE_039F20:          CPX $03                             ;; 039F20 : E4 03       ;
CODE_039F22:          BPL CODE_039EC8                     ;; 039F22 : 10 A4       ;
CODE_039F24:          PLX                                 ;; 039F24 : FA          ;
CODE_039F25:          LDY.W $151C,X                       ;; 039F25 : BC 1C 15    ;
CODE_039F28:          LDA.W DinoTilesWritten,Y            ;; 039F28 : B9 32 9F    ;
CODE_039F2B:          LDY.B #$02                          ;; 039F2B : A0 02       ;
CODE_039F2D:          JSL.L FinishOAMWrite                ;; 039F2D : 22 B3 B7 01 ;
Return039F31:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoTilesWritten:     .db $04,$03,$02,$01,$00             ;; ?QPWZ?               ;
                                                          ;;                      ;
Return039F37:         RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
Blargg:               JSR.W CODE_03A062                   ;; ?QPWZ? : 20 62 A0    ;
CODE_039F3B:          LDA RAM_SpritesLocked               ;; 039F3B : A5 9D       ;
CODE_039F3D:          BNE Return039F56                    ;; 039F3D : D0 17       ;
CODE_039F3F:          JSL.L MarioSprInteract              ;; 039F3F : 22 DC A7 01 ;
CODE_039F43:          JSR.W SubOffscreen0Bnk3             ;; 039F43 : 20 5D B8    ;
CODE_039F46:          LDA RAM_SpriteState,X               ;; 039F46 : B5 C2       ;
CODE_039F48:          JSL.L ExecutePtr                    ;; 039F48 : 22 DF 86 00 ;
                                                          ;;                      ;
BlarggPtrs:           .dw CODE_039F57                     ;; ?QPWZ? : 57 9F       ;
                      .dw CODE_039F8B                     ;; ?QPWZ? : 8B 9F       ;
                      .dw CODE_039FA4                     ;; ?QPWZ? : A4 9F       ;
                      .dw CODE_039FC8                     ;; ?QPWZ? : C8 9F       ;
                      .dw CODE_039FEF                     ;; ?QPWZ? : EF 9F       ;
                                                          ;;                      ;
Return039F56:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F57:          LDA.W RAM_OffscreenHorz,X           ;; 039F57 : BD A0 15    ;
CODE_039F5A:          ORA.W $1540,X                       ;; 039F5A : 1D 40 15    ;
CODE_039F5D:          BNE Return039F8A                    ;; 039F5D : D0 2B       ;
CODE_039F5F:          JSR.W SubHorzPosBnk3                ;; 039F5F : 20 17 B8    ;
CODE_039F62:          LDA $0F                             ;; 039F62 : A5 0F       ;
CODE_039F64:          CLC                                 ;; 039F64 : 18          ;
CODE_039F65:          ADC.B #$70                          ;; 039F65 : 69 70       ;
CODE_039F67:          CMP.B #$E0                          ;; 039F67 : C9 E0       ;
CODE_039F69:          BCS Return039F8A                    ;; 039F69 : B0 1F       ;
CODE_039F6B:          LDA.B #$E3                          ;; 039F6B : A9 E3       ;
CODE_039F6D:          STA RAM_SpriteSpeedY,X              ;; 039F6D : 95 AA       ;
CODE_039F6F:          LDA.W RAM_SpriteXHi,X               ;; 039F6F : BD E0 14    ;
CODE_039F72:          STA.W $151C,X                       ;; 039F72 : 9D 1C 15    ;
CODE_039F75:          LDA RAM_SpriteXLo,X                 ;; 039F75 : B5 E4       ;
CODE_039F77:          STA.W $1528,X                       ;; 039F77 : 9D 28 15    ;
CODE_039F7A:          LDA.W RAM_SpriteYHi,X               ;; 039F7A : BD D4 14    ;
CODE_039F7D:          STA.W $1534,X                       ;; 039F7D : 9D 34 15    ;
CODE_039F80:          LDA RAM_SpriteYLo,X                 ;; 039F80 : B5 D8       ;
CODE_039F82:          STA.W $1594,X                       ;; 039F82 : 9D 94 15    ;
CODE_039F85:          JSR.W CODE_039FC0                   ;; 039F85 : 20 C0 9F    ;
CODE_039F88:          INC RAM_SpriteState,X               ;; 039F88 : F6 C2       ;
Return039F8A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F8B:          LDA RAM_SpriteSpeedY,X              ;; 039F8B : B5 AA       ;
CODE_039F8D:          CMP.B #$10                          ;; 039F8D : C9 10       ;
CODE_039F8F:          BMI CODE_039F9B                     ;; 039F8F : 30 0A       ;
CODE_039F91:          LDA.B #$50                          ;; 039F91 : A9 50       ;
CODE_039F93:          STA.W $1540,X                       ;; 039F93 : 9D 40 15    ;
CODE_039F96:          INC RAM_SpriteState,X               ;; 039F96 : F6 C2       ;
CODE_039F98:          STZ RAM_SpriteSpeedY,X              ;; 039F98 : 74 AA       ; Sprite Y Speed = 0 
Return039F9A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F9B:          JSL.L UpdateYPosNoGrvty             ;; 039F9B : 22 1A 80 01 ;
CODE_039F9F:          INC RAM_SpriteSpeedY,X              ;; 039F9F : F6 AA       ;
CODE_039FA1:          INC RAM_SpriteSpeedY,X              ;; 039FA1 : F6 AA       ;
Return039FA3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FA4:          LDA.W $1540,X                       ;; 039FA4 : BD 40 15    ;
CODE_039FA7:          BNE CODE_039FB1                     ;; 039FA7 : D0 08       ;
CODE_039FA9:          INC RAM_SpriteState,X               ;; 039FA9 : F6 C2       ;
CODE_039FAB:          LDA.B #$0A                          ;; 039FAB : A9 0A       ;
CODE_039FAD:          STA.W $1540,X                       ;; 039FAD : 9D 40 15    ;
Return039FB0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FB1:          CMP.B #$20                          ;; 039FB1 : C9 20       ;
CODE_039FB3:          BCC CODE_039FC0                     ;; 039FB3 : 90 0B       ;
CODE_039FB5:          AND.B #$1F                          ;; 039FB5 : 29 1F       ;
CODE_039FB7:          BNE Return039FC7                    ;; 039FB7 : D0 0E       ;
CODE_039FB9:          LDA.W RAM_SpriteDir,X               ;; 039FB9 : BD 7C 15    ;
CODE_039FBC:          EOR.B #$01                          ;; 039FBC : 49 01       ;
CODE_039FBE:          BRA CODE_039FC4                     ;; 039FBE : 80 04       ;
                                                          ;;                      ;
CODE_039FC0:          JSR.W SubHorzPosBnk3                ;; 039FC0 : 20 17 B8    ;
CODE_039FC3:          TYA                                 ;; 039FC3 : 98          ;
CODE_039FC4:          STA.W RAM_SpriteDir,X               ;; 039FC4 : 9D 7C 15    ;
Return039FC7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FC8:          LDA.W $1540,X                       ;; 039FC8 : BD 40 15    ;
CODE_039FCB:          BEQ CODE_039FD6                     ;; 039FCB : F0 09       ;
CODE_039FCD:          LDA.B #$20                          ;; 039FCD : A9 20       ;
CODE_039FCF:          STA RAM_SpriteSpeedY,X              ;; 039FCF : 95 AA       ;
CODE_039FD1:          JSL.L UpdateYPosNoGrvty             ;; 039FD1 : 22 1A 80 01 ;
Return039FD5:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FD6:          LDA.B #$20                          ;; 039FD6 : A9 20       ;
CODE_039FD8:          STA.W $1540,X                       ;; 039FD8 : 9D 40 15    ;
CODE_039FDB:          LDY.W RAM_SpriteDir,X               ;; 039FDB : BC 7C 15    ;
CODE_039FDE:          LDA.W DATA_039FED,Y                 ;; 039FDE : B9 ED 9F    ;
CODE_039FE1:          STA RAM_SpriteSpeedX,X              ;; 039FE1 : 95 B6       ;
CODE_039FE3:          LDA.B #$E2                          ;; 039FE3 : A9 E2       ;
CODE_039FE5:          STA RAM_SpriteSpeedY,X              ;; 039FE5 : 95 AA       ;
CODE_039FE7:          JSR.W CODE_03A045                   ;; 039FE7 : 20 45 A0    ;
CODE_039FEA:          INC RAM_SpriteState,X               ;; 039FEA : F6 C2       ;
Return039FEC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_039FED:          .db $10,$F0                         ;; 039FED               ;
                                                          ;;                      ;
CODE_039FEF:          STZ.W $1602,X                       ;; 039FEF : 9E 02 16    ;
CODE_039FF2:          LDA.W $1540,X                       ;; 039FF2 : BD 40 15    ;
CODE_039FF5:          BEQ CODE_03A002                     ;; 039FF5 : F0 0B       ;
CODE_039FF7:          DEC A                               ;; 039FF7 : 3A          ;
CODE_039FF8:          BNE CODE_03A038                     ;; 039FF8 : D0 3E       ;
CODE_039FFA:          LDA.B #$25                          ;; 039FFA : A9 25       ; \ Play sound effect 
CODE_039FFC:          STA.W $1DF9                         ;; 039FFC : 8D F9 1D    ; / 
CODE_039FFF:          JSR.W CODE_03A045                   ;; 039FFF : 20 45 A0    ;
CODE_03A002:          JSL.L UpdateXPosNoGrvty             ;; 03A002 : 22 22 80 01 ;
CODE_03A006:          JSL.L UpdateYPosNoGrvty             ;; 03A006 : 22 1A 80 01 ;
CODE_03A00A:          LDA RAM_FrameCounter                ;; 03A00A : A5 13       ;
CODE_03A00C:          AND.B #$00                          ;; 03A00C : 29 00       ;
CODE_03A00E:          BNE CODE_03A012                     ;; 03A00E : D0 02       ;
CODE_03A010:          INC RAM_SpriteSpeedY,X              ;; 03A010 : F6 AA       ;
CODE_03A012:          LDA RAM_SpriteSpeedY,X              ;; 03A012 : B5 AA       ;
CODE_03A014:          CMP.B #$20                          ;; 03A014 : C9 20       ;
CODE_03A016:          BMI CODE_03A038                     ;; 03A016 : 30 20       ;
CODE_03A018:          JSR.W CODE_03A045                   ;; 03A018 : 20 45 A0    ;
CODE_03A01B:          STZ RAM_SpriteState,X               ;; 03A01B : 74 C2       ;
CODE_03A01D:          LDA.W $151C,X                       ;; 03A01D : BD 1C 15    ;
CODE_03A020:          STA.W RAM_SpriteXHi,X               ;; 03A020 : 9D E0 14    ;
CODE_03A023:          LDA.W $1528,X                       ;; 03A023 : BD 28 15    ;
CODE_03A026:          STA RAM_SpriteXLo,X                 ;; 03A026 : 95 E4       ;
CODE_03A028:          LDA.W $1534,X                       ;; 03A028 : BD 34 15    ;
CODE_03A02B:          STA.W RAM_SpriteYHi,X               ;; 03A02B : 9D D4 14    ;
CODE_03A02E:          LDA.W $1594,X                       ;; 03A02E : BD 94 15    ;
CODE_03A031:          STA RAM_SpriteYLo,X                 ;; 03A031 : 95 D8       ;
CODE_03A033:          LDA.B #$40                          ;; 03A033 : A9 40       ;
CODE_03A035:          STA.W $1540,X                       ;; 03A035 : 9D 40 15    ;
CODE_03A038:          LDA RAM_SpriteSpeedY,X              ;; 03A038 : B5 AA       ;
CODE_03A03A:          CLC                                 ;; 03A03A : 18          ;
CODE_03A03B:          ADC.B #$06                          ;; 03A03B : 69 06       ;
CODE_03A03D:          CMP.B #$0C                          ;; 03A03D : C9 0C       ;
CODE_03A03F:          BCS Return03A044                    ;; 03A03F : B0 03       ;
CODE_03A041:          INC.W $1602,X                       ;; 03A041 : FE 02 16    ;
Return03A044:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A045:          LDA RAM_SpriteYLo,X                 ;; 03A045 : B5 D8       ;
CODE_03A047:          PHA                                 ;; 03A047 : 48          ;
CODE_03A048:          SEC                                 ;; 03A048 : 38          ;
CODE_03A049:          SBC.B #$0C                          ;; 03A049 : E9 0C       ;
CODE_03A04B:          STA RAM_SpriteYLo,X                 ;; 03A04B : 95 D8       ;
CODE_03A04D:          LDA.W RAM_SpriteYHi,X               ;; 03A04D : BD D4 14    ;
CODE_03A050:          PHA                                 ;; 03A050 : 48          ;
CODE_03A051:          SBC.B #$00                          ;; 03A051 : E9 00       ;
CODE_03A053:          STA.W RAM_SpriteYHi,X               ;; 03A053 : 9D D4 14    ;
CODE_03A056:          JSL.L CODE_028528                   ;; 03A056 : 22 28 85 02 ;
CODE_03A05A:          PLA                                 ;; 03A05A : 68          ;
CODE_03A05B:          STA.W RAM_SpriteYHi,X               ;; 03A05B : 9D D4 14    ;
CODE_03A05E:          PLA                                 ;; 03A05E : 68          ;
CODE_03A05F:          STA RAM_SpriteYLo,X                 ;; 03A05F : 95 D8       ;
Return03A061:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A062:          JSR.W GetDrawInfoBnk3               ;; 03A062 : 20 60 B7    ;
CODE_03A065:          LDA RAM_SpriteState,X               ;; 03A065 : B5 C2       ;
CODE_03A067:          BEQ CODE_03A038                     ;; 03A067 : F0 CF       ;
CODE_03A069:          CMP.B #$04                          ;; 03A069 : C9 04       ;
CODE_03A06B:          BEQ CODE_03A09D                     ;; 03A06B : F0 30       ;
CODE_03A06D:          JSL.L GenericSprGfxRt2              ;; 03A06D : 22 B2 90 01 ;
CODE_03A071:          LDY.W RAM_SprOAMIndex,X             ;; 03A071 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03A074:          LDA.B #$A0                          ;; 03A074 : A9 A0       ;
CODE_03A076:          STA.W OAM_Tile,Y                    ;; 03A076 : 99 02 03    ;
CODE_03A079:          LDA.W OAM_Prop,Y                    ;; 03A079 : B9 03 03    ;
CODE_03A07C:          AND.B #$CF                          ;; 03A07C : 29 CF       ;
CODE_03A07E:          STA.W OAM_Prop,Y                    ;; 03A07E : 99 03 03    ;
Return03A081:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A082:          .db $F8,$08,$F8,$08,$18,$08,$F8,$08 ;; 03A082               ;
                      .db $F8,$E8                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03A08C:          .db $F8,$F8,$08,$08,$08             ;; 03A08C               ;
                                                          ;;                      ;
BlarggTilemap:        .db $A2,$A4,$C2,$C4,$A6,$A2,$A4,$E6 ;; ?QPWZ?               ;
                      .db $C8,$A6                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03A09B:          .db $45,$05                         ;; 03A09B               ;
                                                          ;;                      ;
CODE_03A09D:          LDA.W $1602,X                       ;; 03A09D : BD 02 16    ;
CODE_03A0A0:          ASL                                 ;; 03A0A0 : 0A          ;
CODE_03A0A1:          ASL                                 ;; 03A0A1 : 0A          ;
CODE_03A0A2:          ADC.W $1602,X                       ;; 03A0A2 : 7D 02 16    ;
CODE_03A0A5:          STA $03                             ;; 03A0A5 : 85 03       ;
CODE_03A0A7:          LDA.W RAM_SpriteDir,X               ;; 03A0A7 : BD 7C 15    ;
CODE_03A0AA:          STA $02                             ;; 03A0AA : 85 02       ;
CODE_03A0AC:          PHX                                 ;; 03A0AC : DA          ;
CODE_03A0AD:          LDX.B #$04                          ;; 03A0AD : A2 04       ;
CODE_03A0AF:          PHX                                 ;; 03A0AF : DA          ;
CODE_03A0B0:          PHX                                 ;; 03A0B0 : DA          ;
CODE_03A0B1:          LDA $01                             ;; 03A0B1 : A5 01       ;
CODE_03A0B3:          CLC                                 ;; 03A0B3 : 18          ;
CODE_03A0B4:          ADC.W DATA_03A08C,X                 ;; 03A0B4 : 7D 8C A0    ;
CODE_03A0B7:          STA.W OAM_DispY,Y                   ;; 03A0B7 : 99 01 03    ;
CODE_03A0BA:          LDA $02                             ;; 03A0BA : A5 02       ;
CODE_03A0BC:          BNE CODE_03A0C3                     ;; 03A0BC : D0 05       ;
CODE_03A0BE:          TXA                                 ;; 03A0BE : 8A          ;
CODE_03A0BF:          CLC                                 ;; 03A0BF : 18          ;
CODE_03A0C0:          ADC.B #$05                          ;; 03A0C0 : 69 05       ;
CODE_03A0C2:          TAX                                 ;; 03A0C2 : AA          ;
CODE_03A0C3:          LDA $00                             ;; 03A0C3 : A5 00       ;
CODE_03A0C5:          CLC                                 ;; 03A0C5 : 18          ;
CODE_03A0C6:          ADC.W DATA_03A082,X                 ;; 03A0C6 : 7D 82 A0    ;
CODE_03A0C9:          STA.W OAM_DispX,Y                   ;; 03A0C9 : 99 00 03    ;
CODE_03A0CC:          PLA                                 ;; 03A0CC : 68          ;
CODE_03A0CD:          CLC                                 ;; 03A0CD : 18          ;
CODE_03A0CE:          ADC $03                             ;; 03A0CE : 65 03       ;
CODE_03A0D0:          TAX                                 ;; 03A0D0 : AA          ;
CODE_03A0D1:          LDA.W BlarggTilemap,X               ;; 03A0D1 : BD 91 A0    ;
CODE_03A0D4:          STA.W OAM_Tile,Y                    ;; 03A0D4 : 99 02 03    ;
CODE_03A0D7:          LDX $02                             ;; 03A0D7 : A6 02       ;
CODE_03A0D9:          LDA.W DATA_03A09B,X                 ;; 03A0D9 : BD 9B A0    ;
CODE_03A0DC:          STA.W OAM_Prop,Y                    ;; 03A0DC : 99 03 03    ;
CODE_03A0DF:          PLX                                 ;; 03A0DF : FA          ;
CODE_03A0E0:          INY                                 ;; 03A0E0 : C8          ;
CODE_03A0E1:          INY                                 ;; 03A0E1 : C8          ;
CODE_03A0E2:          INY                                 ;; 03A0E2 : C8          ;
CODE_03A0E3:          INY                                 ;; 03A0E3 : C8          ;
CODE_03A0E4:          DEX                                 ;; 03A0E4 : CA          ;
CODE_03A0E5:          BPL CODE_03A0AF                     ;; 03A0E5 : 10 C8       ;
CODE_03A0E7:          PLX                                 ;; 03A0E7 : FA          ;
CODE_03A0E8:          LDY.B #$02                          ;; 03A0E8 : A0 02       ;
CODE_03A0EA:          LDA.B #$04                          ;; 03A0EA : A9 04       ;
CODE_03A0EC:          JSL.L FinishOAMWrite                ;; 03A0EC : 22 B3 B7 01 ;
Return03A0F0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A0F1:          JSL.L InitSpriteTables              ;; 03A0F1 : 22 D2 F7 07 ;
CODE_03A0F5:          STZ.W RAM_OffscreenHorz,X           ;; 03A0F5 : 9E A0 15    ;
CODE_03A0F8:          LDA.B #$80                          ;; 03A0F8 : A9 80       ;
CODE_03A0FA:          STA RAM_SpriteYLo,X                 ;; 03A0FA : 95 D8       ;
CODE_03A0FC:          LDA.B #$FF                          ;; 03A0FC : A9 FF       ;
CODE_03A0FE:          STA.W RAM_SpriteYHi,X               ;; 03A0FE : 9D D4 14    ;
CODE_03A101:          LDA.B #$D0                          ;; 03A101 : A9 D0       ;
CODE_03A103:          STA RAM_SpriteXLo,X                 ;; 03A103 : 95 E4       ;
CODE_03A105:          LDA.B #$00                          ;; 03A105 : A9 00       ;
CODE_03A107:          STA.W RAM_SpriteXHi,X               ;; 03A107 : 9D E0 14    ;
CODE_03A10A:          LDA.B #$02                          ;; 03A10A : A9 02       ;
CODE_03A10C:          STA.W $187B,X                       ;; 03A10C : 9D 7B 18    ;
CODE_03A10F:          LDA.B #$03                          ;; 03A10F : A9 03       ;
CODE_03A111:          STA RAM_SpriteState,X               ;; 03A111 : 95 C2       ;
CODE_03A113:          JSL.L CODE_03DD7D                   ;; 03A113 : 22 7D DD 03 ;
Return03A117:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
Bnk3CallSprMain:      PHB                                 ;; ?QPWZ? : 8B          ;
CODE_03A119:          PHK                                 ;; 03A119 : 4B          ;
CODE_03A11A:          PLB                                 ;; 03A11A : AB          ;
CODE_03A11B:          LDA RAM_SpriteNum,X                 ;; 03A11B : B5 9E       ;
CODE_03A11D:          CMP.B #$C8                          ;; 03A11D : C9 C8       ;
CODE_03A11F:          BNE CODE_03A126                     ;; 03A11F : D0 05       ;
CODE_03A121:          JSR.W LightSwitch                   ;; 03A121 : 20 F5 C1    ;
CODE_03A124:          PLB                                 ;; 03A124 : AB          ;
Return03A125:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A126:          CMP.B #$C7                          ;; 03A126 : C9 C7       ;
CODE_03A128:          BNE CODE_03A12F                     ;; 03A128 : D0 05       ;
CODE_03A12A:          JSR.W InvisMushroom                 ;; 03A12A : 20 0F C3    ;
CODE_03A12D:          PLB                                 ;; 03A12D : AB          ;
Return03A12E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A12F:          CMP.B #$51                          ;; 03A12F : C9 51       ;
CODE_03A131:          BNE CODE_03A138                     ;; 03A131 : D0 05       ;
CODE_03A133:          JSR.W Ninji                         ;; 03A133 : 20 4C C3    ;
CODE_03A136:          PLB                                 ;; 03A136 : AB          ;
Return03A137:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A138:          CMP.B #$1B                          ;; 03A138 : C9 1B       ;
CODE_03A13A:          BNE CODE_03A141                     ;; 03A13A : D0 05       ;
CODE_03A13C:          JSR.W Football                      ;; 03A13C : 20 12 80    ;
CODE_03A13F:          PLB                                 ;; 03A13F : AB          ;
Return03A140:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A141:          CMP.B #$C6                          ;; 03A141 : C9 C6       ;
CODE_03A143:          BNE CODE_03A14A                     ;; 03A143 : D0 05       ;
CODE_03A145:          JSR.W DarkRoomWithLight             ;; 03A145 : 20 DC C4    ;
CODE_03A148:          PLB                                 ;; 03A148 : AB          ;
Return03A149:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A14A:          CMP.B #$7A                          ;; 03A14A : C9 7A       ;
CODE_03A14C:          BNE CODE_03A153                     ;; 03A14C : D0 05       ;
CODE_03A14E:          JSR.W Firework                      ;; 03A14E : 20 16 C8    ;
CODE_03A151:          PLB                                 ;; 03A151 : AB          ;
Return03A152:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A153:          CMP.B #$7C                          ;; 03A153 : C9 7C       ;
CODE_03A155:          BNE CODE_03A15C                     ;; 03A155 : D0 05       ;
CODE_03A157:          JSR.W PrincessPeach                 ;; 03A157 : 20 97 AC    ;
CODE_03A15A:          PLB                                 ;; 03A15A : AB          ;
Return03A15B:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A15C:          CMP.B #$C5                          ;; 03A15C : C9 C5       ;
CODE_03A15E:          BNE CODE_03A165                     ;; 03A15E : D0 05       ;
CODE_03A160:          JSR.W BigBooBoss                    ;; 03A160 : 20 87 80    ;
CODE_03A163:          PLB                                 ;; 03A163 : AB          ;
Return03A164:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A165:          CMP.B #$C4                          ;; 03A165 : C9 C4       ;
CODE_03A167:          BNE CODE_03A16E                     ;; 03A167 : D0 05       ;
CODE_03A169:          JSR.W GreyFallingPlat               ;; 03A169 : 20 54 84    ;
CODE_03A16C:          PLB                                 ;; 03A16C : AB          ;
Return03A16D:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A16E:          CMP.B #$C2                          ;; 03A16E : C9 C2       ;
CODE_03A170:          BNE CODE_03A177                     ;; 03A170 : D0 05       ;
CODE_03A172:          JSR.W Blurp                         ;; 03A172 : 20 CA 84    ;
CODE_03A175:          PLB                                 ;; 03A175 : AB          ;
Return03A176:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A177:          CMP.B #$C3                          ;; 03A177 : C9 C3       ;
CODE_03A179:          BNE CODE_03A180                     ;; 03A179 : D0 05       ;
CODE_03A17B:          JSR.W PorcuPuffer                   ;; 03A17B : 20 2F 85    ;
CODE_03A17E:          PLB                                 ;; 03A17E : AB          ;
Return03A17F:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A180:          CMP.B #$C1                          ;; 03A180 : C9 C1       ;
CODE_03A182:          BNE CODE_03A189                     ;; 03A182 : D0 05       ;
CODE_03A184:          JSR.W FlyingTurnBlocks              ;; 03A184 : 20 F6 85    ;
CODE_03A187:          PLB                                 ;; 03A187 : AB          ;
Return03A188:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A189:          CMP.B #$C0                          ;; 03A189 : C9 C0       ;
CODE_03A18B:          BNE CODE_03A192                     ;; 03A18B : D0 05       ;
CODE_03A18D:          JSR.W GrayLavaPlatform              ;; 03A18D : 20 FF 86    ;
CODE_03A190:          PLB                                 ;; 03A190 : AB          ;
Return03A191:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A192:          CMP.B #$BF                          ;; 03A192 : C9 BF       ;
CODE_03A194:          BNE CODE_03A19B                     ;; 03A194 : D0 05       ;
CODE_03A196:          JSR.W MegaMole                      ;; 03A196 : 20 70 87    ;
CODE_03A199:          PLB                                 ;; 03A199 : AB          ;
Return03A19A:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A19B:          CMP.B #$BE                          ;; 03A19B : C9 BE       ;
CODE_03A19D:          BNE CODE_03A1A4                     ;; 03A19D : D0 05       ;
CODE_03A19F:          JSR.W Swooper                       ;; 03A19F : 20 A3 88    ;
CODE_03A1A2:          PLB                                 ;; 03A1A2 : AB          ;
Return03A1A3:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1A4:          CMP.B #$BD                          ;; 03A1A4 : C9 BD       ;
CODE_03A1A6:          BNE CODE_03A1AD                     ;; 03A1A6 : D0 05       ;
CODE_03A1A8:          JSR.W SlidingKoopa                  ;; 03A1A8 : 20 58 89    ;
CODE_03A1AB:          PLB                                 ;; 03A1AB : AB          ;
Return03A1AC:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1AD:          CMP.B #$BC                          ;; 03A1AD : C9 BC       ;
CODE_03A1AF:          BNE CODE_03A1B6                     ;; 03A1AF : D0 05       ;
CODE_03A1B1:          JSR.W BowserStatue                  ;; 03A1B1 : 20 3C 8A    ;
CODE_03A1B4:          PLB                                 ;; 03A1B4 : AB          ;
Return03A1B5:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1B6:          CMP.B #$B8                          ;; 03A1B6 : C9 B8       ;
CODE_03A1B8:          BEQ CODE_03A1BE                     ;; 03A1B8 : F0 04       ;
CODE_03A1BA:          CMP.B #$B7                          ;; 03A1BA : C9 B7       ;
CODE_03A1BC:          BNE CODE_03A1C3                     ;; 03A1BC : D0 05       ;
CODE_03A1BE:          JSR.W CarrotTopLift                 ;; 03A1BE : 20 2F 8C    ;
CODE_03A1C1:          PLB                                 ;; 03A1C1 : AB          ;
Return03A1C2:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1C3:          CMP.B #$B9                          ;; 03A1C3 : C9 B9       ;
CODE_03A1C5:          BNE CODE_03A1CC                     ;; 03A1C5 : D0 05       ;
CODE_03A1C7:          JSR.W InfoBox                       ;; 03A1C7 : 20 6F 8D    ;
CODE_03A1CA:          PLB                                 ;; 03A1CA : AB          ;
Return03A1CB:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1CC:          CMP.B #$BA                          ;; 03A1CC : C9 BA       ;
CODE_03A1CE:          BNE CODE_03A1D5                     ;; 03A1CE : D0 05       ;
CODE_03A1D0:          JSR.W TimedLift                     ;; 03A1D0 : 20 BB 8D    ;
CODE_03A1D3:          PLB                                 ;; 03A1D3 : AB          ;
Return03A1D4:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1D5:          CMP.B #$BB                          ;; 03A1D5 : C9 BB       ;
CODE_03A1D7:          BNE CODE_03A1DE                     ;; 03A1D7 : D0 05       ;
CODE_03A1D9:          JSR.W GreyCastleBlock               ;; 03A1D9 : 20 79 8E    ;
CODE_03A1DC:          PLB                                 ;; 03A1DC : AB          ;
Return03A1DD:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1DE:          CMP.B #$B3                          ;; 03A1DE : C9 B3       ;
CODE_03A1E0:          BNE CODE_03A1E7                     ;; 03A1E0 : D0 05       ;
CODE_03A1E2:          JSR.W StatueFireball                ;; 03A1E2 : 20 EC 8E    ;
CODE_03A1E5:          PLB                                 ;; 03A1E5 : AB          ;
Return03A1E6:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1E7:          LDA RAM_SpriteNum,X                 ;; 03A1E7 : B5 9E       ;
CODE_03A1E9:          CMP.B #$B2                          ;; 03A1E9 : C9 B2       ;
CODE_03A1EB:          BNE CODE_03A1F2                     ;; 03A1EB : D0 05       ;
CODE_03A1ED:          JSR.W FallingSpike                  ;; 03A1ED : 20 14 92    ;
CODE_03A1F0:          PLB                                 ;; 03A1F0 : AB          ;
Return03A1F1:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1F2:          CMP.B #$AE                          ;; 03A1F2 : C9 AE       ;
CODE_03A1F4:          BNE CODE_03A1FB                     ;; 03A1F4 : D0 05       ;
CODE_03A1F6:          JSR.W FishinBoo                     ;; 03A1F6 : 20 65 90    ;
CODE_03A1F9:          PLB                                 ;; 03A1F9 : AB          ;
Return03A1FA:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1FB:          CMP.B #$B6                          ;; 03A1FB : C9 B6       ;
CODE_03A1FD:          BNE CODE_03A204                     ;; 03A1FD : D0 05       ;
CODE_03A1FF:          JSR.W ReflectingFireball            ;; 03A1FF : 20 75 8F    ;
CODE_03A202:          PLB                                 ;; 03A202 : AB          ;
Return03A203:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A204:          CMP.B #$B0                          ;; 03A204 : C9 B0       ;
CODE_03A206:          BNE CODE_03A20D                     ;; 03A206 : D0 05       ;
CODE_03A208:          JSR.W BooStream                     ;; 03A208 : 20 7A 8F    ;
CODE_03A20B:          PLB                                 ;; 03A20B : AB          ;
Return03A20C:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A20D:          CMP.B #$B1                          ;; 03A20D : C9 B1       ;
CODE_03A20F:          BNE CODE_03A216                     ;; 03A20F : D0 05       ;
CODE_03A211:          JSR.W CreateEatBlock                ;; 03A211 : 20 84 92    ;
CODE_03A214:          PLB                                 ;; 03A214 : AB          ;
Return03A215:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A216:          CMP.B #$AC                          ;; 03A216 : C9 AC       ;
CODE_03A218:          BEQ CODE_03A21E                     ;; 03A218 : F0 04       ;
CODE_03A21A:          CMP.B #$AD                          ;; 03A21A : C9 AD       ;
CODE_03A21C:          BNE CODE_03A223                     ;; 03A21C : D0 05       ;
CODE_03A21E:          JSR.W WoodenSpike                   ;; 03A21E : 20 23 94    ;
CODE_03A221:          PLB                                 ;; 03A221 : AB          ;
Return03A222:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A223:          CMP.B #$AB                          ;; 03A223 : C9 AB       ;
CODE_03A225:          BNE CODE_03A22C                     ;; 03A225 : D0 05       ;
CODE_03A227:          JSR.W RexMainRt                     ;; 03A227 : 20 17 95    ;
CODE_03A22A:          PLB                                 ;; 03A22A : AB          ;
Return03A22B:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A22C:          CMP.B #$AA                          ;; 03A22C : C9 AA       ;
CODE_03A22E:          BNE CODE_03A235                     ;; 03A22E : D0 05       ;
CODE_03A230:          JSR.W Fishbone                      ;; 03A230 : 20 F6 96    ;
CODE_03A233:          PLB                                 ;; 03A233 : AB          ;
Return03A234:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A235:          CMP.B #$A9                          ;; 03A235 : C9 A9       ;
CODE_03A237:          BNE CODE_03A23E                     ;; 03A237 : D0 05       ;
CODE_03A239:          JSR.W Reznor                        ;; 03A239 : 20 90 98    ;
CODE_03A23C:          PLB                                 ;; 03A23C : AB          ;
Return03A23D:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A23E:          CMP.B #$A8                          ;; 03A23E : C9 A8       ;
CODE_03A240:          BNE CODE_03A247                     ;; 03A240 : D0 05       ;
CODE_03A242:          JSR.W Blargg                        ;; 03A242 : 20 38 9F    ;
CODE_03A245:          PLB                                 ;; 03A245 : AB          ;
Return03A246:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A247:          CMP.B #$A1                          ;; 03A247 : C9 A1       ;
CODE_03A249:          BNE CODE_03A250                     ;; 03A249 : D0 05       ;
CODE_03A24B:          JSR.W BowserBowlingBall             ;; 03A24B : 20 63 B1    ;
CODE_03A24E:          PLB                                 ;; 03A24E : AB          ;
Return03A24F:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A250:          CMP.B #$A2                          ;; 03A250 : C9 A2       ;
CODE_03A252:          BNE BowserFight                     ;; 03A252 : D0 05       ;
CODE_03A254:          JSR.W MechaKoopa                    ;; 03A254 : 20 A9 B2    ;
CODE_03A257:          PLB                                 ;; 03A257 : AB          ;
Return03A258:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
BowserFight:          JSL.L CODE_03DFCC                   ;; ?QPWZ? : 22 CC DF 03 ;
CODE_03A25D:          JSR.W CODE_03A279                   ;; 03A25D : 20 79 A2    ;
CODE_03A260:          JSR.W CODE_03B43C                   ;; 03A260 : 20 3C B4    ;
CODE_03A263:          PLB                                 ;; 03A263 : AB          ;
Return03A264:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A265:          .db $04,$03,$02,$01,$00,$01,$02,$03 ;; 03A265               ;
                      .db $04,$05,$06,$07,$07,$07,$07,$07 ;; ?QPWZ?               ;
                      .db $07,$07,$07,$07                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A279:          LDA $38                             ;; 03A279 : A5 38       ;
CODE_03A27B:          LSR                                 ;; 03A27B : 4A          ;
CODE_03A27C:          LSR                                 ;; 03A27C : 4A          ;
CODE_03A27D:          LSR                                 ;; 03A27D : 4A          ;
CODE_03A27E:          TAY                                 ;; 03A27E : A8          ;
CODE_03A27F:          LDA.W DATA_03A265,Y                 ;; 03A27F : B9 65 A2    ;
CODE_03A282:          STA.W $1429                         ;; 03A282 : 8D 29 14    ;
CODE_03A285:          LDA.W $1570,X                       ;; 03A285 : BD 70 15    ;
CODE_03A288:          CLC                                 ;; 03A288 : 18          ;
CODE_03A289:          ADC.B #$1E                          ;; 03A289 : 69 1E       ;
CODE_03A28B:          ORA.W RAM_SpriteDir,X               ;; 03A28B : 1D 7C 15    ;
CODE_03A28E:          STA.W $1BA2                         ;; 03A28E : 8D A2 1B    ;
CODE_03A291:          LDA RAM_FrameCounterB               ;; 03A291 : A5 14       ;
CODE_03A293:          LSR                                 ;; 03A293 : 4A          ;
CODE_03A294:          AND.B #$03                          ;; 03A294 : 29 03       ;
CODE_03A296:          STA.W $1428                         ;; 03A296 : 8D 28 14    ;
CODE_03A299:          LDA.B #$90                          ;; 03A299 : A9 90       ;
CODE_03A29B:          STA $2A                             ;; 03A29B : 85 2A       ;
CODE_03A29D:          LDA.B #$C8                          ;; 03A29D : A9 C8       ;
CODE_03A29F:          STA $2C                             ;; 03A29F : 85 2C       ;
CODE_03A2A1:          JSL.L CODE_03DEDF                   ;; 03A2A1 : 22 DF DE 03 ;
CODE_03A2A5:          LDA.W $14B5                         ;; 03A2A5 : AD B5 14    ;
CODE_03A2A8:          BEQ CODE_03A2AD                     ;; 03A2A8 : F0 03       ;
CODE_03A2AA:          JSR.W CODE_03AF59                   ;; 03A2AA : 20 59 AF    ;
CODE_03A2AD:          LDA.W $1564,X                       ;; 03A2AD : BD 64 15    ;
CODE_03A2B0:          BEQ CODE_03A2B5                     ;; 03A2B0 : F0 03       ;
CODE_03A2B2:          JSR.W CODE_03A3E2                   ;; 03A2B2 : 20 E2 A3    ;
CODE_03A2B5:          LDA.W $1594,X                       ;; 03A2B5 : BD 94 15    ;
CODE_03A2B8:          BEQ CODE_03A2CE                     ;; 03A2B8 : F0 14       ;
CODE_03A2BA:          DEC A                               ;; 03A2BA : 3A          ;
CODE_03A2BB:          LSR                                 ;; 03A2BB : 4A          ;
CODE_03A2BC:          LSR                                 ;; 03A2BC : 4A          ;
CODE_03A2BD:          PHA                                 ;; 03A2BD : 48          ;
CODE_03A2BE:          LSR                                 ;; 03A2BE : 4A          ;
CODE_03A2BF:          TAY                                 ;; 03A2BF : A8          ;
CODE_03A2C0:          LDA.W DATA_03A8BE,Y                 ;; 03A2C0 : B9 BE A8    ;
CODE_03A2C3:          STA $02                             ;; 03A2C3 : 85 02       ;
CODE_03A2C5:          PLA                                 ;; 03A2C5 : 68          ;
CODE_03A2C6:          AND.B #$03                          ;; 03A2C6 : 29 03       ;
CODE_03A2C8:          STA $03                             ;; 03A2C8 : 85 03       ;
CODE_03A2CA:          JSR.W CODE_03AA6E                   ;; 03A2CA : 20 6E AA    ;
CODE_03A2CD:          NOP                                 ;; 03A2CD : EA          ;
CODE_03A2CE:          LDA RAM_SpritesLocked               ;; 03A2CE : A5 9D       ;
CODE_03A2D0:          BNE Return03A340                    ;; 03A2D0 : D0 6E       ;
CODE_03A2D2:          STZ.W $1594,X                       ;; 03A2D2 : 9E 94 15    ;
CODE_03A2D5:          LDA.B #$30                          ;; 03A2D5 : A9 30       ;
CODE_03A2D7:          STA $64                             ;; 03A2D7 : 85 64       ;
CODE_03A2D9:          LDA $38                             ;; 03A2D9 : A5 38       ;
CODE_03A2DB:          CMP.B #$20                          ;; 03A2DB : C9 20       ;
CODE_03A2DD:          BCS CODE_03A2E1                     ;; 03A2DD : B0 02       ;
CODE_03A2DF:          STZ $64                             ;; 03A2DF : 64 64       ;
CODE_03A2E1:          JSR.W CODE_03A661                   ;; 03A2E1 : 20 61 A6    ;
CODE_03A2E4:          LDA.W $14B0                         ;; 03A2E4 : AD B0 14    ;
CODE_03A2E7:          BEQ CODE_03A2F2                     ;; 03A2E7 : F0 09       ;
CODE_03A2E9:          LDA RAM_FrameCounter                ;; 03A2E9 : A5 13       ;
CODE_03A2EB:          AND.B #$03                          ;; 03A2EB : 29 03       ;
CODE_03A2ED:          BNE CODE_03A2F2                     ;; 03A2ED : D0 03       ;
CODE_03A2EF:          DEC.W $14B0                         ;; 03A2EF : CE B0 14    ;
CODE_03A2F2:          LDA RAM_FrameCounter                ;; 03A2F2 : A5 13       ;
CODE_03A2F4:          AND.B #$7F                          ;; 03A2F4 : 29 7F       ;
CODE_03A2F6:          BNE CODE_03A305                     ;; 03A2F6 : D0 0D       ;
CODE_03A2F8:          JSL.L GetRand                       ;; 03A2F8 : 22 F9 AC 01 ;
CODE_03A2FC:          AND.B #$01                          ;; 03A2FC : 29 01       ;
CODE_03A2FE:          BNE CODE_03A305                     ;; 03A2FE : D0 05       ;
CODE_03A300:          LDA.B #$0C                          ;; 03A300 : A9 0C       ;
CODE_03A302:          STA.W $1558,X                       ;; 03A302 : 9D 58 15    ;
CODE_03A305:          JSR.W CODE_03B078                   ;; 03A305 : 20 78 B0    ;
CODE_03A308:          LDA.W $151C,X                       ;; 03A308 : BD 1C 15    ;
CODE_03A30B:          CMP.B #$09                          ;; 03A30B : C9 09       ;
CODE_03A30D:          BEQ CODE_03A31A                     ;; 03A30D : F0 0B       ;
CODE_03A30F:          STZ.W $1427                         ;; 03A30F : 9C 27 14    ;
CODE_03A312:          LDA.W $1558,X                       ;; 03A312 : BD 58 15    ;
CODE_03A315:          BEQ CODE_03A31A                     ;; 03A315 : F0 03       ;
CODE_03A317:          INC.W $1427                         ;; 03A317 : EE 27 14    ;
CODE_03A31A:          JSR.W CODE_03A5AD                   ;; 03A31A : 20 AD A5    ;
CODE_03A31D:          JSL.L UpdateXPosNoGrvty             ;; 03A31D : 22 22 80 01 ;
CODE_03A321:          JSL.L UpdateYPosNoGrvty             ;; 03A321 : 22 1A 80 01 ;
CODE_03A325:          LDA.W $151C,X                       ;; 03A325 : BD 1C 15    ;
CODE_03A328:          JSL.L ExecutePtr                    ;; 03A328 : 22 DF 86 00 ;
                                                          ;;                      ;
BowserFightPtrs:      .dw CODE_03A441                     ;; ?QPWZ? : 41 A4       ;
                      .dw CODE_03A6F8                     ;; ?QPWZ? : F8 A6       ;
                      .dw CODE_03A84B                     ;; ?QPWZ? : 4B A8       ;
                      .dw CODE_03A7AD                     ;; ?QPWZ? : AD A7       ;
                      .dw CODE_03AB9F                     ;; ?QPWZ? : 9F AB       ;
                      .dw CODE_03ABBE                     ;; ?QPWZ? : BE AB       ;
                      .dw CODE_03AC03                     ;; ?QPWZ? : 03 AC       ;
                      .dw CODE_03A49C                     ;; ?QPWZ? : 9C A4       ;
                      .dw CODE_03AB21                     ;; ?QPWZ? : 21 AB       ;
                      .dw CODE_03AB64                     ;; ?QPWZ? : 64 AB       ;
                                                          ;;                      ;
Return03A340:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A341:          .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B ;; 03A341               ;
                      .db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B ;; ?QPWZ?               ;
                      .db $D6,$DE,$22,$2A,$D6,$DE,$22,$2A ;; ?QPWZ?               ;
                      .db $D7,$DF,$21,$29,$D7,$DF,$21,$29 ;; ?QPWZ?               ;
                      .db $D8,$E0,$20,$28,$D8,$E0,$20,$28 ;; ?QPWZ?               ;
                      .db $DA,$E2,$1E,$26,$DA,$E2,$1E,$26 ;; ?QPWZ?               ;
                      .db $DC,$E4,$1C,$24,$DC,$E4,$1C,$24 ;; ?QPWZ?               ;
                      .db $E0,$E8,$18,$20,$E0,$E8,$18,$20 ;; ?QPWZ?               ;
                      .db $E8,$F0,$10,$18,$E8,$F0,$10,$18 ;; ?QPWZ?               ;
DATA_03A389:          .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23 ;; 03A389               ;
                      .db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23 ;; ?QPWZ?               ;
                      .db $DE,$D6,$D6,$DE,$22,$2A,$2A,$22 ;; ?QPWZ?               ;
                      .db $DF,$D7,$D7,$DF,$21,$29,$29,$21 ;; ?QPWZ?               ;
                      .db $E0,$D8,$D8,$E0,$20,$28,$28,$20 ;; ?QPWZ?               ;
                      .db $E2,$DA,$DA,$E2,$1E,$26,$26,$1E ;; ?QPWZ?               ;
                      .db $E4,$DC,$DC,$E4,$1C,$24,$24,$1C ;; ?QPWZ?               ;
                      .db $E8,$E0,$E0,$E8,$18,$20,$20,$18 ;; ?QPWZ?               ;
                      .db $F0,$E8,$E8,$F0,$10,$18,$18,$10 ;; ?QPWZ?               ;
DATA_03A3D1:          .db $80,$40,$00,$C0,$00,$C0,$80,$40 ;; 03A3D1               ;
DATA_03A3D9:          .db $E3,$ED,$ED,$EB,$EB,$E9,$E9,$E7 ;; 03A3D9               ;
                      .db $E7                             ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A3E2:          JSR.W GetDrawInfoBnk3               ;; 03A3E2 : 20 60 B7    ;
CODE_03A3E5:          LDA.W $1564,X                       ;; 03A3E5 : BD 64 15    ;
CODE_03A3E8:          DEC A                               ;; 03A3E8 : 3A          ;
CODE_03A3E9:          LSR                                 ;; 03A3E9 : 4A          ;
CODE_03A3EA:          STA $03                             ;; 03A3EA : 85 03       ;
CODE_03A3EC:          ASL                                 ;; 03A3EC : 0A          ;
CODE_03A3ED:          ASL                                 ;; 03A3ED : 0A          ;
CODE_03A3EE:          ASL                                 ;; 03A3EE : 0A          ;
CODE_03A3EF:          STA $02                             ;; 03A3EF : 85 02       ;
CODE_03A3F1:          LDA.B #$70                          ;; 03A3F1 : A9 70       ;
CODE_03A3F3:          STA.W RAM_SprOAMIndex,X             ;; 03A3F3 : 9D EA 15    ;
CODE_03A3F6:          TAY                                 ;; 03A3F6 : A8          ;
CODE_03A3F7:          PHX                                 ;; 03A3F7 : DA          ;
CODE_03A3F8:          LDX.B #$07                          ;; 03A3F8 : A2 07       ;
CODE_03A3FA:          PHX                                 ;; 03A3FA : DA          ;
CODE_03A3FB:          TXA                                 ;; 03A3FB : 8A          ;
CODE_03A3FC:          ORA $02                             ;; 03A3FC : 05 02       ;
CODE_03A3FE:          TAX                                 ;; 03A3FE : AA          ;
CODE_03A3FF:          LDA $00                             ;; 03A3FF : A5 00       ;
CODE_03A401:          CLC                                 ;; 03A401 : 18          ;
CODE_03A402:          ADC.W DATA_03A341,X                 ;; 03A402 : 7D 41 A3    ;
CODE_03A405:          CLC                                 ;; 03A405 : 18          ;
CODE_03A406:          ADC.B #$08                          ;; 03A406 : 69 08       ;
CODE_03A408:          STA.W OAM_DispX,Y                   ;; 03A408 : 99 00 03    ;
CODE_03A40B:          LDA $01                             ;; 03A40B : A5 01       ;
CODE_03A40D:          CLC                                 ;; 03A40D : 18          ;
CODE_03A40E:          ADC.W DATA_03A389,X                 ;; 03A40E : 7D 89 A3    ;
CODE_03A411:          CLC                                 ;; 03A411 : 18          ;
CODE_03A412:          ADC.B #$30                          ;; 03A412 : 69 30       ;
CODE_03A414:          STA.W OAM_DispY,Y                   ;; 03A414 : 99 01 03    ;
CODE_03A417:          LDX $03                             ;; 03A417 : A6 03       ;
CODE_03A419:          LDA.W DATA_03A3D9,X                 ;; 03A419 : BD D9 A3    ;
CODE_03A41C:          STA.W OAM_Tile,Y                    ;; 03A41C : 99 02 03    ;
CODE_03A41F:          PLX                                 ;; 03A41F : FA          ;
CODE_03A420:          LDA.W DATA_03A3D1,X                 ;; 03A420 : BD D1 A3    ;
CODE_03A423:          STA.W OAM_Prop,Y                    ;; 03A423 : 99 03 03    ;
CODE_03A426:          INY                                 ;; 03A426 : C8          ;
CODE_03A427:          INY                                 ;; 03A427 : C8          ;
CODE_03A428:          INY                                 ;; 03A428 : C8          ;
CODE_03A429:          INY                                 ;; 03A429 : C8          ;
CODE_03A42A:          DEX                                 ;; 03A42A : CA          ;
CODE_03A42B:          BPL CODE_03A3FA                     ;; 03A42B : 10 CD       ;
CODE_03A42D:          PLX                                 ;; 03A42D : FA          ;
CODE_03A42E:          LDY.B #$02                          ;; 03A42E : A0 02       ;
CODE_03A430:          LDA.B #$07                          ;; 03A430 : A9 07       ;
CODE_03A432:          JSL.L FinishOAMWrite                ;; 03A432 : 22 B3 B7 01 ;
Return03A436:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A437:          .db $00,$00,$00,$00,$02,$04,$06,$08 ;; 03A437               ;
                      .db $0A,$0E                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A441:          LDA.W RAM_DisableInter,X            ;; 03A441 : BD 4C 15    ;
CODE_03A444:          BNE CODE_03A482                     ;; 03A444 : D0 3C       ;
CODE_03A446:          LDA.W $1540,X                       ;; 03A446 : BD 40 15    ;
CODE_03A449:          BNE CODE_03A465                     ;; 03A449 : D0 1A       ;
CODE_03A44B:          LDA.B #$0E                          ;; 03A44B : A9 0E       ;
CODE_03A44D:          STA.W $1570,X                       ;; 03A44D : 9D 70 15    ;
CODE_03A450:          LDA.B #$04                          ;; 03A450 : A9 04       ;
CODE_03A452:          STA RAM_SpriteSpeedY,X              ;; 03A452 : 95 AA       ;
CODE_03A454:          STZ RAM_SpriteSpeedX,X              ;; 03A454 : 74 B6       ; Sprite X Speed = 0 
CODE_03A456:          LDA RAM_SpriteYLo,X                 ;; 03A456 : B5 D8       ;
CODE_03A458:          SEC                                 ;; 03A458 : 38          ;
CODE_03A459:          SBC RAM_ScreenBndryYLo              ;; 03A459 : E5 1C       ;
CODE_03A45B:          CMP.B #$10                          ;; 03A45B : C9 10       ;
CODE_03A45D:          BNE Return03A464                    ;; 03A45D : D0 05       ;
CODE_03A45F:          LDA.B #$A4                          ;; 03A45F : A9 A4       ;
CODE_03A461:          STA.W $1540,X                       ;; 03A461 : 9D 40 15    ;
Return03A464:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A465:          STZ RAM_SpriteSpeedY,X              ;; 03A465 : 74 AA       ; Sprite Y Speed = 0 
CODE_03A467:          STZ RAM_SpriteSpeedX,X              ;; 03A467 : 74 B6       ; Sprite X Speed = 0 
CODE_03A469:          CMP.B #$01                          ;; 03A469 : C9 01       ;
CODE_03A46B:          BEQ CODE_03A47C                     ;; 03A46B : F0 0F       ;
CODE_03A46D:          CMP.B #$40                          ;; 03A46D : C9 40       ;
CODE_03A46F:          BCS Return03A47B                    ;; 03A46F : B0 0A       ;
CODE_03A471:          LSR                                 ;; 03A471 : 4A          ;
CODE_03A472:          LSR                                 ;; 03A472 : 4A          ;
CODE_03A473:          LSR                                 ;; 03A473 : 4A          ;
CODE_03A474:          TAY                                 ;; 03A474 : A8          ;
CODE_03A475:          LDA.W DATA_03A437,Y                 ;; 03A475 : B9 37 A4    ;
CODE_03A478:          STA.W $1570,X                       ;; 03A478 : 9D 70 15    ;
Return03A47B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A47C:          LDA.B #$24                          ;; 03A47C : A9 24       ;
CODE_03A47E:          STA.W RAM_DisableInter,X            ;; 03A47E : 9D 4C 15    ;
Return03A481:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A482:          DEC A                               ;; 03A482 : 3A          ;
CODE_03A483:          BNE Return03A48F                    ;; 03A483 : D0 0A       ;
CODE_03A485:          LDA.B #$07                          ;; 03A485 : A9 07       ;
CODE_03A487:          STA.W $151C,X                       ;; 03A487 : 9D 1C 15    ;
CODE_03A48A:          LDA.B #$78                          ;; 03A48A : A9 78       ;
CODE_03A48C:          STA.W $14B0                         ;; 03A48C : 8D B0 14    ;
Return03A48F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A490:          .db $FF,$01                         ;; 03A490               ;
                                                          ;;                      ;
DATA_03A492:          .db $C8,$38                         ;; 03A492               ;
                                                          ;;                      ;
DATA_03A494:          .db $01,$FF                         ;; 03A494               ;
                                                          ;;                      ;
DATA_03A496:          .db $1C,$E4                         ;; 03A496               ;
                                                          ;;                      ;
DATA_03A498:          .db $00,$02,$04,$02                 ;; 03A498               ;
                                                          ;;                      ;
CODE_03A49C:          JSR.W CODE_03A4D2                   ;; 03A49C : 20 D2 A4    ;
CODE_03A49F:          JSR.W CODE_03A4FD                   ;; 03A49F : 20 FD A4    ;
CODE_03A4A2:          JSR.W CODE_03A4ED                   ;; 03A4A2 : 20 ED A4    ;
CODE_03A4A5:          LDA.W $1528,X                       ;; 03A4A5 : BD 28 15    ;
CODE_03A4A8:          AND.B #$01                          ;; 03A4A8 : 29 01       ;
CODE_03A4AA:          TAY                                 ;; 03A4AA : A8          ;
CODE_03A4AB:          LDA RAM_SpriteSpeedX,X              ;; 03A4AB : B5 B6       ;
CODE_03A4AD:          CLC                                 ;; 03A4AD : 18          ;
CODE_03A4AE:          ADC.W DATA_03A490,Y                 ;; 03A4AE : 79 90 A4    ;
CODE_03A4B1:          STA RAM_SpriteSpeedX,X              ;; 03A4B1 : 95 B6       ;
CODE_03A4B3:          CMP.W DATA_03A492,Y                 ;; 03A4B3 : D9 92 A4    ;
CODE_03A4B6:          BNE CODE_03A4BB                     ;; 03A4B6 : D0 03       ;
CODE_03A4B8:          INC.W $1528,X                       ;; 03A4B8 : FE 28 15    ;
CODE_03A4BB:          LDA.W $1534,X                       ;; 03A4BB : BD 34 15    ;
CODE_03A4BE:          AND.B #$01                          ;; 03A4BE : 29 01       ;
CODE_03A4C0:          TAY                                 ;; 03A4C0 : A8          ;
CODE_03A4C1:          LDA RAM_SpriteSpeedY,X              ;; 03A4C1 : B5 AA       ;
CODE_03A4C3:          CLC                                 ;; 03A4C3 : 18          ;
CODE_03A4C4:          ADC.W DATA_03A494,Y                 ;; 03A4C4 : 79 94 A4    ;
CODE_03A4C7:          STA RAM_SpriteSpeedY,X              ;; 03A4C7 : 95 AA       ;
CODE_03A4C9:          CMP.W DATA_03A496,Y                 ;; 03A4C9 : D9 96 A4    ;
CODE_03A4CC:          BNE Return03A4D1                    ;; 03A4CC : D0 03       ;
CODE_03A4CE:          INC.W $1534,X                       ;; 03A4CE : FE 34 15    ;
Return03A4D1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A4D2:          LDY.B #$00                          ;; 03A4D2 : A0 00       ;
CODE_03A4D4:          LDA RAM_FrameCounter                ;; 03A4D4 : A5 13       ;
CODE_03A4D6:          AND.B #$E0                          ;; 03A4D6 : 29 E0       ;
CODE_03A4D8:          BNE CODE_03A4E6                     ;; 03A4D8 : D0 0C       ;
CODE_03A4DA:          LDA RAM_FrameCounter                ;; 03A4DA : A5 13       ;
CODE_03A4DC:          AND.B #$18                          ;; 03A4DC : 29 18       ;
CODE_03A4DE:          LSR                                 ;; 03A4DE : 4A          ;
CODE_03A4DF:          LSR                                 ;; 03A4DF : 4A          ;
CODE_03A4E0:          LSR                                 ;; 03A4E0 : 4A          ;
CODE_03A4E1:          TAY                                 ;; 03A4E1 : A8          ;
CODE_03A4E2:          LDA.W DATA_03A498,Y                 ;; 03A4E2 : B9 98 A4    ;
CODE_03A4E5:          TAY                                 ;; 03A4E5 : A8          ;
CODE_03A4E6:          TYA                                 ;; 03A4E6 : 98          ;
CODE_03A4E7:          STA.W $1570,X                       ;; 03A4E7 : 9D 70 15    ;
Return03A4EA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A4EB:          .db $80,$00                         ;; 03A4EB               ;
                                                          ;;                      ;
CODE_03A4ED:          LDA RAM_FrameCounter                ;; 03A4ED : A5 13       ;
CODE_03A4EF:          AND.B #$1F                          ;; 03A4EF : 29 1F       ;
CODE_03A4F1:          BNE Return03A4FC                    ;; 03A4F1 : D0 09       ;
CODE_03A4F3:          JSR.W SubHorzPosBnk3                ;; 03A4F3 : 20 17 B8    ;
CODE_03A4F6:          LDA.W DATA_03A4EB,Y                 ;; 03A4F6 : B9 EB A4    ;
CODE_03A4F9:          STA.W RAM_SpriteDir,X               ;; 03A4F9 : 9D 7C 15    ;
Return03A4FC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A4FD:          LDA.W $14B0                         ;; 03A4FD : AD B0 14    ;
CODE_03A500:          BNE Return03A52C                    ;; 03A500 : D0 2A       ;
CODE_03A502:          LDA.W $151C,X                       ;; 03A502 : BD 1C 15    ;
CODE_03A505:          CMP.B #$08                          ;; 03A505 : C9 08       ;
CODE_03A507:          BNE CODE_03A51A                     ;; 03A507 : D0 11       ;
CODE_03A509:          INC.W $14B8                         ;; 03A509 : EE B8 14    ;
CODE_03A50C:          LDA.W $14B8                         ;; 03A50C : AD B8 14    ;
CODE_03A50F:          CMP.B #$03                          ;; 03A50F : C9 03       ;
CODE_03A511:          BEQ CODE_03A51A                     ;; 03A511 : F0 07       ;
CODE_03A513:          LDA.B #$FF                          ;; 03A513 : A9 FF       ;
CODE_03A515:          STA.W $14B6                         ;; 03A515 : 8D B6 14    ;
CODE_03A518:          BRA Return03A52C                    ;; 03A518 : 80 12       ;
                                                          ;;                      ;
CODE_03A51A:          STZ.W $14B8                         ;; 03A51A : 9C B8 14    ;
CODE_03A51D:          LDA.W $14C8                         ;; 03A51D : AD C8 14    ;
CODE_03A520:          BEQ CODE_03A527                     ;; 03A520 : F0 05       ;
CODE_03A522:          LDA.W $14C9                         ;; 03A522 : AD C9 14    ;
CODE_03A525:          BNE Return03A52C                    ;; 03A525 : D0 05       ;
CODE_03A527:          LDA.B #$FF                          ;; 03A527 : A9 FF       ;
CODE_03A529:          STA.W $14B1                         ;; 03A529 : 8D B1 14    ;
Return03A52C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A52D:          .db $00,$00,$00,$00,$00,$00,$00,$00 ;; 03A52D               ;
                      .db $00,$02,$04,$06,$08,$0A,$0E,$0E ;; ?QPWZ?               ;
                      .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ;; ?QPWZ?               ;
                      .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ;; ?QPWZ?               ;
                      .db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ;; ?QPWZ?               ;
                      .db $0E,$0E,$0A,$08,$06,$04,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
DATA_03A56D:          .db $00,$00,$00,$00,$00,$00,$00,$00 ;; 03A56D               ;
                      .db $00,$00,$10,$20,$30,$40,$50,$60 ;; ?QPWZ?               ;
                      .db $80,$A0,$C0,$E0,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$C0,$80,$60 ;; ?QPWZ?               ;
                      .db $40,$30,$20,$10,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A5AD:          LDA.W $14B1                         ;; 03A5AD : AD B1 14    ;
CODE_03A5B0:          BEQ CODE_03A5D8                     ;; 03A5B0 : F0 26       ;
CODE_03A5B2:          DEC.W $14B1                         ;; 03A5B2 : CE B1 14    ;
CODE_03A5B5:          BNE CODE_03A5BD                     ;; 03A5B5 : D0 06       ;
CODE_03A5B7:          LDA.B #$54                          ;; 03A5B7 : A9 54       ;
CODE_03A5B9:          STA.W $14B0                         ;; 03A5B9 : 8D B0 14    ;
Return03A5BC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A5BD:          LSR                                 ;; 03A5BD : 4A          ;
CODE_03A5BE:          LSR                                 ;; 03A5BE : 4A          ;
CODE_03A5BF:          TAY                                 ;; 03A5BF : A8          ;
CODE_03A5C0:          LDA.W DATA_03A52D,Y                 ;; 03A5C0 : B9 2D A5    ;
CODE_03A5C3:          STA.W $1570,X                       ;; 03A5C3 : 9D 70 15    ;
CODE_03A5C6:          LDA.W $14B1                         ;; 03A5C6 : AD B1 14    ;
CODE_03A5C9:          CMP.B #$80                          ;; 03A5C9 : C9 80       ;
CODE_03A5CB:          BNE CODE_03A5D5                     ;; 03A5CB : D0 08       ;
CODE_03A5CD:          JSR.W CODE_03B019                   ;; 03A5CD : 20 19 B0    ;
CODE_03A5D0:          LDA.B #$08                          ;; 03A5D0 : A9 08       ; \ Play sound effect 
CODE_03A5D2:          STA.W $1DFC                         ;; 03A5D2 : 8D FC 1D    ; / 
CODE_03A5D5:          PLA                                 ;; 03A5D5 : 68          ;
CODE_03A5D6:          PLA                                 ;; 03A5D6 : 68          ;
Return03A5D7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A5D8:          LDA.W $14B6                         ;; 03A5D8 : AD B6 14    ;
CODE_03A5DB:          BEQ Return03A60D                    ;; 03A5DB : F0 30       ;
CODE_03A5DD:          DEC.W $14B6                         ;; 03A5DD : CE B6 14    ;
CODE_03A5E0:          BEQ CODE_03A60E                     ;; 03A5E0 : F0 2C       ;
CODE_03A5E2:          LSR                                 ;; 03A5E2 : 4A          ;
CODE_03A5E3:          LSR                                 ;; 03A5E3 : 4A          ;
CODE_03A5E4:          TAY                                 ;; 03A5E4 : A8          ;
CODE_03A5E5:          LDA.W DATA_03A52D,Y                 ;; 03A5E5 : B9 2D A5    ;
CODE_03A5E8:          STA.W $1570,X                       ;; 03A5E8 : 9D 70 15    ;
CODE_03A5EB:          LDA.W DATA_03A56D,Y                 ;; 03A5EB : B9 6D A5    ;
CODE_03A5EE:          STA $36                             ;; 03A5EE : 85 36       ;
CODE_03A5F0:          STZ $37                             ;; 03A5F0 : 64 37       ;
CODE_03A5F2:          CMP.B #$FF                          ;; 03A5F2 : C9 FF       ;
CODE_03A5F4:          BNE CODE_03A5FC                     ;; 03A5F4 : D0 06       ;
CODE_03A5F6:          STZ $36                             ;; 03A5F6 : 64 36       ;
CODE_03A5F8:          INC $37                             ;; 03A5F8 : E6 37       ;
CODE_03A5FA:          STZ $64                             ;; 03A5FA : 64 64       ;
CODE_03A5FC:          LDA.W $14B6                         ;; 03A5FC : AD B6 14    ;
CODE_03A5FF:          CMP.B #$80                          ;; 03A5FF : C9 80       ;
CODE_03A601:          BNE CODE_03A60B                     ;; 03A601 : D0 08       ;
CODE_03A603:          LDA.B #$09                          ;; 03A603 : A9 09       ; \ Play sound effect 
CODE_03A605:          STA.W $1DFC                         ;; 03A605 : 8D FC 1D    ; / 
CODE_03A608:          JSR.W CODE_03A61D                   ;; 03A608 : 20 1D A6    ;
CODE_03A60B:          PLA                                 ;; 03A60B : 68          ;
CODE_03A60C:          PLA                                 ;; 03A60C : 68          ;
Return03A60D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A60E:          LDA.B #$60                          ;; 03A60E : A9 60       ;
CODE_03A610:          LDY.W $14B8                         ;; 03A610 : AC B8 14    ;
CODE_03A613:          CPY.B #$02                          ;; 03A613 : C0 02       ;
CODE_03A615:          BEQ CODE_03A619                     ;; 03A615 : F0 02       ;
CODE_03A617:          LDA.B #$20                          ;; 03A617 : A9 20       ;
CODE_03A619:          STA.W $14B0                         ;; 03A619 : 8D B0 14    ;
Return03A61C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A61D:          LDA.B #$08                          ;; 03A61D : A9 08       ;
CODE_03A61F:          STA.W $14D0                         ;; 03A61F : 8D D0 14    ;
CODE_03A622:          LDA.B #$A1                          ;; 03A622 : A9 A1       ;
CODE_03A624:          STA $A6                             ;; 03A624 : 85 A6       ;
CODE_03A626:          LDA RAM_SpriteXLo,X                 ;; 03A626 : B5 E4       ;
CODE_03A628:          CLC                                 ;; 03A628 : 18          ;
CODE_03A629:          ADC.B #$08                          ;; 03A629 : 69 08       ;
CODE_03A62B:          STA $EC                             ;; 03A62B : 85 EC       ;
CODE_03A62D:          LDA.W RAM_SpriteXHi,X               ;; 03A62D : BD E0 14    ;
CODE_03A630:          ADC.B #$00                          ;; 03A630 : 69 00       ;
CODE_03A632:          STA.W $14E8                         ;; 03A632 : 8D E8 14    ;
CODE_03A635:          LDA RAM_SpriteYLo,X                 ;; 03A635 : B5 D8       ;
CODE_03A637:          CLC                                 ;; 03A637 : 18          ;
CODE_03A638:          ADC.B #$40                          ;; 03A638 : 69 40       ;
CODE_03A63A:          STA $E0                             ;; 03A63A : 85 E0       ;
CODE_03A63C:          LDA.W RAM_SpriteYHi,X               ;; 03A63C : BD D4 14    ;
CODE_03A63F:          ADC.B #$00                          ;; 03A63F : 69 00       ;
CODE_03A641:          STA.W $14DC                         ;; 03A641 : 8D DC 14    ;
CODE_03A644:          PHX                                 ;; 03A644 : DA          ;
CODE_03A645:          LDX.B #$08                          ;; 03A645 : A2 08       ;
CODE_03A647:          JSL.L InitSpriteTables              ;; 03A647 : 22 D2 F7 07 ;
CODE_03A64B:          PLX                                 ;; 03A64B : FA          ;
Return03A64C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A64D:          .db $00,$00,$00,$00,$FC,$F8,$F4,$F0 ;; 03A64D               ;
                      .db $F4,$F8,$FC,$00,$04,$08,$0C,$10 ;; ?QPWZ?               ;
                      .db $0C,$08,$04,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A661:          LDA.W $14B5                         ;; 03A661 : AD B5 14    ;
CODE_03A664:          BEQ Return03A6BF                    ;; 03A664 : F0 59       ;
CODE_03A666:          STZ.W $14B1                         ;; 03A666 : 9C B1 14    ;
CODE_03A669:          STZ.W $14B6                         ;; 03A669 : 9C B6 14    ;
CODE_03A66C:          DEC.W $14B5                         ;; 03A66C : CE B5 14    ;
CODE_03A66F:          BNE CODE_03A691                     ;; 03A66F : D0 20       ;
CODE_03A671:          LDA.B #$50                          ;; 03A671 : A9 50       ;
CODE_03A673:          STA.W $14B0                         ;; 03A673 : 8D B0 14    ;
CODE_03A676:          DEC.W $187B,X                       ;; 03A676 : DE 7B 18    ;
CODE_03A679:          BNE CODE_03A691                     ;; 03A679 : D0 16       ;
CODE_03A67B:          LDA.W $151C,X                       ;; 03A67B : BD 1C 15    ;
CODE_03A67E:          CMP.B #$09                          ;; 03A67E : C9 09       ;
CODE_03A680:          BEQ CODE_03A6C0                     ;; 03A680 : F0 3E       ;
CODE_03A682:          LDA.B #$02                          ;; 03A682 : A9 02       ;
CODE_03A684:          STA.W $187B,X                       ;; 03A684 : 9D 7B 18    ;
CODE_03A687:          LDA.B #$01                          ;; 03A687 : A9 01       ;
CODE_03A689:          STA.W $151C,X                       ;; 03A689 : 9D 1C 15    ;
CODE_03A68C:          LDA.B #$80                          ;; 03A68C : A9 80       ;
CODE_03A68E:          STA.W $1540,X                       ;; 03A68E : 9D 40 15    ;
CODE_03A691:          PLY                                 ;; 03A691 : 7A          ;
CODE_03A692:          PLY                                 ;; 03A692 : 7A          ;
CODE_03A693:          PHA                                 ;; 03A693 : 48          ;
CODE_03A694:          LDA.W $14B5                         ;; 03A694 : AD B5 14    ;
CODE_03A697:          LSR                                 ;; 03A697 : 4A          ;
CODE_03A698:          LSR                                 ;; 03A698 : 4A          ;
CODE_03A699:          TAY                                 ;; 03A699 : A8          ;
CODE_03A69A:          LDA.W DATA_03A64D,Y                 ;; 03A69A : B9 4D A6    ;
CODE_03A69D:          STA $36                             ;; 03A69D : 85 36       ;
CODE_03A69F:          STZ $37                             ;; 03A69F : 64 37       ;
CODE_03A6A1:          BPL CODE_03A6A5                     ;; 03A6A1 : 10 02       ;
CODE_03A6A3:          INC $37                             ;; 03A6A3 : E6 37       ;
CODE_03A6A5:          PLA                                 ;; 03A6A5 : 68          ;
CODE_03A6A6:          LDY.B #$0C                          ;; 03A6A6 : A0 0C       ;
CODE_03A6A8:          CMP.B #$40                          ;; 03A6A8 : C9 40       ;
CODE_03A6AA:          BCS CODE_03A6B6                     ;; 03A6AA : B0 0A       ;
CODE_03A6AC:          LDA RAM_FrameCounter                ;; 03A6AC : A5 13       ;
CODE_03A6AE:          LDY.B #$10                          ;; 03A6AE : A0 10       ;
CODE_03A6B0:          AND.B #$04                          ;; 03A6B0 : 29 04       ;
CODE_03A6B2:          BEQ CODE_03A6B6                     ;; 03A6B2 : F0 02       ;
CODE_03A6B4:          LDY.B #$12                          ;; 03A6B4 : A0 12       ;
CODE_03A6B6:          TYA                                 ;; 03A6B6 : 98          ;
CODE_03A6B7:          STA.W $1570,X                       ;; 03A6B7 : 9D 70 15    ;
CODE_03A6BA:          LDA.B #$02                          ;; 03A6BA : A9 02       ;
CODE_03A6BC:          STA.W $1427                         ;; 03A6BC : 8D 27 14    ;
Return03A6BF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A6C0:          LDA.B #$04                          ;; 03A6C0 : A9 04       ;
CODE_03A6C2:          STA.W $151C,X                       ;; 03A6C2 : 9D 1C 15    ;
CODE_03A6C5:          STZ RAM_SpriteSpeedX,X              ;; 03A6C5 : 74 B6       ; Sprite X Speed = 0 
Return03A6C7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
KillMostSprites:      LDY.B #$09                          ;; ?QPWZ? : A0 09       ;
CODE_03A6CA:          LDA.W $14C8,Y                       ;; 03A6CA : B9 C8 14    ;
CODE_03A6CD:          BEQ CODE_03A6EC                     ;; 03A6CD : F0 1D       ;
CODE_03A6CF:          LDA.W RAM_SpriteNum,Y               ;; 03A6CF : B9 9E 00    ;
CODE_03A6D2:          CMP.B #$A9                          ;; 03A6D2 : C9 A9       ;
CODE_03A6D4:          BEQ CODE_03A6EC                     ;; 03A6D4 : F0 16       ;
CODE_03A6D6:          CMP.B #$29                          ;; 03A6D6 : C9 29       ;
CODE_03A6D8:          BEQ CODE_03A6EC                     ;; 03A6D8 : F0 12       ;
CODE_03A6DA:          CMP.B #$A0                          ;; 03A6DA : C9 A0       ;
CODE_03A6DC:          BEQ CODE_03A6EC                     ;; 03A6DC : F0 0E       ;
CODE_03A6DE:          CMP.B #$C5                          ;; 03A6DE : C9 C5       ;
CODE_03A6E0:          BEQ CODE_03A6EC                     ;; 03A6E0 : F0 0A       ;
CODE_03A6E2:          LDA.B #$04                          ;; 03A6E2 : A9 04       ; \ Sprite status = Killed by spin jump 
CODE_03A6E4:          STA.W $14C8,Y                       ;; 03A6E4 : 99 C8 14    ; / 
CODE_03A6E7:          LDA.B #$1F                          ;; 03A6E7 : A9 1F       ; \ Time to show cloud of smoke = #$1F 
CODE_03A6E9:          STA.W $1540,Y                       ;; 03A6E9 : 99 40 15    ; / 
CODE_03A6EC:          DEY                                 ;; 03A6EC : 88          ;
CODE_03A6ED:          BPL CODE_03A6CA                     ;; 03A6ED : 10 DB       ;
Return03A6EF:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A6F0:          .db $0E,$0E,$0A,$08,$06,$04,$02,$00 ;; 03A6F0               ;
                                                          ;;                      ;
CODE_03A6F8:          LDA.W $1540,X                       ;; 03A6F8 : BD 40 15    ;
CODE_03A6FB:          BEQ CODE_03A731                     ;; 03A6FB : F0 34       ;
CODE_03A6FD:          CMP.B #$01                          ;; 03A6FD : C9 01       ;
CODE_03A6FF:          BNE CODE_03A706                     ;; 03A6FF : D0 05       ;
CODE_03A701:          LDY.B #$17                          ;; 03A701 : A0 17       ;
CODE_03A703:          STY.W $1DFB                         ;; 03A703 : 8C FB 1D    ; / Change music 
CODE_03A706:          LSR                                 ;; 03A706 : 4A          ;
CODE_03A707:          LSR                                 ;; 03A707 : 4A          ;
CODE_03A708:          LSR                                 ;; 03A708 : 4A          ;
CODE_03A709:          LSR                                 ;; 03A709 : 4A          ;
CODE_03A70A:          TAY                                 ;; 03A70A : A8          ;
CODE_03A70B:          LDA.W DATA_03A6F0,Y                 ;; 03A70B : B9 F0 A6    ;
CODE_03A70E:          STA.W $1570,X                       ;; 03A70E : 9D 70 15    ;
CODE_03A711:          STZ RAM_SpriteSpeedX,X              ;; 03A711 : 74 B6       ; Sprite X Speed = 0 
CODE_03A713:          STZ RAM_SpriteSpeedY,X              ;; 03A713 : 74 AA       ; Sprite Y Speed = 0 
CODE_03A715:          STZ.W $1528,X                       ;; 03A715 : 9E 28 15    ;
CODE_03A718:          STZ.W $1534,X                       ;; 03A718 : 9E 34 15    ;
CODE_03A71B:          STZ.W $14B2                         ;; 03A71B : 9C B2 14    ;
Return03A71E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A71F:          .db $01,$FF                         ;; 03A71F               ;
                                                          ;;                      ;
DATA_03A721:          .db $10,$80                         ;; 03A721               ;
                                                          ;;                      ;
DATA_03A723:          .db $07,$03                         ;; 03A723               ;
                                                          ;;                      ;
DATA_03A725:          .db $FF,$01                         ;; 03A725               ;
                                                          ;;                      ;
DATA_03A727:          .db $F0,$08                         ;; 03A727               ;
                                                          ;;                      ;
DATA_03A729:          .db $01,$FF                         ;; 03A729               ;
                                                          ;;                      ;
DATA_03A72B:          .db $03,$03                         ;; 03A72B               ;
                                                          ;;                      ;
DATA_03A72D:          .db $60,$02                         ;; 03A72D               ;
                                                          ;;                      ;
DATA_03A72F:          .db $01,$01                         ;; 03A72F               ;
                                                          ;;                      ;
CODE_03A731:          LDY.W $1528,X                       ;; 03A731 : BC 28 15    ;
CODE_03A734:          CPY.B #$02                          ;; 03A734 : C0 02       ;
CODE_03A736:          BCS CODE_03A74F                     ;; 03A736 : B0 17       ;
CODE_03A738:          LDA RAM_FrameCounter                ;; 03A738 : A5 13       ;
CODE_03A73A:          AND.W DATA_03A723,Y                 ;; 03A73A : 39 23 A7    ;
CODE_03A73D:          BNE CODE_03A74F                     ;; 03A73D : D0 10       ;
CODE_03A73F:          LDA RAM_SpriteSpeedX,X              ;; 03A73F : B5 B6       ;
CODE_03A741:          CLC                                 ;; 03A741 : 18          ;
CODE_03A742:          ADC.W DATA_03A71F,Y                 ;; 03A742 : 79 1F A7    ;
CODE_03A745:          STA RAM_SpriteSpeedX,X              ;; 03A745 : 95 B6       ;
CODE_03A747:          CMP.W DATA_03A721,Y                 ;; 03A747 : D9 21 A7    ;
CODE_03A74A:          BNE CODE_03A74F                     ;; 03A74A : D0 03       ;
CODE_03A74C:          INC.W $1528,X                       ;; 03A74C : FE 28 15    ;
CODE_03A74F:          LDY.W $1534,X                       ;; 03A74F : BC 34 15    ;
CODE_03A752:          CPY.B #$02                          ;; 03A752 : C0 02       ;
CODE_03A754:          BCS CODE_03A76D                     ;; 03A754 : B0 17       ;
CODE_03A756:          LDA RAM_FrameCounter                ;; 03A756 : A5 13       ;
CODE_03A758:          AND.W DATA_03A72B,Y                 ;; 03A758 : 39 2B A7    ;
CODE_03A75B:          BNE CODE_03A76D                     ;; 03A75B : D0 10       ;
CODE_03A75D:          LDA RAM_SpriteSpeedY,X              ;; 03A75D : B5 AA       ;
CODE_03A75F:          CLC                                 ;; 03A75F : 18          ;
CODE_03A760:          ADC.W DATA_03A725,Y                 ;; 03A760 : 79 25 A7    ;
CODE_03A763:          STA RAM_SpriteSpeedY,X              ;; 03A763 : 95 AA       ;
CODE_03A765:          CMP.W DATA_03A727,Y                 ;; 03A765 : D9 27 A7    ;
CODE_03A768:          BNE CODE_03A76D                     ;; 03A768 : D0 03       ;
CODE_03A76A:          INC.W $1534,X                       ;; 03A76A : FE 34 15    ;
CODE_03A76D:          LDY.W $14B2                         ;; 03A76D : AC B2 14    ;
CODE_03A770:          CPY.B #$02                          ;; 03A770 : C0 02       ;
CODE_03A772:          BEQ CODE_03A794                     ;; 03A772 : F0 20       ;
CODE_03A774:          LDA RAM_FrameCounter                ;; 03A774 : A5 13       ;
CODE_03A776:          AND.W DATA_03A72F,Y                 ;; 03A776 : 39 2F A7    ;
CODE_03A779:          BNE CODE_03A78D                     ;; 03A779 : D0 12       ;
CODE_03A77B:          LDA $38                             ;; 03A77B : A5 38       ;
CODE_03A77D:          CLC                                 ;; 03A77D : 18          ;
CODE_03A77E:          ADC.W DATA_03A729,Y                 ;; 03A77E : 79 29 A7    ;
CODE_03A781:          STA $38                             ;; 03A781 : 85 38       ;
CODE_03A783:          STA $39                             ;; 03A783 : 85 39       ;
CODE_03A785:          CMP.W DATA_03A72D,Y                 ;; 03A785 : D9 2D A7    ;
CODE_03A788:          BNE CODE_03A78D                     ;; 03A788 : D0 03       ;
CODE_03A78A:          INC.W $14B2                         ;; 03A78A : EE B2 14    ;
CODE_03A78D:          LDA.W RAM_SpriteXHi,X               ;; 03A78D : BD E0 14    ;
CODE_03A790:          CMP.B #$FE                          ;; 03A790 : C9 FE       ;
CODE_03A792:          BNE Return03A7AC                    ;; 03A792 : D0 18       ;
CODE_03A794:          LDA.B #$03                          ;; 03A794 : A9 03       ;
CODE_03A796:          STA.W $151C,X                       ;; 03A796 : 9D 1C 15    ;
CODE_03A799:          LDA.B #$80                          ;; 03A799 : A9 80       ;
CODE_03A79B:          STA.W $14B0                         ;; 03A79B : 8D B0 14    ;
CODE_03A79E:          JSL.L GetRand                       ;; 03A79E : 22 F9 AC 01 ;
CODE_03A7A2:          AND.B #$F0                          ;; 03A7A2 : 29 F0       ;
CODE_03A7A4:          STA.W $14B7                         ;; 03A7A4 : 8D B7 14    ;
CODE_03A7A7:          LDA.B #$1D                          ;; 03A7A7 : A9 1D       ;
CODE_03A7A9:          STA.W $1DFB                         ;; 03A7A9 : 8D FB 1D    ; / Change music 
Return03A7AC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7AD:          LDA.B #$60                          ;; 03A7AD : A9 60       ;
CODE_03A7AF:          STA $38                             ;; 03A7AF : 85 38       ;
CODE_03A7B1:          STA $39                             ;; 03A7B1 : 85 39       ;
CODE_03A7B3:          LDA.B #$FF                          ;; 03A7B3 : A9 FF       ;
CODE_03A7B5:          STA.W RAM_SpriteXHi,X               ;; 03A7B5 : 9D E0 14    ;
CODE_03A7B8:          LDA.B #$60                          ;; 03A7B8 : A9 60       ;
CODE_03A7BA:          STA RAM_SpriteXLo,X                 ;; 03A7BA : 95 E4       ;
CODE_03A7BC:          LDA.W $14B0                         ;; 03A7BC : AD B0 14    ;
CODE_03A7BF:          BNE CODE_03A7DF                     ;; 03A7BF : D0 1E       ;
CODE_03A7C1:          LDA.B #$18                          ;; 03A7C1 : A9 18       ;
CODE_03A7C3:          STA.W $1DFB                         ;; 03A7C3 : 8D FB 1D    ; / Change music 
CODE_03A7C6:          LDA.B #$02                          ;; 03A7C6 : A9 02       ;
CODE_03A7C8:          STA.W $151C,X                       ;; 03A7C8 : 9D 1C 15    ;
CODE_03A7CB:          LDA.B #$18                          ;; 03A7CB : A9 18       ;
CODE_03A7CD:          STA RAM_SpriteYLo,X                 ;; 03A7CD : 95 D8       ;
CODE_03A7CF:          LDA.B #$00                          ;; 03A7CF : A9 00       ;
CODE_03A7D1:          STA.W RAM_SpriteYHi,X               ;; 03A7D1 : 9D D4 14    ;
CODE_03A7D4:          LDA.B #$08                          ;; 03A7D4 : A9 08       ;
CODE_03A7D6:          STA $38                             ;; 03A7D6 : 85 38       ;
CODE_03A7D8:          STA $39                             ;; 03A7D8 : 85 39       ;
CODE_03A7DA:          LDA.B #$64                          ;; 03A7DA : A9 64       ;
CODE_03A7DC:          STA RAM_SpriteSpeedX,X              ;; 03A7DC : 95 B6       ;
Return03A7DE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7DF:          CMP.B #$60                          ;; 03A7DF : C9 60       ;
CODE_03A7E1:          BCS Return03A840                    ;; 03A7E1 : B0 5D       ;
CODE_03A7E3:          LDA RAM_FrameCounter                ;; 03A7E3 : A5 13       ;
CODE_03A7E5:          AND.B #$1F                          ;; 03A7E5 : 29 1F       ;
CODE_03A7E7:          BNE Return03A840                    ;; 03A7E7 : D0 57       ;
CODE_03A7E9:          LDY.B #$07                          ;; 03A7E9 : A0 07       ;
CODE_03A7EB:          LDA.W $14C8,Y                       ;; 03A7EB : B9 C8 14    ;
CODE_03A7EE:          BEQ CODE_03A7F6                     ;; 03A7EE : F0 06       ;
CODE_03A7F0:          DEY                                 ;; 03A7F0 : 88          ;
CODE_03A7F1:          CPY.B #$01                          ;; 03A7F1 : C0 01       ;
CODE_03A7F3:          BNE CODE_03A7EB                     ;; 03A7F3 : D0 F6       ;
Return03A7F5:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7F6:          LDA.B #$17                          ;; 03A7F6 : A9 17       ; \ Play sound effect 
CODE_03A7F8:          STA.W $1DFC                         ;; 03A7F8 : 8D FC 1D    ; / 
CODE_03A7FB:          LDA.B #$08                          ;; 03A7FB : A9 08       ; \ Sprite status = Normal 
CODE_03A7FD:          STA.W $14C8,Y                       ;; 03A7FD : 99 C8 14    ; / 
CODE_03A800:          LDA.B #$33                          ;; 03A800 : A9 33       ;
CODE_03A802:          STA.W RAM_SpriteNum,Y               ;; 03A802 : 99 9E 00    ;
CODE_03A805:          LDA.W $14B7                         ;; 03A805 : AD B7 14    ;
CODE_03A808:          PHA                                 ;; 03A808 : 48          ;
CODE_03A809:          STA.W RAM_SpriteXLo,Y               ;; 03A809 : 99 E4 00    ;
CODE_03A80C:          CLC                                 ;; 03A80C : 18          ;
CODE_03A80D:          ADC.B #$20                          ;; 03A80D : 69 20       ;
CODE_03A80F:          STA.W $14B7                         ;; 03A80F : 8D B7 14    ;
CODE_03A812:          LDA.B #$00                          ;; 03A812 : A9 00       ;
CODE_03A814:          STA.W RAM_SpriteXHi,Y               ;; 03A814 : 99 E0 14    ;
CODE_03A817:          LDA.B #$00                          ;; 03A817 : A9 00       ;
CODE_03A819:          STA.W RAM_SpriteYLo,Y               ;; 03A819 : 99 D8 00    ;
CODE_03A81C:          STA.W RAM_SpriteYHi,Y               ;; 03A81C : 99 D4 14    ;
CODE_03A81F:          PHX                                 ;; 03A81F : DA          ;
CODE_03A820:          TYX                                 ;; 03A820 : BB          ;
CODE_03A821:          JSL.L InitSpriteTables              ;; 03A821 : 22 D2 F7 07 ;
CODE_03A825:          INC RAM_SpriteState,X               ;; 03A825 : F6 C2       ;
CODE_03A827:          ASL.W RAM_Tweaker1686,X             ;; 03A827 : 1E 86 16    ;
CODE_03A82A:          LSR.W RAM_Tweaker1686,X             ;; 03A82A : 5E 86 16    ;
CODE_03A82D:          LDA.B #$39                          ;; 03A82D : A9 39       ;
CODE_03A82F:          STA.W RAM_Tweaker1662,X             ;; 03A82F : 9D 62 16    ;
CODE_03A832:          PLX                                 ;; 03A832 : FA          ;
CODE_03A833:          PLA                                 ;; 03A833 : 68          ;
CODE_03A834:          LSR                                 ;; 03A834 : 4A          ;
CODE_03A835:          LSR                                 ;; 03A835 : 4A          ;
CODE_03A836:          LSR                                 ;; 03A836 : 4A          ;
CODE_03A837:          LSR                                 ;; 03A837 : 4A          ;
CODE_03A838:          LSR                                 ;; 03A838 : 4A          ;
CODE_03A839:          TAY                                 ;; 03A839 : A8          ;
CODE_03A83A:          LDA.W BowserSound,Y                 ;; 03A83A : B9 41 A8    ;
CODE_03A83D:          STA.W $1DFC                         ;; 03A83D : 8D FC 1D    ; / Play sound effect 
Return03A840:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserSound:          .db $2D                             ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserSoundMusic:     .db $2E,$2F,$30,$31,$32,$33,$34,$19 ;; ?QPWZ?               ;
                      .db $1A                             ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A84B:          STZ RAM_SpriteSpeedY,X              ;; 03A84B : 74 AA       ; Sprite Y Speed = 0 
CODE_03A84D:          LDA.W $1540,X                       ;; 03A84D : BD 40 15    ;
CODE_03A850:          BNE CODE_03A86E                     ;; 03A850 : D0 1C       ;
CODE_03A852:          LDA RAM_SpriteSpeedX,X              ;; 03A852 : B5 B6       ;
CODE_03A854:          BEQ CODE_03A858                     ;; 03A854 : F0 02       ;
CODE_03A856:          DEC RAM_SpriteSpeedX,X              ;; 03A856 : D6 B6       ;
CODE_03A858:          LDA RAM_FrameCounter                ;; 03A858 : A5 13       ;
CODE_03A85A:          AND.B #$03                          ;; 03A85A : 29 03       ;
CODE_03A85C:          BNE Return03A86D                    ;; 03A85C : D0 0F       ;
CODE_03A85E:          INC $38                             ;; 03A85E : E6 38       ;
CODE_03A860:          INC $39                             ;; 03A860 : E6 39       ;
CODE_03A862:          LDA $38                             ;; 03A862 : A5 38       ;
CODE_03A864:          CMP.B #$20                          ;; 03A864 : C9 20       ;
CODE_03A866:          BNE Return03A86D                    ;; 03A866 : D0 05       ;
CODE_03A868:          LDA.B #$FF                          ;; 03A868 : A9 FF       ;
CODE_03A86A:          STA.W $1540,X                       ;; 03A86A : 9D 40 15    ;
Return03A86D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A86E:          CMP.B #$A0                          ;; 03A86E : C9 A0       ;
CODE_03A870:          BNE CODE_03A877                     ;; 03A870 : D0 05       ;
CODE_03A872:          PHA                                 ;; 03A872 : 48          ;
CODE_03A873:          JSR.W CODE_03A8D6                   ;; 03A873 : 20 D6 A8    ;
CODE_03A876:          PLA                                 ;; 03A876 : 68          ;
CODE_03A877:          STZ RAM_SpriteSpeedX,X              ;; 03A877 : 74 B6       ; Sprite X Speed = 0 
CODE_03A879:          STZ RAM_SpriteSpeedY,X              ;; 03A879 : 74 AA       ; Sprite Y Speed = 0 
CODE_03A87B:          CMP.B #$01                          ;; 03A87B : C9 01       ;
CODE_03A87D:          BEQ CODE_03A89D                     ;; 03A87D : F0 1E       ;
CODE_03A87F:          CMP.B #$40                          ;; 03A87F : C9 40       ;
CODE_03A881:          BCS CODE_03A8AE                     ;; 03A881 : B0 2B       ;
CODE_03A883:          CMP.B #$3F                          ;; 03A883 : C9 3F       ;
CODE_03A885:          BNE CODE_03A892                     ;; 03A885 : D0 0B       ;
CODE_03A887:          PHA                                 ;; 03A887 : 48          ;
CODE_03A888:          LDY.W $14B4                         ;; 03A888 : AC B4 14    ;
CODE_03A88B:          LDA.W BowserSoundMusic,Y            ;; 03A88B : B9 42 A8    ;
CODE_03A88E:          STA.W $1DFB                         ;; 03A88E : 8D FB 1D    ; / Change music 
CODE_03A891:          PLA                                 ;; 03A891 : 68          ;
CODE_03A892:          LSR                                 ;; 03A892 : 4A          ;
CODE_03A893:          LSR                                 ;; 03A893 : 4A          ;
CODE_03A894:          LSR                                 ;; 03A894 : 4A          ;
CODE_03A895:          TAY                                 ;; 03A895 : A8          ;
CODE_03A896:          LDA.W DATA_03A437,Y                 ;; 03A896 : B9 37 A4    ;
CODE_03A899:          STA.W $1570,X                       ;; 03A899 : 9D 70 15    ;
Return03A89C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A89D:          LDA.W $14B4                         ;; 03A89D : AD B4 14    ;
CODE_03A8A0:          INC A                               ;; 03A8A0 : 1A          ;
CODE_03A8A1:          STA.W $151C,X                       ;; 03A8A1 : 9D 1C 15    ;
CODE_03A8A4:          STZ RAM_SpriteSpeedX,X              ;; 03A8A4 : 74 B6       ; Sprite X Speed = 0 
CODE_03A8A6:          STZ RAM_SpriteSpeedY,X              ;; 03A8A6 : 74 AA       ; Sprite Y Speed = 0 
CODE_03A8A8:          LDA.B #$80                          ;; 03A8A8 : A9 80       ;
CODE_03A8AA:          STA.W $14B0                         ;; 03A8AA : 8D B0 14    ;
Return03A8AD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A8AE:          CMP.B #$E8                          ;; 03A8AE : C9 E8       ;
CODE_03A8B0:          BNE CODE_03A8B7                     ;; 03A8B0 : D0 05       ;
CODE_03A8B2:          LDY.B #$2A                          ;; 03A8B2 : A0 2A       ; \ Play sound effect 
CODE_03A8B4:          STY.W $1DF9                         ;; 03A8B4 : 8C F9 1D    ; / 
CODE_03A8B7:          SEC                                 ;; 03A8B7 : 38          ;
CODE_03A8B8:          SBC.B #$3F                          ;; 03A8B8 : E9 3F       ;
CODE_03A8BA:          STA.W $1594,X                       ;; 03A8BA : 9D 94 15    ;
Return03A8BD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A8BE:          .db $00,$00,$00,$08,$10,$14,$14,$16 ;; 03A8BE               ;
                      .db $16,$18,$18,$17,$16,$16,$17,$18 ;; ?QPWZ?               ;
                      .db $18,$17,$14,$10,$0C,$08,$04,$00 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A8D6:          LDY.B #$07                          ;; 03A8D6 : A0 07       ;
CODE_03A8D8:          LDA.W $14C8,Y                       ;; 03A8D8 : B9 C8 14    ;
CODE_03A8DB:          BEQ CODE_03A8E3                     ;; 03A8DB : F0 06       ;
ADDR_03A8DD:          DEY                                 ;; 03A8DD : 88          ;
ADDR_03A8DE:          CPY.B #$01                          ;; 03A8DE : C0 01       ;
ADDR_03A8E0:          BNE CODE_03A8D8                     ;; 03A8E0 : D0 F6       ;
Return03A8E2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A8E3:          LDA.B #$10                          ;; 03A8E3 : A9 10       ; \ Play sound effect 
CODE_03A8E5:          STA.W $1DF9                         ;; 03A8E5 : 8D F9 1D    ; / 
CODE_03A8E8:          LDA.B #$08                          ;; 03A8E8 : A9 08       ; \ Sprite status = Normal 
CODE_03A8EA:          STA.W $14C8,Y                       ;; 03A8EA : 99 C8 14    ; / 
CODE_03A8ED:          LDA.B #$74                          ;; 03A8ED : A9 74       ;
CODE_03A8EF:          STA.W RAM_SpriteNum,Y               ;; 03A8EF : 99 9E 00    ;
CODE_03A8F2:          LDA RAM_SpriteXLo,X                 ;; 03A8F2 : B5 E4       ;
CODE_03A8F4:          CLC                                 ;; 03A8F4 : 18          ;
CODE_03A8F5:          ADC.B #$04                          ;; 03A8F5 : 69 04       ;
CODE_03A8F7:          STA.W RAM_SpriteXLo,Y               ;; 03A8F7 : 99 E4 00    ;
CODE_03A8FA:          LDA.W RAM_SpriteXHi,X               ;; 03A8FA : BD E0 14    ;
CODE_03A8FD:          ADC.B #$00                          ;; 03A8FD : 69 00       ;
CODE_03A8FF:          STA.W RAM_SpriteXHi,Y               ;; 03A8FF : 99 E0 14    ;
CODE_03A902:          LDA RAM_SpriteYLo,X                 ;; 03A902 : B5 D8       ;
CODE_03A904:          CLC                                 ;; 03A904 : 18          ;
CODE_03A905:          ADC.B #$18                          ;; 03A905 : 69 18       ;
CODE_03A907:          STA.W RAM_SpriteYLo,Y               ;; 03A907 : 99 D8 00    ;
CODE_03A90A:          LDA.W RAM_SpriteYHi,X               ;; 03A90A : BD D4 14    ;
CODE_03A90D:          ADC.B #$00                          ;; 03A90D : 69 00       ;
CODE_03A90F:          STA.W RAM_SpriteYHi,Y               ;; 03A90F : 99 D4 14    ;
CODE_03A912:          PHX                                 ;; 03A912 : DA          ;
CODE_03A913:          TYX                                 ;; 03A913 : BB          ;
CODE_03A914:          JSL.L InitSpriteTables              ;; 03A914 : 22 D2 F7 07 ;
CODE_03A918:          LDA.B #$C0                          ;; 03A918 : A9 C0       ;
CODE_03A91A:          STA RAM_SpriteSpeedY,X              ;; 03A91A : 95 AA       ;
CODE_03A91C:          STZ.W RAM_SpriteDir,X               ;; 03A91C : 9E 7C 15    ;
CODE_03A91F:          LDY.B #$0C                          ;; 03A91F : A0 0C       ;
CODE_03A921:          LDA RAM_SpriteXLo,X                 ;; 03A921 : B5 E4       ;
CODE_03A923:          BPL CODE_03A92A                     ;; 03A923 : 10 05       ;
CODE_03A925:          LDY.B #$F4                          ;; 03A925 : A0 F4       ;
CODE_03A927:          INC.W RAM_SpriteDir,X               ;; 03A927 : FE 7C 15    ;
CODE_03A92A:          STY RAM_SpriteSpeedX,X              ;; 03A92A : 94 B6       ;
CODE_03A92C:          PLX                                 ;; 03A92C : FA          ;
Return03A92D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A92E:          .db $00,$08,$00,$08,$00,$08,$00,$08 ;; 03A92E               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $00,$08,$00,$08,$00,$08,$00,$08 ;; ?QPWZ?               ;
                      .db $08,$00,$08,$00,$08,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$08,$00,$08,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$08,$00,$08,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$08,$00,$08,$00,$08,$00 ;; ?QPWZ?               ;
DATA_03A97E:          .db $00,$00,$08,$08,$00,$00,$08,$08 ;; 03A97E               ;
                      .db $00,$00,$08,$08,$00,$00,$08,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
                      .db $00,$00,$10,$10,$00,$00,$10,$10 ;; ?QPWZ?               ;
DATA_03A9CE:          .db $05,$06,$15,$16,$9D,$9E,$4E,$AE ;; 03A9CE               ;
                      .db $06,$05,$16,$15,$9E,$9D,$AE,$4E ;; ?QPWZ?               ;
                      .db $8A,$8B,$AA,$68,$83,$84,$AA,$68 ;; ?QPWZ?               ;
                      .db $8A,$8B,$80,$81,$83,$84,$80,$81 ;; ?QPWZ?               ;
                      .db $85,$86,$A5,$A6,$83,$84,$A5,$A6 ;; ?QPWZ?               ;
                      .db $82,$83,$A2,$A3,$82,$83,$A2,$A3 ;; ?QPWZ?               ;
                      .db $8A,$8B,$AA,$68,$83,$84,$AA,$68 ;; ?QPWZ?               ;
                      .db $8A,$8B,$80,$81,$83,$84,$80,$81 ;; ?QPWZ?               ;
                      .db $85,$86,$A5,$A6,$83,$84,$A5,$A6 ;; ?QPWZ?               ;
                      .db $82,$83,$A2,$A3,$82,$83,$A2,$A3 ;; ?QPWZ?               ;
DATA_03AA1E:          .db $01,$01,$01,$01,$01,$01,$01,$01 ;; 03AA1E               ;
                      .db $41,$41,$41,$41,$41,$41,$41,$41 ;; ?QPWZ?               ;
                      .db $01,$01,$01,$01,$01,$01,$01,$01 ;; ?QPWZ?               ;
                      .db $01,$01,$01,$01,$01,$01,$01,$01 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$01,$01,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $41,$41,$41,$41,$41,$41,$41,$41 ;; ?QPWZ?               ;
                      .db $41,$41,$41,$41,$41,$41,$41,$41 ;; ?QPWZ?               ;
                      .db $40,$40,$40,$40,$41,$41,$40,$40 ;; ?QPWZ?               ;
                      .db $40,$40,$40,$40,$40,$40,$40,$40 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AA6E:          LDA RAM_SpriteXLo,X                 ;; 03AA6E : B5 E4       ;
CODE_03AA70:          CLC                                 ;; 03AA70 : 18          ;
CODE_03AA71:          ADC.B #$04                          ;; 03AA71 : 69 04       ;
CODE_03AA73:          SEC                                 ;; 03AA73 : 38          ;
CODE_03AA74:          SBC RAM_ScreenBndryXLo              ;; 03AA74 : E5 1A       ;
CODE_03AA76:          STA $00                             ;; 03AA76 : 85 00       ;
CODE_03AA78:          LDA RAM_SpriteYLo,X                 ;; 03AA78 : B5 D8       ;
CODE_03AA7A:          CLC                                 ;; 03AA7A : 18          ;
CODE_03AA7B:          ADC.B #$20                          ;; 03AA7B : 69 20       ;
CODE_03AA7D:          SEC                                 ;; 03AA7D : 38          ;
CODE_03AA7E:          SBC $02                             ;; 03AA7E : E5 02       ;
CODE_03AA80:          SEC                                 ;; 03AA80 : 38          ;
CODE_03AA81:          SBC RAM_ScreenBndryYLo              ;; 03AA81 : E5 1C       ;
CODE_03AA83:          STA $01                             ;; 03AA83 : 85 01       ;
CODE_03AA85:          CPY.B #$08                          ;; 03AA85 : C0 08       ;
CODE_03AA87:          BCC CODE_03AAC6                     ;; 03AA87 : 90 3D       ;
CODE_03AA89:          CPY.B #$10                          ;; 03AA89 : C0 10       ;
CODE_03AA8B:          BCS CODE_03AAC6                     ;; 03AA8B : B0 39       ;
CODE_03AA8D:          LDA $00                             ;; 03AA8D : A5 00       ;
CODE_03AA8F:          SEC                                 ;; 03AA8F : 38          ;
CODE_03AA90:          SBC.B #$04                          ;; 03AA90 : E9 04       ;
CODE_03AA92:          STA.W $02A0                         ;; 03AA92 : 8D A0 02    ;
CODE_03AA95:          CLC                                 ;; 03AA95 : 18          ;
CODE_03AA96:          ADC.B #$10                          ;; 03AA96 : 69 10       ;
CODE_03AA98:          STA.W $02A4                         ;; 03AA98 : 8D A4 02    ;
CODE_03AA9B:          LDA $01                             ;; 03AA9B : A5 01       ;
CODE_03AA9D:          SEC                                 ;; 03AA9D : 38          ;
CODE_03AA9E:          SBC.B #$18                          ;; 03AA9E : E9 18       ;
CODE_03AAA0:          STA.W $02A1                         ;; 03AAA0 : 8D A1 02    ;
CODE_03AAA3:          STA.W $02A5                         ;; 03AAA3 : 8D A5 02    ;
CODE_03AAA6:          LDA.B #$20                          ;; 03AAA6 : A9 20       ;
CODE_03AAA8:          STA.W $02A2                         ;; 03AAA8 : 8D A2 02    ;
CODE_03AAAB:          LDA.B #$22                          ;; 03AAAB : A9 22       ;
CODE_03AAAD:          STA.W $02A6                         ;; 03AAAD : 8D A6 02    ;
CODE_03AAB0:          LDA RAM_FrameCounterB               ;; 03AAB0 : A5 14       ;
CODE_03AAB2:          LSR                                 ;; 03AAB2 : 4A          ;
CODE_03AAB3:          AND.B #$06                          ;; 03AAB3 : 29 06       ;
CODE_03AAB5:          INC A                               ;; 03AAB5 : 1A          ;
CODE_03AAB6:          INC A                               ;; 03AAB6 : 1A          ;
CODE_03AAB7:          INC A                               ;; 03AAB7 : 1A          ;
CODE_03AAB8:          STA.W $02A3                         ;; 03AAB8 : 8D A3 02    ;
CODE_03AABB:          STA.W $02A7                         ;; 03AABB : 8D A7 02    ;
CODE_03AABE:          LDA.B #$02                          ;; 03AABE : A9 02       ;
CODE_03AAC0:          STA.W $0448                         ;; 03AAC0 : 8D 48 04    ;
CODE_03AAC3:          STA.W $0449                         ;; 03AAC3 : 8D 49 04    ;
CODE_03AAC6:          LDY.B #$70                          ;; 03AAC6 : A0 70       ;
CODE_03AAC8:          LDA $03                             ;; 03AAC8 : A5 03       ;
CODE_03AACA:          ASL                                 ;; 03AACA : 0A          ;
CODE_03AACB:          ASL                                 ;; 03AACB : 0A          ;
CODE_03AACC:          STA $04                             ;; 03AACC : 85 04       ;
CODE_03AACE:          PHX                                 ;; 03AACE : DA          ;
CODE_03AACF:          LDX.B #$03                          ;; 03AACF : A2 03       ;
CODE_03AAD1:          PHX                                 ;; 03AAD1 : DA          ;
CODE_03AAD2:          TXA                                 ;; 03AAD2 : 8A          ;
CODE_03AAD3:          CLC                                 ;; 03AAD3 : 18          ;
CODE_03AAD4:          ADC $04                             ;; 03AAD4 : 65 04       ;
CODE_03AAD6:          TAX                                 ;; 03AAD6 : AA          ;
CODE_03AAD7:          LDA $00                             ;; 03AAD7 : A5 00       ;
CODE_03AAD9:          CLC                                 ;; 03AAD9 : 18          ;
CODE_03AADA:          ADC.W DATA_03A92E,X                 ;; 03AADA : 7D 2E A9    ;
CODE_03AADD:          STA.W OAM_DispX,Y                   ;; 03AADD : 99 00 03    ;
CODE_03AAE0:          LDA $01                             ;; 03AAE0 : A5 01       ;
CODE_03AAE2:          CLC                                 ;; 03AAE2 : 18          ;
CODE_03AAE3:          ADC.W DATA_03A97E,X                 ;; 03AAE3 : 7D 7E A9    ;
CODE_03AAE6:          STA.W OAM_DispY,Y                   ;; 03AAE6 : 99 01 03    ;
CODE_03AAE9:          LDA.W DATA_03A9CE,X                 ;; 03AAE9 : BD CE A9    ;
CODE_03AAEC:          STA.W OAM_Tile,Y                    ;; 03AAEC : 99 02 03    ;
CODE_03AAEF:          LDA.W DATA_03AA1E,X                 ;; 03AAEF : BD 1E AA    ;
CODE_03AAF2:          PHX                                 ;; 03AAF2 : DA          ;
CODE_03AAF3:          LDX.W $15E9                         ;; 03AAF3 : AE E9 15    ; X = Sprite index 
CODE_03AAF6:          CPX.B #$09                          ;; 03AAF6 : E0 09       ;
CODE_03AAF8:          BEQ CODE_03AAFC                     ;; 03AAF8 : F0 02       ;
CODE_03AAFA:          ORA.B #$30                          ;; 03AAFA : 09 30       ;
CODE_03AAFC:          STA.W OAM_Prop,Y                    ;; 03AAFC : 99 03 03    ;
CODE_03AAFF:          PLX                                 ;; 03AAFF : FA          ;
CODE_03AB00:          PHY                                 ;; 03AB00 : 5A          ;
CODE_03AB01:          TYA                                 ;; 03AB01 : 98          ;
CODE_03AB02:          LSR                                 ;; 03AB02 : 4A          ;
CODE_03AB03:          LSR                                 ;; 03AB03 : 4A          ;
CODE_03AB04:          TAY                                 ;; 03AB04 : A8          ;
CODE_03AB05:          LDA.B #$02                          ;; 03AB05 : A9 02       ;
CODE_03AB07:          STA.W OAM_TileSize,Y                ;; 03AB07 : 99 60 04    ;
CODE_03AB0A:          PLY                                 ;; 03AB0A : 7A          ;
CODE_03AB0B:          INY                                 ;; 03AB0B : C8          ;
CODE_03AB0C:          INY                                 ;; 03AB0C : C8          ;
CODE_03AB0D:          INY                                 ;; 03AB0D : C8          ;
CODE_03AB0E:          INY                                 ;; 03AB0E : C8          ;
CODE_03AB0F:          PLX                                 ;; 03AB0F : FA          ;
CODE_03AB10:          DEX                                 ;; 03AB10 : CA          ;
CODE_03AB11:          BPL CODE_03AAD1                     ;; 03AB11 : 10 BE       ;
CODE_03AB13:          PLX                                 ;; 03AB13 : FA          ;
Return03AB14:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AB15:          .db $01,$FF                         ;; 03AB15               ;
                                                          ;;                      ;
DATA_03AB17:          .db $20,$E0                         ;; 03AB17               ;
                                                          ;;                      ;
DATA_03AB19:          .db $02,$FE                         ;; 03AB19               ;
                                                          ;;                      ;
DATA_03AB1B:          .db $20,$E0,$01,$FF,$10,$F0         ;; 03AB1B               ;
                                                          ;;                      ;
CODE_03AB21:          JSR.W CODE_03A4FD                   ;; 03AB21 : 20 FD A4    ;
CODE_03AB24:          JSR.W CODE_03A4D2                   ;; 03AB24 : 20 D2 A4    ;
CODE_03AB27:          JSR.W CODE_03A4ED                   ;; 03AB27 : 20 ED A4    ;
CODE_03AB2A:          LDA RAM_FrameCounter                ;; 03AB2A : A5 13       ;
CODE_03AB2C:          AND.B #$00                          ;; 03AB2C : 29 00       ;
CODE_03AB2E:          BNE CODE_03AB4B                     ;; 03AB2E : D0 1B       ;
CODE_03AB30:          LDY.B #$00                          ;; 03AB30 : A0 00       ;
CODE_03AB32:          LDA RAM_SpriteXLo,X                 ;; 03AB32 : B5 E4       ;
CODE_03AB34:          CMP RAM_MarioXPos                   ;; 03AB34 : C5 94       ;
CODE_03AB36:          LDA.W RAM_SpriteXHi,X               ;; 03AB36 : BD E0 14    ;
CODE_03AB39:          SBC RAM_MarioXPosHi                 ;; 03AB39 : E5 95       ;
CODE_03AB3B:          BMI CODE_03AB3E                     ;; 03AB3B : 30 01       ;
CODE_03AB3D:          INY                                 ;; 03AB3D : C8          ;
CODE_03AB3E:          LDA RAM_SpriteSpeedX,X              ;; 03AB3E : B5 B6       ;
CODE_03AB40:          CMP.W DATA_03AB17,Y                 ;; 03AB40 : D9 17 AB    ;
CODE_03AB43:          BEQ CODE_03AB4B                     ;; 03AB43 : F0 06       ;
CODE_03AB45:          CLC                                 ;; 03AB45 : 18          ;
CODE_03AB46:          ADC.W DATA_03AB15,Y                 ;; 03AB46 : 79 15 AB    ;
CODE_03AB49:          STA RAM_SpriteSpeedX,X              ;; 03AB49 : 95 B6       ;
CODE_03AB4B:          LDY.B #$00                          ;; 03AB4B : A0 00       ;
CODE_03AB4D:          LDA RAM_SpriteYLo,X                 ;; 03AB4D : B5 D8       ;
CODE_03AB4F:          CMP.B #$10                          ;; 03AB4F : C9 10       ;
CODE_03AB51:          BMI CODE_03AB54                     ;; 03AB51 : 30 01       ;
CODE_03AB53:          INY                                 ;; 03AB53 : C8          ;
CODE_03AB54:          LDA RAM_SpriteSpeedY,X              ;; 03AB54 : B5 AA       ;
CODE_03AB56:          CMP.W DATA_03AB1B,Y                 ;; 03AB56 : D9 1B AB    ;
CODE_03AB59:          BEQ Return03AB61                    ;; 03AB59 : F0 06       ;
CODE_03AB5B:          CLC                                 ;; 03AB5B : 18          ;
CODE_03AB5C:          ADC.W DATA_03AB19,Y                 ;; 03AB5C : 79 19 AB    ;
CODE_03AB5F:          STA RAM_SpriteSpeedY,X              ;; 03AB5F : 95 AA       ;
Return03AB61:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AB62:          .db $10,$F0                         ;; 03AB62               ;
                                                          ;;                      ;
CODE_03AB64:          LDA.B #$03                          ;; 03AB64 : A9 03       ;
CODE_03AB66:          STA.W $1427                         ;; 03AB66 : 8D 27 14    ;
CODE_03AB69:          JSR.W CODE_03A4FD                   ;; 03AB69 : 20 FD A4    ;
CODE_03AB6C:          JSR.W CODE_03A4D2                   ;; 03AB6C : 20 D2 A4    ;
CODE_03AB6F:          JSR.W CODE_03A4ED                   ;; 03AB6F : 20 ED A4    ;
CODE_03AB72:          LDA RAM_SpriteSpeedY,X              ;; 03AB72 : B5 AA       ;
CODE_03AB74:          CLC                                 ;; 03AB74 : 18          ;
CODE_03AB75:          ADC.B #$03                          ;; 03AB75 : 69 03       ;
CODE_03AB77:          STA RAM_SpriteSpeedY,X              ;; 03AB77 : 95 AA       ;
CODE_03AB79:          LDA RAM_SpriteYLo,X                 ;; 03AB79 : B5 D8       ;
CODE_03AB7B:          CMP.B #$64                          ;; 03AB7B : C9 64       ;
CODE_03AB7D:          BCC Return03AB9E                    ;; 03AB7D : 90 1F       ;
CODE_03AB7F:          LDA.W RAM_SpriteYHi,X               ;; 03AB7F : BD D4 14    ;
CODE_03AB82:          BMI Return03AB9E                    ;; 03AB82 : 30 1A       ;
CODE_03AB84:          LDA.B #$64                          ;; 03AB84 : A9 64       ;
CODE_03AB86:          STA RAM_SpriteYLo,X                 ;; 03AB86 : 95 D8       ;
CODE_03AB88:          LDA.B #$A0                          ;; 03AB88 : A9 A0       ;
CODE_03AB8A:          STA RAM_SpriteSpeedY,X              ;; 03AB8A : 95 AA       ;
CODE_03AB8C:          LDA.B #$09                          ;; 03AB8C : A9 09       ; \ Play sound effect 
CODE_03AB8E:          STA.W $1DFC                         ;; 03AB8E : 8D FC 1D    ; / 
CODE_03AB91:          JSR.W SubHorzPosBnk3                ;; 03AB91 : 20 17 B8    ;
CODE_03AB94:          LDA.W DATA_03AB62,Y                 ;; 03AB94 : B9 62 AB    ;
CODE_03AB97:          STA RAM_SpriteSpeedX,X              ;; 03AB97 : 95 B6       ;
CODE_03AB99:          LDA.B #$20                          ;; 03AB99 : A9 20       ; \ Set ground shake timer 
CODE_03AB9B:          STA.W RAM_ShakeGrndTimer            ;; 03AB9B : 8D 87 18    ; / 
Return03AB9E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AB9F:          JSR.W CODE_03A6AC                   ;; 03AB9F : 20 AC A6    ;
CODE_03ABA2:          LDA.W RAM_SpriteYHi,X               ;; 03ABA2 : BD D4 14    ;
CODE_03ABA5:          BMI CODE_03ABAF                     ;; 03ABA5 : 30 08       ;
CODE_03ABA7:          BNE CODE_03ABB9                     ;; 03ABA7 : D0 10       ;
CODE_03ABA9:          LDA RAM_SpriteYLo,X                 ;; 03ABA9 : B5 D8       ;
CODE_03ABAB:          CMP.B #$10                          ;; 03ABAB : C9 10       ;
CODE_03ABAD:          BCS CODE_03ABB9                     ;; 03ABAD : B0 0A       ;
CODE_03ABAF:          LDA.B #$05                          ;; 03ABAF : A9 05       ;
CODE_03ABB1:          STA.W $151C,X                       ;; 03ABB1 : 9D 1C 15    ;
CODE_03ABB4:          LDA.B #$60                          ;; 03ABB4 : A9 60       ;
CODE_03ABB6:          STA.W $1540,X                       ;; 03ABB6 : 9D 40 15    ;
CODE_03ABB9:          LDA.B #$F8                          ;; 03ABB9 : A9 F8       ;
CODE_03ABBB:          STA RAM_SpriteSpeedY,X              ;; 03ABBB : 95 AA       ;
Return03ABBD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ABBE:          JSR.W CODE_03A6AC                   ;; 03ABBE : 20 AC A6    ;
CODE_03ABC1:          STZ RAM_SpriteSpeedX,X              ;; 03ABC1 : 74 B6       ; Sprite X Speed = 0 
CODE_03ABC3:          STZ RAM_SpriteSpeedY,X              ;; 03ABC3 : 74 AA       ; Sprite Y Speed = 0 
CODE_03ABC5:          LDA.W $1540,X                       ;; 03ABC5 : BD 40 15    ;
CODE_03ABC8:          BNE CODE_03ABEB                     ;; 03ABC8 : D0 21       ;
CODE_03ABCA:          LDA $36                             ;; 03ABCA : A5 36       ;
CODE_03ABCC:          CLC                                 ;; 03ABCC : 18          ;
CODE_03ABCD:          ADC.B #$0A                          ;; 03ABCD : 69 0A       ;
CODE_03ABCF:          STA $36                             ;; 03ABCF : 85 36       ;
CODE_03ABD1:          LDA $37                             ;; 03ABD1 : A5 37       ;
CODE_03ABD3:          ADC.B #$00                          ;; 03ABD3 : 69 00       ;
CODE_03ABD5:          STA $37                             ;; 03ABD5 : 85 37       ;
CODE_03ABD7:          BEQ Return03ABEA                    ;; 03ABD7 : F0 11       ;
CODE_03ABD9:          STZ $36                             ;; 03ABD9 : 64 36       ;
CODE_03ABDB:          LDA.B #$20                          ;; 03ABDB : A9 20       ;
CODE_03ABDD:          STA.W RAM_DisableInter,X            ;; 03ABDD : 9D 4C 15    ;
CODE_03ABE0:          LDA.B #$60                          ;; 03ABE0 : A9 60       ;
CODE_03ABE2:          STA.W $1540,X                       ;; 03ABE2 : 9D 40 15    ;
CODE_03ABE5:          LDA.B #$06                          ;; 03ABE5 : A9 06       ;
CODE_03ABE7:          STA.W $151C,X                       ;; 03ABE7 : 9D 1C 15    ;
Return03ABEA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ABEB:          CMP.B #$40                          ;; 03ABEB : C9 40       ;
CODE_03ABED:          BCC Return03AC02                    ;; 03ABED : 90 13       ;
CODE_03ABEF:          CMP.B #$5E                          ;; 03ABEF : C9 5E       ;
CODE_03ABF1:          BNE CODE_03ABF8                     ;; 03ABF1 : D0 05       ;
CODE_03ABF3:          LDY.B #$1B                          ;; 03ABF3 : A0 1B       ;
CODE_03ABF5:          STY.W $1DFB                         ;; 03ABF5 : 8C FB 1D    ; / Change music 
CODE_03ABF8:          LDA.W $1564,X                       ;; 03ABF8 : BD 64 15    ;
CODE_03ABFB:          BNE Return03AC02                    ;; 03ABFB : D0 05       ;
CODE_03ABFD:          LDA.B #$12                          ;; 03ABFD : A9 12       ;
CODE_03ABFF:          STA.W $1564,X                       ;; 03ABFF : 9D 64 15    ;
Return03AC02:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC03:          JSR.W CODE_03A6AC                   ;; 03AC03 : 20 AC A6    ;
CODE_03AC06:          LDA.W RAM_DisableInter,X            ;; 03AC06 : BD 4C 15    ;
CODE_03AC09:          CMP.B #$01                          ;; 03AC09 : C9 01       ;
CODE_03AC0B:          BNE CODE_03AC22                     ;; 03AC0B : D0 15       ;
CODE_03AC0D:          LDA.B #$0B                          ;; 03AC0D : A9 0B       ;
CODE_03AC0F:          STA RAM_MarioAnimation              ;; 03AC0F : 85 71       ;
CODE_03AC11:          INC.W $190D                         ;; 03AC11 : EE 0D 19    ;
CODE_03AC14:          STZ.W $0701                         ;; 03AC14 : 9C 01 07    ;
CODE_03AC17:          STZ.W $0702                         ;; 03AC17 : 9C 02 07    ;
CODE_03AC1A:          LDA.B #$03                          ;; 03AC1A : A9 03       ;
CODE_03AC1C:          STA.W RAM_IsBehindScenery           ;; 03AC1C : 8D F9 13    ;
CODE_03AC1F:          JSR.W CODE_03AC63                   ;; 03AC1F : 20 63 AC    ;
CODE_03AC22:          LDA.W $1540,X                       ;; 03AC22 : BD 40 15    ;
CODE_03AC25:          BNE Return03AC4C                    ;; 03AC25 : D0 25       ;
CODE_03AC27:          LDA.B #$FA                          ;; 03AC27 : A9 FA       ;
CODE_03AC29:          STA RAM_SpriteSpeedX,X              ;; 03AC29 : 95 B6       ;
CODE_03AC2B:          LDA.B #$FC                          ;; 03AC2B : A9 FC       ;
CODE_03AC2D:          STA RAM_SpriteSpeedY,X              ;; 03AC2D : 95 AA       ;
CODE_03AC2F:          LDA $36                             ;; 03AC2F : A5 36       ;
CODE_03AC31:          CLC                                 ;; 03AC31 : 18          ;
CODE_03AC32:          ADC.B #$05                          ;; 03AC32 : 69 05       ;
CODE_03AC34:          STA $36                             ;; 03AC34 : 85 36       ;
CODE_03AC36:          LDA $37                             ;; 03AC36 : A5 37       ;
CODE_03AC38:          ADC.B #$00                          ;; 03AC38 : 69 00       ;
CODE_03AC3A:          STA $37                             ;; 03AC3A : 85 37       ;
CODE_03AC3C:          LDA RAM_FrameCounter                ;; 03AC3C : A5 13       ;
CODE_03AC3E:          AND.B #$03                          ;; 03AC3E : 29 03       ;
CODE_03AC40:          BNE Return03AC4C                    ;; 03AC40 : D0 0A       ;
CODE_03AC42:          LDA $38                             ;; 03AC42 : A5 38       ;
CODE_03AC44:          CMP.B #$80                          ;; 03AC44 : C9 80       ;
CODE_03AC46:          BCS CODE_03AC4D                     ;; 03AC46 : B0 05       ;
CODE_03AC48:          INC $38                             ;; 03AC48 : E6 38       ;
CODE_03AC4A:          INC $39                             ;; 03AC4A : E6 39       ;
Return03AC4C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC4D:          LDA.W $164A,X                       ;; 03AC4D : BD 4A 16    ;
CODE_03AC50:          BNE CODE_03AC5A                     ;; 03AC50 : D0 08       ;
CODE_03AC52:          LDA.B #$1C                          ;; 03AC52 : A9 1C       ;
CODE_03AC54:          STA.W $1DFB                         ;; 03AC54 : 8D FB 1D    ; / Change music 
CODE_03AC57:          INC.W $164A,X                       ;; 03AC57 : FE 4A 16    ;
CODE_03AC5A:          LDA.B #$FE                          ;; 03AC5A : A9 FE       ;
CODE_03AC5C:          STA.W RAM_SpriteXHi,X               ;; 03AC5C : 9D E0 14    ;
CODE_03AC5F:          STA.W RAM_SpriteYHi,X               ;; 03AC5F : 9D D4 14    ;
Return03AC62:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC63:          LDA.B #$08                          ;; 03AC63 : A9 08       ;
CODE_03AC65:          STA.W $14D0                         ;; 03AC65 : 8D D0 14    ;
CODE_03AC68:          LDA.B #$7C                          ;; 03AC68 : A9 7C       ;
CODE_03AC6A:          STA $A6                             ;; 03AC6A : 85 A6       ;
CODE_03AC6C:          LDA RAM_SpriteXLo,X                 ;; 03AC6C : B5 E4       ;
CODE_03AC6E:          CLC                                 ;; 03AC6E : 18          ;
CODE_03AC6F:          ADC.B #$08                          ;; 03AC6F : 69 08       ;
CODE_03AC71:          STA $EC                             ;; 03AC71 : 85 EC       ;
CODE_03AC73:          LDA.W RAM_SpriteXHi,X               ;; 03AC73 : BD E0 14    ;
CODE_03AC76:          ADC.B #$00                          ;; 03AC76 : 69 00       ;
CODE_03AC78:          STA.W $14E8                         ;; 03AC78 : 8D E8 14    ;
CODE_03AC7B:          LDA RAM_SpriteYLo,X                 ;; 03AC7B : B5 D8       ;
CODE_03AC7D:          CLC                                 ;; 03AC7D : 18          ;
CODE_03AC7E:          ADC.B #$47                          ;; 03AC7E : 69 47       ;
CODE_03AC80:          STA $E0                             ;; 03AC80 : 85 E0       ;
CODE_03AC82:          LDA.W RAM_SpriteYHi,X               ;; 03AC82 : BD D4 14    ;
CODE_03AC85:          ADC.B #$00                          ;; 03AC85 : 69 00       ;
CODE_03AC87:          STA.W $14DC                         ;; 03AC87 : 8D DC 14    ;
CODE_03AC8A:          PHX                                 ;; 03AC8A : DA          ;
CODE_03AC8B:          LDX.B #$08                          ;; 03AC8B : A2 08       ;
CODE_03AC8D:          JSL.L InitSpriteTables              ;; 03AC8D : 22 D2 F7 07 ;
CODE_03AC91:          PLX                                 ;; 03AC91 : FA          ;
Return03AC92:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BlushTileDispY:       .db $01,$11                         ;; ?QPWZ?               ;
                                                          ;;                      ;
BlushTiles:           .db $6E,$88                         ;; ?QPWZ?               ;
                                                          ;;                      ;
PrincessPeach:        LDA RAM_SpriteXLo,X                 ;; ?QPWZ? : B5 E4       ;
CODE_03AC99:          SEC                                 ;; 03AC99 : 38          ;
CODE_03AC9A:          SBC RAM_ScreenBndryXLo              ;; 03AC9A : E5 1A       ;
CODE_03AC9C:          STA $00                             ;; 03AC9C : 85 00       ;
CODE_03AC9E:          LDA RAM_SpriteYLo,X                 ;; 03AC9E : B5 D8       ;
CODE_03ACA0:          SEC                                 ;; 03ACA0 : 38          ;
CODE_03ACA1:          SBC RAM_ScreenBndryYLo              ;; 03ACA1 : E5 1C       ;
CODE_03ACA3:          STA $01                             ;; 03ACA3 : 85 01       ;
CODE_03ACA5:          LDA RAM_FrameCounter                ;; 03ACA5 : A5 13       ;
CODE_03ACA7:          AND.B #$7F                          ;; 03ACA7 : 29 7F       ;
CODE_03ACA9:          BNE CODE_03ACB8                     ;; 03ACA9 : D0 0D       ;
CODE_03ACAB:          JSL.L GetRand                       ;; 03ACAB : 22 F9 AC 01 ;
CODE_03ACAF:          AND.B #$07                          ;; 03ACAF : 29 07       ;
CODE_03ACB1:          BNE CODE_03ACB8                     ;; 03ACB1 : D0 05       ;
CODE_03ACB3:          LDA.B #$0C                          ;; 03ACB3 : A9 0C       ;
CODE_03ACB5:          STA.W RAM_DisableInter,X            ;; 03ACB5 : 9D 4C 15    ;
CODE_03ACB8:          LDY.W $1602,X                       ;; 03ACB8 : BC 02 16    ;
CODE_03ACBB:          LDA.W RAM_DisableInter,X            ;; 03ACBB : BD 4C 15    ;
CODE_03ACBE:          BEQ CODE_03ACC1                     ;; 03ACBE : F0 01       ;
CODE_03ACC0:          INY                                 ;; 03ACC0 : C8          ;
CODE_03ACC1:          LDA.W RAM_SpriteDir,X               ;; 03ACC1 : BD 7C 15    ;
CODE_03ACC4:          BNE CODE_03ACCB                     ;; 03ACC4 : D0 05       ;
CODE_03ACC6:          TYA                                 ;; 03ACC6 : 98          ;
CODE_03ACC7:          CLC                                 ;; 03ACC7 : 18          ;
CODE_03ACC8:          ADC.B #$08                          ;; 03ACC8 : 69 08       ;
CODE_03ACCA:          TAY                                 ;; 03ACCA : A8          ;
CODE_03ACCB:          STY $03                             ;; 03ACCB : 84 03       ;
CODE_03ACCD:          LDA.B #$D0                          ;; 03ACCD : A9 D0       ;
CODE_03ACCF:          STA.W RAM_SprOAMIndex,X             ;; 03ACCF : 9D EA 15    ;
CODE_03ACD2:          TAY                                 ;; 03ACD2 : A8          ;
CODE_03ACD3:          JSR.W CODE_03AAC8                   ;; 03ACD3 : 20 C8 AA    ;
CODE_03ACD6:          LDY.B #$02                          ;; 03ACD6 : A0 02       ;
CODE_03ACD8:          LDA.B #$03                          ;; 03ACD8 : A9 03       ;
CODE_03ACDA:          JSL.L FinishOAMWrite                ;; 03ACDA : 22 B3 B7 01 ;
CODE_03ACDE:          LDA.W $1558,X                       ;; 03ACDE : BD 58 15    ;
CODE_03ACE1:          BEQ CODE_03AD18                     ;; 03ACE1 : F0 35       ;
CODE_03ACE3:          PHX                                 ;; 03ACE3 : DA          ;
CODE_03ACE4:          LDX.B #$00                          ;; 03ACE4 : A2 00       ;
CODE_03ACE6:          LDA RAM_MarioPowerUp                ;; 03ACE6 : A5 19       ;
CODE_03ACE8:          BNE CODE_03ACEB                     ;; 03ACE8 : D0 01       ;
CODE_03ACEA:          INX                                 ;; 03ACEA : E8          ;
CODE_03ACEB:          LDY.B #$4C                          ;; 03ACEB : A0 4C       ;
CODE_03ACED:          LDA $7E                             ;; 03ACED : A5 7E       ;
CODE_03ACEF:          STA.W OAM_DispX,Y                   ;; 03ACEF : 99 00 03    ;
CODE_03ACF2:          LDA $80                             ;; 03ACF2 : A5 80       ;
CODE_03ACF4:          CLC                                 ;; 03ACF4 : 18          ;
CODE_03ACF5:          ADC.W BlushTileDispY,X              ;; 03ACF5 : 7D 93 AC    ;
CODE_03ACF8:          STA.W OAM_DispY,Y                   ;; 03ACF8 : 99 01 03    ;
CODE_03ACFB:          LDA.W BlushTiles,X                  ;; 03ACFB : BD 95 AC    ;
CODE_03ACFE:          STA.W OAM_Tile,Y                    ;; 03ACFE : 99 02 03    ;
CODE_03AD01:          PLX                                 ;; 03AD01 : FA          ;
CODE_03AD02:          LDA RAM_MarioDirection              ;; 03AD02 : A5 76       ;
CODE_03AD04:          CMP.B #$01                          ;; 03AD04 : C9 01       ;
CODE_03AD06:          LDA.B #$31                          ;; 03AD06 : A9 31       ;
CODE_03AD08:          BCC CODE_03AD0C                     ;; 03AD08 : 90 02       ;
CODE_03AD0A:          ORA.B #$40                          ;; 03AD0A : 09 40       ;
CODE_03AD0C:          STA.W OAM_Prop,Y                    ;; 03AD0C : 99 03 03    ;
CODE_03AD0F:          TYA                                 ;; 03AD0F : 98          ;
CODE_03AD10:          LSR                                 ;; 03AD10 : 4A          ;
CODE_03AD11:          LSR                                 ;; 03AD11 : 4A          ;
CODE_03AD12:          TAY                                 ;; 03AD12 : A8          ;
CODE_03AD13:          LDA.B #$02                          ;; 03AD13 : A9 02       ;
CODE_03AD15:          STA.W OAM_TileSize,Y                ;; 03AD15 : 99 60 04    ;
CODE_03AD18:          STZ RAM_SpriteSpeedX,X              ;; 03AD18 : 74 B6       ; Sprite X Speed = 0 
CODE_03AD1A:          STZ RAM_MarioSpeedX                 ;; 03AD1A : 64 7B       ;
CODE_03AD1C:          LDA.B #$04                          ;; 03AD1C : A9 04       ;
CODE_03AD1E:          STA.W $1602,X                       ;; 03AD1E : 9D 02 16    ;
CODE_03AD21:          LDA RAM_SpriteState,X               ;; 03AD21 : B5 C2       ;
CODE_03AD23:          JSL.L ExecutePtr                    ;; 03AD23 : 22 DF 86 00 ;
                                                          ;;                      ;
PeachPtrs:            .dw CODE_03AD37                     ;; ?QPWZ? : 37 AD       ;
                      .dw CODE_03ADB3                     ;; ?QPWZ? : B3 AD       ;
                      .dw CODE_03ADDD                     ;; ?QPWZ? : DD AD       ;
                      .dw CODE_03AE25                     ;; ?QPWZ? : 25 AE       ;
                      .dw CODE_03AE32                     ;; ?QPWZ? : 32 AE       ;
                      .dw CODE_03AEAF                     ;; ?QPWZ? : AF AE       ;
                      .dw CODE_03AEE8                     ;; ?QPWZ? : E8 AE       ;
                      .dw CODE_03C796                     ;; ?QPWZ? : 96 C7       ;
                                                          ;;                      ;
CODE_03AD37:          LDA.B #$06                          ;; 03AD37 : A9 06       ;
CODE_03AD39:          STA.W $1602,X                       ;; 03AD39 : 9D 02 16    ;
CODE_03AD3C:          JSL.L UpdateYPosNoGrvty             ;; 03AD3C : 22 1A 80 01 ;
CODE_03AD40:          LDA RAM_SpriteSpeedY,X              ;; 03AD40 : B5 AA       ;
CODE_03AD42:          CMP.B #$08                          ;; 03AD42 : C9 08       ;
CODE_03AD44:          BCS CODE_03AD4B                     ;; 03AD44 : B0 05       ;
CODE_03AD46:          CLC                                 ;; 03AD46 : 18          ;
CODE_03AD47:          ADC.B #$01                          ;; 03AD47 : 69 01       ;
CODE_03AD49:          STA RAM_SpriteSpeedY,X              ;; 03AD49 : 95 AA       ;
CODE_03AD4B:          LDA.W RAM_SpriteYHi,X               ;; 03AD4B : BD D4 14    ;
CODE_03AD4E:          BMI CODE_03AD63                     ;; 03AD4E : 30 13       ;
CODE_03AD50:          LDA RAM_SpriteYLo,X                 ;; 03AD50 : B5 D8       ;
CODE_03AD52:          CMP.B #$A0                          ;; 03AD52 : C9 A0       ;
CODE_03AD54:          BCC CODE_03AD63                     ;; 03AD54 : 90 0D       ;
CODE_03AD56:          LDA.B #$A0                          ;; 03AD56 : A9 A0       ;
CODE_03AD58:          STA RAM_SpriteYLo,X                 ;; 03AD58 : 95 D8       ;
CODE_03AD5A:          STZ RAM_SpriteSpeedY,X              ;; 03AD5A : 74 AA       ; Sprite Y Speed = 0 
CODE_03AD5C:          LDA.B #$A0                          ;; 03AD5C : A9 A0       ;
CODE_03AD5E:          STA.W $1540,X                       ;; 03AD5E : 9D 40 15    ;
CODE_03AD61:          INC RAM_SpriteState,X               ;; 03AD61 : F6 C2       ;
CODE_03AD63:          LDA RAM_FrameCounter                ;; 03AD63 : A5 13       ;
CODE_03AD65:          AND.B #$07                          ;; 03AD65 : 29 07       ;
CODE_03AD67:          BNE Return03AD73                    ;; 03AD67 : D0 0A       ;
CODE_03AD69:          LDY.B #$0B                          ;; 03AD69 : A0 0B       ;
CODE_03AD6B:          LDA.W $17F0,Y                       ;; 03AD6B : B9 F0 17    ;
CODE_03AD6E:          BEQ CODE_03AD74                     ;; 03AD6E : F0 04       ;
CODE_03AD70:          DEY                                 ;; 03AD70 : 88          ;
CODE_03AD71:          BPL CODE_03AD6B                     ;; 03AD71 : 10 F8       ;
Return03AD73:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AD74:          LDA.B #$05                          ;; 03AD74 : A9 05       ;
CODE_03AD76:          STA.W $17F0,Y                       ;; 03AD76 : 99 F0 17    ;
CODE_03AD79:          JSL.L GetRand                       ;; 03AD79 : 22 F9 AC 01 ;
CODE_03AD7D:          STZ $00                             ;; 03AD7D : 64 00       ;
CODE_03AD7F:          AND.B #$1F                          ;; 03AD7F : 29 1F       ;
CODE_03AD81:          CLC                                 ;; 03AD81 : 18          ;
CODE_03AD82:          ADC.B #$F8                          ;; 03AD82 : 69 F8       ;
CODE_03AD84:          BPL CODE_03AD88                     ;; 03AD84 : 10 02       ;
CODE_03AD86:          DEC $00                             ;; 03AD86 : C6 00       ;
CODE_03AD88:          CLC                                 ;; 03AD88 : 18          ;
CODE_03AD89:          ADC RAM_SpriteXLo,X                 ;; 03AD89 : 75 E4       ;
CODE_03AD8B:          STA.W $1808,Y                       ;; 03AD8B : 99 08 18    ;
CODE_03AD8E:          LDA.W RAM_SpriteXHi,X               ;; 03AD8E : BD E0 14    ;
CODE_03AD91:          ADC $00                             ;; 03AD91 : 65 00       ;
CODE_03AD93:          STA.W $18EA,Y                       ;; 03AD93 : 99 EA 18    ;
CODE_03AD96:          LDA.W RAM_RandomByte2               ;; 03AD96 : AD 8E 14    ;
CODE_03AD99:          AND.B #$1F                          ;; 03AD99 : 29 1F       ;
CODE_03AD9B:          ADC RAM_SpriteYLo,X                 ;; 03AD9B : 75 D8       ;
CODE_03AD9D:          STA.W $17FC,Y                       ;; 03AD9D : 99 FC 17    ;
CODE_03ADA0:          LDA.W RAM_SpriteYHi,X               ;; 03ADA0 : BD D4 14    ;
CODE_03ADA3:          ADC.B #$00                          ;; 03ADA3 : 69 00       ;
CODE_03ADA5:          STA.W $1814,Y                       ;; 03ADA5 : 99 14 18    ;
CODE_03ADA8:          LDA.B #$00                          ;; 03ADA8 : A9 00       ;
CODE_03ADAA:          STA.W $1820,Y                       ;; 03ADAA : 99 20 18    ;
CODE_03ADAD:          LDA.B #$17                          ;; 03ADAD : A9 17       ;
CODE_03ADAF:          STA.W $1850,Y                       ;; 03ADAF : 99 50 18    ;
Return03ADB2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ADB3:          LDA.W $1540,X                       ;; 03ADB3 : BD 40 15    ;
CODE_03ADB6:          BNE CODE_03ADC2                     ;; 03ADB6 : D0 0A       ;
CODE_03ADB8:          INC RAM_SpriteState,X               ;; 03ADB8 : F6 C2       ;
CODE_03ADBA:          JSR.W CODE_03ADCC                   ;; 03ADBA : 20 CC AD    ;
CODE_03ADBD:          BCC CODE_03ADC2                     ;; 03ADBD : 90 03       ;
ADDR_03ADBF:          INC.W $151C,X                       ;; 03ADBF : FE 1C 15    ;
CODE_03ADC2:          JSR.W SubHorzPosBnk3                ;; 03ADC2 : 20 17 B8    ;
CODE_03ADC5:          TYA                                 ;; 03ADC5 : 98          ;
CODE_03ADC6:          STA.W RAM_SpriteDir,X               ;; 03ADC6 : 9D 7C 15    ;
CODE_03ADC9:          STA RAM_MarioDirection              ;; 03ADC9 : 85 76       ;
Return03ADCB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ADCC:          JSL.L GetSpriteClippingA            ;; 03ADCC : 22 9F B6 03 ;
CODE_03ADD0:          JSL.L GetMarioClipping              ;; 03ADD0 : 22 64 B6 03 ;
CODE_03ADD4:          JSL.L CheckForContact               ;; 03ADD4 : 22 2B B7 03 ;
Return03ADD8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03ADD9:          .db $08,$F8,$F8,$08                 ;; 03ADD9               ;
                                                          ;;                      ;
CODE_03ADDD:          LDA RAM_FrameCounterB               ;; 03ADDD : A5 14       ;
CODE_03ADDF:          AND.B #$08                          ;; 03ADDF : 29 08       ;
CODE_03ADE1:          BNE CODE_03ADE8                     ;; 03ADE1 : D0 05       ;
CODE_03ADE3:          LDA.B #$08                          ;; 03ADE3 : A9 08       ;
CODE_03ADE5:          STA.W $1602,X                       ;; 03ADE5 : 9D 02 16    ;
CODE_03ADE8:          JSR.W CODE_03ADCC                   ;; 03ADE8 : 20 CC AD    ;
CODE_03ADEB:          PHP                                 ;; 03ADEB : 08          ;
CODE_03ADEC:          JSR.W SubHorzPosBnk3                ;; 03ADEC : 20 17 B8    ;
CODE_03ADEF:          PLP                                 ;; 03ADEF : 28          ;
CODE_03ADF0:          LDA.W $151C,X                       ;; 03ADF0 : BD 1C 15    ;
CODE_03ADF3:          BNE ADDR_03ADF9                     ;; 03ADF3 : D0 04       ;
CODE_03ADF5:          BCS CODE_03AE14                     ;; 03ADF5 : B0 1D       ;
CODE_03ADF7:          BRA CODE_03ADFF                     ;; 03ADF7 : 80 06       ;
                                                          ;;                      ;
ADDR_03ADF9:          BCC CODE_03AE14                     ;; 03ADF9 : 90 19       ;
ADDR_03ADFB:          TYA                                 ;; 03ADFB : 98          ;
ADDR_03ADFC:          EOR.B #$01                          ;; 03ADFC : 49 01       ;
ADDR_03ADFE:          TAY                                 ;; 03ADFE : A8          ;
CODE_03ADFF:          LDA.W DATA_03ADD9,Y                 ;; 03ADFF : B9 D9 AD    ;
CODE_03AE02:          STA RAM_SpriteSpeedX,X              ;; 03AE02 : 95 B6       ;
CODE_03AE04:          EOR.B #$FF                          ;; 03AE04 : 49 FF       ;
CODE_03AE06:          INC A                               ;; 03AE06 : 1A          ;
CODE_03AE07:          STA RAM_MarioSpeedX                 ;; 03AE07 : 85 7B       ;
CODE_03AE09:          TYA                                 ;; 03AE09 : 98          ;
CODE_03AE0A:          STA.W RAM_SpriteDir,X               ;; 03AE0A : 9D 7C 15    ;
CODE_03AE0D:          STA RAM_MarioDirection              ;; 03AE0D : 85 76       ;
CODE_03AE0F:          JSL.L UpdateXPosNoGrvty             ;; 03AE0F : 22 22 80 01 ;
Return03AE13:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE14:          JSR.W SubHorzPosBnk3                ;; 03AE14 : 20 17 B8    ;
CODE_03AE17:          TYA                                 ;; 03AE17 : 98          ;
CODE_03AE18:          STA.W RAM_SpriteDir,X               ;; 03AE18 : 9D 7C 15    ;
CODE_03AE1B:          STA RAM_MarioDirection              ;; 03AE1B : 85 76       ;
CODE_03AE1D:          INC RAM_SpriteState,X               ;; 03AE1D : F6 C2       ;
CODE_03AE1F:          LDA.B #$60                          ;; 03AE1F : A9 60       ;
CODE_03AE21:          STA.W $1540,X                       ;; 03AE21 : 9D 40 15    ;
Return03AE24:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE25:          LDA.W $1540,X                       ;; 03AE25 : BD 40 15    ;
CODE_03AE28:          BNE Return03AE31                    ;; 03AE28 : D0 07       ;
CODE_03AE2A:          INC RAM_SpriteState,X               ;; 03AE2A : F6 C2       ;
CODE_03AE2C:          LDA.B #$A0                          ;; 03AE2C : A9 A0       ;
CODE_03AE2E:          STA.W $1540,X                       ;; 03AE2E : 9D 40 15    ;
Return03AE31:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE32:          LDA.W $1540,X                       ;; 03AE32 : BD 40 15    ;
CODE_03AE35:          BNE CODE_03AE3F                     ;; 03AE35 : D0 08       ;
CODE_03AE37:          INC RAM_SpriteState,X               ;; 03AE37 : F6 C2       ;
CODE_03AE39:          STZ.W $188A                         ;; 03AE39 : 9C 8A 18    ;
CODE_03AE3C:          STZ.W $188B                         ;; 03AE3C : 9C 8B 18    ;
CODE_03AE3F:          CMP.B #$50                          ;; 03AE3F : C9 50       ;
CODE_03AE41:          BCC Return03AE5A                    ;; 03AE41 : 90 17       ;
CODE_03AE43:          PHA                                 ;; 03AE43 : 48          ;
CODE_03AE44:          BNE CODE_03AE4B                     ;; 03AE44 : D0 05       ;
CODE_03AE46:          LDA.B #$14                          ;; 03AE46 : A9 14       ;
CODE_03AE48:          STA.W RAM_DisableInter,X            ;; 03AE48 : 9D 4C 15    ;
CODE_03AE4B:          LDA.B #$0A                          ;; 03AE4B : A9 0A       ;
CODE_03AE4D:          STA.W $1602,X                       ;; 03AE4D : 9D 02 16    ;
CODE_03AE50:          PLA                                 ;; 03AE50 : 68          ;
CODE_03AE51:          CMP.B #$68                          ;; 03AE51 : C9 68       ;
CODE_03AE53:          BNE Return03AE5A                    ;; 03AE53 : D0 05       ;
CODE_03AE55:          LDA.B #$80                          ;; 03AE55 : A9 80       ;
CODE_03AE57:          STA.W $1558,X                       ;; 03AE57 : 9D 58 15    ;
Return03AE5A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AE5B:          .db $08,$08,$08,$08,$08,$08,$18,$08 ;; 03AE5B               ;
                      .db $08,$08,$08,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$08,$08,$20,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$20,$08,$08,$10 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $20,$08,$08,$08,$08,$08,$20,$08 ;; ?QPWZ?               ;
                      .db $04,$20,$08,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$08,$08,$10,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$10,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$40                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AEAF:          JSR.W CODE_03D674                   ;; 03AEAF : 20 74 D6    ;
CODE_03AEB2:          LDA.W $1540,X                       ;; 03AEB2 : BD 40 15    ;
CODE_03AEB5:          BNE Return03AEC7                    ;; 03AEB5 : D0 10       ;
CODE_03AEB7:          LDY.W $1921                         ;; 03AEB7 : AC 21 19    ;
CODE_03AEBA:          CPY.B #$54                          ;; 03AEBA : C0 54       ;
CODE_03AEBC:          BEQ CODE_03AEC8                     ;; 03AEBC : F0 0A       ;
CODE_03AEBE:          INC.W $1921                         ;; 03AEBE : EE 21 19    ;
CODE_03AEC1:          LDA.W DATA_03AE5B,Y                 ;; 03AEC1 : B9 5B AE    ;
CODE_03AEC4:          STA.W $1540,X                       ;; 03AEC4 : 9D 40 15    ;
Return03AEC7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AEC8:          INC RAM_SpriteState,X               ;; 03AEC8 : F6 C2       ;
CODE_03AECA:          LDA.B #$40                          ;; 03AECA : A9 40       ;
CODE_03AECC:          STA.W $1540,X                       ;; 03AECC : 9D 40 15    ;
Return03AECF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AED0:          INC RAM_SpriteState,X               ;; 03AED0 : F6 C2       ;
CODE_03AED2:          LDA.B #$80                          ;; 03AED2 : A9 80       ;
CODE_03AED4:          STA.W $1FEB                         ;; 03AED4 : 8D EB 1F    ;
Return03AED7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AED8:          .db $00,$00,$94,$18,$18,$9C,$9C,$FF ;; 03AED8               ;
                      .db $00,$00,$52,$63,$63,$73,$73,$7F ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AEE8:          LDA.W $1540,X                       ;; 03AEE8 : BD 40 15    ;
CODE_03AEEB:          BEQ CODE_03AED0                     ;; 03AEEB : F0 E3       ;
CODE_03AEED:          LSR                                 ;; 03AEED : 4A          ;
CODE_03AEEE:          STA $00                             ;; 03AEEE : 85 00       ;
CODE_03AEF0:          STZ $01                             ;; 03AEF0 : 64 01       ;
CODE_03AEF2:          REP #$20                            ;; 03AEF2 : C2 20       ; Accum (16 bit) 
CODE_03AEF4:          LDA $00                             ;; 03AEF4 : A5 00       ;
CODE_03AEF6:          ASL                                 ;; 03AEF6 : 0A          ;
CODE_03AEF7:          ASL                                 ;; 03AEF7 : 0A          ;
CODE_03AEF8:          ASL                                 ;; 03AEF8 : 0A          ;
CODE_03AEF9:          ASL                                 ;; 03AEF9 : 0A          ;
CODE_03AEFA:          ASL                                 ;; 03AEFA : 0A          ;
CODE_03AEFB:          ORA $00                             ;; 03AEFB : 05 00       ;
CODE_03AEFD:          STA $00                             ;; 03AEFD : 85 00       ;
CODE_03AEFF:          ASL                                 ;; 03AEFF : 0A          ;
CODE_03AF00:          ASL                                 ;; 03AF00 : 0A          ;
CODE_03AF01:          ASL                                 ;; 03AF01 : 0A          ;
CODE_03AF02:          ASL                                 ;; 03AF02 : 0A          ;
CODE_03AF03:          ASL                                 ;; 03AF03 : 0A          ;
CODE_03AF04:          ORA $00                             ;; 03AF04 : 05 00       ;
CODE_03AF06:          STA $00                             ;; 03AF06 : 85 00       ;
CODE_03AF08:          SEP #$20                            ;; 03AF08 : E2 20       ; Accum (8 bit) 
CODE_03AF0A:          PHX                                 ;; 03AF0A : DA          ;
CODE_03AF0B:          TAX                                 ;; 03AF0B : AA          ;
CODE_03AF0C:          LDY.W $0681                         ;; 03AF0C : AC 81 06    ;
CODE_03AF0F:          LDA.B #$02                          ;; 03AF0F : A9 02       ;
CODE_03AF11:          STA.W $0682,Y                       ;; 03AF11 : 99 82 06    ;
CODE_03AF14:          LDA.B #$F1                          ;; 03AF14 : A9 F1       ;
CODE_03AF16:          STA.W $0683,Y                       ;; 03AF16 : 99 83 06    ;
CODE_03AF19:          LDA $00                             ;; 03AF19 : A5 00       ;
CODE_03AF1B:          STA.W $0684,Y                       ;; 03AF1B : 99 84 06    ;
CODE_03AF1E:          LDA $01                             ;; 03AF1E : A5 01       ;
CODE_03AF20:          STA.W $0685,Y                       ;; 03AF20 : 99 85 06    ;
CODE_03AF23:          LDA.B #$00                          ;; 03AF23 : A9 00       ;
CODE_03AF25:          STA.W $0686,Y                       ;; 03AF25 : 99 86 06    ;
CODE_03AF28:          TYA                                 ;; 03AF28 : 98          ;
CODE_03AF29:          CLC                                 ;; 03AF29 : 18          ;
CODE_03AF2A:          ADC.B #$04                          ;; 03AF2A : 69 04       ;
CODE_03AF2C:          STA.W $0681                         ;; 03AF2C : 8D 81 06    ;
CODE_03AF2F:          PLX                                 ;; 03AF2F : FA          ;
CODE_03AF30:          JSR.W CODE_03D674                   ;; 03AF30 : 20 74 D6    ;
Return03AF33:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AF34:          .db $F4,$FF,$0C,$19,$24,$19,$0C,$FF ;; 03AF34               ;
DATA_03AF3C:          .db $FC,$F6,$F4,$F6,$FC,$02,$04,$02 ;; 03AF3C               ;
DATA_03AF44:          .db $05,$05,$05,$05,$45,$45,$45,$45 ;; 03AF44               ;
DATA_03AF4C:          .db $34,$34,$34,$35,$35,$36,$36,$37 ;; 03AF4C               ;
                      .db $38,$3A,$3E,$46,$54             ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AF59:          JSR.W GetDrawInfoBnk3               ;; 03AF59 : 20 60 B7    ;
CODE_03AF5C:          LDA.W RAM_SpriteDir,X               ;; 03AF5C : BD 7C 15    ;
CODE_03AF5F:          STA $04                             ;; 03AF5F : 85 04       ;
CODE_03AF61:          LDA RAM_FrameCounterB               ;; 03AF61 : A5 14       ;
CODE_03AF63:          LSR                                 ;; 03AF63 : 4A          ;
CODE_03AF64:          LSR                                 ;; 03AF64 : 4A          ;
CODE_03AF65:          AND.B #$07                          ;; 03AF65 : 29 07       ;
CODE_03AF67:          STA $02                             ;; 03AF67 : 85 02       ;
CODE_03AF69:          LDA.B #$EC                          ;; 03AF69 : A9 EC       ;
CODE_03AF6B:          STA.W RAM_SprOAMIndex,X             ;; 03AF6B : 9D EA 15    ;
CODE_03AF6E:          TAY                                 ;; 03AF6E : A8          ;
CODE_03AF6F:          PHX                                 ;; 03AF6F : DA          ;
CODE_03AF70:          LDX.B #$03                          ;; 03AF70 : A2 03       ;
CODE_03AF72:          PHX                                 ;; 03AF72 : DA          ;
CODE_03AF73:          TXA                                 ;; 03AF73 : 8A          ;
CODE_03AF74:          ASL                                 ;; 03AF74 : 0A          ;
CODE_03AF75:          ASL                                 ;; 03AF75 : 0A          ;
CODE_03AF76:          ADC $02                             ;; 03AF76 : 65 02       ;
CODE_03AF78:          AND.B #$07                          ;; 03AF78 : 29 07       ;
CODE_03AF7A:          TAX                                 ;; 03AF7A : AA          ;
CODE_03AF7B:          LDA $00                             ;; 03AF7B : A5 00       ;
CODE_03AF7D:          CLC                                 ;; 03AF7D : 18          ;
CODE_03AF7E:          ADC.W DATA_03AF34,X                 ;; 03AF7E : 7D 34 AF    ;
CODE_03AF81:          STA.W OAM_DispX,Y                   ;; 03AF81 : 99 00 03    ;
CODE_03AF84:          LDA $01                             ;; 03AF84 : A5 01       ;
CODE_03AF86:          CLC                                 ;; 03AF86 : 18          ;
CODE_03AF87:          ADC.W DATA_03AF3C,X                 ;; 03AF87 : 7D 3C AF    ;
CODE_03AF8A:          STA.W OAM_DispY,Y                   ;; 03AF8A : 99 01 03    ;
CODE_03AF8D:          LDA.B #$59                          ;; 03AF8D : A9 59       ;
CODE_03AF8F:          STA.W OAM_Tile,Y                    ;; 03AF8F : 99 02 03    ;
CODE_03AF92:          LDA.W DATA_03AF44,X                 ;; 03AF92 : BD 44 AF    ;
CODE_03AF95:          ORA $64                             ;; 03AF95 : 05 64       ;
CODE_03AF97:          STA.W OAM_Prop,Y                    ;; 03AF97 : 99 03 03    ;
CODE_03AF9A:          PLX                                 ;; 03AF9A : FA          ;
CODE_03AF9B:          INY                                 ;; 03AF9B : C8          ;
CODE_03AF9C:          INY                                 ;; 03AF9C : C8          ;
CODE_03AF9D:          INY                                 ;; 03AF9D : C8          ;
CODE_03AF9E:          INY                                 ;; 03AF9E : C8          ;
CODE_03AF9F:          DEX                                 ;; 03AF9F : CA          ;
CODE_03AFA0:          BPL CODE_03AF72                     ;; 03AFA0 : 10 D0       ;
CODE_03AFA2:          LDA.W $14B3                         ;; 03AFA2 : AD B3 14    ;
CODE_03AFA5:          INC.W $14B3                         ;; 03AFA5 : EE B3 14    ;
CODE_03AFA8:          LSR                                 ;; 03AFA8 : 4A          ;
CODE_03AFA9:          LSR                                 ;; 03AFA9 : 4A          ;
CODE_03AFAA:          LSR                                 ;; 03AFAA : 4A          ;
CODE_03AFAB:          CMP.B #$0D                          ;; 03AFAB : C9 0D       ;
CODE_03AFAD:          BCS CODE_03AFD7                     ;; 03AFAD : B0 28       ;
CODE_03AFAF:          TAX                                 ;; 03AFAF : AA          ;
CODE_03AFB0:          LDY.B #$FC                          ;; 03AFB0 : A0 FC       ;
CODE_03AFB2:          LDA $04                             ;; 03AFB2 : A5 04       ;
CODE_03AFB4:          ASL                                 ;; 03AFB4 : 0A          ;
CODE_03AFB5:          ROL                                 ;; 03AFB5 : 2A          ;
CODE_03AFB6:          ASL                                 ;; 03AFB6 : 0A          ;
CODE_03AFB7:          ASL                                 ;; 03AFB7 : 0A          ;
CODE_03AFB8:          ASL                                 ;; 03AFB8 : 0A          ;
CODE_03AFB9:          ADC $00                             ;; 03AFB9 : 65 00       ;
CODE_03AFBB:          CLC                                 ;; 03AFBB : 18          ;
CODE_03AFBC:          ADC.B #$15                          ;; 03AFBC : 69 15       ;
CODE_03AFBE:          STA.W OAM_DispX,Y                   ;; 03AFBE : 99 00 03    ;
CODE_03AFC1:          LDA $01                             ;; 03AFC1 : A5 01       ;
CODE_03AFC3:          CLC                                 ;; 03AFC3 : 18          ;
CODE_03AFC4:          ADC.L DATA_03AF4C,X                 ;; 03AFC4 : 7F 4C AF 03 ;
CODE_03AFC8:          STA.W OAM_DispY,Y                   ;; 03AFC8 : 99 01 03    ;
CODE_03AFCB:          LDA.B #$49                          ;; 03AFCB : A9 49       ;
CODE_03AFCD:          STA.W OAM_Tile,Y                    ;; 03AFCD : 99 02 03    ;
CODE_03AFD0:          LDA.B #$07                          ;; 03AFD0 : A9 07       ;
CODE_03AFD2:          ORA $64                             ;; 03AFD2 : 05 64       ;
CODE_03AFD4:          STA.W OAM_Prop,Y                    ;; 03AFD4 : 99 03 03    ;
CODE_03AFD7:          PLX                                 ;; 03AFD7 : FA          ;
CODE_03AFD8:          LDY.B #$00                          ;; 03AFD8 : A0 00       ;
CODE_03AFDA:          LDA.B #$04                          ;; 03AFDA : A9 04       ;
CODE_03AFDC:          JSL.L FinishOAMWrite                ;; 03AFDC : 22 B3 B7 01 ;
CODE_03AFE0:          LDY.W RAM_SprOAMIndex,X             ;; 03AFE0 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03AFE3:          PHX                                 ;; 03AFE3 : DA          ;
CODE_03AFE4:          LDX.B #$04                          ;; 03AFE4 : A2 04       ;
CODE_03AFE6:          LDA.W OAM_DispX,Y                   ;; 03AFE6 : B9 00 03    ;
CODE_03AFE9:          STA.W OAM_ExtendedDispX,Y           ;; 03AFE9 : 99 00 02    ;
CODE_03AFEC:          LDA.W OAM_DispY,Y                   ;; 03AFEC : B9 01 03    ;
CODE_03AFEF:          STA.W OAM_ExtendedDispY,Y           ;; 03AFEF : 99 01 02    ;
CODE_03AFF2:          LDA.W OAM_Tile,Y                    ;; 03AFF2 : B9 02 03    ;
CODE_03AFF5:          STA.W OAM_ExtendedTile,Y            ;; 03AFF5 : 99 02 02    ;
CODE_03AFF8:          LDA.W OAM_Prop,Y                    ;; 03AFF8 : B9 03 03    ;
CODE_03AFFB:          STA.W OAM_ExtendedProp,Y            ;; 03AFFB : 99 03 02    ;
CODE_03AFFE:          PHY                                 ;; 03AFFE : 5A          ;
CODE_03AFFF:          TYA                                 ;; 03AFFF : 98          ;
CODE_03B000:          LSR                                 ;; 03B000 : 4A          ;
CODE_03B001:          LSR                                 ;; 03B001 : 4A          ;
CODE_03B002:          TAY                                 ;; 03B002 : A8          ;
CODE_03B003:          LDA.W OAM_TileSize,Y                ;; 03B003 : B9 60 04    ;
CODE_03B006:          STA.W $0420,Y                       ;; 03B006 : 99 20 04    ;
CODE_03B009:          PLY                                 ;; 03B009 : 7A          ;
CODE_03B00A:          INY                                 ;; 03B00A : C8          ;
CODE_03B00B:          INY                                 ;; 03B00B : C8          ;
CODE_03B00C:          INY                                 ;; 03B00C : C8          ;
CODE_03B00D:          INY                                 ;; 03B00D : C8          ;
CODE_03B00E:          DEX                                 ;; 03B00E : CA          ;
CODE_03B00F:          BPL CODE_03AFE6                     ;; 03B00F : 10 D5       ;
CODE_03B011:          PLX                                 ;; 03B011 : FA          ;
Return03B012:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B013:          .db $00,$10                         ;; 03B013               ;
                                                          ;;                      ;
DATA_03B015:          .db $00,$00                         ;; 03B015               ;
                                                          ;;                      ;
DATA_03B017:          .db $F8,$08                         ;; 03B017               ;
                                                          ;;                      ;
CODE_03B019:          STZ $02                             ;; 03B019 : 64 02       ;
CODE_03B01B:          JSR.W CODE_03B020                   ;; 03B01B : 20 20 B0    ;
CODE_03B01E:          INC $02                             ;; 03B01E : E6 02       ;
CODE_03B020:          LDY.B #$01                          ;; 03B020 : A0 01       ;
CODE_03B022:          LDA.W $14C8,Y                       ;; 03B022 : B9 C8 14    ;
CODE_03B025:          BEQ CODE_03B02B                     ;; 03B025 : F0 04       ;
CODE_03B027:          DEY                                 ;; 03B027 : 88          ;
CODE_03B028:          BPL CODE_03B022                     ;; 03B028 : 10 F8       ;
Return03B02A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B02B:          LDA.B #$08                          ;; 03B02B : A9 08       ; \ Sprite status = Normal 
CODE_03B02D:          STA.W $14C8,Y                       ;; 03B02D : 99 C8 14    ; / 
CODE_03B030:          LDA.B #$A2                          ;; 03B030 : A9 A2       ;
CODE_03B032:          STA.W RAM_SpriteNum,Y               ;; 03B032 : 99 9E 00    ;
CODE_03B035:          LDA RAM_SpriteYLo,X                 ;; 03B035 : B5 D8       ;
CODE_03B037:          CLC                                 ;; 03B037 : 18          ;
CODE_03B038:          ADC.B #$10                          ;; 03B038 : 69 10       ;
CODE_03B03A:          STA.W RAM_SpriteYLo,Y               ;; 03B03A : 99 D8 00    ;
CODE_03B03D:          LDA.W RAM_SpriteYHi,X               ;; 03B03D : BD D4 14    ;
CODE_03B040:          ADC.B #$00                          ;; 03B040 : 69 00       ;
CODE_03B042:          STA.W RAM_SpriteYHi,Y               ;; 03B042 : 99 D4 14    ;
CODE_03B045:          LDA RAM_SpriteXLo,X                 ;; 03B045 : B5 E4       ;
CODE_03B047:          STA $00                             ;; 03B047 : 85 00       ;
CODE_03B049:          LDA.W RAM_SpriteXHi,X               ;; 03B049 : BD E0 14    ;
CODE_03B04C:          STA $01                             ;; 03B04C : 85 01       ;
CODE_03B04E:          PHX                                 ;; 03B04E : DA          ;
CODE_03B04F:          LDX $02                             ;; 03B04F : A6 02       ;
CODE_03B051:          LDA $00                             ;; 03B051 : A5 00       ;
CODE_03B053:          CLC                                 ;; 03B053 : 18          ;
CODE_03B054:          ADC.W DATA_03B013,X                 ;; 03B054 : 7D 13 B0    ;
CODE_03B057:          STA.W RAM_SpriteXLo,Y               ;; 03B057 : 99 E4 00    ;
CODE_03B05A:          LDA $01                             ;; 03B05A : A5 01       ;
CODE_03B05C:          ADC.W DATA_03B015,X                 ;; 03B05C : 7D 15 B0    ;
CODE_03B05F:          STA.W RAM_SpriteXHi,Y               ;; 03B05F : 99 E0 14    ;
CODE_03B062:          TYX                                 ;; 03B062 : BB          ;
CODE_03B063:          JSL.L InitSpriteTables              ;; 03B063 : 22 D2 F7 07 ;
CODE_03B067:          LDY $02                             ;; 03B067 : A4 02       ;
CODE_03B069:          LDA.W DATA_03B017,Y                 ;; 03B069 : B9 17 B0    ;
CODE_03B06C:          STA RAM_SpriteSpeedX,X              ;; 03B06C : 95 B6       ;
CODE_03B06E:          LDA.B #$C0                          ;; 03B06E : A9 C0       ;
CODE_03B070:          STA RAM_SpriteSpeedY,X              ;; 03B070 : 95 AA       ;
CODE_03B072:          PLX                                 ;; 03B072 : FA          ;
Return03B073:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B074:          .db $40,$C0                         ;; 03B074               ;
                                                          ;;                      ;
DATA_03B076:          .db $10,$F0                         ;; 03B076               ;
                                                          ;;                      ;
CODE_03B078:          LDA $38                             ;; 03B078 : A5 38       ;
CODE_03B07A:          CMP.B #$20                          ;; 03B07A : C9 20       ;
CODE_03B07C:          BNE Return03B0DB                    ;; 03B07C : D0 5D       ;
CODE_03B07E:          LDA.W $151C,X                       ;; 03B07E : BD 1C 15    ;
CODE_03B081:          CMP.B #$07                          ;; 03B081 : C9 07       ;
CODE_03B083:          BCC Return03B0F2                    ;; 03B083 : 90 6D       ;
CODE_03B085:          LDA $36                             ;; 03B085 : A5 36       ;
CODE_03B087:          ORA $37                             ;; 03B087 : 05 37       ;
CODE_03B089:          BNE Return03B0F2                    ;; 03B089 : D0 67       ;
CODE_03B08B:          JSR.W CODE_03B0DC                   ;; 03B08B : 20 DC B0    ;
CODE_03B08E:          LDA.W RAM_DisableInter,X            ;; 03B08E : BD 4C 15    ;
CODE_03B091:          BNE Return03B0DB                    ;; 03B091 : D0 48       ;
CODE_03B093:          LDA.B #$24                          ;; 03B093 : A9 24       ;
CODE_03B095:          STA.W RAM_Tweaker1662,X             ;; 03B095 : 9D 62 16    ;
CODE_03B098:          JSL.L MarioSprInteract              ;; 03B098 : 22 DC A7 01 ;
CODE_03B09C:          BCC CODE_03B0BD                     ;; 03B09C : 90 1F       ;
CODE_03B09E:          JSR.W CODE_03B0D6                   ;; 03B09E : 20 D6 B0    ;
CODE_03B0A1:          STZ RAM_MarioSpeedY                 ;; 03B0A1 : 64 7D       ;
CODE_03B0A3:          JSR.W SubHorzPosBnk3                ;; 03B0A3 : 20 17 B8    ;
CODE_03B0A6:          LDA.W $14B1                         ;; 03B0A6 : AD B1 14    ;
CODE_03B0A9:          ORA.W $14B6                         ;; 03B0A9 : 0D B6 14    ;
CODE_03B0AC:          BEQ CODE_03B0B3                     ;; 03B0AC : F0 05       ;
ADDR_03B0AE:          LDA.W DATA_03B076,Y                 ;; 03B0AE : B9 76 B0    ;
ADDR_03B0B1:          BRA CODE_03B0B6                     ;; 03B0B1 : 80 03       ;
                                                          ;;                      ;
CODE_03B0B3:          LDA.W DATA_03B074,Y                 ;; 03B0B3 : B9 74 B0    ;
CODE_03B0B6:          STA RAM_MarioSpeedX                 ;; 03B0B6 : 85 7B       ;
CODE_03B0B8:          LDA.B #$01                          ;; 03B0B8 : A9 01       ; \ Play sound effect 
CODE_03B0BA:          STA.W $1DF9                         ;; 03B0BA : 8D F9 1D    ; / 
CODE_03B0BD:          INC.W RAM_Tweaker1662,X             ;; 03B0BD : FE 62 16    ;
CODE_03B0C0:          JSL.L MarioSprInteract              ;; 03B0C0 : 22 DC A7 01 ;
CODE_03B0C4:          BCC CODE_03B0C9                     ;; 03B0C4 : 90 03       ;
ADDR_03B0C6:          JSR.W CODE_03B0D2                   ;; 03B0C6 : 20 D2 B0    ;
CODE_03B0C9:          INC.W RAM_Tweaker1662,X             ;; 03B0C9 : FE 62 16    ;
CODE_03B0CC:          JSL.L MarioSprInteract              ;; 03B0CC : 22 DC A7 01 ;
CODE_03B0D0:          BCC Return03B0DB                    ;; 03B0D0 : 90 09       ;
CODE_03B0D2:          JSL.L HurtMario                     ;; 03B0D2 : 22 B7 F5 00 ;
CODE_03B0D6:          LDA.B #$20                          ;; 03B0D6 : A9 20       ;
CODE_03B0D8:          STA.W RAM_DisableInter,X            ;; 03B0D8 : 9D 4C 15    ;
Return03B0DB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B0DC:          LDY.B #$01                          ;; 03B0DC : A0 01       ;
CODE_03B0DE:          PHY                                 ;; 03B0DE : 5A          ;
CODE_03B0DF:          LDA.W $14C8,Y                       ;; 03B0DF : B9 C8 14    ;
CODE_03B0E2:          CMP.B #$09                          ;; 03B0E2 : C9 09       ;
CODE_03B0E4:          BNE CODE_03B0EE                     ;; 03B0E4 : D0 08       ;
CODE_03B0E6:          LDA.W RAM_OffscreenHorz,Y           ;; 03B0E6 : B9 A0 15    ;
CODE_03B0E9:          BNE CODE_03B0EE                     ;; 03B0E9 : D0 03       ;
CODE_03B0EB:          JSR.W CODE_03B0F3                   ;; 03B0EB : 20 F3 B0    ;
CODE_03B0EE:          PLY                                 ;; 03B0EE : 7A          ;
CODE_03B0EF:          DEY                                 ;; 03B0EF : 88          ;
CODE_03B0F0:          BPL CODE_03B0DE                     ;; 03B0F0 : 10 EC       ;
Return03B0F2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B0F3:          PHX                                 ;; 03B0F3 : DA          ;
CODE_03B0F4:          TYX                                 ;; 03B0F4 : BB          ;
CODE_03B0F5:          JSL.L GetSpriteClippingB            ;; 03B0F5 : 22 E5 B6 03 ;
CODE_03B0F9:          PLX                                 ;; 03B0F9 : FA          ;
CODE_03B0FA:          LDA.B #$24                          ;; 03B0FA : A9 24       ;
CODE_03B0FC:          STA.W RAM_Tweaker1662,X             ;; 03B0FC : 9D 62 16    ;
CODE_03B0FF:          JSL.L GetSpriteClippingA            ;; 03B0FF : 22 9F B6 03 ;
CODE_03B103:          JSL.L CheckForContact               ;; 03B103 : 22 2B B7 03 ;
CODE_03B107:          BCS CODE_03B142                     ;; 03B107 : B0 39       ;
CODE_03B109:          INC.W RAM_Tweaker1662,X             ;; 03B109 : FE 62 16    ;
CODE_03B10C:          JSL.L GetSpriteClippingA            ;; 03B10C : 22 9F B6 03 ;
CODE_03B110:          JSL.L CheckForContact               ;; 03B110 : 22 2B B7 03 ;
CODE_03B114:          BCC Return03B160                    ;; 03B114 : 90 4A       ;
CODE_03B116:          LDA.W $14B5                         ;; 03B116 : AD B5 14    ;
CODE_03B119:          BNE Return03B160                    ;; 03B119 : D0 45       ;
CODE_03B11B:          LDA.B #$4C                          ;; 03B11B : A9 4C       ;
CODE_03B11D:          STA.W $14B5                         ;; 03B11D : 8D B5 14    ;
CODE_03B120:          STZ.W $14B3                         ;; 03B120 : 9C B3 14    ;
CODE_03B123:          LDA.W $151C,X                       ;; 03B123 : BD 1C 15    ;
CODE_03B126:          STA.W $14B4                         ;; 03B126 : 8D B4 14    ;
CODE_03B129:          LDA.B #$28                          ;; 03B129 : A9 28       ; \ Play sound effect 
CODE_03B12B:          STA.W $1DFC                         ;; 03B12B : 8D FC 1D    ; / 
CODE_03B12E:          LDA.W $151C,X                       ;; 03B12E : BD 1C 15    ;
CODE_03B131:          CMP.B #$09                          ;; 03B131 : C9 09       ;
CODE_03B133:          BNE CODE_03B142                     ;; 03B133 : D0 0D       ;
CODE_03B135:          LDA.W $187B,X                       ;; 03B135 : BD 7B 18    ;
CODE_03B138:          CMP.B #$01                          ;; 03B138 : C9 01       ;
CODE_03B13A:          BNE CODE_03B142                     ;; 03B13A : D0 06       ;
CODE_03B13C:          PHY                                 ;; 03B13C : 5A          ;
CODE_03B13D:          JSL.L KillMostSprites               ;; 03B13D : 22 C8 A6 03 ;
CODE_03B141:          PLY                                 ;; 03B141 : 7A          ;
CODE_03B142:          LDA.B #$00                          ;; 03B142 : A9 00       ;
CODE_03B144:          STA.W RAM_SpriteSpeedX,Y            ;; 03B144 : 99 B6 00    ;
CODE_03B147:          PHX                                 ;; 03B147 : DA          ;
CODE_03B148:          LDX.B #$10                          ;; 03B148 : A2 10       ;
CODE_03B14A:          LDA.W RAM_SpriteSpeedY,Y            ;; 03B14A : B9 AA 00    ;
CODE_03B14D:          BMI CODE_03B151                     ;; 03B14D : 30 02       ;
CODE_03B14F:          LDX.B #$D0                          ;; 03B14F : A2 D0       ;
CODE_03B151:          TXA                                 ;; 03B151 : 8A          ;
CODE_03B152:          STA.W RAM_SpriteSpeedY,Y            ;; 03B152 : 99 AA 00    ;
CODE_03B155:          LDA.B #$02                          ;; 03B155 : A9 02       ; \ Sprite status = Killed 
CODE_03B157:          STA.W $14C8,Y                       ;; 03B157 : 99 C8 14    ; / 
CODE_03B15A:          TYX                                 ;; 03B15A : BB          ;
CODE_03B15B:          JSL.L CODE_01AB6F                   ;; 03B15B : 22 6F AB 01 ;
CODE_03B15F:          PLX                                 ;; 03B15F : FA          ;
Return03B160:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserBallSpeed:      .db $10,$F0                         ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBowlingBall:    JSR.W BowserBallGfx                 ;; ?QPWZ? : 20 21 B2    ;
CODE_03B166:          LDA RAM_SpritesLocked               ;; 03B166 : A5 9D       ;
CODE_03B168:          BNE Return03B1D4                    ;; 03B168 : D0 6A       ;
CODE_03B16A:          JSR.W SubOffscreen0Bnk3             ;; 03B16A : 20 5D B8    ;
CODE_03B16D:          JSL.L MarioSprInteract              ;; 03B16D : 22 DC A7 01 ;
CODE_03B171:          JSL.L UpdateXPosNoGrvty             ;; 03B171 : 22 22 80 01 ;
CODE_03B175:          JSL.L UpdateYPosNoGrvty             ;; 03B175 : 22 1A 80 01 ;
CODE_03B179:          LDA RAM_SpriteSpeedY,X              ;; 03B179 : B5 AA       ;
CODE_03B17B:          CMP.B #$40                          ;; 03B17B : C9 40       ;
CODE_03B17D:          BPL CODE_03B186                     ;; 03B17D : 10 07       ;
CODE_03B17F:          CLC                                 ;; 03B17F : 18          ;
CODE_03B180:          ADC.B #$03                          ;; 03B180 : 69 03       ;
CODE_03B182:          STA RAM_SpriteSpeedY,X              ;; 03B182 : 95 AA       ;
CODE_03B184:          BRA CODE_03B18A                     ;; 03B184 : 80 04       ;
                                                          ;;                      ;
CODE_03B186:          LDA.B #$40                          ;; 03B186 : A9 40       ;
CODE_03B188:          STA RAM_SpriteSpeedY,X              ;; 03B188 : 95 AA       ;
CODE_03B18A:          LDA RAM_SpriteSpeedY,X              ;; 03B18A : B5 AA       ;
CODE_03B18C:          BMI CODE_03B1C5                     ;; 03B18C : 30 37       ;
CODE_03B18E:          LDA.W RAM_SpriteYHi,X               ;; 03B18E : BD D4 14    ;
CODE_03B191:          BMI CODE_03B1C5                     ;; 03B191 : 30 32       ;
CODE_03B193:          LDA RAM_SpriteYLo,X                 ;; 03B193 : B5 D8       ;
CODE_03B195:          CMP.B #$B0                          ;; 03B195 : C9 B0       ;
CODE_03B197:          BCC CODE_03B1C5                     ;; 03B197 : 90 2C       ;
CODE_03B199:          LDA.B #$B0                          ;; 03B199 : A9 B0       ;
CODE_03B19B:          STA RAM_SpriteYLo,X                 ;; 03B19B : 95 D8       ;
CODE_03B19D:          LDA RAM_SpriteSpeedY,X              ;; 03B19D : B5 AA       ;
CODE_03B19F:          CMP.B #$3E                          ;; 03B19F : C9 3E       ;
CODE_03B1A1:          BCC CODE_03B1AD                     ;; 03B1A1 : 90 0A       ;
CODE_03B1A3:          LDY.B #$25                          ;; 03B1A3 : A0 25       ; \ Play sound effect 
CODE_03B1A5:          STY.W $1DFC                         ;; 03B1A5 : 8C FC 1D    ; / 
CODE_03B1A8:          LDY.B #$20                          ;; 03B1A8 : A0 20       ; \ Set ground shake timer 
CODE_03B1AA:          STY.W RAM_ShakeGrndTimer            ;; 03B1AA : 8C 87 18    ; / 
CODE_03B1AD:          CMP.B #$08                          ;; 03B1AD : C9 08       ;
CODE_03B1AF:          BCC CODE_03B1B6                     ;; 03B1AF : 90 05       ;
CODE_03B1B1:          LDA.B #$01                          ;; 03B1B1 : A9 01       ; \ Play sound effect 
CODE_03B1B3:          STA.W $1DF9                         ;; 03B1B3 : 8D F9 1D    ; / 
CODE_03B1B6:          JSR.W CODE_03B7F8                   ;; 03B1B6 : 20 F8 B7    ;
CODE_03B1B9:          LDA RAM_SpriteSpeedX,X              ;; 03B1B9 : B5 B6       ;
CODE_03B1BB:          BNE CODE_03B1C5                     ;; 03B1BB : D0 08       ;
CODE_03B1BD:          JSR.W SubHorzPosBnk3                ;; 03B1BD : 20 17 B8    ;
CODE_03B1C0:          LDA.W BowserBallSpeed,Y             ;; 03B1C0 : B9 61 B1    ;
CODE_03B1C3:          STA RAM_SpriteSpeedX,X              ;; 03B1C3 : 95 B6       ;
CODE_03B1C5:          LDA RAM_SpriteSpeedX,X              ;; 03B1C5 : B5 B6       ;
CODE_03B1C7:          BEQ Return03B1D4                    ;; 03B1C7 : F0 0B       ;
CODE_03B1C9:          BMI CODE_03B1D1                     ;; 03B1C9 : 30 06       ;
CODE_03B1CB:          DEC.W $1570,X                       ;; 03B1CB : DE 70 15    ;
CODE_03B1CE:          DEC.W $1570,X                       ;; 03B1CE : DE 70 15    ;
CODE_03B1D1:          INC.W $1570,X                       ;; 03B1D1 : FE 70 15    ;
Return03B1D4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserBallDispX:      .db $F0,$00,$10,$F0,$00,$10,$F0,$00 ;; ?QPWZ?               ;
                      .db $10,$00,$00,$F8                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallDispY:      .db $E2,$E2,$E2,$F2,$F2,$F2,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$EA                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallTiles:      .db $45,$47,$45,$65,$66,$65,$45,$47 ;; ?QPWZ?               ;
                      .db $45,$39,$38,$63                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallGfxProp:    .db $0D,$0D,$4D,$0D,$0D,$4D,$8D,$8D ;; ?QPWZ?               ;
                      .db $CD,$0D,$0D,$0D                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallTileSize:   .db $02,$02,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$00,$00,$02                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallDispX2:     .db $04,$0D,$10,$0D,$04,$FB,$F8,$FB ;; ?QPWZ?               ;
BowserBallDispY2:     .db $00,$FD,$F4,$EB,$E8,$EB,$F4,$FD ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallGfx:        LDA.B #$70                          ;; ?QPWZ? : A9 70       ;
CODE_03B223:          STA.W RAM_SprOAMIndex,X             ;; 03B223 : 9D EA 15    ;
CODE_03B226:          JSR.W GetDrawInfoBnk3               ;; 03B226 : 20 60 B7    ;
CODE_03B229:          PHX                                 ;; 03B229 : DA          ;
CODE_03B22A:          LDX.B #$0B                          ;; 03B22A : A2 0B       ;
CODE_03B22C:          LDA $00                             ;; 03B22C : A5 00       ;
CODE_03B22E:          CLC                                 ;; 03B22E : 18          ;
CODE_03B22F:          ADC.W BowserBallDispX,X             ;; 03B22F : 7D D5 B1    ;
CODE_03B232:          STA.W OAM_DispX,Y                   ;; 03B232 : 99 00 03    ;
CODE_03B235:          LDA $01                             ;; 03B235 : A5 01       ;
CODE_03B237:          CLC                                 ;; 03B237 : 18          ;
CODE_03B238:          ADC.W BowserBallDispY,X             ;; 03B238 : 7D E1 B1    ;
CODE_03B23B:          STA.W OAM_DispY,Y                   ;; 03B23B : 99 01 03    ;
CODE_03B23E:          LDA.W BowserBallTiles,X             ;; 03B23E : BD ED B1    ;
CODE_03B241:          STA.W OAM_Tile,Y                    ;; 03B241 : 99 02 03    ;
CODE_03B244:          LDA.W BowserBallGfxProp,X           ;; 03B244 : BD F9 B1    ;
CODE_03B247:          ORA $64                             ;; 03B247 : 05 64       ;
CODE_03B249:          STA.W OAM_Prop,Y                    ;; 03B249 : 99 03 03    ;
CODE_03B24C:          PHY                                 ;; 03B24C : 5A          ;
CODE_03B24D:          TYA                                 ;; 03B24D : 98          ;
CODE_03B24E:          LSR                                 ;; 03B24E : 4A          ;
CODE_03B24F:          LSR                                 ;; 03B24F : 4A          ;
CODE_03B250:          TAY                                 ;; 03B250 : A8          ;
CODE_03B251:          LDA.W BowserBallTileSize,X          ;; 03B251 : BD 05 B2    ;
CODE_03B254:          STA.W OAM_TileSize,Y                ;; 03B254 : 99 60 04    ;
CODE_03B257:          PLY                                 ;; 03B257 : 7A          ;
CODE_03B258:          INY                                 ;; 03B258 : C8          ;
CODE_03B259:          INY                                 ;; 03B259 : C8          ;
CODE_03B25A:          INY                                 ;; 03B25A : C8          ;
CODE_03B25B:          INY                                 ;; 03B25B : C8          ;
CODE_03B25C:          DEX                                 ;; 03B25C : CA          ;
CODE_03B25D:          BPL CODE_03B22C                     ;; 03B25D : 10 CD       ;
CODE_03B25F:          PLX                                 ;; 03B25F : FA          ;
CODE_03B260:          PHX                                 ;; 03B260 : DA          ;
CODE_03B261:          LDY.W RAM_SprOAMIndex,X             ;; 03B261 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03B264:          LDA.W $1570,X                       ;; 03B264 : BD 70 15    ;
CODE_03B267:          LSR                                 ;; 03B267 : 4A          ;
CODE_03B268:          LSR                                 ;; 03B268 : 4A          ;
CODE_03B269:          LSR                                 ;; 03B269 : 4A          ;
CODE_03B26A:          AND.B #$07                          ;; 03B26A : 29 07       ;
CODE_03B26C:          PHA                                 ;; 03B26C : 48          ;
CODE_03B26D:          TAX                                 ;; 03B26D : AA          ;
CODE_03B26E:          LDA.W OAM_Tile2DispX,Y              ;; 03B26E : B9 04 03    ;
CODE_03B271:          CLC                                 ;; 03B271 : 18          ;
CODE_03B272:          ADC.W BowserBallDispX2,X            ;; 03B272 : 7D 11 B2    ;
CODE_03B275:          STA.W OAM_Tile2DispX,Y              ;; 03B275 : 99 04 03    ;
CODE_03B278:          LDA.W OAM_Tile2DispY,Y              ;; 03B278 : B9 05 03    ;
CODE_03B27B:          CLC                                 ;; 03B27B : 18          ;
CODE_03B27C:          ADC.W BowserBallDispY2,X            ;; 03B27C : 7D 19 B2    ;
CODE_03B27F:          STA.W OAM_Tile2DispY,Y              ;; 03B27F : 99 05 03    ;
CODE_03B282:          PLA                                 ;; 03B282 : 68          ;
CODE_03B283:          CLC                                 ;; 03B283 : 18          ;
CODE_03B284:          ADC.B #$02                          ;; 03B284 : 69 02       ;
CODE_03B286:          AND.B #$07                          ;; 03B286 : 29 07       ;
CODE_03B288:          TAX                                 ;; 03B288 : AA          ;
CODE_03B289:          LDA.W OAM_Tile3DispX,Y              ;; 03B289 : B9 08 03    ;
CODE_03B28C:          CLC                                 ;; 03B28C : 18          ;
CODE_03B28D:          ADC.W BowserBallDispX2,X            ;; 03B28D : 7D 11 B2    ;
CODE_03B290:          STA.W OAM_Tile3DispX,Y              ;; 03B290 : 99 08 03    ;
CODE_03B293:          LDA.W OAM_Tile3DispY,Y              ;; 03B293 : B9 09 03    ;
CODE_03B296:          CLC                                 ;; 03B296 : 18          ;
CODE_03B297:          ADC.W BowserBallDispY2,X            ;; 03B297 : 7D 19 B2    ;
CODE_03B29A:          STA.W OAM_Tile3DispY,Y              ;; 03B29A : 99 09 03    ;
CODE_03B29D:          PLX                                 ;; 03B29D : FA          ;
CODE_03B29E:          LDA.B #$0B                          ;; 03B29E : A9 0B       ;
CODE_03B2A0:          LDY.B #$FF                          ;; 03B2A0 : A0 FF       ;
CODE_03B2A2:          JSL.L FinishOAMWrite                ;; 03B2A2 : 22 B3 B7 01 ;
Return03B2A6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechakoopaSpeed:      .db $08,$F8                         ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopa:           JSL.L CODE_03B307                   ;; ?QPWZ? : 22 07 B3 03 ;
CODE_03B2AD:          LDA.W $14C8,X                       ;; 03B2AD : BD C8 14    ;
CODE_03B2B0:          CMP.B #$08                          ;; 03B2B0 : C9 08       ;
CODE_03B2B2:          BNE Return03B306                    ;; 03B2B2 : D0 52       ;
CODE_03B2B4:          LDA RAM_SpritesLocked               ;; 03B2B4 : A5 9D       ;
CODE_03B2B6:          BNE Return03B306                    ;; 03B2B6 : D0 4E       ;
CODE_03B2B8:          JSR.W SubOffscreen0Bnk3             ;; 03B2B8 : 20 5D B8    ;
CODE_03B2BB:          JSL.L SprSpr+MarioSprRts            ;; 03B2BB : 22 3A 80 01 ;
CODE_03B2BF:          JSL.L UpdateSpritePos               ;; 03B2BF : 22 2A 80 01 ;
CODE_03B2C3:          LDA.W RAM_SprObjStatus,X            ;; 03B2C3 : BD 88 15    ; \ Branch if not on ground 
CODE_03B2C6:          AND.B #$04                          ;; 03B2C6 : 29 04       ;  | 
CODE_03B2C8:          BEQ CODE_03B2E3                     ;; 03B2C8 : F0 19       ; / 
CODE_03B2CA:          STZ RAM_SpriteSpeedY,X              ;; 03B2CA : 74 AA       ; Sprite Y Speed = 0 
CODE_03B2CC:          LDY.W RAM_SpriteDir,X               ;; 03B2CC : BC 7C 15    ;
CODE_03B2CF:          LDA.W MechakoopaSpeed,Y             ;; 03B2CF : B9 A7 B2    ;
CODE_03B2D2:          STA RAM_SpriteSpeedX,X              ;; 03B2D2 : 95 B6       ;
CODE_03B2D4:          LDA RAM_SpriteState,X               ;; 03B2D4 : B5 C2       ;
CODE_03B2D6:          INC RAM_SpriteState,X               ;; 03B2D6 : F6 C2       ;
CODE_03B2D8:          AND.B #$3F                          ;; 03B2D8 : 29 3F       ;
CODE_03B2DA:          BNE CODE_03B2E3                     ;; 03B2DA : D0 07       ;
CODE_03B2DC:          JSR.W SubHorzPosBnk3                ;; 03B2DC : 20 17 B8    ;
CODE_03B2DF:          TYA                                 ;; 03B2DF : 98          ;
CODE_03B2E0:          STA.W RAM_SpriteDir,X               ;; 03B2E0 : 9D 7C 15    ;
CODE_03B2E3:          LDA.W RAM_SprObjStatus,X            ;; 03B2E3 : BD 88 15    ; \ Branch if not touching object 
CODE_03B2E6:          AND.B #$03                          ;; 03B2E6 : 29 03       ;  | 
CODE_03B2E8:          BEQ CODE_03B2F9                     ;; 03B2E8 : F0 0F       ; / 
ADDR_03B2EA:          LDA RAM_SpriteSpeedX,X              ;; 03B2EA : B5 B6       ;
ADDR_03B2EC:          EOR.B #$FF                          ;; 03B2EC : 49 FF       ;
ADDR_03B2EE:          INC A                               ;; 03B2EE : 1A          ;
ADDR_03B2EF:          STA RAM_SpriteSpeedX,X              ;; 03B2EF : 95 B6       ;
ADDR_03B2F1:          LDA.W RAM_SpriteDir,X               ;; 03B2F1 : BD 7C 15    ;
ADDR_03B2F4:          EOR.B #$01                          ;; 03B2F4 : 49 01       ;
ADDR_03B2F6:          STA.W RAM_SpriteDir,X               ;; 03B2F6 : 9D 7C 15    ;
CODE_03B2F9:          INC.W $1570,X                       ;; 03B2F9 : FE 70 15    ;
CODE_03B2FC:          LDA.W $1570,X                       ;; 03B2FC : BD 70 15    ;
CODE_03B2FF:          AND.B #$0C                          ;; 03B2FF : 29 0C       ;
CODE_03B301:          LSR                                 ;; 03B301 : 4A          ;
CODE_03B302:          LSR                                 ;; 03B302 : 4A          ;
CODE_03B303:          STA.W $1602,X                       ;; 03B303 : 9D 02 16    ;
Return03B306:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B307:          PHB                                 ;; 03B307 : 8B          ; Wrapper 
CODE_03B308:          PHK                                 ;; 03B308 : 4B          ;
CODE_03B309:          PLB                                 ;; 03B309 : AB          ;
CODE_03B30A:          JSR.W MechaKoopaGfx                 ;; 03B30A : 20 55 B3    ;
CODE_03B30D:          PLB                                 ;; 03B30D : AB          ;
Return03B30E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechakoopaDispX:      .db $F8,$08,$F8,$00,$08,$00,$10,$00 ;; ?QPWZ?               ;
MechakoopaDispY:      .db $F8,$F8,$08,$00,$F9,$F9,$09,$00 ;; ?QPWZ?               ;
                      .db $F8,$F8,$08,$00,$F9,$F9,$09,$00 ;; ?QPWZ?               ;
                      .db $FD,$00,$05,$00,$00,$00,$08,$00 ;; ?QPWZ?               ;
MechakoopaTiles:      .db $40,$42,$60,$51,$40,$42,$60,$0A ;; ?QPWZ?               ;
                      .db $40,$42,$60,$0C,$40,$42,$60,$0E ;; ?QPWZ?               ;
                      .db $00,$02,$10,$01,$00,$02,$10,$01 ;; ?QPWZ?               ;
MechakoopaGfxProp:    .db $00,$00,$00,$00,$40,$40,$40,$40 ;; ?QPWZ?               ;
MechakoopaTileSize:   .db $02,$00,$00,$02                 ;; ?QPWZ?               ;
                                                          ;;                      ;
MechakoopaPalette:    .db $0B,$05                         ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopaGfx:        LDA.B #$0B                          ;; ?QPWZ? : A9 0B       ;
CODE_03B357:          STA.W RAM_SpritePal,X               ;; 03B357 : 9D F6 15    ;
CODE_03B35A:          LDA.W $1540,X                       ;; 03B35A : BD 40 15    ;
CODE_03B35D:          BEQ CODE_03B37F                     ;; 03B35D : F0 20       ;
CODE_03B35F:          LDY.B #$05                          ;; 03B35F : A0 05       ;
CODE_03B361:          CMP.B #$05                          ;; 03B361 : C9 05       ;
CODE_03B363:          BCC CODE_03B369                     ;; 03B363 : 90 04       ;
CODE_03B365:          CMP.B #$FA                          ;; 03B365 : C9 FA       ;
CODE_03B367:          BCC CODE_03B36B                     ;; 03B367 : 90 02       ;
CODE_03B369:          LDY.B #$04                          ;; 03B369 : A0 04       ;
CODE_03B36B:          TYA                                 ;; 03B36B : 98          ;
CODE_03B36C:          STA.W $1602,X                       ;; 03B36C : 9D 02 16    ;
CODE_03B36F:          LDA.W $1540,X                       ;; 03B36F : BD 40 15    ;
CODE_03B372:          CMP.B #$30                          ;; 03B372 : C9 30       ;
CODE_03B374:          BCS CODE_03B37F                     ;; 03B374 : B0 09       ;
CODE_03B376:          AND.B #$01                          ;; 03B376 : 29 01       ;
CODE_03B378:          TAY                                 ;; 03B378 : A8          ;
CODE_03B379:          LDA.W MechakoopaPalette,Y           ;; 03B379 : B9 53 B3    ;
CODE_03B37C:          STA.W RAM_SpritePal,X               ;; 03B37C : 9D F6 15    ;
CODE_03B37F:          JSR.W GetDrawInfoBnk3               ;; 03B37F : 20 60 B7    ;
CODE_03B382:          LDA.W RAM_SpritePal,X               ;; 03B382 : BD F6 15    ;
CODE_03B385:          STA $04                             ;; 03B385 : 85 04       ;
CODE_03B387:          TYA                                 ;; 03B387 : 98          ;
CODE_03B388:          CLC                                 ;; 03B388 : 18          ;
CODE_03B389:          ADC.B #$0C                          ;; 03B389 : 69 0C       ;
CODE_03B38B:          TAY                                 ;; 03B38B : A8          ;
CODE_03B38C:          LDA.W $1602,X                       ;; 03B38C : BD 02 16    ;
CODE_03B38F:          ASL                                 ;; 03B38F : 0A          ;
CODE_03B390:          ASL                                 ;; 03B390 : 0A          ;
CODE_03B391:          STA $03                             ;; 03B391 : 85 03       ;
CODE_03B393:          LDA.W RAM_SpriteDir,X               ;; 03B393 : BD 7C 15    ;
CODE_03B396:          ASL                                 ;; 03B396 : 0A          ;
CODE_03B397:          ASL                                 ;; 03B397 : 0A          ;
CODE_03B398:          EOR.B #$04                          ;; 03B398 : 49 04       ;
CODE_03B39A:          STA $02                             ;; 03B39A : 85 02       ;
CODE_03B39C:          PHX                                 ;; 03B39C : DA          ;
CODE_03B39D:          LDX.B #$03                          ;; 03B39D : A2 03       ;
CODE_03B39F:          PHX                                 ;; 03B39F : DA          ;
CODE_03B3A0:          PHY                                 ;; 03B3A0 : 5A          ;
CODE_03B3A1:          TYA                                 ;; 03B3A1 : 98          ;
CODE_03B3A2:          LSR                                 ;; 03B3A2 : 4A          ;
CODE_03B3A3:          LSR                                 ;; 03B3A3 : 4A          ;
CODE_03B3A4:          TAY                                 ;; 03B3A4 : A8          ;
CODE_03B3A5:          LDA.W MechakoopaTileSize,X          ;; 03B3A5 : BD 4F B3    ;
CODE_03B3A8:          STA.W OAM_TileSize,Y                ;; 03B3A8 : 99 60 04    ;
CODE_03B3AB:          PLY                                 ;; 03B3AB : 7A          ;
CODE_03B3AC:          PLA                                 ;; 03B3AC : 68          ;
CODE_03B3AD:          PHA                                 ;; 03B3AD : 48          ;
CODE_03B3AE:          CLC                                 ;; 03B3AE : 18          ;
CODE_03B3AF:          ADC $02                             ;; 03B3AF : 65 02       ;
CODE_03B3B1:          TAX                                 ;; 03B3B1 : AA          ;
CODE_03B3B2:          LDA $00                             ;; 03B3B2 : A5 00       ;
CODE_03B3B4:          CLC                                 ;; 03B3B4 : 18          ;
CODE_03B3B5:          ADC.W MechakoopaDispX,X             ;; 03B3B5 : 7D 0F B3    ;
CODE_03B3B8:          STA.W OAM_DispX,Y                   ;; 03B3B8 : 99 00 03    ;
CODE_03B3BB:          LDA.W MechakoopaGfxProp,X           ;; 03B3BB : BD 47 B3    ;
CODE_03B3BE:          ORA $04                             ;; 03B3BE : 05 04       ;
CODE_03B3C0:          ORA $64                             ;; 03B3C0 : 05 64       ;
CODE_03B3C2:          STA.W OAM_Prop,Y                    ;; 03B3C2 : 99 03 03    ;
CODE_03B3C5:          PLA                                 ;; 03B3C5 : 68          ;
CODE_03B3C6:          PHA                                 ;; 03B3C6 : 48          ;
CODE_03B3C7:          CLC                                 ;; 03B3C7 : 18          ;
CODE_03B3C8:          ADC $03                             ;; 03B3C8 : 65 03       ;
CODE_03B3CA:          TAX                                 ;; 03B3CA : AA          ;
CODE_03B3CB:          LDA.W MechakoopaTiles,X             ;; 03B3CB : BD 2F B3    ;
CODE_03B3CE:          STA.W OAM_Tile,Y                    ;; 03B3CE : 99 02 03    ;
CODE_03B3D1:          LDA $01                             ;; 03B3D1 : A5 01       ;
CODE_03B3D3:          CLC                                 ;; 03B3D3 : 18          ;
CODE_03B3D4:          ADC.W MechakoopaDispY,X             ;; 03B3D4 : 7D 17 B3    ;
CODE_03B3D7:          STA.W OAM_DispY,Y                   ;; 03B3D7 : 99 01 03    ;
CODE_03B3DA:          PLX                                 ;; 03B3DA : FA          ;
CODE_03B3DB:          DEY                                 ;; 03B3DB : 88          ;
CODE_03B3DC:          DEY                                 ;; 03B3DC : 88          ;
CODE_03B3DD:          DEY                                 ;; 03B3DD : 88          ;
CODE_03B3DE:          DEY                                 ;; 03B3DE : 88          ;
CODE_03B3DF:          DEX                                 ;; 03B3DF : CA          ;
CODE_03B3E0:          BPL CODE_03B39F                     ;; 03B3E0 : 10 BD       ;
CODE_03B3E2:          PLX                                 ;; 03B3E2 : FA          ;
CODE_03B3E3:          LDY.B #$FF                          ;; 03B3E3 : A0 FF       ;
CODE_03B3E5:          LDA.B #$03                          ;; 03B3E5 : A9 03       ;
CODE_03B3E7:          JSL.L FinishOAMWrite                ;; 03B3E7 : 22 B3 B7 01 ;
CODE_03B3EB:          JSR.W MechaKoopaKeyGfx              ;; 03B3EB : 20 F7 B3    ;
Return03B3EE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechaKeyDispX:        .db $F9,$0F                         ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKeyGfxProp:      .db $4D,$0D                         ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKeyTiles:        .db $70,$71,$72,$71                 ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopaKeyGfx:     LDA.W RAM_SprOAMIndex,X             ;; ?QPWZ? : BD EA 15    ;
CODE_03B3FA:          CLC                                 ;; 03B3FA : 18          ;
CODE_03B3FB:          ADC.B #$10                          ;; 03B3FB : 69 10       ;
CODE_03B3FD:          STA.W RAM_SprOAMIndex,X             ;; 03B3FD : 9D EA 15    ;
CODE_03B400:          JSR.W GetDrawInfoBnk3               ;; 03B400 : 20 60 B7    ;
CODE_03B403:          PHX                                 ;; 03B403 : DA          ;
CODE_03B404:          LDA.W $1570,X                       ;; 03B404 : BD 70 15    ;
CODE_03B407:          LSR                                 ;; 03B407 : 4A          ;
CODE_03B408:          LSR                                 ;; 03B408 : 4A          ;
CODE_03B409:          AND.B #$03                          ;; 03B409 : 29 03       ;
CODE_03B40B:          STA $02                             ;; 03B40B : 85 02       ;
CODE_03B40D:          LDA.W RAM_SpriteDir,X               ;; 03B40D : BD 7C 15    ;
CODE_03B410:          TAX                                 ;; 03B410 : AA          ;
CODE_03B411:          LDA $00                             ;; 03B411 : A5 00       ;
CODE_03B413:          CLC                                 ;; 03B413 : 18          ;
CODE_03B414:          ADC.W MechaKeyDispX,X               ;; 03B414 : 7D EF B3    ;
CODE_03B417:          STA.W OAM_DispX,Y                   ;; 03B417 : 99 00 03    ;
CODE_03B41A:          LDA $01                             ;; 03B41A : A5 01       ;
CODE_03B41C:          SEC                                 ;; 03B41C : 38          ;
CODE_03B41D:          SBC.B #$00                          ;; 03B41D : E9 00       ;
CODE_03B41F:          STA.W OAM_DispY,Y                   ;; 03B41F : 99 01 03    ;
CODE_03B422:          LDA.W MechaKeyGfxProp,X             ;; 03B422 : BD F1 B3    ;
CODE_03B425:          ORA $64                             ;; 03B425 : 05 64       ;
CODE_03B427:          STA.W OAM_Prop,Y                    ;; 03B427 : 99 03 03    ;
CODE_03B42A:          LDX $02                             ;; 03B42A : A6 02       ;
CODE_03B42C:          LDA.W MechaKeyTiles,X               ;; 03B42C : BD F3 B3    ;
CODE_03B42F:          STA.W OAM_Tile,Y                    ;; 03B42F : 99 02 03    ;
CODE_03B432:          PLX                                 ;; 03B432 : FA          ;
CODE_03B433:          LDY.B #$00                          ;; 03B433 : A0 00       ;
CODE_03B435:          LDA.B #$00                          ;; 03B435 : A9 00       ;
CODE_03B437:          JSL.L FinishOAMWrite                ;; 03B437 : 22 B3 B7 01 ;
Return03B43B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B43C:          JSR.W BowserItemBoxGfx              ;; 03B43C : 20 4F B4    ;
CODE_03B43F:          JSR.W BowserSceneGfx                ;; 03B43F : 20 AC B4    ;
Return03B442:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserItemBoxPosX:    .db $70,$80,$70,$80                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxPosY:    .db $07,$07,$17,$17                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxProp:    .db $37,$77,$B7,$F7                 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxGfx:     LDA.W $190D                         ;; ?QPWZ? : AD 0D 19    ;
CODE_03B452:          BEQ CODE_03B457                     ;; 03B452 : F0 03       ;
CODE_03B454:          STZ.W $0DC2                         ;; 03B454 : 9C C2 0D    ;
CODE_03B457:          LDA.W $0DC2                         ;; 03B457 : AD C2 0D    ;
CODE_03B45A:          BEQ Return03B48B                    ;; 03B45A : F0 2F       ;
CODE_03B45C:          PHX                                 ;; 03B45C : DA          ;
CODE_03B45D:          LDX.B #$03                          ;; 03B45D : A2 03       ;
CODE_03B45F:          LDY.B #$04                          ;; 03B45F : A0 04       ;
CODE_03B461:          LDA.W BowserItemBoxPosX,X           ;; 03B461 : BD 43 B4    ;
CODE_03B464:          STA.W OAM_ExtendedDispX,Y           ;; 03B464 : 99 00 02    ;
CODE_03B467:          LDA.W BowserItemBoxPosY,X           ;; 03B467 : BD 47 B4    ;
CODE_03B46A:          STA.W OAM_ExtendedDispY,Y           ;; 03B46A : 99 01 02    ;
CODE_03B46D:          LDA.B #$43                          ;; 03B46D : A9 43       ;
CODE_03B46F:          STA.W OAM_ExtendedTile,Y            ;; 03B46F : 99 02 02    ;
CODE_03B472:          LDA.W BowserItemBoxProp,X           ;; 03B472 : BD 4B B4    ;
CODE_03B475:          STA.W OAM_ExtendedProp,Y            ;; 03B475 : 99 03 02    ;
CODE_03B478:          PHY                                 ;; 03B478 : 5A          ;
CODE_03B479:          TYA                                 ;; 03B479 : 98          ;
CODE_03B47A:          LSR                                 ;; 03B47A : 4A          ;
CODE_03B47B:          LSR                                 ;; 03B47B : 4A          ;
CODE_03B47C:          TAY                                 ;; 03B47C : A8          ;
CODE_03B47D:          LDA.B #$02                          ;; 03B47D : A9 02       ;
CODE_03B47F:          STA.W $0420,Y                       ;; 03B47F : 99 20 04    ;
CODE_03B482:          PLY                                 ;; 03B482 : 7A          ;
CODE_03B483:          INY                                 ;; 03B483 : C8          ;
CODE_03B484:          INY                                 ;; 03B484 : C8          ;
CODE_03B485:          INY                                 ;; 03B485 : C8          ;
CODE_03B486:          INY                                 ;; 03B486 : C8          ;
CODE_03B487:          DEX                                 ;; 03B487 : CA          ;
CODE_03B488:          BPL CODE_03B461                     ;; 03B488 : 10 D7       ;
CODE_03B48A:          PLX                                 ;; 03B48A : FA          ;
Return03B48B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserRoofPosX:       .db $00,$30,$60,$90,$C0,$F0,$00,$30 ;; ?QPWZ?               ;
                      .db $40,$50,$60,$90,$A0,$B0,$C0,$F0 ;; ?QPWZ?               ;
BowserRoofPosY:       .db $B0,$B0,$B0,$B0,$B0,$B0,$D0,$D0 ;; ?QPWZ?               ;
                      .db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0 ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserSceneGfx:       PHX                                 ;; ?QPWZ? : DA          ;
CODE_03B4AD:          LDY.B #$BC                          ;; 03B4AD : A0 BC       ;
CODE_03B4AF:          STZ $01                             ;; 03B4AF : 64 01       ;
CODE_03B4B1:          LDA.W $190D                         ;; 03B4B1 : AD 0D 19    ;
CODE_03B4B4:          STA $0F                             ;; 03B4B4 : 85 0F       ;
CODE_03B4B6:          CMP.B #$01                          ;; 03B4B6 : C9 01       ;
CODE_03B4B8:          LDX.B #$10                          ;; 03B4B8 : A2 10       ;
CODE_03B4BA:          BCC CODE_03B4BF                     ;; 03B4BA : 90 03       ;
CODE_03B4BC:          LDY.B #$90                          ;; 03B4BC : A0 90       ;
CODE_03B4BE:          DEX                                 ;; 03B4BE : CA          ;
CODE_03B4BF:          LDA.B #$C0                          ;; 03B4BF : A9 C0       ;
CODE_03B4C1:          SEC                                 ;; 03B4C1 : 38          ;
CODE_03B4C2:          SBC RAM_ScreenBndryYLo              ;; 03B4C2 : E5 1C       ;
CODE_03B4C4:          STA.W OAM_DispY,Y                   ;; 03B4C4 : 99 01 03    ;
CODE_03B4C7:          LDA $01                             ;; 03B4C7 : A5 01       ;
CODE_03B4C9:          SEC                                 ;; 03B4C9 : 38          ;
CODE_03B4CA:          SBC RAM_ScreenBndryXLo              ;; 03B4CA : E5 1A       ;
CODE_03B4CC:          STA.W OAM_DispX,Y                   ;; 03B4CC : 99 00 03    ;
CODE_03B4CF:          CLC                                 ;; 03B4CF : 18          ;
CODE_03B4D0:          ADC.B #$10                          ;; 03B4D0 : 69 10       ;
CODE_03B4D2:          STA $01                             ;; 03B4D2 : 85 01       ;
CODE_03B4D4:          LDA.B #$08                          ;; 03B4D4 : A9 08       ;
CODE_03B4D6:          STA.W OAM_Tile,Y                    ;; 03B4D6 : 99 02 03    ;
CODE_03B4D9:          LDA.B #$0D                          ;; 03B4D9 : A9 0D       ;
CODE_03B4DB:          ORA $64                             ;; 03B4DB : 05 64       ;
CODE_03B4DD:          STA.W OAM_Prop,Y                    ;; 03B4DD : 99 03 03    ;
CODE_03B4E0:          PHY                                 ;; 03B4E0 : 5A          ;
CODE_03B4E1:          TYA                                 ;; 03B4E1 : 98          ;
CODE_03B4E2:          LSR                                 ;; 03B4E2 : 4A          ;
CODE_03B4E3:          LSR                                 ;; 03B4E3 : 4A          ;
CODE_03B4E4:          TAY                                 ;; 03B4E4 : A8          ;
CODE_03B4E5:          LDA.B #$02                          ;; 03B4E5 : A9 02       ;
CODE_03B4E7:          STA.W OAM_TileSize,Y                ;; 03B4E7 : 99 60 04    ;
CODE_03B4EA:          PLY                                 ;; 03B4EA : 7A          ;
CODE_03B4EB:          INY                                 ;; 03B4EB : C8          ;
CODE_03B4EC:          INY                                 ;; 03B4EC : C8          ;
CODE_03B4ED:          INY                                 ;; 03B4ED : C8          ;
CODE_03B4EE:          INY                                 ;; 03B4EE : C8          ;
CODE_03B4EF:          DEX                                 ;; 03B4EF : CA          ;
CODE_03B4F0:          BPL CODE_03B4BF                     ;; 03B4F0 : 10 CD       ;
CODE_03B4F2:          LDX.B #$0F                          ;; 03B4F2 : A2 0F       ;
CODE_03B4F4:          LDA $0F                             ;; 03B4F4 : A5 0F       ;
CODE_03B4F6:          BNE CODE_03B532                     ;; 03B4F6 : D0 3A       ;
CODE_03B4F8:          LDY.B #$14                          ;; 03B4F8 : A0 14       ;
CODE_03B4FA:          LDA.W BowserRoofPosX,X              ;; 03B4FA : BD 8C B4    ;
CODE_03B4FD:          SEC                                 ;; 03B4FD : 38          ;
CODE_03B4FE:          SBC RAM_ScreenBndryXLo              ;; 03B4FE : E5 1A       ;
CODE_03B500:          STA.W OAM_ExtendedDispX,Y           ;; 03B500 : 99 00 02    ;
CODE_03B503:          LDA.W BowserRoofPosY,X              ;; 03B503 : BD 9C B4    ;
CODE_03B506:          SEC                                 ;; 03B506 : 38          ;
CODE_03B507:          SBC RAM_ScreenBndryYLo              ;; 03B507 : E5 1C       ;
CODE_03B509:          STA.W OAM_ExtendedDispY,Y           ;; 03B509 : 99 01 02    ;
CODE_03B50C:          LDA.B #$08                          ;; 03B50C : A9 08       ;
CODE_03B50E:          CPX.B #$06                          ;; 03B50E : E0 06       ;
CODE_03B510:          BCS CODE_03B514                     ;; 03B510 : B0 02       ;
CODE_03B512:          LDA.B #$03                          ;; 03B512 : A9 03       ;
CODE_03B514:          STA.W OAM_ExtendedTile,Y            ;; 03B514 : 99 02 02    ;
CODE_03B517:          LDA.B #$0D                          ;; 03B517 : A9 0D       ;
CODE_03B519:          ORA $64                             ;; 03B519 : 05 64       ;
CODE_03B51B:          STA.W OAM_ExtendedProp,Y            ;; 03B51B : 99 03 02    ;
CODE_03B51E:          PHY                                 ;; 03B51E : 5A          ;
CODE_03B51F:          TYA                                 ;; 03B51F : 98          ;
CODE_03B520:          LSR                                 ;; 03B520 : 4A          ;
CODE_03B521:          LSR                                 ;; 03B521 : 4A          ;
CODE_03B522:          TAY                                 ;; 03B522 : A8          ;
CODE_03B523:          LDA.B #$02                          ;; 03B523 : A9 02       ;
CODE_03B525:          STA.W $0420,Y                       ;; 03B525 : 99 20 04    ;
CODE_03B528:          PLY                                 ;; 03B528 : 7A          ;
CODE_03B529:          INY                                 ;; 03B529 : C8          ;
CODE_03B52A:          INY                                 ;; 03B52A : C8          ;
CODE_03B52B:          INY                                 ;; 03B52B : C8          ;
CODE_03B52C:          INY                                 ;; 03B52C : C8          ;
CODE_03B52D:          DEX                                 ;; 03B52D : CA          ;
CODE_03B52E:          BPL CODE_03B4FA                     ;; 03B52E : 10 CA       ;
CODE_03B530:          BRA CODE_03B56A                     ;; 03B530 : 80 38       ;
                                                          ;;                      ;
CODE_03B532:          LDY.B #$50                          ;; 03B532 : A0 50       ;
CODE_03B534:          LDA.W BowserRoofPosX,X              ;; 03B534 : BD 8C B4    ;
CODE_03B537:          SEC                                 ;; 03B537 : 38          ;
CODE_03B538:          SBC RAM_ScreenBndryXLo              ;; 03B538 : E5 1A       ;
CODE_03B53A:          STA.W OAM_DispX,Y                   ;; 03B53A : 99 00 03    ;
CODE_03B53D:          LDA.W BowserRoofPosY,X              ;; 03B53D : BD 9C B4    ;
CODE_03B540:          SEC                                 ;; 03B540 : 38          ;
CODE_03B541:          SBC RAM_ScreenBndryYLo              ;; 03B541 : E5 1C       ;
CODE_03B543:          STA.W OAM_DispY,Y                   ;; 03B543 : 99 01 03    ;
CODE_03B546:          LDA.B #$08                          ;; 03B546 : A9 08       ;
CODE_03B548:          CPX.B #$06                          ;; 03B548 : E0 06       ;
CODE_03B54A:          BCS CODE_03B54E                     ;; 03B54A : B0 02       ;
CODE_03B54C:          LDA.B #$03                          ;; 03B54C : A9 03       ;
CODE_03B54E:          STA.W OAM_Tile,Y                    ;; 03B54E : 99 02 03    ;
CODE_03B551:          LDA.B #$0D                          ;; 03B551 : A9 0D       ;
CODE_03B553:          ORA $64                             ;; 03B553 : 05 64       ;
CODE_03B555:          STA.W OAM_Prop,Y                    ;; 03B555 : 99 03 03    ;
CODE_03B558:          PHY                                 ;; 03B558 : 5A          ;
CODE_03B559:          TYA                                 ;; 03B559 : 98          ;
CODE_03B55A:          LSR                                 ;; 03B55A : 4A          ;
CODE_03B55B:          LSR                                 ;; 03B55B : 4A          ;
CODE_03B55C:          TAY                                 ;; 03B55C : A8          ;
CODE_03B55D:          LDA.B #$02                          ;; 03B55D : A9 02       ;
CODE_03B55F:          STA.W OAM_TileSize,Y                ;; 03B55F : 99 60 04    ;
CODE_03B562:          PLY                                 ;; 03B562 : 7A          ;
CODE_03B563:          INY                                 ;; 03B563 : C8          ;
CODE_03B564:          INY                                 ;; 03B564 : C8          ;
CODE_03B565:          INY                                 ;; 03B565 : C8          ;
CODE_03B566:          INY                                 ;; 03B566 : C8          ;
CODE_03B567:          DEX                                 ;; 03B567 : CA          ;
CODE_03B568:          BPL CODE_03B534                     ;; 03B568 : 10 CA       ;
CODE_03B56A:          PLX                                 ;; 03B56A : FA          ;
Return03B56B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
SprClippingDispX:     .db $02,$02,$10,$14,$00,$00,$01,$08 ;; ?QPWZ?               ;
                      .db $F8,$FE,$03,$06,$01,$00,$06,$02 ;; ?QPWZ?               ;
                      .db $00,$E8,$FC,$FC,$04,$00,$FC,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$02,$00,$02,$E0,$F0 ;; ?QPWZ?               ;
                      .db $FC,$FC,$00,$F8,$F4,$F2,$00,$FC ;; ?QPWZ?               ;
                      .db $F2,$F0,$02,$00,$F8,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $08,$00,$00,$00,$FC,$03,$08,$00 ;; ?QPWZ?               ;
                      .db $08,$04,$F8,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingWidth:     .db $0C,$0C,$10,$08,$30,$50,$0E,$28 ;; ?QPWZ?               ;
                      .db $20,$14,$01,$03,$0D,$0F,$14,$24 ;; ?QPWZ?               ;
                      .db $0F,$40,$08,$08,$18,$0F,$18,$0C ;; ?QPWZ?               ;
                      .db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30 ;; ?QPWZ?               ;
                      .db $08,$08,$10,$20,$38,$3C,$20,$18 ;; ?QPWZ?               ;
                      .db $1C,$20,$0C,$10,$10,$08,$1C,$1C ;; ?QPWZ?               ;
                      .db $10,$30,$30,$40,$08,$12,$34,$0F ;; ?QPWZ?               ;
                      .db $20,$08,$20,$10                 ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingDispY:     .db $03,$03,$FE,$08,$FE,$FE,$02,$08 ;; ?QPWZ?               ;
                      .db $FE,$08,$07,$06,$FE,$FC,$06,$FE ;; ?QPWZ?               ;
                      .db $FE,$E8,$10,$10,$02,$FE,$F4,$08 ;; ?QPWZ?               ;
                      .db $13,$23,$33,$43,$0A,$FD,$F8,$FC ;; ?QPWZ?               ;
                      .db $E8,$10,$00,$E8,$20,$04,$58,$FC ;; ?QPWZ?               ;
                      .db $E8,$FC,$F8,$02,$F8,$04,$FE,$FE ;; ?QPWZ?               ;
                      .db $F2,$FE,$FE,$FE,$FC,$00,$08,$F8 ;; ?QPWZ?               ;
                      .db $10,$03,$10,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingHeight:    .db $0A,$15,$12,$08,$0E,$0E,$18,$30 ;; ?QPWZ?               ;
                      .db $10,$1E,$02,$03,$16,$10,$14,$12 ;; ?QPWZ?               ;
                      .db $20,$40,$34,$74,$0C,$0E,$18,$45 ;; ?QPWZ?               ;
                      .db $3A,$2A,$1A,$0A,$30,$1B,$20,$12 ;; ?QPWZ?               ;
                      .db $18,$18,$10,$20,$38,$14,$08,$18 ;; ?QPWZ?               ;
                      .db $28,$1B,$13,$4C,$10,$04,$22,$20 ;; ?QPWZ?               ;
                      .db $1C,$12,$12,$12,$08,$20,$2E,$14 ;; ?QPWZ?               ;
                      .db $28,$0A,$10,$0D                 ;; ?QPWZ?               ;
                                                          ;;                      ;
MairoClipDispY:       .db $06,$14,$10,$18                 ;; ?QPWZ?               ;
                                                          ;;                      ;
MarioClippingHeight:  .db $1A,$0C,$20,$18                 ;; ?QPWZ?               ;
                                                          ;;                      ;
GetMarioClipping:     PHX                                 ;; ?QPWZ? : DA          ;
CODE_03B665:          LDA RAM_MarioXPos                   ;; 03B665 : A5 94       ; \ 
CODE_03B667:          CLC                                 ;; 03B667 : 18          ;  | 
CODE_03B668:          ADC.B #$02                          ;; 03B668 : 69 02       ;  | 
CODE_03B66A:          STA $00                             ;; 03B66A : 85 00       ;  | $00 = (Mario X position + #$02) Low byte 
CODE_03B66C:          LDA RAM_MarioXPosHi                 ;; 03B66C : A5 95       ;  | 
CODE_03B66E:          ADC.B #$00                          ;; 03B66E : 69 00       ;  | 
CODE_03B670:          STA $08                             ;; 03B670 : 85 08       ; / $08 = (Mario X position + #$02) High byte 
CODE_03B672:          LDA.B #$0C                          ;; 03B672 : A9 0C       ; \ $06 = Clipping width X (#$0C) 
CODE_03B674:          STA $02                             ;; 03B674 : 85 02       ; / 
CODE_03B676:          LDX.B #$00                          ;; 03B676 : A2 00       ; \ If mario small or ducking, X = #$01 
CODE_03B678:          LDA RAM_IsDucking                   ;; 03B678 : A5 73       ;  | else, X = #$00 
CODE_03B67A:          BNE CODE_03B680                     ;; 03B67A : D0 04       ;  | 
CODE_03B67C:          LDA RAM_MarioPowerUp                ;; 03B67C : A5 19       ;  | 
CODE_03B67E:          BNE CODE_03B681                     ;; 03B67E : D0 01       ;  | 
CODE_03B680:          INX                                 ;; 03B680 : E8          ; / 
CODE_03B681:          LDA.W RAM_OnYoshi                   ;; 03B681 : AD 7A 18    ; \ If on Yoshi, X += #$02 
CODE_03B684:          BEQ CODE_03B688                     ;; 03B684 : F0 02       ;  | 
CODE_03B686:          INX                                 ;; 03B686 : E8          ;  | 
CODE_03B687:          INX                                 ;; 03B687 : E8          ; / 
CODE_03B688:          LDA.L MarioClippingHeight,X         ;; 03B688 : BF 60 B6 03 ; \ $03 = Clipping height 
CODE_03B68C:          STA $03                             ;; 03B68C : 85 03       ; / 
CODE_03B68E:          LDA RAM_MarioYPos                   ;; 03B68E : A5 96       ; \ 
CODE_03B690:          CLC                                 ;; 03B690 : 18          ;  | 
CODE_03B691:          ADC.L MairoClipDispY,X              ;; 03B691 : 7F 5C B6 03 ;  | 
CODE_03B695:          STA $01                             ;; 03B695 : 85 01       ;  | $01 = (Mario Y position + displacement) Low byte 
CODE_03B697:          LDA RAM_MarioYPosHi                 ;; 03B697 : A5 97       ;  | 
CODE_03B699:          ADC.B #$00                          ;; 03B699 : 69 00       ;  | 
CODE_03B69B:          STA $09                             ;; 03B69B : 85 09       ; / $09 = (Mario Y position + displacement) High byte 
CODE_03B69D:          PLX                                 ;; 03B69D : FA          ;
Return03B69E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
GetSpriteClippingA:   PHY                                 ;; ?QPWZ? : 5A          ;
CODE_03B6A0:          PHX                                 ;; 03B6A0 : DA          ;
CODE_03B6A1:          TXY                                 ;; 03B6A1 : 9B          ; Y = Sprite index 
CODE_03B6A2:          LDA.W RAM_Tweaker1662,X             ;; 03B6A2 : BD 62 16    ; \ X = Clipping table index 
CODE_03B6A5:          AND.B #$3F                          ;; 03B6A5 : 29 3F       ;  | 
CODE_03B6A7:          TAX                                 ;; 03B6A7 : AA          ; / 
CODE_03B6A8:          STZ $0F                             ;; 03B6A8 : 64 0F       ; \ 
CODE_03B6AA:          LDA.L SprClippingDispX,X            ;; 03B6AA : BF 6C B5 03 ;  | Load low byte of X displacement 
CODE_03B6AE:          BPL CODE_03B6B2                     ;; 03B6AE : 10 02       ;  | 
CODE_03B6B0:          DEC $0F                             ;; 03B6B0 : C6 0F       ;  | $0F = High byte of X displacement 
CODE_03B6B2:          CLC                                 ;; 03B6B2 : 18          ;  | 
CODE_03B6B3:          ADC.W RAM_SpriteXLo,Y               ;; 03B6B3 : 79 E4 00    ;  | 
CODE_03B6B6:          STA $04                             ;; 03B6B6 : 85 04       ;  | $04 = (Sprite X position + displacement) Low byte 
CODE_03B6B8:          LDA.W RAM_SpriteXHi,Y               ;; 03B6B8 : B9 E0 14    ;  | 
CODE_03B6BB:          ADC $0F                             ;; 03B6BB : 65 0F       ;  | 
CODE_03B6BD:          STA $0A                             ;; 03B6BD : 85 0A       ; / $0A = (Sprite X position + displacement) High byte 
CODE_03B6BF:          LDA.L SprClippingWidth,X            ;; 03B6BF : BF A8 B5 03 ; \ $06 = Clipping width 
CODE_03B6C3:          STA $06                             ;; 03B6C3 : 85 06       ; / 
CODE_03B6C5:          STZ $0F                             ;; 03B6C5 : 64 0F       ; \ 
CODE_03B6C7:          LDA.L SprClippingDispY,X            ;; 03B6C7 : BF E4 B5 03 ;  | Load low byte of Y displacement 
CODE_03B6CB:          BPL CODE_03B6CF                     ;; 03B6CB : 10 02       ;  | 
CODE_03B6CD:          DEC $0F                             ;; 03B6CD : C6 0F       ;  | $0F = High byte of Y displacement 
CODE_03B6CF:          CLC                                 ;; 03B6CF : 18          ;  | 
CODE_03B6D0:          ADC.W RAM_SpriteYLo,Y               ;; 03B6D0 : 79 D8 00    ;  | 
CODE_03B6D3:          STA $05                             ;; 03B6D3 : 85 05       ;  | $05 = (Sprite Y position + displacement) Low byte 
CODE_03B6D5:          LDA.W RAM_SpriteYHi,Y               ;; 03B6D5 : B9 D4 14    ;  | 
CODE_03B6D8:          ADC $0F                             ;; 03B6D8 : 65 0F       ;  | 
CODE_03B6DA:          STA $0B                             ;; 03B6DA : 85 0B       ; / $0B = (Sprite Y position + displacement) High byte 
CODE_03B6DC:          LDA.L SprClippingHeight,X           ;; 03B6DC : BF 20 B6 03 ; \ $07 = Clipping height 
CODE_03B6E0:          STA $07                             ;; 03B6E0 : 85 07       ; / 
CODE_03B6E2:          PLX                                 ;; 03B6E2 : FA          ; X = Sprite index 
CODE_03B6E3:          PLY                                 ;; 03B6E3 : 7A          ;
Return03B6E4:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
GetSpriteClippingB:   PHY                                 ;; ?QPWZ? : 5A          ;
CODE_03B6E6:          PHX                                 ;; 03B6E6 : DA          ;
CODE_03B6E7:          TXY                                 ;; 03B6E7 : 9B          ; Y = Sprite index 
CODE_03B6E8:          LDA.W RAM_Tweaker1662,X             ;; 03B6E8 : BD 62 16    ; \ X = Clipping table index 
CODE_03B6EB:          AND.B #$3F                          ;; 03B6EB : 29 3F       ;  | 
CODE_03B6ED:          TAX                                 ;; 03B6ED : AA          ; / 
CODE_03B6EE:          STZ $0F                             ;; 03B6EE : 64 0F       ; \ 
CODE_03B6F0:          LDA.L SprClippingDispX,X            ;; 03B6F0 : BF 6C B5 03 ;  | Load low byte of X displacement 
CODE_03B6F4:          BPL CODE_03B6F8                     ;; 03B6F4 : 10 02       ;  | 
CODE_03B6F6:          DEC $0F                             ;; 03B6F6 : C6 0F       ;  | $0F = High byte of X displacement 
CODE_03B6F8:          CLC                                 ;; 03B6F8 : 18          ;  | 
CODE_03B6F9:          ADC.W RAM_SpriteXLo,Y               ;; 03B6F9 : 79 E4 00    ;  | 
CODE_03B6FC:          STA $00                             ;; 03B6FC : 85 00       ;  | $00 = (Sprite X position + displacement) Low byte 
CODE_03B6FE:          LDA.W RAM_SpriteXHi,Y               ;; 03B6FE : B9 E0 14    ;  | 
CODE_03B701:          ADC $0F                             ;; 03B701 : 65 0F       ;  | 
CODE_03B703:          STA $08                             ;; 03B703 : 85 08       ; / $08 = (Sprite X position + displacement) High byte 
CODE_03B705:          LDA.L SprClippingWidth,X            ;; 03B705 : BF A8 B5 03 ; \ $02 = Clipping width 
CODE_03B709:          STA $02                             ;; 03B709 : 85 02       ; / 
CODE_03B70B:          STZ $0F                             ;; 03B70B : 64 0F       ; \ 
CODE_03B70D:          LDA.L SprClippingDispY,X            ;; 03B70D : BF E4 B5 03 ;  | Load low byte of Y displacement 
CODE_03B711:          BPL CODE_03B715                     ;; 03B711 : 10 02       ;  | 
CODE_03B713:          DEC $0F                             ;; 03B713 : C6 0F       ;  | $0F = High byte of Y displacement 
CODE_03B715:          CLC                                 ;; 03B715 : 18          ;  | 
CODE_03B716:          ADC.W RAM_SpriteYLo,Y               ;; 03B716 : 79 D8 00    ;  | 
CODE_03B719:          STA $01                             ;; 03B719 : 85 01       ;  | $01 = (Sprite Y position + displacement) Low byte 
CODE_03B71B:          LDA.W RAM_SpriteYHi,Y               ;; 03B71B : B9 D4 14    ;  | 
CODE_03B71E:          ADC $0F                             ;; 03B71E : 65 0F       ;  | 
CODE_03B720:          STA $09                             ;; 03B720 : 85 09       ; / $09 = (Sprite Y position + displacement) High byte 
CODE_03B722:          LDA.L SprClippingHeight,X           ;; 03B722 : BF 20 B6 03 ; \ $03 = Clipping height 
CODE_03B726:          STA $03                             ;; 03B726 : 85 03       ; / 
CODE_03B728:          PLX                                 ;; 03B728 : FA          ; X = Sprite index 
CODE_03B729:          PLY                                 ;; 03B729 : 7A          ;
Return03B72A:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CheckForContact:      PHX                                 ;; ?QPWZ? : DA          ;
CODE_03B72C:          LDX.B #$01                          ;; 03B72C : A2 01       ;
CODE_03B72E:          LDA $00,X                           ;; 03B72E : B5 00       ;
CODE_03B730:          SEC                                 ;; 03B730 : 38          ;
CODE_03B731:          SBC $04,X                           ;; 03B731 : F5 04       ;
CODE_03B733:          PHA                                 ;; 03B733 : 48          ;
CODE_03B734:          LDA $08,X                           ;; 03B734 : B5 08       ;
CODE_03B736:          SBC $0A,X                           ;; 03B736 : F5 0A       ;
CODE_03B738:          STA $0C                             ;; 03B738 : 85 0C       ;
CODE_03B73A:          PLA                                 ;; 03B73A : 68          ;
CODE_03B73B:          CLC                                 ;; 03B73B : 18          ;
CODE_03B73C:          ADC.B #$80                          ;; 03B73C : 69 80       ;
CODE_03B73E:          LDA $0C                             ;; 03B73E : A5 0C       ;
CODE_03B740:          ADC.B #$00                          ;; 03B740 : 69 00       ;
CODE_03B742:          BNE CODE_03B75A                     ;; 03B742 : D0 16       ;
CODE_03B744:          LDA $04,X                           ;; 03B744 : B5 04       ;
CODE_03B746:          SEC                                 ;; 03B746 : 38          ;
CODE_03B747:          SBC $00,X                           ;; 03B747 : F5 00       ;
CODE_03B749:          CLC                                 ;; 03B749 : 18          ;
CODE_03B74A:          ADC $06,X                           ;; 03B74A : 75 06       ;
CODE_03B74C:          STA $0F                             ;; 03B74C : 85 0F       ;
CODE_03B74E:          LDA $02,X                           ;; 03B74E : B5 02       ;
CODE_03B750:          CLC                                 ;; 03B750 : 18          ;
CODE_03B751:          ADC $06,X                           ;; 03B751 : 75 06       ;
CODE_03B753:          CMP $0F                             ;; 03B753 : C5 0F       ;
CODE_03B755:          BCC CODE_03B75A                     ;; 03B755 : 90 03       ;
CODE_03B757:          DEX                                 ;; 03B757 : CA          ;
CODE_03B758:          BPL CODE_03B72E                     ;; 03B758 : 10 D4       ;
CODE_03B75A:          PLX                                 ;; 03B75A : FA          ;
Return03B75B:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B75C:          .db $0C,$1C                         ;; 03B75C               ;
                                                          ;;                      ;
DATA_03B75E:          .db $01,$02                         ;; 03B75E               ;
                                                          ;;                      ;
GetDrawInfoBnk3:      STZ.W RAM_OffscreenVert,X           ;; ?QPWZ? : 9E 6C 18    ; Reset sprite offscreen flag, vertical 
CODE_03B763:          STZ.W RAM_OffscreenHorz,X           ;; 03B763 : 9E A0 15    ; Reset sprite offscreen flag, horizontal 
CODE_03B766:          LDA RAM_SpriteXLo,X                 ;; 03B766 : B5 E4       ; \ 
CODE_03B768:          CMP RAM_ScreenBndryXLo              ;; 03B768 : C5 1A       ;  | Set horizontal offscreen if necessary 
CODE_03B76A:          LDA.W RAM_SpriteXHi,X               ;; 03B76A : BD E0 14    ;  | 
CODE_03B76D:          SBC RAM_ScreenBndryXHi              ;; 03B76D : E5 1B       ;  | 
CODE_03B76F:          BEQ CODE_03B774                     ;; 03B76F : F0 03       ;  | 
CODE_03B771:          INC.W RAM_OffscreenHorz,X           ;; 03B771 : FE A0 15    ; / 
CODE_03B774:          LDA.W RAM_SpriteXHi,X               ;; 03B774 : BD E0 14    ; \ 
CODE_03B777:          XBA                                 ;; 03B777 : EB          ;  | Mark sprite invalid if far enough off screen 
CODE_03B778:          LDA RAM_SpriteXLo,X                 ;; 03B778 : B5 E4       ;  | 
CODE_03B77A:          REP #$20                            ;; 03B77A : C2 20       ; Accum (16 bit) 
CODE_03B77C:          SEC                                 ;; 03B77C : 38          ;  | 
CODE_03B77D:          SBC RAM_ScreenBndryXLo              ;; 03B77D : E5 1A       ;  | 
CODE_03B77F:          CLC                                 ;; 03B77F : 18          ;  | 
CODE_03B780:          ADC.W #$0040                        ;; 03B780 : 69 40 00    ;  | 
CODE_03B783:          CMP.W #$0180                        ;; 03B783 : C9 80 01    ;  | 
CODE_03B786:          SEP #$20                            ;; 03B786 : E2 20       ; Accum (8 bit) 
CODE_03B788:          ROL                                 ;; 03B788 : 2A          ;  | 
CODE_03B789:          AND.B #$01                          ;; 03B789 : 29 01       ;  | 
CODE_03B78B:          STA.W $15C4,X                       ;; 03B78B : 9D C4 15    ;  | 
CODE_03B78E:          BNE CODE_03B7CF                     ;; 03B78E : D0 3F       ; /  
CODE_03B790:          LDY.B #$00                          ;; 03B790 : A0 00       ; \ set up loop: 
CODE_03B792:          LDA.W RAM_Tweaker1662,X             ;; 03B792 : BD 62 16    ;  |  
CODE_03B795:          AND.B #$20                          ;; 03B795 : 29 20       ;  | if not smushed (1662 & 0x20), go through loop twice 
CODE_03B797:          BEQ CODE_03B79A                     ;; 03B797 : F0 01       ;  | else, go through loop once 
CODE_03B799:          INY                                 ;; 03B799 : C8          ; /                        
CODE_03B79A:          LDA RAM_SpriteYLo,X                 ;; 03B79A : B5 D8       ; \                        
CODE_03B79C:          CLC                                 ;; 03B79C : 18          ;  | set vertical offscree 
CODE_03B79D:          ADC.W DATA_03B75C,Y                 ;; 03B79D : 79 5C B7    ;  |                       
CODE_03B7A0:          PHP                                 ;; 03B7A0 : 08          ;  |                       
CODE_03B7A1:          CMP RAM_ScreenBndryYLo              ;; 03B7A1 : C5 1C       ;  | (vert screen boundry) 
CODE_03B7A3:          ROL $00                             ;; 03B7A3 : 26 00       ;  |                       
CODE_03B7A5:          PLP                                 ;; 03B7A5 : 28          ;  |                       
CODE_03B7A6:          LDA.W RAM_SpriteYHi,X               ;; 03B7A6 : BD D4 14    ;  |                       
CODE_03B7A9:          ADC.B #$00                          ;; 03B7A9 : 69 00       ;  |                       
CODE_03B7AB:          LSR $00                             ;; 03B7AB : 46 00       ;  |                       
CODE_03B7AD:          SBC RAM_ScreenBndryYHi              ;; 03B7AD : E5 1D       ;  |                       
CODE_03B7AF:          BEQ CODE_03B7BA                     ;; 03B7AF : F0 09       ;  |                       
CODE_03B7B1:          LDA.W RAM_OffscreenVert,X           ;; 03B7B1 : BD 6C 18    ;  | (vert offscreen)      
CODE_03B7B4:          ORA.W DATA_03B75E,Y                 ;; 03B7B4 : 19 5E B7    ;  |                       
CODE_03B7B7:          STA.W RAM_OffscreenVert,X           ;; 03B7B7 : 9D 6C 18    ;  |                       
CODE_03B7BA:          DEY                                 ;; 03B7BA : 88          ;  |                       
CODE_03B7BB:          BPL CODE_03B79A                     ;; 03B7BB : 10 DD       ; /                        
CODE_03B7BD:          LDY.W RAM_SprOAMIndex,X             ;; 03B7BD : BC EA 15    ; get offset to sprite OAM                           
CODE_03B7C0:          LDA RAM_SpriteXLo,X                 ;; 03B7C0 : B5 E4       ; \ 
CODE_03B7C2:          SEC                                 ;; 03B7C2 : 38          ;  |                                                     
CODE_03B7C3:          SBC RAM_ScreenBndryXLo              ;; 03B7C3 : E5 1A       ;  |                                                    
CODE_03B7C5:          STA $00                             ;; 03B7C5 : 85 00       ; / $00 = sprite x position relative to screen boarder 
CODE_03B7C7:          LDA RAM_SpriteYLo,X                 ;; 03B7C7 : B5 D8       ; \                                                     
CODE_03B7C9:          SEC                                 ;; 03B7C9 : 38          ;  |                                                     
CODE_03B7CA:          SBC RAM_ScreenBndryYLo              ;; 03B7CA : E5 1C       ;  |                                                    
CODE_03B7CC:          STA $01                             ;; 03B7CC : 85 01       ; / $01 = sprite y position relative to screen boarder 
Return03B7CE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B7CF:          PLA                                 ;; 03B7CF : 68          ; \ Return from *main gfx routine* subroutine... 
CODE_03B7D0:          PLA                                 ;; 03B7D0 : 68          ;  |    ...(not just this subroutine) 
Return03B7D1:         RTS                                 ;; ?QPWZ? : 60          ; / 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B7D2:          .db $00,$00,$00,$F8,$F8,$F8,$F8,$F8 ;; 03B7D2               ;
                      .db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8 ;; ?QPWZ?               ;
                      .db $E8,$E8,$E8,$00,$00,$00,$00,$FE ;; ?QPWZ?               ;
                      .db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0 ;; ?QPWZ?               ;
                      .db $DC,$D8,$D4,$D0,$CC,$C8         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03B7F8:          LDA RAM_SpriteSpeedY,X              ;; 03B7F8 : B5 AA       ;
CODE_03B7FA:          PHA                                 ;; 03B7FA : 48          ;
CODE_03B7FB:          STZ RAM_SpriteSpeedY,X              ;; 03B7FB : 74 AA       ; Sprite Y Speed = 0 
CODE_03B7FD:          PLA                                 ;; 03B7FD : 68          ;
CODE_03B7FE:          LSR                                 ;; 03B7FE : 4A          ;
CODE_03B7FF:          LSR                                 ;; 03B7FF : 4A          ;
CODE_03B800:          TAY                                 ;; 03B800 : A8          ;
CODE_03B801:          LDA RAM_SpriteNum,X                 ;; 03B801 : B5 9E       ;
CODE_03B803:          CMP.B #$A1                          ;; 03B803 : C9 A1       ;
CODE_03B805:          BNE CODE_03B80C                     ;; 03B805 : D0 05       ;
CODE_03B807:          TYA                                 ;; 03B807 : 98          ;
CODE_03B808:          CLC                                 ;; 03B808 : 18          ;
CODE_03B809:          ADC.B #$13                          ;; 03B809 : 69 13       ;
CODE_03B80B:          TAY                                 ;; 03B80B : A8          ;
CODE_03B80C:          LDA.W DATA_03B7D2,Y                 ;; 03B80C : B9 D2 B7    ;
CODE_03B80F:          LDY.W RAM_SprObjStatus,X            ;; 03B80F : BC 88 15    ;
CODE_03B812:          BMI Return03B816                    ;; 03B812 : 30 02       ;
CODE_03B814:          STA RAM_SpriteSpeedY,X              ;; 03B814 : 95 AA       ;
Return03B816:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SubHorzPosBnk3:       LDY.B #$00                          ;; ?QPWZ? : A0 00       ;
CODE_03B819:          LDA RAM_MarioXPos                   ;; 03B819 : A5 94       ;
CODE_03B81B:          SEC                                 ;; 03B81B : 38          ;
CODE_03B81C:          SBC RAM_SpriteXLo,X                 ;; 03B81C : F5 E4       ;
CODE_03B81E:          STA $0F                             ;; 03B81E : 85 0F       ;
CODE_03B820:          LDA RAM_MarioXPosHi                 ;; 03B820 : A5 95       ;
CODE_03B822:          SBC.W RAM_SpriteXHi,X               ;; 03B822 : FD E0 14    ;
CODE_03B825:          BPL Return03B828                    ;; 03B825 : 10 01       ;
CODE_03B827:          INY                                 ;; 03B827 : C8          ;
Return03B828:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SubVertPosBnk3:       LDY.B #$00                          ;; ?QPWZ? : A0 00       ;
CODE_03B82B:          LDA RAM_MarioYPos                   ;; 03B82B : A5 96       ;
CODE_03B82D:          SEC                                 ;; 03B82D : 38          ;
CODE_03B82E:          SBC RAM_SpriteYLo,X                 ;; 03B82E : F5 D8       ;
CODE_03B830:          STA $0F                             ;; 03B830 : 85 0F       ;
CODE_03B832:          LDA RAM_MarioYPosHi                 ;; 03B832 : A5 97       ;
CODE_03B834:          SBC.W RAM_SpriteYHi,X               ;; 03B834 : FD D4 14    ;
CODE_03B837:          BPL Return03B83A                    ;; 03B837 : 10 01       ;
CODE_03B839:          INY                                 ;; 03B839 : C8          ;
Return03B83A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B83B:          .db $40,$B0                         ;; 03B83B               ;
                                                          ;;                      ;
DATA_03B83D:          .db $01,$FF                         ;; 03B83D               ;
                                                          ;;                      ;
DATA_03B83F:          .db $30,$C0,$A0,$80,$A0,$40,$60,$B0 ;; 03B83F               ;
DATA_03B847:          .db $01,$FF,$01,$FF,$01,$00,$01,$FF ;; 03B847               ;
                                                          ;;                      ;
SubOffscreen3Bnk3:    LDA.B #$06                          ;; ?QPWZ? : A9 06       ; \ Entry point of routine determines value of $03 
CODE_03B851:          BRA CODE_03B859                     ;; 03B851 : 80 06       ;  | 
                                                          ;;                      ;
SubOffscreen2Bnk3:    LDA.B #$04                          ;; ?QPWZ? : A9 04       ;  | 
ADDR_03B855:          BRA CODE_03B859                     ;; 03B855 : 80 02       ;  | 
                                                          ;;                      ;
SubOffscreen1Bnk3:    LDA.B #$02                          ;; ?QPWZ? : A9 02       ;  | 
CODE_03B859:          STA $03                             ;; 03B859 : 85 03       ;  | 
CODE_03B85B:          BRA CODE_03B85F                     ;; 03B85B : 80 02       ;  | 
                                                          ;;                      ;
SubOffscreen0Bnk3:    STZ $03                             ;; ?QPWZ? : 64 03       ; / 
CODE_03B85F:          JSR.W IsSprOffScreenBnk3            ;; 03B85F : 20 FB B8    ; \ if sprite is not off screen, return 
CODE_03B862:          BEQ Return03B8C2                    ;; 03B862 : F0 5E       ; / 
CODE_03B864:          LDA RAM_IsVerticalLvl               ;; 03B864 : A5 5B       ; \  vertical level 
CODE_03B866:          AND.B #$01                          ;; 03B866 : 29 01       ;  | 
CODE_03B868:          BNE VerticalLevelBnk3               ;; 03B868 : D0 59       ; / 
CODE_03B86A:          LDA RAM_SpriteYLo,X                 ;; 03B86A : B5 D8       ; \ 
CODE_03B86C:          CLC                                 ;; 03B86C : 18          ;  | 
CODE_03B86D:          ADC.B #$50                          ;; 03B86D : 69 50       ;  | if the sprite has gone off the bottom of the level... 
CODE_03B86F:          LDA.W RAM_SpriteYHi,X               ;; 03B86F : BD D4 14    ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2) 
CODE_03B872:          ADC.B #$00                          ;; 03B872 : 69 00       ;  | 
CODE_03B874:          CMP.B #$02                          ;; 03B874 : C9 02       ;  | 
CODE_03B876:          BPL OffScrEraseSprBnk3              ;; 03B876 : 10 34       ; /    ...erase the sprite 
CODE_03B878:          LDA.W RAM_Tweaker167A,X             ;; 03B878 : BD 7A 16    ; \ if "process offscreen" flag is set, return 
CODE_03B87B:          AND.B #$04                          ;; 03B87B : 29 04       ;  | 
CODE_03B87D:          BNE Return03B8C2                    ;; 03B87D : D0 43       ; / 
CODE_03B87F:          LDA RAM_FrameCounter                ;; 03B87F : A5 13       ;
CODE_03B881:          AND.B #$01                          ;; 03B881 : 29 01       ;
CODE_03B883:          ORA $03                             ;; 03B883 : 05 03       ;
CODE_03B885:          STA $01                             ;; 03B885 : 85 01       ;
CODE_03B887:          TAY                                 ;; 03B887 : A8          ;
CODE_03B888:          LDA RAM_ScreenBndryXLo              ;; 03B888 : A5 1A       ;
CODE_03B88A:          CLC                                 ;; 03B88A : 18          ;
CODE_03B88B:          ADC.W DATA_03B83F,Y                 ;; 03B88B : 79 3F B8    ;
CODE_03B88E:          ROL $00                             ;; 03B88E : 26 00       ;
CODE_03B890:          CMP RAM_SpriteXLo,X                 ;; 03B890 : D5 E4       ;
CODE_03B892:          PHP                                 ;; 03B892 : 08          ;
CODE_03B893:          LDA RAM_ScreenBndryXHi              ;; 03B893 : A5 1B       ;
CODE_03B895:          LSR $00                             ;; 03B895 : 46 00       ;
CODE_03B897:          ADC.W DATA_03B847,Y                 ;; 03B897 : 79 47 B8    ;
CODE_03B89A:          PLP                                 ;; 03B89A : 28          ;
CODE_03B89B:          SBC.W RAM_SpriteXHi,X               ;; 03B89B : FD E0 14    ;
CODE_03B89E:          STA $00                             ;; 03B89E : 85 00       ;
CODE_03B8A0:          LSR $01                             ;; 03B8A0 : 46 01       ;
CODE_03B8A2:          BCC CODE_03B8A8                     ;; 03B8A2 : 90 04       ;
CODE_03B8A4:          EOR.B #$80                          ;; 03B8A4 : 49 80       ;
CODE_03B8A6:          STA $00                             ;; 03B8A6 : 85 00       ;
CODE_03B8A8:          LDA $00                             ;; 03B8A8 : A5 00       ;
CODE_03B8AA:          BPL Return03B8C2                    ;; 03B8AA : 10 16       ;
OffScrEraseSprBnk3:   LDA.W $14C8,X                       ;; ?QPWZ? : BD C8 14    ; \ If sprite status < 8, permanently erase sprite 
CODE_03B8AF:          CMP.B #$08                          ;; 03B8AF : C9 08       ;  | 
CODE_03B8B1:          BCC OffScrKillSprBnk3               ;; 03B8B1 : 90 0C       ; / 
CODE_03B8B3:          LDY.W RAM_SprIndexInLvl,X           ;; 03B8B3 : BC 1A 16    ; \ Branch if should permanently erase sprite 
CODE_03B8B6:          CPY.B #$FF                          ;; 03B8B6 : C0 FF       ;  | 
CODE_03B8B8:          BEQ OffScrKillSprBnk3               ;; 03B8B8 : F0 05       ; / 
CODE_03B8BA:          LDA.B #$00                          ;; 03B8BA : A9 00       ; \ Allow sprite to be reloaded by level loading routine 
CODE_03B8BC:          STA.W RAM_SprLoadStatus,Y           ;; 03B8BC : 99 38 19    ; / 
OffScrKillSprBnk3:    STZ.W $14C8,X                       ;; ?QPWZ? : 9E C8 14    ;
Return03B8C2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
VerticalLevelBnk3:    LDA.W RAM_Tweaker167A,X             ;; ?QPWZ? : BD 7A 16    ; \ If "process offscreen" flag is set, return 
CODE_03B8C6:          AND.B #$04                          ;; 03B8C6 : 29 04       ;  | 
CODE_03B8C8:          BNE Return03B8C2                    ;; 03B8C8 : D0 F8       ; / 
CODE_03B8CA:          LDA RAM_FrameCounter                ;; 03B8CA : A5 13       ; \ Return every other frame 
CODE_03B8CC:          LSR                                 ;; 03B8CC : 4A          ;  | 
CODE_03B8CD:          BCS Return03B8C2                    ;; 03B8CD : B0 F3       ; / 
CODE_03B8CF:          AND.B #$01                          ;; 03B8CF : 29 01       ;
CODE_03B8D1:          STA $01                             ;; 03B8D1 : 85 01       ;
CODE_03B8D3:          TAY                                 ;; 03B8D3 : A8          ;
CODE_03B8D4:          LDA RAM_ScreenBndryYLo              ;; 03B8D4 : A5 1C       ;
CODE_03B8D6:          CLC                                 ;; 03B8D6 : 18          ;
CODE_03B8D7:          ADC.W DATA_03B83B,Y                 ;; 03B8D7 : 79 3B B8    ;
CODE_03B8DA:          ROL $00                             ;; 03B8DA : 26 00       ;
CODE_03B8DC:          CMP RAM_SpriteYLo,X                 ;; 03B8DC : D5 D8       ;
CODE_03B8DE:          PHP                                 ;; 03B8DE : 08          ;
CODE_03B8DF:          LDA.W RAM_ScreenBndryYHi            ;; 03B8DF : AD 1D 00    ;
CODE_03B8E2:          LSR $00                             ;; 03B8E2 : 46 00       ;
CODE_03B8E4:          ADC.W DATA_03B83D,Y                 ;; 03B8E4 : 79 3D B8    ;
CODE_03B8E7:          PLP                                 ;; 03B8E7 : 28          ;
CODE_03B8E8:          SBC.W RAM_SpriteYHi,X               ;; 03B8E8 : FD D4 14    ;
CODE_03B8EB:          STA $00                             ;; 03B8EB : 85 00       ;
CODE_03B8ED:          LDY $01                             ;; 03B8ED : A4 01       ;
CODE_03B8EF:          BEQ CODE_03B8F5                     ;; 03B8EF : F0 04       ;
CODE_03B8F1:          EOR.B #$80                          ;; 03B8F1 : 49 80       ;
CODE_03B8F3:          STA $00                             ;; 03B8F3 : 85 00       ;
CODE_03B8F5:          LDA $00                             ;; 03B8F5 : A5 00       ;
CODE_03B8F7:          BPL Return03B8C2                    ;; 03B8F7 : 10 C9       ;
CODE_03B8F9:          BMI OffScrEraseSprBnk3              ;; 03B8F9 : 30 B1       ;
IsSprOffScreenBnk3:   LDA.W RAM_OffscreenHorz,X           ;; ?QPWZ? : BD A0 15    ; \ If sprite is on screen, A = 0  
CODE_03B8FE:          ORA.W RAM_OffscreenVert,X           ;; 03B8FE : 1D 6C 18    ;  | 
Return03B901:         RTS                                 ;; ?QPWZ? : 60          ; / Return 
                                                          ;;                      ;
                                                          ;;                      ;
MagiKoopaPals:        .db $FF,$7F,$4A,$29,$00,$00,$00,$14 ;; ?QPWZ?               ;
                      .db $00,$20,$92,$7E,$0A,$00,$2A,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$AD,$35,$00,$00,$00,$24 ;; ?QPWZ?               ;
                      .db $00,$2C,$2F,$72,$0D,$00,$AD,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$10,$42,$00,$00,$00,$30 ;; ?QPWZ?               ;
                      .db $00,$38,$CC,$65,$50,$00,$10,$01 ;; ?QPWZ?               ;
                      .db $FF,$7F,$73,$4E,$00,$00,$00,$3C ;; ?QPWZ?               ;
                      .db $41,$44,$69,$59,$B3,$00,$73,$01 ;; ?QPWZ?               ;
                      .db $FF,$7F,$D6,$5A,$00,$00,$00,$48 ;; ?QPWZ?               ;
                      .db $A4,$50,$06,$4D,$16,$01,$D6,$01 ;; ?QPWZ?               ;
                      .db $FF,$7F,$39,$67,$00,$00,$42,$54 ;; ?QPWZ?               ;
                      .db $07,$5D,$A3,$40,$79,$01,$39,$02 ;; ?QPWZ?               ;
                      .db $FF,$7F,$9C,$73,$00,$00,$A5,$60 ;; ?QPWZ?               ;
                      .db $6A,$69,$40,$34,$DC,$01,$9C,$02 ;; ?QPWZ?               ;
                      .db $FF,$7F,$FF,$7F,$00,$00,$08,$6D ;; ?QPWZ?               ;
                      .db $CD,$75,$00,$28,$3F,$02,$FF,$02 ;; ?QPWZ?               ;
BooBossPals:          .db $FF,$7F,$63,$0C,$00,$00,$00,$0C ;; ?QPWZ?               ;
                      .db $00,$0C,$00,$0C,$00,$0C,$03,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$E7,$1C,$00,$00,$00,$1C ;; ?QPWZ?               ;
                      .db $00,$1C,$20,$1C,$81,$1C,$07,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$6B,$2D,$00,$00,$00,$2C ;; ?QPWZ?               ;
                      .db $40,$2C,$A2,$2C,$05,$2D,$0B,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$EF,$3D,$00,$00,$60,$3C ;; ?QPWZ?               ;
                      .db $C3,$3C,$26,$3D,$89,$3D,$0F,$00 ;; ?QPWZ?               ;
                      .db $FF,$7F,$73,$4E,$00,$00,$E4,$4C ;; ?QPWZ?               ;
                      .db $47,$4D,$AA,$4D,$0D,$4E,$13,$10 ;; ?QPWZ?               ;
                      .db $FF,$7F,$F7,$5E,$00,$00,$68,$5D ;; ?QPWZ?               ;
                      .db $CB,$5D,$2E,$5E,$91,$5E,$17,$20 ;; ?QPWZ?               ;
                      .db $FF,$7F,$7B,$6F,$00,$00,$EC,$6D ;; ?QPWZ?               ;
                      .db $4F,$6E,$B2,$6E,$15,$6F,$1B,$30 ;; ?QPWZ?               ;
                      .db $FF,$7F,$FF,$7F,$00,$00,$70,$7E ;; ?QPWZ?               ;
                      .db $D3,$7E,$36,$7F,$99,$7F,$1F,$40 ;; ?QPWZ?               ;
DATA_03BA02:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 03BA02               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF         ;; ?QPWZ?               ;
                                                          ;;                      ;
GenTileFromSpr2:      STA RAM_BlockBlock                  ;; ?QPWZ? : 85 9C       ; $9C = tile to generate 
CODE_03C002:          LDA RAM_SpriteXLo,X                 ;; 03C002 : B5 E4       ; \ $9A = Sprite X position + #$08 
CODE_03C004:          SEC                                 ;; 03C004 : 38          ;  | for block creation 
CODE_03C005:          SBC.B #$08                          ;; 03C005 : E9 08       ;  | 
CODE_03C007:          STA RAM_BlockYLo                    ;; 03C007 : 85 9A       ;  | 
CODE_03C009:          LDA.W RAM_SpriteXHi,X               ;; 03C009 : BD E0 14    ;  | 
CODE_03C00C:          SBC.B #$00                          ;; 03C00C : E9 00       ;  | 
CODE_03C00E:          STA RAM_BlockYHi                    ;; 03C00E : 85 9B       ; / 
CODE_03C010:          LDA RAM_SpriteYLo,X                 ;; 03C010 : B5 D8       ; \ $98 = Sprite Y position + #$08 
CODE_03C012:          CLC                                 ;; 03C012 : 18          ;  | for block creation 
CODE_03C013:          ADC.B #$08                          ;; 03C013 : 69 08       ;  | 
CODE_03C015:          STA RAM_BlockXLo                    ;; 03C015 : 85 98       ;  | 
CODE_03C017:          LDA.W RAM_SpriteYHi,X               ;; 03C017 : BD D4 14    ;  | 
CODE_03C01A:          ADC.B #$00                          ;; 03C01A : 69 00       ;  | 
CODE_03C01C:          STA RAM_BlockXHi                    ;; 03C01C : 85 99       ; / 
CODE_03C01E:          JSL.L GenerateTile                  ;; 03C01E : 22 B0 BE 00 ; Generate the tile 
Return03C022:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03C023:          PHB                                 ;; 03C023 : 8B          ; Wrapper 
CODE_03C024:          PHK                                 ;; 03C024 : 4B          ;
CODE_03C025:          PLB                                 ;; 03C025 : AB          ;
CODE_03C026:          JSR.W CODE_03C02F                   ;; 03C026 : 20 2F C0    ;
CODE_03C029:          PLB                                 ;; 03C029 : AB          ;
Return03C02A:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C02B:          .db $74,$75,$77,$76                 ;; 03C02B               ;
                                                          ;;                      ;
CODE_03C02F:          LDY.W $160E,X                       ;; 03C02F : BC 0E 16    ;
CODE_03C032:          LDA.B #$00                          ;; 03C032 : A9 00       ;
CODE_03C034:          STA.W $14C8,Y                       ;; 03C034 : 99 C8 14    ;
CODE_03C037:          LDA.B #$06                          ;; 03C037 : A9 06       ; \ Play sound effect 
CODE_03C039:          STA.W $1DF9                         ;; 03C039 : 8D F9 1D    ; / 
CODE_03C03C:          LDA.W $160E,Y                       ;; 03C03C : B9 0E 16    ;
CODE_03C03F:          BNE CODE_03C09B                     ;; 03C03F : D0 5A       ;
CODE_03C041:          LDA.W RAM_SpriteNum,Y               ;; 03C041 : B9 9E 00    ;
CODE_03C044:          CMP.B #$81                          ;; 03C044 : C9 81       ;
CODE_03C046:          BNE CODE_03C054                     ;; 03C046 : D0 0C       ;
ADDR_03C048:          LDA RAM_FrameCounterB               ;; 03C048 : A5 14       ;
ADDR_03C04A:          LSR                                 ;; 03C04A : 4A          ;
ADDR_03C04B:          LSR                                 ;; 03C04B : 4A          ;
ADDR_03C04C:          LSR                                 ;; 03C04C : 4A          ;
ADDR_03C04D:          LSR                                 ;; 03C04D : 4A          ;
ADDR_03C04E:          AND.B #$03                          ;; 03C04E : 29 03       ;
ADDR_03C050:          TAY                                 ;; 03C050 : A8          ;
ADDR_03C051:          LDA.W DATA_03C02B,Y                 ;; 03C051 : B9 2B C0    ;
CODE_03C054:          CMP.B #$74                          ;; 03C054 : C9 74       ;
CODE_03C056:          BCC CODE_03C09B                     ;; 03C056 : 90 43       ;
ADDR_03C058:          CMP.B #$78                          ;; 03C058 : C9 78       ;
ADDR_03C05A:          BCS CODE_03C09B                     ;; 03C05A : B0 3F       ;
ADDR_03C05C:          STZ.W $18AC                         ;; 03C05C : 9C AC 18    ;
ADDR_03C05F:          STZ.W RAM_YoshiHasWings             ;; 03C05F : 9C 1E 14    ; No Yoshi wing ability 
ADDR_03C062:          LDA.B #$35                          ;; 03C062 : A9 35       ;
ADDR_03C064:          STA.W RAM_SpriteNum,X               ;; 03C064 : 9D 9E 00    ;
ADDR_03C067:          LDA.B #$08                          ;; 03C067 : A9 08       ; \ Sprite status = Normal 
ADDR_03C069:          STA.W $14C8,X                       ;; 03C069 : 9D C8 14    ; / 
ADDR_03C06C:          LDA.B #$1F                          ;; 03C06C : A9 1F       ; \ Play sound effect 
ADDR_03C06E:          STA.W $1DFC                         ;; 03C06E : 8D FC 1D    ; / 
ADDR_03C071:          LDA RAM_SpriteYLo,X                 ;; 03C071 : B5 D8       ;
ADDR_03C073:          SBC.B #$10                          ;; 03C073 : E9 10       ;
ADDR_03C075:          STA RAM_SpriteYLo,X                 ;; 03C075 : 95 D8       ;
ADDR_03C077:          LDA.W RAM_SpriteYHi,X               ;; 03C077 : BD D4 14    ;
ADDR_03C07A:          SBC.B #$00                          ;; 03C07A : E9 00       ;
ADDR_03C07C:          STA.W RAM_SpriteYHi,X               ;; 03C07C : 9D D4 14    ;
ADDR_03C07F:          LDA.W RAM_SpritePal,X               ;; 03C07F : BD F6 15    ;
ADDR_03C082:          PHA                                 ;; 03C082 : 48          ;
ADDR_03C083:          JSL.L InitSpriteTables              ;; 03C083 : 22 D2 F7 07 ;
ADDR_03C087:          PLA                                 ;; 03C087 : 68          ;
ADDR_03C088:          AND.B #$FE                          ;; 03C088 : 29 FE       ;
ADDR_03C08A:          STA.W RAM_SpritePal,X               ;; 03C08A : 9D F6 15    ;
ADDR_03C08D:          LDA.B #$0C                          ;; 03C08D : A9 0C       ;
ADDR_03C08F:          STA.W $1602,X                       ;; 03C08F : 9D 02 16    ;
ADDR_03C092:          DEC.W $160E,X                       ;; 03C092 : DE 0E 16    ;
ADDR_03C095:          LDA.B #$40                          ;; 03C095 : A9 40       ;
ADDR_03C097:          STA.W $18E8                         ;; 03C097 : 8D E8 18    ;
Return03C09A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C09B:          INC.W $1570,X                       ;; 03C09B : FE 70 15    ;
CODE_03C09E:          LDA.W $1570,X                       ;; 03C09E : BD 70 15    ;
CODE_03C0A1:          CMP.B #$05                          ;; 03C0A1 : C9 05       ;
CODE_03C0A3:          BNE CODE_03C0A7                     ;; 03C0A3 : D0 02       ;
ADDR_03C0A5:          BRA ADDR_03C05C                     ;; 03C0A5 : 80 B5       ;
                                                          ;;                      ;
CODE_03C0A7:          JSL.L CODE_05B34A                   ;; 03C0A7 : 22 4A B3 05 ;
CODE_03C0AB:          LDA.B #$01                          ;; 03C0AB : A9 01       ;
CODE_03C0AD:          JSL.L GivePoints                    ;; 03C0AD : 22 E5 AC 02 ;
Return03C0B1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C0B2:          .db $68,$6A,$6C,$6E                 ;; 03C0B2               ;
                                                          ;;                      ;
DATA_03C0B6:          .db $00,$03,$01,$02,$04,$02,$00,$01 ;; 03C0B6               ;
                      .db $00,$04,$00,$02,$00,$03,$04,$01 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C0C6:          LDA RAM_SpritesLocked               ;; 03C0C6 : A5 9D       ;
CODE_03C0C8:          BNE CODE_03C0CD                     ;; 03C0C8 : D0 03       ;
CODE_03C0CA:          JSR.W CODE_03C11E                   ;; 03C0CA : 20 1E C1    ;
CODE_03C0CD:          STZ $00                             ;; 03C0CD : 64 00       ;
CODE_03C0CF:          LDX.B #$13                          ;; 03C0CF : A2 13       ;
CODE_03C0D1:          LDY.B #$B0                          ;; 03C0D1 : A0 B0       ;
CODE_03C0D3:          STX $02                             ;; 03C0D3 : 86 02       ;
CODE_03C0D5:          LDA $00                             ;; 03C0D5 : A5 00       ;
CODE_03C0D7:          STA.W OAM_DispX,Y                   ;; 03C0D7 : 99 00 03    ;
CODE_03C0DA:          CLC                                 ;; 03C0DA : 18          ;
CODE_03C0DB:          ADC.B #$10                          ;; 03C0DB : 69 10       ;
CODE_03C0DD:          STA $00                             ;; 03C0DD : 85 00       ;
CODE_03C0DF:          LDA.B #$C4                          ;; 03C0DF : A9 C4       ;
CODE_03C0E1:          STA.W OAM_DispY,Y                   ;; 03C0E1 : 99 01 03    ;
CODE_03C0E4:          LDA $64                             ;; 03C0E4 : A5 64       ;
CODE_03C0E6:          ORA.B #$09                          ;; 03C0E6 : 09 09       ;
CODE_03C0E8:          STA.W OAM_Prop,Y                    ;; 03C0E8 : 99 03 03    ;
CODE_03C0EB:          PHX                                 ;; 03C0EB : DA          ;
CODE_03C0EC:          LDA RAM_FrameCounterB               ;; 03C0EC : A5 14       ;
CODE_03C0EE:          LSR                                 ;; 03C0EE : 4A          ;
CODE_03C0EF:          LSR                                 ;; 03C0EF : 4A          ;
CODE_03C0F0:          LSR                                 ;; 03C0F0 : 4A          ;
CODE_03C0F1:          CLC                                 ;; 03C0F1 : 18          ;
CODE_03C0F2:          ADC.L DATA_03C0B6,X                 ;; 03C0F2 : 7F B6 C0 03 ;
CODE_03C0F6:          AND.B #$03                          ;; 03C0F6 : 29 03       ;
CODE_03C0F8:          TAX                                 ;; 03C0F8 : AA          ;
CODE_03C0F9:          LDA.L DATA_03C0B2,X                 ;; 03C0F9 : BF B2 C0 03 ;
CODE_03C0FD:          STA.W OAM_Tile,Y                    ;; 03C0FD : 99 02 03    ;
CODE_03C100:          TYA                                 ;; 03C100 : 98          ;
CODE_03C101:          LSR                                 ;; 03C101 : 4A          ;
CODE_03C102:          LSR                                 ;; 03C102 : 4A          ;
CODE_03C103:          TAX                                 ;; 03C103 : AA          ;
CODE_03C104:          LDA.B #$02                          ;; 03C104 : A9 02       ;
CODE_03C106:          STA.W OAM_TileSize,X                ;; 03C106 : 9D 60 04    ;
CODE_03C109:          PLX                                 ;; 03C109 : FA          ;
CODE_03C10A:          INY                                 ;; 03C10A : C8          ;
CODE_03C10B:          INY                                 ;; 03C10B : C8          ;
CODE_03C10C:          INY                                 ;; 03C10C : C8          ;
CODE_03C10D:          INY                                 ;; 03C10D : C8          ;
CODE_03C10E:          DEX                                 ;; 03C10E : CA          ;
CODE_03C10F:          BPL CODE_03C0D3                     ;; 03C10F : 10 C2       ;
Return03C111:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
IggyPlatSpeed:        .db $FF,$01,$FF,$01                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C116:          .db $FF,$00,$FF,$00                 ;; 03C116               ;
                                                          ;;                      ;
IggyPlatBounds:       .db $E7,$18,$D7,$28                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C11E:          LDA RAM_SpritesLocked               ;; 03C11E : A5 9D       ; \ If sprites locked... 
CODE_03C120:          ORA.W $1493                         ;; 03C120 : 0D 93 14    ;  | ...or battle is over (set to FF when over)... 
CODE_03C123:          BNE Return03C175                    ;; 03C123 : D0 50       ; / ...return 
CODE_03C125:          LDA.W $1906                         ;; 03C125 : AD 06 19    ; \ If platform at a maximum tilt, (stationary timer > 0) 
CODE_03C128:          BEQ CODE_03C12D                     ;; 03C128 : F0 03       ;  | 
CODE_03C12A:          DEC.W $1906                         ;; 03C12A : CE 06 19    ; / decrement stationary timer 
CODE_03C12D:          LDA RAM_FrameCounter                ;; 03C12D : A5 13       ; \ Return every other time through... 
CODE_03C12F:          AND.B #$01                          ;; 03C12F : 29 01       ;  | 
CODE_03C131:          ORA.W $1906                         ;; 03C131 : 0D 06 19    ;  | ...return if stationary 
CODE_03C134:          BNE Return03C175                    ;; 03C134 : D0 3F       ; / 
CODE_03C136:          LDA.W $1905                         ;; 03C136 : AD 05 19    ; $1907 holds the total number of tilts made 
CODE_03C139:          AND.B #$01                          ;; 03C139 : 29 01       ; \ X=1 if platform tilted up to the right (/)... 
CODE_03C13B:          TAX                                 ;; 03C13B : AA          ; / ...else X=0 
CODE_03C13C:          LDA.W $1907                         ;; 03C13C : AD 07 19    ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\ 
CODE_03C13F:          CMP.B #$04                          ;; 03C13F : C9 04       ; \ If this is phase 4 or 5... 
CODE_03C141:          BCC CODE_03C145                     ;; 03C141 : 90 02       ;  | ...cause a steep tilt by setting X=X+2 
CODE_03C143:          INX                                 ;; 03C143 : E8          ;  | 
CODE_03C144:          INX                                 ;; 03C144 : E8          ; / 
CODE_03C145:          LDA $36                             ;; 03C145 : A5 36       ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\ 
CODE_03C147:          CLC                                 ;; 03C147 : 18          ; \ Get new tilt of platform by adding value 
CODE_03C148:          ADC.L IggyPlatSpeed,X               ;; 03C148 : 7F 12 C1 03 ;  | 
CODE_03C14C:          STA $36                             ;; 03C14C : 85 36       ; / 
CODE_03C14E:          PHA                                 ;; 03C14E : 48          ;
CODE_03C14F:          LDA $37                             ;; 03C14F : A5 37       ; $37 is boolean tilt of platform: 0\ /1 
CODE_03C151:          ADC.L DATA_03C116,X                 ;; 03C151 : 7F 16 C1 03 ; \ if tilted up to left,  $37=0 
CODE_03C155:          AND.B #$01                          ;; 03C155 : 29 01       ;  | if tilted up to right, $37=1 
CODE_03C157:          STA $37                             ;; 03C157 : 85 37       ; / 
CODE_03C159:          PLA                                 ;; 03C159 : 68          ;
CODE_03C15A:          CMP.L IggyPlatBounds,X              ;; 03C15A : DF 1A C1 03 ; \ Return if platform not at a maximum tilt 
CODE_03C15E:          BNE Return03C175                    ;; 03C15E : D0 15       ; / 
CODE_03C160:          INC.W $1905                         ;; 03C160 : EE 05 19    ; Increment total number of tilts made 
CODE_03C163:          LDA.B #$40                          ;; 03C163 : A9 40       ; \ Set timer to stay stationary 
CODE_03C165:          STA.W $1906                         ;; 03C165 : 8D 06 19    ; / 
CODE_03C168:          INC.W $1907                         ;; 03C168 : EE 07 19    ; Increment phase 
CODE_03C16B:          LDA.W $1907                         ;; 03C16B : AD 07 19    ; \ If phase > 5, phase = 0 
CODE_03C16E:          CMP.B #$06                          ;; 03C16E : C9 06       ;  | 
CODE_03C170:          BNE Return03C175                    ;; 03C170 : D0 03       ;  | 
CODE_03C172:          STZ.W $1907                         ;; 03C172 : 9C 07 19    ; / 
Return03C175:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C176:          .db $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D ;; 03C176               ;
                      .db $0D,$0D,$FC,$FC,$FC,$FC,$FC,$FC ;; ?QPWZ?               ;
                      .db $FB,$FB,$FB,$FB,$0C,$0C,$0C,$0C ;; ?QPWZ?               ;
                      .db $0C,$0C,$0D,$0D,$0D,$0D,$FC,$FC ;; ?QPWZ?               ;
                      .db $FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB ;; ?QPWZ?               ;
DATA_03C19E:          .db $0E,$0E,$0E,$0D,$0D,$0D,$0C,$0C ;; 03C19E               ;
                      .db $0B,$0B,$0E,$0E,$0E,$0D,$0D,$0D ;; ?QPWZ?               ;
                      .db $0C,$0C,$0B,$0B,$12,$12,$12,$11 ;; ?QPWZ?               ;
                      .db $11,$11,$10,$10,$0F,$0F,$12,$12 ;; ?QPWZ?               ;
                      .db $12,$11,$11,$11,$10,$10,$0F,$0F ;; ?QPWZ?               ;
DATA_03C1C6:          .db $02,$FE                         ;; 03C1C6               ;
                                                          ;;                      ;
DATA_03C1C8:          .db $00,$FF                         ;; 03C1C8               ;
                                                          ;;                      ;
CODE_03C1CA:          PHB                                 ;; 03C1CA : 8B          ;
CODE_03C1CB:          PHK                                 ;; 03C1CB : 4B          ;
CODE_03C1CC:          PLB                                 ;; 03C1CC : AB          ;
CODE_03C1CD:          LDY.B #$00                          ;; 03C1CD : A0 00       ;
CODE_03C1CF:          LDA.W $15B8,X                       ;; 03C1CF : BD B8 15    ;
CODE_03C1D2:          BPL CODE_03C1D5                     ;; 03C1D2 : 10 01       ;
CODE_03C1D4:          INY                                 ;; 03C1D4 : C8          ;
CODE_03C1D5:          LDA RAM_SpriteXLo,X                 ;; 03C1D5 : B5 E4       ;
CODE_03C1D7:          CLC                                 ;; 03C1D7 : 18          ;
CODE_03C1D8:          ADC.W DATA_03C1C6,Y                 ;; 03C1D8 : 79 C6 C1    ;
CODE_03C1DB:          STA RAM_SpriteXLo,X                 ;; 03C1DB : 95 E4       ;
CODE_03C1DD:          LDA.W RAM_SpriteXHi,X               ;; 03C1DD : BD E0 14    ;
CODE_03C1E0:          ADC.W DATA_03C1C8,Y                 ;; 03C1E0 : 79 C8 C1    ;
CODE_03C1E3:          STA.W RAM_SpriteXHi,X               ;; 03C1E3 : 9D E0 14    ;
CODE_03C1E6:          LDA.B #$18                          ;; 03C1E6 : A9 18       ;
CODE_03C1E8:          STA RAM_SpriteSpeedY,X              ;; 03C1E8 : 95 AA       ;
CODE_03C1EA:          PLB                                 ;; 03C1EA : AB          ;
Return03C1EB:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C1EC:          .db $00,$04,$07,$08,$08,$07,$04,$00 ;; 03C1EC               ;
                      .db $00                             ;; ?QPWZ?               ;
                                                          ;;                      ;
LightSwitch:          LDA RAM_SpritesLocked               ;; ?QPWZ? : A5 9D       ;
CODE_03C1F7:          BNE CODE_03C22B                     ;; 03C1F7 : D0 32       ;
CODE_03C1F9:          JSL.L InvisBlkMainRt                ;; 03C1F9 : 22 4F B4 01 ;
CODE_03C1FD:          JSR.W SubOffscreen0Bnk3             ;; 03C1FD : 20 5D B8    ;
CODE_03C200:          LDA.W $1558,X                       ;; 03C200 : BD 58 15    ;
CODE_03C203:          CMP.B #$05                          ;; 03C203 : C9 05       ;
CODE_03C205:          BNE CODE_03C22B                     ;; 03C205 : D0 24       ;
CODE_03C207:          STZ RAM_SpriteState,X               ;; 03C207 : 74 C2       ;
CODE_03C209:          LDY.B #$0B                          ;; 03C209 : A0 0B       ; \ Play sound effect 
CODE_03C20B:          STY.W $1DF9                         ;; 03C20B : 8C F9 1D    ; / 
CODE_03C20E:          PHA                                 ;; 03C20E : 48          ;
CODE_03C20F:          LDY.B #$09                          ;; 03C20F : A0 09       ;
CODE_03C211:          LDA.W $14C8,Y                       ;; 03C211 : B9 C8 14    ;
CODE_03C214:          CMP.B #$08                          ;; 03C214 : C9 08       ;
CODE_03C216:          BNE CODE_03C227                     ;; 03C216 : D0 0F       ;
CODE_03C218:          LDA.W RAM_SpriteNum,Y               ;; 03C218 : B9 9E 00    ;
CODE_03C21B:          CMP.B #$C6                          ;; 03C21B : C9 C6       ;
CODE_03C21D:          BNE CODE_03C227                     ;; 03C21D : D0 08       ;
CODE_03C21F:          LDA.W RAM_SpriteState,Y             ;; 03C21F : B9 C2 00    ;
CODE_03C222:          EOR.B #$01                          ;; 03C222 : 49 01       ;
CODE_03C224:          STA.W RAM_SpriteState,Y             ;; 03C224 : 99 C2 00    ;
CODE_03C227:          DEY                                 ;; 03C227 : 88          ;
CODE_03C228:          BPL CODE_03C211                     ;; 03C228 : 10 E7       ;
CODE_03C22A:          PLA                                 ;; 03C22A : 68          ;
CODE_03C22B:          LDA.W $1558,X                       ;; 03C22B : BD 58 15    ;
CODE_03C22E:          LSR                                 ;; 03C22E : 4A          ;
CODE_03C22F:          TAY                                 ;; 03C22F : A8          ;
CODE_03C230:          LDA RAM_ScreenBndryYLo              ;; 03C230 : A5 1C       ;
CODE_03C232:          PHA                                 ;; 03C232 : 48          ;
CODE_03C233:          CLC                                 ;; 03C233 : 18          ;
CODE_03C234:          ADC.W DATA_03C1EC,Y                 ;; 03C234 : 79 EC C1    ;
CODE_03C237:          STA RAM_ScreenBndryYLo              ;; 03C237 : 85 1C       ;
CODE_03C239:          LDA RAM_ScreenBndryYHi              ;; 03C239 : A5 1D       ;
CODE_03C23B:          PHA                                 ;; 03C23B : 48          ;
CODE_03C23C:          ADC.B #$00                          ;; 03C23C : 69 00       ;
CODE_03C23E:          STA RAM_ScreenBndryYHi              ;; 03C23E : 85 1D       ;
CODE_03C240:          JSL.L GenericSprGfxRt2              ;; 03C240 : 22 B2 90 01 ;
CODE_03C244:          LDY.W RAM_SprOAMIndex,X             ;; 03C244 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03C247:          LDA.B #$2A                          ;; 03C247 : A9 2A       ;
CODE_03C249:          STA.W OAM_Tile,Y                    ;; 03C249 : 99 02 03    ;
CODE_03C24C:          LDA.W OAM_Prop,Y                    ;; 03C24C : B9 03 03    ;
CODE_03C24F:          AND.B #$BF                          ;; 03C24F : 29 BF       ;
CODE_03C251:          STA.W OAM_Prop,Y                    ;; 03C251 : 99 03 03    ;
CODE_03C254:          PLA                                 ;; 03C254 : 68          ;
CODE_03C255:          STA RAM_ScreenBndryYHi              ;; 03C255 : 85 1D       ;
CODE_03C257:          PLA                                 ;; 03C257 : 68          ;
CODE_03C258:          STA RAM_ScreenBndryYLo              ;; 03C258 : 85 1C       ;
Return03C25A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ChainsawMotorTiles:   .db $E0,$C2,$C0,$C2                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C25F:          .db $F2,$0E                         ;; 03C25F               ;
                                                          ;;                      ;
DATA_03C261:          .db $33,$B3                         ;; 03C261               ;
                                                          ;;                      ;
CODE_03C263:          PHB                                 ;; 03C263 : 8B          ; Wrapper 
CODE_03C264:          PHK                                 ;; 03C264 : 4B          ;
CODE_03C265:          PLB                                 ;; 03C265 : AB          ;
CODE_03C266:          JSR.W ChainsawGfx                   ;; 03C266 : 20 6B C2    ;
CODE_03C269:          PLB                                 ;; 03C269 : AB          ;
Return03C26A:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
ChainsawGfx:          JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_03C26E:          PHX                                 ;; 03C26E : DA          ;
CODE_03C26F:          LDA RAM_SpriteNum,X                 ;; 03C26F : B5 9E       ;
CODE_03C271:          SEC                                 ;; 03C271 : 38          ;
CODE_03C272:          SBC.B #$65                          ;; 03C272 : E9 65       ;
CODE_03C274:          TAX                                 ;; 03C274 : AA          ;
CODE_03C275:          LDA.W DATA_03C25F,X                 ;; 03C275 : BD 5F C2    ;
CODE_03C278:          STA $03                             ;; 03C278 : 85 03       ;
CODE_03C27A:          LDA.W DATA_03C261,X                 ;; 03C27A : BD 61 C2    ;
CODE_03C27D:          STA $04                             ;; 03C27D : 85 04       ;
CODE_03C27F:          PLX                                 ;; 03C27F : FA          ;
CODE_03C280:          LDA RAM_FrameCounterB               ;; 03C280 : A5 14       ;
CODE_03C282:          AND.B #$02                          ;; 03C282 : 29 02       ;
CODE_03C284:          STA $02                             ;; 03C284 : 85 02       ;
CODE_03C286:          LDA $00                             ;; 03C286 : A5 00       ;
CODE_03C288:          SEC                                 ;; 03C288 : 38          ;
CODE_03C289:          SBC.B #$08                          ;; 03C289 : E9 08       ;
CODE_03C28B:          STA.W OAM_DispX,Y                   ;; 03C28B : 99 00 03    ;
CODE_03C28E:          STA.W OAM_Tile2DispX,Y              ;; 03C28E : 99 04 03    ;
CODE_03C291:          STA.W OAM_Tile3DispX,Y              ;; 03C291 : 99 08 03    ;
CODE_03C294:          LDA $01                             ;; 03C294 : A5 01       ;
CODE_03C296:          SEC                                 ;; 03C296 : 38          ;
CODE_03C297:          SBC.B #$08                          ;; 03C297 : E9 08       ;
CODE_03C299:          STA.W OAM_DispY,Y                   ;; 03C299 : 99 01 03    ;
CODE_03C29C:          CLC                                 ;; 03C29C : 18          ;
CODE_03C29D:          ADC $03                             ;; 03C29D : 65 03       ;
CODE_03C29F:          CLC                                 ;; 03C29F : 18          ;
CODE_03C2A0:          ADC $02                             ;; 03C2A0 : 65 02       ;
CODE_03C2A2:          STA.W OAM_Tile2DispY,Y              ;; 03C2A2 : 99 05 03    ;
CODE_03C2A5:          CLC                                 ;; 03C2A5 : 18          ;
CODE_03C2A6:          ADC $03                             ;; 03C2A6 : 65 03       ;
CODE_03C2A8:          STA.W OAM_Tile3DispY,Y              ;; 03C2A8 : 99 09 03    ;
CODE_03C2AB:          LDA RAM_FrameCounterB               ;; 03C2AB : A5 14       ;
CODE_03C2AD:          LSR                                 ;; 03C2AD : 4A          ;
CODE_03C2AE:          LSR                                 ;; 03C2AE : 4A          ;
CODE_03C2AF:          AND.B #$03                          ;; 03C2AF : 29 03       ;
CODE_03C2B1:          PHX                                 ;; 03C2B1 : DA          ;
CODE_03C2B2:          TAX                                 ;; 03C2B2 : AA          ;
CODE_03C2B3:          LDA.W ChainsawMotorTiles,X          ;; 03C2B3 : BD 5B C2    ;
CODE_03C2B6:          STA.W OAM_Tile,Y                    ;; 03C2B6 : 99 02 03    ;
CODE_03C2B9:          PLX                                 ;; 03C2B9 : FA          ;
CODE_03C2BA:          LDA.B #$AE                          ;; 03C2BA : A9 AE       ;
CODE_03C2BC:          STA.W OAM_Tile2,Y                   ;; 03C2BC : 99 06 03    ;
CODE_03C2BF:          LDA.B #$8E                          ;; 03C2BF : A9 8E       ;
CODE_03C2C1:          STA.W OAM_Tile3,Y                   ;; 03C2C1 : 99 0A 03    ;
CODE_03C2C4:          LDA.B #$37                          ;; 03C2C4 : A9 37       ;
CODE_03C2C6:          STA.W OAM_Prop,Y                    ;; 03C2C6 : 99 03 03    ;
CODE_03C2C9:          LDA $04                             ;; 03C2C9 : A5 04       ;
CODE_03C2CB:          STA.W OAM_Tile2Prop,Y               ;; 03C2CB : 99 07 03    ;
CODE_03C2CE:          STA.W OAM_Tile3Prop,Y               ;; 03C2CE : 99 0B 03    ;
CODE_03C2D1:          LDY.B #$02                          ;; 03C2D1 : A0 02       ;
CODE_03C2D3:          TYA                                 ;; 03C2D3 : 98          ;
CODE_03C2D4:          JSL.L FinishOAMWrite                ;; 03C2D4 : 22 B3 B7 01 ;
Return03C2D8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
TriggerInivis1Up:     PHX                                 ;; ?QPWZ? : DA          ; \ Find free sprite slot (#$0B-#$00) 
CODE_03C2DA:          LDX.B #$0B                          ;; 03C2DA : A2 0B       ;  | 
CODE_03C2DC:          LDA.W $14C8,X                       ;; 03C2DC : BD C8 14    ;  | 
CODE_03C2DF:          BEQ Generate1Up                     ;; 03C2DF : F0 05       ;  | 
ADDR_03C2E1:          DEX                                 ;; 03C2E1 : CA          ;  | 
ADDR_03C2E2:          BPL CODE_03C2DC                     ;; 03C2E2 : 10 F8       ;  | 
ADDR_03C2E4:          PLX                                 ;; 03C2E4 : FA          ;  | 
Return03C2E5:         RTL                                 ;; ?QPWZ? : 6B          ; / 
                                                          ;;                      ;
Generate1Up:          LDA.B #$08                          ;; ?QPWZ? : A9 08       ; \ Sprite status = Normal 
CODE_03C2E8:          STA.W $14C8,X                       ;; 03C2E8 : 9D C8 14    ; / 
CODE_03C2EB:          LDA.B #$78                          ;; 03C2EB : A9 78       ; \ Sprite = 1Up 
CODE_03C2ED:          STA RAM_SpriteNum,X                 ;; 03C2ED : 95 9E       ; / 
CODE_03C2EF:          LDA RAM_MarioXPos                   ;; 03C2EF : A5 94       ; \ Sprite X position = Mario X position 
CODE_03C2F1:          STA RAM_SpriteXLo,X                 ;; 03C2F1 : 95 E4       ;  | 
CODE_03C2F3:          LDA RAM_MarioXPosHi                 ;; 03C2F3 : A5 95       ;  | 
CODE_03C2F5:          STA.W RAM_SpriteXHi,X               ;; 03C2F5 : 9D E0 14    ; / 
CODE_03C2F8:          LDA RAM_MarioYPos                   ;; 03C2F8 : A5 96       ; \ Sprite Y position = Matio Y position 
CODE_03C2FA:          STA RAM_SpriteYLo,X                 ;; 03C2FA : 95 D8       ;  | 
CODE_03C2FC:          LDA RAM_MarioYPosHi                 ;; 03C2FC : A5 97       ;  | 
CODE_03C2FE:          STA.W RAM_SpriteYHi,X               ;; 03C2FE : 9D D4 14    ; / 
CODE_03C301:          JSL.L InitSpriteTables              ;; 03C301 : 22 D2 F7 07 ; Load sprite tables 
CODE_03C305:          LDA.B #$10                          ;; 03C305 : A9 10       ; \ Disable interaction timer = #$10 
CODE_03C307:          STA.W RAM_DisableInter,X            ;; 03C307 : 9D 4C 15    ; / 
CODE_03C30A:          JSR.W PopupMushroom                 ;; 03C30A : 20 34 C3    ;
CODE_03C30D:          PLX                                 ;; 03C30D : FA          ;
Return03C30E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
InvisMushroom:        JSR.W GetDrawInfoBnk3               ;; ?QPWZ? : 20 60 B7    ;
CODE_03C312:          JSL.L MarioSprInteract              ;; 03C312 : 22 DC A7 01 ; \ Return if no interaction 
CODE_03C316:          BCC Return03C347                    ;; 03C316 : 90 2F       ; / 
CODE_03C318:          LDA.B #$74                          ;; 03C318 : A9 74       ; \ Replace, Sprite = Mushroom 
CODE_03C31A:          STA RAM_SpriteNum,X                 ;; 03C31A : 95 9E       ; / 
CODE_03C31C:          JSL.L InitSpriteTables              ;; 03C31C : 22 D2 F7 07 ; Reset sprite tables 
CODE_03C320:          LDA.B #$20                          ;; 03C320 : A9 20       ; \ Disable interaction timer = #$20 
CODE_03C322:          STA.W RAM_DisableInter,X            ;; 03C322 : 9D 4C 15    ; / 
CODE_03C325:          LDA RAM_SpriteYLo,X                 ;; 03C325 : B5 D8       ; \ Sprite Y position = Mario Y position - $000F 
CODE_03C327:          SEC                                 ;; 03C327 : 38          ;  | 
CODE_03C328:          SBC.B #$0F                          ;; 03C328 : E9 0F       ;  | 
CODE_03C32A:          STA RAM_SpriteYLo,X                 ;; 03C32A : 95 D8       ;  | 
CODE_03C32C:          LDA.W RAM_SpriteYHi,X               ;; 03C32C : BD D4 14    ;  | 
CODE_03C32F:          SBC.B #$00                          ;; 03C32F : E9 00       ;  | 
CODE_03C331:          STA.W RAM_SpriteYHi,X               ;; 03C331 : 9D D4 14    ; / 
PopupMushroom:        LDA.B #$00                          ;; ?QPWZ? : A9 00       ; \ Sprite direction = dirction of Mario's X speed 
CODE_03C336:          LDY RAM_MarioSpeedX                 ;; 03C336 : A4 7B       ;  | 
CODE_03C338:          BPL CODE_03C33B                     ;; 03C338 : 10 01       ;  | 
CODE_03C33A:          INC A                               ;; 03C33A : 1A          ;  | 
CODE_03C33B:          STA.W RAM_SpriteDir,X               ;; 03C33B : 9D 7C 15    ; / 
CODE_03C33E:          LDA.B #$C0                          ;; 03C33E : A9 C0       ; \ Set upward speed 
CODE_03C340:          STA RAM_SpriteSpeedY,X              ;; 03C340 : 95 AA       ; / 
CODE_03C342:          LDA.B #$02                          ;; 03C342 : A9 02       ; \ Play sound effect 
CODE_03C344:          STA.W $1DFC                         ;; 03C344 : 8D FC 1D    ; / 
Return03C347:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
NinjiSpeedY:          .db $D0,$C0,$B0,$D0                 ;; ?QPWZ?               ;
                                                          ;;                      ;
Ninji:                JSL.L GenericSprGfxRt2              ;; ?QPWZ? : 22 B2 90 01 ; Draw sprite uing the routine for sprites <= 53 
CODE_03C350:          LDA RAM_SpritesLocked               ;; 03C350 : A5 9D       ; \ Return if sprites locked			 
CODE_03C352:          BNE Return03C38F                    ;; 03C352 : D0 3B       ; /						 
CODE_03C354:          JSR.W SubHorzPosBnk3                ;; 03C354 : 20 17 B8    ; \ Always face mario				 
CODE_03C357:          TYA                                 ;; 03C357 : 98          ;  |						 
CODE_03C358:          STA.W RAM_SpriteDir,X               ;; 03C358 : 9D 7C 15    ; /						 
CODE_03C35B:          JSR.W SubOffscreen0Bnk3             ;; 03C35B : 20 5D B8    ; Only process while onscreen			 
CODE_03C35E:          JSL.L SprSpr+MarioSprRts            ;; 03C35E : 22 3A 80 01 ; Interact with mario				 
CODE_03C362:          JSL.L UpdateSpritePos               ;; 03C362 : 22 2A 80 01 ; Update position based on speed values       
CODE_03C366:          LDA.W RAM_SprObjStatus,X            ;; 03C366 : BD 88 15    ; \ Branch if not on ground 
CODE_03C369:          AND.B #$04                          ;; 03C369 : 29 04       ;  | 
CODE_03C36B:          BEQ CODE_03C385                     ;; 03C36B : F0 18       ; / 
CODE_03C36D:          STZ RAM_SpriteSpeedY,X              ;; 03C36D : 74 AA       ; Sprite Y Speed = 0 
CODE_03C36F:          LDA.W $1540,X                       ;; 03C36F : BD 40 15    ;
CODE_03C372:          BNE CODE_03C385                     ;; 03C372 : D0 11       ;
CODE_03C374:          LDA.B #$60                          ;; 03C374 : A9 60       ;
CODE_03C376:          STA.W $1540,X                       ;; 03C376 : 9D 40 15    ;
CODE_03C379:          INC RAM_SpriteState,X               ;; 03C379 : F6 C2       ;
CODE_03C37B:          LDA RAM_SpriteState,X               ;; 03C37B : B5 C2       ;
CODE_03C37D:          AND.B #$03                          ;; 03C37D : 29 03       ;
CODE_03C37F:          TAY                                 ;; 03C37F : A8          ;
CODE_03C380:          LDA.W NinjiSpeedY,Y                 ;; 03C380 : B9 48 C3    ;
CODE_03C383:          STA RAM_SpriteSpeedY,X              ;; 03C383 : 95 AA       ;
CODE_03C385:          LDA.B #$00                          ;; 03C385 : A9 00       ;
CODE_03C387:          LDY RAM_SpriteSpeedY,X              ;; 03C387 : B4 AA       ;
CODE_03C389:          BMI CODE_03C38C                     ;; 03C389 : 30 01       ;
CODE_03C38B:          INC A                               ;; 03C38B : 1A          ;
CODE_03C38C:          STA.W $1602,X                       ;; 03C38C : 9D 02 16    ;
Return03C38F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C390:          PHB                                 ;; 03C390 : 8B          ;
CODE_03C391:          PHK                                 ;; 03C391 : 4B          ;
CODE_03C392:          PLB                                 ;; 03C392 : AB          ;
CODE_03C393:          LDA.W RAM_SpriteDir,X               ;; 03C393 : BD 7C 15    ;
CODE_03C396:          PHA                                 ;; 03C396 : 48          ;
CODE_03C397:          LDY.W $15AC,X                       ;; 03C397 : BC AC 15    ;
CODE_03C39A:          BEQ CODE_03C3A5                     ;; 03C39A : F0 09       ;
CODE_03C39C:          CPY.B #$05                          ;; 03C39C : C0 05       ;
CODE_03C39E:          BCC CODE_03C3A5                     ;; 03C39E : 90 05       ;
CODE_03C3A0:          EOR.B #$01                          ;; 03C3A0 : 49 01       ;
CODE_03C3A2:          STA.W RAM_SpriteDir,X               ;; 03C3A2 : 9D 7C 15    ;
CODE_03C3A5:          JSR.W CODE_03C3DA                   ;; 03C3A5 : 20 DA C3    ;
CODE_03C3A8:          PLA                                 ;; 03C3A8 : 68          ;
CODE_03C3A9:          STA.W RAM_SpriteDir,X               ;; 03C3A9 : 9D 7C 15    ;
CODE_03C3AC:          PLB                                 ;; 03C3AC : AB          ;
Return03C3AD:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03C3AE:          JSL.L GenericSprGfxRt2              ;; 03C3AE : 22 B2 90 01 ;
Return03C3B2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DryBonesTileDispX:    .db $00,$08,$00,$00,$F8,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $00,$00,$FC,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesGfxProp:      .db $43,$43,$43,$03,$03,$03         ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesTileDispY:    .db $F4,$F0,$00,$F4,$F1,$00,$F4,$F0 ;; ?QPWZ?               ;
                      .db $00                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesTiles:        .db $00,$64,$66,$00,$64,$68,$82,$64 ;; ?QPWZ?               ;
                      .db $E6                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C3D7:          .db $00,$00,$FF                     ;; 03C3D7               ;
                                                          ;;                      ;
CODE_03C3DA:          LDA RAM_SpriteNum,X                 ;; 03C3DA : B5 9E       ;
CODE_03C3DC:          CMP.B #$31                          ;; 03C3DC : C9 31       ;
CODE_03C3DE:          BEQ CODE_03C3AE                     ;; 03C3DE : F0 CE       ;
CODE_03C3E0:          JSR.W GetDrawInfoBnk3               ;; 03C3E0 : 20 60 B7    ;
CODE_03C3E3:          LDA.W $15AC,X                       ;; 03C3E3 : BD AC 15    ;
CODE_03C3E6:          STA $05                             ;; 03C3E6 : 85 05       ;
CODE_03C3E8:          LDA.W RAM_SpriteDir,X               ;; 03C3E8 : BD 7C 15    ;
CODE_03C3EB:          ASL                                 ;; 03C3EB : 0A          ;
CODE_03C3EC:          ADC.W RAM_SpriteDir,X               ;; 03C3EC : 7D 7C 15    ;
CODE_03C3EF:          STA $02                             ;; 03C3EF : 85 02       ;
CODE_03C3F1:          PHX                                 ;; 03C3F1 : DA          ;
CODE_03C3F2:          LDA.W $1602,X                       ;; 03C3F2 : BD 02 16    ;
CODE_03C3F5:          PHA                                 ;; 03C3F5 : 48          ;
CODE_03C3F6:          ASL                                 ;; 03C3F6 : 0A          ;
CODE_03C3F7:          ADC.W $1602,X                       ;; 03C3F7 : 7D 02 16    ;
CODE_03C3FA:          STA $03                             ;; 03C3FA : 85 03       ;
CODE_03C3FC:          PLX                                 ;; 03C3FC : FA          ;
CODE_03C3FD:          LDA.W DATA_03C3D7,X                 ;; 03C3FD : BD D7 C3    ;
CODE_03C400:          STA $04                             ;; 03C400 : 85 04       ;
CODE_03C402:          LDX.B #$02                          ;; 03C402 : A2 02       ;
CODE_03C404:          PHX                                 ;; 03C404 : DA          ;
CODE_03C405:          TXA                                 ;; 03C405 : 8A          ;
CODE_03C406:          CLC                                 ;; 03C406 : 18          ;
CODE_03C407:          ADC $02                             ;; 03C407 : 65 02       ;
CODE_03C409:          TAX                                 ;; 03C409 : AA          ;
CODE_03C40A:          PHX                                 ;; 03C40A : DA          ;
CODE_03C40B:          LDA $05                             ;; 03C40B : A5 05       ;
CODE_03C40D:          BEQ CODE_03C414                     ;; 03C40D : F0 05       ;
CODE_03C40F:          TXA                                 ;; 03C40F : 8A          ;
CODE_03C410:          CLC                                 ;; 03C410 : 18          ;
CODE_03C411:          ADC.B #$06                          ;; 03C411 : 69 06       ;
CODE_03C413:          TAX                                 ;; 03C413 : AA          ;
CODE_03C414:          LDA $00                             ;; 03C414 : A5 00       ;
CODE_03C416:          CLC                                 ;; 03C416 : 18          ;
CODE_03C417:          ADC.W DryBonesTileDispX,X           ;; 03C417 : 7D B3 C3    ;
CODE_03C41A:          STA.W OAM_DispX,Y                   ;; 03C41A : 99 00 03    ;
CODE_03C41D:          PLX                                 ;; 03C41D : FA          ;
CODE_03C41E:          LDA.W DryBonesGfxProp,X             ;; 03C41E : BD BF C3    ;
CODE_03C421:          ORA $64                             ;; 03C421 : 05 64       ;
CODE_03C423:          STA.W OAM_Prop,Y                    ;; 03C423 : 99 03 03    ;
CODE_03C426:          PLA                                 ;; 03C426 : 68          ;
CODE_03C427:          PHA                                 ;; 03C427 : 48          ;
CODE_03C428:          CLC                                 ;; 03C428 : 18          ;
CODE_03C429:          ADC $03                             ;; 03C429 : 65 03       ;
CODE_03C42B:          TAX                                 ;; 03C42B : AA          ;
CODE_03C42C:          LDA $01                             ;; 03C42C : A5 01       ;
CODE_03C42E:          CLC                                 ;; 03C42E : 18          ;
CODE_03C42F:          ADC.W DryBonesTileDispY,X           ;; 03C42F : 7D C5 C3    ;
CODE_03C432:          STA.W OAM_DispY,Y                   ;; 03C432 : 99 01 03    ;
CODE_03C435:          LDA.W DryBonesTiles,X               ;; 03C435 : BD CE C3    ;
CODE_03C438:          STA.W OAM_Tile,Y                    ;; 03C438 : 99 02 03    ;
CODE_03C43B:          PLX                                 ;; 03C43B : FA          ;
CODE_03C43C:          INY                                 ;; 03C43C : C8          ;
CODE_03C43D:          INY                                 ;; 03C43D : C8          ;
CODE_03C43E:          INY                                 ;; 03C43E : C8          ;
CODE_03C43F:          INY                                 ;; 03C43F : C8          ;
CODE_03C440:          DEX                                 ;; 03C440 : CA          ;
CODE_03C441:          CPX $04                             ;; 03C441 : E4 04       ;
CODE_03C443:          BNE CODE_03C404                     ;; 03C443 : D0 BF       ;
CODE_03C445:          PLX                                 ;; 03C445 : FA          ;
CODE_03C446:          LDY.B #$02                          ;; 03C446 : A0 02       ;
CODE_03C448:          TYA                                 ;; 03C448 : 98          ;
CODE_03C449:          JSL.L FinishOAMWrite                ;; 03C449 : 22 B3 B7 01 ;
Return03C44D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C44E:          LDA.W RAM_OffscreenHorz,X           ;; 03C44E : BD A0 15    ;
CODE_03C451:          ORA.W RAM_OffscreenVert,X           ;; 03C451 : 1D 6C 18    ;
CODE_03C454:          BNE Return03C460                    ;; 03C454 : D0 0A       ;
CODE_03C456:          LDY.B #$07                          ;; 03C456 : A0 07       ; \ Find a free extended sprite slot 
CODE_03C458:          LDA.W RAM_ExSpriteNum,Y             ;; 03C458 : B9 0B 17    ;  | 
CODE_03C45B:          BEQ CODE_03C461                     ;; 03C45B : F0 04       ;  | 
CODE_03C45D:          DEY                                 ;; 03C45D : 88          ;  | 
CODE_03C45E:          BPL CODE_03C458                     ;; 03C45E : 10 F8       ;  | 
Return03C460:         RTL                                 ;; ?QPWZ? : 6B          ; / Return if no free slots 
                                                          ;;                      ;
CODE_03C461:          LDA.B #$06                          ;; 03C461 : A9 06       ; \ Extended sprite = Bone 
CODE_03C463:          STA.W RAM_ExSpriteNum,Y             ;; 03C463 : 99 0B 17    ; / 
CODE_03C466:          LDA RAM_SpriteYLo,X                 ;; 03C466 : B5 D8       ;
CODE_03C468:          SEC                                 ;; 03C468 : 38          ;
CODE_03C469:          SBC.B #$10                          ;; 03C469 : E9 10       ;
CODE_03C46B:          STA.W RAM_ExSpriteYLo,Y             ;; 03C46B : 99 15 17    ;
CODE_03C46E:          LDA.W RAM_SpriteYHi,X               ;; 03C46E : BD D4 14    ;
CODE_03C471:          SBC.B #$00                          ;; 03C471 : E9 00       ;
CODE_03C473:          STA.W RAM_ExSpriteYHi,Y             ;; 03C473 : 99 29 17    ;
CODE_03C476:          LDA RAM_SpriteXLo,X                 ;; 03C476 : B5 E4       ;
CODE_03C478:          STA.W RAM_ExSpriteXLo,Y             ;; 03C478 : 99 1F 17    ;
CODE_03C47B:          LDA.W RAM_SpriteXHi,X               ;; 03C47B : BD E0 14    ;
CODE_03C47E:          STA.W RAM_ExSpriteXHi,Y             ;; 03C47E : 99 33 17    ;
CODE_03C481:          LDA.W RAM_SpriteDir,X               ;; 03C481 : BD 7C 15    ;
CODE_03C484:          LSR                                 ;; 03C484 : 4A          ;
CODE_03C485:          LDA.B #$18                          ;; 03C485 : A9 18       ;
CODE_03C487:          BCC CODE_03C48B                     ;; 03C487 : 90 02       ;
CODE_03C489:          LDA.B #$E8                          ;; 03C489 : A9 E8       ;
CODE_03C48B:          STA.W RAM_ExSprSpeedX,Y             ;; 03C48B : 99 47 17    ;
Return03C48E:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C48F:          .db $01,$FF                         ;; 03C48F               ;
                                                          ;;                      ;
DATA_03C491:          .db $FF,$90                         ;; 03C491               ;
                                                          ;;                      ;
DiscoBallTiles:       .db $80,$82,$84,$86,$88,$8C,$C0,$C2 ;; ?QPWZ?               ;
                      .db $C2                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C49C:          .db $31,$33,$35,$37,$31,$33,$35,$37 ;; 03C49C               ;
                      .db $39                             ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C4A5:          LDY.W RAM_SprOAMIndex,X             ;; 03C4A5 : BC EA 15    ; Y = Index into sprite OAM 
CODE_03C4A8:          LDA.B #$78                          ;; 03C4A8 : A9 78       ;
CODE_03C4AA:          STA.W OAM_DispX,Y                   ;; 03C4AA : 99 00 03    ;
CODE_03C4AD:          LDA.B #$28                          ;; 03C4AD : A9 28       ;
CODE_03C4AF:          STA.W OAM_DispY,Y                   ;; 03C4AF : 99 01 03    ;
CODE_03C4B2:          PHX                                 ;; 03C4B2 : DA          ;
CODE_03C4B3:          LDA RAM_SpriteState,X               ;; 03C4B3 : B5 C2       ;
CODE_03C4B5:          LDX.B #$08                          ;; 03C4B5 : A2 08       ;
CODE_03C4B7:          AND.B #$01                          ;; 03C4B7 : 29 01       ;
CODE_03C4B9:          BEQ CODE_03C4C1                     ;; 03C4B9 : F0 06       ;
CODE_03C4BB:          LDA RAM_FrameCounter                ;; 03C4BB : A5 13       ;
CODE_03C4BD:          LSR                                 ;; 03C4BD : 4A          ;
CODE_03C4BE:          AND.B #$07                          ;; 03C4BE : 29 07       ;
CODE_03C4C0:          TAX                                 ;; 03C4C0 : AA          ;
CODE_03C4C1:          LDA.W DiscoBallTiles,X              ;; 03C4C1 : BD 93 C4    ;
CODE_03C4C4:          STA.W OAM_Tile,Y                    ;; 03C4C4 : 99 02 03    ;
CODE_03C4C7:          LDA.W DATA_03C49C,X                 ;; 03C4C7 : BD 9C C4    ;
CODE_03C4CA:          STA.W OAM_Prop,Y                    ;; 03C4CA : 99 03 03    ;
CODE_03C4CD:          TYA                                 ;; 03C4CD : 98          ;
CODE_03C4CE:          LSR                                 ;; 03C4CE : 4A          ;
CODE_03C4CF:          LSR                                 ;; 03C4CF : 4A          ;
CODE_03C4D0:          TAY                                 ;; 03C4D0 : A8          ;
CODE_03C4D1:          LDA.B #$02                          ;; 03C4D1 : A9 02       ;
CODE_03C4D3:          STA.W OAM_TileSize,Y                ;; 03C4D3 : 99 60 04    ;
CODE_03C4D6:          PLX                                 ;; 03C4D6 : FA          ;
Return03C4D7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C4D8:          .db $10,$8C                         ;; 03C4D8               ;
                                                          ;;                      ;
DATA_03C4DA:          .db $42,$31                         ;; 03C4DA               ;
                                                          ;;                      ;
DarkRoomWithLight:    LDA.W $1534,X                       ;; ?QPWZ? : BD 34 15    ;
CODE_03C4DF:          BNE CODE_03C500                     ;; 03C4DF : D0 1F       ;
CODE_03C4E1:          LDY.B #$09                          ;; 03C4E1 : A0 09       ;
CODE_03C4E3:          CPY.W $15E9                         ;; 03C4E3 : CC E9 15    ;
CODE_03C4E6:          BEQ CODE_03C4FA                     ;; 03C4E6 : F0 12       ;
CODE_03C4E8:          LDA.W $14C8,Y                       ;; 03C4E8 : B9 C8 14    ;
CODE_03C4EB:          CMP.B #$08                          ;; 03C4EB : C9 08       ;
CODE_03C4ED:          BNE CODE_03C4FA                     ;; 03C4ED : D0 0B       ;
CODE_03C4EF:          LDA.W RAM_SpriteNum,Y               ;; 03C4EF : B9 9E 00    ;
CODE_03C4F2:          CMP.B #$C6                          ;; 03C4F2 : C9 C6       ;
CODE_03C4F4:          BNE CODE_03C4FA                     ;; 03C4F4 : D0 04       ;
CODE_03C4F6:          STZ.W $14C8,X                       ;; 03C4F6 : 9E C8 14    ;
Return03C4F9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C4FA:          DEY                                 ;; 03C4FA : 88          ;
CODE_03C4FB:          BPL CODE_03C4E3                     ;; 03C4FB : 10 E6       ;
CODE_03C4FD:          INC.W $1534,X                       ;; 03C4FD : FE 34 15    ;
CODE_03C500:          JSR.W CODE_03C4A5                   ;; 03C500 : 20 A5 C4    ;
CODE_03C503:          LDA.B #$FF                          ;; 03C503 : A9 FF       ;
CODE_03C505:          STA $40                             ;; 03C505 : 85 40       ;
CODE_03C507:          LDA.B #$20                          ;; 03C507 : A9 20       ;
CODE_03C509:          STA $44                             ;; 03C509 : 85 44       ;
CODE_03C50B:          LDA.B #$20                          ;; 03C50B : A9 20       ;
CODE_03C50D:          STA $43                             ;; 03C50D : 85 43       ;
CODE_03C50F:          LDA.B #$80                          ;; 03C50F : A9 80       ;
CODE_03C511:          STA.W $0D9F                         ;; 03C511 : 8D 9F 0D    ;
CODE_03C514:          LDA RAM_SpriteState,X               ;; 03C514 : B5 C2       ;
CODE_03C516:          AND.B #$01                          ;; 03C516 : 29 01       ;
CODE_03C518:          TAY                                 ;; 03C518 : A8          ;
CODE_03C519:          LDA.W DATA_03C4D8,Y                 ;; 03C519 : B9 D8 C4    ;
CODE_03C51C:          STA.W $0701                         ;; 03C51C : 8D 01 07    ;
CODE_03C51F:          LDA.W DATA_03C4DA,Y                 ;; 03C51F : B9 DA C4    ;
CODE_03C522:          STA.W $0702                         ;; 03C522 : 8D 02 07    ;
CODE_03C525:          LDA RAM_SpritesLocked               ;; 03C525 : A5 9D       ;
CODE_03C527:          BNE Return03C4F9                    ;; 03C527 : D0 D0       ;
CODE_03C529:          LDA.W $1482                         ;; 03C529 : AD 82 14    ;
CODE_03C52C:          BNE CODE_03C54D                     ;; 03C52C : D0 1F       ;
CODE_03C52E:          LDA.B #$00                          ;; 03C52E : A9 00       ;
CODE_03C530:          STA.W $1476                         ;; 03C530 : 8D 76 14    ;
CODE_03C533:          LDA.B #$90                          ;; 03C533 : A9 90       ;
CODE_03C535:          STA.W $1478                         ;; 03C535 : 8D 78 14    ;
CODE_03C538:          LDA.B #$78                          ;; 03C538 : A9 78       ;
CODE_03C53A:          STA.W $1472                         ;; 03C53A : 8D 72 14    ;
CODE_03C53D:          LDA.B #$87                          ;; 03C53D : A9 87       ;
CODE_03C53F:          STA.W $1474                         ;; 03C53F : 8D 74 14    ;
CODE_03C542:          LDA.B #$01                          ;; 03C542 : A9 01       ;
CODE_03C544:          STA.W $1486                         ;; 03C544 : 8D 86 14    ;
CODE_03C547:          STZ.W $1483                         ;; 03C547 : 9C 83 14    ;
CODE_03C54A:          INC.W $1482                         ;; 03C54A : EE 82 14    ;
CODE_03C54D:          LDY.W $1483                         ;; 03C54D : AC 83 14    ;
CODE_03C550:          LDA.W $1476                         ;; 03C550 : AD 76 14    ;
CODE_03C553:          CLC                                 ;; 03C553 : 18          ;
CODE_03C554:          ADC.W DATA_03C48F,Y                 ;; 03C554 : 79 8F C4    ;
CODE_03C557:          STA.W $1476                         ;; 03C557 : 8D 76 14    ;
CODE_03C55A:          LDA.W $1478                         ;; 03C55A : AD 78 14    ;
CODE_03C55D:          CLC                                 ;; 03C55D : 18          ;
CODE_03C55E:          ADC.W DATA_03C48F,Y                 ;; 03C55E : 79 8F C4    ;
CODE_03C561:          STA.W $1478                         ;; 03C561 : 8D 78 14    ;
CODE_03C564:          CMP.W DATA_03C491,Y                 ;; 03C564 : D9 91 C4    ;
CODE_03C567:          BNE CODE_03C572                     ;; 03C567 : D0 09       ;
CODE_03C569:          LDA.W $1483                         ;; 03C569 : AD 83 14    ;
CODE_03C56C:          INC A                               ;; 03C56C : 1A          ;
CODE_03C56D:          AND.B #$01                          ;; 03C56D : 29 01       ;
CODE_03C56F:          STA.W $1483                         ;; 03C56F : 8D 83 14    ;
CODE_03C572:          LDA RAM_FrameCounter                ;; 03C572 : A5 13       ;
CODE_03C574:          AND.B #$03                          ;; 03C574 : 29 03       ;
CODE_03C576:          BNE Return03C4F9                    ;; 03C576 : D0 81       ;
CODE_03C578:          LDY.B #$00                          ;; 03C578 : A0 00       ;
CODE_03C57A:          LDA.W $1472                         ;; 03C57A : AD 72 14    ;
CODE_03C57D:          STA.W $147A                         ;; 03C57D : 8D 7A 14    ;
CODE_03C580:          SEC                                 ;; 03C580 : 38          ;
CODE_03C581:          SBC.W $1476                         ;; 03C581 : ED 76 14    ;
CODE_03C584:          BCS CODE_03C58A                     ;; 03C584 : B0 04       ;
ADDR_03C586:          INY                                 ;; 03C586 : C8          ;
ADDR_03C587:          EOR.B #$FF                          ;; 03C587 : 49 FF       ;
ADDR_03C589:          INC A                               ;; 03C589 : 1A          ;
CODE_03C58A:          STA.W $1480                         ;; 03C58A : 8D 80 14    ;
CODE_03C58D:          STY.W $1484                         ;; 03C58D : 8C 84 14    ;
CODE_03C590:          STZ.W $147E                         ;; 03C590 : 9C 7E 14    ;
CODE_03C593:          LDY.B #$00                          ;; 03C593 : A0 00       ;
CODE_03C595:          LDA.W $1474                         ;; 03C595 : AD 74 14    ;
CODE_03C598:          STA.W $147C                         ;; 03C598 : 8D 7C 14    ;
CODE_03C59B:          SEC                                 ;; 03C59B : 38          ;
CODE_03C59C:          SBC.W $1478                         ;; 03C59C : ED 78 14    ;
CODE_03C59F:          BCS CODE_03C5A5                     ;; 03C59F : B0 04       ;
CODE_03C5A1:          INY                                 ;; 03C5A1 : C8          ;
CODE_03C5A2:          EOR.B #$FF                          ;; 03C5A2 : 49 FF       ;
CODE_03C5A4:          INC A                               ;; 03C5A4 : 1A          ;
CODE_03C5A5:          STA.W $1481                         ;; 03C5A5 : 8D 81 14    ;
CODE_03C5A8:          STY.W $1485                         ;; 03C5A8 : 8C 85 14    ;
CODE_03C5AB:          STZ.W $147F                         ;; 03C5AB : 9C 7F 14    ;
CODE_03C5AE:          LDA RAM_SpriteState,X               ;; 03C5AE : B5 C2       ;
CODE_03C5B0:          STA $0F                             ;; 03C5B0 : 85 0F       ;
CODE_03C5B2:          PHX                                 ;; 03C5B2 : DA          ;
CODE_03C5B3:          REP #$10                            ;; 03C5B3 : C2 10       ; Index (16 bit) 
CODE_03C5B5:          LDX.W #$0000                        ;; 03C5B5 : A2 00 00    ;
CODE_03C5B8:          CPX.W #$005F                        ;; 03C5B8 : E0 5F 00    ;
CODE_03C5BB:          BCC CODE_03C607                     ;; 03C5BB : 90 4A       ;
CODE_03C5BD:          LDA.W $147E                         ;; 03C5BD : AD 7E 14    ;
CODE_03C5C0:          CLC                                 ;; 03C5C0 : 18          ;
CODE_03C5C1:          ADC.W $1480                         ;; 03C5C1 : 6D 80 14    ;
CODE_03C5C4:          STA.W $147E                         ;; 03C5C4 : 8D 7E 14    ;
CODE_03C5C7:          BCS CODE_03C5CD                     ;; 03C5C7 : B0 04       ;
CODE_03C5C9:          CMP.B #$CF                          ;; 03C5C9 : C9 CF       ;
CODE_03C5CB:          BCC CODE_03C5E0                     ;; 03C5CB : 90 13       ;
CODE_03C5CD:          SBC.B #$CF                          ;; 03C5CD : E9 CF       ;
CODE_03C5CF:          STA.W $147E                         ;; 03C5CF : 8D 7E 14    ;
CODE_03C5D2:          INC.W $147A                         ;; 03C5D2 : EE 7A 14    ;
CODE_03C5D5:          LDA.W $1484                         ;; 03C5D5 : AD 84 14    ;
CODE_03C5D8:          BNE CODE_03C5E0                     ;; 03C5D8 : D0 06       ;
CODE_03C5DA:          DEC.W $147A                         ;; 03C5DA : CE 7A 14    ;
CODE_03C5DD:          DEC.W $147A                         ;; 03C5DD : CE 7A 14    ;
CODE_03C5E0:          LDA.W $147F                         ;; 03C5E0 : AD 7F 14    ;
CODE_03C5E3:          CLC                                 ;; 03C5E3 : 18          ;
CODE_03C5E4:          ADC.W $1481                         ;; 03C5E4 : 6D 81 14    ;
CODE_03C5E7:          STA.W $147F                         ;; 03C5E7 : 8D 7F 14    ;
CODE_03C5EA:          BCS CODE_03C5F0                     ;; 03C5EA : B0 04       ;
CODE_03C5EC:          CMP.B #$CF                          ;; 03C5EC : C9 CF       ;
CODE_03C5EE:          BCC CODE_03C603                     ;; 03C5EE : 90 13       ;
CODE_03C5F0:          SBC.B #$CF                          ;; 03C5F0 : E9 CF       ;
CODE_03C5F2:          STA.W $147F                         ;; 03C5F2 : 8D 7F 14    ;
CODE_03C5F5:          INC.W $147C                         ;; 03C5F5 : EE 7C 14    ;
CODE_03C5F8:          LDA.W $1485                         ;; 03C5F8 : AD 85 14    ;
CODE_03C5FB:          BNE CODE_03C603                     ;; 03C5FB : D0 06       ;
ADDR_03C5FD:          DEC.W $147C                         ;; 03C5FD : CE 7C 14    ;
ADDR_03C600:          DEC.W $147C                         ;; 03C600 : CE 7C 14    ;
CODE_03C603:          LDA $0F                             ;; 03C603 : A5 0F       ;
CODE_03C605:          BNE CODE_03C60F                     ;; 03C605 : D0 08       ;
CODE_03C607:          LDA.B #$01                          ;; 03C607 : A9 01       ;
CODE_03C609:          STA.W $04A0,X                       ;; 03C609 : 9D A0 04    ;
CODE_03C60C:          DEC A                               ;; 03C60C : 3A          ;
CODE_03C60D:          BRA CODE_03C618                     ;; 03C60D : 80 09       ;
                                                          ;;                      ;
CODE_03C60F:          LDA.W $147A                         ;; 03C60F : AD 7A 14    ;
CODE_03C612:          STA.W $04A0,X                       ;; 03C612 : 9D A0 04    ;
CODE_03C615:          LDA.W $147C                         ;; 03C615 : AD 7C 14    ;
CODE_03C618:          STA.W $04A1,X                       ;; 03C618 : 9D A1 04    ;
CODE_03C61B:          INX                                 ;; 03C61B : E8          ;
CODE_03C61C:          INX                                 ;; 03C61C : E8          ;
CODE_03C61D:          CPX.W #$01C0                        ;; 03C61D : E0 C0 01    ;
CODE_03C620:          BNE CODE_03C5B8                     ;; 03C620 : D0 96       ;
CODE_03C622:          SEP #$10                            ;; 03C622 : E2 10       ; Index (8 bit) 
CODE_03C624:          PLX                                 ;; 03C624 : FA          ;
Return03C625:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C626:          .db $14,$28,$38,$20,$30,$4C,$40,$34 ;; 03C626               ;
                      .db $2C,$1C,$08,$0C,$04,$0C,$1C,$24 ;; ?QPWZ?               ;
                      .db $2C,$38,$40,$48,$50,$5C,$5C,$6C ;; ?QPWZ?               ;
                      .db $4C,$58,$24,$78,$64,$70,$78,$7C ;; ?QPWZ?               ;
                      .db $70,$68,$58,$4C,$40,$34,$24,$04 ;; ?QPWZ?               ;
                      .db $18,$2C,$0C,$0C,$14,$18,$1C,$24 ;; ?QPWZ?               ;
                      .db $2C,$28,$24,$30,$30,$34,$38,$3C ;; ?QPWZ?               ;
                      .db $44,$54,$48,$5C,$68,$40,$4C,$40 ;; ?QPWZ?               ;
                      .db $3C,$40,$50,$54,$60,$54,$4C,$5C ;; ?QPWZ?               ;
                      .db $5C,$68,$74,$6C,$7C,$78,$68,$80 ;; ?QPWZ?               ;
                      .db $18,$48,$2C,$1C                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C67A:          .db $1C,$0C,$08,$1C,$14,$08,$14,$24 ;; 03C67A               ;
                      .db $28,$2C,$30,$3C,$44,$4C,$44,$34 ;; ?QPWZ?               ;
                      .db $40,$34,$24,$1C,$10,$0C,$18,$18 ;; ?QPWZ?               ;
                      .db $2C,$28,$68,$28,$34,$34,$38,$40 ;; ?QPWZ?               ;
                      .db $44,$44,$38,$3C,$44,$48,$4C,$5C ;; ?QPWZ?               ;
                      .db $5C,$54,$64,$74,$74,$88,$80,$94 ;; ?QPWZ?               ;
                      .db $8C,$78,$6C,$64,$70,$7C,$8C,$98 ;; ?QPWZ?               ;
                      .db $90,$98,$84,$84,$88,$78,$78,$6C ;; ?QPWZ?               ;
                      .db $5C,$50,$50,$48,$50,$5C,$64,$64 ;; ?QPWZ?               ;
                      .db $74,$78,$74,$64,$60,$58,$54,$50 ;; ?QPWZ?               ;
                      .db $50,$58,$30,$34                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C6CE:          .db $20,$30,$39,$47,$50,$60,$70,$7C ;; 03C6CE               ;
                      .db $7B,$80,$7D,$78,$6E,$60,$4F,$47 ;; ?QPWZ?               ;
                      .db $41,$38,$30,$2A,$20,$10,$04,$00 ;; ?QPWZ?               ;
                      .db $00,$08,$10,$20,$1A,$10,$0A,$06 ;; ?QPWZ?               ;
                      .db $0F,$17,$16,$1C,$1F,$21,$10,$18 ;; ?QPWZ?               ;
                      .db $20,$2C,$2E,$3B,$30,$30,$2D,$2A ;; ?QPWZ?               ;
                      .db $34,$36,$3A,$3F,$45,$4D,$5F,$54 ;; ?QPWZ?               ;
                      .db $4E,$67,$70,$67,$70,$5C,$4E,$40 ;; ?QPWZ?               ;
                      .db $48,$56,$57,$5F,$68,$72,$77,$6F ;; ?QPWZ?               ;
                      .db $66,$60,$67,$5C,$57,$4B,$4D,$54 ;; ?QPWZ?               ;
                      .db $48,$43,$3D,$3C                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C722:          .db $18,$1E,$25,$22,$1A,$17,$20,$30 ;; 03C722               ;
                      .db $41,$4F,$61,$70,$7F,$8C,$94,$92 ;; ?QPWZ?               ;
                      .db $A0,$86,$93,$88,$88,$78,$66,$50 ;; ?QPWZ?               ;
                      .db $40,$30,$22,$20,$2C,$30,$40,$4F ;; ?QPWZ?               ;
                      .db $59,$51,$3F,$39,$4C,$5F,$6A,$6F ;; ?QPWZ?               ;
                      .db $77,$7E,$6C,$60,$58,$48,$3D,$2F ;; ?QPWZ?               ;
                      .db $28,$38,$44,$30,$36,$27,$21,$2F ;; ?QPWZ?               ;
                      .db $39,$2A,$2F,$39,$40,$3F,$49,$50 ;; ?QPWZ?               ;
                      .db $60,$59,$4C,$51,$48,$4F,$56,$67 ;; ?QPWZ?               ;
                      .db $5B,$68,$75,$7D,$87,$8A,$7A,$6B ;; ?QPWZ?               ;
                      .db $70,$82,$73,$92                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C776:          .db $60,$B0,$40,$80                 ;; 03C776               ;
                                                          ;;                      ;
FireworkSfx1:         .db $26,$00,$26,$28                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx2:         .db $00,$2B,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx3:         .db $27,$00,$27,$29                 ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx4:         .db $00,$2C,$00,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C78A:          .db $00,$AA,$FF,$AA                 ;; 03C78A               ;
                                                          ;;                      ;
DATA_03C78E:          .db $00,$7E,$27,$7E                 ;; 03C78E               ;
                                                          ;;                      ;
DATA_03C792:          .db $C0,$C0,$FF,$C0                 ;; 03C792               ;
                                                          ;;                      ;
CODE_03C796:          LDA.W $1564,X                       ;; 03C796 : BD 64 15    ;
CODE_03C799:          BEQ CODE_03C7A7                     ;; 03C799 : F0 0C       ;
CODE_03C79B:          DEC A                               ;; 03C79B : 3A          ;
CODE_03C79C:          BNE Return03C7A6                    ;; 03C79C : D0 08       ;
CODE_03C79E:          INC.W $13C6                         ;; 03C79E : EE C6 13    ;
CODE_03C7A1:          LDA.B #$FF                          ;; 03C7A1 : A9 FF       ;
CODE_03C7A3:          STA.W $1493                         ;; 03C7A3 : 8D 93 14    ;
Return03C7A6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C7A7:          LDA.W $156D                         ;; 03C7A7 : AD 6D 15    ;
CODE_03C7AA:          AND.B #$03                          ;; 03C7AA : 29 03       ;
CODE_03C7AC:          TAY                                 ;; 03C7AC : A8          ;
CODE_03C7AD:          LDA.W DATA_03C78A,Y                 ;; 03C7AD : B9 8A C7    ;
CODE_03C7B0:          STA.W $0701                         ;; 03C7B0 : 8D 01 07    ;
CODE_03C7B3:          LDA.W DATA_03C78E,Y                 ;; 03C7B3 : B9 8E C7    ;
CODE_03C7B6:          STA.W $0702                         ;; 03C7B6 : 8D 02 07    ;
CODE_03C7B9:          LDA.W $1FEB                         ;; 03C7B9 : AD EB 1F    ;
CODE_03C7BC:          BNE Return03C80F                    ;; 03C7BC : D0 51       ;
CODE_03C7BE:          LDA.W $1534,X                       ;; 03C7BE : BD 34 15    ;
CODE_03C7C1:          CMP.B #$04                          ;; 03C7C1 : C9 04       ;
CODE_03C7C3:          BEQ CODE_03C810                     ;; 03C7C3 : F0 4B       ;
CODE_03C7C5:          LDY.B #$01                          ;; 03C7C5 : A0 01       ;
CODE_03C7C7:          LDA.W $14C8,Y                       ;; 03C7C7 : B9 C8 14    ;
CODE_03C7CA:          BEQ CODE_03C7D0                     ;; 03C7CA : F0 04       ;
ADDR_03C7CC:          DEY                                 ;; 03C7CC : 88          ;
ADDR_03C7CD:          BPL CODE_03C7C7                     ;; 03C7CD : 10 F8       ;
Return03C7CF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C7D0:          LDA.B #$08                          ;; 03C7D0 : A9 08       ; \ Sprite status = Normal 
CODE_03C7D2:          STA.W $14C8,Y                       ;; 03C7D2 : 99 C8 14    ; / 
CODE_03C7D5:          LDA.B #$7A                          ;; 03C7D5 : A9 7A       ;
CODE_03C7D7:          STA.W RAM_SpriteNum,Y               ;; 03C7D7 : 99 9E 00    ;
CODE_03C7DA:          LDA.B #$00                          ;; 03C7DA : A9 00       ;
CODE_03C7DC:          STA.W RAM_SpriteXHi,Y               ;; 03C7DC : 99 E0 14    ;
CODE_03C7DF:          LDA.B #$A8                          ;; 03C7DF : A9 A8       ;
CODE_03C7E1:          CLC                                 ;; 03C7E1 : 18          ;
CODE_03C7E2:          ADC RAM_ScreenBndryYLo              ;; 03C7E2 : 65 1C       ;
CODE_03C7E4:          STA.W RAM_SpriteYLo,Y               ;; 03C7E4 : 99 D8 00    ;
CODE_03C7E7:          LDA RAM_ScreenBndryYHi              ;; 03C7E7 : A5 1D       ;
CODE_03C7E9:          ADC.B #$00                          ;; 03C7E9 : 69 00       ;
CODE_03C7EB:          STA.W RAM_SpriteYHi,Y               ;; 03C7EB : 99 D4 14    ;
CODE_03C7EE:          PHX                                 ;; 03C7EE : DA          ;
CODE_03C7EF:          TYX                                 ;; 03C7EF : BB          ;
CODE_03C7F0:          JSL.L InitSpriteTables              ;; 03C7F0 : 22 D2 F7 07 ;
CODE_03C7F4:          PLX                                 ;; 03C7F4 : FA          ;
CODE_03C7F5:          PHX                                 ;; 03C7F5 : DA          ;
CODE_03C7F6:          LDA.W $1534,X                       ;; 03C7F6 : BD 34 15    ;
CODE_03C7F9:          AND.B #$03                          ;; 03C7F9 : 29 03       ;
CODE_03C7FB:          STA.W $1534,Y                       ;; 03C7FB : 99 34 15    ;
CODE_03C7FE:          TAX                                 ;; 03C7FE : AA          ;
CODE_03C7FF:          LDA.W DATA_03C792,X                 ;; 03C7FF : BD 92 C7    ;
CODE_03C802:          STA.W $1FEB                         ;; 03C802 : 8D EB 1F    ;
CODE_03C805:          LDA.W DATA_03C776,X                 ;; 03C805 : BD 76 C7    ;
CODE_03C808:          STA.W RAM_SpriteXLo,Y               ;; 03C808 : 99 E4 00    ;
CODE_03C80B:          PLX                                 ;; 03C80B : FA          ;
CODE_03C80C:          INC.W $1534,X                       ;; 03C80C : FE 34 15    ;
Return03C80F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C810:          LDA.B #$70                          ;; 03C810 : A9 70       ;
CODE_03C812:          STA.W $1564,X                       ;; 03C812 : 9D 64 15    ;
Return03C815:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
Firework:             LDA RAM_SpriteState,X               ;; ?QPWZ? : B5 C2       ;
CODE_03C818:          JSL.L ExecutePtr                    ;; 03C818 : 22 DF 86 00 ;
                                                          ;;                      ;
FireworkPtrs:         .dw CODE_03C828                     ;; ?QPWZ? : 28 C8       ;
                      .dw CODE_03C845                     ;; ?QPWZ? : 45 C8       ;
                      .dw CODE_03C88D                     ;; ?QPWZ? : 8D C8       ;
                      .dw CODE_03C941                     ;; ?QPWZ? : 41 C9       ;
                                                          ;;                      ;
FireworkSpeedY:       .db $E4,$E6,$E4,$E2                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C828:          LDY.W $1534,X                       ;; 03C828 : BC 34 15    ;
CODE_03C82B:          LDA.W FireworkSpeedY,Y              ;; 03C82B : B9 24 C8    ;
CODE_03C82E:          STA RAM_SpriteSpeedY,X              ;; 03C82E : 95 AA       ;
CODE_03C830:          LDA.B #$25                          ;; 03C830 : A9 25       ; \ Play sound effect 
CODE_03C832:          STA.W $1DFC                         ;; 03C832 : 8D FC 1D    ; / 
CODE_03C835:          LDA.B #$10                          ;; 03C835 : A9 10       ;
CODE_03C837:          STA.W $1564,X                       ;; 03C837 : 9D 64 15    ;
CODE_03C83A:          INC RAM_SpriteState,X               ;; 03C83A : F6 C2       ;
Return03C83C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C83D:          .db $14,$0C,$10,$15                 ;; 03C83D               ;
                                                          ;;                      ;
DATA_03C841:          .db $08,$10,$0C,$05                 ;; 03C841               ;
                                                          ;;                      ;
CODE_03C845:          LDA.W $1564,X                       ;; 03C845 : BD 64 15    ;
CODE_03C848:          CMP.B #$01                          ;; 03C848 : C9 01       ;
CODE_03C84A:          BNE CODE_03C85B                     ;; 03C84A : D0 0F       ;
CODE_03C84C:          LDY.W $1534,X                       ;; 03C84C : BC 34 15    ;
CODE_03C84F:          LDA.W FireworkSfx1,Y                ;; 03C84F : B9 7A C7    ; \ Play sound effect 
CODE_03C852:          STA.W $1DF9                         ;; 03C852 : 8D F9 1D    ; / 
CODE_03C855:          LDA.W FireworkSfx2,Y                ;; 03C855 : B9 7E C7    ; \ Play sound effect 
CODE_03C858:          STA.W $1DFC                         ;; 03C858 : 8D FC 1D    ; / 
CODE_03C85B:          JSL.L UpdateYPosNoGrvty             ;; 03C85B : 22 1A 80 01 ;
CODE_03C85F:          INC RAM_SpriteSpeedX,X              ;; 03C85F : F6 B6       ;
CODE_03C861:          LDA RAM_SpriteSpeedX,X              ;; 03C861 : B5 B6       ;
CODE_03C863:          AND.B #$03                          ;; 03C863 : 29 03       ;
CODE_03C865:          BNE CODE_03C869                     ;; 03C865 : D0 02       ;
CODE_03C867:          INC RAM_SpriteSpeedY,X              ;; 03C867 : F6 AA       ;
CODE_03C869:          LDA RAM_SpriteSpeedY,X              ;; 03C869 : B5 AA       ;
CODE_03C86B:          CMP.B #$FC                          ;; 03C86B : C9 FC       ;
CODE_03C86D:          BNE CODE_03C885                     ;; 03C86D : D0 16       ;
CODE_03C86F:          INC RAM_SpriteState,X               ;; 03C86F : F6 C2       ;
CODE_03C871:          LDY.W $1534,X                       ;; 03C871 : BC 34 15    ;
CODE_03C874:          LDA.W DATA_03C83D,Y                 ;; 03C874 : B9 3D C8    ;
CODE_03C877:          STA.W $151C,X                       ;; 03C877 : 9D 1C 15    ;
CODE_03C87A:          LDA.W DATA_03C841,Y                 ;; 03C87A : B9 41 C8    ;
CODE_03C87D:          STA.W $15AC,X                       ;; 03C87D : 9D AC 15    ;
CODE_03C880:          LDA.B #$08                          ;; 03C880 : A9 08       ;
CODE_03C882:          STA.W $156D                         ;; 03C882 : 8D 6D 15    ;
CODE_03C885:          JSR.W CODE_03C96D                   ;; 03C885 : 20 6D C9    ;
Return03C888:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C889:          .db $FF,$80,$C0,$FF                 ;; 03C889               ;
                                                          ;;                      ;
CODE_03C88D:          LDA.W $15AC,X                       ;; 03C88D : BD AC 15    ;
CODE_03C890:          DEC A                               ;; 03C890 : 3A          ;
CODE_03C891:          BNE CODE_03C8A2                     ;; 03C891 : D0 0F       ;
CODE_03C893:          LDY.W $1534,X                       ;; 03C893 : BC 34 15    ;
CODE_03C896:          LDA.W FireworkSfx3,Y                ;; 03C896 : B9 82 C7    ; \ Play sound effect 
CODE_03C899:          STA.W $1DF9                         ;; 03C899 : 8D F9 1D    ; / 
CODE_03C89C:          LDA.W FireworkSfx4,Y                ;; 03C89C : B9 86 C7    ; \ Play sound effect 
CODE_03C89F:          STA.W $1DFC                         ;; 03C89F : 8D FC 1D    ; / 
CODE_03C8A2:          JSR.W CODE_03C8B1                   ;; 03C8A2 : 20 B1 C8    ;
CODE_03C8A5:          LDA RAM_SpriteState,X               ;; 03C8A5 : B5 C2       ;
CODE_03C8A7:          CMP.B #$02                          ;; 03C8A7 : C9 02       ;
CODE_03C8A9:          BNE CODE_03C8AE                     ;; 03C8A9 : D0 03       ;
CODE_03C8AB:          JSR.W CODE_03C8B1                   ;; 03C8AB : 20 B1 C8    ;
CODE_03C8AE:          JMP.W CODE_03C9E9                   ;; 03C8AE : 4C E9 C9    ;
                                                          ;;                      ;
CODE_03C8B1:          LDY.W $1534,X                       ;; 03C8B1 : BC 34 15    ;
CODE_03C8B4:          LDA.W $1570,X                       ;; 03C8B4 : BD 70 15    ;
CODE_03C8B7:          CLC                                 ;; 03C8B7 : 18          ;
CODE_03C8B8:          ADC.W $151C,X                       ;; 03C8B8 : 7D 1C 15    ;
CODE_03C8BB:          STA.W $1570,X                       ;; 03C8BB : 9D 70 15    ;
CODE_03C8BE:          BCS ADDR_03C8DB                     ;; 03C8BE : B0 1B       ;
CODE_03C8C0:          CMP.W DATA_03C889,Y                 ;; 03C8C0 : D9 89 C8    ;
CODE_03C8C3:          BCS CODE_03C8E0                     ;; 03C8C3 : B0 1B       ;
CODE_03C8C5:          LDA.W $151C,X                       ;; 03C8C5 : BD 1C 15    ;
CODE_03C8C8:          CMP.B #$02                          ;; 03C8C8 : C9 02       ;
CODE_03C8CA:          BCC CODE_03C8D4                     ;; 03C8CA : 90 08       ;
CODE_03C8CC:          SEC                                 ;; 03C8CC : 38          ;
CODE_03C8CD:          SBC.B #$01                          ;; 03C8CD : E9 01       ;
CODE_03C8CF:          STA.W $151C,X                       ;; 03C8CF : 9D 1C 15    ;
CODE_03C8D2:          BCS CODE_03C8E4                     ;; 03C8D2 : B0 10       ;
CODE_03C8D4:          LDA.B #$01                          ;; 03C8D4 : A9 01       ;
CODE_03C8D6:          STA.W $151C,X                       ;; 03C8D6 : 9D 1C 15    ;
CODE_03C8D9:          BRA CODE_03C8E4                     ;; 03C8D9 : 80 09       ;
                                                          ;;                      ;
ADDR_03C8DB:          LDA.B #$FF                          ;; 03C8DB : A9 FF       ;
ADDR_03C8DD:          STA.W $1570,X                       ;; 03C8DD : 9D 70 15    ;
CODE_03C8E0:          INC RAM_SpriteState,X               ;; 03C8E0 : F6 C2       ;
CODE_03C8E2:          STZ RAM_SpriteSpeedY,X              ;; 03C8E2 : 74 AA       ; Sprite Y Speed = 0 
CODE_03C8E4:          LDA.W $151C,X                       ;; 03C8E4 : BD 1C 15    ;
CODE_03C8E7:          AND.B #$FF                          ;; 03C8E7 : 29 FF       ;
CODE_03C8E9:          TAY                                 ;; 03C8E9 : A8          ;
CODE_03C8EA:          LDA.W DATA_03C8F1,Y                 ;; 03C8EA : B9 F1 C8    ;
CODE_03C8ED:          STA.W $1602,X                       ;; 03C8ED : 9D 02 16    ;
Return03C8F0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C8F1:          .db $06,$05,$04,$03,$03,$03,$03,$02 ;; 03C8F1               ;
                      .db $02,$02,$02,$02,$02,$02,$01,$01 ;; ?QPWZ?               ;
                      .db $01,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $03,$03,$03,$03,$03,$03,$03,$03 ;; ?QPWZ?               ;
                      .db $03,$03,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$02,$02,$02,$02,$02 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C941:          LDA RAM_FrameCounter                ;; 03C941 : A5 13       ;
CODE_03C943:          AND.B #$07                          ;; 03C943 : 29 07       ;
CODE_03C945:          BNE CODE_03C949                     ;; 03C945 : D0 02       ;
CODE_03C947:          INC RAM_SpriteSpeedY,X              ;; 03C947 : F6 AA       ;
CODE_03C949:          JSL.L UpdateYPosNoGrvty             ;; 03C949 : 22 1A 80 01 ;
CODE_03C94D:          LDA.B #$07                          ;; 03C94D : A9 07       ;
CODE_03C94F:          LDY RAM_SpriteSpeedY,X              ;; 03C94F : B4 AA       ;
CODE_03C951:          CPY.B #$08                          ;; 03C951 : C0 08       ;
CODE_03C953:          BNE CODE_03C958                     ;; 03C953 : D0 03       ;
CODE_03C955:          STZ.W $14C8,X                       ;; 03C955 : 9E C8 14    ;
CODE_03C958:          CPY.B #$03                          ;; 03C958 : C0 03       ;
CODE_03C95A:          BCC CODE_03C962                     ;; 03C95A : 90 06       ;
CODE_03C95C:          INC A                               ;; 03C95C : 1A          ;
CODE_03C95D:          CPY.B #$05                          ;; 03C95D : C0 05       ;
CODE_03C95F:          BCC CODE_03C962                     ;; 03C95F : 90 01       ;
CODE_03C961:          INC A                               ;; 03C961 : 1A          ;
CODE_03C962:          STA.W $1602,X                       ;; 03C962 : 9D 02 16    ;
CODE_03C965:          JSR.W CODE_03C9E9                   ;; 03C965 : 20 E9 C9    ;
Return03C968:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C969:          .db $EC,$8E,$EC,$EC                 ;; 03C969               ;
                                                          ;;                      ;
CODE_03C96D:          TXA                                 ;; 03C96D : 8A          ;
CODE_03C96E:          EOR RAM_FrameCounter                ;; 03C96E : 45 13       ;
CODE_03C970:          AND.B #$03                          ;; 03C970 : 29 03       ;
CODE_03C972:          BNE Return03C9B8                    ;; 03C972 : D0 44       ;
CODE_03C974:          JSR.W GetDrawInfoBnk3               ;; 03C974 : 20 60 B7    ;
CODE_03C977:          LDY.B #$00                          ;; 03C977 : A0 00       ;
CODE_03C979:          LDA $00                             ;; 03C979 : A5 00       ;
CODE_03C97B:          STA.W OAM_DispX,Y                   ;; 03C97B : 99 00 03    ;
CODE_03C97E:          STA.W OAM_Tile2DispX,Y              ;; 03C97E : 99 04 03    ;
CODE_03C981:          LDA $01                             ;; 03C981 : A5 01       ;
CODE_03C983:          STA.W OAM_DispY,Y                   ;; 03C983 : 99 01 03    ;
CODE_03C986:          PHX                                 ;; 03C986 : DA          ;
CODE_03C987:          LDA.W $1534,X                       ;; 03C987 : BD 34 15    ;
CODE_03C98A:          TAX                                 ;; 03C98A : AA          ;
CODE_03C98B:          LDA RAM_FrameCounter                ;; 03C98B : A5 13       ;
CODE_03C98D:          LSR                                 ;; 03C98D : 4A          ;
CODE_03C98E:          LSR                                 ;; 03C98E : 4A          ;
CODE_03C98F:          AND.B #$02                          ;; 03C98F : 29 02       ;
CODE_03C991:          LSR                                 ;; 03C991 : 4A          ;
CODE_03C992:          ADC.W DATA_03C969,X                 ;; 03C992 : 7D 69 C9    ;
CODE_03C995:          STA.W OAM_Tile,Y                    ;; 03C995 : 99 02 03    ;
CODE_03C998:          PLX                                 ;; 03C998 : FA          ;
CODE_03C999:          LDA RAM_FrameCounter                ;; 03C999 : A5 13       ;
CODE_03C99B:          ASL                                 ;; 03C99B : 0A          ;
CODE_03C99C:          AND.B #$0E                          ;; 03C99C : 29 0E       ;
CODE_03C99E:          STA $02                             ;; 03C99E : 85 02       ;
CODE_03C9A0:          LDA RAM_FrameCounter                ;; 03C9A0 : A5 13       ;
CODE_03C9A2:          ASL                                 ;; 03C9A2 : 0A          ;
CODE_03C9A3:          ASL                                 ;; 03C9A3 : 0A          ;
CODE_03C9A4:          ASL                                 ;; 03C9A4 : 0A          ;
CODE_03C9A5:          ASL                                 ;; 03C9A5 : 0A          ;
CODE_03C9A6:          AND.B #$40                          ;; 03C9A6 : 29 40       ;
CODE_03C9A8:          ORA $02                             ;; 03C9A8 : 05 02       ;
CODE_03C9AA:          ORA.B #$31                          ;; 03C9AA : 09 31       ;
CODE_03C9AC:          STA.W OAM_Prop,Y                    ;; 03C9AC : 99 03 03    ;
CODE_03C9AF:          TYA                                 ;; 03C9AF : 98          ;
CODE_03C9B0:          LSR                                 ;; 03C9B0 : 4A          ;
CODE_03C9B1:          LSR                                 ;; 03C9B1 : 4A          ;
CODE_03C9B2:          TAY                                 ;; 03C9B2 : A8          ;
CODE_03C9B3:          LDA.B #$00                          ;; 03C9B3 : A9 00       ;
CODE_03C9B5:          STA.W OAM_TileSize,Y                ;; 03C9B5 : 99 60 04    ;
Return03C9B8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C9B9:          .db $36,$35,$C7,$34,$34,$34,$34,$24 ;; 03C9B9               ;
                      .db $03,$03,$36,$35,$C7,$34,$34,$24 ;; ?QPWZ?               ;
                      .db $24,$24,$24,$03,$36,$35,$C7,$34 ;; ?QPWZ?               ;
                      .db $34,$34,$24,$24,$03,$24,$36,$35 ;; ?QPWZ?               ;
                      .db $C7,$34,$24,$24,$24,$24,$24,$03 ;; ?QPWZ?               ;
DATA_03C9E1:          .db $00,$01,$01,$00,$00,$FF,$FF,$00 ;; 03C9E1               ;
                                                          ;;                      ;
CODE_03C9E9:          TXA                                 ;; 03C9E9 : 8A          ;
CODE_03C9EA:          EOR RAM_FrameCounter                ;; 03C9EA : 45 13       ;
CODE_03C9EC:          STA $05                             ;; 03C9EC : 85 05       ;
CODE_03C9EE:          LDA.W $1570,X                       ;; 03C9EE : BD 70 15    ;
CODE_03C9F1:          STA $06                             ;; 03C9F1 : 85 06       ;
CODE_03C9F3:          LDA.W $1602,X                       ;; 03C9F3 : BD 02 16    ;
CODE_03C9F6:          STA $07                             ;; 03C9F6 : 85 07       ;
CODE_03C9F8:          LDA RAM_SpriteXLo,X                 ;; 03C9F8 : B5 E4       ;
CODE_03C9FA:          STA $08                             ;; 03C9FA : 85 08       ;
CODE_03C9FC:          LDA RAM_SpriteYLo,X                 ;; 03C9FC : B5 D8       ;
CODE_03C9FE:          SEC                                 ;; 03C9FE : 38          ;
CODE_03C9FF:          SBC RAM_ScreenBndryYLo              ;; 03C9FF : E5 1C       ;
CODE_03CA01:          STA $09                             ;; 03CA01 : 85 09       ;
CODE_03CA03:          LDA.W $1534,X                       ;; 03CA03 : BD 34 15    ;
CODE_03CA06:          STA $0A                             ;; 03CA06 : 85 0A       ;
CODE_03CA08:          PHX                                 ;; 03CA08 : DA          ;
CODE_03CA09:          LDX.B #$3F                          ;; 03CA09 : A2 3F       ;
CODE_03CA0B:          LDY.B #$00                          ;; 03CA0B : A0 00       ;
CODE_03CA0D:          STX $04                             ;; 03CA0D : 86 04       ;
CODE_03CA0F:          LDA $0A                             ;; 03CA0F : A5 0A       ;
CODE_03CA11:          CMP.B #$03                          ;; 03CA11 : C9 03       ;
CODE_03CA13:          LDA.W DATA_03C626,X                 ;; 03CA13 : BD 26 C6    ;
CODE_03CA16:          BCC CODE_03CA1B                     ;; 03CA16 : 90 03       ;
CODE_03CA18:          LDA.W DATA_03C6CE,X                 ;; 03CA18 : BD CE C6    ;
CODE_03CA1B:          SEC                                 ;; 03CA1B : 38          ;
CODE_03CA1C:          SBC.B #$40                          ;; 03CA1C : E9 40       ;
CODE_03CA1E:          STA $00                             ;; 03CA1E : 85 00       ;
CODE_03CA20:          PHY                                 ;; 03CA20 : 5A          ;
CODE_03CA21:          LDA $0A                             ;; 03CA21 : A5 0A       ;
CODE_03CA23:          CMP.B #$03                          ;; 03CA23 : C9 03       ;
CODE_03CA25:          LDA.W DATA_03C67A,X                 ;; 03CA25 : BD 7A C6    ;
CODE_03CA28:          BCC CODE_03CA2D                     ;; 03CA28 : 90 03       ;
CODE_03CA2A:          LDA.W DATA_03C722,X                 ;; 03CA2A : BD 22 C7    ;
CODE_03CA2D:          SEC                                 ;; 03CA2D : 38          ;
CODE_03CA2E:          SBC.B #$50                          ;; 03CA2E : E9 50       ;
CODE_03CA30:          STA $01                             ;; 03CA30 : 85 01       ;
CODE_03CA32:          LDA $00                             ;; 03CA32 : A5 00       ;
CODE_03CA34:          BPL CODE_03CA39                     ;; 03CA34 : 10 03       ;
CODE_03CA36:          EOR.B #$FF                          ;; 03CA36 : 49 FF       ;
CODE_03CA38:          INC A                               ;; 03CA38 : 1A          ;
CODE_03CA39:          STA.W $4202                         ;; 03CA39 : 8D 02 42    ; Multiplicand A
CODE_03CA3C:          LDA $06                             ;; 03CA3C : A5 06       ;
CODE_03CA3E:          STA.W $4203                         ;; 03CA3E : 8D 03 42    ; Multplier B
CODE_03CA41:          NOP                                 ;; 03CA41 : EA          ;
CODE_03CA42:          NOP                                 ;; 03CA42 : EA          ;
CODE_03CA43:          NOP                                 ;; 03CA43 : EA          ;
CODE_03CA44:          NOP                                 ;; 03CA44 : EA          ;
CODE_03CA45:          LDA.W $4217                         ;; 03CA45 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_03CA48:          LDY $00                             ;; 03CA48 : A4 00       ;
CODE_03CA4A:          BPL CODE_03CA4F                     ;; 03CA4A : 10 03       ;
CODE_03CA4C:          EOR.B #$FF                          ;; 03CA4C : 49 FF       ;
CODE_03CA4E:          INC A                               ;; 03CA4E : 1A          ;
CODE_03CA4F:          STA $02                             ;; 03CA4F : 85 02       ;
CODE_03CA51:          LDA $01                             ;; 03CA51 : A5 01       ;
CODE_03CA53:          BPL CODE_03CA58                     ;; 03CA53 : 10 03       ;
CODE_03CA55:          EOR.B #$FF                          ;; 03CA55 : 49 FF       ;
CODE_03CA57:          INC A                               ;; 03CA57 : 1A          ;
CODE_03CA58:          STA.W $4202                         ;; 03CA58 : 8D 02 42    ; Multiplicand A
CODE_03CA5B:          LDA $06                             ;; 03CA5B : A5 06       ;
CODE_03CA5D:          STA.W $4203                         ;; 03CA5D : 8D 03 42    ; Multplier B
CODE_03CA60:          NOP                                 ;; 03CA60 : EA          ;
CODE_03CA61:          NOP                                 ;; 03CA61 : EA          ;
CODE_03CA62:          NOP                                 ;; 03CA62 : EA          ;
CODE_03CA63:          NOP                                 ;; 03CA63 : EA          ;
CODE_03CA64:          LDA.W $4217                         ;; 03CA64 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_03CA67:          LDY $01                             ;; 03CA67 : A4 01       ;
CODE_03CA69:          BPL CODE_03CA6E                     ;; 03CA69 : 10 03       ;
CODE_03CA6B:          EOR.B #$FF                          ;; 03CA6B : 49 FF       ;
CODE_03CA6D:          INC A                               ;; 03CA6D : 1A          ;
CODE_03CA6E:          STA $03                             ;; 03CA6E : 85 03       ;
CODE_03CA70:          LDY.B #$00                          ;; 03CA70 : A0 00       ;
CODE_03CA72:          LDA $07                             ;; 03CA72 : A5 07       ;
CODE_03CA74:          CMP.B #$06                          ;; 03CA74 : C9 06       ;
CODE_03CA76:          BCC CODE_03CA82                     ;; 03CA76 : 90 0A       ;
CODE_03CA78:          LDA $05                             ;; 03CA78 : A5 05       ;
CODE_03CA7A:          CLC                                 ;; 03CA7A : 18          ;
CODE_03CA7B:          ADC $04                             ;; 03CA7B : 65 04       ;
CODE_03CA7D:          LSR                                 ;; 03CA7D : 4A          ;
CODE_03CA7E:          LSR                                 ;; 03CA7E : 4A          ;
CODE_03CA7F:          AND.B #$07                          ;; 03CA7F : 29 07       ;
CODE_03CA81:          TAY                                 ;; 03CA81 : A8          ;
CODE_03CA82:          LDA.W DATA_03C9E1,Y                 ;; 03CA82 : B9 E1 C9    ;
CODE_03CA85:          PLY                                 ;; 03CA85 : 7A          ;
CODE_03CA86:          CLC                                 ;; 03CA86 : 18          ;
CODE_03CA87:          ADC $02                             ;; 03CA87 : 65 02       ;
CODE_03CA89:          CLC                                 ;; 03CA89 : 18          ;
CODE_03CA8A:          ADC $08                             ;; 03CA8A : 65 08       ;
CODE_03CA8C:          STA.W OAM_ExtendedDispX,Y           ;; 03CA8C : 99 00 02    ;
CODE_03CA8F:          LDA $03                             ;; 03CA8F : A5 03       ;
CODE_03CA91:          CLC                                 ;; 03CA91 : 18          ;
CODE_03CA92:          ADC $09                             ;; 03CA92 : 65 09       ;
CODE_03CA94:          STA.W OAM_ExtendedDispY,Y           ;; 03CA94 : 99 01 02    ;
CODE_03CA97:          PHX                                 ;; 03CA97 : DA          ;
CODE_03CA98:          LDA $05                             ;; 03CA98 : A5 05       ;
CODE_03CA9A:          AND.B #$03                          ;; 03CA9A : 29 03       ;
CODE_03CA9C:          STA $0F                             ;; 03CA9C : 85 0F       ;
CODE_03CA9E:          ASL                                 ;; 03CA9E : 0A          ;
CODE_03CA9F:          ASL                                 ;; 03CA9F : 0A          ;
CODE_03CAA0:          ASL                                 ;; 03CAA0 : 0A          ;
CODE_03CAA1:          ADC $0F                             ;; 03CAA1 : 65 0F       ;
CODE_03CAA3:          ADC $0F                             ;; 03CAA3 : 65 0F       ;
CODE_03CAA5:          ADC $07                             ;; 03CAA5 : 65 07       ;
CODE_03CAA7:          TAX                                 ;; 03CAA7 : AA          ;
CODE_03CAA8:          LDA.W DATA_03C9B9,X                 ;; 03CAA8 : BD B9 C9    ;
CODE_03CAAB:          STA.W OAM_ExtendedTile,Y            ;; 03CAAB : 99 02 02    ;
CODE_03CAAE:          PLX                                 ;; 03CAAE : FA          ;
CODE_03CAAF:          LDA $05                             ;; 03CAAF : A5 05       ;
CODE_03CAB1:          LSR                                 ;; 03CAB1 : 4A          ;
CODE_03CAB2:          NOP                                 ;; 03CAB2 : EA          ;
CODE_03CAB3:          NOP                                 ;; 03CAB3 : EA          ;
CODE_03CAB4:          PHX                                 ;; 03CAB4 : DA          ;
CODE_03CAB5:          LDX $0A                             ;; 03CAB5 : A6 0A       ;
CODE_03CAB7:          CPX.B #$03                          ;; 03CAB7 : E0 03       ;
CODE_03CAB9:          BEQ CODE_03CABD                     ;; 03CAB9 : F0 02       ;
CODE_03CABB:          EOR $04                             ;; 03CABB : 45 04       ;
CODE_03CABD:          AND.B #$0E                          ;; 03CABD : 29 0E       ;
CODE_03CABF:          ORA.B #$31                          ;; 03CABF : 09 31       ;
CODE_03CAC1:          STA.W OAM_ExtendedProp,Y            ;; 03CAC1 : 99 03 02    ;
CODE_03CAC4:          PLX                                 ;; 03CAC4 : FA          ;
CODE_03CAC5:          PHY                                 ;; 03CAC5 : 5A          ;
CODE_03CAC6:          TYA                                 ;; 03CAC6 : 98          ;
CODE_03CAC7:          LSR                                 ;; 03CAC7 : 4A          ;
CODE_03CAC8:          LSR                                 ;; 03CAC8 : 4A          ;
CODE_03CAC9:          TAY                                 ;; 03CAC9 : A8          ;
CODE_03CACA:          LDA.B #$00                          ;; 03CACA : A9 00       ;
CODE_03CACC:          STA.W $0420,Y                       ;; 03CACC : 99 20 04    ;
CODE_03CACF:          PLY                                 ;; 03CACF : 7A          ;
CODE_03CAD0:          INY                                 ;; 03CAD0 : C8          ;
CODE_03CAD1:          INY                                 ;; 03CAD1 : C8          ;
CODE_03CAD2:          INY                                 ;; 03CAD2 : C8          ;
CODE_03CAD3:          INY                                 ;; 03CAD3 : C8          ;
CODE_03CAD4:          DEX                                 ;; 03CAD4 : CA          ;
CODE_03CAD5:          BMI CODE_03CADA                     ;; 03CAD5 : 30 03       ;
CODE_03CAD7:          JMP.W CODE_03CA0D                   ;; 03CAD7 : 4C 0D CA    ;
                                                          ;;                      ;
CODE_03CADA:          LDX.B #$53                          ;; 03CADA : A2 53       ;
CODE_03CADC:          STX $04                             ;; 03CADC : 86 04       ;
CODE_03CADE:          LDA $0A                             ;; 03CADE : A5 0A       ;
CODE_03CAE0:          CMP.B #$03                          ;; 03CAE0 : C9 03       ;
CODE_03CAE2:          LDA.W DATA_03C626,X                 ;; 03CAE2 : BD 26 C6    ;
CODE_03CAE5:          BCC CODE_03CAEA                     ;; 03CAE5 : 90 03       ;
CODE_03CAE7:          LDA.W DATA_03C6CE,X                 ;; 03CAE7 : BD CE C6    ;
CODE_03CAEA:          SEC                                 ;; 03CAEA : 38          ;
CODE_03CAEB:          SBC.B #$40                          ;; 03CAEB : E9 40       ;
CODE_03CAED:          STA $00                             ;; 03CAED : 85 00       ;
CODE_03CAEF:          LDA $0A                             ;; 03CAEF : A5 0A       ;
CODE_03CAF1:          CMP.B #$03                          ;; 03CAF1 : C9 03       ;
CODE_03CAF3:          LDA.W DATA_03C67A,X                 ;; 03CAF3 : BD 7A C6    ;
CODE_03CAF6:          BCC CODE_03CAFB                     ;; 03CAF6 : 90 03       ;
CODE_03CAF8:          LDA.W DATA_03C722,X                 ;; 03CAF8 : BD 22 C7    ;
CODE_03CAFB:          SEC                                 ;; 03CAFB : 38          ;
CODE_03CAFC:          SBC.B #$50                          ;; 03CAFC : E9 50       ;
CODE_03CAFE:          STA $01                             ;; 03CAFE : 85 01       ;
CODE_03CB00:          PHY                                 ;; 03CB00 : 5A          ;
CODE_03CB01:          LDA $00                             ;; 03CB01 : A5 00       ;
CODE_03CB03:          BPL CODE_03CB08                     ;; 03CB03 : 10 03       ;
CODE_03CB05:          EOR.B #$FF                          ;; 03CB05 : 49 FF       ;
CODE_03CB07:          INC A                               ;; 03CB07 : 1A          ;
CODE_03CB08:          STA.W $4202                         ;; 03CB08 : 8D 02 42    ; Multiplicand A
CODE_03CB0B:          LDA $06                             ;; 03CB0B : A5 06       ;
CODE_03CB0D:          STA.W $4203                         ;; 03CB0D : 8D 03 42    ; Multplier B
CODE_03CB10:          NOP                                 ;; 03CB10 : EA          ;
CODE_03CB11:          NOP                                 ;; 03CB11 : EA          ;
CODE_03CB12:          NOP                                 ;; 03CB12 : EA          ;
CODE_03CB13:          NOP                                 ;; 03CB13 : EA          ;
CODE_03CB14:          LDA.W $4217                         ;; 03CB14 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_03CB17:          LDY $00                             ;; 03CB17 : A4 00       ;
CODE_03CB19:          BPL CODE_03CB1E                     ;; 03CB19 : 10 03       ;
CODE_03CB1B:          EOR.B #$FF                          ;; 03CB1B : 49 FF       ;
CODE_03CB1D:          INC A                               ;; 03CB1D : 1A          ;
CODE_03CB1E:          STA $02                             ;; 03CB1E : 85 02       ;
CODE_03CB20:          LDA $01                             ;; 03CB20 : A5 01       ;
CODE_03CB22:          BPL CODE_03CB27                     ;; 03CB22 : 10 03       ;
CODE_03CB24:          EOR.B #$FF                          ;; 03CB24 : 49 FF       ;
CODE_03CB26:          INC A                               ;; 03CB26 : 1A          ;
CODE_03CB27:          STA.W $4202                         ;; 03CB27 : 8D 02 42    ; Multiplicand A
CODE_03CB2A:          LDA $06                             ;; 03CB2A : A5 06       ;
CODE_03CB2C:          STA.W $4203                         ;; 03CB2C : 8D 03 42    ; Multplier B
CODE_03CB2F:          NOP                                 ;; 03CB2F : EA          ;
CODE_03CB30:          NOP                                 ;; 03CB30 : EA          ;
CODE_03CB31:          NOP                                 ;; 03CB31 : EA          ;
CODE_03CB32:          NOP                                 ;; 03CB32 : EA          ;
CODE_03CB33:          LDA.W $4217                         ;; 03CB33 : AD 17 42    ; Product/Remainder Result (High Byte)
CODE_03CB36:          LDY $01                             ;; 03CB36 : A4 01       ;
CODE_03CB38:          BPL CODE_03CB3D                     ;; 03CB38 : 10 03       ;
CODE_03CB3A:          EOR.B #$FF                          ;; 03CB3A : 49 FF       ;
CODE_03CB3C:          INC A                               ;; 03CB3C : 1A          ;
CODE_03CB3D:          STA $03                             ;; 03CB3D : 85 03       ;
CODE_03CB3F:          LDY.B #$00                          ;; 03CB3F : A0 00       ;
CODE_03CB41:          LDA $07                             ;; 03CB41 : A5 07       ;
CODE_03CB43:          CMP.B #$06                          ;; 03CB43 : C9 06       ;
CODE_03CB45:          BCC CODE_03CB51                     ;; 03CB45 : 90 0A       ;
CODE_03CB47:          LDA $05                             ;; 03CB47 : A5 05       ;
CODE_03CB49:          CLC                                 ;; 03CB49 : 18          ;
CODE_03CB4A:          ADC $04                             ;; 03CB4A : 65 04       ;
CODE_03CB4C:          LSR                                 ;; 03CB4C : 4A          ;
CODE_03CB4D:          LSR                                 ;; 03CB4D : 4A          ;
CODE_03CB4E:          AND.B #$07                          ;; 03CB4E : 29 07       ;
CODE_03CB50:          TAY                                 ;; 03CB50 : A8          ;
CODE_03CB51:          LDA.W DATA_03C9E1,Y                 ;; 03CB51 : B9 E1 C9    ;
CODE_03CB54:          PLY                                 ;; 03CB54 : 7A          ;
CODE_03CB55:          CLC                                 ;; 03CB55 : 18          ;
CODE_03CB56:          ADC $02                             ;; 03CB56 : 65 02       ;
CODE_03CB58:          CLC                                 ;; 03CB58 : 18          ;
CODE_03CB59:          ADC $08                             ;; 03CB59 : 65 08       ;
CODE_03CB5B:          STA.W OAM_DispX,Y                   ;; 03CB5B : 99 00 03    ;
CODE_03CB5E:          LDA $03                             ;; 03CB5E : A5 03       ;
CODE_03CB60:          CLC                                 ;; 03CB60 : 18          ;
CODE_03CB61:          ADC $09                             ;; 03CB61 : 65 09       ;
CODE_03CB63:          STA.W OAM_DispY,Y                   ;; 03CB63 : 99 01 03    ;
CODE_03CB66:          PHX                                 ;; 03CB66 : DA          ;
CODE_03CB67:          LDA $05                             ;; 03CB67 : A5 05       ;
CODE_03CB69:          AND.B #$03                          ;; 03CB69 : 29 03       ;
CODE_03CB6B:          STA $0F                             ;; 03CB6B : 85 0F       ;
CODE_03CB6D:          ASL                                 ;; 03CB6D : 0A          ;
CODE_03CB6E:          ASL                                 ;; 03CB6E : 0A          ;
CODE_03CB6F:          ASL                                 ;; 03CB6F : 0A          ;
CODE_03CB70:          ADC $0F                             ;; 03CB70 : 65 0F       ;
CODE_03CB72:          ADC $0F                             ;; 03CB72 : 65 0F       ;
CODE_03CB74:          ADC $07                             ;; 03CB74 : 65 07       ;
CODE_03CB76:          TAX                                 ;; 03CB76 : AA          ;
CODE_03CB77:          LDA.W DATA_03C9B9,X                 ;; 03CB77 : BD B9 C9    ;
CODE_03CB7A:          STA.W OAM_Tile,Y                    ;; 03CB7A : 99 02 03    ;
CODE_03CB7D:          PLX                                 ;; 03CB7D : FA          ;
CODE_03CB7E:          LDA $05                             ;; 03CB7E : A5 05       ;
CODE_03CB80:          LSR                                 ;; 03CB80 : 4A          ;
CODE_03CB81:          NOP                                 ;; 03CB81 : EA          ;
CODE_03CB82:          NOP                                 ;; 03CB82 : EA          ;
CODE_03CB83:          PHX                                 ;; 03CB83 : DA          ;
CODE_03CB84:          LDX $0A                             ;; 03CB84 : A6 0A       ;
CODE_03CB86:          CPX.B #$03                          ;; 03CB86 : E0 03       ;
CODE_03CB88:          BEQ CODE_03CB8C                     ;; 03CB88 : F0 02       ;
CODE_03CB8A:          EOR $04                             ;; 03CB8A : 45 04       ;
CODE_03CB8C:          AND.B #$0E                          ;; 03CB8C : 29 0E       ;
CODE_03CB8E:          ORA.B #$31                          ;; 03CB8E : 09 31       ;
CODE_03CB90:          STA.W OAM_Prop,Y                    ;; 03CB90 : 99 03 03    ;
CODE_03CB93:          PLX                                 ;; 03CB93 : FA          ;
CODE_03CB94:          PHY                                 ;; 03CB94 : 5A          ;
CODE_03CB95:          TYA                                 ;; 03CB95 : 98          ;
CODE_03CB96:          LSR                                 ;; 03CB96 : 4A          ;
CODE_03CB97:          LSR                                 ;; 03CB97 : 4A          ;
CODE_03CB98:          TAY                                 ;; 03CB98 : A8          ;
CODE_03CB99:          LDA.B #$00                          ;; 03CB99 : A9 00       ;
CODE_03CB9B:          STA.W OAM_TileSize,Y                ;; 03CB9B : 99 60 04    ;
CODE_03CB9E:          PLY                                 ;; 03CB9E : 7A          ;
CODE_03CB9F:          INY                                 ;; 03CB9F : C8          ;
CODE_03CBA0:          INY                                 ;; 03CBA0 : C8          ;
CODE_03CBA1:          INY                                 ;; 03CBA1 : C8          ;
CODE_03CBA2:          INY                                 ;; 03CBA2 : C8          ;
CODE_03CBA3:          DEX                                 ;; 03CBA3 : CA          ;
CODE_03CBA4:          CPX.B #$3F                          ;; 03CBA4 : E0 3F       ;
CODE_03CBA6:          BEQ CODE_03CBAB                     ;; 03CBA6 : F0 03       ;
CODE_03CBA8:          JMP.W CODE_03CADC                   ;; 03CBA8 : 4C DC CA    ;
                                                          ;;                      ;
CODE_03CBAB:          PLX                                 ;; 03CBAB : FA          ;
Return03CBAC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ChuckSprGenDispX:     .db $14,$EC                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ChuckSprGenSpeedHi:   .db $00,$FF                         ;; ?QPWZ?               ;
                                                          ;;                      ;
ChuckSprGenSpeedLo:   .db $18,$E8                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CBB3:          JSL.L FindFreeSprSlot               ;; 03CBB3 : 22 E4 A9 02 ; \ Return if no free slots 
CODE_03CBB7:          BMI Return03CC08                    ;; 03CBB7 : 30 4F       ; / 
CODE_03CBB9:          LDA.B #$1B                          ;; 03CBB9 : A9 1B       ; \ Sprite = Football 
CODE_03CBBB:          STA.W RAM_SpriteNum,Y               ;; 03CBBB : 99 9E 00    ; / 
CODE_03CBBE:          PHX                                 ;; 03CBBE : DA          ;
CODE_03CBBF:          TYX                                 ;; 03CBBF : BB          ;
CODE_03CBC0:          JSL.L InitSpriteTables              ;; 03CBC0 : 22 D2 F7 07 ;
CODE_03CBC4:          PLX                                 ;; 03CBC4 : FA          ;
CODE_03CBC5:          LDA.B #$08                          ;; 03CBC5 : A9 08       ; \ Sprite status = Normal 
CODE_03CBC7:          STA.W $14C8,Y                       ;; 03CBC7 : 99 C8 14    ; / 
CODE_03CBCA:          LDA RAM_SpriteYLo,X                 ;; 03CBCA : B5 D8       ;
CODE_03CBCC:          STA.W RAM_SpriteYLo,Y               ;; 03CBCC : 99 D8 00    ;
CODE_03CBCF:          LDA.W RAM_SpriteYHi,X               ;; 03CBCF : BD D4 14    ;
CODE_03CBD2:          STA.W RAM_SpriteYHi,Y               ;; 03CBD2 : 99 D4 14    ;
CODE_03CBD5:          LDA RAM_SpriteXLo,X                 ;; 03CBD5 : B5 E4       ;
CODE_03CBD7:          STA $01                             ;; 03CBD7 : 85 01       ;
CODE_03CBD9:          LDA.W RAM_SpriteXHi,X               ;; 03CBD9 : BD E0 14    ;
CODE_03CBDC:          STA $00                             ;; 03CBDC : 85 00       ;
CODE_03CBDE:          PHX                                 ;; 03CBDE : DA          ;
CODE_03CBDF:          LDA.W RAM_SpriteDir,X               ;; 03CBDF : BD 7C 15    ;
CODE_03CBE2:          TAX                                 ;; 03CBE2 : AA          ;
CODE_03CBE3:          LDA $01                             ;; 03CBE3 : A5 01       ;
CODE_03CBE5:          CLC                                 ;; 03CBE5 : 18          ;
CODE_03CBE6:          ADC.L ChuckSprGenDispX,X            ;; 03CBE6 : 7F AD CB 03 ;
CODE_03CBEA:          STA.W RAM_SpriteXLo,Y               ;; 03CBEA : 99 E4 00    ;
CODE_03CBED:          LDA $00                             ;; 03CBED : A5 00       ;
CODE_03CBEF:          ADC.L ChuckSprGenSpeedHi,X          ;; 03CBEF : 7F AF CB 03 ;
CODE_03CBF3:          STA.W RAM_SpriteXHi,Y               ;; 03CBF3 : 99 E0 14    ;
CODE_03CBF6:          LDA.L ChuckSprGenSpeedLo,X          ;; 03CBF6 : BF B1 CB 03 ;
CODE_03CBFA:          STA.W RAM_SpriteSpeedX,Y            ;; 03CBFA : 99 B6 00    ;
CODE_03CBFD:          LDA.B #$E0                          ;; 03CBFD : A9 E0       ;
CODE_03CBFF:          STA.W RAM_SpriteSpeedY,Y            ;; 03CBFF : 99 AA 00    ;
CODE_03CC02:          LDA.B #$10                          ;; 03CC02 : A9 10       ;
CODE_03CC04:          STA.W $1540,Y                       ;; 03CC04 : 99 40 15    ;
CODE_03CC07:          PLX                                 ;; 03CC07 : FA          ;
Return03CC08:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03CC09:          PHB                                 ;; 03CC09 : 8B          ; Wrapper 
CODE_03CC0A:          PHK                                 ;; 03CC0A : 4B          ;
CODE_03CC0B:          PLB                                 ;; 03CC0B : AB          ;
CODE_03CC0C:          STZ.W RAM_Tweaker1662,X             ;; 03CC0C : 9E 62 16    ;
CODE_03CC0F:          JSR.W CODE_03CC14                   ;; 03CC0F : 20 14 CC    ;
CODE_03CC12:          PLB                                 ;; 03CC12 : AB          ;
Return03CC13:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03CC14:          JSR.W CODE_03D484                   ;; 03CC14 : 20 84 D4    ;
CODE_03CC17:          LDA.W $14C8,X                       ;; 03CC17 : BD C8 14    ;
CODE_03CC1A:          CMP.B #$08                          ;; 03CC1A : C9 08       ;
CODE_03CC1C:          BNE Return03CC37                    ;; 03CC1C : D0 19       ;
CODE_03CC1E:          LDA RAM_SpritesLocked               ;; 03CC1E : A5 9D       ;
CODE_03CC20:          BNE Return03CC37                    ;; 03CC20 : D0 15       ;
CODE_03CC22:          LDA.W $151C,X                       ;; 03CC22 : BD 1C 15    ;
CODE_03CC25:          JSL.L ExecutePtr                    ;; 03CC25 : 22 DF 86 00 ;
                                                          ;;                      ;
PipeKoopaPtrs:        .dw CODE_03CC8A                     ;; ?QPWZ? : 8A CC       ;
                      .dw CODE_03CD21                     ;; ?QPWZ? : 21 CD       ;
                      .dw CODE_03CDC7                     ;; ?QPWZ? : C7 CD       ;
                      .dw CODE_03CDEF                     ;; ?QPWZ? : EF CD       ;
                      .dw CODE_03CE0E                     ;; ?QPWZ? : 0E CE       ;
                      .dw CODE_03CE5A                     ;; ?QPWZ? : 5A CE       ;
                      .dw CODE_03CE89                     ;; ?QPWZ? : 89 CE       ;
                                                          ;;                      ;
Return03CC37:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CC38:          .db $18,$38,$58,$78,$98,$B8,$D8,$78 ;; 03CC38               ;
DATA_03CC40:          .db $40,$50,$50,$40,$30,$40,$50,$40 ;; 03CC40               ;
DATA_03CC48:          .db $50,$4A,$50,$4A,$4A,$40,$4A,$48 ;; 03CC48               ;
                      .db $4A                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CC51:          .db $02,$04,$06,$08,$0B,$0C,$0E,$10 ;; 03CC51               ;
                      .db $13                             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CC5A:          .db $00,$01,$02,$03,$04,$05,$06,$00 ;; 03CC5A               ;
                      .db $01,$02,$03,$04,$05,$06,$00,$01 ;; ?QPWZ?               ;
                      .db $02,$03,$04,$05,$06,$00,$01,$02 ;; ?QPWZ?               ;
                      .db $03,$04,$05,$06,$00,$01,$02,$03 ;; ?QPWZ?               ;
                      .db $04,$05,$06,$00,$01,$02,$03,$04 ;; ?QPWZ?               ;
                      .db $05,$06,$00,$01,$02,$03,$04,$05 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CC8A:          LDA.W $1540,X                       ;; 03CC8A : BD 40 15    ;
CODE_03CC8D:          BNE Return03CCDF                    ;; 03CC8D : D0 50       ;
CODE_03CC8F:          LDA.W $1570,X                       ;; 03CC8F : BD 70 15    ;
CODE_03CC92:          BNE CODE_03CC9D                     ;; 03CC92 : D0 09       ;
CODE_03CC94:          JSL.L GetRand                       ;; 03CC94 : 22 F9 AC 01 ;
CODE_03CC98:          AND.B #$0F                          ;; 03CC98 : 29 0F       ;
CODE_03CC9A:          STA.W $160E,X                       ;; 03CC9A : 9D 0E 16    ;
CODE_03CC9D:          LDA.W $160E,X                       ;; 03CC9D : BD 0E 16    ;
CODE_03CCA0:          ORA.W $1570,X                       ;; 03CCA0 : 1D 70 15    ;
CODE_03CCA3:          TAY                                 ;; 03CCA3 : A8          ;
CODE_03CCA4:          LDA.W DATA_03CC5A,Y                 ;; 03CCA4 : B9 5A CC    ;
CODE_03CCA7:          TAY                                 ;; 03CCA7 : A8          ;
CODE_03CCA8:          LDA.W DATA_03CC38,Y                 ;; 03CCA8 : B9 38 CC    ;
CODE_03CCAB:          STA RAM_SpriteXLo,X                 ;; 03CCAB : 95 E4       ;
CODE_03CCAD:          LDA RAM_SpriteState,X               ;; 03CCAD : B5 C2       ;
CODE_03CCAF:          CMP.B #$06                          ;; 03CCAF : C9 06       ;
CODE_03CCB1:          LDA.W DATA_03CC40,Y                 ;; 03CCB1 : B9 40 CC    ;
CODE_03CCB4:          BCC CODE_03CCB8                     ;; 03CCB4 : 90 02       ;
CODE_03CCB6:          LDA.B #$50                          ;; 03CCB6 : A9 50       ;
CODE_03CCB8:          STA RAM_SpriteYLo,X                 ;; 03CCB8 : 95 D8       ;
CODE_03CCBA:          LDA.B #$08                          ;; 03CCBA : A9 08       ;
CODE_03CCBC:          LDY.W $1570,X                       ;; 03CCBC : BC 70 15    ;
CODE_03CCBF:          BNE CODE_03CCCC                     ;; 03CCBF : D0 0B       ;
CODE_03CCC1:          JSR.W CODE_03CCE2                   ;; 03CCC1 : 20 E2 CC    ;
CODE_03CCC4:          JSL.L GetRand                       ;; 03CCC4 : 22 F9 AC 01 ;
CODE_03CCC8:          LSR                                 ;; 03CCC8 : 4A          ;
CODE_03CCC9:          LSR                                 ;; 03CCC9 : 4A          ;
CODE_03CCCA:          AND.B #$07                          ;; 03CCCA : 29 07       ;
CODE_03CCCC:          STA.W $1528,X                       ;; 03CCCC : 9D 28 15    ;
CODE_03CCCF:          TAY                                 ;; 03CCCF : A8          ;
CODE_03CCD0:          LDA.W DATA_03CC48,Y                 ;; 03CCD0 : B9 48 CC    ;
CODE_03CCD3:          STA.W $1540,X                       ;; 03CCD3 : 9D 40 15    ;
CODE_03CCD6:          INC.W $151C,X                       ;; 03CCD6 : FE 1C 15    ;
CODE_03CCD9:          LDA.W DATA_03CC51,Y                 ;; 03CCD9 : B9 51 CC    ;
CODE_03CCDC:          STA.W $1602,X                       ;; 03CCDC : 9D 02 16    ;
Return03CCDF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CCE0:          .db $10,$20                         ;; 03CCE0               ;
                                                          ;;                      ;
CODE_03CCE2:          LDY.B #$01                          ;; 03CCE2 : A0 01       ;
CODE_03CCE4:          JSR.W CODE_03CCE8                   ;; 03CCE4 : 20 E8 CC    ;
CODE_03CCE7:          DEY                                 ;; 03CCE7 : 88          ;
CODE_03CCE8:          LDA.B #$08                          ;; 03CCE8 : A9 08       ; \ Sprite status = Normal 
CODE_03CCEA:          STA.W $14C8,Y                       ;; 03CCEA : 99 C8 14    ; / 
CODE_03CCED:          LDA.B #$29                          ;; 03CCED : A9 29       ;
CODE_03CCEF:          STA.W RAM_SpriteNum,Y               ;; 03CCEF : 99 9E 00    ;
CODE_03CCF2:          PHX                                 ;; 03CCF2 : DA          ;
CODE_03CCF3:          TYX                                 ;; 03CCF3 : BB          ;
CODE_03CCF4:          JSL.L InitSpriteTables              ;; 03CCF4 : 22 D2 F7 07 ;
CODE_03CCF8:          PLX                                 ;; 03CCF8 : FA          ;
CODE_03CCF9:          LDA.W DATA_03CCE0,Y                 ;; 03CCF9 : B9 E0 CC    ;
CODE_03CCFC:          STA.W $1570,Y                       ;; 03CCFC : 99 70 15    ;
CODE_03CCFF:          LDA RAM_SpriteState,X               ;; 03CCFF : B5 C2       ;
CODE_03CD01:          STA.W RAM_SpriteState,Y             ;; 03CD01 : 99 C2 00    ;
CODE_03CD04:          LDA.W $160E,X                       ;; 03CD04 : BD 0E 16    ;
CODE_03CD07:          STA.W $160E,Y                       ;; 03CD07 : 99 0E 16    ;
CODE_03CD0A:          LDA RAM_SpriteXLo,X                 ;; 03CD0A : B5 E4       ;
CODE_03CD0C:          STA.W RAM_SpriteXLo,Y               ;; 03CD0C : 99 E4 00    ;
CODE_03CD0F:          LDA.W RAM_SpriteXHi,X               ;; 03CD0F : BD E0 14    ;
CODE_03CD12:          STA.W RAM_SpriteXHi,Y               ;; 03CD12 : 99 E0 14    ;
CODE_03CD15:          LDA RAM_SpriteYLo,X                 ;; 03CD15 : B5 D8       ;
CODE_03CD17:          STA.W RAM_SpriteYLo,Y               ;; 03CD17 : 99 D8 00    ;
CODE_03CD1A:          LDA.W RAM_SpriteYHi,X               ;; 03CD1A : BD D4 14    ;
CODE_03CD1D:          STA.W RAM_SpriteYHi,Y               ;; 03CD1D : 99 D4 14    ;
Return03CD20:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CD21:          LDA.W $1540,X                       ;; 03CD21 : BD 40 15    ;
CODE_03CD24:          BNE CODE_03CD2E                     ;; 03CD24 : D0 08       ;
CODE_03CD26:          LDA.B #$40                          ;; 03CD26 : A9 40       ;
CODE_03CD28:          STA.W $1540,X                       ;; 03CD28 : 9D 40 15    ;
CODE_03CD2B:          INC.W $151C,X                       ;; 03CD2B : FE 1C 15    ;
CODE_03CD2E:          LDA.B #$F8                          ;; 03CD2E : A9 F8       ;
CODE_03CD30:          STA RAM_SpriteSpeedY,X              ;; 03CD30 : 95 AA       ;
CODE_03CD32:          JSL.L UpdateYPosNoGrvty             ;; 03CD32 : 22 1A 80 01 ;
Return03CD36:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CD37:          .db $02,$02,$02,$02,$03,$03,$03,$03 ;; 03CD37               ;
                      .db $03,$03,$03,$03,$02,$02,$02,$02 ;; ?QPWZ?               ;
                      .db $04,$04,$04,$04,$05,$05,$04,$05 ;; ?QPWZ?               ;
                      .db $05,$04,$05,$05,$04,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $06,$06,$06,$06,$07,$07,$07,$07 ;; ?QPWZ?               ;
                      .db $07,$07,$07,$07,$06,$06,$06,$06 ;; ?QPWZ?               ;
                      .db $08,$08,$08,$08,$08,$09,$09,$08 ;; ?QPWZ?               ;
                      .db $08,$09,$09,$08,$08,$08,$08,$08 ;; ?QPWZ?               ;
                      .db $0B,$0B,$0B,$0B,$0B,$0A,$0B,$0A ;; ?QPWZ?               ;
                      .db $0B,$0A,$0B,$0A,$0B,$0B,$0B,$0B ;; ?QPWZ?               ;
                      .db $0C,$0C,$0C,$0C,$0D,$0C,$0D,$0C ;; ?QPWZ?               ;
                      .db $0D,$0C,$0D,$0C,$0D,$0D,$0D,$0D ;; ?QPWZ?               ;
                      .db $0E,$0E,$0E,$0E,$0E,$0F,$0E,$0F ;; ?QPWZ?               ;
                      .db $0E,$0F,$0E,$0F,$0E,$0E,$0E,$0E ;; ?QPWZ?               ;
                      .db $10,$10,$10,$10,$11,$12,$11,$10 ;; ?QPWZ?               ;
                      .db $11,$12,$11,$10,$11,$11,$11,$11 ;; ?QPWZ?               ;
                      .db $13,$13,$13,$13,$13,$13,$13,$13 ;; ?QPWZ?               ;
                      .db $13,$13,$13,$13,$13,$13,$13,$13 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CDC7:          JSR.W CODE_03CEA7                   ;; 03CDC7 : 20 A7 CE    ;
CODE_03CDCA:          LDA.W $1540,X                       ;; 03CDCA : BD 40 15    ;
CODE_03CDCD:          BNE CODE_03CDDA                     ;; 03CDCD : D0 0B       ;
CODE_03CDCF:          LDA.B #$24                          ;; 03CDCF : A9 24       ;
CODE_03CDD1:          STA.W $1540,X                       ;; 03CDD1 : 9D 40 15    ;
CODE_03CDD4:          LDA.B #$03                          ;; 03CDD4 : A9 03       ;
CODE_03CDD6:          STA.W $151C,X                       ;; 03CDD6 : 9D 1C 15    ;
Return03CDD9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDDA:          LSR                                 ;; 03CDDA : 4A          ;
CODE_03CDDB:          LSR                                 ;; 03CDDB : 4A          ;
CODE_03CDDC:          STA $00                             ;; 03CDDC : 85 00       ;
CODE_03CDDE:          LDA.W $1528,X                       ;; 03CDDE : BD 28 15    ;
CODE_03CDE1:          ASL                                 ;; 03CDE1 : 0A          ;
CODE_03CDE2:          ASL                                 ;; 03CDE2 : 0A          ;
CODE_03CDE3:          ASL                                 ;; 03CDE3 : 0A          ;
CODE_03CDE4:          ASL                                 ;; 03CDE4 : 0A          ;
CODE_03CDE5:          ORA $00                             ;; 03CDE5 : 05 00       ;
CODE_03CDE7:          TAY                                 ;; 03CDE7 : A8          ;
CODE_03CDE8:          LDA.W DATA_03CD37,Y                 ;; 03CDE8 : B9 37 CD    ;
CODE_03CDEB:          STA.W $1602,X                       ;; 03CDEB : 9D 02 16    ;
Return03CDEE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDEF:          LDA.W $1540,X                       ;; 03CDEF : BD 40 15    ;
CODE_03CDF2:          BNE CODE_03CE05                     ;; 03CDF2 : D0 11       ;
CODE_03CDF4:          LDA.W $1570,X                       ;; 03CDF4 : BD 70 15    ;
CODE_03CDF7:          BEQ CODE_03CDFD                     ;; 03CDF7 : F0 04       ;
CODE_03CDF9:          STZ.W $14C8,X                       ;; 03CDF9 : 9E C8 14    ;
Return03CDFC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDFD:          STZ.W $151C,X                       ;; 03CDFD : 9E 1C 15    ;
CODE_03CE00:          LDA.B #$30                          ;; 03CE00 : A9 30       ;
CODE_03CE02:          STA.W $1540,X                       ;; 03CE02 : 9D 40 15    ;
CODE_03CE05:          LDA.B #$10                          ;; 03CE05 : A9 10       ;
CODE_03CE07:          STA RAM_SpriteSpeedY,X              ;; 03CE07 : 95 AA       ;
CODE_03CE09:          JSL.L UpdateYPosNoGrvty             ;; 03CE09 : 22 1A 80 01 ;
Return03CE0D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE0E:          LDA.W $1540,X                       ;; 03CE0E : BD 40 15    ;
CODE_03CE11:          BNE CODE_03CE2A                     ;; 03CE11 : D0 17       ;
CODE_03CE13:          INC.W $1534,X                       ;; 03CE13 : FE 34 15    ;
CODE_03CE16:          LDA.W $1534,X                       ;; 03CE16 : BD 34 15    ;
CODE_03CE19:          CMP.B #$03                          ;; 03CE19 : C9 03       ;
CODE_03CE1B:          BNE CODE_03CDCF                     ;; 03CE1B : D0 B2       ;
CODE_03CE1D:          LDA.B #$05                          ;; 03CE1D : A9 05       ;
CODE_03CE1F:          STA.W $151C,X                       ;; 03CE1F : 9D 1C 15    ;
CODE_03CE22:          STZ RAM_SpriteSpeedY,X              ;; 03CE22 : 74 AA       ; Sprite Y Speed = 0 
CODE_03CE24:          LDA.B #$23                          ;; 03CE24 : A9 23       ;
CODE_03CE26:          STA.W $1DF9                         ;; 03CE26 : 8D F9 1D    ; / Play sound effect 
Return03CE29:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE2A:          LDY.W $1570,X                       ;; 03CE2A : BC 70 15    ;
CODE_03CE2D:          BNE CODE_03CE42                     ;; 03CE2D : D0 13       ;
CODE_03CE2F:          CMP.B #$24                          ;; 03CE2F : C9 24       ;
CODE_03CE31:          BNE CODE_03CE38                     ;; 03CE31 : D0 05       ;
CODE_03CE33:          LDY.B #$29                          ;; 03CE33 : A0 29       ;
CODE_03CE35:          STY.W $1DFC                         ;; 03CE35 : 8C FC 1D    ; / Play sound effect 
CODE_03CE38:          LDA RAM_FrameCounterB               ;; 03CE38 : A5 14       ;
CODE_03CE3A:          LSR                                 ;; 03CE3A : 4A          ;
CODE_03CE3B:          LSR                                 ;; 03CE3B : 4A          ;
CODE_03CE3C:          AND.B #$01                          ;; 03CE3C : 29 01       ;
CODE_03CE3E:          STA.W $1602,X                       ;; 03CE3E : 9D 02 16    ;
Return03CE41:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE42:          CMP.B #$10                          ;; 03CE42 : C9 10       ;
CODE_03CE44:          BNE CODE_03CE4B                     ;; 03CE44 : D0 05       ;
CODE_03CE46:          LDY.B #$2A                          ;; 03CE46 : A0 2A       ;
CODE_03CE48:          STY.W $1DFC                         ;; 03CE48 : 8C FC 1D    ; / Play sound effect 
CODE_03CE4B:          LSR                                 ;; 03CE4B : 4A          ;
CODE_03CE4C:          LSR                                 ;; 03CE4C : 4A          ;
CODE_03CE4D:          LSR                                 ;; 03CE4D : 4A          ;
CODE_03CE4E:          TAY                                 ;; 03CE4E : A8          ;
CODE_03CE4F:          LDA.W DATA_03CE56,Y                 ;; 03CE4F : B9 56 CE    ;
CODE_03CE52:          STA.W $1602,X                       ;; 03CE52 : 9D 02 16    ;
Return03CE55:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CE56:          .db $16,$16,$15,$14                 ;; 03CE56               ;
                                                          ;;                      ;
CODE_03CE5A:          JSL.L UpdateYPosNoGrvty             ;; 03CE5A : 22 1A 80 01 ;
CODE_03CE5E:          LDA RAM_SpriteSpeedY,X              ;; 03CE5E : B5 AA       ;
CODE_03CE60:          CMP.B #$40                          ;; 03CE60 : C9 40       ;
CODE_03CE62:          BPL CODE_03CE69                     ;; 03CE62 : 10 05       ;
CODE_03CE64:          CLC                                 ;; 03CE64 : 18          ;
CODE_03CE65:          ADC.B #$03                          ;; 03CE65 : 69 03       ;
CODE_03CE67:          STA RAM_SpriteSpeedY,X              ;; 03CE67 : 95 AA       ;
CODE_03CE69:          LDA.W RAM_SpriteYHi,X               ;; 03CE69 : BD D4 14    ;
CODE_03CE6C:          BEQ CODE_03CE87                     ;; 03CE6C : F0 19       ;
CODE_03CE6E:          LDA RAM_SpriteYLo,X                 ;; 03CE6E : B5 D8       ;
CODE_03CE70:          CMP.B #$85                          ;; 03CE70 : C9 85       ;
CODE_03CE72:          BCC CODE_03CE87                     ;; 03CE72 : 90 13       ;
CODE_03CE74:          LDA.B #$06                          ;; 03CE74 : A9 06       ;
CODE_03CE76:          STA.W $151C,X                       ;; 03CE76 : 9D 1C 15    ;
CODE_03CE79:          LDA.B #$80                          ;; 03CE79 : A9 80       ;
CODE_03CE7B:          STA.W $1540,X                       ;; 03CE7B : 9D 40 15    ;
CODE_03CE7E:          LDA.B #$20                          ;; 03CE7E : A9 20       ;
CODE_03CE80:          STA.W $1DFC                         ;; 03CE80 : 8D FC 1D    ; / Play sound effect 
CODE_03CE83:          JSL.L CODE_028528                   ;; 03CE83 : 22 28 85 02 ;
CODE_03CE87:          BRA CODE_03CE2F                     ;; 03CE87 : 80 A6       ;
                                                          ;;                      ;
CODE_03CE89:          LDA.W $1540,X                       ;; 03CE89 : BD 40 15    ;
CODE_03CE8C:          BNE CODE_03CE9E                     ;; 03CE8C : D0 10       ;
CODE_03CE8E:          STZ.W $14C8,X                       ;; 03CE8E : 9E C8 14    ;
CODE_03CE91:          INC.W $13C6                         ;; 03CE91 : EE C6 13    ;
CODE_03CE94:          LDA.B #$FF                          ;; 03CE94 : A9 FF       ;
CODE_03CE96:          STA.W $1493                         ;; 03CE96 : 8D 93 14    ;
CODE_03CE99:          LDA.B #$0B                          ;; 03CE99 : A9 0B       ;
CODE_03CE9B:          STA.W $1DFB                         ;; 03CE9B : 8D FB 1D    ; / Change music 
CODE_03CE9E:          LDA.B #$04                          ;; 03CE9E : A9 04       ;
CODE_03CEA0:          STA RAM_SpriteSpeedY,X              ;; 03CEA0 : 95 AA       ;
CODE_03CEA2:          JSL.L UpdateYPosNoGrvty             ;; 03CEA2 : 22 1A 80 01 ;
Return03CEA6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CEA7:          JSL.L MarioSprInteract              ;; 03CEA7 : 22 DC A7 01 ;
CODE_03CEAB:          BCC Return03CEF1                    ;; 03CEAB : 90 44       ;
CODE_03CEAD:          LDA RAM_MarioSpeedY                 ;; 03CEAD : A5 7D       ;
CODE_03CEAF:          CMP.B #$10                          ;; 03CEAF : C9 10       ;
CODE_03CEB1:          BMI CODE_03CEED                     ;; 03CEB1 : 30 3A       ;
CODE_03CEB3:          JSL.L DisplayContactGfx             ;; 03CEB3 : 22 99 AB 01 ;
CODE_03CEB7:          LDA.B #$02                          ;; 03CEB7 : A9 02       ;
CODE_03CEB9:          JSL.L GivePoints                    ;; 03CEB9 : 22 E5 AC 02 ;
CODE_03CEBD:          JSL.L BoostMarioSpeed               ;; 03CEBD : 22 33 AA 01 ;
CODE_03CEC1:          LDA.B #$02                          ;; 03CEC1 : A9 02       ;
CODE_03CEC3:          STA.W $1DF9                         ;; 03CEC3 : 8D F9 1D    ; / Play sound effect 
CODE_03CEC6:          LDA.W $1570,X                       ;; 03CEC6 : BD 70 15    ;
CODE_03CEC9:          BNE CODE_03CEDB                     ;; 03CEC9 : D0 10       ;
CODE_03CECB:          LDA.B #$28                          ;; 03CECB : A9 28       ;
CODE_03CECD:          STA.W $1DFC                         ;; 03CECD : 8D FC 1D    ; / Play sound effect 
CODE_03CED0:          LDA.W $1534,X                       ;; 03CED0 : BD 34 15    ;
CODE_03CED3:          CMP.B #$02                          ;; 03CED3 : C9 02       ;
CODE_03CED5:          BNE CODE_03CEDB                     ;; 03CED5 : D0 04       ;
CODE_03CED7:          JSL.L KillMostSprites               ;; 03CED7 : 22 C8 A6 03 ;
CODE_03CEDB:          LDA.B #$04                          ;; 03CEDB : A9 04       ;
CODE_03CEDD:          STA.W $151C,X                       ;; 03CEDD : 9D 1C 15    ;
CODE_03CEE0:          LDA.B #$50                          ;; 03CEE0 : A9 50       ;
CODE_03CEE2:          LDY.W $1570,X                       ;; 03CEE2 : BC 70 15    ;
CODE_03CEE5:          BEQ CODE_03CEE9                     ;; 03CEE5 : F0 02       ;
CODE_03CEE7:          LDA.B #$1F                          ;; 03CEE7 : A9 1F       ;
CODE_03CEE9:          STA.W $1540,X                       ;; 03CEE9 : 9D 40 15    ;
Return03CEEC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CEED:          JSL.L HurtMario                     ;; 03CEED : 22 B7 F5 00 ;
Return03CEF1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CEF2:          .db $F8,$08,$F8,$08,$00,$00,$F8,$08 ;; 03CEF2               ;
                      .db $F8,$08,$00,$00,$F8,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$FB,$00,$FB,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$08,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$F8,$00,$08,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$06,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$02,$00,$00,$F8,$08,$00,$04 ;; ?QPWZ?               ;
                      .db $00,$08,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CF7C:          .db $F8,$08,$F8,$08,$00,$00,$F8,$08 ;; 03CF7C               ;
                      .db $F8,$08,$00,$00,$F8,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$FB,$00,$FB,$03,$00,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$08,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$F8,$00,$08,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$06,$00,$08,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$02,$00,$08,$F8,$08,$00,$04 ;; ?QPWZ?               ;
                      .db $00,$08,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $08,$00,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$F8,$08,$00,$00,$08,$00 ;; ?QPWZ?               ;
                      .db $F8,$08,$00,$00,$00,$00,$F8,$08 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$F8,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D006:          .db $04,$04,$14,$14,$00,$00,$04,$04 ;; 03D006               ;
                      .db $14,$14,$00,$00,$00,$08,$F8,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$08,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$F8,$F8,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$08,$F8,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$08,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$F8,$00,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $00,$F8,$00,$00,$05,$05,$00,$0F ;; ?QPWZ?               ;
                      .db $F8,$F8,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$05,$05,$00,$F8 ;; ?QPWZ?               ;
                      .db $F8,$00,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$00,$00,$00,$04,$04 ;; ?QPWZ?               ;
                      .db $01,$00,$00,$00,$04,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$00,$00,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $03,$00,$00,$00,$05,$05,$04,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D090:          .db $04,$04,$14,$14,$00,$00,$04,$04 ;; 03D090               ;
                      .db $14,$14,$00,$00,$00,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$08,$F8,$F8,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$F8,$F8,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$08,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$08,$08,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$F8,$F8,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $00,$F8,$F8,$00,$05,$05,$00,$0F ;; ?QPWZ?               ;
                      .db $F8,$F8,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$05,$05,$00,$F8 ;; ?QPWZ?               ;
                      .db $F8,$00,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$00,$00,$00,$04,$04 ;; ?QPWZ?               ;
                      .db $01,$00,$00,$00,$04,$04,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$05,$00,$F8,$F8,$00 ;; ?QPWZ?               ;
                      .db $05,$05,$00,$00,$00,$00,$05,$05 ;; ?QPWZ?               ;
                      .db $03,$00,$00,$00,$05,$05,$04,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D11A:          .db $20,$20,$26,$26,$08,$00,$2E,$2E ;; 03D11A               ;
                      .db $24,$24,$08,$00,$00,$28,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$04,$28,$12,$12,$00,$00 ;; ?QPWZ?               ;
                      .db $22,$22,$04,$12,$12,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $08,$00,$00,$00,$00,$28,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$0A,$28,$13,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $20,$20,$0C,$02,$00,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $0C,$02,$00,$00,$22,$22,$06,$03 ;; ?QPWZ?               ;
                      .db $12,$12,$20,$20,$06,$12,$12,$00 ;; ?QPWZ?               ;
                      .db $2A,$2A,$00,$00,$00,$00,$2C,$2C ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$20,$20,$06,$12 ;; ?QPWZ?               ;
                      .db $12,$00,$20,$20,$06,$12,$12,$00 ;; ?QPWZ?               ;
                      .db $22,$22,$08,$00,$00,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $08,$00,$00,$00,$2E,$2E,$08,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$4E,$4E,$60,$43,$43,$00 ;; ?QPWZ?               ;
                      .db $4E,$4E,$64,$00,$00,$00,$62,$62 ;; ?QPWZ?               ;
                      .db $64,$00,$00,$00,$62,$62,$64,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D1A4:          .db $20,$20,$26,$26,$48,$00,$2E,$2E ;; 03D1A4               ;
                      .db $24,$24,$48,$00,$40,$28,$42,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$44,$28,$52,$52,$00,$00 ;; ?QPWZ?               ;
                      .db $22,$22,$44,$52,$52,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $48,$00,$00,$00,$40,$28,$42,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$4A,$28,$53,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $20,$20,$4C,$1E,$1F,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $4C,$1F,$1E,$00,$22,$22,$44,$03 ;; ?QPWZ?               ;
                      .db $52,$52,$20,$20,$44,$52,$52,$00 ;; ?QPWZ?               ;
                      .db $2A,$2A,$00,$00,$00,$00,$2C,$2C ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$20,$20,$46,$52 ;; ?QPWZ?               ;
                      .db $52,$00,$20,$20,$46,$52,$52,$00 ;; ?QPWZ?               ;
                      .db $22,$22,$48,$00,$00,$00,$20,$20 ;; ?QPWZ?               ;
                      .db $48,$00,$00,$00,$2E,$2E,$48,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$4E,$4E,$66,$68,$68,$00 ;; ?QPWZ?               ;
                      .db $4E,$4E,$6A,$00,$00,$00,$62,$62 ;; ?QPWZ?               ;
                      .db $6A,$00,$00,$00,$62,$62,$6A,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
LemmyGfxProp:         .db $05,$45,$05,$45,$05,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$00,$05,$05,$05,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$05,$05,$45,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$05,$45,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $05,$00,$00,$00,$05,$05,$05,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$05,$05,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$05,$00,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $45,$45,$00,$00,$05,$45,$05,$05 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$45,$45,$05,$45,$00 ;; ?QPWZ?               ;
                      .db $05,$45,$00,$00,$00,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$05,$45,$45,$05 ;; ?QPWZ?               ;
                      .db $45,$00,$05,$45,$05,$05,$45,$00 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$00,$00,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $05,$00,$00,$00,$05,$45,$05,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$07,$47,$07,$07,$47,$00 ;; ?QPWZ?               ;
                      .db $07,$47,$07,$00,$00,$00,$07,$47 ;; ?QPWZ?               ;
                      .db $07,$00,$00,$00,$07,$47,$07,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
WendyGfxProp:         .db $09,$49,$09,$49,$09,$00,$09,$49 ;; ?QPWZ?               ;
                      .db $09,$49,$09,$00,$09,$09,$09,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$09,$09,$09,$49,$00,$00 ;; ?QPWZ?               ;
                      .db $09,$49,$09,$09,$49,$00,$09,$49 ;; ?QPWZ?               ;
                      .db $09,$00,$00,$00,$09,$09,$09,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$09,$09,$09,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $09,$49,$09,$09,$09,$00,$09,$49 ;; ?QPWZ?               ;
                      .db $49,$49,$49,$00,$09,$49,$09,$09 ;; ?QPWZ?               ;
                      .db $09,$49,$09,$49,$49,$09,$49,$00 ;; ?QPWZ?               ;
                      .db $09,$49,$00,$00,$00,$00,$09,$49 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$09,$49,$49,$09 ;; ?QPWZ?               ;
                      .db $49,$00,$09,$49,$09,$09,$49,$00 ;; ?QPWZ?               ;
                      .db $09,$49,$09,$00,$00,$00,$09,$49 ;; ?QPWZ?               ;
                      .db $09,$00,$00,$00,$09,$49,$09,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$45,$05,$05,$45,$00 ;; ?QPWZ?               ;
                      .db $05,$45,$05,$00,$00,$00,$05,$45 ;; ?QPWZ?               ;
                      .db $05,$00,$00,$00,$05,$45,$05,$00 ;; ?QPWZ?               ;
                      .db $00,$00                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D342:          .db $02,$02,$02,$02,$02,$04,$02,$02 ;; 03D342               ;
                      .db $02,$02,$02,$04,$02,$02,$00,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$00,$00,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$00,$00,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$00,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$00,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$00,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$00,$04,$04,$02,$02,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$04,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $04,$04,$04,$04,$02,$02,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$04,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$02,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$02,$04 ;; ?QPWZ?               ;
                      .db $04,$04                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D3CC:          .db $02,$02,$02,$02,$02,$04,$02,$02 ;; 03D3CC               ;
                      .db $02,$02,$02,$04,$02,$02,$00,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$00,$00,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$00,$00,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$00,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$00,$04,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$00,$00,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$00,$00,$04,$02,$02,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$04,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $04,$04,$04,$04,$02,$02,$02,$00 ;; ?QPWZ?               ;
                      .db $00,$04,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$02,$04 ;; ?QPWZ?               ;
                      .db $04,$04,$02,$02,$02,$00,$00,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$04,$04,$02,$02 ;; ?QPWZ?               ;
                      .db $02,$04,$04,$04,$02,$02,$02,$04 ;; ?QPWZ?               ;
                      .db $04,$04                         ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D456:          .db $04,$04,$02,$03,$04,$02,$02,$02 ;; 03D456               ;
                      .db $03,$03,$05,$04,$01,$01,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$02,$02,$02     ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D46D:          .db $04,$04,$02,$03,$04,$02,$02,$02 ;; 03D46D               ;
                      .db $04,$04,$05,$04,$01,$01,$04,$04 ;; ?QPWZ?               ;
                      .db $02,$02,$02,$04,$02,$02,$02     ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D484:          JSR.W GetDrawInfoBnk3               ;; 03D484 : 20 60 B7    ;
CODE_03D487:          LDA.W $1602,X                       ;; 03D487 : BD 02 16    ;
CODE_03D48A:          ASL                                 ;; 03D48A : 0A          ;
CODE_03D48B:          ASL                                 ;; 03D48B : 0A          ;
CODE_03D48C:          ADC.W $1602,X                       ;; 03D48C : 7D 02 16    ;
CODE_03D48F:          ADC.W $1602,X                       ;; 03D48F : 7D 02 16    ;
CODE_03D492:          STA $02                             ;; 03D492 : 85 02       ;
CODE_03D494:          LDA RAM_SpriteState,X               ;; 03D494 : B5 C2       ;
CODE_03D496:          CMP.B #$06                          ;; 03D496 : C9 06       ;
CODE_03D498:          BEQ CODE_03D4DF                     ;; 03D498 : F0 45       ;
CODE_03D49A:          PHX                                 ;; 03D49A : DA          ;
CODE_03D49B:          LDA.W $1602,X                       ;; 03D49B : BD 02 16    ;
CODE_03D49E:          TAX                                 ;; 03D49E : AA          ;
CODE_03D49F:          LDA.W DATA_03D456,X                 ;; 03D49F : BD 56 D4    ;
CODE_03D4A2:          TAX                                 ;; 03D4A2 : AA          ;
CODE_03D4A3:          PHX                                 ;; 03D4A3 : DA          ;
CODE_03D4A4:          TXA                                 ;; 03D4A4 : 8A          ;
CODE_03D4A5:          CLC                                 ;; 03D4A5 : 18          ;
CODE_03D4A6:          ADC $02                             ;; 03D4A6 : 65 02       ;
CODE_03D4A8:          TAX                                 ;; 03D4A8 : AA          ;
CODE_03D4A9:          LDA $00                             ;; 03D4A9 : A5 00       ;
CODE_03D4AB:          CLC                                 ;; 03D4AB : 18          ;
CODE_03D4AC:          ADC.W DATA_03CEF2,X                 ;; 03D4AC : 7D F2 CE    ;
CODE_03D4AF:          STA.W OAM_DispX,Y                   ;; 03D4AF : 99 00 03    ;
CODE_03D4B2:          LDA $01                             ;; 03D4B2 : A5 01       ;
CODE_03D4B4:          CLC                                 ;; 03D4B4 : 18          ;
CODE_03D4B5:          ADC.W DATA_03D006,X                 ;; 03D4B5 : 7D 06 D0    ;
CODE_03D4B8:          STA.W OAM_DispY,Y                   ;; 03D4B8 : 99 01 03    ;
CODE_03D4BB:          LDA.W DATA_03D11A,X                 ;; 03D4BB : BD 1A D1    ;
CODE_03D4BE:          STA.W OAM_Tile,Y                    ;; 03D4BE : 99 02 03    ;
CODE_03D4C1:          LDA.W LemmyGfxProp,X                ;; 03D4C1 : BD 2E D2    ;
CODE_03D4C4:          ORA.B #$10                          ;; 03D4C4 : 09 10       ;
CODE_03D4C6:          STA.W OAM_Prop,Y                    ;; 03D4C6 : 99 03 03    ;
CODE_03D4C9:          PHY                                 ;; 03D4C9 : 5A          ;
CODE_03D4CA:          TYA                                 ;; 03D4CA : 98          ;
CODE_03D4CB:          LSR                                 ;; 03D4CB : 4A          ;
CODE_03D4CC:          LSR                                 ;; 03D4CC : 4A          ;
CODE_03D4CD:          TAY                                 ;; 03D4CD : A8          ;
CODE_03D4CE:          LDA.W DATA_03D342,X                 ;; 03D4CE : BD 42 D3    ;
CODE_03D4D1:          STA.W OAM_TileSize,Y                ;; 03D4D1 : 99 60 04    ;
CODE_03D4D4:          PLY                                 ;; 03D4D4 : 7A          ;
CODE_03D4D5:          INY                                 ;; 03D4D5 : C8          ;
CODE_03D4D6:          INY                                 ;; 03D4D6 : C8          ;
CODE_03D4D7:          INY                                 ;; 03D4D7 : C8          ;
CODE_03D4D8:          INY                                 ;; 03D4D8 : C8          ;
CODE_03D4D9:          PLX                                 ;; 03D4D9 : FA          ;
CODE_03D4DA:          DEX                                 ;; 03D4DA : CA          ;
CODE_03D4DB:          BPL CODE_03D4A3                     ;; 03D4DB : 10 C6       ;
CODE_03D4DD:          PLX                                 ;; 03D4DD : FA          ;
Return03D4DE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D4DF:          PHX                                 ;; 03D4DF : DA          ;
CODE_03D4E0:          LDA.W $1602,X                       ;; 03D4E0 : BD 02 16    ;
CODE_03D4E3:          TAX                                 ;; 03D4E3 : AA          ;
CODE_03D4E4:          LDA.W DATA_03D46D,X                 ;; 03D4E4 : BD 6D D4    ;
CODE_03D4E7:          TAX                                 ;; 03D4E7 : AA          ;
CODE_03D4E8:          PHX                                 ;; 03D4E8 : DA          ;
CODE_03D4E9:          TXA                                 ;; 03D4E9 : 8A          ;
CODE_03D4EA:          CLC                                 ;; 03D4EA : 18          ;
CODE_03D4EB:          ADC $02                             ;; 03D4EB : 65 02       ;
CODE_03D4ED:          TAX                                 ;; 03D4ED : AA          ;
CODE_03D4EE:          LDA $00                             ;; 03D4EE : A5 00       ;
CODE_03D4F0:          CLC                                 ;; 03D4F0 : 18          ;
CODE_03D4F1:          ADC.W DATA_03CF7C,X                 ;; 03D4F1 : 7D 7C CF    ;
CODE_03D4F4:          STA.W OAM_DispX,Y                   ;; 03D4F4 : 99 00 03    ;
CODE_03D4F7:          LDA $01                             ;; 03D4F7 : A5 01       ;
CODE_03D4F9:          CLC                                 ;; 03D4F9 : 18          ;
CODE_03D4FA:          ADC.W DATA_03D090,X                 ;; 03D4FA : 7D 90 D0    ;
CODE_03D4FD:          STA.W OAM_DispY,Y                   ;; 03D4FD : 99 01 03    ;
CODE_03D500:          LDA.W DATA_03D1A4,X                 ;; 03D500 : BD A4 D1    ;
CODE_03D503:          STA.W OAM_Tile,Y                    ;; 03D503 : 99 02 03    ;
CODE_03D506:          LDA.W WendyGfxProp,X                ;; 03D506 : BD B8 D2    ;
CODE_03D509:          ORA.B #$10                          ;; 03D509 : 09 10       ;
CODE_03D50B:          STA.W OAM_Prop,Y                    ;; 03D50B : 99 03 03    ;
CODE_03D50E:          PHY                                 ;; 03D50E : 5A          ;
CODE_03D50F:          TYA                                 ;; 03D50F : 98          ;
CODE_03D510:          LSR                                 ;; 03D510 : 4A          ;
CODE_03D511:          LSR                                 ;; 03D511 : 4A          ;
CODE_03D512:          TAY                                 ;; 03D512 : A8          ;
CODE_03D513:          LDA.W DATA_03D3CC,X                 ;; 03D513 : BD CC D3    ;
CODE_03D516:          STA.W OAM_TileSize,Y                ;; 03D516 : 99 60 04    ;
CODE_03D519:          PLY                                 ;; 03D519 : 7A          ;
CODE_03D51A:          INY                                 ;; 03D51A : C8          ;
CODE_03D51B:          INY                                 ;; 03D51B : C8          ;
CODE_03D51C:          INY                                 ;; 03D51C : C8          ;
CODE_03D51D:          INY                                 ;; 03D51D : C8          ;
CODE_03D51E:          PLX                                 ;; 03D51E : FA          ;
CODE_03D51F:          DEX                                 ;; 03D51F : CA          ;
CODE_03D520:          BPL CODE_03D4E8                     ;; 03D520 : 10 C6       ;
CODE_03D522:          BRA CODE_03D4DD                     ;; 03D522 : 80 B9       ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03D524:          .db $18,$20                         ;; 03D524               ;
                                                          ;;                      ;
DATA_03D526:          .db $A1,$0E,$20,$20,$88,$0E,$28,$20 ;; 03D526               ;
                      .db $AB,$0E,$30,$20,$99,$0E,$38,$20 ;; ?QPWZ?               ;
                      .db $A8,$0E,$40,$20,$BF,$0E,$48,$20 ;; ?QPWZ?               ;
                      .db $AC,$0E,$58,$20,$88,$0E,$60,$20 ;; ?QPWZ?               ;
                      .db $8B,$0E,$68,$20,$AF,$0E,$70,$20 ;; ?QPWZ?               ;
                      .db $8C,$0E,$78,$20,$9E,$0E,$80,$20 ;; ?QPWZ?               ;
                      .db $AD,$0E,$88,$20,$AE,$0E,$90,$20 ;; ?QPWZ?               ;
                      .db $AB,$0E,$98,$20,$8C,$0E,$A8,$20 ;; ?QPWZ?               ;
                      .db $99,$0E,$B0,$20,$AC,$0E,$C0,$20 ;; ?QPWZ?               ;
                      .db $A8,$0E,$C8,$20,$AF,$0E,$D0,$20 ;; ?QPWZ?               ;
                      .db $8C,$0E,$D8,$20,$AB,$0E,$E0,$20 ;; ?QPWZ?               ;
                      .db $BD,$0E,$18,$30,$A1,$0E,$20,$30 ;; ?QPWZ?               ;
                      .db $88,$0E,$28,$30,$AB,$0E,$30,$30 ;; ?QPWZ?               ;
                      .db $99,$0E,$38,$30,$A8,$0E,$40,$30 ;; ?QPWZ?               ;
                      .db $BE,$0E,$48,$30,$AD,$0E,$50,$30 ;; ?QPWZ?               ;
                      .db $98,$0E,$58,$30,$8C,$0E,$68,$30 ;; ?QPWZ?               ;
                      .db $A0,$0E,$70,$30,$AB,$0E,$78,$30 ;; ?QPWZ?               ;
                      .db $99,$0E,$80,$30,$9E,$0E,$88,$30 ;; ?QPWZ?               ;
                      .db $8A,$0E,$90,$30,$8C,$0E,$98,$30 ;; ?QPWZ?               ;
                      .db $AC,$0E,$A0,$30,$AC,$0E,$A8,$30 ;; ?QPWZ?               ;
                      .db $BE,$0E,$B0,$30,$B0,$0E,$B8,$30 ;; ?QPWZ?               ;
                      .db $A8,$0E,$C0,$30,$AC,$0E,$C8,$30 ;; ?QPWZ?               ;
                      .db $98,$0E,$D0,$30,$99,$0E,$D8,$30 ;; ?QPWZ?               ;
                      .db $BE,$0E,$18,$40,$88,$0E,$20,$40 ;; ?QPWZ?               ;
                      .db $9E,$0E,$28,$40,$8B,$0E,$38,$40 ;; ?QPWZ?               ;
                      .db $98,$0E,$40,$40,$99,$0E,$48,$40 ;; ?QPWZ?               ;
                      .db $AC,$0E,$58,$40,$8D,$0E,$60,$40 ;; ?QPWZ?               ;
                      .db $AB,$0E,$68,$40,$99,$0E,$70,$40 ;; ?QPWZ?               ;
                      .db $8C,$0E,$78,$40,$9E,$0E,$80,$40 ;; ?QPWZ?               ;
                      .db $8B,$0E,$88,$40,$AC,$0E,$98,$40 ;; ?QPWZ?               ;
                      .db $88,$0E,$A0,$40,$AB,$0E,$A8,$40 ;; ?QPWZ?               ;
                      .db $8C,$0E,$B8,$40,$8E,$0E,$C0,$40 ;; ?QPWZ?               ;
                      .db $A8,$0E,$C8,$40,$99,$0E,$D0,$40 ;; ?QPWZ?               ;
                      .db $9E,$0E,$D8,$40,$8E,$0E,$18,$50 ;; ?QPWZ?               ;
                      .db $AD,$0E,$20,$50,$A8,$0E,$30,$50 ;; ?QPWZ?               ;
                      .db $AD,$0E,$38,$50,$88,$0E,$40,$50 ;; ?QPWZ?               ;
                      .db $9B,$0E,$48,$50,$8C,$0E,$58,$50 ;; ?QPWZ?               ;
                      .db $88,$0E,$68,$50,$AF,$0E,$70,$50 ;; ?QPWZ?               ;
                      .db $88,$0E,$78,$50,$8A,$0E,$80,$50 ;; ?QPWZ?               ;
                      .db $88,$0E,$88,$50,$AD,$0E,$90,$50 ;; ?QPWZ?               ;
                      .db $99,$0E,$98,$50,$A8,$0E,$A0,$50 ;; ?QPWZ?               ;
                      .db $9E,$0E,$A8,$50,$BD,$0E         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D674:          PHX                                 ;; 03D674 : DA          ;
CODE_03D675:          REP #$30                            ;; 03D675 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_03D677:          LDX.W $1921                         ;; 03D677 : AE 21 19    ;
CODE_03D67A:          BEQ CODE_03D6A8                     ;; 03D67A : F0 2C       ;
CODE_03D67C:          DEX                                 ;; 03D67C : CA          ;
CODE_03D67D:          LDY.W #$0000                        ;; 03D67D : A0 00 00    ;
CODE_03D680:          PHX                                 ;; 03D680 : DA          ;
CODE_03D681:          TXA                                 ;; 03D681 : 8A          ;
CODE_03D682:          ASL                                 ;; 03D682 : 0A          ;
CODE_03D683:          ASL                                 ;; 03D683 : 0A          ;
CODE_03D684:          TAX                                 ;; 03D684 : AA          ;
CODE_03D685:          LDA.W DATA_03D524,X                 ;; 03D685 : BD 24 D5    ;
CODE_03D688:          STA.W OAM_ExtendedDispX,Y           ;; 03D688 : 99 00 02    ;
CODE_03D68B:          LDA.W DATA_03D526,X                 ;; 03D68B : BD 26 D5    ;
CODE_03D68E:          STA.W OAM_ExtendedTile,Y            ;; 03D68E : 99 02 02    ;
CODE_03D691:          PHY                                 ;; 03D691 : 5A          ;
CODE_03D692:          TYA                                 ;; 03D692 : 98          ;
CODE_03D693:          LSR                                 ;; 03D693 : 4A          ;
CODE_03D694:          LSR                                 ;; 03D694 : 4A          ;
CODE_03D695:          TAY                                 ;; 03D695 : A8          ;
CODE_03D696:          SEP #$20                            ;; 03D696 : E2 20       ; Accum (8 bit) 
CODE_03D698:          LDA.B #$00                          ;; 03D698 : A9 00       ;
CODE_03D69A:          STA.W $0420,Y                       ;; 03D69A : 99 20 04    ;
CODE_03D69D:          REP #$20                            ;; 03D69D : C2 20       ; Accum (16 bit) 
CODE_03D69F:          PLY                                 ;; 03D69F : 7A          ;
CODE_03D6A0:          PLX                                 ;; 03D6A0 : FA          ;
CODE_03D6A1:          INY                                 ;; 03D6A1 : C8          ;
CODE_03D6A2:          INY                                 ;; 03D6A2 : C8          ;
CODE_03D6A3:          INY                                 ;; 03D6A3 : C8          ;
CODE_03D6A4:          INY                                 ;; 03D6A4 : C8          ;
CODE_03D6A5:          DEX                                 ;; 03D6A5 : CA          ;
CODE_03D6A6:          BPL CODE_03D680                     ;; 03D6A6 : 10 D8       ;
CODE_03D6A8:          SEP #$30                            ;; 03D6A8 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_03D6AA:          PLX                                 ;; 03D6AA : FA          ;
Return03D6AB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03D6AC:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 03D6AC               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF                 ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D700:          .db $B0,$A0,$90,$80,$70,$60,$50,$40 ;; 03D700               ;
                      .db $30,$20,$10,$00                 ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D70C:          PHX                                 ;; 03D70C : DA          ;
CODE_03D70D:          LDA.W RAM_Reznor1Dead               ;; 03D70D : AD 20 15    ; \ Return if less than 2 reznors killed 
CODE_03D710:          CLC                                 ;; 03D710 : 18          ;  | 
CODE_03D711:          ADC.W RAM_Reznor2Dead               ;; 03D711 : 6D 21 15    ;  | 
CODE_03D714:          ADC.W RAM_Reznor3Dead               ;; 03D714 : 6D 22 15    ;  | 
CODE_03D717:          ADC.W RAM_Reznor4Dead               ;; 03D717 : 6D 23 15    ;  | 
CODE_03D71A:          CMP.B #$02                          ;; 03D71A : C9 02       ;  | 
CODE_03D71C:          BCC CODE_03D757                     ;; 03D71C : 90 39       ; / 
BreakBridge:          LDX.W $1B9F                         ;; ?QPWZ? : AE 9F 1B    ;
CODE_03D721:          CPX.B #$0C                          ;; 03D721 : E0 0C       ;
CODE_03D723:          BCS CODE_03D757                     ;; 03D723 : B0 32       ;
CODE_03D725:          LDA.L DATA_03D700,X                 ;; 03D725 : BF 00 D7 03 ;
CODE_03D729:          STA RAM_BlockYLo                    ;; 03D729 : 85 9A       ;
CODE_03D72B:          STZ RAM_BlockYHi                    ;; 03D72B : 64 9B       ;
CODE_03D72D:          LDA.B #$B0                          ;; 03D72D : A9 B0       ;
CODE_03D72F:          STA RAM_BlockXLo                    ;; 03D72F : 85 98       ;
CODE_03D731:          STZ RAM_BlockXHi                    ;; 03D731 : 64 99       ;
CODE_03D733:          LDA.W $14A7                         ;; 03D733 : AD A7 14    ;
CODE_03D736:          BEQ CODE_03D74A                     ;; 03D736 : F0 12       ;
CODE_03D738:          CMP.B #$3C                          ;; 03D738 : C9 3C       ;
CODE_03D73A:          BNE CODE_03D757                     ;; 03D73A : D0 1B       ;
CODE_03D73C:          JSR.W CODE_03D77F                   ;; 03D73C : 20 7F D7    ;
CODE_03D73F:          JSR.W CODE_03D759                   ;; 03D73F : 20 59 D7    ;
CODE_03D742:          JSR.W CODE_03D77F                   ;; 03D742 : 20 7F D7    ;
CODE_03D745:          INC.W $1B9F                         ;; 03D745 : EE 9F 1B    ;
CODE_03D748:          BRA CODE_03D757                     ;; 03D748 : 80 0D       ;
                                                          ;;                      ;
CODE_03D74A:          JSR.W CODE_03D766                   ;; 03D74A : 20 66 D7    ;
CODE_03D74D:          LDA.B #$40                          ;; 03D74D : A9 40       ;
CODE_03D74F:          STA.W $14A7                         ;; 03D74F : 8D A7 14    ;
CODE_03D752:          LDA.B #$07                          ;; 03D752 : A9 07       ;
CODE_03D754:          STA.W $1DFC                         ;; 03D754 : 8D FC 1D    ; / Play sound effect 
CODE_03D757:          PLX                                 ;; 03D757 : FA          ;
Return03D758:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03D759:          REP #$20                            ;; 03D759 : C2 20       ; Accum (16 bit) 
CODE_03D75B:          LDA.W #$0170                        ;; 03D75B : A9 70 01    ;
CODE_03D75E:          SEC                                 ;; 03D75E : 38          ;
CODE_03D75F:          SBC RAM_BlockYLo                    ;; 03D75F : E5 9A       ;
CODE_03D761:          STA RAM_BlockYLo                    ;; 03D761 : 85 9A       ;
CODE_03D763:          SEP #$20                            ;; 03D763 : E2 20       ; Accum (8 bit) 
Return03D765:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D766:          JSR.W CODE_03D76C                   ;; 03D766 : 20 6C D7    ;
CODE_03D769:          JSR.W CODE_03D759                   ;; 03D769 : 20 59 D7    ;
CODE_03D76C:          REP #$20                            ;; 03D76C : C2 20       ; Accum (16 bit) 
CODE_03D76E:          LDA RAM_BlockYLo                    ;; 03D76E : A5 9A       ;
CODE_03D770:          SEC                                 ;; 03D770 : 38          ;
CODE_03D771:          SBC RAM_ScreenBndryXLo              ;; 03D771 : E5 1A       ;
CODE_03D773:          CMP.W #$0100                        ;; 03D773 : C9 00 01    ;
CODE_03D776:          SEP #$20                            ;; 03D776 : E2 20       ; Accum (8 bit) 
CODE_03D778:          BCS Return03D77E                    ;; 03D778 : B0 04       ;
CODE_03D77A:          JSL.L CODE_028A44                   ;; 03D77A : 22 44 8A 02 ;
Return03D77E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D77F:          LDA RAM_BlockYLo                    ;; 03D77F : A5 9A       ;
CODE_03D781:          LSR                                 ;; 03D781 : 4A          ;
CODE_03D782:          LSR                                 ;; 03D782 : 4A          ;
CODE_03D783:          LSR                                 ;; 03D783 : 4A          ;
CODE_03D784:          STA $01                             ;; 03D784 : 85 01       ;
CODE_03D786:          LSR                                 ;; 03D786 : 4A          ;
CODE_03D787:          ORA RAM_BlockXLo                    ;; 03D787 : 05 98       ;
CODE_03D789:          REP #$20                            ;; 03D789 : C2 20       ; Accum (16 bit) 
CODE_03D78B:          AND.W #$00FF                        ;; 03D78B : 29 FF 00    ;
CODE_03D78E:          LDX RAM_BlockYHi                    ;; 03D78E : A6 9B       ;
CODE_03D790:          BEQ CODE_03D798                     ;; 03D790 : F0 06       ;
CODE_03D792:          CLC                                 ;; 03D792 : 18          ;
CODE_03D793:          ADC.W #$01B0                        ;; 03D793 : 69 B0 01    ;
CODE_03D796:          LDX.B #$04                          ;; 03D796 : A2 04       ;
CODE_03D798:          STX $00                             ;; 03D798 : 86 00       ;
CODE_03D79A:          REP #$10                            ;; 03D79A : C2 10       ; Index (16 bit) 
CODE_03D79C:          TAX                                 ;; 03D79C : AA          ;
CODE_03D79D:          SEP #$20                            ;; 03D79D : E2 20       ; Accum (8 bit) 
CODE_03D79F:          LDA.B #$25                          ;; 03D79F : A9 25       ;
CODE_03D7A1:          STA.L $7EC800,X                     ;; 03D7A1 : 9F 00 C8 7E ;
CODE_03D7A5:          LDA.B #$00                          ;; 03D7A5 : A9 00       ;
CODE_03D7A7:          STA.L $7FC800,X                     ;; 03D7A7 : 9F 00 C8 7F ;
CODE_03D7AB:          REP #$20                            ;; 03D7AB : C2 20       ; Accum (16 bit) 
CODE_03D7AD:          LDA.L $7F837B                       ;; 03D7AD : AF 7B 83 7F ;
CODE_03D7B1:          TAX                                 ;; 03D7B1 : AA          ;
CODE_03D7B2:          LDA.W #$C05A                        ;; 03D7B2 : A9 5A C0    ;
CODE_03D7B5:          CLC                                 ;; 03D7B5 : 18          ;
CODE_03D7B6:          ADC $00                             ;; 03D7B6 : 65 00       ;
CODE_03D7B8:          STA.L $7F837D,X                     ;; 03D7B8 : 9F 7D 83 7F ;
CODE_03D7BC:          ORA.W #$2000                        ;; 03D7BC : 09 00 20    ;
CODE_03D7BF:          STA.L $7F8383,X                     ;; 03D7BF : 9F 83 83 7F ;
CODE_03D7C3:          LDA.W #$0240                        ;; 03D7C3 : A9 40 02    ;
CODE_03D7C6:          STA.L $7F837F,X                     ;; 03D7C6 : 9F 7F 83 7F ;
CODE_03D7CA:          STA.L $7F8385,X                     ;; 03D7CA : 9F 85 83 7F ;
CODE_03D7CE:          LDA.W #$38FC                        ;; 03D7CE : A9 FC 38    ;
CODE_03D7D1:          STA.L $7F8381,X                     ;; 03D7D1 : 9F 81 83 7F ;
CODE_03D7D5:          STA.L $7F8387,X                     ;; 03D7D5 : 9F 87 83 7F ;
CODE_03D7D9:          LDA.W #$00FF                        ;; 03D7D9 : A9 FF 00    ;
CODE_03D7DC:          STA.L $7F8389,X                     ;; 03D7DC : 9F 89 83 7F ;
CODE_03D7E0:          TXA                                 ;; 03D7E0 : 8A          ;
CODE_03D7E1:          CLC                                 ;; 03D7E1 : 18          ;
CODE_03D7E2:          ADC.W #$000C                        ;; 03D7E2 : 69 0C 00    ;
CODE_03D7E5:          STA.L $7F837B                       ;; 03D7E5 : 8F 7B 83 7F ;
CODE_03D7E9:          SEP #$30                            ;; 03D7E9 : E2 30       ; Index (8 bit) Accum (8 bit) 
Return03D7EB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
IggyPlatform:         .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$15,$16,$17,$18,$17,$18 ;; ?QPWZ?               ;
                      .db $17,$18,$17,$18,$19,$1A,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$01,$02,$03,$04,$03,$04 ;; ?QPWZ?               ;
                      .db $03,$04,$03,$04,$05,$12,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$07,$04,$03,$04,$03 ;; ?QPWZ?               ;
                      .db $04,$03,$04,$03,$08,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$09,$0A,$04,$03,$04 ;; ?QPWZ?               ;
                      .db $03,$04,$03,$0B,$0C,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$0D,$0E,$04,$03 ;; ?QPWZ?               ;
                      .db $04,$03,$0F,$10,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$11,$02,$03,$04 ;; ?QPWZ?               ;
                      .db $03,$04,$05,$12,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$07,$04,$03 ;; ?QPWZ?               ;
                      .db $04,$03,$08,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$09,$0A,$04 ;; ?QPWZ?               ;
                      .db $03,$0B,$0C,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$13,$03 ;; ?QPWZ?               ;
                      .db $04,$14,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$13 ;; ?QPWZ?               ;
                      .db $14,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
DATA_03D8EC:          .db $FF,$FF                         ;; 03D8EC               ;
                                                          ;;                      ;
DATA_03D8EE:          .db $FF,$FF,$FF,$FF,$24,$34,$25,$0B ;; 03D8EE               ;
                      .db $26,$36,$0E,$1B,$0C,$1C,$0D,$1D ;; ?QPWZ?               ;
                      .db $0E,$1E,$29,$39,$2A,$3A,$2B,$3B ;; ?QPWZ?               ;
                      .db $26,$38,$20,$30,$21,$31,$27,$37 ;; ?QPWZ?               ;
                      .db $28,$38,$FF,$FF,$22,$32,$0E,$33 ;; ?QPWZ?               ;
                      .db $0C,$1C,$0D,$1D,$0E,$3C,$2D,$3D ;; ?QPWZ?               ;
                      .db $FF,$FF,$07,$17,$0E,$23,$0E,$04 ;; ?QPWZ?               ;
                      .db $0C,$1C,$0D,$1D,$0E,$09,$0E,$2C ;; ?QPWZ?               ;
                      .db $0A,$1A,$FF,$FF,$24,$34,$2B,$3B ;; ?QPWZ?               ;
                      .db $FF,$FF,$07,$17,$0E,$18,$0E,$19 ;; ?QPWZ?               ;
                      .db $0A,$1A,$02,$12,$03,$13,$03,$08 ;; ?QPWZ?               ;
                      .db $03,$05,$03,$05,$03,$14,$03,$15 ;; ?QPWZ?               ;
                      .db $03,$05,$03,$05,$03,$08,$03,$06 ;; ?QPWZ?               ;
                      .db $0F,$1F                         ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D958:          REP #$10                            ;; 03D958 : C2 10       ; Index (16 bit) 
CODE_03D95A:          STZ.W $2115                         ;; 03D95A : 9C 15 21    ; VRAM Address Increment Value
CODE_03D95D:          STZ.W $2116                         ;; 03D95D : 9C 16 21    ; Address for VRAM Read/Write (Low Byte)
CODE_03D960:          STZ.W $2117                         ;; 03D960 : 9C 17 21    ; Address for VRAM Read/Write (High Byte)
CODE_03D963:          LDX.W #$4000                        ;; 03D963 : A2 00 40    ;
CODE_03D966:          LDA.B #$FF                          ;; 03D966 : A9 FF       ;
CODE_03D968:          STA.W $2118                         ;; 03D968 : 8D 18 21    ; Data for VRAM Write (Low Byte)
CODE_03D96B:          DEX                                 ;; 03D96B : CA          ;
CODE_03D96C:          BNE CODE_03D968                     ;; 03D96C : D0 FA       ;
CODE_03D96E:          SEP #$10                            ;; 03D96E : E2 10       ; Index (8 bit) 
CODE_03D970:          BIT.W $0D9B                         ;; 03D970 : 2C 9B 0D    ;
CODE_03D973:          BVS Return03D990                    ;; 03D973 : 70 1B       ;
CODE_03D975:          PHB                                 ;; 03D975 : 8B          ;
CODE_03D976:          PHK                                 ;; 03D976 : 4B          ;
CODE_03D977:          PLB                                 ;; 03D977 : AB          ;
CODE_03D978:          LDA.B #$EC                          ;; 03D978 : A9 EC       ;
CODE_03D97A:          STA $05                             ;; 03D97A : 85 05       ;
CODE_03D97C:          LDA.B #$D7                          ;; 03D97C : A9 D7       ;
CODE_03D97E:          STA $06                             ;; 03D97E : 85 06       ;
CODE_03D980:          LDA.B #$03                          ;; 03D980 : A9 03       ;
CODE_03D982:          STA $07                             ;; 03D982 : 85 07       ;
CODE_03D984:          LDA.B #$10                          ;; 03D984 : A9 10       ;
CODE_03D986:          STA $00                             ;; 03D986 : 85 00       ;
CODE_03D988:          LDA.B #$08                          ;; 03D988 : A9 08       ;
CODE_03D98A:          STA $01                             ;; 03D98A : 85 01       ;
CODE_03D98C:          JSR.W CODE_03D991                   ;; 03D98C : 20 91 D9    ;
CODE_03D98F:          PLB                                 ;; 03D98F : AB          ;
Return03D990:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03D991:          STZ.W $2115                         ;; 03D991 : 9C 15 21    ; VRAM Address Increment Value
CODE_03D994:          LDY.B #$00                          ;; 03D994 : A0 00       ;
CODE_03D996:          STY $02                             ;; 03D996 : 84 02       ;
CODE_03D998:          LDA.B #$00                          ;; 03D998 : A9 00       ;
CODE_03D99A:          STA $03                             ;; 03D99A : 85 03       ;
CODE_03D99C:          LDA $00                             ;; 03D99C : A5 00       ;
CODE_03D99E:          STA.W $2116                         ;; 03D99E : 8D 16 21    ; Address for VRAM Read/Write (Low Byte)
CODE_03D9A1:          LDA $01                             ;; 03D9A1 : A5 01       ;
CODE_03D9A3:          STA.W $2117                         ;; 03D9A3 : 8D 17 21    ; Address for VRAM Read/Write (High Byte)
CODE_03D9A6:          LDY $02                             ;; 03D9A6 : A4 02       ;
CODE_03D9A8:          LDA.B #$10                          ;; 03D9A8 : A9 10       ;
CODE_03D9AA:          STA $04                             ;; 03D9AA : 85 04       ;
CODE_03D9AC:          LDA [$05],Y                         ;; 03D9AC : B7 05       ;
CODE_03D9AE:          STA.W $0AF6,Y                       ;; 03D9AE : 99 F6 0A    ;
CODE_03D9B1:          ASL                                 ;; 03D9B1 : 0A          ;
CODE_03D9B2:          ASL                                 ;; 03D9B2 : 0A          ;
CODE_03D9B3:          ORA $03                             ;; 03D9B3 : 05 03       ;
CODE_03D9B5:          TAX                                 ;; 03D9B5 : AA          ;
CODE_03D9B6:          LDA.L DATA_03D8EC,X                 ;; 03D9B6 : BF EC D8 03 ;
CODE_03D9BA:          STA.W $2118                         ;; 03D9BA : 8D 18 21    ; Data for VRAM Write (Low Byte)
CODE_03D9BD:          LDA.L DATA_03D8EE,X                 ;; 03D9BD : BF EE D8 03 ;
CODE_03D9C1:          STA.W $2118                         ;; 03D9C1 : 8D 18 21    ; Data for VRAM Write (Low Byte)
CODE_03D9C4:          INY                                 ;; 03D9C4 : C8          ;
CODE_03D9C5:          DEC $04                             ;; 03D9C5 : C6 04       ;
CODE_03D9C7:          BNE CODE_03D9AC                     ;; 03D9C7 : D0 E3       ;
CODE_03D9C9:          LDA $00                             ;; 03D9C9 : A5 00       ;
CODE_03D9CB:          CLC                                 ;; 03D9CB : 18          ;
CODE_03D9CC:          ADC.B #$80                          ;; 03D9CC : 69 80       ;
CODE_03D9CE:          STA $00                             ;; 03D9CE : 85 00       ;
CODE_03D9D0:          BCC CODE_03D9D4                     ;; 03D9D0 : 90 02       ;
CODE_03D9D2:          INC $01                             ;; 03D9D2 : E6 01       ;
CODE_03D9D4:          LDA $03                             ;; 03D9D4 : A5 03       ;
CODE_03D9D6:          EOR.B #$01                          ;; 03D9D6 : 49 01       ;
CODE_03D9D8:          BNE CODE_03D99A                     ;; 03D9D8 : D0 C0       ;
CODE_03D9DA:          TYA                                 ;; 03D9DA : 98          ;
CODE_03D9DB:          BNE CODE_03D996                     ;; 03D9DB : D0 B9       ;
Return03D9DD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03D9DE:          .db $FF,$00,$FF,$FF,$02,$04,$06,$FF ;; 03D9DE               ;
                      .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF ;; ?QPWZ?               ;
                      .db $FF,$00,$FF,$FF,$02,$04,$06,$FF ;; ?QPWZ?               ;
                      .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF ;; ?QPWZ?               ;
                      .db $FF,$00,$FF,$FF,$02,$04,$06,$FF ;; ?QPWZ?               ;
                      .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $46,$48,$4A,$FF,$4C,$4E,$50,$FF ;; ?QPWZ?               ;
                      .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$B2,$B4,$06,$FF ;; ?QPWZ?               ;
                      .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $FF,$1C,$FF,$FF,$1E,$20,$22,$FF ;; ?QPWZ?               ;
                      .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF ;; ?QPWZ?               ;
                      .db $FF,$2E,$30,$FF,$32,$34,$35,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $FF,$2E,$30,$FF,$32,$34,$35,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $FF,$2E,$30,$FF,$32,$34,$35,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$3E,$40,$41,$3F ;; ?QPWZ?               ;
                      .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF ;; ?QPWZ?               ;
                      .db $08,$0A,$0C,$FF,$0E,$10,$12,$FF ;; ?QPWZ?               ;
                      .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF ;; ?QPWZ?               ;
                      .db $08,$0A,$0C,$FF,$0E,$14,$16,$FF ;; ?QPWZ?               ;
                      .db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF ;; ?QPWZ?               ;
                      .db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $6C,$6E,$FF,$FF,$72,$74,$50,$FF ;; ?QPWZ?               ;
                      .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $FF,$BE,$FF,$FF,$DC,$DE,$06,$FF ;; ?QPWZ?               ;
                      .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $60,$62,$FF,$FF,$64,$66,$22,$FF ;; ?QPWZ?               ;
                      .db $24,$26,$28,$FF,$FF,$2A,$2C,$FF ;; ?QPWZ?               ;
                      .db $FF,$68,$69,$FF,$32,$6A,$6B,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $FF,$68,$69,$FF,$32,$6A,$6B,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $FF,$68,$69,$FF,$32,$6A,$6B,$33 ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$3E,$40,$41,$3F ;; ?QPWZ?               ;
                      .db $7A,$7C,$FF,$FF,$7E,$80,$82,$FF ;; ?QPWZ?               ;
                      .db $84,$86,$0C,$FF,$0E,$10,$12,$FF ;; ?QPWZ?               ;
                      .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF ;; ?QPWZ?               ;
                      .db $84,$86,$0C,$FF,$0E,$14,$16,$FF ;; ?QPWZ?               ;
                      .db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF ;; ?QPWZ?               ;
                      .db $84,$86,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $A0,$A2,$A4,$FF,$A6,$A8,$AA,$FF ;; ?QPWZ?               ;
                      .db $52,$54,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $FF,$B8,$FF,$FF,$D6,$D8,$DA,$FF ;; ?QPWZ?               ;
                      .db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF ;; ?QPWZ?               ;
                      .db $88,$8A,$8C,$FF,$8E,$90,$92,$FF ;; ?QPWZ?               ;
                      .db $94,$96,$28,$FF,$FF,$2A,$2C,$FF ;; ?QPWZ?               ;
                      .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$42,$44,$45,$43 ;; ?QPWZ?               ;
                      .db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D ;; ?QPWZ?               ;
                      .db $36,$38,$39,$37,$3E,$40,$41,$3F ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF ;; ?QPWZ?               ;
                      .db $C0,$C2,$C4,$FF,$E0,$E2,$E4,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF ;; ?QPWZ?               ;
                      .db $C6,$C8,$CA,$FF,$E6,$E8,$EA,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$CD,$FF,$FF ;; ?QPWZ?               ;
                      .db $C5,$C3,$C1,$FF,$E5,$E3,$E1,$FF ;; ?QPWZ?               ;
                      .db $FF,$90,$92,$94,$96,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$B0,$B2,$B4,$B6,$38,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF ;; ?QPWZ?               ;
                      .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF ;; ?QPWZ?               ;
                      .db $FF,$90,$92,$94,$96,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$98,$9A,$9C,$B6,$38,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF ;; ?QPWZ?               ;
                      .db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF ;; ?QPWZ?               ;
                      .db $FF,$90,$92,$94,$96,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF ;; ?QPWZ?               ;
                      .db $FF,$F8,$FA,$FC,$F6,$78,$7A,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$90,$92,$94,$96,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$D8,$DA,$DC,$D6,$58,$5A ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$90,$92,$94,$96,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$90,$92,$94,$96,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$90,$92,$94,$96,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $04,$06,$08,$0A,$0B,$09,$07,$05 ;; ?QPWZ?               ;
                      .db $24,$26,$28,$2A,$2C,$29,$27,$25 ;; ?QPWZ?               ;
                      .db $FF,$84,$86,$88,$89,$87,$85,$FF ;; ?QPWZ?               ;
                      .db $FF,$A4,$A6,$A8,$A9,$A7,$A5,$FF ;; ?QPWZ?               ;
                      .db $04,$06,$08,$0A,$0B,$09,$07,$05 ;; ?QPWZ?               ;
                      .db $24,$26,$28,$2D,$2B,$29,$27,$25 ;; ?QPWZ?               ;
                      .db $FF,$84,$86,$88,$89,$87,$85,$FF ;; ?QPWZ?               ;
                      .db $FF,$A4,$A6,$0C,$0D,$A7,$A5,$FF ;; ?QPWZ?               ;
                      .db $80,$82,$83,$8A,$82,$83,$8C,$8E ;; ?QPWZ?               ;
                      .db $A0,$A2,$A3,$C4,$A2,$A3,$AC,$AE ;; ?QPWZ?               ;
                      .db $80,$8A,$8A,$8A,$8A,$8A,$8C,$8E ;; ?QPWZ?               ;
                      .db $A0,$60,$61,$C4,$60,$61,$AC,$AE ;; ?QPWZ?               ;
                      .db $80,$03,$01,$8A,$00,$02,$8C,$8E ;; ?QPWZ?               ;
                      .db $A0,$23,$21,$C4,$20,$22,$AC,$AE ;; ?QPWZ?               ;
                      .db $80,$00,$02,$8A,$03,$01,$AA,$8E ;; ?QPWZ?               ;
                      .db $A0,$20,$22,$C4,$23,$21,$AC,$AE ;; ?QPWZ?               ;
                      .db $C0,$C2,$C4,$C4,$C4,$CA,$CC,$CE ;; ?QPWZ?               ;
                      .db $E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE ;; ?QPWZ?               ;
                      .db $40,$42,$44,$46,$48,$4A,$4C,$4E ;; ?QPWZ?               ;
                      .db $FF,$62,$64,$66,$68,$6A,$6C,$FF ;; ?QPWZ?               ;
                      .db $10,$12,$14,$16,$18,$1A,$1C,$1E ;; ?QPWZ?               ;
                      .db $10,$30,$32,$34,$36,$1A,$1C,$1E ;; ?QPWZ?               ;
KoopaPalPtrLo:        .db $BC,$A4,$98,$78,$6C             ;; ?QPWZ?               ;
                                                          ;;                      ;
KoopaPalPtrHi:        .db $B2,$B2,$B2,$B3,$B3             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03DD78:          .db $0B,$0B,$0B,$21,$00             ;; 03DD78               ;
                                                          ;;                      ;
CODE_03DD7D:          PHX                                 ;; 03DD7D : DA          ;
CODE_03DD7E:          PHB                                 ;; 03DD7E : 8B          ;
CODE_03DD7F:          PHK                                 ;; 03DD7F : 4B          ;
CODE_03DD80:          PLB                                 ;; 03DD80 : AB          ;
CODE_03DD81:          LDY RAM_SpriteState,X               ;; 03DD81 : B4 C2       ;
CODE_03DD83:          STY.W $13FC                         ;; 03DD83 : 8C FC 13    ;
CODE_03DD86:          CPY.B #$04                          ;; 03DD86 : C0 04       ;
CODE_03DD88:          BNE CODE_03DD97                     ;; 03DD88 : D0 0D       ;
CODE_03DD8A:          JSR.W CODE_03DE8E                   ;; 03DD8A : 20 8E DE    ;
CODE_03DD8D:          LDA.B #$48                          ;; 03DD8D : A9 48       ;
CODE_03DD8F:          STA $2C                             ;; 03DD8F : 85 2C       ;
CODE_03DD91:          LDA.B #$14                          ;; 03DD91 : A9 14       ;
CODE_03DD93:          STA $38                             ;; 03DD93 : 85 38       ;
CODE_03DD95:          STA $39                             ;; 03DD95 : 85 39       ;
CODE_03DD97:          LDA.B #$FF                          ;; 03DD97 : A9 FF       ;
CODE_03DD99:          STA RAM_ScreensInLvl                ;; 03DD99 : 85 5D       ;
CODE_03DD9B:          INC A                               ;; 03DD9B : 1A          ;
CODE_03DD9C:          STA $5E                             ;; 03DD9C : 85 5E       ;
CODE_03DD9E:          LDY.W $13FC                         ;; 03DD9E : AC FC 13    ;
CODE_03DDA1:          LDX.W DATA_03DD78,Y                 ;; 03DDA1 : BE 78 DD    ;
CODE_03DDA4:          LDA.W KoopaPalPtrLo,Y               ;; 03DDA4 : B9 6E DD    ; \ $00 = Pointer in bank 0 (from above tables) 
CODE_03DDA7:          STA $00                             ;; 03DDA7 : 85 00       ;  | 
CODE_03DDA9:          LDA.W KoopaPalPtrHi,Y               ;; 03DDA9 : B9 73 DD    ;  | 
CODE_03DDAC:          STA $01                             ;; 03DDAC : 85 01       ;  | 
CODE_03DDAE:          STZ $02                             ;; 03DDAE : 64 02       ; / 
CODE_03DDB0:          LDY.B #$0B                          ;; 03DDB0 : A0 0B       ; \ Read 0B bytes and put them in $0707 
CODE_03DDB2:          LDA [$00],Y                         ;; 03DDB2 : B7 00       ;  | 
CODE_03DDB4:          STA.W $0707,Y                       ;; 03DDB4 : 99 07 07    ;  | 
CODE_03DDB7:          DEY                                 ;; 03DDB7 : 88          ;  | 
CODE_03DDB8:          BPL CODE_03DDB2                     ;; 03DDB8 : 10 F8       ; / 
CODE_03DDBA:          LDA.B #$80                          ;; 03DDBA : A9 80       ;
CODE_03DDBC:          STA.W $2115                         ;; 03DDBC : 8D 15 21    ; VRAM Address Increment Value
CODE_03DDBF:          STZ.W $2116                         ;; 03DDBF : 9C 16 21    ; Address for VRAM Read/Write (Low Byte)
CODE_03DDC2:          STZ.W $2117                         ;; 03DDC2 : 9C 17 21    ; Address for VRAM Read/Write (High Byte)
CODE_03DDC5:          TXY                                 ;; 03DDC5 : 9B          ;
CODE_03DDC6:          BEQ CODE_03DDD7                     ;; 03DDC6 : F0 0F       ;
CODE_03DDC8:          JSL.L CODE_00BA28                   ;; 03DDC8 : 22 28 BA 00 ;
CODE_03DDCC:          LDA.B #$80                          ;; 03DDCC : A9 80       ;
CODE_03DDCE:          STA $03                             ;; 03DDCE : 85 03       ;
CODE_03DDD0:          JSR.W CODE_03DDE5                   ;; 03DDD0 : 20 E5 DD    ;
CODE_03DDD3:          DEC $03                             ;; 03DDD3 : C6 03       ;
CODE_03DDD5:          BNE CODE_03DDD0                     ;; 03DDD5 : D0 F9       ;
CODE_03DDD7:          LDX.B #$5F                          ;; 03DDD7 : A2 5F       ;
CODE_03DDD9:          LDA.B #$FF                          ;; 03DDD9 : A9 FF       ;
CODE_03DDDB:          STA.L $7EC680,X                     ;; 03DDDB : 9F 80 C6 7E ;
CODE_03DDDF:          DEX                                 ;; 03DDDF : CA          ;
CODE_03DDE0:          BPL CODE_03DDD9                     ;; 03DDE0 : 10 F7       ;
CODE_03DDE2:          PLB                                 ;; 03DDE2 : AB          ;
CODE_03DDE3:          PLX                                 ;; 03DDE3 : FA          ;
Return03DDE4:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03DDE5:          LDX.B #$00                          ;; 03DDE5 : A2 00       ;
CODE_03DDE7:          TXY                                 ;; 03DDE7 : 9B          ;
CODE_03DDE8:          LDA.B #$08                          ;; 03DDE8 : A9 08       ;
CODE_03DDEA:          STA $05                             ;; 03DDEA : 85 05       ;
CODE_03DDEC:          JSR.W CODE_03DE39                   ;; 03DDEC : 20 39 DE    ;
CODE_03DDEF:          PHY                                 ;; 03DDEF : 5A          ;
CODE_03DDF0:          TYA                                 ;; 03DDF0 : 98          ;
CODE_03DDF1:          LSR                                 ;; 03DDF1 : 4A          ;
CODE_03DDF2:          CLC                                 ;; 03DDF2 : 18          ;
CODE_03DDF3:          ADC.B #$0F                          ;; 03DDF3 : 69 0F       ;
CODE_03DDF5:          TAY                                 ;; 03DDF5 : A8          ;
CODE_03DDF6:          JSR.W CODE_03DE3C                   ;; 03DDF6 : 20 3C DE    ;
CODE_03DDF9:          LDY.B #$08                          ;; 03DDF9 : A0 08       ;
CODE_03DDFB:          LDA.W $1BA3,X                       ;; 03DDFB : BD A3 1B    ;
CODE_03DDFE:          ASL                                 ;; 03DDFE : 0A          ;
CODE_03DDFF:          ROL                                 ;; 03DDFF : 2A          ;
CODE_03DE00:          ROL                                 ;; 03DE00 : 2A          ;
CODE_03DE01:          ROL                                 ;; 03DE01 : 2A          ;
CODE_03DE02:          AND.B #$07                          ;; 03DE02 : 29 07       ;
CODE_03DE04:          STA.W $1BA3,X                       ;; 03DE04 : 9D A3 1B    ;
CODE_03DE07:          STA.W $2119                         ;; 03DE07 : 8D 19 21    ; Data for VRAM Write (High Byte)
CODE_03DE0A:          INX                                 ;; 03DE0A : E8          ;
CODE_03DE0B:          DEY                                 ;; 03DE0B : 88          ;
CODE_03DE0C:          BNE CODE_03DDFB                     ;; 03DE0C : D0 ED       ;
CODE_03DE0E:          PLY                                 ;; 03DE0E : 7A          ;
CODE_03DE0F:          DEC $05                             ;; 03DE0F : C6 05       ;
CODE_03DE11:          BNE CODE_03DDEC                     ;; 03DE11 : D0 D9       ;
CODE_03DE13:          LDA.B #$07                          ;; 03DE13 : A9 07       ;
CODE_03DE15:          TAX                                 ;; 03DE15 : AA          ;
CODE_03DE16:          LDY.B #$08                          ;; 03DE16 : A0 08       ;
CODE_03DE18:          STY $05                             ;; 03DE18 : 84 05       ;
CODE_03DE1A:          LDY.W $1BA3,X                       ;; 03DE1A : BC A3 1B    ;
CODE_03DE1D:          STY.W $2119                         ;; 03DE1D : 8C 19 21    ; Data for VRAM Write (High Byte)
CODE_03DE20:          DEX                                 ;; 03DE20 : CA          ;
CODE_03DE21:          DEC $05                             ;; 03DE21 : C6 05       ;
CODE_03DE23:          BNE CODE_03DE1A                     ;; 03DE23 : D0 F5       ;
CODE_03DE25:          CLC                                 ;; 03DE25 : 18          ;
CODE_03DE26:          ADC.B #$08                          ;; 03DE26 : 69 08       ;
CODE_03DE28:          CMP.B #$40                          ;; 03DE28 : C9 40       ;
CODE_03DE2A:          BCC CODE_03DE15                     ;; 03DE2A : 90 E9       ;
CODE_03DE2C:          REP #$20                            ;; 03DE2C : C2 20       ; Accum (16 bit) 
CODE_03DE2E:          LDA $00                             ;; 03DE2E : A5 00       ;
CODE_03DE30:          CLC                                 ;; 03DE30 : 18          ;
CODE_03DE31:          ADC.W #$0018                        ;; 03DE31 : 69 18 00    ;
CODE_03DE34:          STA $00                             ;; 03DE34 : 85 00       ;
CODE_03DE36:          SEP #$20                            ;; 03DE36 : E2 20       ; Accum (8 bit) 
Return03DE38:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03DE39:          JSR.W CODE_03DE3C                   ;; 03DE39 : 20 3C DE    ;
CODE_03DE3C:          PHX                                 ;; 03DE3C : DA          ;
CODE_03DE3D:          LDA [$00],Y                         ;; 03DE3D : B7 00       ;
CODE_03DE3F:          PHY                                 ;; 03DE3F : 5A          ;
CODE_03DE40:          LDY.B #$08                          ;; 03DE40 : A0 08       ;
CODE_03DE42:          ASL                                 ;; 03DE42 : 0A          ;
CODE_03DE43:          ROR.W $1BA3,X                       ;; 03DE43 : 7E A3 1B    ;
CODE_03DE46:          INX                                 ;; 03DE46 : E8          ;
CODE_03DE47:          DEY                                 ;; 03DE47 : 88          ;
CODE_03DE48:          BNE CODE_03DE42                     ;; 03DE48 : D0 F8       ;
CODE_03DE4A:          PLY                                 ;; 03DE4A : 7A          ;
CODE_03DE4B:          INY                                 ;; 03DE4B : C8          ;
CODE_03DE4C:          PLX                                 ;; 03DE4C : FA          ;
Return03DE4D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DE4E:          .db $40,$41,$42,$43,$44,$45,$46,$47 ;; 03DE4E               ;
                      .db $50,$51,$52,$53,$54,$55,$56,$57 ;; ?QPWZ?               ;
                      .db $60,$61,$62,$63,$64,$65,$66,$67 ;; ?QPWZ?               ;
                      .db $70,$71,$72,$73,$74,$75,$76,$77 ;; ?QPWZ?               ;
                      .db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F ;; ?QPWZ?               ;
                      .db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F ;; ?QPWZ?               ;
                      .db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F ;; ?QPWZ?               ;
                      .db $78,$79,$7A,$7B,$7C,$7D,$7E,$3F ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03DE8E:          STZ.W $2115                         ;; 03DE8E : 9C 15 21    ; VRAM Address Increment Value
CODE_03DE91:          REP #$20                            ;; 03DE91 : C2 20       ; Accum (16 bit) 
CODE_03DE93:          LDA.W #$0A1C                        ;; 03DE93 : A9 1C 0A    ;
CODE_03DE96:          STA $00                             ;; 03DE96 : 85 00       ;
CODE_03DE98:          LDX.B #$00                          ;; 03DE98 : A2 00       ;
CODE_03DE9A:          REP #$20                            ;; 03DE9A : C2 20       ; Accum (16 bit) 
CODE_03DE9C:          LDA $00                             ;; 03DE9C : A5 00       ;
CODE_03DE9E:          CLC                                 ;; 03DE9E : 18          ;
CODE_03DE9F:          ADC.W #$0080                        ;; 03DE9F : 69 80 00    ;
CODE_03DEA2:          STA $00                             ;; 03DEA2 : 85 00       ;
CODE_03DEA4:          STA.W $2116                         ;; 03DEA4 : 8D 16 21    ; Address for VRAM Read/Write (Low Byte)
CODE_03DEA7:          SEP #$20                            ;; 03DEA7 : E2 20       ; Accum (8 bit) 
CODE_03DEA9:          LDY.B #$08                          ;; 03DEA9 : A0 08       ;
CODE_03DEAB:          LDA.L DATA_03DE4E,X                 ;; 03DEAB : BF 4E DE 03 ;
CODE_03DEAF:          STA.W $2118                         ;; 03DEAF : 8D 18 21    ; Data for VRAM Write (Low Byte)
CODE_03DEB2:          INX                                 ;; 03DEB2 : E8          ;
CODE_03DEB3:          DEY                                 ;; 03DEB3 : 88          ;
CODE_03DEB4:          BNE CODE_03DEAB                     ;; 03DEB4 : D0 F5       ;
CODE_03DEB6:          CPX.B #$40                          ;; 03DEB6 : E0 40       ;
CODE_03DEB8:          BCC CODE_03DE9A                     ;; 03DEB8 : 90 E0       ;
Return03DEBA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DEBB:          .db $00,$01,$10,$01                 ;; 03DEBB               ;
                                                          ;;                      ;
DATA_03DEBF:          .db $6E,$70,$FF,$50,$FE,$FE,$FF,$57 ;; 03DEBF               ;
DATA_03DEC7:          .db $72,$74,$52,$54,$3C,$3E,$55,$53 ;; 03DEC7               ;
DATA_03DECF:          .db $76,$56,$56,$FF,$FF,$FF,$51,$FF ;; 03DECF               ;
DATA_03DED7:          .db $20,$03,$30,$03,$40,$03,$50,$03 ;; 03DED7               ;
                                                          ;;                      ;
CODE_03DEDF:          PHB                                 ;; 03DEDF : 8B          ;
CODE_03DEE0:          PHK                                 ;; 03DEE0 : 4B          ;
CODE_03DEE1:          PLB                                 ;; 03DEE1 : AB          ;
CODE_03DEE2:          LDA.W RAM_SpriteXHi,X               ;; 03DEE2 : BD E0 14    ;
CODE_03DEE5:          XBA                                 ;; 03DEE5 : EB          ;
CODE_03DEE6:          LDA RAM_SpriteXLo,X                 ;; 03DEE6 : B5 E4       ;
CODE_03DEE8:          LDY.B #$00                          ;; 03DEE8 : A0 00       ;
CODE_03DEEA:          JSR.W CODE_03DFAE                   ;; 03DEEA : 20 AE DF    ;
CODE_03DEED:          LDA.W RAM_SpriteYHi,X               ;; 03DEED : BD D4 14    ;
CODE_03DEF0:          XBA                                 ;; 03DEF0 : EB          ;
CODE_03DEF1:          LDA RAM_SpriteYLo,X                 ;; 03DEF1 : B5 D8       ;
CODE_03DEF3:          LDY.B #$02                          ;; 03DEF3 : A0 02       ;
CODE_03DEF5:          JSR.W CODE_03DFAE                   ;; 03DEF5 : 20 AE DF    ;
CODE_03DEF8:          PHX                                 ;; 03DEF8 : DA          ;
CODE_03DEF9:          REP #$30                            ;; 03DEF9 : C2 30       ; Index (16 bit) Accum (16 bit) 
CODE_03DEFB:          STZ $06                             ;; 03DEFB : 64 06       ;
CODE_03DEFD:          LDY.W #$0003                        ;; 03DEFD : A0 03 00    ;
CODE_03DF00:          LDA.W $0D9B                         ;; 03DF00 : AD 9B 0D    ;
CODE_03DF03:          LSR                                 ;; 03DF03 : 4A          ;
CODE_03DF04:          BCC CODE_03DF44                     ;; 03DF04 : 90 3E       ;
CODE_03DF06:          LDA.W $1428                         ;; 03DF06 : AD 28 14    ;
CODE_03DF09:          AND.W #$0003                        ;; 03DF09 : 29 03 00    ;
CODE_03DF0C:          ASL                                 ;; 03DF0C : 0A          ;
CODE_03DF0D:          TAX                                 ;; 03DF0D : AA          ;
CODE_03DF0E:          LDA.L DATA_03DEBF,X                 ;; 03DF0E : BF BF DE 03 ;
CODE_03DF12:          STA.L $7EC681                       ;; 03DF12 : 8F 81 C6 7E ;
CODE_03DF16:          LDA.L DATA_03DEC7,X                 ;; 03DF16 : BF C7 DE 03 ;
CODE_03DF1A:          STA.L $7EC683                       ;; 03DF1A : 8F 83 C6 7E ;
CODE_03DF1E:          LDA.L DATA_03DECF,X                 ;; 03DF1E : BF CF DE 03 ;
CODE_03DF22:          STA.L $7EC685                       ;; 03DF22 : 8F 85 C6 7E ;
CODE_03DF26:          LDA.W #$0008                        ;; 03DF26 : A9 08 00    ;
CODE_03DF29:          STA $06                             ;; 03DF29 : 85 06       ;
CODE_03DF2B:          LDX.W #$0380                        ;; 03DF2B : A2 80 03    ;
CODE_03DF2E:          LDA.W $1BA2                         ;; 03DF2E : AD A2 1B    ;
CODE_03DF31:          AND.W #$007F                        ;; 03DF31 : 29 7F 00    ;
CODE_03DF34:          CMP.W #$002C                        ;; 03DF34 : C9 2C 00    ;
CODE_03DF37:          BCC CODE_03DF3C                     ;; 03DF37 : 90 03       ;
CODE_03DF39:          LDX.W #$0388                        ;; 03DF39 : A2 88 03    ;
CODE_03DF3C:          TXA                                 ;; 03DF3C : 8A          ;
CODE_03DF3D:          LDX.W #$000A                        ;; 03DF3D : A2 0A 00    ;
CODE_03DF40:          LDY.W #$0007                        ;; 03DF40 : A0 07 00    ;
CODE_03DF43:          SEC                                 ;; 03DF43 : 38          ;
CODE_03DF44:          STY $00                             ;; 03DF44 : 84 00       ;
CODE_03DF46:          BCS CODE_03DF55                     ;; 03DF46 : B0 0D       ;
CODE_03DF48:          LDA.W $1BA2                         ;; 03DF48 : AD A2 1B    ;
CODE_03DF4B:          AND.W #$007F                        ;; 03DF4B : 29 7F 00    ;
CODE_03DF4E:          ASL                                 ;; 03DF4E : 0A          ;
CODE_03DF4F:          ASL                                 ;; 03DF4F : 0A          ;
CODE_03DF50:          ASL                                 ;; 03DF50 : 0A          ;
CODE_03DF51:          ASL                                 ;; 03DF51 : 0A          ;
CODE_03DF52:          LDX.W #$0003                        ;; 03DF52 : A2 03 00    ;
CODE_03DF55:          STX $02                             ;; 03DF55 : 86 02       ;
CODE_03DF57:          PHA                                 ;; 03DF57 : 48          ;
CODE_03DF58:          LDY.W $1BA1                         ;; 03DF58 : AC A1 1B    ;
CODE_03DF5B:          BPL CODE_03DF60                     ;; 03DF5B : 10 03       ;
CODE_03DF5D:          CLC                                 ;; 03DF5D : 18          ;
CODE_03DF5E:          ADC $00                             ;; 03DF5E : 65 00       ;
CODE_03DF60:          TAY                                 ;; 03DF60 : A8          ;
CODE_03DF61:          SEP #$20                            ;; 03DF61 : E2 20       ; Accum (8 bit) 
CODE_03DF63:          LDX $06                             ;; 03DF63 : A6 06       ;
CODE_03DF65:          LDA $00                             ;; 03DF65 : A5 00       ;
CODE_03DF67:          STA $04                             ;; 03DF67 : 85 04       ;
CODE_03DF69:          LDA.W DATA_03D9DE,Y                 ;; 03DF69 : B9 DE D9    ;
CODE_03DF6C:          INY                                 ;; 03DF6C : C8          ;
CODE_03DF6D:          BIT.W $1BA2                         ;; 03DF6D : 2C A2 1B    ;
CODE_03DF70:          BPL CODE_03DF76                     ;; 03DF70 : 10 04       ;
CODE_03DF72:          EOR.B #$01                          ;; 03DF72 : 49 01       ;
CODE_03DF74:          DEY                                 ;; 03DF74 : 88          ;
CODE_03DF75:          DEY                                 ;; 03DF75 : 88          ;
CODE_03DF76:          STA.L $7EC680,X                     ;; 03DF76 : 9F 80 C6 7E ;
CODE_03DF7A:          INX                                 ;; 03DF7A : E8          ;
CODE_03DF7B:          DEC $04                             ;; 03DF7B : C6 04       ;
CODE_03DF7D:          BPL CODE_03DF69                     ;; 03DF7D : 10 EA       ;
CODE_03DF7F:          STX $06                             ;; 03DF7F : 86 06       ;
CODE_03DF81:          REP #$20                            ;; 03DF81 : C2 20       ; Accum (16 bit) 
CODE_03DF83:          PLA                                 ;; 03DF83 : 68          ;
CODE_03DF84:          SEC                                 ;; 03DF84 : 38          ;
CODE_03DF85:          ADC $00                             ;; 03DF85 : 65 00       ;
CODE_03DF87:          LDX $02                             ;; 03DF87 : A6 02       ;
CODE_03DF89:          CPX.W #$0004                        ;; 03DF89 : E0 04 00    ;
CODE_03DF8C:          BEQ CODE_03DF48                     ;; 03DF8C : F0 BA       ;
CODE_03DF8E:          CPX.W #$0008                        ;; 03DF8E : E0 08 00    ;
CODE_03DF91:          BNE CODE_03DF96                     ;; 03DF91 : D0 03       ;
CODE_03DF93:          LDA.W #$0360                        ;; 03DF93 : A9 60 03    ;
CODE_03DF96:          CPX.W #$000A                        ;; 03DF96 : E0 0A 00    ;
CODE_03DF99:          BNE CODE_03DFA6                     ;; 03DF99 : D0 0B       ;
CODE_03DF9B:          LDA.W $1427                         ;; 03DF9B : AD 27 14    ;
CODE_03DF9E:          AND.W #$0003                        ;; 03DF9E : 29 03 00    ;
CODE_03DFA1:          ASL                                 ;; 03DFA1 : 0A          ;
CODE_03DFA2:          TAY                                 ;; 03DFA2 : A8          ;
CODE_03DFA3:          LDA.W DATA_03DED7,Y                 ;; 03DFA3 : B9 D7 DE    ;
CODE_03DFA6:          DEX                                 ;; 03DFA6 : CA          ;
CODE_03DFA7:          BPL CODE_03DF55                     ;; 03DFA7 : 10 AC       ;
CODE_03DFA9:          SEP #$30                            ;; 03DFA9 : E2 30       ; Index (8 bit) Accum (8 bit) 
CODE_03DFAB:          PLX                                 ;; 03DFAB : FA          ;
CODE_03DFAC:          PLB                                 ;; 03DFAC : AB          ;
Return03DFAD:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03DFAE:          PHX                                 ;; 03DFAE : DA          ;
CODE_03DFAF:          TYX                                 ;; 03DFAF : BB          ;
CODE_03DFB0:          REP #$20                            ;; 03DFB0 : C2 20       ; Accum (16 bit) 
CODE_03DFB2:          EOR.W #$FFFF                        ;; 03DFB2 : 49 FF FF    ;
CODE_03DFB5:          INC A                               ;; 03DFB5 : 1A          ;
CODE_03DFB6:          CLC                                 ;; 03DFB6 : 18          ;
CODE_03DFB7:          ADC.L DATA_03DEBB,X                 ;; 03DFB7 : 7F BB DE 03 ;
CODE_03DFBB:          CLC                                 ;; 03DFBB : 18          ;
CODE_03DFBC:          ADC RAM_ScreenBndryXLo,X            ;; 03DFBC : 75 1A       ;
CODE_03DFBE:          STA $3A,X                           ;; 03DFBE : 95 3A       ;
CODE_03DFC0:          SEP #$20                            ;; 03DFC0 : E2 20       ; Accum (8 bit) 
CODE_03DFC2:          PLX                                 ;; 03DFC2 : FA          ;
Return03DFC3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DFC4:          .db $00,$0E,$1C,$2A,$38,$46,$54,$62 ;; 03DFC4               ;
                                                          ;;                      ;
CODE_03DFCC:          PHX                                 ;; 03DFCC : DA          ;
CODE_03DFCD:          LDX.W $0681                         ;; 03DFCD : AE 81 06    ;
CODE_03DFD0:          LDA.B #$10                          ;; 03DFD0 : A9 10       ;
CODE_03DFD2:          STA.W $0682,X                       ;; 03DFD2 : 9D 82 06    ;
CODE_03DFD5:          STZ.W $0683,X                       ;; 03DFD5 : 9E 83 06    ;
CODE_03DFD8:          STZ.W $0684,X                       ;; 03DFD8 : 9E 84 06    ;
CODE_03DFDB:          STZ.W $0685,X                       ;; 03DFDB : 9E 85 06    ;
CODE_03DFDE:          TXY                                 ;; 03DFDE : 9B          ;
CODE_03DFDF:          LDX.W $1FFB                         ;; 03DFDF : AE FB 1F    ;
CODE_03DFE2:          BNE CODE_03E01B                     ;; 03DFE2 : D0 37       ;
CODE_03DFE4:          LDA.W $190D                         ;; 03DFE4 : AD 0D 19    ;
CODE_03DFE7:          BEQ CODE_03DFF0                     ;; 03DFE7 : F0 07       ;
CODE_03DFE9:          REP #$20                            ;; 03DFE9 : C2 20       ; Accum (16 bit) 
CODE_03DFEB:          LDA.W $0701                         ;; 03DFEB : AD 01 07    ;
CODE_03DFEE:          BRA CODE_03E031                     ;; 03DFEE : 80 41       ;
                                                          ;;                      ;
CODE_03DFF0:          LDA RAM_FrameCounterB               ;; 03DFF0 : A5 14       ; Accum (8 bit) 
CODE_03DFF2:          LSR                                 ;; 03DFF2 : 4A          ;
CODE_03DFF3:          BCC CODE_03E036                     ;; 03DFF3 : 90 41       ;
CODE_03DFF5:          DEC.W $1FFC                         ;; 03DFF5 : CE FC 1F    ;
CODE_03DFF8:          BNE CODE_03E036                     ;; 03DFF8 : D0 3C       ;
CODE_03DFFA:          TAX                                 ;; 03DFFA : AA          ;
CODE_03DFFB:          LDA.L CODE_04F708,X                 ;; 03DFFB : BF 08 F7 04 ;
CODE_03DFFF:          AND.B #$07                          ;; 03DFFF : 29 07       ;
CODE_03E001:          TAX                                 ;; 03E001 : AA          ;
CODE_03E002:          LDA.L DATA_04F6F8,X                 ;; 03E002 : BF F8 F6 04 ;
CODE_03E006:          STA.W $1FFC                         ;; 03E006 : 8D FC 1F    ;
CODE_03E009:          LDA.L DATA_04F700,X                 ;; 03E009 : BF 00 F7 04 ;
CODE_03E00D:          STA.W $1FFB                         ;; 03E00D : 8D FB 1F    ;
CODE_03E010:          TAX                                 ;; 03E010 : AA          ;
CODE_03E011:          LDA.B #$08                          ;; 03E011 : A9 08       ;
CODE_03E013:          STA.W $1FFD                         ;; 03E013 : 8D FD 1F    ;
CODE_03E016:          LDA.B #$18                          ;; 03E016 : A9 18       ;
CODE_03E018:          STA.W $1DFC                         ;; 03E018 : 8D FC 1D    ; / Play sound effect 
CODE_03E01B:          DEC.W $1FFD                         ;; 03E01B : CE FD 1F    ;
CODE_03E01E:          BPL CODE_03E028                     ;; 03E01E : 10 08       ;
CODE_03E020:          DEC.W $1FFB                         ;; 03E020 : CE FB 1F    ;
CODE_03E023:          LDA.B #$04                          ;; 03E023 : A9 04       ;
CODE_03E025:          STA.W $1FFD                         ;; 03E025 : 8D FD 1F    ;
CODE_03E028:          TXA                                 ;; 03E028 : 8A          ;
CODE_03E029:          ASL                                 ;; 03E029 : 0A          ;
CODE_03E02A:          TAX                                 ;; 03E02A : AA          ;
CODE_03E02B:          REP #$20                            ;; 03E02B : C2 20       ; Accum (16 bit) 
CODE_03E02D:          LDA.L DATA_00B5DE,X                 ;; 03E02D : BF DE B5 00 ;
CODE_03E031:          STA.W $0684,Y                       ;; 03E031 : 99 84 06    ;
CODE_03E034:          SEP #$20                            ;; 03E034 : E2 20       ; Accum (8 bit) 
CODE_03E036:          LDX.W $1429                         ;; 03E036 : AE 29 14    ;
CODE_03E039:          LDA.L DATA_03DFC4,X                 ;; 03E039 : BF C4 DF 03 ;
CODE_03E03D:          TAX                                 ;; 03E03D : AA          ;
CODE_03E03E:          LDA.B #$0E                          ;; 03E03E : A9 0E       ;
CODE_03E040:          STA $00                             ;; 03E040 : 85 00       ;
CODE_03E042:          LDA.L DATA_00B69E,X                 ;; 03E042 : BF 9E B6 00 ;
CODE_03E046:          STA.W $0686,Y                       ;; 03E046 : 99 86 06    ;
CODE_03E049:          INX                                 ;; 03E049 : E8          ;
CODE_03E04A:          INY                                 ;; 03E04A : C8          ;
CODE_03E04B:          DEC $00                             ;; 03E04B : C6 00       ;
CODE_03E04D:          BNE CODE_03E042                     ;; 03E04D : D0 F3       ;
CODE_03E04F:          TYX                                 ;; 03E04F : BB          ;
CODE_03E050:          STZ.W $0686,X                       ;; 03E050 : 9E 86 06    ;
CODE_03E053:          INX                                 ;; 03E053 : E8          ;
CODE_03E054:          INX                                 ;; 03E054 : E8          ;
CODE_03E055:          INX                                 ;; 03E055 : E8          ;
CODE_03E056:          INX                                 ;; 03E056 : E8          ;
CODE_03E057:          STX.W $0681                         ;; 03E057 : 8E 81 06    ;
CODE_03E05A:          PLX                                 ;; 03E05A : FA          ;
Return03E05B:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03E05C:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 03E05C               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF                 ;; ?QPWZ?               ;
                                                          ;;                      ;
ADDR_03E400:          DEC RAM_MarioPowerUp                ;; 03E400 : C6 19       ; \ Unreachable 
Return03E402:         RTS                                 ;; ?QPWZ? : 60          ; / Decrease Mario's Status 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03E403:          .db $13,$78,$13,$BE,$14,$F2,$14,$1C ;; 03E403               ;
                      .db $16,$78,$13,$BE,$14,$F2,$14,$1C ;; ?QPWZ?               ;
                      .db $16,$78,$13,$BE,$14,$F2,$14,$1C ;; ?QPWZ?               ;
                      .db $16,$9E,$13,$AE,$13,$BE,$13,$DE ;; ?QPWZ?               ;
                      .db $13,$CE,$13,$EE,$13,$FE,$13,$0E ;; ?QPWZ?               ;
                      .db $14,$1E,$14,$2E,$14,$3E,$14,$4E ;; ?QPWZ?               ;
                      .db $14,$5E,$14,$6E,$14,$7E,$14,$8E ;; ?QPWZ?               ;
                      .db $14,$9E,$14,$AE,$14,$00,$00,$94 ;; ?QPWZ?               ;
                      .db $21,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$97 ;; ?QPWZ?               ;
                      .db $21,$BB,$21,$51,$22,$F7,$21,$33 ;; ?QPWZ?               ;
                      .db $22,$15,$22,$D9,$21,$73,$22,$92 ;; ?QPWZ?               ;
                      .db $22,$B4,$23,$E2,$23,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$CC,$23,$0F,$24,$C9 ;; ?QPWZ?               ;
                      .db $22,$B4,$23,$E2,$23,$00,$23,$00 ;; ?QPWZ?               ;
                      .db $00,$1A,$23,$CC,$23,$0F,$24,$44 ;; ?QPWZ?               ;
                      .db $24,$6B,$24,$AF,$24,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$8E,$24,$DF,$24,$35 ;; ?QPWZ?               ;
                      .db $25,$6E,$25,$B2,$25,$5C,$25,$00 ;; ?QPWZ?               ;
                      .db $00,$0F,$25,$91,$25,$E2,$25,$12 ;; ?QPWZ?               ;
                      .db $26,$8D,$26,$B1,$26,$61,$26,$00 ;; ?QPWZ?               ;
                      .db $00,$3A,$26,$A0,$26,$E1,$26,$11 ;; ?QPWZ?               ;
                      .db $27,$7E,$27,$A8,$27,$54,$27,$00 ;; ?QPWZ?               ;
                      .db $00,$33,$27,$94,$27,$0F,$24,$D1 ;; ?QPWZ?               ;
                      .db $22,$B4,$23,$E2,$23,$00,$23,$7E ;; ?QPWZ?               ;
                      .db $23,$50,$23,$CC,$23,$0F,$24,$14 ;; ?QPWZ?               ;
                      .db $28,$54,$28,$80,$28,$4C,$28,$2C ;; ?QPWZ?               ;
                      .db $28,$FD,$27,$6B,$28,$A4,$28,$C8 ;; ?QPWZ?               ;
                      .db $28,$E7,$28,$7D,$29,$23,$29,$5F ;; ?QPWZ?               ;
                      .db $29,$41,$29,$05,$29,$9F,$29,$D1 ;; ?QPWZ?               ;
                      .db $22,$BE,$29,$E2,$23,$00,$23,$7E ;; ?QPWZ?               ;
                      .db $23,$50,$23,$CC,$23,$0F,$24,$14 ;; ?QPWZ?               ;
                      .db $28,$F5,$29,$0D,$2A,$4C,$28,$2C ;; ?QPWZ?               ;
                      .db $28,$FD,$27,$6B,$28,$A4,$28,$47 ;; ?QPWZ?               ;
                      .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0 ;; ?QPWZ?               ;
                      .db $2A,$C0,$2A,$84,$2A,$24,$2B,$79 ;; ?QPWZ?               ;
                      .db $2B,$43,$2B,$E2,$23,$00,$23,$E2 ;; ?QPWZ?               ;
                      .db $2B,$AE,$2B,$CC,$23,$0F,$24,$47 ;; ?QPWZ?               ;
                      .db $2C,$18,$2C,$0D,$2A,$4C,$28,$5F ;; ?QPWZ?               ;
                      .db $2C,$30,$2C,$6B,$28,$A4,$28,$25 ;; ?QPWZ?               ;
                      .db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0 ;; ?QPWZ?               ;
                      .db $2A,$C0,$2A,$84,$2A,$24,$2B,$7F ;; ?QPWZ?               ;
                      .db $2C,$98,$2C,$0C,$2D,$C8,$2C,$F6 ;; ?QPWZ?               ;
                      .db $2C,$E0,$2C,$B0,$2C,$00,$00,$C2 ;; ?QPWZ?               ;
                      .db $14,$00,$00,$76,$1E,$C5,$1E,$F0 ;; ?QPWZ?               ;
                      .db $1E,$A2,$1E,$03,$1F,$2A,$1F,$49 ;; ?QPWZ?               ;
                      .db $1F,$68,$1F,$A4,$1F,$0A,$20,$4C ;; ?QPWZ?               ;
                      .db $20,$E9,$1F,$C8,$1F,$83,$1F,$2C ;; ?QPWZ?               ;
                      .db $20,$7B,$20,$A6,$20,$C8,$20,$5A ;; ?QPWZ?               ;
                      .db $21,$04,$21,$3E,$21,$22,$21,$E6 ;; ?QPWZ?               ;
                      .db $20,$7A,$21,$D2,$14,$E2,$14,$2C ;; ?QPWZ?               ;
                      .db $15,$4C,$15,$3C,$15,$5C,$15,$6C ;; ?QPWZ?               ;
                      .db $15,$7C,$15,$8C,$15,$9C,$15,$AC ;; ?QPWZ?               ;
                      .db $15,$CC,$15,$BC,$15,$DC,$15,$EC ;; ?QPWZ?               ;
                      .db $15,$AE,$13,$4E,$14,$5E,$14,$6E ;; ?QPWZ?               ;
                      .db $14,$7E,$14,$8E,$14,$6E,$14,$FC ;; ?QPWZ?               ;
                      .db $15,$6E,$14,$7E,$14,$8E,$14,$9E ;; ?QPWZ?               ;
                      .db $14,$0C,$16,$00,$00,$3D,$16,$93 ;; ?QPWZ?               ;
                      .db $17,$BD,$17,$1B,$17,$57,$17,$99 ;; ?QPWZ?               ;
                      .db $16,$00,$00,$E7,$17,$3D,$16,$93 ;; ?QPWZ?               ;
                      .db $17,$BD,$17,$1B,$17,$57,$17,$DE ;; ?QPWZ?               ;
                      .db $16,$00,$00,$E7,$17,$00,$18,$EF ;; ?QPWZ?               ;
                      .db $18,$10,$19,$89,$18,$BC,$18,$55 ;; ?QPWZ?               ;
                      .db $18,$00,$00,$E7,$17,$31,$19,$E4 ;; ?QPWZ?               ;
                      .db $19,$05,$1A,$8A,$19,$B7,$19,$5F ;; ?QPWZ?               ;
                      .db $19,$00,$00,$E7,$17,$C8,$1A,$AB ;; ?QPWZ?               ;
                      .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91 ;; ?QPWZ?               ;
                      .db $1B,$00,$00,$E7,$17,$ED,$1B,$6E ;; ?QPWZ?               ;
                      .db $1C,$8F,$1C,$1B,$1C,$48,$1C,$5B ;; ?QPWZ?               ;
                      .db $1C,$00,$00,$E7,$17,$C8,$1A,$AB ;; ?QPWZ?               ;
                      .db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91 ;; ?QPWZ?               ;
                      .db $1B,$01,$1B,$E7,$17,$B0,$1C,$70 ;; ?QPWZ?               ;
                      .db $1D,$90,$1D,$19,$1D,$4A,$1D,$5D ;; ?QPWZ?               ;
                      .db $1D,$E2,$1C,$AE,$1D,$3D,$16,$93 ;; ?QPWZ?               ;
                      .db $17,$BD,$17,$1B,$17,$57,$17,$99 ;; ?QPWZ?               ;
                      .db $16,$7C,$16,$E7,$17,$3D,$16,$93 ;; ?QPWZ?               ;
                      .db $17,$BD,$17,$1B,$17,$57,$17,$DE ;; ?QPWZ?               ;
                      .db $16,$7C,$16,$E7,$17,$00,$18,$EF ;; ?QPWZ?               ;
                      .db $18,$10,$19,$89,$18,$BC,$18,$55 ;; ?QPWZ?               ;
                      .db $18,$34,$18,$E7,$17,$26,$1A,$A6 ;; ?QPWZ?               ;
                      .db $1A,$B7,$1A,$4E,$1A,$67,$1A,$80 ;; ?QPWZ?               ;
                      .db $1A,$40,$1A,$E7,$17,$32,$16,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$3A,$16,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$C1,$1D,$D4 ;; ?QPWZ?               ;
                      .db $1D,$58,$1E,$F8,$1D,$3E,$1E,$0A ;; ?QPWZ?               ;
                      .db $1E,$E6,$1D,$24,$1E,$2C,$15,$4C ;; ?QPWZ?               ;
                      .db $15,$2C,$15,$5C,$15,$6C,$15,$7C ;; ?QPWZ?               ;
                      .db $15,$6C,$15,$9C,$15,$FF,$00,$1C ;; ?QPWZ?               ;
                      .db $16,$00,$00,$DA,$04,$E2,$16,$E3 ;; ?QPWZ?               ;
                      .db $90,$1B,$00,$E4,$01,$00,$DA,$12 ;; ?QPWZ?               ;
                      .db $E2,$1E,$DB,$0A,$DE,$14,$19,$27 ;; ?QPWZ?               ;
                      .db $0C,$6D,$B4,$0C,$2E,$B7,$B9,$30 ;; ?QPWZ?               ;
                      .db $6E,$B7,$0C,$2D,$B9,$0C,$6E,$BB ;; ?QPWZ?               ;
                      .db $C6,$0C,$2D,$BB,$30,$6E,$B9,$0C ;; ?QPWZ?               ;
                      .db $2D,$B3,$0C,$6E,$B4,$0C,$2D,$B7 ;; ?QPWZ?               ;
                      .db $B9,$30,$6E,$B7,$0C,$2D,$B8,$0C ;; ?QPWZ?               ;
                      .db $6E,$B9,$C6,$0C,$2D,$B9,$30,$6E ;; ?QPWZ?               ;
                      .db $B7,$0C,$2D,$B8,$00,$DA,$12,$DB ;; ?QPWZ?               ;
                      .db $0F,$DE,$14,$14,$20,$48,$6D,$B7 ;; ?QPWZ?               ;
                      .db $18,$B9,$48,$B7,$0C,$B4,$B5,$30 ;; ?QPWZ?               ;
                      .db $B7,$0C,$C6,$B9,$B7,$B9,$48,$B7 ;; ?QPWZ?               ;
                      .db $18,$B4,$DA,$00,$DB,$05,$DE,$14 ;; ?QPWZ?               ;
                      .db $19,$27,$30,$6B,$C7,$0C,$C7,$B7 ;; ?QPWZ?               ;
                      .db $0C,$2C,$B9,$BC,$06,$7B,$BB,$BC ;; ?QPWZ?               ;
                      .db $0C,$69,$BB,$18,$C6,$0C,$C7,$B3 ;; ?QPWZ?               ;
                      .db $0C,$2C,$B7,$BB,$06,$7B,$B9,$BB ;; ?QPWZ?               ;
                      .db $0C,$69,$B9,$18,$C6,$0C,$C7,$B2 ;; ?QPWZ?               ;
                      .db $0C,$2C,$B4,$B9,$06,$7B,$B7,$B9 ;; ?QPWZ?               ;
                      .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06 ;; ?QPWZ?               ;
                      .db $4B,$AD,$AF,$B0,$B2,$B4,$B5,$30 ;; ?QPWZ?               ;
                      .db $6B,$B4,$0C,$C7,$B7,$0C,$2C,$B9 ;; ?QPWZ?               ;
                      .db $BC,$06,$7B,$BB,$BC,$0C,$69,$BB ;; ?QPWZ?               ;
                      .db $18,$C6,$0C,$C7,$B3,$0C,$2C,$B7 ;; ?QPWZ?               ;
                      .db $BB,$06,$7B,$B9,$BB,$0C,$69,$B9 ;; ?QPWZ?               ;
                      .db $18,$C6,$0C,$C7,$B2,$0C,$2C,$B4 ;; ?QPWZ?               ;
                      .db $B9,$06,$7B,$B7,$B9,$0C,$69,$B7 ;; ?QPWZ?               ;
                      .db $18,$C6,$0C,$C7,$06,$4B,$AD,$AF ;; ?QPWZ?               ;
                      .db $B0,$B2,$B4,$B5,$DA,$12,$DB,$08 ;; ?QPWZ?               ;
                      .db $DE,$14,$1F,$25,$0C,$6D,$B0,$0C ;; ?QPWZ?               ;
                      .db $2E,$B4,$B4,$30,$6E,$B4,$0C,$2D ;; ?QPWZ?               ;
                      .db $B4,$0C,$6E,$B7,$C6,$0C,$2D,$B7 ;; ?QPWZ?               ;
                      .db $30,$6E,$B3,$0C,$2D,$AF,$0C,$6E ;; ?QPWZ?               ;
                      .db $AE,$0C,$2D,$B2,$B2,$30,$6E,$B2 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B2,$0C,$6E,$B4,$C6,$0C ;; ?QPWZ?               ;
                      .db $2D,$B4,$30,$6E,$B4,$0C,$2D,$B4 ;; ?QPWZ?               ;
                      .db $DA,$12,$DB,$0C,$DE,$14,$1B,$26 ;; ?QPWZ?               ;
                      .db $0C,$6D,$AB,$0C,$2E,$B0,$B0,$30 ;; ?QPWZ?               ;
                      .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B3 ;; ?QPWZ?               ;
                      .db $C6,$0C,$2D,$B3,$30,$6E,$AF,$0C ;; ?QPWZ?               ;
                      .db $2D,$AB,$0C,$6E,$AB,$0C,$2E,$AE ;; ?QPWZ?               ;
                      .db $AE,$30,$6E,$AE,$0C,$2D,$AE,$0C ;; ?QPWZ?               ;
                      .db $6E,$B1,$C6,$0C,$2D,$B1,$30,$6E ;; ?QPWZ?               ;
                      .db $B1,$0C,$2D,$B1,$DA,$04,$DB,$08 ;; ?QPWZ?               ;
                      .db $DE,$14,$19,$28,$0C,$3B,$C7,$9C ;; ?QPWZ?               ;
                      .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9B ;; ?QPWZ?               ;
                      .db $C7,$9B,$C7,$9B,$C7,$9B,$C7,$9A ;; ?QPWZ?               ;
                      .db $C7,$9A,$C7,$9A,$C7,$9A,$C7,$99 ;; ?QPWZ?               ;
                      .db $C7,$99,$C7,$99,$C7,$99,$DA,$08 ;; ?QPWZ?               ;
                      .db $DB,$0C,$DE,$14,$19,$28,$0C,$6E ;; ?QPWZ?               ;
                      .db $98,$9F,$93,$9F,$98,$9F,$93,$9F ;; ?QPWZ?               ;
                      .db $97,$9F,$93,$9F,$97,$9F,$93,$9F ;; ?QPWZ?               ;
                      .db $96,$9F,$93,$9F,$96,$9F,$93,$9F ;; ?QPWZ?               ;
                      .db $95,$9C,$90,$9C,$95,$9C,$90,$9C ;; ?QPWZ?               ;
                      .db $DA,$05,$DB,$14,$DE,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $E9,$F3,$17,$08,$0C,$4B,$D1,$0C ;; ?QPWZ?               ;
                      .db $4C,$D2,$0C,$49,$D1,$0C,$4B,$D2 ;; ?QPWZ?               ;
                      .db $00,$0C,$6E,$B9,$0C,$2D,$BB,$BC ;; ?QPWZ?               ;
                      .db $30,$6E,$B9,$0C,$2D,$B8,$0C,$6E ;; ?QPWZ?               ;
                      .db $B7,$0C,$2D,$B8,$B9,$30,$6E,$B4 ;; ?QPWZ?               ;
                      .db $0C,$C7,$12,$6E,$B4,$06,$6D,$B3 ;; ?QPWZ?               ;
                      .db $0C,$2C,$B2,$12,$6E,$B4,$06,$6D ;; ?QPWZ?               ;
                      .db $B3,$0C,$2C,$B2,$0C,$2E,$B4,$B2 ;; ?QPWZ?               ;
                      .db $30,$4E,$B7,$C6,$00,$30,$6D,$B0 ;; ?QPWZ?               ;
                      .db $0C,$C6,$AF,$C6,$AD,$AB,$AC,$AD ;; ?QPWZ?               ;
                      .db $B4,$30,$C6,$24,$B4,$18,$B0,$0C ;; ?QPWZ?               ;
                      .db $AF,$B0,$B1,$30,$B2,$06,$C7,$AB ;; ?QPWZ?               ;
                      .db $AD,$AF,$B0,$B2,$B4,$B5,$06,$7B ;; ?QPWZ?               ;
                      .db $B4,$B5,$0C,$69,$B4,$18,$C6,$0C ;; ?QPWZ?               ;
                      .db $C7,$06,$4B,$AF,$B0,$B2,$B4,$B5 ;; ?QPWZ?               ;
                      .db $B6,$06,$7B,$B7,$B9,$0C,$69,$B7 ;; ?QPWZ?               ;
                      .db $18,$C6,$0C,$C7,$06,$4B,$B2,$B4 ;; ?QPWZ?               ;
                      .db $B5,$B7,$B9,$BB,$30,$BC,$C6,$BB ;; ?QPWZ?               ;
                      .db $0C,$C7,$06,$4B,$BB,$BC,$BB,$B9 ;; ?QPWZ?               ;
                      .db $B7,$B5,$0C,$6E,$B5,$0C,$2D,$B5 ;; ?QPWZ?               ;
                      .db $B9,$30,$6E,$B6,$0C,$2D,$B6,$0C ;; ?QPWZ?               ;
                      .db $6E,$B4,$0C,$2D,$B4,$B4,$30,$6E ;; ?QPWZ?               ;
                      .db $B1,$0C,$C7,$12,$6E,$AD,$06,$6D ;; ?QPWZ?               ;
                      .db $AD,$0C,$2C,$AD,$12,$6E,$AD,$06 ;; ?QPWZ?               ;
                      .db $6D,$AD,$0C,$2C,$AD,$0C,$2E,$AD ;; ?QPWZ?               ;
                      .db $AD,$30,$4E,$B2,$C6,$0C,$6E,$B0 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B0,$B5,$30,$6E,$B0,$0C ;; ?QPWZ?               ;
                      .db $2D,$B0,$0C,$6E,$B0,$0C,$2D,$B0 ;; ?QPWZ?               ;
                      .db $B0,$30,$6E,$AB,$0C,$C7,$12,$6E ;; ?QPWZ?               ;
                      .db $A9,$06,$6D,$A9,$0C,$2C,$A9,$12 ;; ?QPWZ?               ;
                      .db $6E,$A9,$06,$6D,$A9,$0C,$2C,$A9 ;; ?QPWZ?               ;
                      .db $0C,$2E,$A9,$A9,$30,$4E,$AF,$C6 ;; ?QPWZ?               ;
                      .db $0C,$C7,$9D,$C7,$9D,$C7,$9E,$C7 ;; ?QPWZ?               ;
                      .db $9E,$C7,$9C,$C7,$9C,$C7,$99,$C7 ;; ?QPWZ?               ;
                      .db $99,$C7,$9A,$C7,$9A,$C7,$9A,$C7 ;; ?QPWZ?               ;
                      .db $9A,$C7,$97,$C7,$97,$C7,$97,$C7 ;; ?QPWZ?               ;
                      .db $97,$0C,$91,$A1,$98,$A1,$92,$A1 ;; ?QPWZ?               ;
                      .db $98,$A1,$93,$9F,$98,$9F,$95,$9F ;; ?QPWZ?               ;
                      .db $90,$9F,$8E,$9D,$95,$9D,$8E,$9D ;; ?QPWZ?               ;
                      .db $90,$91,$93,$9D,$8E,$9D,$93,$9D ;; ?QPWZ?               ;
                      .db $8E,$9D,$0C,$6E,$B9,$0C,$2D,$BB ;; ?QPWZ?               ;
                      .db $BC,$30,$6E,$B9,$0C,$2D,$B8,$0C ;; ?QPWZ?               ;
                      .db $6E,$B7,$0C,$2D,$B8,$B9,$30,$6E ;; ?QPWZ?               ;
                      .db $C0,$0C,$C7,$0C,$6E,$C0,$0C,$2D ;; ?QPWZ?               ;
                      .db $BF,$C0,$18,$6E,$BC,$0C,$2E,$BC ;; ?QPWZ?               ;
                      .db $18,$6E,$B9,$30,$4E,$BC,$C6,$00 ;; ?QPWZ?               ;
                      .db $06,$7B,$B4,$B5,$0C,$69,$B4,$18 ;; ?QPWZ?               ;
                      .db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2 ;; ?QPWZ?               ;
                      .db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C ;; ?QPWZ?               ;
                      .db $69,$B7,$18,$C6,$0C,$C7,$06,$4B ;; ?QPWZ?               ;
                      .db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC ;; ?QPWZ?               ;
                      .db $BB,$60,$BC,$0C,$6E,$B5,$0C,$2D ;; ?QPWZ?               ;
                      .db $B5,$B9,$30,$6E,$B6,$0C,$2D,$B6 ;; ?QPWZ?               ;
                      .db $0C,$6E,$B4,$0C,$2D,$B4,$B4,$30 ;; ?QPWZ?               ;
                      .db $6E,$BD,$0C,$C7,$0C,$6E,$B9,$0C ;; ?QPWZ?               ;
                      .db $2D,$B9,$B9,$18,$6E,$B9,$0C,$2E ;; ?QPWZ?               ;
                      .db $B5,$18,$6E,$B5,$30,$4E,$B7,$C6 ;; ?QPWZ?               ;
                      .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30 ;; ?QPWZ?               ;
                      .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C ;; ?QPWZ?               ;
                      .db $C7,$0C,$6E,$B5,$0C,$2D,$B5,$B5 ;; ?QPWZ?               ;
                      .db $18,$6E,$B5,$0C,$2E,$B2,$18,$6E ;; ?QPWZ?               ;
                      .db $B2,$30,$4E,$B4,$C6,$0C,$C7,$98 ;; ?QPWZ?               ;
                      .db $C7,$98,$C7,$98,$C7,$98,$C7,$9C ;; ?QPWZ?               ;
                      .db $C7,$9C,$C7,$99,$C7,$99,$C7,$95 ;; ?QPWZ?               ;
                      .db $C7,$95,$C7,$97,$C7,$97,$C7,$9C ;; ?QPWZ?               ;
                      .db $C7,$9C,$C7,$9C,$C7,$9C,$0C,$91 ;; ?QPWZ?               ;
                      .db $9D,$98,$9D,$92,$9E,$98,$9E,$93 ;; ?QPWZ?               ;
                      .db $9F,$9A,$9F,$95,$A1,$9C,$A1,$8E ;; ?QPWZ?               ;
                      .db $9A,$95,$9A,$93,$9F,$9A,$9F,$98 ;; ?QPWZ?               ;
                      .db $9F,$93,$9F,$98,$98,$97,$96,$0C ;; ?QPWZ?               ;
                      .db $6E,$B9,$0C,$2D,$BB,$BC,$30,$6E ;; ?QPWZ?               ;
                      .db $B9,$0C,$2D,$B8,$0C,$6E,$B7,$0C ;; ?QPWZ?               ;
                      .db $2D,$B8,$B9,$30,$6E,$C0,$0C,$C7 ;; ?QPWZ?               ;
                      .db $00,$30,$6D,$B0,$0C,$C6,$AF,$C6 ;; ?QPWZ?               ;
                      .db $AD,$AB,$AC,$AD,$B4,$30,$C6,$0C ;; ?QPWZ?               ;
                      .db $6E,$B5,$0C,$2D,$B5,$B9,$30,$6E ;; ?QPWZ?               ;
                      .db $B6,$0C,$2D,$B6,$0C,$6E,$B4,$0C ;; ?QPWZ?               ;
                      .db $2D,$B4,$B4,$30,$6E,$BD,$0C,$C7 ;; ?QPWZ?               ;
                      .db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30 ;; ?QPWZ?               ;
                      .db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C ;; ?QPWZ?               ;
                      .db $C7,$06,$7B,$B4,$B5,$0C,$69,$B4 ;; ?QPWZ?               ;
                      .db $18,$C6,$0C,$C7,$06,$4B,$AF,$B0 ;; ?QPWZ?               ;
                      .db $B2,$B4,$B5,$B6,$06,$7B,$B7,$B9 ;; ?QPWZ?               ;
                      .db $0C,$69,$B7,$18,$C6,$0C,$C7,$06 ;; ?QPWZ?               ;
                      .db $4B,$B2,$B4,$B5,$B7,$B9,$BB,$0C ;; ?QPWZ?               ;
                      .db $C7,$98,$C7,$98,$C7,$98,$C7,$98 ;; ?QPWZ?               ;
                      .db $C7,$9C,$C7,$9C,$C7,$99,$C7,$99 ;; ?QPWZ?               ;
                      .db $0C,$91,$9D,$98,$9D,$92,$9E,$98 ;; ?QPWZ?               ;
                      .db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C ;; ?QPWZ?               ;
                      .db $A1,$DA,$12,$18,$6D,$AD,$0C,$B4 ;; ?QPWZ?               ;
                      .db $C7,$C7,$0C,$2D,$B4,$0C,$6E,$B3 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B4,$0C,$6E,$B5,$0C,$2D ;; ?QPWZ?               ;
                      .db $B4,$B1,$30,$6E,$AD,$0C,$2D,$AD ;; ?QPWZ?               ;
                      .db $0C,$6E,$B4,$0C,$2D,$B2,$0C,$6D ;; ?QPWZ?               ;
                      .db $B4,$0C,$2D,$B2,$0C,$6E,$B4,$0C ;; ?QPWZ?               ;
                      .db $2D,$B2,$C7,$0C,$6D,$AD,$30,$C6 ;; ?QPWZ?               ;
                      .db $C7,$00,$DB,$0F,$DE,$14,$14,$20 ;; ?QPWZ?               ;
                      .db $DA,$12,$18,$6D,$B9,$0C,$C0,$C7 ;; ?QPWZ?               ;
                      .db $C7,$0C,$2D,$C0,$0C,$6E,$BF,$0C ;; ?QPWZ?               ;
                      .db $2D,$C0,$0C,$6E,$C1,$0C,$2D,$C0 ;; ?QPWZ?               ;
                      .db $BD,$30,$6E,$B9,$0C,$2D,$B9,$0C ;; ?QPWZ?               ;
                      .db $6E,$C0,$0C,$2D,$BE,$0C,$6D,$C0 ;; ?QPWZ?               ;
                      .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D ;; ?QPWZ?               ;
                      .db $BE,$C7,$0C,$6D,$B9,$30,$C6,$C7 ;; ?QPWZ?               ;
                      .db $DA,$12,$18,$6D,$A8,$0C,$AB,$C7 ;; ?QPWZ?               ;
                      .db $C7,$0C,$2D,$AB,$0C,$6E,$AA,$0C ;; ?QPWZ?               ;
                      .db $2D,$AB,$0C,$6E,$AD,$0C,$2D,$AB ;; ?QPWZ?               ;
                      .db $A8,$30,$6E,$A5,$0C,$2D,$A5,$0C ;; ?QPWZ?               ;
                      .db $6E,$AB,$0C,$2D,$AA,$0C,$6D,$AB ;; ?QPWZ?               ;
                      .db $0C,$2D,$AA,$0C,$6E,$AB,$0C,$2D ;; ?QPWZ?               ;
                      .db $AA,$C7,$0C,$6D,$A4,$30,$C6,$C7 ;; ?QPWZ?               ;
                      .db $DB,$05,$DE,$19,$19,$35,$DA,$00 ;; ?QPWZ?               ;
                      .db $30,$6B,$A8,$0C,$C6,$A7,$A8,$AD ;; ?QPWZ?               ;
                      .db $48,$B4,$0C,$B3,$B4,$30,$B9,$B4 ;; ?QPWZ?               ;
                      .db $60,$B2,$DB,$08,$DE,$19,$18,$34 ;; ?QPWZ?               ;
                      .db $DA,$00,$30,$6B,$9F,$0C,$C6,$9E ;; ?QPWZ?               ;
                      .db $9F,$A5,$48,$AB,$0C,$AA,$AB,$30 ;; ?QPWZ?               ;
                      .db $B4,$AB,$60,$AA,$0C,$C7,$99,$C7 ;; ?QPWZ?               ;
                      .db $99,$C7,$99,$C7,$99,$C7,$99,$C7 ;; ?QPWZ?               ;
                      .db $99,$C7,$99,$C7,$99,$C7,$98,$C7 ;; ?QPWZ?               ;
                      .db $98,$C7,$98,$C7,$98,$C7,$98,$C7 ;; ?QPWZ?               ;
                      .db $98,$C7,$98,$C7,$98,$0C,$95,$9F ;; ?QPWZ?               ;
                      .db $90,$9F,$95,$9F,$90,$9F,$95,$9F ;; ?QPWZ?               ;
                      .db $90,$9F,$95,$9F,$90,$8F,$8E,$9E ;; ?QPWZ?               ;
                      .db $95,$9E,$8E,$9E,$95,$9E,$8E,$9E ;; ?QPWZ?               ;
                      .db $95,$9E,$8E,$9E,$90,$92,$18,$6D ;; ?QPWZ?               ;
                      .db $AB,$0C,$B2,$C7,$C7,$0C,$2D,$B2 ;; ?QPWZ?               ;
                      .db $0C,$6E,$B1,$0C,$2D,$B2,$0C,$6E ;; ?QPWZ?               ;
                      .db $B4,$0C,$2D,$B2,$AF,$30,$6E,$AB ;; ?QPWZ?               ;
                      .db $0C,$2D,$B2,$18,$4E,$B0,$B0,$10 ;; ?QPWZ?               ;
                      .db $6D,$B0,$10,$6E,$B2,$10,$6E,$B3 ;; ?QPWZ?               ;
                      .db $30,$B4,$C7,$00,$18,$6D,$A3,$0C ;; ?QPWZ?               ;
                      .db $A9,$C7,$C7,$0C,$2D,$A9,$0C,$6E ;; ?QPWZ?               ;
                      .db $A8,$0C,$2D,$A9,$0C,$6E,$AB,$0C ;; ?QPWZ?               ;
                      .db $2D,$A9,$A6,$30,$6E,$A3,$0C,$2D ;; ?QPWZ?               ;
                      .db $A9,$18,$4E,$A8,$A8,$10,$6D,$A8 ;; ?QPWZ?               ;
                      .db $10,$6E,$A9,$10,$6E,$AA,$30,$AC ;; ?QPWZ?               ;
                      .db $C7,$30,$69,$AB,$0C,$C6,$A9,$AB ;; ?QPWZ?               ;
                      .db $AF,$48,$B2,$0C,$B0,$B2,$48,$B0 ;; ?QPWZ?               ;
                      .db $18,$B2,$60,$B4,$30,$69,$A3,$0C ;; ?QPWZ?               ;
                      .db $C6,$A3,$A6,$A9,$48,$AB,$0C,$A9 ;; ?QPWZ?               ;
                      .db $AB,$48,$A8,$18,$AB,$60,$AC,$0C ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$97,$C7,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$97,$C7,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9C ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$97,$C7,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E ;; ?QPWZ?               ;
                      .db $9D,$93,$9D,$8E,$9D,$93,$9D,$95 ;; ?QPWZ?               ;
                      .db $97,$98,$9F,$93,$9F,$98,$9F,$93 ;; ?QPWZ?               ;
                      .db $9F,$90,$A0,$97,$A0,$90,$A0,$92 ;; ?QPWZ?               ;
                      .db $94,$18,$6D,$AB,$0C,$B2,$C7,$C7 ;; ?QPWZ?               ;
                      .db $0C,$2D,$B2,$0C,$6E,$B1,$0C,$2D ;; ?QPWZ?               ;
                      .db $B2,$0C,$6E,$B4,$0C,$2D,$B2,$C7 ;; ?QPWZ?               ;
                      .db $30,$6E,$AB,$0C,$2D,$B2,$18,$4E ;; ?QPWZ?               ;
                      .db $B0,$B0,$10,$6D,$B0,$10,$6E,$B2 ;; ?QPWZ?               ;
                      .db $10,$6E,$B3,$18,$2E,$B4,$C7,$30 ;; ?QPWZ?               ;
                      .db $4E,$B7,$00,$18,$6D,$B7,$0C,$BE ;; ?QPWZ?               ;
                      .db $C7,$C7,$0C,$2D,$BE,$0C,$6E,$BD ;; ?QPWZ?               ;
                      .db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D ;; ?QPWZ?               ;
                      .db $BE,$C7,$30,$6E,$B7,$0C,$2D,$BE ;; ?QPWZ?               ;
                      .db $18,$4E,$BC,$BC,$10,$6D,$BC,$10 ;; ?QPWZ?               ;
                      .db $6E,$BE,$10,$6E,$BF,$18,$2E,$C0 ;; ?QPWZ?               ;
                      .db $C7,$06,$C7,$AB,$AD,$AF,$B0,$B2 ;; ?QPWZ?               ;
                      .db $B4,$B5,$18,$6D,$A3,$0C,$A9,$C7 ;; ?QPWZ?               ;
                      .db $C7,$0C,$2D,$A9,$0C,$6E,$A8,$0C ;; ?QPWZ?               ;
                      .db $2D,$A9,$0C,$6E,$AB,$0C,$2D,$A9 ;; ?QPWZ?               ;
                      .db $C7,$30,$6E,$A3,$0C,$2D,$A9,$18 ;; ?QPWZ?               ;
                      .db $4E,$A8,$A8,$10,$6D,$A8,$10,$6E ;; ?QPWZ?               ;
                      .db $A9,$10,$6E,$AA,$18,$2E,$AB,$C7 ;; ?QPWZ?               ;
                      .db $30,$4E,$AF,$30,$69,$AB,$0C,$C6 ;; ?QPWZ?               ;
                      .db $A9,$AB,$AF,$48,$B2,$0C,$B0,$B2 ;; ?QPWZ?               ;
                      .db $30,$B0,$B2,$30,$B4,$B3,$30,$69 ;; ?QPWZ?               ;
                      .db $A3,$0C,$C6,$A3,$A6,$A9,$48,$AB ;; ?QPWZ?               ;
                      .db $0C,$A9,$AB,$30,$A8,$AB,$30,$AB ;; ?QPWZ?               ;
                      .db $AF,$0C,$C7,$97,$C7,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$97,$C7,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$9C,$C7,$9C,$C7,$9C ;; ?QPWZ?               ;
                      .db $C7,$9C,$DA,$01,$18,$AF,$C7,$A7 ;; ?QPWZ?               ;
                      .db $C6,$0C,$93,$9D,$8E,$9D,$93,$9D ;; ?QPWZ?               ;
                      .db $8E,$9D,$93,$9D,$8E,$9D,$93,$9D ;; ?QPWZ?               ;
                      .db $95,$97,$98,$9F,$93,$9F,$98,$9F ;; ?QPWZ?               ;
                      .db $93,$9F,$18,$8C,$C7,$93,$C6,$DA ;; ?QPWZ?               ;
                      .db $05,$DB,$14,$DE,$00,$00,$00,$E9 ;; ?QPWZ?               ;
                      .db $F3,$17,$06,$18,$4C,$D1,$C7,$30 ;; ?QPWZ?               ;
                      .db $6D,$D2,$DA,$04,$DB,$0A,$DE,$22 ;; ?QPWZ?               ;
                      .db $19,$38,$60,$5E,$BC,$C6,$DA,$01 ;; ?QPWZ?               ;
                      .db $60,$C6,$C6,$C6,$00,$DA,$04,$DB ;; ?QPWZ?               ;
                      .db $08,$DE,$20,$18,$36,$60,$5D,$B4 ;; ?QPWZ?               ;
                      .db $C6,$DA,$01,$60,$C6,$C6,$C6,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0C,$DE,$21,$1A,$37,$60 ;; ?QPWZ?               ;
                      .db $5D,$AB,$C6,$DA,$01,$60,$C6,$C6 ;; ?QPWZ?               ;
                      .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18 ;; ?QPWZ?               ;
                      .db $36,$60,$5D,$A4,$C6,$DA,$01,$60 ;; ?QPWZ?               ;
                      .db $C6,$C6,$C6,$DA,$04,$DB,$0F,$10 ;; ?QPWZ?               ;
                      .db $5D,$B0,$C7,$B0,$AE,$C7,$AE,$AD ;; ?QPWZ?               ;
                      .db $C7,$AD,$AC,$C7,$AC,$30,$AB,$24 ;; ?QPWZ?               ;
                      .db $A7,$6C,$A6,$60,$C6,$DA,$04,$DB ;; ?QPWZ?               ;
                      .db $0F,$10,$5D,$AB,$C7,$AB,$A8,$C7 ;; ?QPWZ?               ;
                      .db $A8,$A9,$C7,$A9,$A9,$C7,$A9,$30 ;; ?QPWZ?               ;
                      .db $A6,$24,$A3,$6C,$A2,$60,$C6,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0F,$10,$5D,$A8,$C7,$A8 ;; ?QPWZ?               ;
                      .db $A4,$C7,$A4,$A4,$C7,$A4,$A4,$C7 ;; ?QPWZ?               ;
                      .db $A4,$30,$A3,$24,$9D,$6C,$9C,$60 ;; ?QPWZ?               ;
                      .db $C6,$DA,$08,$DB,$0A,$DE,$22,$19 ;; ?QPWZ?               ;
                      .db $38,$10,$5D,$8C,$8C,$8C,$90,$90 ;; ?QPWZ?               ;
                      .db $90,$91,$91,$91,$92,$92,$92,$30 ;; ?QPWZ?               ;
                      .db $93,$24,$93,$6C,$8C,$60,$C6,$DA ;; ?QPWZ?               ;
                      .db $01,$E2,$12,$DB,$0A,$DE,$14,$19 ;; ?QPWZ?               ;
                      .db $28,$18,$7C,$A7,$0C,$A8,$AB,$AD ;; ?QPWZ?               ;
                      .db $30,$AB,$0C,$AD,$AF,$C6,$AF,$30 ;; ?QPWZ?               ;
                      .db $AD,$0C,$A7,$A8,$AB,$AD,$30,$AB ;; ?QPWZ?               ;
                      .db $0C,$AC,$AD,$C6,$AD,$60,$AB,$60 ;; ?QPWZ?               ;
                      .db $77,$C6,$00,$DA,$02,$DB,$0A,$18 ;; ?QPWZ?               ;
                      .db $79,$A7,$0C,$A8,$AB,$AD,$30,$AB ;; ?QPWZ?               ;
                      .db $0C,$AD,$AF,$C6,$AF,$30,$AD,$0C ;; ?QPWZ?               ;
                      .db $A7,$A8,$AB,$AD,$30,$AB,$0C,$AC ;; ?QPWZ?               ;
                      .db $AD,$C6,$AD,$60,$AB,$C6,$DA,$01 ;; ?QPWZ?               ;
                      .db $DB,$0C,$DE,$14,$19,$28,$06,$C6 ;; ?QPWZ?               ;
                      .db $18,$79,$A7,$0C,$A8,$AB,$AD,$30 ;; ?QPWZ?               ;
                      .db $AB,$0C,$AD,$AF,$C6,$AF,$30,$AD ;; ?QPWZ?               ;
                      .db $0C,$A7,$A8,$AB,$AD,$30,$AB,$0C ;; ?QPWZ?               ;
                      .db $AC,$AD,$C6,$AD,$60,$AB,$60,$75 ;; ?QPWZ?               ;
                      .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19 ;; ?QPWZ?               ;
                      .db $28,$18,$7B,$C7,$60,$98,$97,$96 ;; ?QPWZ?               ;
                      .db $95,$C6,$C6,$C6,$DA,$01,$DB,$0A ;; ?QPWZ?               ;
                      .db $DE,$14,$19,$28,$18,$7B,$C7,$0C ;; ?QPWZ?               ;
                      .db $C7,$24,$9F,$30,$B0,$0C,$C7,$24 ;; ?QPWZ?               ;
                      .db $9F,$30,$AF,$0C,$C7,$24,$9F,$30 ;; ?QPWZ?               ;
                      .db $AE,$0C,$C7,$24,$9F,$30,$B1,$60 ;; ?QPWZ?               ;
                      .db $C6,$C6,$C6,$DA,$01,$DB,$0A,$DE ;; ?QPWZ?               ;
                      .db $14,$19,$28,$18,$7B,$C7,$18,$C7 ;; ?QPWZ?               ;
                      .db $48,$A8,$18,$C7,$48,$A7,$18,$C7 ;; ?QPWZ?               ;
                      .db $48,$A6,$18,$C7,$48,$A5,$60,$C6 ;; ?QPWZ?               ;
                      .db $C6,$C6,$DA,$01,$DB,$0A,$DE,$14 ;; ?QPWZ?               ;
                      .db $19,$28,$18,$7B,$C7,$24,$C7,$3C ;; ?QPWZ?               ;
                      .db $AB,$24,$C7,$3C,$AB,$24,$C7,$3C ;; ?QPWZ?               ;
                      .db $AB,$24,$C7,$3C,$AB,$60,$C6,$C6 ;; ?QPWZ?               ;
                      .db $C6,$DA,$01,$DB,$0A,$DE,$14,$19 ;; ?QPWZ?               ;
                      .db $28,$18,$7B,$C7,$30,$C7,$B4,$30 ;; ?QPWZ?               ;
                      .db $C7,$B3,$30,$C7,$B2,$30,$C7,$B4 ;; ?QPWZ?               ;
                      .db $60,$C6,$C6,$C6,$DA,$04,$DB,$08 ;; ?QPWZ?               ;
                      .db $DE,$22,$18,$14,$08,$5C,$C7,$A9 ;; ?QPWZ?               ;
                      .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24 ;; ?QPWZ?               ;
                      .db $AB,$0C,$C7,$08,$C7,$E2,$1C,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0A,$DE,$22,$18,$14,$08 ;; ?QPWZ?               ;
                      .db $5D,$AC,$AD,$C7,$AF,$B0,$C7,$24 ;; ?QPWZ?               ;
                      .db $AD,$0C,$C7,$08,$AC,$AB,$C7,$AC ;; ?QPWZ?               ;
                      .db $AD,$C7,$24,$B4,$0C,$C7,$08,$C7 ;; ?QPWZ?               ;
                      .db $00,$DA,$04,$DB,$0C,$DE,$22,$18 ;; ?QPWZ?               ;
                      .db $14,$08,$5C,$C7,$A4,$C7,$A4,$A9 ;; ?QPWZ?               ;
                      .db $C7,$24,$A4,$0C,$C7,$08,$A4,$A4 ;; ?QPWZ?               ;
                      .db $C7,$A4,$A4,$C7,$24,$A5,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$C7,$DA,$06,$DB,$0A,$DE,$22 ;; ?QPWZ?               ;
                      .db $18,$14,$08,$5D,$B8,$B9,$C7,$BB ;; ?QPWZ?               ;
                      .db $BC,$C7,$24,$B9,$0C,$C7,$08,$B8 ;; ?QPWZ?               ;
                      .db $B7,$C7,$B8,$B9,$C7,$24,$C0,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$C7,$DA,$0D,$DB,$0F,$DE ;; ?QPWZ?               ;
                      .db $22,$18,$14,$01,$C7,$08,$C7,$18 ;; ?QPWZ?               ;
                      .db $4E,$C7,$9D,$C7,$9E,$C7,$9F,$C7 ;; ?QPWZ?               ;
                      .db $9F,$18,$9E,$08,$C7,$C7,$9D,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$C7,$C7,$AB,$DA,$0D,$DB ;; ?QPWZ?               ;
                      .db $0F,$DE,$22,$18,$14,$08,$C7,$18 ;; ?QPWZ?               ;
                      .db $4E,$C7,$98,$C7,$98,$C7,$9A,$C7 ;; ?QPWZ?               ;
                      .db $99,$18,$A1,$08,$C7,$C7,$A3,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$C7,$C7,$A4,$DA,$08,$DB ;; ?QPWZ?               ;
                      .db $0A,$DE,$22,$18,$14,$08,$C7,$18 ;; ?QPWZ?               ;
                      .db $5F,$91,$08,$C7,$C7,$91,$18,$92 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$92,$18,$93,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$93,$18,$95,$08,$95,$90,$8F ;; ?QPWZ?               ;
                      .db $18,$8E,$08,$C6,$C7,$93,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$98,$DA,$04,$DB,$14 ;; ?QPWZ?               ;
                      .db $08,$C7,$18,$6C,$D1,$08,$D2,$C7 ;; ?QPWZ?               ;
                      .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18 ;; ?QPWZ?               ;
                      .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1 ;; ?QPWZ?               ;
                      .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7 ;; ?QPWZ?               ;
                      .db $D2,$18,$C6,$08,$C7,$C7,$D2,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0A,$DE,$22,$19,$38,$18 ;; ?QPWZ?               ;
                      .db $4D,$B4,$08,$C7,$C7,$B4,$E3,$60 ;; ?QPWZ?               ;
                      .db $18,$18,$B4,$08,$C7,$C7,$B7,$18 ;; ?QPWZ?               ;
                      .db $B7,$08,$C7,$C7,$B7,$18,$B7,$C7 ;; ?QPWZ?               ;
                      .db $00,$DA,$04,$DB,$08,$DE,$20,$18 ;; ?QPWZ?               ;
                      .db $36,$18,$4D,$A4,$08,$C7,$C7,$A4 ;; ?QPWZ?               ;
                      .db $18,$A4,$08,$C7,$C7,$A7,$18,$A7 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$A7,$18,$A7,$C7,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0C,$DE,$21,$1A,$37,$18 ;; ?QPWZ?               ;
                      .db $4D,$AD,$08,$C7,$C7,$AD,$18,$AD ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$AF,$18,$AF,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$AF,$18,$AF,$C7,$DA,$04,$DB ;; ?QPWZ?               ;
                      .db $0A,$DE,$22,$18,$36,$18,$4D,$A9 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$A9,$18,$A9,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$AB,$18,$AB,$08,$C7,$C7,$AB ;; ?QPWZ?               ;
                      .db $18,$AB,$C7,$DA,$04,$DB,$0F,$08 ;; ?QPWZ?               ;
                      .db $4D,$C7,$C7,$9A,$18,$9A,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9F ;; ?QPWZ?               ;
                      .db $18,$9F,$18,$C7,$18,$7D,$9F,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$0F,$08,$4C,$C7,$C7,$8E ;; ?QPWZ?               ;
                      .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$93,$18,$93,$18,$C7 ;; ?QPWZ?               ;
                      .db $18,$7E,$93,$DA,$08,$DB,$0A,$DE ;; ?QPWZ?               ;
                      .db $22,$19,$38,$08,$5F,$C7,$C7,$8E ;; ?QPWZ?               ;
                      .db $18,$8E,$08,$C7,$C7,$8E,$18,$8E ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$93,$18,$93,$18,$C7 ;; ?QPWZ?               ;
                      .db $18,$7F,$93,$DA,$00,$DB,$0A,$08 ;; ?QPWZ?               ;
                      .db $6C,$C7,$C7,$D0,$18,$D0,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$D0,$18,$D0,$08,$C7,$C7,$D0 ;; ?QPWZ?               ;
                      .db $18,$D0,$18,$C7,$D0,$24,$C7,$00 ;; ?QPWZ?               ;
                      .db $DA,$04,$E2,$16,$E3,$90,$1C,$DB ;; ?QPWZ?               ;
                      .db $0A,$DE,$22,$19,$38,$18,$4C,$B4 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$B4,$18,$B4,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$B7,$18,$B7,$08,$C7,$C7,$B7 ;; ?QPWZ?               ;
                      .db $18,$B7,$C7,$00,$DA,$04,$DB,$08 ;; ?QPWZ?               ;
                      .db $DE,$20,$18,$36,$18,$4C,$A4,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$A4,$18,$A4,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $A7,$18,$A7,$08,$C7,$C7,$A7,$18 ;; ?QPWZ?               ;
                      .db $A7,$C7,$DA,$04,$DB,$0C,$DE,$21 ;; ?QPWZ?               ;
                      .db $1A,$37,$18,$4C,$AD,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $AD,$18,$AD,$08,$C7,$C7,$AF,$18 ;; ?QPWZ?               ;
                      .db $AF,$08,$C7,$C7,$AF,$18,$AF,$C7 ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$0A,$DE,$22,$18,$36 ;; ?QPWZ?               ;
                      .db $18,$4C,$A9,$08,$C7,$C7,$A9,$18 ;; ?QPWZ?               ;
                      .db $A9,$08,$C7,$C7,$AB,$18,$AB,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$AB,$18,$AB,$C7,$DA,$04 ;; ?QPWZ?               ;
                      .db $DB,$0F,$08,$4C,$C7,$C7,$9A,$18 ;; ?QPWZ?               ;
                      .db $9A,$08,$C7,$C7,$9A,$18,$9A,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$9F,$18,$9F,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $C7,$18,$7D,$9F,$DA,$04,$DB,$0F ;; ?QPWZ?               ;
                      .db $08,$4B,$C7,$C7,$8E,$18,$8E,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $93,$18,$93,$08,$C7,$C7,$C7,$18 ;; ?QPWZ?               ;
                      .db $7E,$93,$DA,$08,$DB,$0A,$DE,$22 ;; ?QPWZ?               ;
                      .db $19,$38,$08,$5E,$C7,$C7,$8E,$18 ;; ?QPWZ?               ;
                      .db $8E,$08,$C7,$C7,$8E,$18,$8E,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$93,$18,$93,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $C7,$18,$7F,$93,$DA,$00,$DB,$0A ;; ?QPWZ?               ;
                      .db $08,$6B,$C7,$C7,$D0,$18,$D0,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$D0,$18,$D0,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $D0,$18,$D0,$C7,$08,$D0,$DB,$14 ;; ?QPWZ?               ;
                      .db $08,$D1,$D1,$DA,$00,$DB,$0A,$DE ;; ?QPWZ?               ;
                      .db $22,$19,$38,$08,$5D,$A8,$C7,$AB ;; ?QPWZ?               ;
                      .db $AD,$C7,$24,$AB,$0C,$C7,$08,$AD ;; ?QPWZ?               ;
                      .db $AF,$C7,$B0,$AF,$AE,$24,$AD,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$A7,$A8,$C7,$AB,$AD,$C7 ;; ?QPWZ?               ;
                      .db $24,$AB,$0C,$C7,$08,$AC,$AD,$C7 ;; ?QPWZ?               ;
                      .db $AE,$AD,$AC,$24,$AB,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $AC,$00,$DA,$06,$DB,$0A,$DE,$22 ;; ?QPWZ?               ;
                      .db $19,$38,$08,$5D,$A8,$C7,$AB,$AD ;; ?QPWZ?               ;
                      .db $C7,$24,$AB,$0C,$C7,$08,$AD,$AF ;; ?QPWZ?               ;
                      .db $C7,$B0,$AF,$AE,$24,$AD,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$A7,$A8,$C7,$AB,$AD,$C7,$24 ;; ?QPWZ?               ;
                      .db $AB,$0C,$C7,$08,$AC,$AD,$C7,$AE ;; ?QPWZ?               ;
                      .db $AD,$AC,$24,$AB,$0C,$C7,$08,$AC ;; ?QPWZ?               ;
                      .db $00,$DA,$12,$DB,$05,$DE,$22,$19 ;; ?QPWZ?               ;
                      .db $28,$60,$6B,$B4,$30,$B3,$08,$C6 ;; ?QPWZ?               ;
                      .db $C6,$B3,$BB,$C6,$B9,$48,$B7,$18 ;; ?QPWZ?               ;
                      .db $B2,$60,$B1,$DA,$06,$DB,$08,$DE ;; ?QPWZ?               ;
                      .db $14,$1F,$30,$08,$6B,$A4,$C7,$A4 ;; ?QPWZ?               ;
                      .db $A8,$C7,$24,$A4,$0C,$C7,$08,$A8 ;; ?QPWZ?               ;
                      .db $AB,$C7,$AB,$A7,$A7,$24,$A7,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$A3,$A2,$C7,$A6,$A6,$C7 ;; ?QPWZ?               ;
                      .db $24,$A6,$0C,$C7,$08,$A6,$A8,$C7 ;; ?QPWZ?               ;
                      .db $AB,$A8,$A8,$24,$A8,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $A8,$08,$6D,$A4,$C7,$A4,$A8,$C7 ;; ?QPWZ?               ;
                      .db $24,$A4,$0C,$C7,$08,$A8,$AB,$C7 ;; ?QPWZ?               ;
                      .db $AB,$A7,$A7,$24,$A7,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $A3,$A2,$C7,$A6,$A6,$C7,$24,$A6 ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$A6,$A8,$C7,$AB,$A8 ;; ?QPWZ?               ;
                      .db $A8,$24,$A8,$0C,$C7,$08,$A8,$DA ;; ?QPWZ?               ;
                      .db $06,$DB,$0C,$DE,$14,$1F,$30,$08 ;; ?QPWZ?               ;
                      .db $6D,$9F,$C7,$A8,$A4,$C7,$24,$A8 ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$A4,$A7,$C7,$A7,$AB ;; ?QPWZ?               ;
                      .db $AB,$24,$A3,$0C,$C7,$08,$9F,$9F ;; ?QPWZ?               ;
                      .db $C7,$A2,$A2,$C7,$24,$A2,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$A2,$A5,$C7,$A8,$A5,$A5,$24 ;; ?QPWZ?               ;
                      .db $A5,$0C,$C7,$08,$A5,$DA,$0D,$DB ;; ?QPWZ?               ;
                      .db $0F,$01,$C7,$18,$4E,$C7,$9F,$C7 ;; ?QPWZ?               ;
                      .db $9F,$C7,$9F,$C7,$9F,$C7,$9F,$C7 ;; ?QPWZ?               ;
                      .db $9F,$C7,$9F,$C7,$9F,$DA,$0D,$DB ;; ?QPWZ?               ;
                      .db $0F,$18,$4E,$C7,$9C,$C7,$9C,$C7 ;; ?QPWZ?               ;
                      .db $9B,$C7,$9B,$C7,$9A,$C7,$9A,$C7 ;; ?QPWZ?               ;
                      .db $99,$C7,$99,$DA,$08,$DB,$0A,$DE ;; ?QPWZ?               ;
                      .db $14,$1F,$30,$18,$6F,$98,$C7,$18 ;; ?QPWZ?               ;
                      .db $93,$08,$C7,$C7,$93,$18,$97,$C7 ;; ?QPWZ?               ;
                      .db $18,$93,$08,$C7,$C7,$93,$18,$96 ;; ?QPWZ?               ;
                      .db $C7,$18,$93,$08,$C7,$C7,$93,$18 ;; ?QPWZ?               ;
                      .db $95,$C7,$18,$90,$08,$C7,$C7,$90 ;; ?QPWZ?               ;
                      .db $DA,$00,$DB,$14,$18,$6B,$D1,$08 ;; ?QPWZ?               ;
                      .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7 ;; ?QPWZ?               ;
                      .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D2,$D1,$D1,$18,$D1,$08 ;; ?QPWZ?               ;
                      .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7 ;; ?QPWZ?               ;
                      .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D2,$D1,$D1,$08,$AD,$C7 ;; ?QPWZ?               ;
                      .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$A8 ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$C7,$A8,$C7,$A4,$A1 ;; ?QPWZ?               ;
                      .db $C7,$A8,$A4,$C7,$A1,$A4,$C7,$AB ;; ?QPWZ?               ;
                      .db $30,$C6,$C7,$00,$01,$C7,$18,$C7 ;; ?QPWZ?               ;
                      .db $9D,$C7,$9E,$C7,$9F,$C7,$9F,$18 ;; ?QPWZ?               ;
                      .db $9E,$08,$C7,$C7,$9E,$18,$C6,$08 ;; ?QPWZ?               ;
                      .db $9E,$C7,$9F,$18,$C6,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $A3,$A4,$C7,$A4,$A6,$C7,$A6,$18 ;; ?QPWZ?               ;
                      .db $C7,$98,$C7,$98,$C7,$9A,$C7,$99 ;; ?QPWZ?               ;
                      .db $18,$A1,$08,$C7,$C7,$A1,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$A1,$C7,$A3,$18,$C6,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$9A,$9C,$C7,$9C,$9D,$C7,$9D ;; ?QPWZ?               ;
                      .db $18,$91,$08,$C7,$C7,$91,$18,$92 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$92,$18,$93,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$93,$18,$95,$08,$95,$90,$8F ;; ?QPWZ?               ;
                      .db $18,$8E,$08,$C6,$C7,$8E,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$8E,$C7,$93,$18,$C6,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$93,$95,$C7,$95,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1 ;; ?QPWZ?               ;
                      .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1 ;; ?QPWZ?               ;
                      .db $18,$D2,$08,$C6,$C7,$D2,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$D2,$C7,$D2,$18,$C6,$08,$C6 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D2,$C7,$D1,$D2,$D1,$D1 ;; ?QPWZ?               ;
                      .db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8 ;; ?QPWZ?               ;
                      .db $C7,$24,$AB,$0C,$C7,$08,$C7,$AD ;; ?QPWZ?               ;
                      .db $C7,$AD,$AD,$C7,$A9,$C7,$C7,$A9 ;; ?QPWZ?               ;
                      .db $A9,$C7,$A8,$30,$C6,$C7,$08,$AD ;; ?QPWZ?               ;
                      .db $C7,$AF,$B0,$C7,$24,$AD,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$AC,$AB,$C7,$AC,$AD,$C7,$24 ;; ?QPWZ?               ;
                      .db $B4,$0C,$C7,$08,$C7,$B4,$C7,$B3 ;; ?QPWZ?               ;
                      .db $B4,$C7,$B0,$C7,$C7,$B0,$AD,$C7 ;; ?QPWZ?               ;
                      .db $B0,$30,$C6,$C7,$00,$48,$B0,$08 ;; ?QPWZ?               ;
                      .db $AD,$C6,$B0,$48,$B4,$08,$B3,$C6 ;; ?QPWZ?               ;
                      .db $B4,$30,$B9,$30,$B4,$60,$B0,$01 ;; ?QPWZ?               ;
                      .db $C7,$18,$C7,$9D,$C7,$9E,$C7,$9F ;; ?QPWZ?               ;
                      .db $C7,$9F,$18,$9E,$08,$C7,$C7,$9D ;; ?QPWZ?               ;
                      .db $18,$C6,$08,$C7,$C7,$AB,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$B0,$C7,$B0,$AF,$C7,$AF,$AE ;; ?QPWZ?               ;
                      .db $C7,$AE,$18,$C7,$98,$C7,$98,$C7 ;; ?QPWZ?               ;
                      .db $9A,$C7,$99,$18,$A1,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $A3,$18,$C6,$08,$C7,$C7,$A4,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$A8,$C7,$A8,$A7,$C7,$A7 ;; ?QPWZ?               ;
                      .db $A6,$C7,$A6,$18,$91,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $91,$18,$92,$08,$C7,$C7,$92,$18 ;; ?QPWZ?               ;
                      .db $93,$08,$C7,$C7,$93,$18,$95,$08 ;; ?QPWZ?               ;
                      .db $95,$90,$8F,$18,$8E,$08,$C6,$C7 ;; ?QPWZ?               ;
                      .db $93,$18,$C6,$08,$C7,$C7,$98,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$98,$C7,$98,$97,$C7,$97 ;; ?QPWZ?               ;
                      .db $96,$C7,$96,$18,$D1,$08,$D2,$C7 ;; ?QPWZ?               ;
                      .db $D1,$18,$D1,$08,$D2,$C7,$D1,$18 ;; ?QPWZ?               ;
                      .db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1 ;; ?QPWZ?               ;
                      .db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7 ;; ?QPWZ?               ;
                      .db $D2,$18,$C6,$08,$C7,$C7,$D2,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$D2,$C7,$D1,$D2,$C7,$D1 ;; ?QPWZ?               ;
                      .db $D2,$C7,$D1,$DA,$04,$18,$6C,$AD ;; ?QPWZ?               ;
                      .db $B4,$08,$B4,$C7,$B4,$B3,$C7,$B4 ;; ?QPWZ?               ;
                      .db $B5,$C6,$B4,$B1,$C7,$24,$AD,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$AD,$B4,$C6,$B2,$B4,$C6 ;; ?QPWZ?               ;
                      .db $B2,$B4,$C6,$B2,$B0,$C7,$AD,$30 ;; ?QPWZ?               ;
                      .db $C6,$C7,$00,$DA,$04,$18,$6B,$A8 ;; ?QPWZ?               ;
                      .db $AB,$08,$AB,$C7,$AB,$AA,$C7,$AB ;; ?QPWZ?               ;
                      .db $AD,$C6,$AB,$A8,$C7,$24,$A5,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$A5,$AB,$C6,$AA,$AB,$C6 ;; ?QPWZ?               ;
                      .db $AA,$AB,$C6,$AA,$A8,$C7,$A4,$30 ;; ?QPWZ?               ;
                      .db $C6,$C7,$18,$C7,$08,$AD,$C6,$AC ;; ?QPWZ?               ;
                      .db $AD,$C6,$B4,$C6,$C6,$AD,$AD,$C6 ;; ?QPWZ?               ;
                      .db $AC,$AD,$C6,$B4,$C6,$C6,$AD,$AF ;; ?QPWZ?               ;
                      .db $C6,$B1,$18,$C7,$08,$AD,$C6,$AC ;; ?QPWZ?               ;
                      .db $AD,$C6,$B2,$C6,$C6,$AD,$AD,$C6 ;; ?QPWZ?               ;
                      .db $AC,$AD,$C6,$B2,$30,$C6,$01,$C7 ;; ?QPWZ?               ;
                      .db $18,$C7,$9F,$C7,$9F,$C7,$9F,$C7 ;; ?QPWZ?               ;
                      .db $9F,$C7,$9E,$C7,$9E,$C7,$9E,$C7 ;; ?QPWZ?               ;
                      .db $9E,$18,$C7,$99,$C7,$99,$C7,$99 ;; ?QPWZ?               ;
                      .db $C7,$99,$C7,$98,$C7,$98,$C7,$98 ;; ?QPWZ?               ;
                      .db $C7,$98,$18,$95,$08,$C7,$C7,$95 ;; ?QPWZ?               ;
                      .db $18,$90,$08,$C7,$C7,$90,$18,$95 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$95,$18,$95,$08,$95 ;; ?QPWZ?               ;
                      .db $90,$8F,$18,$8E,$08,$C7,$C7,$8E ;; ?QPWZ?               ;
                      .db $18,$95,$08,$C7,$C7,$95,$18,$8E ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$8E,$8E,$C7,$8E,$90 ;; ?QPWZ?               ;
                      .db $C7,$92,$18,$D1,$08,$D2,$C7,$D1 ;; ?QPWZ?               ;
                      .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1 ;; ?QPWZ?               ;
                      .db $08,$D2,$C7,$D1,$D1,$C7,$D1,$D2 ;; ?QPWZ?               ;
                      .db $D1,$D1,$18,$D1,$08,$D2,$C7,$D1 ;; ?QPWZ?               ;
                      .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1 ;; ?QPWZ?               ;
                      .db $08,$D2,$C7,$D1,$D2,$C7,$D1,$D2 ;; ?QPWZ?               ;
                      .db $C7,$D1,$18,$AB,$B2,$08,$B2,$C7 ;; ?QPWZ?               ;
                      .db $B2,$B1,$C7,$B2,$B4,$C6,$B2,$AF ;; ?QPWZ?               ;
                      .db $C7,$24,$AB,$0C,$C7,$08,$B2,$18 ;; ?QPWZ?               ;
                      .db $B0,$B0,$10,$B0,$B2,$B3,$18,$B4 ;; ?QPWZ?               ;
                      .db $C7,$AB,$C6,$00,$18,$A3,$A9,$08 ;; ?QPWZ?               ;
                      .db $A9,$C7,$A9,$A8,$C7,$A9,$AB,$C6 ;; ?QPWZ?               ;
                      .db $A9,$A6,$C7,$24,$A3,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $A9,$18,$A8,$A8,$10,$A8,$A9,$AA ;; ?QPWZ?               ;
                      .db $18,$AB,$C7,$A3,$C6,$18,$C7,$08 ;; ?QPWZ?               ;
                      .db $AB,$C6,$AA,$AB,$C6,$B2,$C6,$C6 ;; ?QPWZ?               ;
                      .db $AB,$AB,$C6,$AA,$AB,$C6,$B2,$C6 ;; ?QPWZ?               ;
                      .db $C6,$AB,$AD,$C6,$AF,$30,$B0,$10 ;; ?QPWZ?               ;
                      .db $B0,$AF,$AD,$AB,$06,$AD,$AF,$B0 ;; ?QPWZ?               ;
                      .db $B2,$B3,$B4,$B5,$B6,$30,$B7,$01 ;; ?QPWZ?               ;
                      .db $C7,$18,$C7,$9D,$C7,$9D,$C7,$9D ;; ?QPWZ?               ;
                      .db $C7,$9D,$C7,$9C,$10,$9C,$9D,$9E ;; ?QPWZ?               ;
                      .db $18,$9F,$C7,$9B,$C6,$18,$C7,$97 ;; ?QPWZ?               ;
                      .db $C7,$97,$C7,$97,$C7,$97,$C7,$9F ;; ?QPWZ?               ;
                      .db $10,$9F,$A0,$A1,$18,$A3,$C7,$A3 ;; ?QPWZ?               ;
                      .db $C6,$18,$93,$08,$C7,$C7,$93,$18 ;; ?QPWZ?               ;
                      .db $8E,$08,$C7,$C7,$8E,$18,$93,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$93,$18,$93,$08,$93,$95 ;; ?QPWZ?               ;
                      .db $97,$18,$98,$08,$C7,$C7,$98,$10 ;; ?QPWZ?               ;
                      .db $98,$9A,$9B,$18,$9C,$C7,$93,$C6 ;; ?QPWZ?               ;
                      .db $18,$D1,$08,$D2,$C7,$D1,$18,$D1 ;; ?QPWZ?               ;
                      .db $08,$D2,$C7,$D1,$18,$D1,$08,$D2 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1 ;; ?QPWZ?               ;
                      .db $18,$D1,$08,$D2,$C7,$D1,$10,$D2 ;; ?QPWZ?               ;
                      .db $D2,$D2,$18,$D1,$08,$D2,$C7,$D1 ;; ?QPWZ?               ;
                      .db $D2,$C7,$D1,$D2,$D1,$D1,$08,$A9 ;; ?QPWZ?               ;
                      .db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24 ;; ?QPWZ?               ;
                      .db $AB,$0C,$C7,$08,$C7,$08,$AD,$C7 ;; ?QPWZ?               ;
                      .db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08 ;; ?QPWZ?               ;
                      .db $AC,$AB,$C7,$AC,$AD,$C7,$24,$B4 ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$C7,$00,$DA,$04,$DB ;; ?QPWZ?               ;
                      .db $0C,$DE,$22,$18,$14,$08,$5C,$A4 ;; ?QPWZ?               ;
                      .db $C7,$A4,$A9,$C7,$24,$A4,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$A4,$A4,$C7,$A4,$A4,$C7,$24 ;; ?QPWZ?               ;
                      .db $A5,$0C,$C7,$08,$C7,$48,$B0,$08 ;; ?QPWZ?               ;
                      .db $AD,$C6,$B0,$60,$B4,$01,$C7,$18 ;; ?QPWZ?               ;
                      .db $C7,$9D,$C7,$9E,$C7,$9F,$C7,$9F ;; ?QPWZ?               ;
                      .db $18,$9E,$08,$C7,$C7,$9D,$18,$C6 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$AB,$18,$C7,$98,$C7 ;; ?QPWZ?               ;
                      .db $98,$C7,$9A,$C7,$99,$18,$A1,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$A3,$18,$C6,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $A4,$18,$91,$08,$C7,$C7,$91,$18 ;; ?QPWZ?               ;
                      .db $92,$08,$C7,$C7,$92,$18,$93,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$93,$18,$95,$08,$95,$90 ;; ?QPWZ?               ;
                      .db $8F,$18,$8E,$08,$C6,$C7,$93,$18 ;; ?QPWZ?               ;
                      .db $C6,$08,$C7,$C7,$98,$18,$D1,$08 ;; ?QPWZ?               ;
                      .db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7 ;; ?QPWZ?               ;
                      .db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1 ;; ?QPWZ?               ;
                      .db $C7,$D1,$D2,$D1,$D1,$18,$D2,$08 ;; ?QPWZ?               ;
                      .db $C6,$C7,$D2,$18,$C6,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $D2,$DA,$04,$DB,$0A,$DE,$22,$19 ;; ?QPWZ?               ;
                      .db $38,$18,$4D,$B4,$08,$C7,$C7,$B4 ;; ?QPWZ?               ;
                      .db $18,$B4,$08,$C7,$C7,$B7,$18,$B7 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$B7,$18,$B7,$C7,$00 ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$08,$DE,$20,$18,$36 ;; ?QPWZ?               ;
                      .db $18,$4D,$A4,$08,$C7,$C7,$A4,$18 ;; ?QPWZ?               ;
                      .db $A4,$08,$C7,$C7,$A7,$18,$A7,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$A7,$18,$A7,$C7,$DA,$04 ;; ?QPWZ?               ;
                      .db $DB,$0C,$DE,$21,$1A,$37,$18,$4D ;; ?QPWZ?               ;
                      .db $AD,$08,$C7,$C7,$AD,$18,$AD,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$AF,$18,$AF,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $AF,$18,$AF,$C7,$DA,$04,$DB,$0A ;; ?QPWZ?               ;
                      .db $DE,$22,$18,$36,$18,$4D,$A9,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$A9,$18,$A9,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $AB,$18,$AB,$08,$C7,$C7,$AB,$18 ;; ?QPWZ?               ;
                      .db $AB,$C7,$DA,$04,$DB,$0F,$08,$4D ;; ?QPWZ?               ;
                      .db $C7,$C7,$9A,$18,$9A,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $9A,$18,$9A,$08,$C7,$C7,$9F,$18 ;; ?QPWZ?               ;
                      .db $9F,$08,$C7,$C7,$C7,$18,$7D,$9F ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7 ;; ?QPWZ?               ;
                      .db $8E,$18,$8E,$08,$C7,$C7,$8E,$18 ;; ?QPWZ?               ;
                      .db $8E,$08,$C7,$C7,$93,$18,$93,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$C7,$18,$7E,$93,$DA,$08 ;; ?QPWZ?               ;
                      .db $DB,$0A,$DE,$22,$19,$38,$08,$5F ;; ?QPWZ?               ;
                      .db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7 ;; ?QPWZ?               ;
                      .db $8E,$18,$8E,$08,$C7,$C7,$93,$18 ;; ?QPWZ?               ;
                      .db $93,$08,$C7,$C7,$C7,$18,$7F,$93 ;; ?QPWZ?               ;
                      .db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7 ;; ?QPWZ?               ;
                      .db $D0,$18,$D0,$08,$C7,$C7,$D0,$18 ;; ?QPWZ?               ;
                      .db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7 ;; ?QPWZ?               ;
                      .db $08,$D0,$DB,$14,$08,$D1,$D1,$DA ;; ?QPWZ?               ;
                      .db $06,$DB,$0A,$DE,$22,$19,$38,$08 ;; ?QPWZ?               ;
                      .db $6F,$B4,$C7,$B7,$B9,$C7,$24,$B7 ;; ?QPWZ?               ;
                      .db $0C,$C7,$08,$B9,$BB,$C7,$BC,$BB ;; ?QPWZ?               ;
                      .db $BA,$24,$B9,$0C,$C7,$08,$B3,$B4 ;; ?QPWZ?               ;
                      .db $C7,$B7,$B9,$C7,$24,$B7,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$B8,$B9,$C7,$BA,$B9,$B8,$24 ;; ?QPWZ?               ;
                      .db $B7,$0C,$C7,$08,$B8,$00,$08,$B9 ;; ?QPWZ?               ;
                      .db $C7,$BB,$BC,$C7,$24,$B9,$0C,$C7 ;; ?QPWZ?               ;
                      .db $08,$B8,$B7,$C7,$B8,$B9,$C7,$24 ;; ?QPWZ?               ;
                      .db $C0,$0C,$C7,$08,$C7,$00,$18,$91 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$91,$18,$92,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$92,$18,$93,$08,$C7,$C7,$93 ;; ?QPWZ?               ;
                      .db $18,$95,$08,$C7,$C7,$95,$DA,$04 ;; ?QPWZ?               ;
                      .db $DB,$0A,$DE,$22,$19,$38,$18,$5D ;; ?QPWZ?               ;
                      .db $C0,$08,$C7,$C7,$C0,$E3,$78,$18 ;; ?QPWZ?               ;
                      .db $18,$C0,$08,$C7,$C7,$C3,$18,$C3 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$C3,$18,$C3,$C3,$00 ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$0A,$DE,$22,$19,$38 ;; ?QPWZ?               ;
                      .db $18,$5D,$C0,$08,$C7,$C7,$C0,$18 ;; ?QPWZ?               ;
                      .db $C0,$08,$C7,$C7,$C3,$18,$C3,$08 ;; ?QPWZ?               ;
                      .db $C7,$C7,$C3,$18,$C3,$C3,$00,$DA ;; ?QPWZ?               ;
                      .db $04,$DB,$08,$DE,$20,$18,$36,$18 ;; ?QPWZ?               ;
                      .db $5D,$A4,$08,$C7,$C7,$A4,$18,$A4 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$A7,$18,$A7,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$A7,$18,$A7,$A7,$DA,$04,$DB ;; ?QPWZ?               ;
                      .db $0C,$DE,$21,$1A,$37,$18,$5D,$B9 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$B9,$18,$B9,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$BB,$18,$BB,$08,$C7,$C7,$BB ;; ?QPWZ?               ;
                      .db $18,$BB,$BB,$DA,$04,$DB,$0A,$DE ;; ?QPWZ?               ;
                      .db $22,$18,$36,$18,$5D,$A9,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$A9,$18,$A9,$08,$C7,$C7,$AB ;; ?QPWZ?               ;
                      .db $18,$AB,$08,$C7,$C7,$AB,$18,$AB ;; ?QPWZ?               ;
                      .db $AB,$DA,$04,$DB,$0F,$08,$5D,$C7 ;; ?QPWZ?               ;
                      .db $C7,$9A,$18,$9A,$08,$C7,$C7,$9A ;; ?QPWZ?               ;
                      .db $18,$9A,$08,$C7,$C7,$9F,$18,$9F ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$9F,$08,$7D,$C7,$C7 ;; ?QPWZ?               ;
                      .db $9F,$DA,$04,$DB,$0F,$08,$5C,$C7 ;; ?QPWZ?               ;
                      .db $C7,$8E,$18,$8E,$08,$C7,$C7,$8E ;; ?QPWZ?               ;
                      .db $18,$8E,$08,$C7,$C7,$93,$18,$93 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$93,$08,$7E,$C7,$C7 ;; ?QPWZ?               ;
                      .db $93,$DA,$08,$DB,$0A,$DE,$22,$19 ;; ?QPWZ?               ;
                      .db $38,$08,$5F,$C7,$C7,$8E,$18,$8E ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$8E,$18,$8E,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$93,$18,$93,$08,$C7,$C7,$C7 ;; ?QPWZ?               ;
                      .db $08,$7F,$C7,$C7,$93,$DA,$00,$DB ;; ?QPWZ?               ;
                      .db $0A,$08,$6C,$C7,$C7,$D0,$18,$D0 ;; ?QPWZ?               ;
                      .db $08,$C7,$C7,$D0,$18,$D0,$08,$C7 ;; ?QPWZ?               ;
                      .db $C7,$D0,$18,$D0,$C7,$08,$D0,$DB ;; ?QPWZ?               ;
                      .db $14,$08,$D1,$D1,$DA,$04,$DE,$14 ;; ?QPWZ?               ;
                      .db $19,$30,$DB,$0A,$08,$4F,$B9,$C6 ;; ?QPWZ?               ;
                      .db $B7,$B9,$C6,$24,$B7,$0C,$C6,$08 ;; ?QPWZ?               ;
                      .db $B9,$BB,$C6,$C7,$BB,$C6,$24,$B9 ;; ?QPWZ?               ;
                      .db $0C,$C6,$08,$C6,$B9,$C6,$B7,$B9 ;; ?QPWZ?               ;
                      .db $C6,$24,$B7,$0C,$C6,$08,$B8,$B9 ;; ?QPWZ?               ;
                      .db $C6,$C7,$B9,$C6,$24,$B7,$0C,$C6 ;; ?QPWZ?               ;
                      .db $08,$B8,$DE,$16,$18,$30,$DB,$0A ;; ?QPWZ?               ;
                      .db $08,$4E,$AD,$C6,$AB,$AD,$C6,$24 ;; ?QPWZ?               ;
                      .db $AB,$0C,$C6,$08,$AD,$AF,$C6,$C7 ;; ?QPWZ?               ;
                      .db $AF,$C6,$24,$AD,$0C,$C6,$08,$C6 ;; ?QPWZ?               ;
                      .db $AD,$C6,$AB,$AD,$C6,$24,$AB,$0C ;; ?QPWZ?               ;
                      .db $C7,$08,$AC,$AD,$C6,$C7,$AD,$C6 ;; ?QPWZ?               ;
                      .db $24,$AB,$0C,$C6,$08,$AC,$00,$DE ;; ?QPWZ?               ;
                      .db $15,$19,$31,$DB,$08,$08,$4E,$A8 ;; ?QPWZ?               ;
                      .db $C6,$A4,$A8,$C6,$24,$A8,$0C,$C6 ;; ?QPWZ?               ;
                      .db $08,$A8,$AB,$C6,$C7,$AB,$C6,$24 ;; ?QPWZ?               ;
                      .db $A7,$0C,$C6,$08,$C6,$A6,$C6,$A6 ;; ?QPWZ?               ;
                      .db $A6,$C6,$24,$A6,$0C,$C6,$08,$A6 ;; ?QPWZ?               ;
                      .db $A8,$C6,$C7,$A8,$C6,$24,$A8,$0C ;; ?QPWZ?               ;
                      .db $C6,$08,$A8,$DA,$06,$DB,$0C,$DE ;; ?QPWZ?               ;
                      .db $14,$1A,$30,$08,$4E,$A4,$C6,$A4 ;; ?QPWZ?               ;
                      .db $A4,$C6,$24,$A4,$0C,$C6,$08,$A4 ;; ?QPWZ?               ;
                      .db $A7,$C6,$C7,$A7,$C6,$24,$A3,$0C ;; ?QPWZ?               ;
                      .db $C6,$08,$C6,$A2,$C6,$A2,$A2,$C6 ;; ?QPWZ?               ;
                      .db $24,$A2,$0C,$C6,$08,$A2,$A5,$C6 ;; ?QPWZ?               ;
                      .db $C7,$A5,$C6,$24,$A5,$0C,$C6,$08 ;; ?QPWZ?               ;
                      .db $A5,$08,$B9,$C6,$BB,$BC,$C6,$24 ;; ?QPWZ?               ;
                      .db $B9,$0C,$C6,$08,$B8,$B7,$C6,$B8 ;; ?QPWZ?               ;
                      .db $B9,$C6,$24,$C0,$0C,$C6,$08,$C6 ;; ?QPWZ?               ;
                      .db $00,$08,$A9,$C6,$A9,$AD,$C6,$24 ;; ?QPWZ?               ;
                      .db $AA,$0C,$C6,$08,$A9,$A8,$C6,$A8 ;; ?QPWZ?               ;
                      .db $A8,$C6,$24,$AB,$0C,$C6,$08,$C6 ;; ?QPWZ?               ;
                      .db $08,$AD,$C6,$AF,$B0,$C6,$24,$AD ;; ?QPWZ?               ;
                      .db $0C,$C6,$08,$AC,$AB,$C6,$AC,$AD ;; ?QPWZ?               ;
                      .db $C6,$24,$B4,$0C,$C6,$08,$C6,$00 ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$0C,$DE,$22,$18,$14 ;; ?QPWZ?               ;
                      .db $08,$5C,$A4,$C6,$A4,$A9,$C6,$24 ;; ?QPWZ?               ;
                      .db $A4,$0C,$C6,$08,$A4,$A4,$C6,$A4 ;; ?QPWZ?               ;
                      .db $A4,$C6,$24,$A5,$0C,$C6,$08,$C6 ;; ?QPWZ?               ;
                      .db $DA,$04,$DB,$0A,$DE,$22,$19,$38 ;; ?QPWZ?               ;
                      .db $60,$5E,$BC,$C6,$DA,$01,$10,$9F ;; ?QPWZ?               ;
                      .db $C6,$C6,$C6,$AF,$C6,$60,$C6,$C6 ;; ?QPWZ?               ;
                      .db $00,$DA,$04,$DB,$08,$DE,$20,$18 ;; ?QPWZ?               ;
                      .db $36,$60,$5D,$B4,$C6,$DA,$01,$10 ;; ?QPWZ?               ;
                      .db $C7,$A3,$C6,$C6,$C6,$B3,$60,$C6 ;; ?QPWZ?               ;
                      .db $C6,$DA,$04,$DB,$0C,$DE,$21,$1A ;; ?QPWZ?               ;
                      .db $37,$60,$5D,$AB,$C6,$DA,$01,$10 ;; ?QPWZ?               ;
                      .db $C7,$C7,$A7,$C6,$C6,$C6,$60,$B7 ;; ?QPWZ?               ;
                      .db $C6,$DA,$04,$DB,$0A,$DE,$22,$18 ;; ?QPWZ?               ;
                      .db $36,$60,$5D,$A4,$C6,$DA,$01,$10 ;; ?QPWZ?               ;
                      .db $C7,$C7,$C7,$AB,$C6,$C6,$60,$C6 ;; ?QPWZ?               ;
                      .db $C6,$DA,$04,$DB,$0F,$10,$5D,$A4 ;; ?QPWZ?               ;
                      .db $C7,$A4,$A2,$C7,$A2,$A1,$C7,$A1 ;; ?QPWZ?               ;
                      .db $A0,$C7,$A0,$60,$9F,$9B,$C6,$DA ;; ?QPWZ?               ;
                      .db $0D,$DB,$0F,$10,$5D,$9C,$C7,$9C ;; ?QPWZ?               ;
                      .db $9C,$C7,$9C,$98,$C7,$98,$98,$C7 ;; ?QPWZ?               ;
                      .db $98,$60,$97,$97,$C6,$DA,$08,$DB ;; ?QPWZ?               ;
                      .db $0A,$DE,$22,$19,$38,$10,$5D,$98 ;; ?QPWZ?               ;
                      .db $C7,$98,$96,$C7,$96,$95,$C7,$95 ;; ?QPWZ?               ;
                      .db $94,$C7,$94,$60,$93,$93,$C6,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$05,$E8,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00,$00,$00,$00 ;; ?QPWZ?               ;
                      .db $00,$00,$00,$00,$00             ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03FDE0:          .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; 03FDE0               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
                      .db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ;; ?QPWZ?               ;
