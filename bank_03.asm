ORG $038000                                               ;;                      ;
                                                          ;;                      ;
DATA_038000:          db $13,$14,$15,$16,$17,$18,$19      ;; 038000               ;
                                                          ;;                      ;
DATA_038007:          db $F0,$F8,$FC,$00,$04,$08,$10      ;; 038007               ;
                                                          ;;                      ;
DATA_03800E:          db $A0,$D0,$C0,$D0                  ;; 03800E               ;
                                                          ;;                      ;
Football:             JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDA.B !SpriteLock                   ;; 038016 : A5 9D       ;
                      BNE Return038086                    ;; 038018 : D0 6C       ;
                      JSR SubOffscreen0Bnk3               ;; 03801A : 20 5D B8    ;
                      JSL SprSpr_MarioSprRts              ;; 03801D : 22 3A 80 01 ;
                      LDA.W !SpriteMisc1540,X             ;; 038021 : BD 40 15    ;
                      BEQ CODE_03802D                     ;; 038024 : F0 07       ;
                      DEC A                               ;; 038026 : 3A          ;
                      BNE CODE_038031                     ;; 038027 : D0 08       ;
                      JSL CODE_01AB6F                     ;; 038029 : 22 6F AB 01 ;
CODE_03802D:          JSL UpdateSpritePos                 ;; 03802D : 22 2A 80 01 ;
CODE_038031:          LDA.W !SpriteBlockedDirs,X          ;; 038031 : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 038034 : 29 03       ;  | 
                      BEQ CODE_03803F                     ;; 038036 : F0 07       ; / 
                      LDA.B !SpriteXSpeed,X               ;; 038038 : B5 B6       ;
                      EOR.B #$FF                          ;; 03803A : 49 FF       ;
                      INC A                               ;; 03803C : 1A          ;
                      STA.B !SpriteXSpeed,X               ;; 03803D : 95 B6       ;
CODE_03803F:          LDA.W !SpriteBlockedDirs,X          ;; 03803F : BD 88 15    ;
                      AND.B #$08                          ;; 038042 : 29 08       ;
                      BEQ CODE_038048                     ;; 038044 : F0 02       ;
                      STZ.B !SpriteYSpeed,X               ;; 038046 : 74 AA       ; Sprite Y Speed = 0 
CODE_038048:          LDA.W !SpriteBlockedDirs,X          ;; 038048 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 03804B : 29 04       ;  | 
                      BEQ Return038086                    ;; 03804D : F0 37       ; / 
                      LDA.W !SpriteMisc1540,X             ;; 03804F : BD 40 15    ;
                      BNE Return038086                    ;; 038052 : D0 32       ;
                      LDA.W !SpriteOBJAttribute,X         ;; 038054 : BD F6 15    ;
                      EOR.B #$40                          ;; 038057 : 49 40       ;
                      STA.W !SpriteOBJAttribute,X         ;; 038059 : 9D F6 15    ;
                      JSL GetRand                         ;; 03805C : 22 F9 AC 01 ;
                      AND.B #$03                          ;; 038060 : 29 03       ;
                      TAY                                 ;; 038062 : A8          ;
                      LDA.W DATA_03800E,Y                 ;; 038063 : B9 0E 80    ;
                      STA.B !SpriteYSpeed,X               ;; 038066 : 95 AA       ;
                      LDY.W !SpriteSlope,X                ;; 038068 : BC B8 15    ;
                      INY                                 ;; 03806B : C8          ;
                      INY                                 ;; 03806C : C8          ;
                      INY                                 ;; 03806D : C8          ;
                      LDA.W DATA_038007,Y                 ;; 03806E : B9 07 80    ;
                      CLC                                 ;; 038071 : 18          ;
                      ADC.B !SpriteXSpeed,X               ;; 038072 : 75 B6       ;
                      BPL CODE_03807E                     ;; 038074 : 10 08       ;
                      CMP.B #$E0                          ;; 038076 : C9 E0       ;
                      BCS CODE_038084                     ;; 038078 : B0 0A       ;
                      LDA.B #$E0                          ;; 03807A : A9 E0       ;
                      BRA CODE_038084                     ;; 03807C : 80 06       ;
                                                          ;;                      ;
CODE_03807E:          CMP.B #$20                          ;; 03807E : C9 20       ;
                      BCC CODE_038084                     ;; 038080 : 90 02       ;
                      LDA.B #$20                          ;; 038082 : A9 20       ;
CODE_038084:          STA.B !SpriteXSpeed,X               ;; 038084 : 95 B6       ;
Return038086:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
BigBooBoss:           JSL CODE_038398                     ;; ?QPWZ? : 22 98 83 03 ;
                      JSL CODE_038239                     ;; 03808B : 22 39 82 03 ;
                      LDA.W !SpriteStatus,X               ;; 03808F : BD C8 14    ;
                      BNE CODE_0380A2                     ;; 038092 : D0 0E       ;
                      INC.W !CutsceneID                   ;; 038094 : EE C6 13    ;
                      LDA.B #$FF                          ;; 038097 : A9 FF       ;
                      STA.W !EndLevelTimer                ;; 038099 : 8D 93 14    ;
                      LDA.B #$0B                          ;; 03809C : A9 0B       ;
                      STA.W !SPCIO2                       ;; 03809E : 8D FB 1D    ; / Change music 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0380A2:          CMP.B #$08                          ;; 0380A2 : C9 08       ;
                      BNE Return0380D4                    ;; 0380A4 : D0 2E       ;
                      LDA.B !SpriteLock                   ;; 0380A6 : A5 9D       ;
                      BNE Return0380D4                    ;; 0380A8 : D0 2A       ;
                      LDA.B !SpriteTableC2,X              ;; 0380AA : B5 C2       ;
                      JSL ExecutePtr                      ;; 0380AC : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_0380BE                      ;; ?QPWZ? : BE 80       ;
                      dw CODE_0380D5                      ;; ?QPWZ? : D5 80       ;
                      dw CODE_038119                      ;; ?QPWZ? : 19 81       ;
                      dw CODE_03818B                      ;; ?QPWZ? : 8B 81       ;
                      dw CODE_0381BC                      ;; ?QPWZ? : BC 81       ;
                      dw CODE_038106                      ;; ?QPWZ? : 06 81       ;
                      dw CODE_0381D3                      ;; ?QPWZ? : D3 81       ;
                                                          ;;                      ;
CODE_0380BE:          LDA.B #$03                          ;; 0380BE : A9 03       ;
                      STA.W !SpriteMisc1602,X             ;; 0380C0 : 9D 02 16    ;
                      INC.W !SpriteMisc1570,X             ;; 0380C3 : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 0380C6 : BD 70 15    ;
                      CMP.B #$90                          ;; 0380C9 : C9 90       ;
                      BNE Return0380D4                    ;; 0380CB : D0 07       ;
                      LDA.B #$08                          ;; 0380CD : A9 08       ;
                      STA.W !SpriteMisc1540,X             ;; 0380CF : 9D 40 15    ;
                      INC.B !SpriteTableC2,X              ;; 0380D2 : F6 C2       ;
Return0380D4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0380D5:          LDA.W !SpriteMisc1540,X             ;; 0380D5 : BD 40 15    ;
                      BNE Return0380F9                    ;; 0380D8 : D0 1F       ;
                      LDA.B #$08                          ;; 0380DA : A9 08       ;
                      STA.W !SpriteMisc1540,X             ;; 0380DC : 9D 40 15    ;
                      INC.W !BooTransparency              ;; 0380DF : EE 0B 19    ;
                      LDA.W !BooTransparency              ;; 0380E2 : AD 0B 19    ;
                      CMP.B #$02                          ;; 0380E5 : C9 02       ;
                      BNE CODE_0380EE                     ;; 0380E7 : D0 05       ;
                      LDY.B #$10                          ;; 0380E9 : A0 10       ; \ Play sound effect 
                      STY.W !SPCIO0                       ;; 0380EB : 8C F9 1D    ; / 
CODE_0380EE:          CMP.B #$07                          ;; 0380EE : C9 07       ;
                      BNE Return0380F9                    ;; 0380F0 : D0 07       ;
                      INC.B !SpriteTableC2,X              ;; 0380F2 : F6 C2       ;
                      LDA.B #$40                          ;; 0380F4 : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 0380F6 : 9D 40 15    ;
Return0380F9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0380FA:          db $FF,$01                          ;; 0380FA               ;
                                                          ;;                      ;
DATA_0380FC:          db $F0,$10                          ;; 0380FC               ;
                                                          ;;                      ;
DATA_0380FE:          db $0C,$F4                          ;; 0380FE               ;
                                                          ;;                      ;
DATA_038100:          db $01,$FF                          ;; 038100               ;
                                                          ;;                      ;
DATA_038102:          db $01,$02,$02,$01                  ;; 038102               ;
                                                          ;;                      ;
CODE_038106:          LDA.W !SpriteMisc1540,X             ;; 038106 : BD 40 15    ;
                      BNE CODE_038112                     ;; 038109 : D0 07       ;
                      STZ.B !SpriteTableC2,X              ;; 03810B : 74 C2       ;
                      LDA.B #$40                          ;; 03810D : A9 40       ;
                      STA.W !SpriteMisc1570,X             ;; 03810F : 9D 70 15    ;
CODE_038112:          LDA.B #$03                          ;; 038112 : A9 03       ;
                      STA.W !SpriteMisc1602,X             ;; 038114 : 9D 02 16    ;
                      BRA CODE_03811F                     ;; 038117 : 80 06       ;
                                                          ;;                      ;
CODE_038119:          STZ.W !SpriteMisc1602,X             ;; 038119 : 9E 02 16    ;
                      JSR CODE_0381E4                     ;; 03811C : 20 E4 81    ;
CODE_03811F:          LDA.W !SpriteMisc15AC,X             ;; 03811F : BD AC 15    ;
                      BNE CODE_038132                     ;; 038122 : D0 0E       ;
                      JSR SubHorzPosBnk3                  ;; 038124 : 20 17 B8    ;
                      TYA                                 ;; 038127 : 98          ;
                      CMP.W !SpriteMisc157C,X             ;; 038128 : DD 7C 15    ;
                      BEQ CODE_03814A                     ;; 03812B : F0 1D       ;
                      LDA.B #$1F                          ;; 03812D : A9 1F       ;
                      STA.W !SpriteMisc15AC,X             ;; 03812F : 9D AC 15    ;
CODE_038132:          CMP.B #$10                          ;; 038132 : C9 10       ;
                      BNE CODE_038140                     ;; 038134 : D0 0A       ;
                      PHA                                 ;; 038136 : 48          ;
                      LDA.W !SpriteMisc157C,X             ;; 038137 : BD 7C 15    ;
                      EOR.B #$01                          ;; 03813A : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 03813C : 9D 7C 15    ;
                      PLA                                 ;; 03813F : 68          ;
CODE_038140:          LSR A                               ;; 038140 : 4A          ;
                      LSR A                               ;; 038141 : 4A          ;
                      LSR A                               ;; 038142 : 4A          ;
                      TAY                                 ;; 038143 : A8          ;
                      LDA.W DATA_038102,Y                 ;; 038144 : B9 02 81    ;
                      STA.W !SpriteMisc1602,X             ;; 038147 : 9D 02 16    ;
CODE_03814A:          LDA.B !EffFrame                     ;; 03814A : A5 14       ;
                      AND.B #$07                          ;; 03814C : 29 07       ;
                      BNE CODE_038166                     ;; 03814E : D0 16       ;
                      LDA.W !SpriteMisc151C,X             ;; 038150 : BD 1C 15    ;
                      AND.B #$01                          ;; 038153 : 29 01       ;
                      TAY                                 ;; 038155 : A8          ;
                      LDA.B !SpriteXSpeed,X               ;; 038156 : B5 B6       ;
                      CLC                                 ;; 038158 : 18          ;
                      ADC.W DATA_0380FA,Y                 ;; 038159 : 79 FA 80    ;
                      STA.B !SpriteXSpeed,X               ;; 03815C : 95 B6       ;
                      CMP.W DATA_0380FC,Y                 ;; 03815E : D9 FC 80    ;
                      BNE CODE_038166                     ;; 038161 : D0 03       ;
                      INC.W !SpriteMisc151C,X             ;; 038163 : FE 1C 15    ;
CODE_038166:          LDA.B !EffFrame                     ;; 038166 : A5 14       ;
                      AND.B #$07                          ;; 038168 : 29 07       ;
                      BNE CODE_038182                     ;; 03816A : D0 16       ;
                      LDA.W !SpriteMisc1528,X             ;; 03816C : BD 28 15    ;
                      AND.B #$01                          ;; 03816F : 29 01       ;
                      TAY                                 ;; 038171 : A8          ;
                      LDA.B !SpriteYSpeed,X               ;; 038172 : B5 AA       ;
                      CLC                                 ;; 038174 : 18          ;
                      ADC.W DATA_038100,Y                 ;; 038175 : 79 00 81    ;
                      STA.B !SpriteYSpeed,X               ;; 038178 : 95 AA       ;
                      CMP.W DATA_0380FE,Y                 ;; 03817A : D9 FE 80    ;
                      BNE CODE_038182                     ;; 03817D : D0 03       ;
                      INC.W !SpriteMisc1528,X             ;; 03817F : FE 28 15    ;
CODE_038182:          JSL UpdateXPosNoGvtyW               ;; 038182 : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 038186 : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03818B:          LDA.W !SpriteMisc1540,X             ;; 03818B : BD 40 15    ;
                      BNE CODE_0381AE                     ;; 03818E : D0 1E       ;
                      INC.B !SpriteTableC2,X              ;; 038190 : F6 C2       ;
                      LDA.B #$08                          ;; 038192 : A9 08       ;
                      STA.W !SpriteMisc1540,X             ;; 038194 : 9D 40 15    ;
                      JSL LoadSpriteTables                ;; 038197 : 22 8B F7 07 ;
                      INC.W !SpriteMisc1534,X             ;; 03819B : FE 34 15    ;
                      LDA.W !SpriteMisc1534,X             ;; 03819E : BD 34 15    ;
                      CMP.B #$03                          ;; 0381A1 : C9 03       ;
                      BNE Return0381AD                    ;; 0381A3 : D0 08       ;
                      LDA.B #$06                          ;; 0381A5 : A9 06       ;
                      STA.B !SpriteTableC2,X              ;; 0381A7 : 95 C2       ;
                      JSL KillMostSprites                 ;; 0381A9 : 22 C8 A6 03 ;
Return0381AD:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381AE:          AND.B #$0E                          ;; 0381AE : 29 0E       ;
                      EOR.W !SpriteOBJAttribute,X         ;; 0381B0 : 5D F6 15    ;
                      STA.W !SpriteOBJAttribute,X         ;; 0381B3 : 9D F6 15    ;
                      LDA.B #$03                          ;; 0381B6 : A9 03       ;
                      STA.W !SpriteMisc1602,X             ;; 0381B8 : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381BC:          LDA.W !SpriteMisc1540,X             ;; 0381BC : BD 40 15    ;
                      BNE Return0381D2                    ;; 0381BF : D0 11       ;
                      LDA.B #$08                          ;; 0381C1 : A9 08       ;
                      STA.W !SpriteMisc1540,X             ;; 0381C3 : 9D 40 15    ;
                      DEC.W !BooTransparency              ;; 0381C6 : CE 0B 19    ;
                      BNE Return0381D2                    ;; 0381C9 : D0 07       ;
                      INC.B !SpriteTableC2,X              ;; 0381CB : F6 C2       ;
                      LDA.B #$C0                          ;; 0381CD : A9 C0       ;
                      STA.W !SpriteMisc1540,X             ;; 0381CF : 9D 40 15    ;
Return0381D2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381D3:          LDA.B #$02                          ;; 0381D3 : A9 02       ; \ Sprite status = Killed 
                      STA.W !SpriteStatus,X               ;; 0381D5 : 9D C8 14    ; / 
                      STZ.B !SpriteXSpeed,X               ;; 0381D8 : 74 B6       ; Sprite X Speed = 0 
                      LDA.B #$D0                          ;; 0381DA : A9 D0       ;
                      STA.B !SpriteYSpeed,X               ;; 0381DC : 95 AA       ;
                      LDA.B #$23                          ;; 0381DE : A9 23       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 0381E0 : 8D F9 1D    ; / 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381E4:          LDY.B #$0B                          ;; 0381E4 : A0 0B       ;
CODE_0381E6:          LDA.W !SpriteStatus,Y               ;; 0381E6 : B9 C8 14    ;
                      CMP.B #$09                          ;; 0381E9 : C9 09       ;
                      BEQ CODE_0381F5                     ;; 0381EB : F0 08       ;
                      CMP.B #$0A                          ;; 0381ED : C9 0A       ;
                      BEQ CODE_0381F5                     ;; 0381EF : F0 04       ;
CODE_0381F1:          DEY                                 ;; 0381F1 : 88          ;
                      BPL CODE_0381E6                     ;; 0381F2 : 10 F2       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0381F5:          PHX                                 ;; 0381F5 : DA          ;
                      TYX                                 ;; 0381F6 : BB          ;
                      JSL GetSpriteClippingB              ;; 0381F7 : 22 E5 B6 03 ;
                      PLX                                 ;; 0381FB : FA          ;
                      JSL GetSpriteClippingA              ;; 0381FC : 22 9F B6 03 ;
                      JSL CheckForContact                 ;; 038200 : 22 2B B7 03 ;
                      BCC CODE_0381F1                     ;; 038204 : 90 EB       ;
                      LDA.B #$03                          ;; 038206 : A9 03       ;
                      STA.B !SpriteTableC2,X              ;; 038208 : 95 C2       ;
                      LDA.B #$40                          ;; 03820A : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 03820C : 9D 40 15    ;
                      PHX                                 ;; 03820F : DA          ;
                      TYX                                 ;; 038210 : BB          ;
                      STZ.W !SpriteStatus,X               ;; 038211 : 9E C8 14    ;
                      LDA.B !SpriteXPosLow,X              ;; 038214 : B5 E4       ;
                      STA.B !TouchBlockXPos               ;; 038216 : 85 9A       ;
                      LDA.W !SpriteYPosHigh,X             ;; 038218 : BD E0 14    ;
                      STA.B !TouchBlockXPos+1             ;; 03821B : 85 9B       ;
                      LDA.B !SpriteYPosLow,X              ;; 03821D : B5 D8       ;
                      STA.B !TouchBlockYPos               ;; 03821F : 85 98       ;
                      LDA.W !SpriteXPosHigh,X             ;; 038221 : BD D4 14    ;
                      STA.B !TouchBlockYPos+1             ;; 038224 : 85 99       ;
                      PHB                                 ;; 038226 : 8B          ;
                      LDA.B #$02                          ;; 038227 : A9 02       ;
                      PHA                                 ;; 038229 : 48          ;
                      PLB                                 ;; 03822A : AB          ;
                      LDA.B #$FF                          ;; 03822B : A9 FF       ;
                      JSL ShatterBlock                    ;; 03822D : 22 63 86 02 ;
                      PLB                                 ;; 038231 : AB          ;
                      PLX                                 ;; 038232 : FA          ;
                      LDA.B #$28                          ;; 038233 : A9 28       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 038235 : 8D FC 1D    ; / 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038239:          LDY.B #$24                          ;; 038239 : A0 24       ;
                      STY.B !ColorSettings                ;; 03823B : 84 40       ;
                      LDA.W !BooTransparency              ;; 03823D : AD 0B 19    ;
                      CMP.B #$08                          ;; 038240 : C9 08       ;
                      DEC A                               ;; 038242 : 3A          ;
                      BCS CODE_03824A                     ;; 038243 : B0 05       ;
                      LDY.B #$34                          ;; 038245 : A0 34       ;
                      STY.B !ColorSettings                ;; 038247 : 84 40       ;
                      INC A                               ;; 038249 : 1A          ;
CODE_03824A:          ASL A                               ;; 03824A : 0A          ;
                      ASL A                               ;; 03824B : 0A          ;
                      ASL A                               ;; 03824C : 0A          ;
                      ASL A                               ;; 03824D : 0A          ;
                      TAX                                 ;; 03824E : AA          ;
                      STZ.B !_0                           ;; 03824F : 64 00       ;
                      LDY.W !DynPaletteIndex              ;; 038251 : AC 81 06    ;
CODE_038254:          LDA.L BooBossPals,X                 ;; 038254 : BF 82 B9 03 ;
                      STA.W !DynPaletteTable+2,Y          ;; 038258 : 99 84 06    ;
                      INY                                 ;; 03825B : C8          ;
                      INX                                 ;; 03825C : E8          ;
                      INC.B !_0                           ;; 03825D : E6 00       ;
                      LDA.B !_0                           ;; 03825F : A5 00       ;
                      CMP.B #$10                          ;; 038261 : C9 10       ;
                      BNE CODE_038254                     ;; 038263 : D0 EF       ;
                      LDX.W !DynPaletteIndex              ;; 038265 : AE 81 06    ;
                      LDA.B #$10                          ;; 038268 : A9 10       ;
                      STA.W !DynPaletteTable,X            ;; 03826A : 9D 82 06    ;
                      LDA.B #$F0                          ;; 03826D : A9 F0       ;
                      STA.W !DynPaletteTable+1,X          ;; 03826F : 9D 83 06    ;
                      STZ.W !DynPaletteTable+$12,X        ;; 038272 : 9E 94 06    ;
                      TXA                                 ;; 038275 : 8A          ;
                      CLC                                 ;; 038276 : 18          ;
                      ADC.B #$12                          ;; 038277 : 69 12       ;
                      STA.W !DynPaletteIndex              ;; 038279 : 8D 81 06    ;
                      LDX.W !CurSpriteProcess             ;; 03827C : AE E9 15    ; X = Sprite index 
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BigBooDispX:          db $08,$08,$20,$00,$00,$00,$00,$10  ;; ?QPWZ?               ;
                      db $10,$10,$10,$20,$20,$20,$20,$30  ;; ?QPWZ?               ;
                      db $30,$30,$30,$FD,$0C,$0C,$27,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$10,$10,$10,$10,$1F  ;; ?QPWZ?               ;
                      db $20,$20,$1F,$2E,$2E,$2C,$2C,$FB  ;; ?QPWZ?               ;
                      db $12,$12,$30,$00,$00,$00,$00,$10  ;; ?QPWZ?               ;
                      db $10,$10,$10,$1F,$20,$20,$1F,$2E  ;; ?QPWZ?               ;
                      db $2E,$2E,$2E,$F8,$11,$FF,$08,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$10,$10,$10,$10  ;; ?QPWZ?               ;
                      db $20,$20,$20,$20,$30,$30,$30,$30  ;; ?QPWZ?               ;
BigBooDispY:          db $12,$22,$18,$00,$10,$20,$30,$00  ;; ?QPWZ?               ;
                      db $10,$20,$30,$00,$10,$20,$30,$00  ;; ?QPWZ?               ;
                      db $10,$20,$30,$18,$16,$16,$12,$22  ;; ?QPWZ?               ;
                      db $00,$10,$20,$30,$00,$10,$20,$30  ;; ?QPWZ?               ;
                      db $00,$10,$20,$30,$00,$10,$20,$30  ;; ?QPWZ?               ;
BigBooTiles:          db $C0,$E0,$E8,$80,$A0,$A0,$80,$82  ;; ?QPWZ?               ;
                      db $A2,$A2,$82,$84,$A4,$C4,$E4,$86  ;; ?QPWZ?               ;
                      db $A6,$C6,$E6,$E8,$C0,$E0,$E8,$80  ;; ?QPWZ?               ;
                      db $A0,$A0,$80,$82,$A2,$A2,$82,$84  ;; ?QPWZ?               ;
                      db $A4,$C4,$E4,$86,$A6,$C6,$E6,$E8  ;; ?QPWZ?               ;
                      db $C0,$E0,$E8,$80,$A0,$A0,$80,$82  ;; ?QPWZ?               ;
                      db $A2,$A2,$82,$84,$A4,$A4,$84,$86  ;; ?QPWZ?               ;
                      db $A6,$A6,$86,$E8,$E8,$E8,$C2,$E2  ;; ?QPWZ?               ;
                      db $80,$A0,$A0,$80,$82,$A2,$A2,$82  ;; ?QPWZ?               ;
                      db $84,$A4,$C4,$E4,$86,$A6,$C6,$E6  ;; ?QPWZ?               ;
BigBooGfxProp:        db $00,$00,$40,$00,$00,$80,$80,$00  ;; ?QPWZ?               ;
                      db $00,$80,$80,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$40,$00  ;; ?QPWZ?               ;
                      db $00,$80,$80,$00,$00,$80,$80,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$40,$00,$00,$80,$80,$00  ;; ?QPWZ?               ;
                      db $00,$80,$80,$00,$00,$80,$80,$00  ;; ?QPWZ?               ;
                      db $00,$80,$80,$00,$00,$40,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$80,$80,$00,$00,$80,$80  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038398:          PHB                                 ;; 038398 : 8B          ; Wrapper 
                      PHK                                 ;; 038399 : 4B          ;
                      PLB                                 ;; 03839A : AB          ;
                      JSR CODE_0383A0                     ;; 03839B : 20 A0 83    ;
                      PLB                                 ;; 03839E : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_0383A0:          LDA.B !SpriteNumber,X               ;; 0383A0 : B5 9E       ;
                      CMP.B #$37                          ;; 0383A2 : C9 37       ;
                      BNE CODE_0383C2                     ;; 0383A4 : D0 1C       ;
                      LDA.B #$00                          ;; 0383A6 : A9 00       ;
                      LDY.B !SpriteTableC2,X              ;; 0383A8 : B4 C2       ;
                      BEQ CODE_0383BA                     ;; 0383AA : F0 0E       ;
                      LDA.B #$06                          ;; 0383AC : A9 06       ;
                      LDY.W !SpriteMisc1558,X             ;; 0383AE : BC 58 15    ;
                      BEQ CODE_0383BA                     ;; 0383B1 : F0 07       ;
                      TYA                                 ;; 0383B3 : 98          ;
                      AND.B #$04                          ;; 0383B4 : 29 04       ;
                      LSR A                               ;; 0383B6 : 4A          ;
                      LSR A                               ;; 0383B7 : 4A          ;
                      ADC.B #$02                          ;; 0383B8 : 69 02       ;
CODE_0383BA:          STA.W !SpriteMisc1602,X             ;; 0383BA : 9D 02 16    ;
                      JSL GenericSprGfxRt2                ;; 0383BD : 22 B2 90 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0383C2:          JSR GetDrawInfoBnk3                 ;; 0383C2 : 20 60 B7    ;
                      LDA.W !SpriteMisc1602,X             ;; 0383C5 : BD 02 16    ;
                      STA.B !_6                           ;; 0383C8 : 85 06       ;
                      ASL A                               ;; 0383CA : 0A          ;
                      ASL A                               ;; 0383CB : 0A          ;
                      STA.B !_3                           ;; 0383CC : 85 03       ;
                      ASL A                               ;; 0383CE : 0A          ;
                      ASL A                               ;; 0383CF : 0A          ;
                      ADC.B !_3                           ;; 0383D0 : 65 03       ;
                      STA.B !_2                           ;; 0383D2 : 85 02       ;
                      LDA.W !SpriteMisc157C,X             ;; 0383D4 : BD 7C 15    ;
                      STA.B !_4                           ;; 0383D7 : 85 04       ;
                      LDA.W !SpriteOBJAttribute,X         ;; 0383D9 : BD F6 15    ;
                      STA.B !_5                           ;; 0383DC : 85 05       ;
                      LDX.B #$00                          ;; 0383DE : A2 00       ;
CODE_0383E0:          PHX                                 ;; 0383E0 : DA          ;
                      LDX.B !_2                           ;; 0383E1 : A6 02       ;
                      LDA.W BigBooTiles,X                 ;; 0383E3 : BD F8 82    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0383E6 : 99 02 03    ;
                      LDA.B !_4                           ;; 0383E9 : A5 04       ;
                      LSR A                               ;; 0383EB : 4A          ;
                      LDA.W BigBooGfxProp,X               ;; 0383EC : BD 48 83    ;
                      ORA.B !_5                           ;; 0383EF : 05 05       ;
                      BCS CODE_0383F5                     ;; 0383F1 : B0 02       ;
                      EOR.B #$40                          ;; 0383F3 : 49 40       ;
CODE_0383F5:          ORA.B !SpriteProperties             ;; 0383F5 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0383F7 : 99 03 03    ;
                      LDA.W BigBooDispX,X                 ;; 0383FA : BD 80 82    ;
                      BCS CODE_038405                     ;; 0383FD : B0 06       ;
                      EOR.B #$FF                          ;; 0383FF : 49 FF       ;
                      INC A                               ;; 038401 : 1A          ;
                      CLC                                 ;; 038402 : 18          ;
                      ADC.B #$28                          ;; 038403 : 69 28       ;
CODE_038405:          CLC                                 ;; 038405 : 18          ;
                      ADC.B !_0                           ;; 038406 : 65 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038408 : 99 00 03    ;
                      PLX                                 ;; 03840B : FA          ;
                      PHX                                 ;; 03840C : DA          ;
                      LDA.B !_6                           ;; 03840D : A5 06       ;
                      CMP.B #$03                          ;; 03840F : C9 03       ;
                      BCC CODE_038418                     ;; 038411 : 90 05       ;
                      TXA                                 ;; 038413 : 8A          ;
                      CLC                                 ;; 038414 : 18          ;
                      ADC.B #$14                          ;; 038415 : 69 14       ;
                      TAX                                 ;; 038417 : AA          ;
CODE_038418:          LDA.B !_1                           ;; 038418 : A5 01       ;
                      CLC                                 ;; 03841A : 18          ;
                      ADC.W BigBooDispY,X                 ;; 03841B : 7D D0 82    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03841E : 99 01 03    ;
                      PLX                                 ;; 038421 : FA          ;
                      INY                                 ;; 038422 : C8          ;
                      INY                                 ;; 038423 : C8          ;
                      INY                                 ;; 038424 : C8          ;
                      INY                                 ;; 038425 : C8          ;
                      INC.B !_2                           ;; 038426 : E6 02       ;
                      INX                                 ;; 038428 : E8          ;
                      CPX.B #$14                          ;; 038429 : E0 14       ;
                      BNE CODE_0383E0                     ;; 03842B : D0 B3       ;
                      LDX.W !CurSpriteProcess             ;; 03842D : AE E9 15    ; X = Sprite index 
                      LDA.W !SpriteMisc1602,X             ;; 038430 : BD 02 16    ;
                      CMP.B #$03                          ;; 038433 : C9 03       ;
                      BNE CODE_03844B                     ;; 038435 : D0 14       ;
                      LDA.W !SpriteMisc1558,X             ;; 038437 : BD 58 15    ;
                      BEQ CODE_03844B                     ;; 03843A : F0 0F       ;
                      LDY.W !SpriteOAMIndex,X             ;; 03843C : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !OAMTileYPos+$100,Y           ;; 03843F : B9 01 03    ;
                      CLC                                 ;; 038442 : 18          ;
                      ADC.B #$05                          ;; 038443 : 69 05       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038445 : 99 01 03    ;
                      STA.W !OAMTileYPos+$104,Y           ;; 038448 : 99 05 03    ;
CODE_03844B:          LDA.B #$13                          ;; 03844B : A9 13       ;
                      LDY.B #$02                          ;; 03844D : A0 02       ;
                      JSL FinishOAMWrite                  ;; 03844F : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GreyFallingPlat:      JSR CODE_038492                     ;; ?QPWZ? : 20 92 84    ;
                      LDA.B !SpriteLock                   ;; 038457 : A5 9D       ;
                      BNE Return038489                    ;; 038459 : D0 2E       ;
                      JSR SubOffscreen0Bnk3               ;; 03845B : 20 5D B8    ;
                      LDA.B !SpriteYSpeed,X               ;; 03845E : B5 AA       ;
                      BEQ CODE_038476                     ;; 038460 : F0 14       ;
                      LDA.W !SpriteMisc1540,X             ;; 038462 : BD 40 15    ;
                      BNE CODE_038472                     ;; 038465 : D0 0B       ;
                      LDA.B !SpriteYSpeed,X               ;; 038467 : B5 AA       ;
                      CMP.B #$40                          ;; 038469 : C9 40       ;
                      BPL CODE_038472                     ;; 03846B : 10 05       ;
                      CLC                                 ;; 03846D : 18          ;
                      ADC.B #$02                          ;; 03846E : 69 02       ;
                      STA.B !SpriteYSpeed,X               ;; 038470 : 95 AA       ;
CODE_038472:          JSL UpdateYPosNoGvtyW               ;; 038472 : 22 1A 80 01 ;
CODE_038476:          JSL InvisBlkMainRt                  ;; 038476 : 22 4F B4 01 ;
                      BCC Return038489                    ;; 03847A : 90 0D       ;
                      LDA.B !SpriteYSpeed,X               ;; 03847C : B5 AA       ;
                      BNE Return038489                    ;; 03847E : D0 09       ;
                      LDA.B #$03                          ;; 038480 : A9 03       ;
                      STA.B !SpriteYSpeed,X               ;; 038482 : 95 AA       ;
                      LDA.B #$18                          ;; 038484 : A9 18       ;
                      STA.W !SpriteMisc1540,X             ;; 038486 : 9D 40 15    ;
Return038489:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FallingPlatDispX:     db $00,$10,$20,$30                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FallingPlatTiles:     db $60,$61,$61,$62                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038492:          JSR GetDrawInfoBnk3                 ;; 038492 : 20 60 B7    ;
                      PHX                                 ;; 038495 : DA          ;
                      LDX.B #$03                          ;; 038496 : A2 03       ;
CODE_038498:          LDA.B !_0                           ;; 038498 : A5 00       ;
                      CLC                                 ;; 03849A : 18          ;
                      ADC.W FallingPlatDispX,X            ;; 03849B : 7D 8A 84    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03849E : 99 00 03    ;
                      LDA.B !_1                           ;; 0384A1 : A5 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 0384A3 : 99 01 03    ;
                      LDA.W FallingPlatTiles,X            ;; 0384A6 : BD 8E 84    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0384A9 : 99 02 03    ;
                      LDA.B #$03                          ;; 0384AC : A9 03       ;
                      ORA.B !SpriteProperties             ;; 0384AE : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0384B0 : 99 03 03    ;
                      INY                                 ;; 0384B3 : C8          ;
                      INY                                 ;; 0384B4 : C8          ;
                      INY                                 ;; 0384B5 : C8          ;
                      INY                                 ;; 0384B6 : C8          ;
                      DEX                                 ;; 0384B7 : CA          ;
                      BPL CODE_038498                     ;; 0384B8 : 10 DE       ;
                      PLX                                 ;; 0384BA : FA          ;
                      LDY.B #$02                          ;; 0384BB : A0 02       ;
                      LDA.B #$03                          ;; 0384BD : A9 03       ;
                      JSL FinishOAMWrite                  ;; 0384BF : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BlurpMaxSpeedY:       db $04,$FC                          ;; ?QPWZ?               ;
                                                          ;;                      ;
BlurpSpeedX:          db $08,$F8                          ;; ?QPWZ?               ;
                                                          ;;                      ;
BlurpAccelY:          db $01,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
Blurp:                JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 0384CE : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !EffFrame                     ;; 0384D1 : AD 14 00    ;
                      LSR A                               ;; 0384D4 : 4A          ;
                      LSR A                               ;; 0384D5 : 4A          ;
                      LSR A                               ;; 0384D6 : 4A          ;
                      CLC                                 ;; 0384D7 : 18          ;
                      ADC.W !CurSpriteProcess             ;; 0384D8 : 6D E9 15    ;
                      LSR A                               ;; 0384DB : 4A          ;
                      LDA.B #$A2                          ;; 0384DC : A9 A2       ;
                      BCC CODE_0384E2                     ;; 0384DE : 90 02       ;
                      LDA.B #$EC                          ;; 0384E0 : A9 EC       ;
CODE_0384E2:          STA.W !OAMTileNo+$100,Y             ;; 0384E2 : 99 02 03    ;
                      LDA.W !SpriteStatus,X               ;; 0384E5 : BD C8 14    ;
                      CMP.B #$08                          ;; 0384E8 : C9 08       ;
                      BEQ CODE_0384F5                     ;; 0384EA : F0 09       ;
CODE_0384EC:          LDA.W !OAMTileAttr+$100,Y           ;; 0384EC : B9 03 03    ;
                      ORA.B #$80                          ;; 0384EF : 09 80       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0384F1 : 99 03 03    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0384F5:          LDA.B !SpriteLock                   ;; 0384F5 : A5 9D       ;
                      BNE Return03852A                    ;; 0384F7 : D0 31       ;
                      JSR SubOffscreen0Bnk3               ;; 0384F9 : 20 5D B8    ;
                      LDA.B !EffFrame                     ;; 0384FC : A5 14       ;
                      AND.B #$03                          ;; 0384FE : 29 03       ;
                      BNE CODE_038516                     ;; 038500 : D0 14       ;
                      LDA.B !SpriteTableC2,X              ;; 038502 : B5 C2       ;
                      AND.B #$01                          ;; 038504 : 29 01       ;
                      TAY                                 ;; 038506 : A8          ;
                      LDA.B !SpriteYSpeed,X               ;; 038507 : B5 AA       ;
                      CLC                                 ;; 038509 : 18          ;
                      ADC.W BlurpAccelY,Y                 ;; 03850A : 79 C8 84    ;
                      STA.B !SpriteYSpeed,X               ;; 03850D : 95 AA       ;
                      CMP.W BlurpMaxSpeedY,Y              ;; 03850F : D9 C4 84    ;
                      BNE CODE_038516                     ;; 038512 : D0 02       ;
                      INC.B !SpriteTableC2,X              ;; 038514 : F6 C2       ;
CODE_038516:          LDY.W !SpriteMisc157C,X             ;; 038516 : BC 7C 15    ;
                      LDA.W BlurpSpeedX,Y                 ;; 038519 : B9 C6 84    ;
                      STA.B !SpriteXSpeed,X               ;; 03851C : 95 B6       ;
                      JSL UpdateXPosNoGvtyW               ;; 03851E : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 038522 : 22 1A 80 01 ;
                      JSL SprSpr_MarioSprRts              ;; 038526 : 22 3A 80 01 ;
Return03852A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
PorcuPuffAccel:       db $01,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
PorcuPuffMaxSpeed:    db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
PorcuPuffer:          JSR CODE_0385A3                     ;; ?QPWZ? : 20 A3 85    ;
                      LDA.B !SpriteLock                   ;; 038532 : A5 9D       ;
                      BNE Return038586                    ;; 038534 : D0 50       ;
                      LDA.W !SpriteStatus,X               ;; 038536 : BD C8 14    ;
                      CMP.B #$08                          ;; 038539 : C9 08       ;
                      BNE Return038586                    ;; 03853B : D0 49       ;
                      JSR SubOffscreen0Bnk3               ;; 03853D : 20 5D B8    ;
                      JSL SprSpr_MarioSprRts              ;; 038540 : 22 3A 80 01 ;
                      JSR SubHorzPosBnk3                  ;; 038544 : 20 17 B8    ;
                      TYA                                 ;; 038547 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 038548 : 9D 7C 15    ;
                      LDA.B !EffFrame                     ;; 03854B : A5 14       ;
                      AND.B #$03                          ;; 03854D : 29 03       ;
                      BNE CODE_03855E                     ;; 03854F : D0 0D       ;
                      LDA.B !SpriteXSpeed,X               ;; 038551 : B5 B6       ; \ Branch if at max speed 
                      CMP.W PorcuPuffMaxSpeed,Y           ;; 038553 : D9 2D 85    ;  | 
                      BEQ CODE_03855E                     ;; 038556 : F0 06       ; / 
                      CLC                                 ;; 038558 : 18          ; \ Otherwise, accelerate 
                      ADC.W PorcuPuffAccel,Y              ;; 038559 : 79 2B 85    ;  | 
                      STA.B !SpriteXSpeed,X               ;; 03855C : 95 B6       ; / 
CODE_03855E:          LDA.B !SpriteXSpeed,X               ;; 03855E : B5 B6       ;
                      PHA                                 ;; 038560 : 48          ;
                      LDA.W !Layer1DXPos                  ;; 038561 : AD BD 17    ;
                      ASL A                               ;; 038564 : 0A          ;
                      ASL A                               ;; 038565 : 0A          ;
                      ASL A                               ;; 038566 : 0A          ;
                      CLC                                 ;; 038567 : 18          ;
                      ADC.B !SpriteXSpeed,X               ;; 038568 : 75 B6       ;
                      STA.B !SpriteXSpeed,X               ;; 03856A : 95 B6       ;
                      JSL UpdateXPosNoGvtyW               ;; 03856C : 22 22 80 01 ;
                      PLA                                 ;; 038570 : 68          ;
                      STA.B !SpriteXSpeed,X               ;; 038571 : 95 B6       ;
                      JSL CODE_019138                     ;; 038573 : 22 38 91 01 ;
                      LDY.B #$04                          ;; 038577 : A0 04       ;
                      LDA.W !SpriteInLiquid,X             ;; 038579 : BD 4A 16    ;
                      BEQ CODE_038580                     ;; 03857C : F0 02       ;
                      LDY.B #$FC                          ;; 03857E : A0 FC       ;
CODE_038580:          STY.B !SpriteYSpeed,X               ;; 038580 : 94 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 038582 : 22 1A 80 01 ;
Return038586:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
PocruPufferDispX:     db $F8,$08,$F8,$08,$08,$F8,$08,$F8  ;; ?QPWZ?               ;
PocruPufferDispY:     db $F8,$F8,$08,$08                  ;; ?QPWZ?               ;
                                                          ;;                      ;
PocruPufferTiles:     db $86,$C0,$A6,$C2,$86,$C0,$A6,$8A  ;; ?QPWZ?               ;
PocruPufferGfxProp:   db $0D,$0D,$0D,$0D,$4D,$4D,$4D,$4D  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_0385A3:          JSR GetDrawInfoBnk3                 ;; 0385A3 : 20 60 B7    ;
                      LDA.B !EffFrame                     ;; 0385A6 : A5 14       ;
                      AND.B #$04                          ;; 0385A8 : 29 04       ;
                      STA.B !_3                           ;; 0385AA : 85 03       ;
                      LDA.W !SpriteMisc157C,X             ;; 0385AC : BD 7C 15    ;
                      STA.B !_2                           ;; 0385AF : 85 02       ;
                      PHX                                 ;; 0385B1 : DA          ;
                      LDX.B #$03                          ;; 0385B2 : A2 03       ;
CODE_0385B4:          LDA.B !_1                           ;; 0385B4 : A5 01       ;
                      CLC                                 ;; 0385B6 : 18          ;
                      ADC.W PocruPufferDispY,X            ;; 0385B7 : 7D 8F 85    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 0385BA : 99 01 03    ;
                      PHX                                 ;; 0385BD : DA          ;
                      LDA.B !_2                           ;; 0385BE : A5 02       ;
                      BNE CODE_0385C6                     ;; 0385C0 : D0 04       ;
                      TXA                                 ;; 0385C2 : 8A          ;
                      ORA.B #$04                          ;; 0385C3 : 09 04       ;
                      TAX                                 ;; 0385C5 : AA          ;
CODE_0385C6:          LDA.B !_0                           ;; 0385C6 : A5 00       ;
                      CLC                                 ;; 0385C8 : 18          ;
                      ADC.W PocruPufferDispX,X            ;; 0385C9 : 7D 87 85    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 0385CC : 99 00 03    ;
                      LDA.W PocruPufferGfxProp,X          ;; 0385CF : BD 9B 85    ;
                      ORA.B !SpriteProperties             ;; 0385D2 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0385D4 : 99 03 03    ;
                      PLA                                 ;; 0385D7 : 68          ;
                      PHA                                 ;; 0385D8 : 48          ;
                      ORA.B !_3                           ;; 0385D9 : 05 03       ;
                      TAX                                 ;; 0385DB : AA          ;
                      LDA.W PocruPufferTiles,X            ;; 0385DC : BD 93 85    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0385DF : 99 02 03    ;
                      PLX                                 ;; 0385E2 : FA          ;
                      INY                                 ;; 0385E3 : C8          ;
                      INY                                 ;; 0385E4 : C8          ;
                      INY                                 ;; 0385E5 : C8          ;
                      INY                                 ;; 0385E6 : C8          ;
                      DEX                                 ;; 0385E7 : CA          ;
                      BPL CODE_0385B4                     ;; 0385E8 : 10 CA       ;
                      PLX                                 ;; 0385EA : FA          ;
                      LDY.B #$02                          ;; 0385EB : A0 02       ;
                      LDA.B #$03                          ;; 0385ED : A9 03       ;
                      JSL FinishOAMWrite                  ;; 0385EF : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FlyingBlockSpeedY:    db $08,$F8                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FlyingTurnBlocks:     JSR CODE_0386A8                     ;; ?QPWZ? : 20 A8 86    ;
                      LDA.B !SpriteLock                   ;; 0385F9 : A5 9D       ;
                      BNE Return038675                    ;; 0385FB : D0 78       ;
                      LDA.W !BGFastScrollActive           ;; 0385FD : AD 9A 1B    ;
                      BEQ CODE_038629                     ;; 038600 : F0 27       ;
                      LDA.W !SpriteMisc1534,X             ;; 038602 : BD 34 15    ;
                      INC.W !SpriteMisc1534,X             ;; 038605 : FE 34 15    ;
                      AND.B #$01                          ;; 038608 : 29 01       ;
                      BNE CODE_03861E                     ;; 03860A : D0 12       ;
                      DEC.W !SpriteMisc1602,X             ;; 03860C : DE 02 16    ;
                      LDA.W !SpriteMisc1602,X             ;; 03860F : BD 02 16    ;
                      CMP.B #$FF                          ;; 038612 : C9 FF       ;
                      BNE CODE_03861E                     ;; 038614 : D0 08       ;
                      LDA.B #$FF                          ;; 038616 : A9 FF       ;
                      STA.W !SpriteMisc1602,X             ;; 038618 : 9D 02 16    ;
                      INC.W !SpriteMisc157C,X             ;; 03861B : FE 7C 15    ;
CODE_03861E:          LDA.W !SpriteMisc157C,X             ;; 03861E : BD 7C 15    ;
                      AND.B #$01                          ;; 038621 : 29 01       ;
                      TAY                                 ;; 038623 : A8          ;
                      LDA.W FlyingBlockSpeedY,Y           ;; 038624 : B9 F4 85    ;
                      STA.B !SpriteYSpeed,X               ;; 038627 : 95 AA       ;
CODE_038629:          LDA.B !SpriteYSpeed,X               ;; 038629 : B5 AA       ;
                      PHA                                 ;; 03862B : 48          ;
                      LDY.W !SpriteMisc151C,X             ;; 03862C : BC 1C 15    ;
                      BNE CODE_038636                     ;; 03862F : D0 05       ;
                      EOR.B #$FF                          ;; 038631 : 49 FF       ;
                      INC A                               ;; 038633 : 1A          ;
                      STA.B !SpriteYSpeed,X               ;; 038634 : 95 AA       ;
CODE_038636:          JSL UpdateYPosNoGvtyW               ;; 038636 : 22 1A 80 01 ;
                      PLA                                 ;; 03863A : 68          ;
                      STA.B !SpriteYSpeed,X               ;; 03863B : 95 AA       ;
                      LDA.W !BGFastScrollActive           ;; 03863D : AD 9A 1B    ;
                      STA.B !SpriteXSpeed,X               ;; 038640 : 95 B6       ;
                      JSL UpdateXPosNoGvtyW               ;; 038642 : 22 22 80 01 ;
                      STA.W !SpriteMisc1528,X             ;; 038646 : 9D 28 15    ;
                      JSL InvisBlkMainRt                  ;; 038649 : 22 4F B4 01 ;
                      BCC Return038675                    ;; 03864D : 90 26       ;
                      LDA.W !BGFastScrollActive           ;; 03864F : AD 9A 1B    ;
                      BNE Return038675                    ;; 038652 : D0 21       ;
                      LDA.B #$08                          ;; 038654 : A9 08       ;
                      STA.W !BGFastScrollActive           ;; 038656 : 8D 9A 1B    ;
                      LDA.B #$7F                          ;; 038659 : A9 7F       ;
                      STA.W !SpriteMisc1602,X             ;; 03865B : 9D 02 16    ;
                      LDY.B #$09                          ;; 03865E : A0 09       ;
CODE_038660:          CPY.W !CurSpriteProcess             ;; 038660 : CC E9 15    ;
                      BEQ CODE_03866C                     ;; 038663 : F0 07       ;
                      LDA.W !SpriteNumber,Y               ;; 038665 : B9 9E 00    ;
                      CMP.B #$C1                          ;; 038668 : C9 C1       ;
                      BEQ CODE_038670                     ;; 03866A : F0 04       ;
CODE_03866C:          DEY                                 ;; 03866C : 88          ;
                      BPL CODE_038660                     ;; 03866D : 10 F1       ;
                      INY                                 ;; 03866F : C8          ;
CODE_038670:          LDA.B #$7F                          ;; 038670 : A9 7F       ;
                      STA.W !SpriteMisc1602,Y             ;; 038672 : 99 02 16    ;
Return038675:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ForestPlatDispX:      db $00,$10,$20,$F2,$2E,$00,$10,$20  ;; ?QPWZ?               ;
                      db $FA,$2E                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatDispY:      db $00,$00,$00,$F6,$F6,$00,$00,$00  ;; ?QPWZ?               ;
                      db $FE,$FE                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatTiles:      db $40,$40,$40,$C6,$C6,$40,$40,$40  ;; ?QPWZ?               ;
                      db $5D,$5D                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatGfxProp:    db $32,$32,$32,$72,$32,$32,$32,$32  ;; ?QPWZ?               ;
                      db $72,$32                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ForestPlatTileSize:   db $02,$02,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_0386A8:          JSR GetDrawInfoBnk3                 ;; 0386A8 : 20 60 B7    ;
                      LDY.W !SpriteOAMIndex,X             ;; 0386AB : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B !EffFrame                     ;; 0386AE : A5 14       ;
                      LSR A                               ;; 0386B0 : 4A          ;
                      AND.B #$04                          ;; 0386B1 : 29 04       ;
                      BEQ CODE_0386B6                     ;; 0386B3 : F0 01       ;
                      INC A                               ;; 0386B5 : 1A          ;
CODE_0386B6:          STA.B !_2                           ;; 0386B6 : 85 02       ;
                      PHX                                 ;; 0386B8 : DA          ;
                      LDX.B #$04                          ;; 0386B9 : A2 04       ;
CODE_0386BB:          STX.B !_6                           ;; 0386BB : 86 06       ;
                      TXA                                 ;; 0386BD : 8A          ;
                      CLC                                 ;; 0386BE : 18          ;
                      ADC.B !_2                           ;; 0386BF : 65 02       ;
                      TAX                                 ;; 0386C1 : AA          ;
                      LDA.B !_0                           ;; 0386C2 : A5 00       ;
                      CLC                                 ;; 0386C4 : 18          ;
                      ADC.W ForestPlatDispX,X             ;; 0386C5 : 7D 76 86    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 0386C8 : 99 00 03    ;
                      LDA.B !_1                           ;; 0386CB : A5 01       ;
                      CLC                                 ;; 0386CD : 18          ;
                      ADC.W ForestPlatDispY,X             ;; 0386CE : 7D 80 86    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 0386D1 : 99 01 03    ;
                      LDA.W ForestPlatTiles,X             ;; 0386D4 : BD 8A 86    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0386D7 : 99 02 03    ;
                      LDA.W ForestPlatGfxProp,X           ;; 0386DA : BD 94 86    ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0386DD : 99 03 03    ;
                      PHY                                 ;; 0386E0 : 5A          ;
                      TYA                                 ;; 0386E1 : 98          ;
                      LSR A                               ;; 0386E2 : 4A          ;
                      LSR A                               ;; 0386E3 : 4A          ;
                      TAY                                 ;; 0386E4 : A8          ;
                      LDA.W ForestPlatTileSize,X          ;; 0386E5 : BD 9E 86    ;
                      STA.W !OAMTileSize+$40,Y            ;; 0386E8 : 99 60 04    ;
                      PLY                                 ;; 0386EB : 7A          ;
                      INY                                 ;; 0386EC : C8          ;
                      INY                                 ;; 0386ED : C8          ;
                      INY                                 ;; 0386EE : C8          ;
                      INY                                 ;; 0386EF : C8          ;
                      LDX.B !_6                           ;; 0386F0 : A6 06       ;
                      DEX                                 ;; 0386F2 : CA          ;
                      BPL CODE_0386BB                     ;; 0386F3 : 10 C6       ;
                      PLX                                 ;; 0386F5 : FA          ;
                      LDY.B #$FF                          ;; 0386F6 : A0 FF       ;
                      LDA.B #$04                          ;; 0386F8 : A9 04       ;
                      JSL FinishOAMWrite                  ;; 0386FA : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GrayLavaPlatform:     JSR CODE_03873A                     ;; ?QPWZ? : 20 3A 87    ;
                      LDA.B !SpriteLock                   ;; 038702 : A5 9D       ;
                      BNE Return038733                    ;; 038704 : D0 2D       ;
                      JSR SubOffscreen0Bnk3               ;; 038706 : 20 5D B8    ;
                      LDA.W !SpriteMisc1540,X             ;; 038709 : BD 40 15    ;
                      DEC A                               ;; 03870C : 3A          ;
                      BNE CODE_03871B                     ;; 03870D : D0 0C       ;
                      LDY.W !SpriteLoadIndex,X            ;; 03870F : BC 1A 16    ; \ 
                      LDA.B #$00                          ;; 038712 : A9 00       ;  | Allow sprite to be reloaded by level loading routine 
                      STA.W !SpriteLoadStatus,Y           ;; 038714 : 99 38 19    ; / 
                      STZ.W !SpriteStatus,X               ;; 038717 : 9E C8 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03871B:          JSL UpdateYPosNoGvtyW               ;; 03871B : 22 1A 80 01 ;
                      JSL InvisBlkMainRt                  ;; 03871F : 22 4F B4 01 ;
                      BCC Return038733                    ;; 038723 : 90 0E       ;
                      LDA.W !SpriteMisc1540,X             ;; 038725 : BD 40 15    ;
                      BNE Return038733                    ;; 038728 : D0 09       ;
                      LDA.B #$06                          ;; 03872A : A9 06       ;
                      STA.B !SpriteYSpeed,X               ;; 03872C : 95 AA       ;
                      LDA.B #$40                          ;; 03872E : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 038730 : 9D 40 15    ;
Return038733:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
LavaPlatTiles:        db $85,$86,$85                      ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_038737:          db $43,$03,$03                      ;; 038737               ;
                                                          ;;                      ;
CODE_03873A:          JSR GetDrawInfoBnk3                 ;; 03873A : 20 60 B7    ;
                      PHX                                 ;; 03873D : DA          ;
                      LDX.B #$02                          ;; 03873E : A2 02       ;
CODE_038740:          LDA.B !_0                           ;; 038740 : A5 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038742 : 99 00 03    ;
                      CLC                                 ;; 038745 : 18          ;
                      ADC.B #$10                          ;; 038746 : 69 10       ;
                      STA.B !_0                           ;; 038748 : 85 00       ;
                      LDA.B !_1                           ;; 03874A : A5 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03874C : 99 01 03    ;
                      LDA.W LavaPlatTiles,X               ;; 03874F : BD 34 87    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038752 : 99 02 03    ;
                      LDA.W DATA_038737,X                 ;; 038755 : BD 37 87    ;
                      ORA.B !SpriteProperties             ;; 038758 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03875A : 99 03 03    ;
                      INY                                 ;; 03875D : C8          ;
                      INY                                 ;; 03875E : C8          ;
                      INY                                 ;; 03875F : C8          ;
                      INY                                 ;; 038760 : C8          ;
                      DEX                                 ;; 038761 : CA          ;
                      BPL CODE_038740                     ;; 038762 : 10 DC       ;
                      PLX                                 ;; 038764 : FA          ;
                      LDY.B #$02                          ;; 038765 : A0 02       ;
                      LDA.B #$02                          ;; 038767 : A9 02       ;
                      JSL FinishOAMWrite                  ;; 038769 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MegaMoleSpeed:        db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMole:             JSR MegaMoleGfxRt                   ;; ?QPWZ? : 20 3F 88    ; Graphics routine		       
                      LDA.W !SpriteStatus,X               ;; 038773 : BD C8 14    ; \ 			       
                      CMP.B #$08                          ;; 038776 : C9 08       ;  | If status != 8, return	       
                      BNE Return038733                    ;; 038778 : D0 B9       ; /				       
                      JSR SubOffscreen3Bnk3               ;; 03877A : 20 4F B8    ; Handle off screen situation      
                      LDY.W !SpriteMisc157C,X             ;; 03877D : BC 7C 15    ; \ Set x speed based on direction 
                      LDA.W MegaMoleSpeed,Y               ;; 038780 : B9 6E 87    ;  |			       
                      STA.B !SpriteXSpeed,X               ;; 038783 : 95 B6       ; /				       
                      LDA.B !SpriteLock                   ;; 038785 : A5 9D       ; \ If sprites locked, return      
                      BNE Return038733                    ;; 038787 : D0 AA       ; /                                
                      LDA.W !SpriteBlockedDirs,X          ;; 038789 : BD 88 15    ;
                      AND.B #$04                          ;; 03878C : 29 04       ;
                      PHA                                 ;; 03878E : 48          ;
                      JSL UpdateSpritePos                 ;; 03878F : 22 2A 80 01 ; Update position based on speed values 
                      JSL SprSprInteract                  ;; 038793 : 22 32 80 01 ; Interact with other sprites 
                      LDA.W !SpriteBlockedDirs,X          ;; 038797 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 03879A : 29 04       ;  | 
                      BEQ MegaMoleInAir                   ;; 03879C : F0 05       ; / 
                      STZ.B !SpriteYSpeed,X               ;; 03879E : 74 AA       ; Sprite Y Speed = 0 
                      PLA                                 ;; 0387A0 : 68          ;
                      BRA MegaMoleOnGround                ;; 0387A1 : 80 0F       ;
                                                          ;;                      ;
MegaMoleInAir:        PLA                                 ;; ?QPWZ? : 68          ;
                      BEQ MegaMoleWasInAir                ;; 0387A4 : F0 05       ;
                      LDA.B #$0A                          ;; 0387A6 : A9 0A       ;
                      STA.W !SpriteMisc1540,X             ;; 0387A8 : 9D 40 15    ;
MegaMoleWasInAir:     LDA.W !SpriteMisc1540,X             ;; ?QPWZ? : BD 40 15    ;
                      BEQ MegaMoleOnGround                ;; 0387AE : F0 02       ;
                      STZ.B !SpriteYSpeed,X               ;; 0387B0 : 74 AA       ; Sprite Y Speed = 0 
MegaMoleOnGround:     LDY.W !SpriteMisc15AC,X             ;; ?QPWZ? : BC AC 15    ; \								   
                      LDA.W !SpriteBlockedDirs,X          ;; 0387B5 : BD 88 15    ; | If Mega Mole is in contact with an object...		   
                      AND.B #$03                          ;; 0387B8 : 29 03       ; |								   
                      BEQ CODE_0387CD                     ;; 0387BA : F0 11       ; |								   
                      CPY.B #$00                          ;; 0387BC : C0 00       ; |    ... and timer hasn't been set (time until flip == 0)... 
                      BNE CODE_0387C5                     ;; 0387BE : D0 05       ; |								   
                      LDA.B #$10                          ;; 0387C0 : A9 10       ; |    ... set time until flip				   
                      STA.W !SpriteMisc15AC,X             ;; 0387C2 : 9D AC 15    ; /								   
CODE_0387C5:          LDA.W !SpriteMisc157C,X             ;; 0387C5 : BD 7C 15    ; \ Flip the temp direction status				   
                      EOR.B #$01                          ;; 0387C8 : 49 01       ; |								   
                      STA.W !SpriteMisc157C,X             ;; 0387CA : 9D 7C 15    ; /								   
CODE_0387CD:          CPY.B #$00                          ;; 0387CD : C0 00       ; \ If time until flip == 0...				   
                      BNE CODE_0387D7                     ;; 0387CF : D0 06       ; |								   
                      LDA.W !SpriteMisc157C,X             ;; 0387D1 : BD 7C 15    ; |    ...update the direction status used by the gfx routine  
                      STA.W !SpriteMisc151C,X             ;; 0387D4 : 9D 1C 15    ; /                                                            
CODE_0387D7:          JSL MarioSprInteract                ;; 0387D7 : 22 DC A7 01 ; Check for mario/Mega Mole contact 
                      BCC Return03882A                    ;; 0387DB : 90 4D       ; (Carry set = contact) 
                      JSR SubVertPosBnk3                  ;; 0387DD : 20 29 B8    ;
                      LDA.B !_E                           ;; 0387E0 : A5 0E       ;
                      CMP.B #$D8                          ;; 0387E2 : C9 D8       ;
                      BPL MegaMoleContact                 ;; 0387E4 : 10 38       ;
                      LDA.B !PlayerYSpeed                 ;; 0387E6 : A5 7D       ;
                      BMI Return03882A                    ;; 0387E8 : 30 40       ;
                      LDA.B #$01                          ;; 0387EA : A9 01       ; \ Set "on sprite" flag				     
                      STA.W !StandOnSolidSprite           ;; 0387EC : 8D 71 14    ; /							     
                      LDA.B #$06                          ;; 0387EF : A9 06       ; \ Set riding Mega Mole				     
                      STA.W !SpriteMisc154C,X             ;; 0387F1 : 9D 4C 15    ; / 						     
                      STZ.B !PlayerYSpeed                 ;; 0387F4 : 64 7D       ; Y speed = 0					     
                      LDA.B #$D6                          ;; 0387F6 : A9 D6       ; \							     
                      LDY.W !PlayerRidingYoshi            ;; 0387F8 : AC 7A 18    ; | Mario's y position += C6 or D6 depending if on yoshi 
                      BEQ MegaMoleNoYoshi                 ;; 0387FB : F0 02       ; |							     
                      LDA.B #$C6                          ;; 0387FD : A9 C6       ; |							     
MegaMoleNoYoshi:      CLC                                 ;; ?QPWZ? : 18          ; |							     
                      ADC.B !SpriteYPosLow,X              ;; 038800 : 75 D8       ; |							     
                      STA.B !PlayerYPosNext               ;; 038802 : 85 96       ; |							     
                      LDA.W !SpriteXPosHigh,X             ;; 038804 : BD D4 14    ; |							     
                      ADC.B #$FF                          ;; 038807 : 69 FF       ; |							     
                      STA.B !PlayerYPosNext+1             ;; 038809 : 85 97       ; /							     
                      LDY.B #$00                          ;; 03880B : A0 00       ; \ 						     
                      LDA.W !SpriteXMovement              ;; 03880D : AD 91 14    ; | $1491 == 01 or FF, depending on direction	     
                      BPL CODE_038813                     ;; 038810 : 10 01       ; | Set mario's new x position			     
                      DEY                                 ;; 038812 : 88          ; |							     
CODE_038813:          CLC                                 ;; 038813 : 18          ; |							     
                      ADC.B !PlayerXPosNext               ;; 038814 : 65 94       ; |							     
                      STA.B !PlayerXPosNext               ;; 038816 : 85 94       ; |							     
                      TYA                                 ;; 038818 : 98          ; |							     
                      ADC.B !PlayerXPosNext+1             ;; 038819 : 65 95       ; |							     
                      STA.B !PlayerXPosNext+1             ;; 03881B : 85 95       ;  /							   
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
MegaMoleContact:      LDA.W !SpriteMisc154C,X             ;; ?QPWZ? : BD 4C 15    ; \ If riding Mega Mole...				     
                      ORA.W !SpriteOnYoshiTongue,X        ;; 038821 : 1D D0 15    ; |   ...or Mega Mole being eaten...		     
                      BNE Return03882A                    ;; 038824 : D0 04       ; /   ...return					     
                      JSL HurtMario                       ;; 038826 : 22 B7 F5 00 ; Hurt mario					     
Return03882A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MegaMoleTileDispX:    db $00,$10,$00,$10,$10,$00,$10,$00  ;; ?QPWZ?               ;
MegaMoleTileDispY:    db $F0,$F0,$00,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMoleTiles:        db $C6,$C8,$E6,$E8,$CA,$CC,$EA,$EC  ;; ?QPWZ?               ;
                                                          ;;                      ;
MegaMoleGfxRt:        JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc151C,X             ;; 038842 : BD 1C 15    ; \ $02 = direction						      
                      STA.B !_2                           ;; 038845 : 85 02       ; / 							      
                      LDA.B !EffFrame                     ;; 038847 : A5 14       ; \ 							      
                      LSR A                               ;; 038849 : 4A          ; |								      
                      LSR A                               ;; 03884A : 4A          ; |								      
                      NOP                                 ;; 03884B : EA          ; |								      
                      CLC                                 ;; 03884C : 18          ; |								      
                      ADC.W !CurSpriteProcess             ;; 03884D : 6D E9 15    ; |								      
                      AND.B #$01                          ;; 038850 : 29 01       ; |								      
                      ASL A                               ;; 038852 : 0A          ; |								      
                      ASL A                               ;; 038853 : 0A          ; |								      
                      STA.B !_3                           ;; 038854 : 85 03       ; | $03 = index to frame start (0 or 4)			      
                      PHX                                 ;; 038856 : DA          ; /								      
                      LDX.B #$03                          ;; 038857 : A2 03       ; Run loop 4 times, cuz 4 tiles per frame			      
MegaMoleGfxLoopSt:    PHX                                 ;; ?QPWZ? : DA          ; Push, current tile					      
                      LDA.B !_2                           ;; 03885A : A5 02       ; \								      
                      BNE MegaMoleFaceLeft                ;; 03885C : D0 04       ; | If facing right, index to frame end += 4		      
                      INX                                 ;; 03885E : E8          ; |								      
                      INX                                 ;; 03885F : E8          ; |								      
                      INX                                 ;; 038860 : E8          ; |								      
                      INX                                 ;; 038861 : E8          ; /								      
MegaMoleFaceLeft:     LDA.B !_0                           ;; ?QPWZ? : A5 00       ; \ Tile x position = sprite x location ($00) + tile displacement 
                      CLC                                 ;; 038864 : 18          ; |								      
                      ADC.W MegaMoleTileDispX,X           ;; 038865 : 7D 2B 88    ; |								      
                      STA.W !OAMTileXPos+$100,Y           ;; 038868 : 99 00 03    ; /								      
                      PLX                                 ;; 03886B : FA          ; \ Pull, X = index to frame end				      
                      LDA.B !_1                           ;; 03886C : A5 01       ; |								      
                      CLC                                 ;; 03886E : 18          ; | Tile y position = sprite y location ($01) + tile displacement 
                      ADC.W MegaMoleTileDispY,X           ;; 03886F : 7D 33 88    ; |						    
                      STA.W !OAMTileYPos+$100,Y           ;; 038872 : 99 01 03    ; /						    
                      PHX                                 ;; 038875 : DA          ; \ Set current tile			    
                      TXA                                 ;; 038876 : 8A          ; | X = index of frame start + current tile	    
                      CLC                                 ;; 038877 : 18          ; |						    
                      ADC.B !_3                           ;; 038878 : 65 03       ; |						    
                      TAX                                 ;; 03887A : AA          ; |						    
                      LDA.W MegaMoleTiles,X               ;; 03887B : BD 37 88    ; |						    
                      STA.W !OAMTileNo+$100,Y             ;; 03887E : 99 02 03    ; /						    
                      LDA.B #$01                          ;; 038881 : A9 01       ; Tile properties xyppccct, format		    
                      LDX.B !_2                           ;; 038883 : A6 02       ; \ If direction == 0...			    
                      BNE MegaMoleGfxNoFlip               ;; 038885 : D0 02       ; |						    
                      ORA.B #$40                          ;; 038887 : 09 40       ; /    ...flip tile				    
MegaMoleGfxNoFlip:    ORA.B !SpriteProperties             ;; ?QPWZ? : 05 64       ; Add in tile priority of level		    
                      STA.W !OAMTileAttr+$100,Y           ;; 03888B : 99 03 03    ; Store tile properties			    
                      PLX                                 ;; 03888E : FA          ; \ Pull, current tile			    
                      INY                                 ;; 03888F : C8          ; | Increase index to sprite tile map ($300)... 
                      INY                                 ;; 038890 : C8          ; |    ...we wrote 4 bytes    
                      INY                                 ;; 038891 : C8          ; |    ...so increment 4 times 
                      INY                                 ;; 038892 : C8          ; |     
                      DEX                                 ;; 038893 : CA          ; | Go to next tile of frame and loop	    
                      BPL MegaMoleGfxLoopSt               ;; 038894 : 10 C3       ; /                                             
                      PLX                                 ;; 038896 : FA          ; Pull, X = sprite index			    
                      LDY.B #$02                          ;; 038897 : A0 02       ; \ Will write 02 to $0460 (all 16x16 tiles) 
                      LDA.B #$03                          ;; 038899 : A9 03       ; | A = number of tiles drawn - 1		    
                      JSL FinishOAMWrite                  ;; 03889B : 22 B3 B7 01 ; / Don't draw if offscreen			    
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BatTiles:             db $AE,$C0,$E8                      ;; ?QPWZ?               ;
                                                          ;;                      ;
Swooper:              JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 0388A7 : BC EA 15    ; Y = Index into sprite OAM 
                      PHX                                 ;; 0388AA : DA          ;
                      LDA.W !SpriteMisc1602,X             ;; 0388AB : BD 02 16    ;
                      TAX                                 ;; 0388AE : AA          ;
                      LDA.W BatTiles,X                    ;; 0388AF : BD A0 88    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0388B2 : 99 02 03    ;
                      PLX                                 ;; 0388B5 : FA          ;
                      LDA.W !SpriteStatus,X               ;; 0388B6 : BD C8 14    ;
                      CMP.B #$08                          ;; 0388B9 : C9 08       ;
                      BEQ CODE_0388C0                     ;; 0388BB : F0 03       ;
                      JMP CODE_0384EC                     ;; 0388BD : 4C EC 84    ;
                                                          ;;                      ;
CODE_0388C0:          LDA.B !SpriteLock                   ;; 0388C0 : A5 9D       ;
                      BNE Return0388DF                    ;; 0388C2 : D0 1B       ;
                      JSR SubOffscreen0Bnk3               ;; 0388C4 : 20 5D B8    ;
                      JSL SprSpr_MarioSprRts              ;; 0388C7 : 22 3A 80 01 ;
                      JSL UpdateXPosNoGvtyW               ;; 0388CB : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 0388CF : 22 1A 80 01 ;
                      LDA.B !SpriteTableC2,X              ;; 0388D3 : B5 C2       ;
                      JSL ExecutePtr                      ;; 0388D5 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_0388E4                      ;; ?QPWZ? : E4 88       ;
                      dw CODE_038905                      ;; ?QPWZ? : 05 89       ;
                      dw CODE_038936                      ;; ?QPWZ? : 36 89       ;
                                                          ;;                      ;
Return0388DF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0388E0:          db $10,$F0                          ;; 0388E0               ;
                                                          ;;                      ;
DATA_0388E2:          db $01,$FF                          ;; 0388E2               ;
                                                          ;;                      ;
CODE_0388E4:          LDA.W !SpriteOffscreenX,X           ;; 0388E4 : BD A0 15    ;
                      BNE Return038904                    ;; 0388E7 : D0 1B       ;
                      JSR SubHorzPosBnk3                  ;; 0388E9 : 20 17 B8    ;
                      LDA.B !_F                           ;; 0388EC : A5 0F       ;
                      CLC                                 ;; 0388EE : 18          ;
                      ADC.B #$50                          ;; 0388EF : 69 50       ;
                      CMP.B #$A0                          ;; 0388F1 : C9 A0       ;
                      BCS Return038904                    ;; 0388F3 : B0 0F       ;
                      INC.B !SpriteTableC2,X              ;; 0388F5 : F6 C2       ;
                      TYA                                 ;; 0388F7 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 0388F8 : 9D 7C 15    ;
                      LDA.B #$20                          ;; 0388FB : A9 20       ;
                      STA.B !SpriteYSpeed,X               ;; 0388FD : 95 AA       ;
                      LDA.B #$26                          ;; 0388FF : A9 26       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 038901 : 8D FC 1D    ; / 
Return038904:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038905:          LDA.B !TrueFrame                    ;; 038905 : A5 13       ;
                      AND.B #$03                          ;; 038907 : 29 03       ;
                      BNE CODE_038915                     ;; 038909 : D0 0A       ;
                      LDA.B !SpriteYSpeed,X               ;; 03890B : B5 AA       ;
                      BEQ CODE_038915                     ;; 03890D : F0 06       ;
                      DEC.B !SpriteYSpeed,X               ;; 03890F : D6 AA       ;
                      BNE CODE_038915                     ;; 038911 : D0 02       ;
                      INC.B !SpriteTableC2,X              ;; 038913 : F6 C2       ;
CODE_038915:          LDA.B !TrueFrame                    ;; 038915 : A5 13       ;
                      AND.B #$03                          ;; 038917 : 29 03       ;
                      BNE CODE_03892B                     ;; 038919 : D0 10       ;
                      LDY.W !SpriteMisc157C,X             ;; 03891B : BC 7C 15    ;
                      LDA.B !SpriteXSpeed,X               ;; 03891E : B5 B6       ;
                      CMP.W DATA_0388E0,Y                 ;; 038920 : D9 E0 88    ;
                      BEQ CODE_03892B                     ;; 038923 : F0 06       ;
                      CLC                                 ;; 038925 : 18          ;
                      ADC.W DATA_0388E2,Y                 ;; 038926 : 79 E2 88    ;
                      STA.B !SpriteXSpeed,X               ;; 038929 : 95 B6       ;
CODE_03892B:          LDA.B !EffFrame                     ;; 03892B : A5 14       ;
                      AND.B #$04                          ;; 03892D : 29 04       ;
                      LSR A                               ;; 03892F : 4A          ;
                      LSR A                               ;; 038930 : 4A          ;
                      INC A                               ;; 038931 : 1A          ;
                      STA.W !SpriteMisc1602,X             ;; 038932 : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038936:          LDA.B !TrueFrame                    ;; 038936 : A5 13       ;
                      AND.B #$01                          ;; 038938 : 29 01       ;
                      BNE CODE_038952                     ;; 03893A : D0 16       ;
                      LDA.W !SpriteMisc151C,X             ;; 03893C : BD 1C 15    ;
                      AND.B #$01                          ;; 03893F : 29 01       ;
                      TAY                                 ;; 038941 : A8          ;
                      LDA.B !SpriteYSpeed,X               ;; 038942 : B5 AA       ;
                      CLC                                 ;; 038944 : 18          ;
                      ADC.W BlurpAccelY,Y                 ;; 038945 : 79 C8 84    ;
                      STA.B !SpriteYSpeed,X               ;; 038948 : 95 AA       ;
                      CMP.W BlurpMaxSpeedY,Y              ;; 03894A : D9 C4 84    ;
                      BNE CODE_038952                     ;; 03894D : D0 03       ;
                      INC.W !SpriteMisc151C,X             ;; 03894F : FE 1C 15    ;
CODE_038952:          BRA CODE_038915                     ;; 038952 : 80 C1       ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038954:          db $20,$E0                          ;; 038954               ;
                                                          ;;                      ;
DATA_038956:          db $02,$FE                          ;; 038956               ;
                                                          ;;                      ;
SlidingKoopa:         LDA.B #$00                          ;; ?QPWZ? : A9 00       ;
                      LDY.B !SpriteXSpeed,X               ;; 03895A : B4 B6       ;
                      BEQ CODE_038964                     ;; 03895C : F0 06       ;
                      BPL CODE_038961                     ;; 03895E : 10 01       ;
                      INC A                               ;; 038960 : 1A          ;
CODE_038961:          STA.W !SpriteMisc157C,X             ;; 038961 : 9D 7C 15    ;
CODE_038964:          JSL GenericSprGfxRt2                ;; 038964 : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 038968 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !SpriteMisc1558,X             ;; 03896B : BD 58 15    ;
                      CMP.B #$01                          ;; 03896E : C9 01       ;
                      BNE CODE_038983                     ;; 038970 : D0 11       ;
                      LDA.W !SpriteMisc157C,X             ;; 038972 : BD 7C 15    ;
                      PHA                                 ;; 038975 : 48          ;
                      LDA.B #$02                          ;; 038976 : A9 02       ;
                      STA.B !SpriteNumber,X               ;; 038978 : 95 9E       ;
                      JSL InitSpriteTables                ;; 03897A : 22 D2 F7 07 ;
                      PLA                                 ;; 03897E : 68          ;
                      STA.W !SpriteMisc157C,X             ;; 03897F : 9D 7C 15    ;
                      SEC                                 ;; 038982 : 38          ;
CODE_038983:          LDA.B #$86                          ;; 038983 : A9 86       ;
                      BCC CODE_038989                     ;; 038985 : 90 02       ;
                      LDA.B #$E0                          ;; 038987 : A9 E0       ;
CODE_038989:          STA.W !OAMTileNo+$100,Y             ;; 038989 : 99 02 03    ;
                      LDA.W !SpriteStatus,X               ;; 03898C : BD C8 14    ;
                      CMP.B #$08                          ;; 03898F : C9 08       ;
                      BNE Return0389FE                    ;; 038991 : D0 6B       ;
                      JSR SubOffscreen0Bnk3               ;; 038993 : 20 5D B8    ;
                      JSL SprSpr_MarioSprRts              ;; 038996 : 22 3A 80 01 ;
                      LDA.B !SpriteLock                   ;; 03899A : A5 9D       ;
                      ORA.W !SpriteMisc1540,X             ;; 03899C : 1D 40 15    ;
                      ORA.W !SpriteMisc1558,X             ;; 03899F : 1D 58 15    ;
                      BNE Return0389FE                    ;; 0389A2 : D0 5A       ;
                      JSL UpdateSpritePos                 ;; 0389A4 : 22 2A 80 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 0389A8 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 0389AB : 29 04       ;  | 
                      BEQ Return0389FE                    ;; 0389AD : F0 4F       ; / 
                      JSR CODE_0389FF                     ;; 0389AF : 20 FF 89    ;
                      LDY.B #$00                          ;; 0389B2 : A0 00       ;
                      LDA.B !SpriteXSpeed,X               ;; 0389B4 : B5 B6       ;
                      BEQ CODE_0389CC                     ;; 0389B6 : F0 14       ;
                      BPL CODE_0389BD                     ;; 0389B8 : 10 03       ;
                      EOR.B #$FF                          ;; 0389BA : 49 FF       ;
                      INC A                               ;; 0389BC : 1A          ;
CODE_0389BD:          STA.B !_0                           ;; 0389BD : 85 00       ;
                      LDA.W !SpriteSlope,X                ;; 0389BF : BD B8 15    ;
                      BEQ CODE_0389CC                     ;; 0389C2 : F0 08       ;
                      LDY.B !_0                           ;; 0389C4 : A4 00       ;
                      EOR.B !SpriteXSpeed,X               ;; 0389C6 : 55 B6       ;
                      BPL CODE_0389CC                     ;; 0389C8 : 10 02       ;
                      LDY.B #$D0                          ;; 0389CA : A0 D0       ;
CODE_0389CC:          STY.B !SpriteYSpeed,X               ;; 0389CC : 94 AA       ;
                      LDA.B !TrueFrame                    ;; 0389CE : A5 13       ;
                      AND.B #$01                          ;; 0389D0 : 29 01       ;
                      BNE Return0389FE                    ;; 0389D2 : D0 2A       ;
                      LDA.W !SpriteSlope,X                ;; 0389D4 : BD B8 15    ;
                      BNE CODE_0389EC                     ;; 0389D7 : D0 13       ;
                      LDA.B !SpriteXSpeed,X               ;; 0389D9 : B5 B6       ;
                      BNE CODE_0389E3                     ;; 0389DB : D0 06       ;
                      LDA.B #$20                          ;; 0389DD : A9 20       ;
                      STA.W !SpriteMisc1558,X             ;; 0389DF : 9D 58 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389E3:          BPL CODE_0389E9                     ;; 0389E3 : 10 04       ;
                      INC.B !SpriteXSpeed,X               ;; 0389E5 : F6 B6       ;
                      INC.B !SpriteXSpeed,X               ;; 0389E7 : F6 B6       ;
CODE_0389E9:          DEC.B !SpriteXSpeed,X               ;; 0389E9 : D6 B6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389EC:          ASL A                               ;; 0389EC : 0A          ;
                      ROL A                               ;; 0389ED : 2A          ;
                      AND.B #$01                          ;; 0389EE : 29 01       ;
                      TAY                                 ;; 0389F0 : A8          ;
                      LDA.B !SpriteXSpeed,X               ;; 0389F1 : B5 B6       ;
                      CMP.W DATA_038954,Y                 ;; 0389F3 : D9 54 89    ;
                      BEQ Return0389FE                    ;; 0389F6 : F0 06       ;
                      CLC                                 ;; 0389F8 : 18          ;
                      ADC.W DATA_038956,Y                 ;; 0389F9 : 79 56 89    ;
                      STA.B !SpriteXSpeed,X               ;; 0389FC : 95 B6       ;
Return0389FE:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0389FF:          LDA.B !SpriteXSpeed,X               ;; 0389FF : B5 B6       ;
                      BEQ Return038A20                    ;; 038A01 : F0 1D       ;
                      LDA.B !TrueFrame                    ;; 038A03 : A5 13       ;
                      AND.B #$03                          ;; 038A05 : 29 03       ;
                      BNE Return038A20                    ;; 038A07 : D0 17       ;
                      LDA.B #$04                          ;; 038A09 : A9 04       ;
                      STA.B !_0                           ;; 038A0B : 85 00       ;
                      LDA.B #$0A                          ;; 038A0D : A9 0A       ;
                      STA.B !_1                           ;; 038A0F : 85 01       ;
                      JSR IsSprOffScreenBnk3              ;; 038A11 : 20 FB B8    ;
                      BNE Return038A20                    ;; 038A14 : D0 0A       ;
                      LDY.B #$03                          ;; 038A16 : A0 03       ;
CODE_038A18:          LDA.W !SmokeSpriteNumber,Y          ;; 038A18 : B9 C0 17    ;
                      BEQ CODE_038A21                     ;; 038A1B : F0 04       ;
                      DEY                                 ;; 038A1D : 88          ;
                      BPL CODE_038A18                     ;; 038A1E : 10 F8       ;
Return038A20:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038A21:          LDA.B #$03                          ;; 038A21 : A9 03       ;
                      STA.W !SmokeSpriteNumber,Y          ;; 038A23 : 99 C0 17    ;
                      LDA.B !SpriteXPosLow,X              ;; 038A26 : B5 E4       ;
                      CLC                                 ;; 038A28 : 18          ;
                      ADC.B !_0                           ;; 038A29 : 65 00       ;
                      STA.W !SmokeSpriteXPos,Y            ;; 038A2B : 99 C8 17    ;
                      LDA.B !SpriteYPosLow,X              ;; 038A2E : B5 D8       ;
                      CLC                                 ;; 038A30 : 18          ;
                      ADC.B !_1                           ;; 038A31 : 65 01       ;
                      STA.W !SmokeSpriteYPos,Y            ;; 038A33 : 99 C4 17    ;
                      LDA.B #$13                          ;; 038A36 : A9 13       ;
                      STA.W !SmokeSpriteTimer,Y           ;; 038A38 : 99 CC 17    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
BowserStatue:         JSR BowserStatueGfx                 ;; ?QPWZ? : 20 3D 8B    ;
                      LDA.B !SpriteLock                   ;; 038A3F : A5 9D       ;
                      BNE Return038A68                    ;; 038A41 : D0 25       ;
                      JSR SubOffscreen0Bnk3               ;; 038A43 : 20 5D B8    ;
                      LDA.B !SpriteTableC2,X              ;; 038A46 : B5 C2       ;
                      JSL ExecutePtr                      ;; 038A48 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_038A57                      ;; ?QPWZ? : 57 8A       ;
                      dw CODE_038A54                      ;; ?QPWZ? : 54 8A       ;
                      dw CODE_038A69                      ;; ?QPWZ? : 69 8A       ;
                      dw CODE_038A54                      ;; ?QPWZ? : 54 8A       ;
                                                          ;;                      ;
CODE_038A54:          JSR CODE_038ACB                     ;; 038A54 : 20 CB 8A    ;
CODE_038A57:          JSL InvisBlkMainRt                  ;; 038A57 : 22 4F B4 01 ;
                      JSL UpdateSpritePos                 ;; 038A5B : 22 2A 80 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 038A5F : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 038A62 : 29 04       ;  | 
                      BEQ Return038A68                    ;; 038A64 : F0 02       ; / 
                      STZ.B !SpriteYSpeed,X               ;; 038A66 : 74 AA       ; Sprite Y Speed = 0 
Return038A68:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038A69:          ASL.W !SpriteTweakerD,X             ;; 038A69 : 1E 7A 16    ;
                      LSR.W !SpriteTweakerD,X             ;; 038A6C : 5E 7A 16    ;
                      JSL MarioSprInteract                ;; 038A6F : 22 DC A7 01 ;
                      STZ.W !SpriteMisc1602,X             ;; 038A73 : 9E 02 16    ;
                      LDA.B !SpriteYSpeed,X               ;; 038A76 : B5 AA       ;
                      CMP.B #$10                          ;; 038A78 : C9 10       ;
                      BPL CODE_038A7F                     ;; 038A7A : 10 03       ;
                      INC.W !SpriteMisc1602,X             ;; 038A7C : FE 02 16    ;
CODE_038A7F:          JSL UpdateSpritePos                 ;; 038A7F : 22 2A 80 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 038A83 : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 038A86 : 29 03       ;  | 
                      BEQ CODE_038A99                     ;; 038A88 : F0 0F       ; / 
                      LDA.B !SpriteXSpeed,X               ;; 038A8A : B5 B6       ;
                      EOR.B #$FF                          ;; 038A8C : 49 FF       ;
                      INC A                               ;; 038A8E : 1A          ;
                      STA.B !SpriteXSpeed,X               ;; 038A8F : 95 B6       ;
                      LDA.W !SpriteMisc157C,X             ;; 038A91 : BD 7C 15    ;
                      EOR.B #$01                          ;; 038A94 : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 038A96 : 9D 7C 15    ;
CODE_038A99:          LDA.W !SpriteBlockedDirs,X          ;; 038A99 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 038A9C : 29 04       ;  | 
                      BEQ Return038AC6                    ;; 038A9E : F0 26       ; / 
                      LDA.B #$10                          ;; 038AA0 : A9 10       ;
                      STA.B !SpriteYSpeed,X               ;; 038AA2 : 95 AA       ;
                      STZ.B !SpriteXSpeed,X               ;; 038AA4 : 74 B6       ; Sprite X Speed = 0 
                      LDA.W !SpriteMisc1540,X             ;; 038AA6 : BD 40 15    ;
                      BEQ CODE_038AC1                     ;; 038AA9 : F0 16       ;
                      DEC A                               ;; 038AAB : 3A          ;
                      BNE Return038AC6                    ;; 038AAC : D0 18       ;
                      LDA.B #$C0                          ;; 038AAE : A9 C0       ;
                      STA.B !SpriteYSpeed,X               ;; 038AB0 : 95 AA       ;
                      JSR SubHorzPosBnk3                  ;; 038AB2 : 20 17 B8    ;
                      TYA                                 ;; 038AB5 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 038AB6 : 9D 7C 15    ;
                      LDA.W BwsrStatueSpeed,Y             ;; 038AB9 : B9 BF 8A    ;
                      STA.B !SpriteXSpeed,X               ;; 038ABC : 95 B6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwsrStatueSpeed:      db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038AC1:          LDA.B #$30                          ;; 038AC1 : A9 30       ;
                      STA.W !SpriteMisc1540,X             ;; 038AC3 : 9D 40 15    ;
Return038AC6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwserFireDispXLo:     db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
BwserFireDispXHi:     db $00,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038ACB:          TXA                                 ;; 038ACB : 8A          ;
                      ASL A                               ;; 038ACC : 0A          ;
                      ASL A                               ;; 038ACD : 0A          ;
                      ADC.B !TrueFrame                    ;; 038ACE : 65 13       ;
                      AND.B #$7F                          ;; 038AD0 : 29 7F       ;
                      BNE Return038B24                    ;; 038AD2 : D0 50       ;
                      JSL FindFreeSprSlot                 ;; 038AD4 : 22 E4 A9 02 ; \ Return if no free slots 
                      BMI Return038B24                    ;; 038AD8 : 30 4A       ; / 
                      LDA.B #$17                          ;; 038ADA : A9 17       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 038ADC : 8D FC 1D    ; / 
                      LDA.B #$08                          ;; 038ADF : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 038AE1 : 99 C8 14    ; / 
                      LDA.B #$B3                          ;; 038AE4 : A9 B3       ; \ Sprite = Bowser Statue Fireball 
                      STA.W !SpriteNumber,Y               ;; 038AE6 : 99 9E 00    ; / 
                      LDA.B !SpriteXPosLow,X              ;; 038AE9 : B5 E4       ;
                      STA.B !_0                           ;; 038AEB : 85 00       ;
                      LDA.W !SpriteYPosHigh,X             ;; 038AED : BD E0 14    ;
                      STA.B !_1                           ;; 038AF0 : 85 01       ;
                      PHX                                 ;; 038AF2 : DA          ;
                      LDA.W !SpriteMisc157C,X             ;; 038AF3 : BD 7C 15    ;
                      TAX                                 ;; 038AF6 : AA          ;
                      LDA.B !_0                           ;; 038AF7 : A5 00       ;
                      CLC                                 ;; 038AF9 : 18          ;
                      ADC.W BwserFireDispXLo,X            ;; 038AFA : 7D C7 8A    ;
                      STA.W !SpriteXPosLow,Y              ;; 038AFD : 99 E4 00    ;
                      LDA.B !_1                           ;; 038B00 : A5 01       ;
                      ADC.W BwserFireDispXHi,X            ;; 038B02 : 7D C9 8A    ;
                      STA.W !SpriteYPosHigh,Y             ;; 038B05 : 99 E0 14    ;
                      TYX                                 ;; 038B08 : BB          ; \ Reset sprite tables 
                      JSL InitSpriteTables                ;; 038B09 : 22 D2 F7 07 ;  | 
                      PLX                                 ;; 038B0D : FA          ; / 
                      LDA.B !SpriteYPosLow,X              ;; 038B0E : B5 D8       ;
                      SEC                                 ;; 038B10 : 38          ;
                      SBC.B #$02                          ;; 038B11 : E9 02       ;
                      STA.W !SpriteYPosLow,Y              ;; 038B13 : 99 D8 00    ;
                      LDA.W !SpriteXPosHigh,X             ;; 038B16 : BD D4 14    ;
                      SBC.B #$00                          ;; 038B19 : E9 00       ;
                      STA.W !SpriteXPosHigh,Y             ;; 038B1B : 99 D4 14    ;
                      LDA.W !SpriteMisc157C,X             ;; 038B1E : BD 7C 15    ;
                      STA.W !SpriteMisc157C,Y             ;; 038B21 : 99 7C 15    ;
Return038B24:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BwsrStatueDispX:      db $08,$F8,$00,$00,$08,$00          ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueDispY:      db $10,$F8,$00                      ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueTiles:      db $56,$30,$41,$56,$30,$35          ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueTileSize:   db $00,$02,$02                      ;; ?QPWZ?               ;
                                                          ;;                      ;
BwsrStatueGfxProp:    db $00,$00,$00,$40,$40,$40          ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserStatueGfx:      JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc1602,X             ;; 038B40 : BD 02 16    ;
                      STA.B !_4                           ;; 038B43 : 85 04       ;
                      EOR.B #$01                          ;; 038B45 : 49 01       ;
                      DEC A                               ;; 038B47 : 3A          ;
                      STA.B !_3                           ;; 038B48 : 85 03       ;
                      LDA.W !SpriteOBJAttribute,X         ;; 038B4A : BD F6 15    ;
                      STA.B !_5                           ;; 038B4D : 85 05       ;
                      LDA.W !SpriteMisc157C,X             ;; 038B4F : BD 7C 15    ;
                      STA.B !_2                           ;; 038B52 : 85 02       ;
                      PHX                                 ;; 038B54 : DA          ;
                      LDX.B #$02                          ;; 038B55 : A2 02       ;
CODE_038B57:          PHX                                 ;; 038B57 : DA          ;
                      LDA.B !_2                           ;; 038B58 : A5 02       ;
                      BNE CODE_038B5F                     ;; 038B5A : D0 03       ;
                      INX                                 ;; 038B5C : E8          ;
                      INX                                 ;; 038B5D : E8          ;
                      INX                                 ;; 038B5E : E8          ;
CODE_038B5F:          LDA.B !_0                           ;; 038B5F : A5 00       ;
                      CLC                                 ;; 038B61 : 18          ;
                      ADC.W BwsrStatueDispX,X             ;; 038B62 : 7D 25 8B    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038B65 : 99 00 03    ;
                      LDA.W BwsrStatueGfxProp,X           ;; 038B68 : BD 37 8B    ;
                      ORA.B !_5                           ;; 038B6B : 05 05       ;
                      ORA.B !SpriteProperties             ;; 038B6D : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 038B6F : 99 03 03    ;
                      PLX                                 ;; 038B72 : FA          ;
                      LDA.B !_1                           ;; 038B73 : A5 01       ;
                      CLC                                 ;; 038B75 : 18          ;
                      ADC.W BwsrStatueDispY,X             ;; 038B76 : 7D 2B 8B    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038B79 : 99 01 03    ;
                      PHX                                 ;; 038B7C : DA          ;
                      LDA.B !_4                           ;; 038B7D : A5 04       ;
                      BEQ CODE_038B84                     ;; 038B7F : F0 03       ;
                      INX                                 ;; 038B81 : E8          ;
                      INX                                 ;; 038B82 : E8          ;
                      INX                                 ;; 038B83 : E8          ;
CODE_038B84:          LDA.W BwsrStatueTiles,X             ;; 038B84 : BD 2E 8B    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038B87 : 99 02 03    ;
                      PLX                                 ;; 038B8A : FA          ;
                      PHY                                 ;; 038B8B : 5A          ;
                      TYA                                 ;; 038B8C : 98          ;
                      LSR A                               ;; 038B8D : 4A          ;
                      LSR A                               ;; 038B8E : 4A          ;
                      TAY                                 ;; 038B8F : A8          ;
                      LDA.W BwsrStatueTileSize,X          ;; 038B90 : BD 34 8B    ;
                      STA.W !OAMTileSize+$40,Y            ;; 038B93 : 99 60 04    ;
                      PLY                                 ;; 038B96 : 7A          ;
                      INY                                 ;; 038B97 : C8          ;
                      INY                                 ;; 038B98 : C8          ;
                      INY                                 ;; 038B99 : C8          ;
                      INY                                 ;; 038B9A : C8          ;
                      DEX                                 ;; 038B9B : CA          ;
                      CPX.B !_3                           ;; 038B9C : E4 03       ;
                      BNE CODE_038B57                     ;; 038B9E : D0 B7       ;
                      PLX                                 ;; 038BA0 : FA          ;
                      LDY.B #$FF                          ;; 038BA1 : A0 FF       ;
                      LDA.B #$02                          ;; 038BA3 : A9 02       ;
                      JSL FinishOAMWrite                  ;; 038BA5 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038BAA:          db $20,$20,$20,$20,$20,$20,$20,$20  ;; 038BAA               ;
                      db $20,$20,$20,$20,$20,$20,$20,$20  ;; ?QPWZ?               ;
                      db $20,$1F,$1E,$1D,$1C,$1B,$1A,$19  ;; ?QPWZ?               ;
                      db $18,$17,$16,$15,$14,$13,$12,$11  ;; ?QPWZ?               ;
                      db $10,$0F,$0E,$0D,$0C,$0B,$0A,$09  ;; ?QPWZ?               ;
                      db $08,$07,$06,$05,$04,$03,$02,$01  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $01,$02,$03,$04,$05,$06,$07,$08  ;; ?QPWZ?               ;
                      db $09,$0A,$0B,$0C,$0D,$0E,$0F,$10  ;; ?QPWZ?               ;
                      db $11,$12,$13,$14,$15,$16,$17,$18  ;; ?QPWZ?               ;
                      db $19,$1A,$1B,$1C,$1D,$1E,$1F,$20  ;; ?QPWZ?               ;
                      db $20,$20,$20,$20,$20,$20,$20,$20  ;; ?QPWZ?               ;
                      db $20,$20,$20,$20,$20,$20,$20,$20  ;; ?QPWZ?               ;
DATA_038C2A:          db $00,$F8,$00,$08                  ;; 038C2A               ;
                                                          ;;                      ;
Return038C2E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CarrotTopLift:        JSR CarrotTopLiftGfx                ;; ?QPWZ? : 20 24 8D    ;
                      LDA.B !SpriteLock                   ;; 038C32 : A5 9D       ;
                      BNE Return038C2E                    ;; 038C34 : D0 F8       ;
                      JSR SubOffscreen0Bnk3               ;; 038C36 : 20 5D B8    ;
                      LDA.W !SpriteMisc1540,X             ;; 038C39 : BD 40 15    ;
                      BNE CODE_038C45                     ;; 038C3C : D0 07       ;
                      INC.B !SpriteTableC2,X              ;; 038C3E : F6 C2       ;
                      LDA.B #$80                          ;; 038C40 : A9 80       ;
                      STA.W !SpriteMisc1540,X             ;; 038C42 : 9D 40 15    ;
CODE_038C45:          LDA.B !SpriteTableC2,X              ;; 038C45 : B5 C2       ;
                      AND.B #$03                          ;; 038C47 : 29 03       ;
                      TAY                                 ;; 038C49 : A8          ;
                      LDA.W DATA_038C2A,Y                 ;; 038C4A : B9 2A 8C    ;
                      STA.B !SpriteXSpeed,X               ;; 038C4D : 95 B6       ;
                      LDA.B !SpriteXSpeed,X               ;; 038C4F : B5 B6       ;
                      LDY.B !SpriteNumber,X               ;; 038C51 : B4 9E       ;
                      CPY.B #$B8                          ;; 038C53 : C0 B8       ;
                      BEQ CODE_038C5A                     ;; 038C55 : F0 03       ;
                      EOR.B #$FF                          ;; 038C57 : 49 FF       ;
                      INC A                               ;; 038C59 : 1A          ;
CODE_038C5A:          STA.B !SpriteYSpeed,X               ;; 038C5A : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 038C5C : 22 1A 80 01 ;
                      LDA.B !SpriteXPosLow,X              ;; 038C60 : B5 E4       ;
                      STA.W !SpriteMisc151C,X             ;; 038C62 : 9D 1C 15    ;
                      JSL UpdateXPosNoGvtyW               ;; 038C65 : 22 22 80 01 ;
                      JSR CODE_038CE4                     ;; 038C69 : 20 E4 8C    ;
                      JSL GetSpriteClippingA              ;; 038C6C : 22 9F B6 03 ;
                      JSL CheckForContact                 ;; 038C70 : 22 2B B7 03 ;
                      BCC Return038CE3                    ;; 038C74 : 90 6D       ;
                      LDA.B !PlayerYSpeed                 ;; 038C76 : A5 7D       ;
                      BMI Return038CE3                    ;; 038C78 : 30 69       ;
                      LDA.B !PlayerXPosNext               ;; 038C7A : A5 94       ;
                      SEC                                 ;; 038C7C : 38          ;
                      SBC.W !SpriteMisc151C,X             ;; 038C7D : FD 1C 15    ;
                      CLC                                 ;; 038C80 : 18          ;
                      ADC.B #$1C                          ;; 038C81 : 69 1C       ;
                      LDY.B !SpriteNumber,X               ;; 038C83 : B4 9E       ;
                      CPY.B #$B8                          ;; 038C85 : C0 B8       ;
                      BNE CODE_038C8C                     ;; 038C87 : D0 03       ;
                      CLC                                 ;; 038C89 : 18          ;
                      ADC.B #$38                          ;; 038C8A : 69 38       ;
CODE_038C8C:          TAY                                 ;; 038C8C : A8          ;
                      LDA.W !PlayerRidingYoshi            ;; 038C8D : AD 7A 18    ;
                      CMP.B #$01                          ;; 038C90 : C9 01       ;
                      LDA.B #$20                          ;; 038C92 : A9 20       ;
                      BCC CODE_038C98                     ;; 038C94 : 90 02       ;
                      LDA.B #$30                          ;; 038C96 : A9 30       ;
CODE_038C98:          CLC                                 ;; 038C98 : 18          ;
                      ADC.B !PlayerYPosNext               ;; 038C99 : 65 96       ;
                      STA.B !_0                           ;; 038C9B : 85 00       ;
                      LDA.B !SpriteYPosLow,X              ;; 038C9D : B5 D8       ;
                      CLC                                 ;; 038C9F : 18          ;
                      ADC.W DATA_038BAA,Y                 ;; 038CA0 : 79 AA 8B    ;
                      CMP.B !_0                           ;; 038CA3 : C5 00       ;
                      BPL Return038CE3                    ;; 038CA5 : 10 3C       ;
                      LDA.W !PlayerRidingYoshi            ;; 038CA7 : AD 7A 18    ;
                      CMP.B #$01                          ;; 038CAA : C9 01       ;
                      LDA.B #$1D                          ;; 038CAC : A9 1D       ;
                      BCC CODE_038CB2                     ;; 038CAE : 90 02       ;
                      LDA.B #$2D                          ;; 038CB0 : A9 2D       ;
CODE_038CB2:          STA.B !_0                           ;; 038CB2 : 85 00       ;
                      LDA.B !SpriteYPosLow,X              ;; 038CB4 : B5 D8       ;
                      CLC                                 ;; 038CB6 : 18          ;
                      ADC.W DATA_038BAA,Y                 ;; 038CB7 : 79 AA 8B    ;
                      PHP                                 ;; 038CBA : 08          ;
                      SEC                                 ;; 038CBB : 38          ;
                      SBC.B !_0                           ;; 038CBC : E5 00       ;
                      STA.B !PlayerYPosNext               ;; 038CBE : 85 96       ;
                      LDA.W !SpriteXPosHigh,X             ;; 038CC0 : BD D4 14    ;
                      SBC.B #$00                          ;; 038CC3 : E9 00       ;
                      PLP                                 ;; 038CC5 : 28          ;
                      ADC.B #$00                          ;; 038CC6 : 69 00       ;
                      STA.B !PlayerYPosNext+1             ;; 038CC8 : 85 97       ;
                      STZ.B !PlayerYSpeed                 ;; 038CCA : 64 7D       ;
                      LDA.B #$01                          ;; 038CCC : A9 01       ;
                      STA.W !StandOnSolidSprite           ;; 038CCE : 8D 71 14    ;
                      LDY.B #$00                          ;; 038CD1 : A0 00       ;
                      LDA.W !SpriteXMovement              ;; 038CD3 : AD 91 14    ;
                      BPL CODE_038CD9                     ;; 038CD6 : 10 01       ;
                      DEY                                 ;; 038CD8 : 88          ;
CODE_038CD9:          CLC                                 ;; 038CD9 : 18          ;
                      ADC.B !PlayerXPosNext               ;; 038CDA : 65 94       ;
                      STA.B !PlayerXPosNext               ;; 038CDC : 85 94       ;
                      TYA                                 ;; 038CDE : 98          ;
                      ADC.B !PlayerXPosNext+1             ;; 038CDF : 65 95       ;
                      STA.B !PlayerXPosNext+1             ;; 038CE1 : 85 95       ;
Return038CE3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038CE4:          LDA.B !PlayerXPosNext               ;; 038CE4 : A5 94       ;
                      CLC                                 ;; 038CE6 : 18          ;
                      ADC.B #$04                          ;; 038CE7 : 69 04       ;
                      STA.B !_0                           ;; 038CE9 : 85 00       ;
                      LDA.B !PlayerXPosNext+1             ;; 038CEB : A5 95       ;
                      ADC.B #$00                          ;; 038CED : 69 00       ;
                      STA.B !_8                           ;; 038CEF : 85 08       ;
                      LDA.B #$08                          ;; 038CF1 : A9 08       ;
                      STA.B !_2                           ;; 038CF3 : 85 02       ;
                      STA.B !_3                           ;; 038CF5 : 85 03       ;
                      LDA.B #$20                          ;; 038CF7 : A9 20       ;
                      LDY.W !PlayerRidingYoshi            ;; 038CF9 : AC 7A 18    ;
                      BEQ CODE_038D00                     ;; 038CFC : F0 02       ;
                      LDA.B #$30                          ;; 038CFE : A9 30       ;
CODE_038D00:          CLC                                 ;; 038D00 : 18          ;
                      ADC.B !PlayerYPosNext               ;; 038D01 : 65 96       ;
                      STA.B !_1                           ;; 038D03 : 85 01       ;
                      LDA.B !PlayerYPosNext+1             ;; 038D05 : A5 97       ;
                      ADC.B #$00                          ;; 038D07 : 69 00       ;
                      STA.B !_9                           ;; 038D09 : 85 09       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DiagPlatDispX:        db $10,$00,$10,$00,$10,$00          ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatDispY:        db $00,$10,$10,$00,$10,$10          ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatTiles2:       db $E4,$E0,$E2,$E4,$E0,$E2          ;; ?QPWZ?               ;
                                                          ;;                      ;
DiagPlatGfxProp:      db $0B,$0B,$0B,$4B,$4B,$4B          ;; ?QPWZ?               ;
                                                          ;;                      ;
CarrotTopLiftGfx:     JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      PHX                                 ;; 038D27 : DA          ;
                      LDA.B !SpriteNumber,X               ;; 038D28 : B5 9E       ;
                      CMP.B #$B8                          ;; 038D2A : C9 B8       ;
                      LDX.B #$02                          ;; 038D2C : A2 02       ;
                      STX.B !_2                           ;; 038D2E : 86 02       ;
                      BCC CODE_038D34                     ;; 038D30 : 90 02       ;
                      LDX.B #$05                          ;; 038D32 : A2 05       ;
CODE_038D34:          LDA.B !_0                           ;; 038D34 : A5 00       ;
                      CLC                                 ;; 038D36 : 18          ;
                      ADC.W DiagPlatDispX,X               ;; 038D37 : 7D 0C 8D    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038D3A : 99 00 03    ;
                      LDA.B !_1                           ;; 038D3D : A5 01       ;
                      CLC                                 ;; 038D3F : 18          ;
                      ADC.W DiagPlatDispY,X               ;; 038D40 : 7D 12 8D    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038D43 : 99 01 03    ;
                      LDA.W DiagPlatTiles2,X              ;; 038D46 : BD 18 8D    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038D49 : 99 02 03    ;
                      LDA.W DiagPlatGfxProp,X             ;; 038D4C : BD 1E 8D    ;
                      ORA.B !SpriteProperties             ;; 038D4F : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 038D51 : 99 03 03    ;
                      INY                                 ;; 038D54 : C8          ;
                      INY                                 ;; 038D55 : C8          ;
                      INY                                 ;; 038D56 : C8          ;
                      INY                                 ;; 038D57 : C8          ;
                      DEX                                 ;; 038D58 : CA          ;
                      DEC.B !_2                           ;; 038D59 : C6 02       ;
                      BPL CODE_038D34                     ;; 038D5B : 10 D7       ;
                      PLX                                 ;; 038D5D : FA          ;
                      LDY.B #$02                          ;; 038D5E : A0 02       ;
                      TYA                                 ;; 038D60 : 98          ;
                      JSL FinishOAMWrite                  ;; 038D61 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_038D66:          db $00,$04,$07,$08,$08,$07,$04,$00  ;; 038D66               ;
                      db $00                              ;; ?QPWZ?               ;
                                                          ;;                      ;
InfoBox:              JSL InvisBlkMainRt                  ;; ?QPWZ? : 22 4F B4 01 ;
                      JSR SubOffscreen0Bnk3               ;; 038D73 : 20 5D B8    ;
                      LDA.W !SpriteMisc1558,X             ;; 038D76 : BD 58 15    ;
                      CMP.B #$01                          ;; 038D79 : C9 01       ;
                      BNE CODE_038D93                     ;; 038D7B : D0 16       ;
                      LDA.B #$22                          ;; 038D7D : A9 22       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 038D7F : 8D FC 1D    ; / 
                      STZ.W !SpriteMisc1558,X             ;; 038D82 : 9E 58 15    ;
                      STZ.B !SpriteTableC2,X              ;; 038D85 : 74 C2       ;
                      LDA.B !SpriteXPosLow,X              ;; 038D87 : B5 E4       ;
                      LSR A                               ;; 038D89 : 4A          ;
                      LSR A                               ;; 038D8A : 4A          ;
                      LSR A                               ;; 038D8B : 4A          ;
                      LSR A                               ;; 038D8C : 4A          ;
                      AND.B #$01                          ;; 038D8D : 29 01       ;
                      INC A                               ;; 038D8F : 1A          ;
                      STA.W !MessageBoxTrigger            ;; 038D90 : 8D 26 14    ;
CODE_038D93:          LDA.W !SpriteMisc1558,X             ;; 038D93 : BD 58 15    ;
                      LSR A                               ;; 038D96 : 4A          ;
                      TAY                                 ;; 038D97 : A8          ;
                      LDA.B !Layer1YPos                   ;; 038D98 : A5 1C       ;
                      PHA                                 ;; 038D9A : 48          ;
                      CLC                                 ;; 038D9B : 18          ;
                      ADC.W DATA_038D66,Y                 ;; 038D9C : 79 66 8D    ;
                      STA.B !Layer1YPos                   ;; 038D9F : 85 1C       ;
                      LDA.B !Layer1YPos+1                 ;; 038DA1 : A5 1D       ;
                      PHA                                 ;; 038DA3 : 48          ;
                      ADC.B #$00                          ;; 038DA4 : 69 00       ;
                      STA.B !Layer1YPos+1                 ;; 038DA6 : 85 1D       ;
                      JSL GenericSprGfxRt2                ;; 038DA8 : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 038DAC : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$C0                          ;; 038DAF : A9 C0       ;
                      STA.W !OAMTileNo+$100,Y             ;; 038DB1 : 99 02 03    ;
                      PLA                                 ;; 038DB4 : 68          ;
                      STA.B !Layer1YPos+1                 ;; 038DB5 : 85 1D       ;
                      PLA                                 ;; 038DB7 : 68          ;
                      STA.B !Layer1YPos                   ;; 038DB8 : 85 1C       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
TimedLift:            JSR TimedPlatformGfx                ;; ?QPWZ? : 20 12 8E    ;
                      LDA.B !SpriteLock                   ;; 038DBE : A5 9D       ;
                      BNE Return038DEF                    ;; 038DC0 : D0 2D       ;
                      JSR SubOffscreen0Bnk3               ;; 038DC2 : 20 5D B8    ;
                      LDA.B !TrueFrame                    ;; 038DC5 : A5 13       ;
                      AND.B #$00                          ;; 038DC7 : 29 00       ;
                      BNE CODE_038DD7                     ;; 038DC9 : D0 0C       ;
                      LDA.B !SpriteTableC2,X              ;; 038DCB : B5 C2       ;
                      BEQ CODE_038DD7                     ;; 038DCD : F0 08       ;
                      LDA.W !SpriteMisc1570,X             ;; 038DCF : BD 70 15    ;
                      BEQ CODE_038DD7                     ;; 038DD2 : F0 03       ;
                      DEC.W !SpriteMisc1570,X             ;; 038DD4 : DE 70 15    ;
CODE_038DD7:          LDA.W !SpriteMisc1570,X             ;; 038DD7 : BD 70 15    ;
                      BEQ CODE_038DF0                     ;; 038DDA : F0 14       ;
                      JSL UpdateXPosNoGvtyW               ;; 038DDC : 22 22 80 01 ;
                      STA.W !SpriteMisc1528,X             ;; 038DE0 : 9D 28 15    ;
                      JSL InvisBlkMainRt                  ;; 038DE3 : 22 4F B4 01 ;
                      BCC Return038DEF                    ;; 038DE7 : 90 06       ;
                      LDA.B #$10                          ;; 038DE9 : A9 10       ;
                      STA.B !SpriteXSpeed,X               ;; 038DEB : 95 B6       ;
                      STA.B !SpriteTableC2,X              ;; 038DED : 95 C2       ;
Return038DEF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038DF0:          JSL UpdateSpritePos                 ;; 038DF0 : 22 2A 80 01 ;
                      LDA.W !SpriteXMovement              ;; 038DF4 : AD 91 14    ;
                      STA.W !SpriteMisc1528,X             ;; 038DF7 : 9D 28 15    ;
                      JSL InvisBlkMainRt                  ;; 038DFA : 22 4F B4 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
TimedPlatDispX:       db $00,$10,$0C                      ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatDispY:       db $00,$00,$04                      ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatTiles:       db $C4,$C4,$00                      ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatGfxProp:     db $0B,$4B,$0B                      ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatTileSize:    db $02,$02,$00                      ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatNumTiles:    db $B6,$B5,$B4,$B3                  ;; ?QPWZ?               ;
                                                          ;;                      ;
TimedPlatformGfx:     JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc1570,X             ;; 038E15 : BD 70 15    ;
                      PHX                                 ;; 038E18 : DA          ;
                      PHA                                 ;; 038E19 : 48          ;
                      LSR A                               ;; 038E1A : 4A          ;
                      LSR A                               ;; 038E1B : 4A          ;
                      LSR A                               ;; 038E1C : 4A          ;
                      LSR A                               ;; 038E1D : 4A          ;
                      LSR A                               ;; 038E1E : 4A          ;
                      LSR A                               ;; 038E1F : 4A          ;
                      TAX                                 ;; 038E20 : AA          ;
                      LDA.W TimedPlatNumTiles,X           ;; 038E21 : BD 0E 8E    ;
                      STA.B !_2                           ;; 038E24 : 85 02       ;
                      LDX.B #$02                          ;; 038E26 : A2 02       ;
                      PLA                                 ;; 038E28 : 68          ;
                      CMP.B #$08                          ;; 038E29 : C9 08       ;
                      BCS CODE_038E2E                     ;; 038E2B : B0 01       ;
                      DEX                                 ;; 038E2D : CA          ;
CODE_038E2E:          LDA.B !_0                           ;; 038E2E : A5 00       ;
                      CLC                                 ;; 038E30 : 18          ;
                      ADC.W TimedPlatDispX,X              ;; 038E31 : 7D FF 8D    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038E34 : 99 00 03    ;
                      LDA.B !_1                           ;; 038E37 : A5 01       ;
                      CLC                                 ;; 038E39 : 18          ;
                      ADC.W TimedPlatDispY,X              ;; 038E3A : 7D 02 8E    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038E3D : 99 01 03    ;
                      LDA.W TimedPlatTiles,X              ;; 038E40 : BD 05 8E    ;
                      CPX.B #$02                          ;; 038E43 : E0 02       ;
                      BNE CODE_038E49                     ;; 038E45 : D0 02       ;
                      LDA.B !_2                           ;; 038E47 : A5 02       ;
CODE_038E49:          STA.W !OAMTileNo+$100,Y             ;; 038E49 : 99 02 03    ;
                      LDA.W TimedPlatGfxProp,X            ;; 038E4C : BD 08 8E    ;
                      ORA.B !SpriteProperties             ;; 038E4F : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 038E51 : 99 03 03    ;
                      PHY                                 ;; 038E54 : 5A          ;
                      TYA                                 ;; 038E55 : 98          ;
                      LSR A                               ;; 038E56 : 4A          ;
                      LSR A                               ;; 038E57 : 4A          ;
                      TAY                                 ;; 038E58 : A8          ;
                      LDA.W TimedPlatTileSize,X           ;; 038E59 : BD 0B 8E    ;
                      STA.W !OAMTileSize+$40,Y            ;; 038E5C : 99 60 04    ;
                      PLY                                 ;; 038E5F : 7A          ;
                      INY                                 ;; 038E60 : C8          ;
                      INY                                 ;; 038E61 : C8          ;
                      INY                                 ;; 038E62 : C8          ;
                      INY                                 ;; 038E63 : C8          ;
                      DEX                                 ;; 038E64 : CA          ;
                      BPL CODE_038E2E                     ;; 038E65 : 10 C7       ;
                      PLX                                 ;; 038E67 : FA          ;
                      LDY.B #$FF                          ;; 038E68 : A0 FF       ;
                      LDA.B #$02                          ;; 038E6A : A9 02       ;
                      JSL FinishOAMWrite                  ;; 038E6C : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
GreyMoveBlkSpeed:     db $00,$F0,$00,$10                  ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkTiming:    db $40,$50,$40,$50                  ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyCastleBlock:      JSR CODE_038EB4                     ;; ?QPWZ? : 20 B4 8E    ;
                      LDA.B !SpriteLock                   ;; 038E7C : A5 9D       ;
                      BNE Return038EA7                    ;; 038E7E : D0 27       ;
                      LDA.W !SpriteMisc1540,X             ;; 038E80 : BD 40 15    ;
                      BNE CODE_038E92                     ;; 038E83 : D0 0D       ;
                      INC.B !SpriteTableC2,X              ;; 038E85 : F6 C2       ;
                      LDA.B !SpriteTableC2,X              ;; 038E87 : B5 C2       ;
                      AND.B #$03                          ;; 038E89 : 29 03       ;
                      TAY                                 ;; 038E8B : A8          ;
                      LDA.W GreyMoveBlkTiming,Y           ;; 038E8C : B9 75 8E    ;
                      STA.W !SpriteMisc1540,X             ;; 038E8F : 9D 40 15    ;
CODE_038E92:          LDA.B !SpriteTableC2,X              ;; 038E92 : B5 C2       ;
                      AND.B #$03                          ;; 038E94 : 29 03       ;
                      TAY                                 ;; 038E96 : A8          ;
                      LDA.W GreyMoveBlkSpeed,Y            ;; 038E97 : B9 71 8E    ;
                      STA.B !SpriteXSpeed,X               ;; 038E9A : 95 B6       ;
                      JSL UpdateXPosNoGvtyW               ;; 038E9C : 22 22 80 01 ;
                      STA.W !SpriteMisc1528,X             ;; 038EA0 : 9D 28 15    ;
                      JSL InvisBlkMainRt                  ;; 038EA3 : 22 4F B4 01 ;
Return038EA7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
GreyMoveBlkDispX:     db $00,$10,$00,$10                  ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkDispY:     db $00,$00,$10,$10                  ;; ?QPWZ?               ;
                                                          ;;                      ;
GreyMoveBlkTiles:     db $CC,$CE,$EC,$EE                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_038EB4:          JSR GetDrawInfoBnk3                 ;; 038EB4 : 20 60 B7    ;
                      PHX                                 ;; 038EB7 : DA          ;
                      LDX.B #$03                          ;; 038EB8 : A2 03       ;
CODE_038EBA:          LDA.B !_0                           ;; 038EBA : A5 00       ;
                      CLC                                 ;; 038EBC : 18          ;
                      ADC.W GreyMoveBlkDispX,X            ;; 038EBD : 7D A8 8E    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038EC0 : 99 00 03    ;
                      LDA.B !_1                           ;; 038EC3 : A5 01       ;
                      CLC                                 ;; 038EC5 : 18          ;
                      ADC.W GreyMoveBlkDispY,X            ;; 038EC6 : 7D AC 8E    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038EC9 : 99 01 03    ;
                      LDA.W GreyMoveBlkTiles,X            ;; 038ECC : BD B0 8E    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038ECF : 99 02 03    ;
                      LDA.B #$03                          ;; 038ED2 : A9 03       ;
                      ORA.B !SpriteProperties             ;; 038ED4 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 038ED6 : 99 03 03    ;
                      INY                                 ;; 038ED9 : C8          ;
                      INY                                 ;; 038EDA : C8          ;
                      INY                                 ;; 038EDB : C8          ;
                      INY                                 ;; 038EDC : C8          ;
                      DEX                                 ;; 038EDD : CA          ;
                      BPL CODE_038EBA                     ;; 038EDE : 10 DA       ;
                      PLX                                 ;; 038EE0 : FA          ;
                      LDY.B #$02                          ;; 038EE1 : A0 02       ;
                      LDA.B #$03                          ;; 038EE3 : A9 03       ;
                      JSL FinishOAMWrite                  ;; 038EE5 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
StatueFireSpeed:      db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireball:       JSR StatueFireballGfx               ;; ?QPWZ? : 20 1B 8F    ;
                      LDA.B !SpriteLock                   ;; 038EEF : A5 9D       ;
                      BNE Return038F06                    ;; 038EF1 : D0 13       ;
                      JSR SubOffscreen0Bnk3               ;; 038EF3 : 20 5D B8    ;
                      JSL MarioSprInteract                ;; 038EF6 : 22 DC A7 01 ;
                      LDY.W !SpriteMisc157C,X             ;; 038EFA : BC 7C 15    ;
                      LDA.W StatueFireSpeed,Y             ;; 038EFD : B9 EA 8E    ;
                      STA.B !SpriteXSpeed,X               ;; 038F00 : 95 B6       ;
                      JSL UpdateXPosNoGvtyW               ;; 038F02 : 22 22 80 01 ;
Return038F06:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
StatueFireDispX:      db $08,$00,$00,$08                  ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireTiles:      db $32,$50,$33,$34,$32,$50,$33,$34  ;; ?QPWZ?               ;
StatueFireGfxProp:    db $09,$09,$09,$09,$89,$89,$89,$89  ;; ?QPWZ?               ;
                                                          ;;                      ;
StatueFireballGfx:    JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc157C,X             ;; 038F1E : BD 7C 15    ;
                      ASL A                               ;; 038F21 : 0A          ;
                      STA.B !_2                           ;; 038F22 : 85 02       ;
                      LDA.B !EffFrame                     ;; 038F24 : A5 14       ;
                      LSR A                               ;; 038F26 : 4A          ;
                      AND.B #$03                          ;; 038F27 : 29 03       ;
                      ASL A                               ;; 038F29 : 0A          ;
                      STA.B !_3                           ;; 038F2A : 85 03       ;
                      PHX                                 ;; 038F2C : DA          ;
                      LDX.B #$01                          ;; 038F2D : A2 01       ;
CODE_038F2F:          LDA.B !_1                           ;; 038F2F : A5 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 038F31 : 99 01 03    ;
                      PHX                                 ;; 038F34 : DA          ;
                      TXA                                 ;; 038F35 : 8A          ;
                      ORA.B !_2                           ;; 038F36 : 05 02       ;
                      TAX                                 ;; 038F38 : AA          ;
                      LDA.B !_0                           ;; 038F39 : A5 00       ;
                      CLC                                 ;; 038F3B : 18          ;
                      ADC.W StatueFireDispX,X             ;; 038F3C : 7D 07 8F    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 038F3F : 99 00 03    ;
                      PLA                                 ;; 038F42 : 68          ;
                      PHA                                 ;; 038F43 : 48          ;
                      ORA.B !_3                           ;; 038F44 : 05 03       ;
                      TAX                                 ;; 038F46 : AA          ;
                      LDA.W StatueFireTiles,X             ;; 038F47 : BD 0B 8F    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038F4A : 99 02 03    ;
                      LDA.W StatueFireGfxProp,X           ;; 038F4D : BD 13 8F    ;
                      LDX.B !_2                           ;; 038F50 : A6 02       ;
                      BNE CODE_038F56                     ;; 038F52 : D0 02       ;
                      EOR.B #$40                          ;; 038F54 : 49 40       ;
CODE_038F56:          ORA.B !SpriteProperties             ;; 038F56 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 038F58 : 99 03 03    ;
                      PLX                                 ;; 038F5B : FA          ;
                      INY                                 ;; 038F5C : C8          ;
                      INY                                 ;; 038F5D : C8          ;
                      INY                                 ;; 038F5E : C8          ;
                      INY                                 ;; 038F5F : C8          ;
                      DEX                                 ;; 038F60 : CA          ;
                      BPL CODE_038F2F                     ;; 038F61 : 10 CC       ;
                      PLX                                 ;; 038F63 : FA          ;
                      LDY.B #$00                          ;; 038F64 : A0 00       ;
                      LDA.B #$01                          ;; 038F66 : A9 01       ;
                      JSL FinishOAMWrite                  ;; 038F68 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BooStreamFrntTiles:   db $88,$8C,$8E,$A8,$AA,$AE,$88,$8C  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReflectingFireball:   JSR CODE_038FF2                     ;; ?QPWZ? : 20 F2 8F    ;
                      BRA CODE_038FA4                     ;; 038F78 : 80 2A       ;
                                                          ;;                      ;
BooStream:            LDA.B #$00                          ;; ?QPWZ? : A9 00       ;
                      LDY.B !SpriteXSpeed,X               ;; 038F7C : B4 B6       ;
                      BPL CODE_038F81                     ;; 038F7E : 10 01       ;
                      INC A                               ;; 038F80 : 1A          ;
CODE_038F81:          STA.W !SpriteMisc157C,X             ;; 038F81 : 9D 7C 15    ;
                      JSL GenericSprGfxRt2                ;; 038F84 : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 038F88 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B !EffFrame                     ;; 038F8B : A5 14       ;
                      LSR A                               ;; 038F8D : 4A          ;
                      LSR A                               ;; 038F8E : 4A          ;
                      LSR A                               ;; 038F8F : 4A          ;
                      LSR A                               ;; 038F90 : 4A          ;
                      AND.B #$01                          ;; 038F91 : 29 01       ;
                      STA.B !_0                           ;; 038F93 : 85 00       ;
                      TXA                                 ;; 038F95 : 8A          ;
                      AND.B #$03                          ;; 038F96 : 29 03       ;
                      ASL A                               ;; 038F98 : 0A          ;
                      ORA.B !_0                           ;; 038F99 : 05 00       ;
                      PHX                                 ;; 038F9B : DA          ;
                      TAX                                 ;; 038F9C : AA          ;
                      LDA.W BooStreamFrntTiles,X          ;; 038F9D : BD 6D 8F    ;
                      STA.W !OAMTileNo+$100,Y             ;; 038FA0 : 99 02 03    ;
                      PLX                                 ;; 038FA3 : FA          ;
CODE_038FA4:          LDA.W !SpriteStatus,X               ;; 038FA4 : BD C8 14    ;
                      CMP.B #$08                          ;; 038FA7 : C9 08       ;
                      BNE Return038FF1                    ;; 038FA9 : D0 46       ;
                      LDA.B !SpriteLock                   ;; 038FAB : A5 9D       ;
                      BNE Return038FF1                    ;; 038FAD : D0 42       ;
                      TXA                                 ;; 038FAF : 8A          ;
                      EOR.B !EffFrame                     ;; 038FB0 : 45 14       ;
                      AND.B #$07                          ;; 038FB2 : 29 07       ;
                      ORA.W !SpriteOffscreenVert,X        ;; 038FB4 : 1D 6C 18    ;
                      BNE CODE_038FC2                     ;; 038FB7 : D0 09       ;
                      LDA.B !SpriteNumber,X               ;; 038FB9 : B5 9E       ;
                      CMP.B #$B0                          ;; 038FBB : C9 B0       ;
                      BNE CODE_038FC2                     ;; 038FBD : D0 03       ;
                      JSR CODE_039020                     ;; 038FBF : 20 20 90    ;
CODE_038FC2:          JSL UpdateYPosNoGvtyW               ;; 038FC2 : 22 1A 80 01 ;
                      JSL UpdateXPosNoGvtyW               ;; 038FC6 : 22 22 80 01 ;
                      JSL CODE_019138                     ;; 038FCA : 22 38 91 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 038FCE : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 038FD1 : 29 03       ;  | 
                      BEQ CODE_038FDC                     ;; 038FD3 : F0 07       ; / 
                      LDA.B !SpriteXSpeed,X               ;; 038FD5 : B5 B6       ;
                      EOR.B #$FF                          ;; 038FD7 : 49 FF       ;
                      INC A                               ;; 038FD9 : 1A          ;
                      STA.B !SpriteXSpeed,X               ;; 038FDA : 95 B6       ;
CODE_038FDC:          LDA.W !SpriteBlockedDirs,X          ;; 038FDC : BD 88 15    ;
                      AND.B #$0C                          ;; 038FDF : 29 0C       ;
                      BEQ CODE_038FEA                     ;; 038FE1 : F0 07       ;
                      LDA.B !SpriteYSpeed,X               ;; 038FE3 : B5 AA       ;
                      EOR.B #$FF                          ;; 038FE5 : 49 FF       ;
                      INC A                               ;; 038FE7 : 1A          ;
                      STA.B !SpriteYSpeed,X               ;; 038FE8 : 95 AA       ;
CODE_038FEA:          JSL MarioSprInteract                ;; 038FEA : 22 DC A7 01 ;
                      JSR SubOffscreen0Bnk3               ;; 038FEE : 20 5D B8    ;
Return038FF1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_038FF2:          JSL GenericSprGfxRt2                ;; 038FF2 : 22 B2 90 01 ;
                      LDA.B !EffFrame                     ;; 038FF6 : A5 14       ;
                      LSR A                               ;; 038FF8 : 4A          ;
                      LSR A                               ;; 038FF9 : 4A          ;
                      LDA.B #$04                          ;; 038FFA : A9 04       ;
                      BCC CODE_038FFF                     ;; 038FFC : 90 01       ;
                      ASL A                               ;; 038FFE : 0A          ;
CODE_038FFF:          LDY.B !SpriteXSpeed,X               ;; 038FFF : B4 B6       ;
                      BPL CODE_039005                     ;; 039001 : 10 02       ;
                      EOR.B #$40                          ;; 039003 : 49 40       ;
CODE_039005:          LDY.B !SpriteYSpeed,X               ;; 039005 : B4 AA       ;
                      BMI CODE_03900B                     ;; 039007 : 30 02       ;
                      EOR.B #$80                          ;; 039009 : 49 80       ;
CODE_03900B:          STA.B !_0                           ;; 03900B : 85 00       ;
                      LDY.W !SpriteOAMIndex,X             ;; 03900D : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$AC                          ;; 039010 : A9 AC       ;
                      STA.W !OAMTileNo+$100,Y             ;; 039012 : 99 02 03    ;
                      LDA.W !OAMTileAttr+$100,Y           ;; 039015 : B9 03 03    ;
                      AND.B #$31                          ;; 039018 : 29 31       ;
                      ORA.B !_0                           ;; 03901A : 05 00       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03901C : 99 03 03    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039020:          LDY.B #$0B                          ;; 039020 : A0 0B       ;
CODE_039022:          LDA.W !MinExtSpriteNumber,Y         ;; 039022 : B9 F0 17    ;
                      BEQ CODE_039037                     ;; 039025 : F0 10       ;
                      DEY                                 ;; 039027 : 88          ;
                      BPL CODE_039022                     ;; 039028 : 10 F8       ;
                      DEC.W !MinExtSpriteSlotIdx          ;; 03902A : CE 5D 18    ;
                      BPL ADDR_039034                     ;; 03902D : 10 05       ;
                      LDA.B #$0B                          ;; 03902F : A9 0B       ;
                      STA.W !MinExtSpriteSlotIdx          ;; 039031 : 8D 5D 18    ;
ADDR_039034:          LDY.W !MinExtSpriteSlotIdx          ;; 039034 : AC 5D 18    ;
CODE_039037:          LDA.B #$0A                          ;; 039037 : A9 0A       ;
                      STA.W !MinExtSpriteNumber,Y         ;; 039039 : 99 F0 17    ;
                      LDA.B !SpriteXPosLow,X              ;; 03903C : B5 E4       ;
                      STA.W !MinExtSpriteXPosLow,Y        ;; 03903E : 99 08 18    ;
                      LDA.W !SpriteYPosHigh,X             ;; 039041 : BD E0 14    ;
                      STA.W !MinExtSpriteXPosHigh,Y       ;; 039044 : 99 EA 18    ;
                      LDA.B !SpriteYPosLow,X              ;; 039047 : B5 D8       ;
                      STA.W !MinExtSpriteYPosLow,Y        ;; 039049 : 99 FC 17    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03904C : BD D4 14    ;
                      STA.W !MinExtSpriteYPosHigh,Y       ;; 03904F : 99 14 18    ;
                      LDA.B #$30                          ;; 039052 : A9 30       ;
                      STA.W !MinExtSpriteXPosSpx,Y        ;; 039054 : 99 50 18    ;
                      LDA.B !SpriteXSpeed,X               ;; 039057 : B5 B6       ;
                      STA.W !MinExtSpriteXSpeed,Y         ;; 039059 : 99 2C 18    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishinBooAccelX:      db $01,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooMaxSpeedX:   db $20,$E0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooAccelY:      db $01,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooMaxSpeedY:   db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBoo:            JSR FishinBooGfx                    ;; ?QPWZ? : 20 80 91    ;
                      LDA.B !SpriteLock                   ;; 039068 : A5 9D       ;
                      BNE Return0390EA                    ;; 03906A : D0 7E       ;
                      JSL MarioSprInteract                ;; 03906C : 22 DC A7 01 ;
                      JSR SubHorzPosBnk3                  ;; 039070 : 20 17 B8    ;
                      STZ.W !SpriteMisc1602,X             ;; 039073 : 9E 02 16    ;
                      LDA.W !SpriteMisc15AC,X             ;; 039076 : BD AC 15    ;
                      BEQ CODE_039086                     ;; 039079 : F0 0B       ;
                      INC.W !SpriteMisc1602,X             ;; 03907B : FE 02 16    ;
                      CMP.B #$10                          ;; 03907E : C9 10       ;
                      BNE CODE_039086                     ;; 039080 : D0 04       ;
                      TYA                                 ;; 039082 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 039083 : 9D 7C 15    ;
CODE_039086:          TXA                                 ;; 039086 : 8A          ;
                      ASL A                               ;; 039087 : 0A          ;
                      ASL A                               ;; 039088 : 0A          ;
                      ASL A                               ;; 039089 : 0A          ;
                      ASL A                               ;; 03908A : 0A          ;
                      ADC.B !TrueFrame                    ;; 03908B : 65 13       ;
                      AND.B #$3F                          ;; 03908D : 29 3F       ;
                      ORA.W !SpriteMisc15AC,X             ;; 03908F : 1D AC 15    ;
                      BNE CODE_039099                     ;; 039092 : D0 05       ;
                      LDA.B #$20                          ;; 039094 : A9 20       ;
                      STA.W !SpriteMisc15AC,X             ;; 039096 : 9D AC 15    ;
CODE_039099:          LDA.W !SpriteWillAppear             ;; 039099 : AD BF 18    ;
                      BEQ CODE_0390A2                     ;; 03909C : F0 04       ;
                      TYA                                 ;; 03909E : 98          ;
                      EOR.B #$01                          ;; 03909F : 49 01       ;
                      TAY                                 ;; 0390A1 : A8          ;
CODE_0390A2:          LDA.B !SpriteXSpeed,X               ;; 0390A2 : B5 B6       ; \ If not at max X speed, accelerate 
                      CMP.W FishinBooMaxSpeedX,Y          ;; 0390A4 : D9 5F 90    ;  | 
                      BEQ CODE_0390AF                     ;; 0390A7 : F0 06       ;  | 
                      CLC                                 ;; 0390A9 : 18          ;  | 
                      ADC.W FishinBooAccelX,Y             ;; 0390AA : 79 5D 90    ;  | 
                      STA.B !SpriteXSpeed,X               ;; 0390AD : 95 B6       ; / 
CODE_0390AF:          LDA.B !TrueFrame                    ;; 0390AF : A5 13       ;
                      AND.B #$01                          ;; 0390B1 : 29 01       ;
                      BNE CODE_0390C9                     ;; 0390B3 : D0 14       ;
                      LDA.B !SpriteTableC2,X              ;; 0390B5 : B5 C2       ;
                      AND.B #$01                          ;; 0390B7 : 29 01       ;
                      TAY                                 ;; 0390B9 : A8          ;
                      LDA.B !SpriteYSpeed,X               ;; 0390BA : B5 AA       ;
                      CLC                                 ;; 0390BC : 18          ;
                      ADC.W FishinBooAccelY,Y             ;; 0390BD : 79 61 90    ;
                      STA.B !SpriteYSpeed,X               ;; 0390C0 : 95 AA       ;
                      CMP.W FishinBooMaxSpeedY,Y          ;; 0390C2 : D9 63 90    ;
                      BNE CODE_0390C9                     ;; 0390C5 : D0 02       ;
                      INC.B !SpriteTableC2,X              ;; 0390C7 : F6 C2       ;
CODE_0390C9:          LDA.B !SpriteXSpeed,X               ;; 0390C9 : B5 B6       ;
                      PHA                                 ;; 0390CB : 48          ;
                      LDY.W !SpriteWillAppear             ;; 0390CC : AC BF 18    ;
                      BNE CODE_0390DC                     ;; 0390CF : D0 0B       ;
                      LDA.W !Layer1DXPos                  ;; 0390D1 : AD BD 17    ;
                      ASL A                               ;; 0390D4 : 0A          ;
                      ASL A                               ;; 0390D5 : 0A          ;
                      ASL A                               ;; 0390D6 : 0A          ;
                      CLC                                 ;; 0390D7 : 18          ;
                      ADC.B !SpriteXSpeed,X               ;; 0390D8 : 75 B6       ;
                      STA.B !SpriteXSpeed,X               ;; 0390DA : 95 B6       ;
CODE_0390DC:          JSL UpdateXPosNoGvtyW               ;; 0390DC : 22 22 80 01 ;
                      PLA                                 ;; 0390E0 : 68          ;
                      STA.B !SpriteXSpeed,X               ;; 0390E1 : 95 B6       ;
                      JSL UpdateYPosNoGvtyW               ;; 0390E3 : 22 1A 80 01 ;
                      JSR CODE_0390F3                     ;; 0390E7 : 20 F3 90    ;
Return0390EA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_0390EB:          db $1A,$14,$EE,$F8                  ;; 0390EB               ;
                                                          ;;                      ;
DATA_0390EF:          db $00,$00,$FF,$FF                  ;; 0390EF               ;
                                                          ;;                      ;
CODE_0390F3:          LDA.W !SpriteMisc157C,X             ;; 0390F3 : BD 7C 15    ;
                      ASL A                               ;; 0390F6 : 0A          ;
                      ADC.W !SpriteMisc1602,X             ;; 0390F7 : 7D 02 16    ;
                      TAY                                 ;; 0390FA : A8          ;
                      LDA.B !SpriteXPosLow,X              ;; 0390FB : B5 E4       ;
                      CLC                                 ;; 0390FD : 18          ;
                      ADC.W DATA_0390EB,Y                 ;; 0390FE : 79 EB 90    ;
                      STA.B !_4                           ;; 039101 : 85 04       ;
                      LDA.W !SpriteYPosHigh,X             ;; 039103 : BD E0 14    ;
                      ADC.W DATA_0390EF,Y                 ;; 039106 : 79 EF 90    ;
                      STA.B !_A                           ;; 039109 : 85 0A       ;
                      LDA.B #$04                          ;; 03910B : A9 04       ;
                      STA.B !_6                           ;; 03910D : 85 06       ;
                      STA.B !_7                           ;; 03910F : 85 07       ;
                      LDA.B !SpriteYPosLow,X              ;; 039111 : B5 D8       ;
                      CLC                                 ;; 039113 : 18          ;
                      ADC.B #$47                          ;; 039114 : 69 47       ;
                      STA.B !_5                           ;; 039116 : 85 05       ;
                      LDA.W !SpriteXPosHigh,X             ;; 039118 : BD D4 14    ;
                      ADC.B #$00                          ;; 03911B : 69 00       ;
                      STA.B !_B                           ;; 03911D : 85 0B       ;
                      JSL GetMarioClipping                ;; 03911F : 22 64 B6 03 ;
                      JSL CheckForContact                 ;; 039123 : 22 2B B7 03 ;
                      BCC Return03912D                    ;; 039127 : 90 04       ;
                      JSL HurtMario                       ;; 039129 : 22 B7 F5 00 ;
Return03912D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishinBooDispX:       db $FB,$05,$00,$F2,$FD,$03,$EA,$EA  ;; ?QPWZ?               ;
                      db $EA,$EA,$FB,$05,$00,$FA,$FD,$03  ;; ?QPWZ?               ;
                      db $F2,$F2,$F2,$F2,$FB,$05,$00,$0E  ;; ?QPWZ?               ;
                      db $03,$FD,$16,$16,$16,$16,$FB,$05  ;; ?QPWZ?               ;
                      db $00,$06,$03,$FD,$0E,$0E,$0E,$0E  ;; ?QPWZ?               ;
FishinBooDispY:       db $0B,$0B,$00,$03,$0F,$0F,$13,$23  ;; ?QPWZ?               ;
                      db $33,$43                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooTiles1:      db $60,$60,$64,$8A,$60,$60,$AC,$AC  ;; ?QPWZ?               ;
                      db $AC,$CE                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooGfxProp:     db $04,$04,$0D,$09,$04,$04,$0D,$0D  ;; ?QPWZ?               ;
                      db $0D,$07                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishinBooTiles2:      db $CC,$CE,$CC,$CE                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_039178:          db $00,$00,$40,$40                  ;; 039178               ;
                                                          ;;                      ;
DATA_03917C:          db $00,$40,$C0,$80                  ;; 03917C               ;
                                                          ;;                      ;
FishinBooGfx:         JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc1602,X             ;; 039183 : BD 02 16    ;
                      STA.B !_4                           ;; 039186 : 85 04       ;
                      LDA.W !SpriteMisc157C,X             ;; 039188 : BD 7C 15    ;
                      STA.B !_2                           ;; 03918B : 85 02       ;
                      PHX                                 ;; 03918D : DA          ;
                      PHY                                 ;; 03918E : 5A          ;
                      LDX.B #$09                          ;; 03918F : A2 09       ;
CODE_039191:          LDA.B !_1                           ;; 039191 : A5 01       ;
                      CLC                                 ;; 039193 : 18          ;
                      ADC.W FishinBooDispY,X              ;; 039194 : 7D 56 91    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039197 : 99 01 03    ;
                      STZ.B !_3                           ;; 03919A : 64 03       ;
                      LDA.W FishinBooTiles1,X             ;; 03919C : BD 60 91    ;
                      CPX.B #$09                          ;; 03919F : E0 09       ;
                      BNE CODE_0391B4                     ;; 0391A1 : D0 11       ;
                      LDA.B !EffFrame                     ;; 0391A3 : A5 14       ;
                      LSR A                               ;; 0391A5 : 4A          ;
                      LSR A                               ;; 0391A6 : 4A          ;
                      PHX                                 ;; 0391A7 : DA          ;
                      AND.B #$03                          ;; 0391A8 : 29 03       ;
                      TAX                                 ;; 0391AA : AA          ;
                      LDA.W DATA_039178,X                 ;; 0391AB : BD 78 91    ;
                      STA.B !_3                           ;; 0391AE : 85 03       ;
                      LDA.W FishinBooTiles2,X             ;; 0391B0 : BD 74 91    ;
                      PLX                                 ;; 0391B3 : FA          ;
CODE_0391B4:          STA.W !OAMTileNo+$100,Y             ;; 0391B4 : 99 02 03    ;
                      LDA.B !_2                           ;; 0391B7 : A5 02       ;
                      CMP.B #$01                          ;; 0391B9 : C9 01       ;
                      LDA.W FishinBooGfxProp,X            ;; 0391BB : BD 6A 91    ;
                      EOR.B !_3                           ;; 0391BE : 45 03       ;
                      ORA.B !SpriteProperties             ;; 0391C0 : 05 64       ;
                      BCS CODE_0391C6                     ;; 0391C2 : B0 02       ;
                      EOR.B #$40                          ;; 0391C4 : 49 40       ;
CODE_0391C6:          STA.W !OAMTileAttr+$100,Y           ;; 0391C6 : 99 03 03    ;
                      PHX                                 ;; 0391C9 : DA          ;
                      LDA.B !_4                           ;; 0391CA : A5 04       ;
                      BEQ CODE_0391D3                     ;; 0391CC : F0 05       ;
                      TXA                                 ;; 0391CE : 8A          ;
                      CLC                                 ;; 0391CF : 18          ;
                      ADC.B #$0A                          ;; 0391D0 : 69 0A       ;
                      TAX                                 ;; 0391D2 : AA          ;
CODE_0391D3:          LDA.B !_2                           ;; 0391D3 : A5 02       ;
                      BNE CODE_0391DC                     ;; 0391D5 : D0 05       ;
                      TXA                                 ;; 0391D7 : 8A          ;
                      CLC                                 ;; 0391D8 : 18          ;
                      ADC.B #$14                          ;; 0391D9 : 69 14       ;
                      TAX                                 ;; 0391DB : AA          ;
CODE_0391DC:          LDA.B !_0                           ;; 0391DC : A5 00       ;
                      CLC                                 ;; 0391DE : 18          ;
                      ADC.W FishinBooDispX,X              ;; 0391DF : 7D 2E 91    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 0391E2 : 99 00 03    ;
                      PLX                                 ;; 0391E5 : FA          ;
                      INY                                 ;; 0391E6 : C8          ;
                      INY                                 ;; 0391E7 : C8          ;
                      INY                                 ;; 0391E8 : C8          ;
                      INY                                 ;; 0391E9 : C8          ;
                      DEX                                 ;; 0391EA : CA          ;
                      BPL CODE_039191                     ;; 0391EB : 10 A4       ;
                      LDA.B !EffFrame                     ;; 0391ED : A5 14       ;
                      LSR A                               ;; 0391EF : 4A          ;
                      LSR A                               ;; 0391F0 : 4A          ;
                      LSR A                               ;; 0391F1 : 4A          ;
                      AND.B #$03                          ;; 0391F2 : 29 03       ;
                      TAX                                 ;; 0391F4 : AA          ;
                      PLY                                 ;; 0391F5 : 7A          ;
                      LDA.W DATA_03917C,X                 ;; 0391F6 : BD 7C 91    ;
                      EOR.W !OAMTileAttr+$110,Y           ;; 0391F9 : 59 13 03    ;
                      STA.W !OAMTileAttr+$110,Y           ;; 0391FC : 99 13 03    ;
                      STA.W !OAMTileAttr+$124,Y           ;; 0391FF : 99 27 03    ;
                      EOR.B #$C0                          ;; 039202 : 49 C0       ;
                      STA.W !OAMTileAttr+$114,Y           ;; 039204 : 99 17 03    ;
                      STA.W !OAMTileAttr+$120,Y           ;; 039207 : 99 23 03    ;
                      PLX                                 ;; 03920A : FA          ;
                      LDY.B #$02                          ;; 03920B : A0 02       ;
                      LDA.B #$09                          ;; 03920D : A9 09       ;
                      JSL FinishOAMWrite                  ;; 03920F : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
FallingSpike:         JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 039218 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$E0                          ;; 03921B : A9 E0       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03921D : 99 02 03    ;
                      LDA.W !OAMTileYPos+$100,Y           ;; 039220 : B9 01 03    ;
                      DEC A                               ;; 039223 : 3A          ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039224 : 99 01 03    ;
                      LDA.W !SpriteMisc1540,X             ;; 039227 : BD 40 15    ;
                      BEQ CODE_039237                     ;; 03922A : F0 0B       ;
                      LSR A                               ;; 03922C : 4A          ;
                      LSR A                               ;; 03922D : 4A          ;
                      AND.B #$01                          ;; 03922E : 29 01       ;
                      CLC                                 ;; 039230 : 18          ;
                      ADC.W !OAMTileXPos+$100,Y           ;; 039231 : 79 00 03    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 039234 : 99 00 03    ;
CODE_039237:          LDA.B !SpriteLock                   ;; 039237 : A5 9D       ;
                      BNE CODE_03926C                     ;; 039239 : D0 31       ;
                      JSR SubOffscreen0Bnk3               ;; 03923B : 20 5D B8    ;
                      JSL UpdateSpritePos                 ;; 03923E : 22 2A 80 01 ;
                      LDA.B !SpriteTableC2,X              ;; 039242 : B5 C2       ;
                      JSL ExecutePtr                      ;; 039244 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03924C                      ;; ?QPWZ? : 4C 92       ;
                      dw CODE_039262                      ;; ?QPWZ? : 62 92       ;
                                                          ;;                      ;
CODE_03924C:          STZ.B !SpriteYSpeed,X               ;; 03924C : 74 AA       ; Sprite Y Speed = 0 
                      JSR SubHorzPosBnk3                  ;; 03924E : 20 17 B8    ;
                      LDA.B !_F                           ;; 039251 : A5 0F       ;
                      CLC                                 ;; 039253 : 18          ;
                      ADC.B #$40                          ;; 039254 : 69 40       ;
                      CMP.B #$80                          ;; 039256 : C9 80       ;
                      BCS Return039261                    ;; 039258 : B0 07       ;
                      INC.B !SpriteTableC2,X              ;; 03925A : F6 C2       ;
                      LDA.B #$40                          ;; 03925C : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 03925E : 9D 40 15    ;
Return039261:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039262:          LDA.W !SpriteMisc1540,X             ;; 039262 : BD 40 15    ;
                      BNE CODE_03926C                     ;; 039265 : D0 05       ;
                      JSL MarioSprInteract                ;; 039267 : 22 DC A7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03926C:          STZ.B !SpriteYSpeed,X               ;; 03926C : 74 AA       ; Sprite Y Speed = 0 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
CrtEatBlkSpeedX:      db $10,$F0,$00,$00,$00              ;; ?QPWZ?               ;
                                                          ;;                      ;
CrtEatBlkSpeedY:      db $00,$00,$10,$F0,$00              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_039279:          db $00,$00,$01,$00,$02,$00,$00,$00  ;; 039279               ;
                      db $03,$00,$00                      ;; ?QPWZ?               ;
                                                          ;;                      ;
CreateEatBlock:       JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 039288 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !OAMTileYPos+$100,Y           ;; 03928B : B9 01 03    ;
                      DEC A                               ;; 03928E : 3A          ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03928F : 99 01 03    ;
                      LDA.B #$2E                          ;; 039292 : A9 2E       ;
                      STA.W !OAMTileNo+$100,Y             ;; 039294 : 99 02 03    ;
                      LDA.W !OAMTileAttr+$100,Y           ;; 039297 : B9 03 03    ;
                      AND.B #$3F                          ;; 03929A : 29 3F       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03929C : 99 03 03    ;
                      LDY.B #$02                          ;; 03929F : A0 02       ;
                      LDA.B #$00                          ;; 0392A1 : A9 00       ;
                      JSL FinishOAMWrite                  ;; 0392A3 : 22 B3 B7 01 ;
                      LDY.B #$04                          ;; 0392A7 : A0 04       ;
                      LDA.W !BlockSnakeActive             ;; 0392A9 : AD 09 19    ;
                      CMP.B #$FF                          ;; 0392AC : C9 FF       ;
                      BEQ CODE_0392C0                     ;; 0392AE : F0 10       ;
                      LDA.B !TrueFrame                    ;; 0392B0 : A5 13       ;
                      AND.B #$03                          ;; 0392B2 : 29 03       ;
                      ORA.B !SpriteLock                   ;; 0392B4 : 05 9D       ;
                      BNE CODE_0392BD                     ;; 0392B6 : D0 05       ;
                      LDA.B #$04                          ;; 0392B8 : A9 04       ; \ Play sound effect 
                      STA.W !SPCIO1                       ;; 0392BA : 8D FA 1D    ; / 
CODE_0392BD:          LDY.W !SpriteMisc157C,X             ;; 0392BD : BC 7C 15    ;
CODE_0392C0:          LDA.B !SpriteLock                   ;; 0392C0 : A5 9D       ;
                      BNE Return03932B                    ;; 0392C2 : D0 67       ;
                      LDA.W CrtEatBlkSpeedX,Y             ;; 0392C4 : B9 6F 92    ;
                      STA.B !SpriteXSpeed,X               ;; 0392C7 : 95 B6       ;
                      LDA.W CrtEatBlkSpeedY,Y             ;; 0392C9 : B9 74 92    ;
                      STA.B !SpriteYSpeed,X               ;; 0392CC : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 0392CE : 22 1A 80 01 ;
                      JSL UpdateXPosNoGvtyW               ;; 0392D2 : 22 22 80 01 ;
                      STZ.W !SpriteMisc1528,X             ;; 0392D6 : 9E 28 15    ;
                      JSL InvisBlkMainRt                  ;; 0392D9 : 22 4F B4 01 ;
                      LDA.W !BlockSnakeActive             ;; 0392DD : AD 09 19    ;
                      CMP.B #$FF                          ;; 0392E0 : C9 FF       ;
                      BEQ Return03932B                    ;; 0392E2 : F0 47       ;
                      LDA.B !SpriteYPosLow,X              ;; 0392E4 : B5 D8       ;
                      ORA.B !SpriteXPosLow,X              ;; 0392E6 : 15 E4       ;
                      AND.B #$0F                          ;; 0392E8 : 29 0F       ;
                      BNE Return03932B                    ;; 0392EA : D0 3F       ;
                      LDA.W !SpriteMisc151C,X             ;; 0392EC : BD 1C 15    ;
                      BNE CODE_03932C                     ;; 0392EF : D0 3B       ;
                      DEC.W !SpriteMisc1570,X             ;; 0392F1 : DE 70 15    ;
                      BMI CODE_0392F8                     ;; 0392F4 : 30 02       ;
                      BNE CODE_03931F                     ;; 0392F6 : D0 27       ;
CODE_0392F8:          LDY.W !PlayerTurnLvl                ;; 0392F8 : AC B3 0D    ;
                      LDA.W !OWPlayerSubmap,Y             ;; 0392FB : B9 11 1F    ;
                      CMP.B #$01                          ;; 0392FE : C9 01       ;
                      LDY.W !SpriteMisc1534,X             ;; 039300 : BC 34 15    ;
                      INC.W !SpriteMisc1534,X             ;; 039303 : FE 34 15    ;
                      LDA.W CrtEatBlkData1,Y              ;; 039306 : B9 A4 93    ;
                      BCS CODE_03930E                     ;; 039309 : B0 03       ;
                      LDA.W CrtEatBlkData2,Y              ;; 03930B : B9 EF 93    ;
CODE_03930E:          STA.W !SpriteMisc1602,X             ;; 03930E : 9D 02 16    ;
                      PHA                                 ;; 039311 : 48          ;
                      LSR A                               ;; 039312 : 4A          ;
                      LSR A                               ;; 039313 : 4A          ;
                      LSR A                               ;; 039314 : 4A          ;
                      LSR A                               ;; 039315 : 4A          ;
                      STA.W !SpriteMisc1570,X             ;; 039316 : 9D 70 15    ;
                      PLA                                 ;; 039319 : 68          ;
                      AND.B #$03                          ;; 03931A : 29 03       ;
                      STA.W !SpriteMisc157C,X             ;; 03931C : 9D 7C 15    ;
CODE_03931F:          LDA.B #$0D                          ;; 03931F : A9 0D       ;
                      JSR GenTileFromSpr1                 ;; 039321 : 20 8B 93    ;
                      LDA.W !SpriteMisc1602,X             ;; 039324 : BD 02 16    ;
                      CMP.B #$FF                          ;; 039327 : C9 FF       ;
                      BEQ CODE_039387                     ;; 039329 : F0 5C       ;
Return03932B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03932C:          LDA.B #$02                          ;; 03932C : A9 02       ;
                      JSR GenTileFromSpr1                 ;; 03932E : 20 8B 93    ;
                      LDA.B #$01                          ;; 039331 : A9 01       ;
                      STA.B !SpriteXSpeed,X               ;; 039333 : 95 B6       ;
                      STA.B !SpriteYSpeed,X               ;; 039335 : 95 AA       ;
                      JSL CODE_019138                     ;; 039337 : 22 38 91 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 03933B : BD 88 15    ;
                      PHA                                 ;; 03933E : 48          ;
                      LDA.B #$FF                          ;; 03933F : A9 FF       ;
                      STA.B !SpriteXSpeed,X               ;; 039341 : 95 B6       ;
                      STA.B !SpriteYSpeed,X               ;; 039343 : 95 AA       ;
                      LDA.B !SpriteXPosLow,X              ;; 039345 : B5 E4       ;
                      PHA                                 ;; 039347 : 48          ;
                      SEC                                 ;; 039348 : 38          ;
                      SBC.B #$01                          ;; 039349 : E9 01       ;
                      STA.B !SpriteXPosLow,X              ;; 03934B : 95 E4       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03934D : BD E0 14    ;
                      PHA                                 ;; 039350 : 48          ;
                      SBC.B #$00                          ;; 039351 : E9 00       ;
                      STA.W !SpriteYPosHigh,X             ;; 039353 : 9D E0 14    ;
                      LDA.B !SpriteYPosLow,X              ;; 039356 : B5 D8       ;
                      PHA                                 ;; 039358 : 48          ;
                      SEC                                 ;; 039359 : 38          ;
                      SBC.B #$01                          ;; 03935A : E9 01       ;
                      STA.B !SpriteYPosLow,X              ;; 03935C : 95 D8       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03935E : BD D4 14    ;
                      PHA                                 ;; 039361 : 48          ;
                      SBC.B #$00                          ;; 039362 : E9 00       ;
                      STA.W !SpriteXPosHigh,X             ;; 039364 : 9D D4 14    ;
                      JSL CODE_019138                     ;; 039367 : 22 38 91 01 ;
                      PLA                                 ;; 03936B : 68          ;
                      STA.W !SpriteXPosHigh,X             ;; 03936C : 9D D4 14    ;
                      PLA                                 ;; 03936F : 68          ;
                      STA.B !SpriteYPosLow,X              ;; 039370 : 95 D8       ;
                      PLA                                 ;; 039372 : 68          ;
                      STA.W !SpriteYPosHigh,X             ;; 039373 : 9D E0 14    ;
                      PLA                                 ;; 039376 : 68          ;
                      STA.B !SpriteXPosLow,X              ;; 039377 : 95 E4       ;
                      PLA                                 ;; 039379 : 68          ;
                      ORA.W !SpriteBlockedDirs,X          ;; 03937A : 1D 88 15    ;
                      BEQ CODE_039387                     ;; 03937D : F0 08       ;
                      TAY                                 ;; 03937F : A8          ;
                      LDA.W DATA_039279,Y                 ;; 039380 : B9 79 92    ;
                      STA.W !SpriteMisc157C,X             ;; 039383 : 9D 7C 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039387:          STZ.W !SpriteStatus,X               ;; 039387 : 9E C8 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
GenTileFromSpr1:      STA.B !Map16TileGenerate            ;; ?QPWZ? : 85 9C       ; $9C = tile to generate 
                      LDA.B !SpriteXPosLow,X              ;; 03938D : B5 E4       ; \ $9A = Sprite X position 
                      STA.B !TouchBlockXPos               ;; 03938F : 85 9A       ;  | for block creation 
                      LDA.W !SpriteYPosHigh,X             ;; 039391 : BD E0 14    ;  | 
                      STA.B !TouchBlockXPos+1             ;; 039394 : 85 9B       ; / 
                      LDA.B !SpriteYPosLow,X              ;; 039396 : B5 D8       ; \ $98 = Sprite Y position 
                      STA.B !TouchBlockYPos               ;; 039398 : 85 98       ;  | for block creation 
                      LDA.W !SpriteXPosHigh,X             ;; 03939A : BD D4 14    ;  | 
                      STA.B !TouchBlockYPos+1             ;; 03939D : 85 99       ; / 
                      JSL GenerateTile                    ;; 03939F : 22 B0 BE 00 ; Generate the tile 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
CrtEatBlkData1:       db $10,$13,$10,$13,$10,$13,$10,$13  ;; ?QPWZ?               ;
                      db $10,$13,$10,$13,$10,$13,$10,$13  ;; ?QPWZ?               ;
                      db $F0,$F0,$20,$12,$10,$12,$10,$12  ;; ?QPWZ?               ;
                      db $10,$12,$10,$12,$10,$12,$10,$12  ;; ?QPWZ?               ;
                      db $D0,$C3,$F1,$21,$22,$F1,$F1,$51  ;; ?QPWZ?               ;
                      db $43,$10,$13,$10,$13,$10,$13,$F0  ;; ?QPWZ?               ;
                      db $F0,$F0,$60,$32,$60,$32,$71,$32  ;; ?QPWZ?               ;
                      db $60,$32,$61,$32,$70,$33,$10,$33  ;; ?QPWZ?               ;
                      db $10,$33,$10,$33,$10,$33,$F0,$10  ;; ?QPWZ?               ;
                      db $F2,$52,$FF                      ;; ?QPWZ?               ;
                                                          ;;                      ;
CrtEatBlkData2:       db $80,$13,$10,$13,$10,$13,$10,$13  ;; ?QPWZ?               ;
                      db $60,$23,$20,$23,$B0,$22,$A1,$22  ;; ?QPWZ?               ;
                      db $A0,$22,$A1,$22,$C0,$13,$10,$13  ;; ?QPWZ?               ;
                      db $10,$13,$10,$13,$10,$13,$10,$13  ;; ?QPWZ?               ;
                      db $10,$13,$F0,$F0,$F0,$52,$50,$33  ;; ?QPWZ?               ;
                      db $50,$32,$50,$33,$50,$22,$50,$33  ;; ?QPWZ?               ;
                      db $F0,$50,$82,$FF                  ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodenSpike:          JSR WoodSpikeGfx                    ;; ?QPWZ? : 20 CF 94    ;
                      LDA.B !SpriteLock                   ;; 039426 : A5 9D       ;
                      BNE Return039440                    ;; 039428 : D0 16       ;
                      JSR SubOffscreen0Bnk3               ;; 03942A : 20 5D B8    ;
                      JSR CODE_039488                     ;; 03942D : 20 88 94    ;
                      LDA.B !SpriteTableC2,X              ;; 039430 : B5 C2       ;
                      AND.B #$03                          ;; 039432 : 29 03       ;
                      JSL ExecutePtr                      ;; 039434 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_039458                      ;; ?QPWZ? : 58 94       ;
                      dw CODE_03944E                      ;; ?QPWZ? : 4E 94       ;
                      dw CODE_039441                      ;; ?QPWZ? : 41 94       ;
                      dw CODE_03946B                      ;; ?QPWZ? : 6B 94       ;
                                                          ;;                      ;
Return039440:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039441:          LDA.W !SpriteMisc1540,X             ;; 039441 : BD 40 15    ;
                      BEQ CODE_03944A                     ;; 039444 : F0 04       ;
                      LDA.B #$20                          ;; 039446 : A9 20       ;
                      BRA CODE_039475                     ;; 039448 : 80 2B       ;
                                                          ;;                      ;
CODE_03944A:          LDA.B #$30                          ;; 03944A : A9 30       ;
                      BRA SetTimerNextState               ;; 03944C : 80 17       ;
                                                          ;;                      ;
CODE_03944E:          LDA.W !SpriteMisc1540,X             ;; 03944E : BD 40 15    ;
                      BNE Return039457                    ;; 039451 : D0 04       ;
                      LDA.B #$18                          ;; 039453 : A9 18       ;
                      BRA SetTimerNextState               ;; 039455 : 80 0E       ;
                                                          ;;                      ;
Return039457:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039458:          LDA.W !SpriteMisc1540,X             ;; 039458 : BD 40 15    ;
                      BEQ CODE_039463                     ;; 03945B : F0 06       ;
                      LDA.B #$F0                          ;; 03945D : A9 F0       ;
                      JSR CODE_039475                     ;; 03945F : 20 75 94    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039463:          LDA.B #$30                          ;; 039463 : A9 30       ;
SetTimerNextState:    STA.W !SpriteMisc1540,X             ;; ?QPWZ? : 9D 40 15    ;
                      INC.B !SpriteTableC2,X              ;; 039468 : F6 C2       ; Goto next state 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03946B:          LDA.W !SpriteMisc1540,X             ;; 03946B : BD 40 15    ; \ If stall timer us up, 
                      BNE Return039474                    ;; 03946E : D0 04       ;  | reset it to #$2F... 
                      LDA.B #$2F                          ;; 039470 : A9 2F       ;  | 
                      BRA SetTimerNextState               ;; 039472 : 80 F1       ;  | ...and goto next state 
                                                          ;;                      ;
Return039474:         RTS                                 ;; ?QPWZ? : 60          ; / 
                                                          ;;                      ;
CODE_039475:          LDY.W !SpriteMisc151C,X             ;; 039475 : BC 1C 15    ;
                      BEQ CODE_03947D                     ;; 039478 : F0 03       ;
                      EOR.B #$FF                          ;; 03947A : 49 FF       ;
                      INC A                               ;; 03947C : 1A          ;
CODE_03947D:          STA.B !SpriteYSpeed,X               ;; 03947D : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 03947F : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_039484:          db $01,$FF                          ;; 039484               ;
                                                          ;;                      ;
DATA_039486:          db $00,$FF                          ;; 039486               ;
                                                          ;;                      ;
CODE_039488:          JSL MarioSprInteract                ;; 039488 : 22 DC A7 01 ;
                      BCC Return0394B0                    ;; 03948C : 90 22       ;
                      JSR SubHorzPosBnk3                  ;; 03948E : 20 17 B8    ;
                      LDA.B !_F                           ;; 039491 : A5 0F       ;
                      CLC                                 ;; 039493 : 18          ;
                      ADC.B #$04                          ;; 039494 : 69 04       ;
                      CMP.B #$08                          ;; 039496 : C9 08       ;
                      BCS CODE_03949F                     ;; 039498 : B0 05       ;
                      JSL HurtMario                       ;; 03949A : 22 B7 F5 00 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03949F:          LDA.B !PlayerXPosNext               ;; 03949F : A5 94       ;
                      CLC                                 ;; 0394A1 : 18          ;
                      ADC.W DATA_039484,Y                 ;; 0394A2 : 79 84 94    ;
                      STA.B !PlayerXPosNext               ;; 0394A5 : 85 94       ;
                      LDA.B !PlayerXPosNext+1             ;; 0394A7 : A5 95       ;
                      ADC.W DATA_039486,Y                 ;; 0394A9 : 79 86 94    ;
                      STA.B !PlayerXPosNext+1             ;; 0394AC : 85 95       ;
                      STZ.B !PlayerXSpeed                 ;; 0394AE : 64 7B       ;
Return0394B0:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
WoodSpikeDispY:       db $00,$10,$20,$30,$40,$40,$30,$20  ;; ?QPWZ?               ;
                      db $10,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeTiles:       db $6A,$6A,$6A,$6A,$4A,$6A,$6A,$6A  ;; ?QPWZ?               ;
                      db $6A,$4A                          ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeGfxProp:     db $81,$81,$81,$81,$81,$01,$01,$01  ;; ?QPWZ?               ;
                      db $01,$01                          ;; ?QPWZ?               ;
                                                          ;;                      ;
WoodSpikeGfx:         JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      STZ.B !_2                           ;; 0394D2 : 64 02       ; \ Set $02 based on sprite number 
                      LDA.B !SpriteNumber,X               ;; 0394D4 : B5 9E       ;  | 
                      CMP.B #$AD                          ;; 0394D6 : C9 AD       ;  | 
                      BNE CODE_0394DE                     ;; 0394D8 : D0 04       ;  | 
                      LDA.B #$05                          ;; 0394DA : A9 05       ;  | 
                      STA.B !_2                           ;; 0394DC : 85 02       ; / 
CODE_0394DE:          PHX                                 ;; 0394DE : DA          ;
                      LDX.B #$04                          ;; 0394DF : A2 04       ; Draw 4 tiles: 
WoodSpikeGfxLoopSt:   PHX                                 ;; ?QPWZ? : DA          ;
                      TXA                                 ;; 0394E2 : 8A          ;
                      CLC                                 ;; 0394E3 : 18          ;
                      ADC.B !_2                           ;; 0394E4 : 65 02       ;
                      TAX                                 ;; 0394E6 : AA          ;
                      LDA.B !_0                           ;; 0394E7 : A5 00       ; \ Set X 
                      STA.W !OAMTileXPos+$100,Y           ;; 0394E9 : 99 00 03    ; / 
                      LDA.B !_1                           ;; 0394EC : A5 01       ; \ Set Y 
                      CLC                                 ;; 0394EE : 18          ;  | 
                      ADC.W WoodSpikeDispY,X              ;; 0394EF : 7D B1 94    ;  | 
                      STA.W !OAMTileYPos+$100,Y           ;; 0394F2 : 99 01 03    ; / 
                      LDA.W WoodSpikeTiles,X              ;; 0394F5 : BD BB 94    ; \ Set tile 
                      STA.W !OAMTileNo+$100,Y             ;; 0394F8 : 99 02 03    ; / 
                      LDA.W WoodSpikeGfxProp,X            ;; 0394FB : BD C5 94    ; \ Set gfs properties 
                      STA.W !OAMTileAttr+$100,Y           ;; 0394FE : 99 03 03    ; / 
                      INY                                 ;; 039501 : C8          ; \ We wrote 4 times, so increase index by 4 
                      INY                                 ;; 039502 : C8          ;  | 
                      INY                                 ;; 039503 : C8          ;  | 
                      INY                                 ;; 039504 : C8          ; / 
                      PLX                                 ;; 039505 : FA          ;
                      DEX                                 ;; 039506 : CA          ;
                      BPL WoodSpikeGfxLoopSt              ;; 039507 : 10 D8       ;
                      PLX                                 ;; 039509 : FA          ;
                      LDY.B #$02                          ;; 03950A : A0 02       ; \ Wrote 5 16x16 tiles... 
                      LDA.B #$04                          ;; 03950C : A9 04       ;  | 
                      JSL FinishOAMWrite                  ;; 03950E : 22 B3 B7 01 ; / 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
RexSpeed:             db $08,$F8,$10,$F0                  ;; ?QPWZ?               ;
                                                          ;;                      ;
RexMainRt:            JSR RexGfxRt                        ;; ?QPWZ? : 20 7E 96    ; Draw Rex gfx							        
                      LDA.W !SpriteStatus,X               ;; 03951A : BD C8 14    ; \ If Rex status != 8...						        
                      CMP.B #$08                          ;; 03951D : C9 08       ;  |   ... not (killed with spin jump [4] or star [2])		        
                      BNE RexReturn                       ;; 03951F : D0 12       ; /    ... return							        
                      LDA.B !SpriteLock                   ;; 039521 : A5 9D       ; \ If sprites locked...						        
                      BNE RexReturn                       ;; 039523 : D0 0E       ; /    ... return							        
                      LDA.W !SpriteMisc1558,X             ;; 039525 : BD 58 15    ; \ If Rex not defeated (timer to show remains > 0)...		        
                      BEQ RexAlive                        ;; 039528 : F0 0A       ; /    ... goto RexAlive						        
                      STA.W !SpriteOnYoshiTongue,X        ;; 03952A : 9D D0 15    ; \ 								        
                      DEC A                               ;; 03952D : 3A          ;  |   If Rex remains don't disappear next frame...			        
                      BNE RexReturn                       ;; 03952E : D0 03       ; /    ... return							        
                      STZ.W !SpriteStatus,X               ;; 039530 : 9E C8 14    ; This is the last frame to show remains, so set Rex status = 0 
RexReturn:            RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexAlive:             JSR SubOffscreen0Bnk3               ;; ?QPWZ? : 20 5D B8    ; Only process Rex while on screen		    
                      INC.W !SpriteMisc1570,X             ;; 039537 : FE 70 15    ; Increment number of frames Rex has been on sc 
                      LDA.W !SpriteMisc1570,X             ;; 03953A : BD 70 15    ; \ Calculate which frame to show:		    
                      LSR A                               ;; 03953D : 4A          ;  | 					    
                      LSR A                               ;; 03953E : 4A          ;  | 					    
                      LDY.B !SpriteTableC2,X              ;; 03953F : B4 C2       ;  | Number of hits determines if smushed	    
                      BEQ CODE_03954A                     ;; 039541 : F0 07       ;  |						    
                      AND.B #$01                          ;; 039543 : 29 01       ;  | Update every 8 cycles if smushed	    
                      CLC                                 ;; 039545 : 18          ;  |						    
                      ADC.B #$03                          ;; 039546 : 69 03       ;  | Show smushed frame			    
                      BRA CODE_03954D                     ;; 039548 : 80 03       ;  |						    
                                                          ;;                      ;
CODE_03954A:          LSR A                               ;; 03954A : 4A          ;  | 					    
                      AND.B #$01                          ;; 03954B : 29 01       ;  | Update every 16 cycles if normal	    
CODE_03954D:          STA.W !SpriteMisc1602,X             ;; 03954D : 9D 02 16    ; / Write frame to show			    
                      LDA.W !SpriteBlockedDirs,X          ;; 039550 : BD 88 15    ; \  If sprite is not on ground...		    
                      AND.B #$04                          ;; 039553 : 29 04       ;  |    ...(4 = on ground) ...		    
                      BEQ RexInAir                        ;; 039555 : F0 12       ; /     ...goto IN_AIR			    
                      LDA.B #$10                          ;; 039557 : A9 10       ; \  Y speed = 10				    
                      STA.B !SpriteYSpeed,X               ;; 039559 : 95 AA       ; /						    
                      LDY.W !SpriteMisc157C,X             ;; 03955B : BC 7C 15    ; Load, y = Rex direction, as index for speed   
                      LDA.B !SpriteTableC2,X              ;; 03955E : B5 C2       ; \ If hits on Rex == 0...			    
                      BEQ RexNoAdjustSpeed                ;; 039560 : F0 02       ; /    ...goto DONT_ADJUST_SPEED		    
                      INY                                 ;; 039562 : C8          ; \ Increment y twice...			    
                      INY                                 ;; 039563 : C8          ; /    ...in order to get speed for smushed Rex 
RexNoAdjustSpeed:     LDA.W RexSpeed,Y                    ;; ?QPWZ? : B9 13 95    ; \ Load x speed from ROM...		    
                      STA.B !SpriteXSpeed,X               ;; 039567 : 95 B6       ; /    ...and store it			    
RexInAir:             LDA.W !SpriteMisc1FE2,X             ;; ?QPWZ? : BD E2 1F    ; \ If time to show half-smushed Rex > 0...	    
                      BNE RexHalfSmushed                  ;; 03956C : D0 04       ; /    ...goto HALF_SMUSHED			    
                      JSL UpdateSpritePos                 ;; 03956E : 22 2A 80 01 ; Update position based on speed values	    
RexHalfSmushed:       LDA.W !SpriteBlockedDirs,X          ;; ?QPWZ? : BD 88 15    ; \ If Rex is touching the side of an object... 
                      AND.B #$03                          ;; 039575 : 29 03       ;  |					        
                      BEQ CODE_039581                     ;; 039577 : F0 08       ;  |					        
                      LDA.W !SpriteMisc157C,X             ;; 039579 : BD 7C 15    ;  |					        
                      EOR.B #$01                          ;; 03957C : 49 01       ;  |    ... change Rex direction	        
                      STA.W !SpriteMisc157C,X             ;; 03957E : 9D 7C 15    ; /					        
CODE_039581:          JSL SprSprInteract                  ;; 039581 : 22 32 80 01 ; Interact with other sprites	        
                      JSL MarioSprInteract                ;; 039585 : 22 DC A7 01 ; Check for mario/Rex contact 
                      BCC NoRexContact                    ;; 039589 : 90 52       ; (carry set = mario/Rex contact)	        
                      LDA.W !InvinsibilityTimer           ;; 03958B : AD 90 14    ; \ If mario star timer > 0 ...	        
                      BNE RexStarKill                     ;; 03958E : D0 62       ; /    ... goto HAS_STAR		        
                      LDA.W !SpriteMisc154C,X             ;; 039590 : BD 4C 15    ; \ If Rex invincibility timer > 0 ...      
                      BNE NoRexContact                    ;; 039593 : D0 48       ; /    ... goto NO_CONTACT		        
                      LDA.B #$08                          ;; 039595 : A9 08       ; \ Rex invincibility timer = $08	        
                      STA.W !SpriteMisc154C,X             ;; 039597 : 9D 4C 15    ; /					        
                      LDA.B !PlayerYSpeed                 ;; 03959A : A5 7D       ; \  If mario's y speed < 10 ...	        
                      CMP.B #$10                          ;; 03959C : C9 10       ;  |   ... Rex will hurt mario	        
                      BMI RexWins                         ;; 03959E : 30 2A       ; /    				        
                      JSR RexPoints                       ;; ?QPWZ? : 20 28 96    ; Give mario points			        
                      JSL BoostMarioSpeed                 ;; 0395A3 : 22 33 AA 01 ; Set mario speed			        
                      JSL DisplayContactGfx               ;; 0395A7 : 22 99 AB 01 ; Display contact graphic		        
                      LDA.W !SpinJumpFlag                 ;; 0395AB : AD 0D 14    ; \  If mario is spin jumping...	        
                      ORA.W !PlayerRidingYoshi            ;; 0395AE : 0D 7A 18    ;  |    ... or on yoshi ...		        
                      BNE RexSpinKill                     ;; 0395B1 : D0 2B       ; /     ... goto SPIN_KILL		        
                      INC.B !SpriteTableC2,X              ;; 0395B3 : F6 C2       ; Increment Rex hit counter		        
                      LDA.B !SpriteTableC2,X              ;; 0395B5 : B5 C2       ; \  If Rex hit counter == 2	        
                      CMP.B #$02                          ;; 0395B7 : C9 02       ;  |   				        
                      BNE SmushRex                        ;; 0395B9 : D0 06       ;  |				        
                      LDA.B #$20                          ;; 0395BB : A9 20       ;  |    ... time to show defeated Rex = $20 
                      STA.W !SpriteMisc1558,X             ;; 0395BD : 9D 58 15    ; / 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SmushRex:             LDA.B #$0C                          ;; ?QPWZ? : A9 0C       ; \ Time to show semi-squashed Rex = $0C 
                      STA.W !SpriteMisc1FE2,X             ;; 0395C3 : 9D E2 1F    ; /					     
                      STZ.W !SpriteTweakerB,X             ;; 0395C6 : 9E 62 16    ; Change clipping area for squashed Rex  
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexWins:              LDA.W !IFrameTimer                  ;; ?QPWZ? : AD 97 14    ; \ If mario is invincible...	  
                      ORA.W !PlayerRidingYoshi            ;; 0395CD : 0D 7A 18    ;  |  ... or mario on yoshi...	  
                      BNE NoRexContact                    ;; 0395D0 : D0 0B       ; /   ... return			  
                      JSR SubHorzPosBnk3                  ;; 0395D2 : 20 17 B8    ; \  Set new Rex direction		  
                      TYA                                 ;; 0395D5 : 98          ;  |  				  
                      STA.W !SpriteMisc157C,X             ;; 0395D6 : 9D 7C 15    ; /					  
                      JSL HurtMario                       ;; 0395D9 : 22 B7 F5 00 ; Hurt mario			  
NoRexContact:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexSpinKill:          LDA.B #$04                          ;; ?QPWZ? : A9 04       ; \ Rex status = 4 (being killed by spin jump)   
                      STA.W !SpriteStatus,X               ;; 0395E0 : 9D C8 14    ; /   					     
                      LDA.B #$1F                          ;; 0395E3 : A9 1F       ; \ Set spin jump animation timer		     
                      STA.W !SpriteMisc1540,X             ;; 0395E5 : 9D 40 15    ; /						     
                      JSL CODE_07FC3B                     ;; 0395E8 : 22 3B FC 07 ; Show star animation			     
                      LDA.B #$08                          ;; 0395EC : A9 08       ; \ 
                      STA.W !SPCIO0                       ;; 0395EE : 8D F9 1D    ; / Play sound effect 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
RexStarKill:          LDA.B #$02                          ;; ?QPWZ? : A9 02       ; \ Rex status = 2 (being killed by star)			   
                      STA.W !SpriteStatus,X               ;; 0395F4 : 9D C8 14    ; /								   
                      LDA.B #$D0                          ;; 0395F7 : A9 D0       ; \ Set y speed						   
                      STA.B !SpriteYSpeed,X               ;; 0395F9 : 95 AA       ; /								   
                      JSR SubHorzPosBnk3                  ;; 0395FB : 20 17 B8    ; Get new Rex direction					   
                      LDA.W RexKilledSpeed,Y              ;; 0395FE : B9 25 96    ; \ Set x speed based on Rex direction			   
                      STA.B !SpriteXSpeed,X               ;; 039601 : 95 B6       ; /								   
                      INC.W !StarKillCounter              ;; 039603 : EE D2 18    ; Increment number consecutive enemies killed		   
                      LDA.W !StarKillCounter              ;; 039606 : AD D2 18    ; \								   
                      CMP.B #$08                          ;; 039609 : C9 08       ;  | If consecutive enemies stomped >= 8, reset to 8		   
                      BCC ADDR_039612                     ;; 03960B : 90 05       ;  |								   
                      LDA.B #$08                          ;; 03960D : A9 08       ;  |								   
                      STA.W !StarKillCounter              ;; 03960F : 8D D2 18    ; /   							   
ADDR_039612:          JSL GivePoints                      ;; 039612 : 22 E5 AC 02 ; Give mario points						   
                      LDY.W !StarKillCounter              ;; 039616 : AC D2 18    ; \ 							   
                      CPY.B #$08                          ;; 039619 : C0 08       ;  | If consecutive enemies stomped < 8 ...			   
                      BCS Return039623                    ;; 03961B : B0 06       ;  |								   
                      LDA.W DATA_038000-1,Y               ;; 03961D : B9 FF 7F    ;  |    ... play sound effect				   
                      STA.W !SPCIO0                       ;; 039620 : 8D F9 1D    ; / Play sound effect 
Return039623:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                      RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
                                                          ;;                      ;
RexKilledSpeed:       db $F0,$10                          ;; ?QPWZ?               ;
                                                          ;;                      ;
                      RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
RexPoints:            PHY                                 ;; ?QPWZ? : 5A          ;
                      LDA.W !SpriteStompCounter           ;; 039629 : AD 97 16    ;
                      CLC                                 ;; 03962C : 18          ;
                      ADC.W !SpriteMisc1626,X             ;; 03962D : 7D 26 16    ;
                      INC.W !SpriteStompCounter           ;; 039630 : EE 97 16    ; Increase consecutive enemies stomped		       
                      TAY                                 ;; 039633 : A8          ;  							     
                      INY                                 ;; 039634 : C8          ;  							     
                      CPY.B #$08                          ;; 039635 : C0 08       ; \ If consecutive enemies stomped >= 8 ...		       
                      BCS CODE_03963F                     ;; 039637 : B0 06       ; /    ... don't play sound 			       
                      LDA.W DATA_038000-1,Y               ;; 039639 : B9 FF 7F    ; \  
                      STA.W !SPCIO0                       ;; 03963C : 8D F9 1D    ; / Play sound effect 
CODE_03963F:          TYA                                 ;; 03963F : 98          ; \							       
                      CMP.B #$08                          ;; 039640 : C9 08       ;  | If consecutive enemies stomped >= 8, reset to 8       
                      BCC CODE_039646                     ;; 039642 : 90 02       ;  |						       
                      LDA.B #$08                          ;; 039644 : A9 08       ; /							       
CODE_039646:          JSL GivePoints                      ;; 039646 : 22 E5 AC 02 ; Give mario points					       
                      PLY                                 ;; 03964A : 7A          ;  							     
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
RexTileDispX:         db $FC,$00,$FC,$00,$FE,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$08,$04,$00,$04,$00  ;; ?QPWZ?               ;
                      db $02,$00,$00,$00,$00,$00,$08,$00  ;; ?QPWZ?               ;
RexTileDispY:         db $F1,$00,$F0,$00,$F8,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$08,$08                  ;; ?QPWZ?               ;
                                                          ;;                      ;
RexTiles:             db $8A,$AA,$8A,$AC,$8A,$AA,$8C,$8C  ;; ?QPWZ?               ;
                      db $A8,$A8,$A2,$B2                  ;; ?QPWZ?               ;
                                                          ;;                      ;
RexGfxProp:           db $47,$07                          ;; ?QPWZ?               ;
                                                          ;;                      ;
RexGfxRt:             LDA.W !SpriteMisc1558,X             ;; ?QPWZ? : BD 58 15    ; \ If time to show Rex remains > 0...							  
                      BEQ RexGfxAlive                     ;; 039681 : F0 05       ;  |												  
                      LDA.B #$05                          ;; 039683 : A9 05       ;  |    ...set Rex frame = 5 (fully squashed)						  
                      STA.W !SpriteMisc1602,X             ;; 039685 : 9D 02 16    ; /												  
RexGfxAlive:          LDA.W !SpriteMisc1FE2,X             ;; ?QPWZ? : BD E2 1F    ; \ If time to show half smushed Rex > 0...							  
                      BEQ RexNotHalfSmushed               ;; 03968B : F0 05       ;  |												  
                      LDA.B #$02                          ;; 03968D : A9 02       ;  |    ...set Rex frame = 2 (half smushed)							  
                      STA.W !SpriteMisc1602,X             ;; 03968F : 9D 02 16    ; /												  
RexNotHalfSmushed:    JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ; Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
                      LDA.W !SpriteMisc1602,X             ;; 039695 : BD 02 16    ; \												  
                      ASL A                               ;; 039698 : 0A          ;  | $03 = index to frame start (frame to show * 2 tile per frame)				  
                      STA.B !_3                           ;; 039699 : 85 03       ; /												  
                      LDA.W !SpriteMisc157C,X             ;; 03969B : BD 7C 15    ; \ $02 = sprite direction									  
                      STA.B !_2                           ;; 03969E : 85 02       ; /												  
                      PHX                                 ;; 0396A0 : DA          ; Push sprite index										  
                      LDX.B #$01                          ;; 0396A1 : A2 01       ; Loop counter = (number of tiles per frame) - 1						  
RexGfxLoopStart:      PHX                                 ;; ?QPWZ? : DA          ; Push current tile number									  
                      TXA                                 ;; 0396A4 : 8A          ; \ X = index to horizontal displacement							  
                      ORA.B !_3                           ;; 0396A5 : 05 03       ; / get index of tile (index to first tile of frame + current tile number)			  
                      PHA                                 ;; 0396A7 : 48          ; Push index of current tile								  
                      LDX.B !_2                           ;; 0396A8 : A6 02       ; \ If facing right...									  
                      BNE RexFaceLeft                     ;; 0396AA : D0 03       ;  |												  
                      CLC                                 ;; 0396AC : 18          ;  |    											  
                      ADC.B #$0C                          ;; 0396AD : 69 0C       ; /    ...use row 2 of horizontal tile displacement table					  
RexFaceLeft:          TAX                                 ;; ?QPWZ? : AA          ; \ 											  
                      LDA.B !_0                           ;; 0396B0 : A5 00       ;  | Tile x position = sprite x location ($00) + tile displacement				  
                      CLC                                 ;; 0396B2 : 18          ;  |												  
                      ADC.W RexTileDispX,X                ;; 0396B3 : 7D 4C 96    ;  |												  
                      STA.W !OAMTileXPos+$100,Y           ;; 0396B6 : 99 00 03    ; /												  
                      PLX                                 ;; 0396B9 : FA          ; \ Pull, X = index to vertical displacement and tilemap					  
                      LDA.B !_1                           ;; 0396BA : A5 01       ;  | Tile y position = sprite y location ($01) + tile displacement				  
                      CLC                                 ;; 0396BC : 18          ;  |												  
                      ADC.W RexTileDispY,X                ;; 0396BD : 7D 64 96    ;  |												  
                      STA.W !OAMTileYPos+$100,Y           ;; 0396C0 : 99 01 03    ; /												  
                      LDA.W RexTiles,X                    ;; 0396C3 : BD 70 96    ; \ Store tile										  
                      STA.W !OAMTileNo+$100,Y             ;; 0396C6 : 99 02 03    ; / 											  
                      LDX.B !_2                           ;; 0396C9 : A6 02       ; \												  
                      LDA.W RexGfxProp,X                  ;; 0396CB : BD 7C 96    ;  | Get tile properties using sprite direction						  
                      ORA.B !SpriteProperties             ;; 0396CE : 05 64       ;  | Level properties 
                      STA.W !OAMTileAttr+$100,Y           ;; 0396D0 : 99 03 03    ; / Store tile properties									  
                      TYA                                 ;; 0396D3 : 98          ; \ Get index to sprite property map ($460)...						  
                      LSR A                               ;; 0396D4 : 4A          ;  |    ...we use the sprite OAM index...							  
                      LSR A                               ;; 0396D5 : 4A          ;  |    ...and divide by 4 because a 16x16 tile is 4 8x8 tiles				  
                      LDX.B !_3                           ;; 0396D6 : A6 03       ;  | If index of frame start is > 0A 							  
                      CPX.B #$0A                          ;; 0396D8 : E0 0A       ;  |												  
                      TAX                                 ;; 0396DA : AA          ;  | 
                      LDA.B #$00                          ;; 0396DB : A9 00       ;  |     ...show only an 8x8 tile			   
                      BCS Rex8x8Tile                      ;; 0396DD : B0 02       ;  |							   
                      LDA.B #$02                          ;; 0396DF : A9 02       ;  | Else show a full 16 x 16 tile			   
Rex8x8Tile:           STA.W !OAMTileSize+$40,X            ;; ?QPWZ? : 9D 60 04    ; /							   
                      PLX                                 ;; 0396E4 : FA          ; \ Pull, X = current tile of the frame we're drawing  
                      INY                                 ;; 0396E5 : C8          ;  | Increase index to sprite tile map ($300)...	   
                      INY                                 ;; 0396E6 : C8          ;  |    ...we wrote 4 times...			   
                      INY                                 ;; 0396E7 : C8          ;  |    ...so increment 4 times			  
                      INY                                 ;; 0396E8 : C8          ;  | 
                      DEX                                 ;; 0396E9 : CA          ;  | Go to next tile of frame and loop		   
                      BPL RexGfxLoopStart                 ;; 0396EA : 10 B7       ; / 						   
                      PLX                                 ;; 0396EC : FA          ; Pull, X = sprite index				   
                      LDY.B #$FF                          ;; 0396ED : A0 FF       ; \ FF because we already wrote size to $0460    		   
                      LDA.B #$01                          ;; 0396EF : A9 01       ;  | A = number of tiles drawn - 1			   
                      JSL FinishOAMWrite                  ;; 0396F1 : 22 B3 B7 01 ; / Don't draw if offscreen				   
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
Fishbone:             JSR FishboneGfx                     ;; ?QPWZ? : 20 8C 97    ;
                      LDA.B !SpriteLock                   ;; 0396F9 : A5 9D       ;
                      BNE Return03972A                    ;; 0396FB : D0 2D       ;
                      JSR SubOffscreen0Bnk3               ;; 0396FD : 20 5D B8    ;
                      JSL MarioSprInteract                ;; 039700 : 22 DC A7 01 ;
                      JSL UpdateXPosNoGvtyW               ;; 039704 : 22 22 80 01 ;
                      TXA                                 ;; 039708 : 8A          ;
                      ASL A                               ;; 039709 : 0A          ;
                      ASL A                               ;; 03970A : 0A          ;
                      ASL A                               ;; 03970B : 0A          ;
                      ASL A                               ;; 03970C : 0A          ;
                      ADC.B !TrueFrame                    ;; 03970D : 65 13       ;
                      AND.B #$7F                          ;; 03970F : 29 7F       ;
                      BNE CODE_039720                     ;; 039711 : D0 0D       ;
                      JSL GetRand                         ;; 039713 : 22 F9 AC 01 ;
                      AND.B #$01                          ;; 039717 : 29 01       ;
                      BNE CODE_039720                     ;; 039719 : D0 05       ;
                      LDA.B #$0C                          ;; 03971B : A9 0C       ;
                      STA.W !SpriteMisc1558,X             ;; 03971D : 9D 58 15    ;
CODE_039720:          LDA.B !SpriteTableC2,X              ;; 039720 : B5 C2       ;
                      JSL ExecutePtr                      ;; 039722 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03972F                      ;; ?QPWZ? : 2F 97       ;
                      dw CODE_03975E                      ;; ?QPWZ? : 5E 97       ;
                                                          ;;                      ;
Return03972A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishboneMaxSpeed:     db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneAcceler:      db $01,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03972F:          INC.W !SpriteMisc1570,X             ;; 03972F : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 039732 : BD 70 15    ;
                      NOP                                 ;; 039735 : EA          ;
                      LSR A                               ;; 039736 : 4A          ;
                      AND.B #$01                          ;; 039737 : 29 01       ;
                      STA.W !SpriteMisc1602,X             ;; 039739 : 9D 02 16    ;
                      LDA.W !SpriteMisc1540,X             ;; 03973C : BD 40 15    ;
                      BEQ CODE_039756                     ;; 03973F : F0 15       ;
                      AND.B #$01                          ;; 039741 : 29 01       ;
                      BNE Return039755                    ;; 039743 : D0 10       ;
                      LDY.W !SpriteMisc157C,X             ;; 039745 : BC 7C 15    ;
                      LDA.B !SpriteXSpeed,X               ;; 039748 : B5 B6       ;
                      CMP.W FishboneMaxSpeed,Y            ;; 03974A : D9 2B 97    ;
                      BEQ Return039755                    ;; 03974D : F0 06       ;
                      CLC                                 ;; 03974F : 18          ;
                      ADC.W FishboneAcceler,Y             ;; 039750 : 79 2D 97    ;
                      STA.B !SpriteXSpeed,X               ;; 039753 : 95 B6       ;
Return039755:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039756:          INC.B !SpriteTableC2,X              ;; 039756 : F6 C2       ;
                      LDA.B #$30                          ;; 039758 : A9 30       ;
                      STA.W !SpriteMisc1540,X             ;; 03975A : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03975E:          STZ.W !SpriteMisc1602,X             ;; 03975E : 9E 02 16    ;
                      LDA.W !SpriteMisc1540,X             ;; 039761 : BD 40 15    ;
                      BEQ CODE_039776                     ;; 039764 : F0 10       ;
                      AND.B #$03                          ;; 039766 : 29 03       ;
                      BNE Return039775                    ;; 039768 : D0 0B       ;
                      LDA.B !SpriteXSpeed,X               ;; 03976A : B5 B6       ;
                      BEQ Return039775                    ;; 03976C : F0 07       ;
                      BPL CODE_039773                     ;; 03976E : 10 03       ;
                      INC.B !SpriteXSpeed,X               ;; 039770 : F6 B6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039773:          DEC.B !SpriteXSpeed,X               ;; 039773 : D6 B6       ;
Return039775:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039776:          STZ.B !SpriteTableC2,X              ;; 039776 : 74 C2       ;
                      LDA.B #$30                          ;; 039778 : A9 30       ;
                      STA.W !SpriteMisc1540,X             ;; 03977A : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
FishboneDispX:        db $F8,$F8,$10,$10                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneDispY:        db $00,$08                          ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneGfxProp:      db $4D,$CD,$0D,$8D                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneTailTiles:    db $A3,$A3,$B3,$B3                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FishboneGfx:          JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 039790 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !SpriteMisc1558,X             ;; 039793 : BD 58 15    ;
                      CMP.B #$01                          ;; 039796 : C9 01       ;
                      LDA.B #$A6                          ;; 039798 : A9 A6       ;
                      BCC CODE_03979E                     ;; 03979A : 90 02       ;
                      LDA.B #$A8                          ;; 03979C : A9 A8       ;
CODE_03979E:          STA.W !OAMTileNo+$100,Y             ;; 03979E : 99 02 03    ;
                      JSR GetDrawInfoBnk3                 ;; 0397A1 : 20 60 B7    ;
                      LDA.W !SpriteMisc157C,X             ;; 0397A4 : BD 7C 15    ;
                      ASL A                               ;; 0397A7 : 0A          ;
                      STA.B !_2                           ;; 0397A8 : 85 02       ;
                      LDA.W !SpriteMisc1602,X             ;; 0397AA : BD 02 16    ;
                      ASL A                               ;; 0397AD : 0A          ;
                      STA.B !_3                           ;; 0397AE : 85 03       ;
                      LDA.W !SpriteOAMIndex,X             ;; 0397B0 : BD EA 15    ;
                      CLC                                 ;; 0397B3 : 18          ;
                      ADC.B #$04                          ;; 0397B4 : 69 04       ;
                      STA.W !SpriteOAMIndex,X             ;; 0397B6 : 9D EA 15    ;
                      TAY                                 ;; 0397B9 : A8          ;
                      PHX                                 ;; 0397BA : DA          ;
                      LDX.B #$01                          ;; 0397BB : A2 01       ;
CODE_0397BD:          LDA.B !_1                           ;; 0397BD : A5 01       ;
                      CLC                                 ;; 0397BF : 18          ;
                      ADC.W FishboneDispY,X               ;; 0397C0 : 7D 82 97    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 0397C3 : 99 01 03    ;
                      PHX                                 ;; 0397C6 : DA          ;
                      TXA                                 ;; 0397C7 : 8A          ;
                      ORA.B !_2                           ;; 0397C8 : 05 02       ;
                      TAX                                 ;; 0397CA : AA          ;
                      LDA.B !_0                           ;; 0397CB : A5 00       ;
                      CLC                                 ;; 0397CD : 18          ;
                      ADC.W FishboneDispX,X               ;; 0397CE : 7D 7E 97    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 0397D1 : 99 00 03    ;
                      LDA.W FishboneGfxProp,X             ;; 0397D4 : BD 84 97    ;
                      ORA.B !SpriteProperties             ;; 0397D7 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 0397D9 : 99 03 03    ;
                      PLA                                 ;; 0397DC : 68          ;
                      PHA                                 ;; 0397DD : 48          ;
                      ORA.B !_3                           ;; 0397DE : 05 03       ;
                      TAX                                 ;; 0397E0 : AA          ;
                      LDA.W FishboneTailTiles,X           ;; 0397E1 : BD 88 97    ;
                      STA.W !OAMTileNo+$100,Y             ;; 0397E4 : 99 02 03    ;
                      PLX                                 ;; 0397E7 : FA          ;
                      INY                                 ;; 0397E8 : C8          ;
                      INY                                 ;; 0397E9 : C8          ;
                      INY                                 ;; 0397EA : C8          ;
                      INY                                 ;; 0397EB : C8          ;
                      DEX                                 ;; 0397EC : CA          ;
                      BPL CODE_0397BD                     ;; 0397ED : 10 CE       ;
                      PLX                                 ;; 0397EF : FA          ;
                      LDY.B #$00                          ;; 0397F0 : A0 00       ;
                      LDA.B #$02                          ;; 0397F2 : A9 02       ;
                      JSL FinishOAMWrite                  ;; 0397F4 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_0397F9:          STA.B !_1                           ;; 0397F9 : 85 01       ;
                      PHX                                 ;; 0397FB : DA          ;
                      PHY                                 ;; 0397FC : 5A          ;
                      JSR SubVertPosBnk3                  ;; 0397FD : 20 29 B8    ;
                      STY.B !_2                           ;; 039800 : 84 02       ;
                      LDA.B !_E                           ;; 039802 : A5 0E       ;
                      BPL CODE_03980B                     ;; 039804 : 10 05       ;
                      EOR.B #$FF                          ;; 039806 : 49 FF       ;
                      CLC                                 ;; 039808 : 18          ;
                      ADC.B #$01                          ;; 039809 : 69 01       ;
CODE_03980B:          STA.B !_C                           ;; 03980B : 85 0C       ;
                      JSR SubHorzPosBnk3                  ;; 03980D : 20 17 B8    ;
                      STY.B !_3                           ;; 039810 : 84 03       ;
                      LDA.B !_F                           ;; 039812 : A5 0F       ;
                      BPL CODE_03981B                     ;; 039814 : 10 05       ;
                      EOR.B #$FF                          ;; 039816 : 49 FF       ;
                      CLC                                 ;; 039818 : 18          ;
                      ADC.B #$01                          ;; 039819 : 69 01       ;
CODE_03981B:          STA.B !_D                           ;; 03981B : 85 0D       ;
                      LDY.B #$00                          ;; 03981D : A0 00       ;
                      LDA.B !_D                           ;; 03981F : A5 0D       ;
                      CMP.B !_C                           ;; 039821 : C5 0C       ;
                      BCS CODE_03982E                     ;; 039823 : B0 09       ;
                      INY                                 ;; 039825 : C8          ;
                      PHA                                 ;; 039826 : 48          ;
                      LDA.B !_C                           ;; 039827 : A5 0C       ;
                      STA.B !_D                           ;; 039829 : 85 0D       ;
                      PLA                                 ;; 03982B : 68          ;
                      STA.B !_C                           ;; 03982C : 85 0C       ;
CODE_03982E:          LDA.B #$00                          ;; 03982E : A9 00       ;
                      STA.B !_B                           ;; 039830 : 85 0B       ;
                      STA.B !_0                           ;; 039832 : 85 00       ;
                      LDX.B !_1                           ;; 039834 : A6 01       ;
CODE_039836:          LDA.B !_B                           ;; 039836 : A5 0B       ;
                      CLC                                 ;; 039838 : 18          ;
                      ADC.B !_C                           ;; 039839 : 65 0C       ;
                      CMP.B !_D                           ;; 03983B : C5 0D       ;
                      BCC CODE_039843                     ;; 03983D : 90 04       ;
                      SBC.B !_D                           ;; 03983F : E5 0D       ;
                      INC.B !_0                           ;; 039841 : E6 00       ;
CODE_039843:          STA.B !_B                           ;; 039843 : 85 0B       ;
                      DEX                                 ;; 039845 : CA          ;
                      BNE CODE_039836                     ;; 039846 : D0 EE       ;
                      TYA                                 ;; 039848 : 98          ;
                      BEQ CODE_039855                     ;; 039849 : F0 0A       ;
                      LDA.B !_0                           ;; 03984B : A5 00       ;
                      PHA                                 ;; 03984D : 48          ;
                      LDA.B !_1                           ;; 03984E : A5 01       ;
                      STA.B !_0                           ;; 039850 : 85 00       ;
                      PLA                                 ;; 039852 : 68          ;
                      STA.B !_1                           ;; 039853 : 85 01       ;
CODE_039855:          LDA.B !_0                           ;; 039855 : A5 00       ;
                      LDY.B !_2                           ;; 039857 : A4 02       ;
                      BEQ CODE_039862                     ;; 039859 : F0 07       ;
                      EOR.B #$FF                          ;; 03985B : 49 FF       ;
                      CLC                                 ;; 03985D : 18          ;
                      ADC.B #$01                          ;; 03985E : 69 01       ;
                      STA.B !_0                           ;; 039860 : 85 00       ;
CODE_039862:          LDA.B !_1                           ;; 039862 : A5 01       ;
                      LDY.B !_3                           ;; 039864 : A4 03       ;
                      BEQ CODE_03986F                     ;; 039866 : F0 07       ;
                      EOR.B #$FF                          ;; 039868 : 49 FF       ;
                      CLC                                 ;; 03986A : 18          ;
                      ADC.B #$01                          ;; 03986B : 69 01       ;
                      STA.B !_1                           ;; 03986D : 85 01       ;
CODE_03986F:          PLY                                 ;; 03986F : 7A          ;
                      PLX                                 ;; 039870 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorInit:           CPX.B #$07                          ;; ?QPWZ? : E0 07       ;
                      BNE CODE_03987E                     ;; 039874 : D0 08       ;
                      LDA.B #$04                          ;; 039876 : A9 04       ;
                      STA.B !SpriteTableC2,X              ;; 039878 : 95 C2       ;
                      JSL CODE_03DD7D                     ;; 03987A : 22 7D DD 03 ;
CODE_03987E:          JSL GetRand                         ;; 03987E : 22 F9 AC 01 ;
                      STA.W !SpriteMisc1570,X             ;; 039882 : 9D 70 15    ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorStartPosLo:     db $00,$80,$00,$80                  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorStartPosHi:     db $00,$00,$01,$01                  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReboundSpeedX:        db $20,$E0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
Reznor:               INC.W !ReznorOAMIndex               ;; ?QPWZ? : EE 0F 14    ;
                      LDA.B !SpriteLock                   ;; 039893 : A5 9D       ;
                      BEQ ReznorNotLocked                 ;; 039895 : F0 03       ;
                      JMP DrawReznor                      ;; 039897 : 4C 7B 9A    ;
                                                          ;;                      ;
ReznorNotLocked:      CPX.B #$07                          ;; ?QPWZ? : E0 07       ;
                      BNE CODE_039910                     ;; 03989C : D0 72       ;
                      PHX                                 ;; 03989E : DA          ;
                      JSL CODE_03D70C                     ;; 03989F : 22 0C D7 03 ; Break bridge when necessary 
                      LDA.B #$80                          ;; ?QPWZ? : A9 80       ; \ Set radius for Reznor sign rotation 
                      STA.B !Mode7CenterX                 ;; 0398A5 : 85 2A       ;  | 
                      STZ.B !Mode7CenterX+1               ;; 0398A7 : 64 2B       ; / 
                      LDX.B #$00                          ;; 0398A9 : A2 00       ;
                      LDA.B #$C0                          ;; 0398AB : A9 C0       ; \ X position of Reznor sign 
                      STA.B !SpriteXPosLow                ;; 0398AD : 85 E4       ;  | 
                      STZ.W !SpriteYPosHigh               ;; 0398AF : 9C E0 14    ; / 
                      LDA.B #$B2                          ;; 0398B2 : A9 B2       ; \ Y position of Reznor sign 
                      STA.B !SpriteYPosLow                ;; 0398B4 : 85 D8       ;  | 
                      STZ.W !SpriteXPosHigh               ;; 0398B6 : 9C D4 14    ; / 
                      LDA.B #$2C                          ;; 0398B9 : A9 2C       ;
                      STA.W !Mode7TileIndex               ;; 0398BB : 8D A2 1B    ;
                      JSL CODE_03DEDF                     ;; 0398BE : 22 DF DE 03 ; Applies position changes to Reznor sign 
                      PLX                                 ;; 0398C2 : FA          ; Pull, X = sprite index 
                      REP #$20                            ;; 0398C3 : C2 20       ; Accum (16 bit) 
                      LDA.B !Mode7Angle                   ;; 0398C5 : A5 36       ; \ Rotate 1 frame around the circle (clockwise) 
                      CLC                                 ;; 0398C7 : 18          ;  | $37,36 = 0 to 1FF, denotes circle position 
                      ADC.W #$0001                        ;; 0398C8 : 69 01 00    ;  | 
                      AND.W #$01FF                        ;; 0398CB : 29 FF 01    ;  | 
                      STA.B !Mode7Angle                   ;; 0398CE : 85 36       ; / 
                      SEP #$20                            ;; 0398D0 : E2 20       ; Accum (8 bit) 
                      CPX.B #$07                          ;; 0398D2 : E0 07       ;
                      BNE CODE_039910                     ;; 0398D4 : D0 3A       ;
                      LDA.W !SpriteMisc163E,X             ;; 0398D6 : BD 3E 16    ; \ Branch if timer to trigger level isn't set 
                      BEQ ReznorNoLevelEnd                ;; 0398D9 : F0 11       ; / 
                      DEC A                               ;; 0398DB : 3A          ;
                      BNE CODE_039910                     ;; 0398DC : D0 32       ;
                      DEC.W !CutsceneID                   ;; 0398DE : CE C6 13    ; Prevent mario from walking at level end 
                      LDA.B #$FF                          ;; 0398E1 : A9 FF       ; \ Set time before return to overworld 
                      STA.W !EndLevelTimer                ;; 0398E3 : 8D 93 14    ; / 
                      LDA.B #$0B                          ;; 0398E6 : A9 0B       ; \ 
                      STA.W !SPCIO2                       ;; 0398E8 : 8D FB 1D    ; / Play sound effect 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorNoLevelEnd:     LDA.W !SpriteMisc151C+7             ;; ?QPWZ? : AD 23 15    ; \ 
                      CLC                                 ;; 0398EF : 18          ;  | 
                      ADC.W !SpriteMisc151C+6             ;; 0398F0 : 6D 22 15    ;  | 
                      ADC.W !SpriteMisc151C+5             ;; 0398F3 : 6D 21 15    ;  | 
                      ADC.W !SpriteMisc151C+4             ;; 0398F6 : 6D 20 15    ;  | 
                      CMP.B #$04                          ;; 0398F9 : C9 04       ;  | 
                      BNE CODE_039910                     ;; 0398FB : D0 13       ;  | 
                      LDA.B #$90                          ;; 0398FD : A9 90       ;  | Set time to trigger level if all Reznors are dead 
                      STA.W !SpriteMisc163E,X             ;; 0398FF : 9D 3E 16    ; / 
                      JSL KillMostSprites                 ;; 039902 : 22 C8 A6 03 ;
                      LDY.B #$07                          ;; 039906 : A0 07       ; \ Zero out extended sprite table 
                      LDA.B #$00                          ;; 039908 : A9 00       ;  | 
CODE_03990A:          STA.W !ExtSpriteNumber,Y            ;; 03990A : 99 0B 17    ;  | 
                      DEY                                 ;; 03990D : 88          ;  | 
                      BPL CODE_03990A                     ;; 03990E : 10 FA       ; / 
CODE_039910:          LDA.W !SpriteStatus,X               ;; 039910 : BD C8 14    ;
                      CMP.B #$08                          ;; 039913 : C9 08       ;
                      BEQ CODE_03991A                     ;; 039915 : F0 03       ;
                      JMP DrawReznor                      ;; 039917 : 4C 7B 9A    ;
                                                          ;;                      ;
CODE_03991A:          TXA                                 ;; 03991A : 8A          ; \ Load Y with Reznor number (0-3)				  
                      AND.B #$03                          ;; 03991B : 29 03       ;  |							  
                      TAY                                 ;; 03991D : A8          ; /								  
                      LDA.B !Mode7Angle                   ;; 03991E : A5 36       ; \								  
                      CLC                                 ;; 039920 : 18          ;  |							  
                      ADC.W ReznorStartPosLo,Y            ;; 039921 : 79 86 98    ;  |							  
                      STA.B !_0                           ;; 039924 : 85 00       ;  | $01,00 = 0-1FF, position Reznors on the circle		  
                      LDA.B !Mode7Angle+1                 ;; 039926 : A5 37       ;  |							  
                      ADC.W ReznorStartPosHi,Y            ;; 039928 : 79 8A 98    ;  |							  
                      AND.B #$01                          ;; 03992B : 29 01       ;  |							  
                      STA.B !_1                           ;; 03992D : 85 01       ; /								  
                      REP #$30                            ;; 03992F : C2 30       ; \   Index (16 bit) Accum (16 bit)  ; Index (16 bit) Accum (16 bit) 
                      LDA.B !_0                           ;; 039931 : A5 00       ;  | Make Reznors turn clockwise rather than counter clockwise 
                      EOR.W #$01FF                        ;; 039933 : 49 FF 01    ;  | ($01,00 = -1 * $01,00)					 							  
                      INC A                               ;; 039936 : 1A          ;  |							  
                      STA.B !_0                           ;; 039937 : 85 00       ; /                                                           
                      CLC                                 ;; 039939 : 18          ;
                      ADC.W #$0080                        ;; 03993A : 69 80 00    ;
                      AND.W #$01FF                        ;; 03993D : 29 FF 01    ;
                      STA.B !_2                           ;; 039940 : 85 02       ;
                      LDA.B !_0                           ;; 039942 : A5 00       ;
                      AND.W #$00FF                        ;; 039944 : 29 FF 00    ;
                      ASL A                               ;; 039947 : 0A          ;
                      TAX                                 ;; 039948 : AA          ;
                      LDA.L CircleCoords,X                ;; 039949 : BF DB F7 07 ;
                      STA.B !_4                           ;; 03994D : 85 04       ;
                      LDA.B !_2                           ;; 03994F : A5 02       ;
                      AND.W #$00FF                        ;; 039951 : 29 FF 00    ;
                      ASL A                               ;; 039954 : 0A          ;
                      TAX                                 ;; 039955 : AA          ;
                      LDA.L CircleCoords,X                ;; 039956 : BF DB F7 07 ;
                      STA.B !_6                           ;; 03995A : 85 06       ;
                      SEP #$30                            ;; 03995C : E2 30       ; Index (8 bit) Accum (8 bit) 
                      LDA.B !_4                           ;; 03995E : A5 04       ;
                      STA.W !HW_WRMPYA                    ;; 039960 : 8D 02 42    ; Multiplicand A
                      LDA.B #$38                          ;; 039963 : A9 38       ;
                      LDY.B !_5                           ;; 039965 : A4 05       ;
                      BNE CODE_039978                     ;; 039967 : D0 0F       ;
                      STA.W !HW_WRMPYB                    ;; 039969 : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03996C : EA          ;
                      NOP                                 ;; 03996D : EA          ;
                      NOP                                 ;; 03996E : EA          ;
                      NOP                                 ;; 03996F : EA          ;
                      ASL.W !HW_RDMPY                     ;; 039970 : 0E 16 42    ; Product/Remainder Result (Low Byte)
                      LDA.W !HW_RDMPY+1                   ;; 039973 : AD 17 42    ; Product/Remainder Result (High Byte)
                      ADC.B #$00                          ;; 039976 : 69 00       ;
CODE_039978:          LSR.B !_1                           ;; 039978 : 46 01       ;
                      BCC CODE_03997F                     ;; 03997A : 90 03       ;
                      EOR.B #$FF                          ;; 03997C : 49 FF       ;
                      INC A                               ;; 03997E : 1A          ;
CODE_03997F:          STA.B !_4                           ;; 03997F : 85 04       ;
                      LDA.B !_6                           ;; 039981 : A5 06       ;
                      STA.W !HW_WRMPYA                    ;; 039983 : 8D 02 42    ; Multiplicand A
                      LDA.B #$38                          ;; 039986 : A9 38       ;
                      LDY.B !_7                           ;; 039988 : A4 07       ;
                      BNE CODE_03999B                     ;; 03998A : D0 0F       ;
                      STA.W !HW_WRMPYB                    ;; 03998C : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03998F : EA          ;
                      NOP                                 ;; 039990 : EA          ;
                      NOP                                 ;; 039991 : EA          ;
                      NOP                                 ;; 039992 : EA          ;
                      ASL.W !HW_RDMPY                     ;; 039993 : 0E 16 42    ; Product/Remainder Result (Low Byte)
                      LDA.W !HW_RDMPY+1                   ;; 039996 : AD 17 42    ; Product/Remainder Result (High Byte)
                      ADC.B #$00                          ;; 039999 : 69 00       ;
CODE_03999B:          LSR.B !_3                           ;; 03999B : 46 03       ;
                      BCC CODE_0399A2                     ;; 03999D : 90 03       ;
                      EOR.B #$FF                          ;; 03999F : 49 FF       ;
                      INC A                               ;; 0399A1 : 1A          ;
CODE_0399A2:          STA.B !_6                           ;; 0399A2 : 85 06       ;
                      LDX.W !CurSpriteProcess             ;; 0399A4 : AE E9 15    ; X = sprite index 
                      LDA.B !SpriteXPosLow,X              ;; 0399A7 : B5 E4       ;
                      PHA                                 ;; 0399A9 : 48          ;
                      STZ.B !_0                           ;; 0399AA : 64 00       ;
                      LDA.B !_4                           ;; 0399AC : A5 04       ;
                      BPL CODE_0399B2                     ;; 0399AE : 10 02       ;
                      DEC.B !_0                           ;; 0399B0 : C6 00       ;
CODE_0399B2:          CLC                                 ;; 0399B2 : 18          ;
                      ADC.B !Mode7CenterX                 ;; 0399B3 : 65 2A       ;
                      PHP                                 ;; 0399B5 : 08          ;
                      CLC                                 ;; 0399B6 : 18          ;
                      ADC.B #$40                          ;; 0399B7 : 69 40       ;
                      STA.B !SpriteXPosLow,X              ;; 0399B9 : 95 E4       ;
                      LDA.B !Mode7CenterX+1               ;; 0399BB : A5 2B       ;
                      ADC.B #$00                          ;; 0399BD : 69 00       ;
                      PLP                                 ;; 0399BF : 28          ;
                      ADC.B !_0                           ;; 0399C0 : 65 00       ;
                      STA.W !SpriteYPosHigh,X             ;; 0399C2 : 9D E0 14    ;
                      PLA                                 ;; 0399C5 : 68          ;
                      SEC                                 ;; 0399C6 : 38          ;
                      SBC.B !SpriteXPosLow,X              ;; 0399C7 : F5 E4       ;
                      EOR.B #$FF                          ;; 0399C9 : 49 FF       ;
                      INC A                               ;; 0399CB : 1A          ;
                      STA.W !SpriteMisc1528,X             ;; 0399CC : 9D 28 15    ;
                      STZ.B !_1                           ;; 0399CF : 64 01       ;
                      LDA.B !_6                           ;; 0399D1 : A5 06       ;
                      BPL CODE_0399D7                     ;; 0399D3 : 10 02       ;
                      DEC.B !_1                           ;; 0399D5 : C6 01       ;
CODE_0399D7:          CLC                                 ;; 0399D7 : 18          ;
                      ADC.B !Mode7CenterY                 ;; 0399D8 : 65 2C       ;
                      PHP                                 ;; 0399DA : 08          ;
                      ADC.B #$20                          ;; 0399DB : 69 20       ;
                      STA.B !SpriteYPosLow,X              ;; 0399DD : 95 D8       ;
                      LDA.B !Mode7CenterY+1               ;; 0399DF : A5 2D       ;
                      ADC.B #$00                          ;; 0399E1 : 69 00       ;
                      PLP                                 ;; 0399E3 : 28          ;
                      ADC.B !_1                           ;; 0399E4 : 65 01       ;
                      STA.W !SpriteXPosHigh,X             ;; 0399E6 : 9D D4 14    ;
                      LDA.W !SpriteMisc151C,X             ;; 0399E9 : BD 1C 15    ; \ If a Reznor is dead, make it's platform standable 
                      BEQ ReznorAlive                     ;; 0399EC : F0 07       ;  | 
                      JSL InvisBlkMainRt                  ;; 0399EE : 22 4F B4 01 ;  | 
                      JMP DrawReznor                      ;; 0399F2 : 4C 7B 9A    ; / 
                                                          ;;                      ;
ReznorAlive:          LDA.B !TrueFrame                    ;; ?QPWZ? : A5 13       ; \ Don't try to spit fire if turning 
                      AND.B #$00                          ;; 0399F7 : 29 00       ;  | 
                      ORA.W !SpriteMisc15AC,X             ;; 0399F9 : 1D AC 15    ;  | 
                      BNE NoSetRznrFireTime               ;; 0399FC : D0 12       ; / 
                      INC.W !SpriteMisc1570,X             ;; 0399FE : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 039A01 : BD 70 15    ;
                      CMP.B #$00                          ;; 039A04 : C9 00       ;
                      BNE NoSetRznrFireTime               ;; 039A06 : D0 08       ;
                      STZ.W !SpriteMisc1570,X             ;; 039A08 : 9E 70 15    ;
                      LDA.B #$40                          ;; 039A0B : A9 40       ; \ Set time to show firing graphic = 0A 
                      STA.W !SpriteMisc1558,X             ;; 039A0D : 9D 58 15    ; / 
NoSetRznrFireTime:    TXA                                 ;; ?QPWZ? : 8A          ;
                      ASL A                               ;; 039A11 : 0A          ;
                      ASL A                               ;; 039A12 : 0A          ;
                      ASL A                               ;; 039A13 : 0A          ;
                      ASL A                               ;; 039A14 : 0A          ;
                      ADC.B !EffFrame                     ;; 039A15 : 65 14       ;
                      AND.B #$3F                          ;; 039A17 : 29 3F       ;
                      ORA.W !SpriteMisc1558,X             ;; 039A19 : 1D 58 15    ; Firing 
                      ORA.W !SpriteMisc15AC,X             ;; 039A1C : 1D AC 15    ; Turning 
                      BNE NoSetRenrTurnTime               ;; 039A1F : D0 16       ;
                      LDA.W !SpriteMisc157C,X             ;; 039A21 : BD 7C 15    ; \ if direction has changed since last frame...		   
                      PHA                                 ;; 039A24 : 48          ;  |							   
                      JSR SubHorzPosBnk3                  ;; 039A25 : 20 17 B8    ;  |							   
                      TYA                                 ;; 039A28 : 98          ;  |							   
                      STA.W !SpriteMisc157C,X             ;; 039A29 : 9D 7C 15    ;  |							   
                      PLA                                 ;; 039A2C : 68          ;  |							   
                      CMP.W !SpriteMisc157C,X             ;; 039A2D : DD 7C 15    ;  |							   
                      BEQ NoSetRenrTurnTime               ;; 039A30 : F0 05       ;  |							   
                      LDA.B #$0A                          ;; 039A32 : A9 0A       ;  | ...set time to show turning graphic = 0A		   
                      STA.W !SpriteMisc15AC,X             ;; 039A34 : 9D AC 15    ; /								   
NoSetRenrTurnTime:    LDA.W !SpriteMisc154C,X             ;; ?QPWZ? : BD 4C 15    ; \ If disable interaction timer > 0, just draw Reznor	   
                      BNE DrawReznor                      ;; 039A3A : D0 3F       ; /								   
                      JSL MarioSprInteract                ;; 039A3C : 22 DC A7 01 ; \ Interact with mario					   
                      BCC DrawReznor                      ;; 039A40 : 90 39       ; / If no contact, just draw Reznor				   
                      LDA.B #$08                          ;; 039A42 : A9 08       ; \ Disable interaction timer = 08				   
                      STA.W !SpriteMisc154C,X             ;; 039A44 : 9D 4C 15    ; / (eg. after hitting Reznor, or getting bounced by platform) 
                      LDA.B !PlayerYPosNext               ;; 039A47 : A5 96       ; \ Compare y positions to see if mario hit Reznor		   
                      SEC                                 ;; 039A49 : 38          ;  |							   
                      SBC.B !SpriteYPosLow,X              ;; 039A4A : F5 D8       ;  |							   
                      CMP.B #$ED                          ;; 039A4C : C9 ED       ;  |							   
                      BMI HitReznor                       ;; 039A4E : 30 27       ; /								   
                      CMP.B #$F2                          ;; 039A50 : C9 F2       ; \ See if mario hit side of the platform			   
                      BMI HitPlatSide                     ;; 039A52 : 30 19       ;  |							   
                      LDA.B !PlayerYSpeed                 ;; 039A54 : A5 7D       ;  |							   
                      BPL HitPlatSide                     ;; 039A56 : 10 15       ; /								   
                      LDA.B #$29                          ;; ?QPWZ? : A9 29       ; ??Something about boosting mario on platform?? 
                      STA.W !SpriteTweakerB,X             ;; 039A5A : 9D 62 16    ;  								   
                      LDA.B #$0F                          ;; 039A5D : A9 0F       ; \ Time to bounce platform = 0F				   
                      STA.W !SpriteMisc1564,X             ;; 039A5F : 9D 64 15    ; /								   
                      LDA.B #$10                          ;; 039A62 : A9 10       ; \ Set mario's y speed to rebound down off platform	   
                      STA.B !PlayerYSpeed                 ;; 039A64 : 85 7D       ; /								   
                      LDA.B #$01                          ;; 039A66 : A9 01       ; \ 
                      STA.W !SPCIO0                       ;; 039A68 : 8D F9 1D    ; / Play sound effect 
                      BRA DrawReznor                      ;; 039A6B : 80 0E       ;
                                                          ;;                      ;
HitPlatSide:          JSR SubHorzPosBnk3                  ;; ?QPWZ? : 20 17 B8    ; \ Set mario to bounce back				   
                      LDA.W ReboundSpeedX,Y               ;; 039A70 : B9 8E 98    ;  | (hit side of platform?)				   
                      STA.B !PlayerXSpeed                 ;; 039A73 : 85 7B       ;  |							   
                      BRA DrawReznor                      ;; 039A75 : 80 04       ; /                                                            
                                                          ;;                      ;
HitReznor:            JSL HurtMario                       ;; ?QPWZ? : 22 B7 F5 00 ; Hurt Mario 
DrawReznor:           STZ.W !SpriteMisc1602,X             ;; ?QPWZ? : 9E 02 16    ; Set normal image 
                      LDA.W !SpriteMisc157C,X             ;; 039A7E : BD 7C 15    ;
                      PHA                                 ;; 039A81 : 48          ;
                      LDY.W !SpriteMisc15AC,X             ;; 039A82 : BC AC 15    ;
                      BEQ ReznorNoTurning                 ;; 039A85 : F0 0E       ;
                      CPY.B #$05                          ;; 039A87 : C0 05       ;
                      BCC ReznorTurning                   ;; 039A89 : 90 05       ;
                      EOR.B #$01                          ;; 039A8B : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 039A8D : 9D 7C 15    ;
ReznorTurning:        LDA.B #$02                          ;; ?QPWZ? : A9 02       ; \ Set turning image 
                      STA.W !SpriteMisc1602,X             ;; 039A92 : 9D 02 16    ; / 
ReznorNoTurning:      LDA.W !SpriteMisc1558,X             ;; ?QPWZ? : BD 58 15    ; \ Shoot fire if "time to show firing image" == 20	        
                      BEQ ReznorNoFiring                  ;; 039A98 : F0 0C       ;  |						        
                      CMP.B #$20                          ;; 039A9A : C9 20       ;  | (shows image for 20 frames after the fireball is shot) 
                      BNE ReznorFiring                    ;; 039A9C : D0 03       ;  |						        
                      JSR ReznorFireRt                    ;; 039A9E : 20 F8 9A    ; /							        
ReznorFiring:         LDA.B #$01                          ;; ?QPWZ? : A9 01       ; \ Set firing image				        
                      STA.W !SpriteMisc1602,X             ;; 039AA3 : 9D 02 16    ; /							        
ReznorNoFiring:       JSR ReznorGfxRt                     ;; ?QPWZ? : 20 75 9B    ; Draw Reznor                                               
                      PLA                                 ;; 039AA9 : 68          ;
                      STA.W !SpriteMisc157C,X             ;; 039AAA : 9D 7C 15    ;
                      LDA.B !SpriteLock                   ;; 039AAD : A5 9D       ; \ If sprites locked, or mario already killed the Reznor on the platform, return		   
                      ORA.W !SpriteMisc151C,X             ;; 039AAF : 1D 1C 15    ;  |											   
                      BNE Return039AF7                    ;; 039AB2 : D0 43       ; /												   
                      LDA.W !SpriteMisc1564,X             ;; 039AB4 : BD 64 15    ; \ If time to bounce platform != 0C, return						   
                      CMP.B #$0C                          ;; 039AB7 : C9 0C       ;  | (causes delay between start of boucing platform and killing Reznor)			   
                      BNE Return039AF7                    ;; 039AB9 : D0 3C       ; /												   
                      LDA.B #$03                          ;; ?QPWZ? : A9 03       ; \ 
                      STA.W !SPCIO0                       ;; 039ABD : 8D F9 1D    ; / Play sound effect 
                      STZ.W !SpriteMisc1558,X             ;; 039AC0 : 9E 58 15    ; Prevent from throwing fire after death							   
                      INC.W !SpriteMisc151C,X             ;; 039AC3 : FE 1C 15    ; Record a hit on Reznor									   
                      JSL FindFreeSprSlot                 ;; 039AC6 : 22 E4 A9 02 ; \ Load Y with a free sprite index for dead Reznor						   
                      BMI Return039AF7                    ;; 039ACA : 30 2B       ; / Return if no free index									   
                      LDA.B #$02                          ;; 039ACC : A9 02       ; \ Set status to being killed								   
                      STA.W !SpriteStatus,Y               ;; 039ACE : 99 C8 14    ; /												   
                      LDA.B #$A9                          ;; 039AD1 : A9 A9       ; \ Sprite to use for dead Reznor								   
                      STA.W !SpriteNumber,Y               ;; 039AD3 : 99 9E 00    ; /												   
                      LDA.B !SpriteXPosLow,X              ;; 039AD6 : B5 E4       ; \ Transfer x position to dead Reznor							   
                      STA.W !SpriteXPosLow,Y              ;; 039AD8 : 99 E4 00    ;  |											   
                      LDA.W !SpriteYPosHigh,X             ;; 039ADB : BD E0 14    ;  |											   
                      STA.W !SpriteYPosHigh,Y             ;; 039ADE : 99 E0 14    ; /												   
                      LDA.B !SpriteYPosLow,X              ;; 039AE1 : B5 D8       ; \ Transfer y position to dead Reznor							   
                      STA.W !SpriteYPosLow,Y              ;; 039AE3 : 99 D8 00    ;  |											   
                      LDA.W !SpriteXPosHigh,X             ;; 039AE6 : BD D4 14    ;  |											   
                      STA.W !SpriteXPosHigh,Y             ;; 039AE9 : 99 D4 14    ; /												   
                      PHX                                 ;; 039AEC : DA          ; \ 											   
                      TYX                                 ;; 039AED : BB          ;  | Before: X must have index of sprite being generated					   
                      JSL InitSpriteTables                ;; 039AEE : 22 D2 F7 07 ; /  Routine clears all old sprite values and loads in new values for the 6 main sprite tables 
                      LDA.B #$C0                          ;; 039AF2 : A9 C0       ; \ Set y speed for Reznor's bounce off the platform					   
                      STA.B !SpriteYSpeed,X               ;; 039AF4 : 95 AA       ; /												   
                      PLX                                 ;; 039AF6 : FA          ; pull, X = sprite index                                                                       
Return039AF7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
ReznorFireRt:         LDY.B #$07                          ;; ?QPWZ? : A0 07       ; \ find a free extended sprite slot, return if all full 
CODE_039AFA:          LDA.W !ExtSpriteNumber,Y            ;; 039AFA : B9 0B 17    ;  | 
                      BEQ FoundRznrFireSlot               ;; 039AFD : F0 04       ;  | 
                      DEY                                 ;; 039AFF : 88          ;  | 
                      BPL CODE_039AFA                     ;; 039B00 : 10 F8       ;  | 
                      RTS                                 ;; ?QPWZ? : 60          ; / Return if no free slots 
                                                          ;;                      ;
FoundRznrFireSlot:    LDA.B #$10                          ;; ?QPWZ? : A9 10       ; \ 
                      STA.W !SPCIO0                       ;; 039B05 : 8D F9 1D    ; / Play sound effect 
                      LDA.B #$02                          ;; 039B08 : A9 02       ; \ Extended sprite = Reznor fireball 
                      STA.W !ExtSpriteNumber,Y            ;; 039B0A : 99 0B 17    ; / 
                      LDA.B !SpriteXPosLow,X              ;; 039B0D : B5 E4       ;
                      PHA                                 ;; 039B0F : 48          ;
                      SEC                                 ;; 039B10 : 38          ;
                      SBC.B #$08                          ;; 039B11 : E9 08       ;
                      STA.W !ExtSpriteXPosLow,Y           ;; 039B13 : 99 1F 17    ;
                      STA.B !SpriteXPosLow,X              ;; 039B16 : 95 E4       ;
                      LDA.W !SpriteYPosHigh,X             ;; 039B18 : BD E0 14    ;
                      SBC.B #$00                          ;; 039B1B : E9 00       ;
                      STA.W !ExtSpriteXPosHigh,Y          ;; 039B1D : 99 33 17    ;
                      LDA.B !SpriteYPosLow,X              ;; 039B20 : B5 D8       ;
                      PHA                                 ;; 039B22 : 48          ;
                      SEC                                 ;; 039B23 : 38          ;
                      SBC.B #$14                          ;; 039B24 : E9 14       ;
                      STA.B !SpriteYPosLow,X              ;; 039B26 : 95 D8       ;
                      STA.W !ExtSpriteYPosLow,Y           ;; 039B28 : 99 15 17    ;
                      LDA.W !SpriteXPosHigh,X             ;; 039B2B : BD D4 14    ;
                      PHA                                 ;; 039B2E : 48          ;
                      SBC.B #$00                          ;; 039B2F : E9 00       ;
                      STA.W !ExtSpriteYPosHigh,Y          ;; 039B31 : 99 29 17    ;
                      STA.W !SpriteXPosHigh,X             ;; 039B34 : 9D D4 14    ;
                      LDA.B #$10                          ;; 039B37 : A9 10       ;
                      JSR CODE_0397F9                     ;; 039B39 : 20 F9 97    ;
                      PLA                                 ;; 039B3C : 68          ;
                      STA.W !SpriteXPosHigh,X             ;; 039B3D : 9D D4 14    ;
                      PLA                                 ;; 039B40 : 68          ;
                      STA.B !SpriteYPosLow,X              ;; 039B41 : 95 D8       ;
                      PLA                                 ;; 039B43 : 68          ;
                      STA.B !SpriteXPosLow,X              ;; 039B44 : 95 E4       ;
                      LDA.B !_0                           ;; 039B46 : A5 00       ;
                      STA.W !ExtSpriteYSpeed,Y            ;; 039B48 : 99 3D 17    ;
                      LDA.B !_1                           ;; 039B4B : A5 01       ;
                      STA.W !ExtSpriteXSpeed,Y            ;; 039B4D : 99 47 17    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorTileDispX:      db $00,$F0,$00,$F0,$F0,$00,$F0,$00  ;; ?QPWZ?               ;
ReznorTileDispY:      db $E0,$E0,$F0,$F0                  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorTiles:          db $40,$42,$60,$62,$44,$46,$64,$66  ;; ?QPWZ?               ;
                      db $28,$28,$48,$48                  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorPal:            db $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F  ;; ?QPWZ?               ;
                      db $7F,$3F,$7F,$3F                  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorGfxRt:          LDA.W !SpriteMisc151C,X             ;; ?QPWZ? : BD 1C 15    ; \ if the reznor is dead, only draw the platform			  
                      BNE DrawReznorPlats                 ;; 039B78 : D0 65       ; /									  
                      JSR GetDrawInfoBnk3                 ;; 039B7A : 20 60 B7    ; after: Y = index to sprite tile map, $00 = sprite x, $01 = sprite y 
                      LDA.W !SpriteMisc1602,X             ;; 039B7D : BD 02 16    ; \ $03 = index to frame start (frame to show * 4 tiles per frame)	  
                      ASL A                               ;; 039B80 : 0A          ;  | 								  
                      ASL A                               ;; 039B81 : 0A          ;  |								  
                      STA.B !_3                           ;; 039B82 : 85 03       ; /									  
                      LDA.W !SpriteMisc157C,X             ;; 039B84 : BD 7C 15    ; \ $02 = direction index						  
                      ASL A                               ;; 039B87 : 0A          ;  |								  
                      ASL A                               ;; 039B88 : 0A          ;  |								  
                      STA.B !_2                           ;; 039B89 : 85 02       ; /                                                                   
                      PHX                                 ;; 039B8B : DA          ;
                      LDX.B #$03                          ;; 039B8C : A2 03       ;
RznrGfxLoopStart:     PHX                                 ;; ?QPWZ? : DA          ;
                      LDA.B !_3                           ;; 039B8F : A5 03       ;
                      CMP.B #$08                          ;; 039B91 : C9 08       ;
                      BCS CODE_039B99                     ;; 039B93 : B0 04       ;
                      TXA                                 ;; 039B95 : 8A          ;
                      ORA.B !_2                           ;; 039B96 : 05 02       ;
                      TAX                                 ;; 039B98 : AA          ;
CODE_039B99:          LDA.B !_0                           ;; 039B99 : A5 00       ;
                      CLC                                 ;; 039B9B : 18          ;
                      ADC.W ReznorTileDispX,X             ;; 039B9C : 7D 51 9B    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 039B9F : 99 00 03    ;
                      PLX                                 ;; 039BA2 : FA          ;
                      LDA.B !_1                           ;; 039BA3 : A5 01       ;
                      CLC                                 ;; 039BA5 : 18          ;
                      ADC.W ReznorTileDispY,X             ;; 039BA6 : 7D 59 9B    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039BA9 : 99 01 03    ;
                      PHX                                 ;; 039BAC : DA          ;
                      TXA                                 ;; 039BAD : 8A          ;
                      ORA.B !_3                           ;; 039BAE : 05 03       ;
                      TAX                                 ;; 039BB0 : AA          ;
                      LDA.W ReznorTiles,X                 ;; 039BB1 : BD 5D 9B    ; \ set tile					  
                      STA.W !OAMTileNo+$100,Y             ;; 039BB4 : 99 02 03    ; /							  
                      LDA.W ReznorPal,X                   ;; 039BB7 : BD 69 9B    ; \ set palette/properties				  
                      CPX.B #$08                          ;; 039BBA : E0 08       ;  | if turning, don't flip				  
                      BCS NoReznorGfxFlip                 ;; 039BBC : B0 06       ;  | 						  
                      LDX.B !_2                           ;; 039BBE : A6 02       ;  | if direction = 0, don't flip			  
                      BNE NoReznorGfxFlip                 ;; 039BC0 : D0 02       ;  |						  
                      EOR.B #$40                          ;; 039BC2 : 49 40       ;  |						  
NoReznorGfxFlip:      STA.W !OAMTileAttr+$100,Y           ;; ?QPWZ? : 99 03 03    ; /							  
                      PLX                                 ;; 039BC7 : FA          ; \ pull, X = current tile of the frame we're drawing 
                      INY                                 ;; 039BC8 : C8          ;  | Increase index to sprite tile map ($300)...	  
                      INY                                 ;; 039BC9 : C8          ;  |    ...we wrote 4 bytes...			  
                      INY                                 ;; 039BCA : C8          ;  |    ...so increment 4 times			  
                      INY                                 ;; 039BCB : C8          ;  |    						  
                      DEX                                 ;; 039BCC : CA          ;  | Go to next tile of frame and loop		  
                      BPL RznrGfxLoopStart                ;; 039BCD : 10 BF       ; / 						  
                      PLX                                 ;; 039BCF : FA          ; \							  
                      LDY.B #$02                          ;; 039BD0 : A0 02       ;  | Y = 02 (All 16x16 tiles)			  
                      LDA.B #$03                          ;; 039BD2 : A9 03       ;  | A = number of tiles drawn - 1			  
                      JSL FinishOAMWrite                  ;; 039BD4 : 22 B3 B7 01 ; / Don't draw if offscreen                           
                      LDA.W !SpriteStatus,X               ;; 039BD8 : BD C8 14    ;
                      CMP.B #$02                          ;; 039BDB : C9 02       ;
                      BEQ Return039BE2                    ;; 039BDD : F0 03       ;
DrawReznorPlats:      JSR ReznorPlatGfxRt                 ;; ?QPWZ? : 20 EB 9B    ;
Return039BE2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ReznorPlatDispY:      db $00,$03,$04,$05,$05,$04,$03,$00  ;; ?QPWZ?               ;
                                                          ;;                      ;
ReznorPlatGfxRt:      LDA.W !SpriteOAMIndex,X             ;; ?QPWZ? : BD EA 15    ;
                      CLC                                 ;; 039BEE : 18          ;
                      ADC.B #$10                          ;; 039BEF : 69 10       ;
                      STA.W !SpriteOAMIndex,X             ;; 039BF1 : 9D EA 15    ;
                      JSR GetDrawInfoBnk3                 ;; 039BF4 : 20 60 B7    ;
                      LDA.W !SpriteMisc1564,X             ;; 039BF7 : BD 64 15    ;
                      LSR A                               ;; 039BFA : 4A          ;
                      PHY                                 ;; 039BFB : 5A          ;
                      TAY                                 ;; 039BFC : A8          ;
                      LDA.W ReznorPlatDispY,Y             ;; 039BFD : B9 E3 9B    ;
                      STA.B !_2                           ;; 039C00 : 85 02       ;
                      PLY                                 ;; 039C02 : 7A          ;
                      LDA.B !_0                           ;; 039C03 : A5 00       ;
                      STA.W !OAMTileXPos+$104,Y           ;; 039C05 : 99 04 03    ;
                      SEC                                 ;; 039C08 : 38          ;
                      SBC.B #$10                          ;; 039C09 : E9 10       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 039C0B : 99 00 03    ;
                      LDA.B !_1                           ;; 039C0E : A5 01       ;
                      SEC                                 ;; 039C10 : 38          ;
                      SBC.B !_2                           ;; 039C11 : E5 02       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039C13 : 99 01 03    ;
                      STA.W !OAMTileYPos+$104,Y           ;; 039C16 : 99 05 03    ;
                      LDA.B #$4E                          ;; 039C19 : A9 4E       ; \ Tile of reznor platform...     
                      STA.W !OAMTileNo+$100,Y             ;; 039C1B : 99 02 03    ;  | ...store left side	       
                      STA.W !OAMTileNo+$104,Y             ;; 039C1E : 99 06 03    ; /  ...store right side	       
                      LDA.B #$33                          ;; 039C21 : A9 33       ; \ Palette of reznor platform...  
                      STA.W !OAMTileAttr+$100,Y           ;; 039C23 : 99 03 03    ;  |			       
                      ORA.B #$40                          ;; 039C26 : 09 40       ;  | ...flip right side	       
                      STA.W !OAMTileAttr+$104,Y           ;; 039C28 : 99 07 03    ; /				       
                      LDY.B #$02                          ;; 039C2B : A0 02       ; \				       
                      LDA.B #$01                          ;; 039C2D : A9 01       ;  | A = number of tiles drawn - 1 
                      JSL FinishOAMWrite                  ;; 039C2F : 22 B3 B7 01 ; / Don't draw if offscreen        
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
InvisBlk_DinosMain:   LDA.B !SpriteNumber,X               ;; ?QPWZ? : B5 9E       ; \ Branch if sprite isn't "Invisible solid block" 
                      CMP.B #$6D                          ;; 039C36 : C9 6D       ;  | 
                      BNE DinoMainRt                      ;; 039C38 : D0 05       ; / 
                      JSL InvisBlkMainRt                  ;; 039C3A : 22 4F B4 01 ; \ Call "Invisible solid block" routine 
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
DinoMainRt:           PHB                                 ;; ?QPWZ? : 8B          ;
                      PHK                                 ;; 039C40 : 4B          ;
                      PLB                                 ;; 039C41 : AB          ;
                      JSR DinoMainSubRt                   ;; 039C42 : 20 47 9C    ;
                      PLB                                 ;; 039C45 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
DinoMainSubRt:        JSR DinoGfxRt                       ;; ?QPWZ? : 20 49 9E    ;
                      LDA.B !SpriteLock                   ;; 039C4A : A5 9D       ;
                      BNE Return039CA3                    ;; 039C4C : D0 55       ;
                      LDA.W !SpriteStatus,X               ;; 039C4E : BD C8 14    ;
                      CMP.B #$08                          ;; 039C51 : C9 08       ;
                      BNE Return039CA3                    ;; 039C53 : D0 4E       ;
                      JSR SubOffscreen0Bnk3               ;; 039C55 : 20 5D B8    ;
                      JSL MarioSprInteract                ;; 039C58 : 22 DC A7 01 ;
                      JSL UpdateSpritePos                 ;; 039C5C : 22 2A 80 01 ;
                      LDA.B !SpriteTableC2,X              ;; 039C60 : B5 C2       ;
                      JSL ExecutePtr                      ;; 039C62 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_039CA8                      ;; ?QPWZ? : A8 9C       ;
                      dw CODE_039D41                      ;; ?QPWZ? : 41 9D       ;
                      dw CODE_039D41                      ;; ?QPWZ? : 41 9D       ;
                      dw CODE_039C74                      ;; ?QPWZ? : 74 9C       ;
                                                          ;;                      ;
DATA_039C6E:          db $00,$FE,$02                      ;; 039C6E               ;
                                                          ;;                      ;
DATA_039C71:          db $00,$FF,$00                      ;; 039C71               ;
                                                          ;;                      ;
CODE_039C74:          LDA.B !SpriteYSpeed,X               ;; 039C74 : B5 AA       ;
                      BMI CODE_039C89                     ;; 039C76 : 30 11       ;
                      STZ.B !SpriteTableC2,X              ;; 039C78 : 74 C2       ;
                      LDA.W !SpriteBlockedDirs,X          ;; 039C7A : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 039C7D : 29 03       ;  | 
                      BEQ CODE_039C89                     ;; 039C7F : F0 08       ; / 
                      LDA.W !SpriteMisc157C,X             ;; 039C81 : BD 7C 15    ;
                      EOR.B #$01                          ;; 039C84 : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 039C86 : 9D 7C 15    ;
CODE_039C89:          STZ.W !SpriteMisc1602,X             ;; 039C89 : 9E 02 16    ;
                      LDA.W !SpriteBlockedDirs,X          ;; 039C8C : BD 88 15    ;
                      AND.B #$03                          ;; 039C8F : 29 03       ;
                      TAY                                 ;; 039C91 : A8          ;
                      LDA.B !SpriteXPosLow,X              ;; 039C92 : B5 E4       ;
                      CLC                                 ;; 039C94 : 18          ;
                      ADC.W DATA_039C6E,Y                 ;; 039C95 : 79 6E 9C    ;
                      STA.B !SpriteXPosLow,X              ;; 039C98 : 95 E4       ;
                      LDA.W !SpriteYPosHigh,X             ;; 039C9A : BD E0 14    ;
                      ADC.W DATA_039C71,Y                 ;; 039C9D : 79 71 9C    ;
                      STA.W !SpriteYPosHigh,X             ;; 039CA0 : 9D E0 14    ;
Return039CA3:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoSpeed:            db $08,$F8,$10,$F0                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_039CA8:          LDA.W !SpriteBlockedDirs,X          ;; 039CA8 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 039CAB : 29 04       ;  | 
                      BEQ CODE_039C89                     ;; 039CAD : F0 DA       ; / 
                      LDA.W !SpriteMisc1540,X             ;; 039CAF : BD 40 15    ;
                      BNE CODE_039CC8                     ;; 039CB2 : D0 14       ;
                      LDA.B !SpriteNumber,X               ;; 039CB4 : B5 9E       ;
                      CMP.B #$6E                          ;; 039CB6 : C9 6E       ;
                      BEQ CODE_039CC8                     ;; 039CB8 : F0 0E       ;
                      LDA.B #$FF                          ;; 039CBA : A9 FF       ; \ Set fire breathing timer 
                      STA.W !SpriteMisc1540,X             ;; 039CBC : 9D 40 15    ; / 
                      JSL GetRand                         ;; 039CBF : 22 F9 AC 01 ;
                      AND.B #$01                          ;; 039CC3 : 29 01       ;
                      INC A                               ;; 039CC5 : 1A          ;
                      STA.B !SpriteTableC2,X              ;; 039CC6 : 95 C2       ;
CODE_039CC8:          TXA                                 ;; 039CC8 : 8A          ;
                      ASL A                               ;; 039CC9 : 0A          ;
                      ASL A                               ;; 039CCA : 0A          ;
                      ASL A                               ;; 039CCB : 0A          ;
                      ASL A                               ;; 039CCC : 0A          ;
                      ADC.B !EffFrame                     ;; 039CCD : 65 14       ;
                      AND.B #$3F                          ;; 039CCF : 29 3F       ;
                      BNE CODE_039CDA                     ;; 039CD1 : D0 07       ;
                      JSR SubHorzPosBnk3                  ;; 039CD3 : 20 17 B8    ; \ If not facing mario, change directions 
                      TYA                                 ;; 039CD6 : 98          ;  | 
                      STA.W !SpriteMisc157C,X             ;; 039CD7 : 9D 7C 15    ; / 
CODE_039CDA:          LDA.B #$10                          ;; 039CDA : A9 10       ;
                      STA.B !SpriteYSpeed,X               ;; 039CDC : 95 AA       ;
                      LDY.W !SpriteMisc157C,X             ;; 039CDE : BC 7C 15    ; \ Set x speed for rhino based on direction and sprite number 
                      LDA.B !SpriteNumber,X               ;; 039CE1 : B5 9E       ;  | 
                      CMP.B #$6E                          ;; 039CE3 : C9 6E       ;  | 
                      BEQ CODE_039CE9                     ;; 039CE5 : F0 02       ;  | 
                      INY                                 ;; 039CE7 : C8          ;  | 
                      INY                                 ;; 039CE8 : C8          ;  | 
CODE_039CE9:          LDA.W DinoSpeed,Y                   ;; 039CE9 : B9 A4 9C    ;  | 
                      STA.B !SpriteXSpeed,X               ;; 039CEC : 95 B6       ; / 
                      JSR DinoSetGfxFrame                 ;; 039CEE : 20 EF 9D    ;
                      LDA.W !SpriteBlockedDirs,X          ;; 039CF1 : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 039CF4 : 29 03       ;  | 
                      BEQ Return039D00                    ;; 039CF6 : F0 08       ; / 
                      LDA.B #$C0                          ;; 039CF8 : A9 C0       ;
                      STA.B !SpriteYSpeed,X               ;; 039CFA : 95 AA       ;
                      LDA.B #$03                          ;; 039CFC : A9 03       ;
                      STA.B !SpriteTableC2,X              ;; 039CFE : 95 C2       ;
Return039D00:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoFlameTable:       db $41,$42,$42,$32,$22,$12,$02,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$02,$02,$02,$02,$12  ;; ?QPWZ?               ;
                      db $22,$32,$42,$42,$42,$42,$41,$41  ;; ?QPWZ?               ;
                      db $41,$43,$43,$33,$23,$13,$03,$03  ;; ?QPWZ?               ;
                      db $03,$03,$03,$03,$03,$03,$03,$03  ;; ?QPWZ?               ;
                      db $03,$03,$03,$03,$03,$03,$03,$13  ;; ?QPWZ?               ;
                      db $23,$33,$43,$43,$43,$43,$41,$41  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_039D41:          STZ.B !SpriteXSpeed,X               ;; 039D41 : 74 B6       ; Sprite X Speed = 0 
                      LDA.W !SpriteMisc1540,X             ;; 039D43 : BD 40 15    ;
                      BNE DinoFlameTimerSet               ;; 039D46 : D0 09       ;
                      STZ.B !SpriteTableC2,X              ;; 039D48 : 74 C2       ;
                      LDA.B #$40                          ;; 039D4A : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 039D4C : 9D 40 15    ;
                      LDA.B #$00                          ;; 039D4F : A9 00       ;
DinoFlameTimerSet:    CMP.B #$C0                          ;; ?QPWZ? : C9 C0       ;
                      BNE CODE_039D5A                     ;; 039D53 : D0 05       ;
                      LDY.B #$17                          ;; 039D55 : A0 17       ; \ Play sound effect 
                      STY.W !SPCIO3                       ;; 039D57 : 8C FC 1D    ; / 
CODE_039D5A:          LSR A                               ;; 039D5A : 4A          ;
                      LSR A                               ;; 039D5B : 4A          ;
                      LSR A                               ;; 039D5C : 4A          ;
                      LDY.B !SpriteTableC2,X              ;; 039D5D : B4 C2       ;
                      CPY.B #$02                          ;; 039D5F : C0 02       ;
                      BNE CODE_039D66                     ;; 039D61 : D0 03       ;
                      CLC                                 ;; 039D63 : 18          ;
                      ADC.B #$20                          ;; 039D64 : 69 20       ;
CODE_039D66:          TAY                                 ;; 039D66 : A8          ;
                      LDA.W DinoFlameTable,Y              ;; 039D67 : B9 01 9D    ;
                      PHA                                 ;; 039D6A : 48          ;
                      AND.B #$0F                          ;; 039D6B : 29 0F       ;
                      STA.W !SpriteMisc1602,X             ;; 039D6D : 9D 02 16    ;
                      PLA                                 ;; 039D70 : 68          ;
                      LSR A                               ;; 039D71 : 4A          ;
                      LSR A                               ;; 039D72 : 4A          ;
                      LSR A                               ;; 039D73 : 4A          ;
                      LSR A                               ;; 039D74 : 4A          ;
                      STA.W !SpriteMisc151C,X             ;; 039D75 : 9D 1C 15    ;
                      BNE Return039D9D                    ;; 039D78 : D0 23       ;
                      LDA.B !SpriteNumber,X               ;; 039D7A : B5 9E       ;
                      CMP.B #$6E                          ;; 039D7C : C9 6E       ;
                      BEQ Return039D9D                    ;; 039D7E : F0 1D       ;
                      TXA                                 ;; 039D80 : 8A          ;
                      EOR.B !TrueFrame                    ;; 039D81 : 45 13       ;
                      AND.B #$03                          ;; 039D83 : 29 03       ;
                      BNE Return039D9D                    ;; 039D85 : D0 16       ;
                      JSR DinoFlameClipping               ;; 039D87 : 20 B6 9D    ;
                      JSL GetMarioClipping                ;; 039D8A : 22 64 B6 03 ;
                      JSL CheckForContact                 ;; 039D8E : 22 2B B7 03 ;
                      BCC Return039D9D                    ;; 039D92 : 90 09       ;
                      LDA.W !InvinsibilityTimer           ;; 039D94 : AD 90 14    ; \ Branch if Mario has star 
                      BNE Return039D9D                    ;; 039D97 : D0 04       ; / 
                      JSL HurtMario                       ;; 039D99 : 22 B7 F5 00 ;
Return039D9D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoFlame1:           db $DC,$02,$10,$02                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame2:           db $FF,$00,$00,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame3:           db $24,$0C,$24,$0C                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame4:           db $02,$DC,$02,$DC                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame5:           db $00,$FF,$00,$FF                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlame6:           db $0C,$24,$0C,$24                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlameClipping:    LDA.W !SpriteMisc1602,X             ;; ?QPWZ? : BD 02 16    ;
                      SEC                                 ;; 039DB9 : 38          ;
                      SBC.B #$02                          ;; 039DBA : E9 02       ;
                      TAY                                 ;; 039DBC : A8          ;
                      LDA.W !SpriteMisc157C,X             ;; 039DBD : BD 7C 15    ;
                      BNE CODE_039DC4                     ;; 039DC0 : D0 02       ;
                      INY                                 ;; 039DC2 : C8          ;
                      INY                                 ;; 039DC3 : C8          ;
CODE_039DC4:          LDA.B !SpriteXPosLow,X              ;; 039DC4 : B5 E4       ;
                      CLC                                 ;; 039DC6 : 18          ;
                      ADC.W DinoFlame1,Y                  ;; 039DC7 : 79 9E 9D    ;
                      STA.B !_4                           ;; 039DCA : 85 04       ;
                      LDA.W !SpriteYPosHigh,X             ;; 039DCC : BD E0 14    ;
                      ADC.W DinoFlame2,Y                  ;; 039DCF : 79 A2 9D    ;
                      STA.B !_A                           ;; 039DD2 : 85 0A       ;
                      LDA.W DinoFlame3,Y                  ;; 039DD4 : B9 A6 9D    ;
                      STA.B !_6                           ;; 039DD7 : 85 06       ;
                      LDA.B !SpriteYPosLow,X              ;; 039DD9 : B5 D8       ;
                      CLC                                 ;; 039DDB : 18          ;
                      ADC.W DinoFlame4,Y                  ;; 039DDC : 79 AA 9D    ;
                      STA.B !_5                           ;; 039DDF : 85 05       ;
                      LDA.W !SpriteXPosHigh,X             ;; 039DE1 : BD D4 14    ;
                      ADC.W DinoFlame5,Y                  ;; 039DE4 : 79 AE 9D    ;
                      STA.B !_B                           ;; 039DE7 : 85 0B       ;
                      LDA.W DinoFlame6,Y                  ;; 039DE9 : B9 B2 9D    ;
                      STA.B !_7                           ;; 039DEC : 85 07       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
DinoSetGfxFrame:      INC.W !SpriteMisc1570,X             ;; ?QPWZ? : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 039DF2 : BD 70 15    ;
                      AND.B #$08                          ;; 039DF5 : 29 08       ;
                      LSR A                               ;; 039DF7 : 4A          ;
                      LSR A                               ;; 039DF8 : 4A          ;
                      LSR A                               ;; 039DF9 : 4A          ;
                      STA.W !SpriteMisc1602,X             ;; 039DFA : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoTorchTileDispX:   db $D8,$E0,$EC,$F8,$00,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchTileDispY:   db $00,$00,$00,$00,$00,$D8,$E0,$EC  ;; ?QPWZ?               ;
                      db $F8,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoFlameTiles:       db $80,$82,$84,$86,$00,$88,$8A,$8C  ;; ?QPWZ?               ;
                      db $8E,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchGfxProp:     db $09,$05,$05,$05,$0F              ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoTorchTiles:       db $EA,$AA,$C4,$C6                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoRhinoTileDispX:   db $F8,$08,$F8,$08,$08,$F8,$08,$F8  ;; ?QPWZ?               ;
DinoRhinoGfxProp:     db $2F,$2F,$2F,$2F,$6F,$6F,$6F,$6F  ;; ?QPWZ?               ;
DinoRhinoTileDispY:   db $F0,$F0,$00,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoRhinoTiles:       db $C0,$C2,$E4,$E6,$C0,$C2,$E0,$E2  ;; ?QPWZ?               ;
                      db $C8,$CA,$E8,$E2,$CC,$CE,$EC,$EE  ;; ?QPWZ?               ;
                                                          ;;                      ;
DinoGfxRt:            JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      LDA.W !SpriteMisc157C,X             ;; 039E4C : BD 7C 15    ;
                      STA.B !_2                           ;; 039E4F : 85 02       ;
                      LDA.W !SpriteMisc1602,X             ;; 039E51 : BD 02 16    ;
                      STA.B !_4                           ;; 039E54 : 85 04       ;
                      LDA.B !SpriteNumber,X               ;; 039E56 : B5 9E       ;
                      CMP.B #$6F                          ;; 039E58 : C9 6F       ;
                      BEQ CODE_039EA9                     ;; 039E5A : F0 4D       ;
                      PHX                                 ;; 039E5C : DA          ;
                      LDX.B #$03                          ;; 039E5D : A2 03       ;
CODE_039E5F:          STX.B !_F                           ;; 039E5F : 86 0F       ;
                      LDA.B !_2                           ;; 039E61 : A5 02       ;
                      CMP.B #$01                          ;; 039E63 : C9 01       ;
                      BCS CODE_039E6C                     ;; 039E65 : B0 05       ;
                      TXA                                 ;; 039E67 : 8A          ;
                      CLC                                 ;; 039E68 : 18          ;
                      ADC.B #$04                          ;; 039E69 : 69 04       ;
                      TAX                                 ;; 039E6B : AA          ;
CODE_039E6C:          LDA.W DinoRhinoGfxProp,X            ;; 039E6C : BD 2D 9E    ;
                      STA.W !OAMTileAttr+$100,Y           ;; 039E6F : 99 03 03    ;
                      LDA.W DinoRhinoTileDispX,X          ;; 039E72 : BD 25 9E    ;
                      CLC                                 ;; 039E75 : 18          ;
                      ADC.B !_0                           ;; 039E76 : 65 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 039E78 : 99 00 03    ;
                      LDA.B !_4                           ;; 039E7B : A5 04       ;
                      CMP.B #$01                          ;; 039E7D : C9 01       ;
                      LDX.B !_F                           ;; 039E7F : A6 0F       ;
                      LDA.W DinoRhinoTileDispY,X          ;; 039E81 : BD 35 9E    ;
                      ADC.B !_1                           ;; 039E84 : 65 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039E86 : 99 01 03    ;
                      LDA.B !_4                           ;; 039E89 : A5 04       ;
                      ASL A                               ;; 039E8B : 0A          ;
                      ASL A                               ;; 039E8C : 0A          ;
                      ADC.B !_F                           ;; 039E8D : 65 0F       ;
                      TAX                                 ;; 039E8F : AA          ;
                      LDA.W DinoRhinoTiles,X              ;; 039E90 : BD 39 9E    ;
                      STA.W !OAMTileNo+$100,Y             ;; 039E93 : 99 02 03    ;
                      INY                                 ;; 039E96 : C8          ;
                      INY                                 ;; 039E97 : C8          ;
                      INY                                 ;; 039E98 : C8          ;
                      INY                                 ;; 039E99 : C8          ;
                      LDX.B !_F                           ;; 039E9A : A6 0F       ;
                      DEX                                 ;; 039E9C : CA          ;
                      BPL CODE_039E5F                     ;; 039E9D : 10 C0       ;
                      PLX                                 ;; 039E9F : FA          ;
                      LDA.B #$03                          ;; 039EA0 : A9 03       ;
                      LDY.B #$02                          ;; 039EA2 : A0 02       ;
                      JSL FinishOAMWrite                  ;; 039EA4 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039EA9:          LDA.W !SpriteMisc151C,X             ;; 039EA9 : BD 1C 15    ;
                      STA.B !_3                           ;; 039EAC : 85 03       ;
                      LDA.W !SpriteMisc1602,X             ;; 039EAE : BD 02 16    ;
                      STA.B !_4                           ;; 039EB1 : 85 04       ;
                      PHX                                 ;; 039EB3 : DA          ;
                      LDA.B !EffFrame                     ;; 039EB4 : A5 14       ;
                      AND.B #$02                          ;; 039EB6 : 29 02       ;
                      ASL A                               ;; 039EB8 : 0A          ;
                      ASL A                               ;; 039EB9 : 0A          ;
                      ASL A                               ;; 039EBA : 0A          ;
                      ASL A                               ;; 039EBB : 0A          ;
                      ASL A                               ;; 039EBC : 0A          ;
                      LDX.B !_4                           ;; 039EBD : A6 04       ;
                      CPX.B #$03                          ;; 039EBF : E0 03       ;
                      BEQ CODE_039EC4                     ;; 039EC1 : F0 01       ;
                      ASL A                               ;; 039EC3 : 0A          ;
CODE_039EC4:          STA.B !_5                           ;; 039EC4 : 85 05       ;
                      LDX.B #$04                          ;; 039EC6 : A2 04       ;
CODE_039EC8:          STX.B !_6                           ;; 039EC8 : 86 06       ;
                      LDA.B !_4                           ;; 039ECA : A5 04       ;
                      CMP.B #$03                          ;; 039ECC : C9 03       ;
                      BNE CODE_039ED5                     ;; 039ECE : D0 05       ;
                      TXA                                 ;; 039ED0 : 8A          ;
                      CLC                                 ;; 039ED1 : 18          ;
                      ADC.B #$05                          ;; 039ED2 : 69 05       ;
                      TAX                                 ;; 039ED4 : AA          ;
CODE_039ED5:          PHX                                 ;; 039ED5 : DA          ;
                      LDA.W DinoTorchTileDispX,X          ;; 039ED6 : BD FE 9D    ;
                      LDX.B !_2                           ;; 039ED9 : A6 02       ;
                      BNE CODE_039EE0                     ;; 039EDB : D0 03       ;
                      EOR.B #$FF                          ;; 039EDD : 49 FF       ;
                      INC A                               ;; 039EDF : 1A          ;
CODE_039EE0:          PLX                                 ;; 039EE0 : FA          ;
                      CLC                                 ;; 039EE1 : 18          ;
                      ADC.B !_0                           ;; 039EE2 : 65 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 039EE4 : 99 00 03    ;
                      LDA.W DinoTorchTileDispY,X          ;; 039EE7 : BD 08 9E    ;
                      CLC                                 ;; 039EEA : 18          ;
                      ADC.B !_1                           ;; 039EEB : 65 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 039EED : 99 01 03    ;
                      LDA.B !_6                           ;; 039EF0 : A5 06       ;
                      CMP.B #$04                          ;; 039EF2 : C9 04       ;
                      BNE CODE_039EFD                     ;; 039EF4 : D0 07       ;
                      LDX.B !_4                           ;; 039EF6 : A6 04       ;
                      LDA.W DinoTorchTiles,X              ;; 039EF8 : BD 21 9E    ;
                      BRA CODE_039F00                     ;; 039EFB : 80 03       ;
                                                          ;;                      ;
CODE_039EFD:          LDA.W DinoFlameTiles,X              ;; 039EFD : BD 12 9E    ;
CODE_039F00:          STA.W !OAMTileNo+$100,Y             ;; 039F00 : 99 02 03    ;
                      LDA.B #$00                          ;; 039F03 : A9 00       ;
                      LDX.B !_2                           ;; 039F05 : A6 02       ;
                      BNE CODE_039F0B                     ;; 039F07 : D0 02       ;
                      ORA.B #$40                          ;; 039F09 : 09 40       ;
CODE_039F0B:          LDX.B !_6                           ;; 039F0B : A6 06       ;
                      CPX.B #$04                          ;; 039F0D : E0 04       ;
                      BEQ CODE_039F13                     ;; 039F0F : F0 02       ;
                      EOR.B !_5                           ;; 039F11 : 45 05       ;
CODE_039F13:          ORA.W DinoTorchGfxProp,X            ;; 039F13 : 1D 1C 9E    ;
                      ORA.B !SpriteProperties             ;; 039F16 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 039F18 : 99 03 03    ;
                      INY                                 ;; 039F1B : C8          ;
                      INY                                 ;; 039F1C : C8          ;
                      INY                                 ;; 039F1D : C8          ;
                      INY                                 ;; 039F1E : C8          ;
                      DEX                                 ;; 039F1F : CA          ;
                      CPX.B !_3                           ;; 039F20 : E4 03       ;
                      BPL CODE_039EC8                     ;; 039F22 : 10 A4       ;
                      PLX                                 ;; 039F24 : FA          ;
                      LDY.W !SpriteMisc151C,X             ;; 039F25 : BC 1C 15    ;
                      LDA.W DinoTilesWritten,Y            ;; 039F28 : B9 32 9F    ;
                      LDY.B #$02                          ;; 039F2B : A0 02       ;
                      JSL FinishOAMWrite                  ;; 039F2D : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DinoTilesWritten:     db $04,$03,$02,$01,$00              ;; ?QPWZ?               ;
                                                          ;;                      ;
                      RTS                                 ;; ?QPWZ? : 60          ;
                                                          ;;                      ;
Blargg:               JSR CODE_03A062                     ;; ?QPWZ? : 20 62 A0    ;
                      LDA.B !SpriteLock                   ;; 039F3B : A5 9D       ;
                      BNE Return039F56                    ;; 039F3D : D0 17       ;
                      JSL MarioSprInteract                ;; 039F3F : 22 DC A7 01 ;
                      JSR SubOffscreen0Bnk3               ;; 039F43 : 20 5D B8    ;
                      LDA.B !SpriteTableC2,X              ;; 039F46 : B5 C2       ;
                      JSL ExecutePtr                      ;; 039F48 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_039F57                      ;; ?QPWZ? : 57 9F       ;
                      dw CODE_039F8B                      ;; ?QPWZ? : 8B 9F       ;
                      dw CODE_039FA4                      ;; ?QPWZ? : A4 9F       ;
                      dw CODE_039FC8                      ;; ?QPWZ? : C8 9F       ;
                      dw CODE_039FEF                      ;; ?QPWZ? : EF 9F       ;
                                                          ;;                      ;
Return039F56:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F57:          LDA.W !SpriteOffscreenX,X           ;; 039F57 : BD A0 15    ;
                      ORA.W !SpriteMisc1540,X             ;; 039F5A : 1D 40 15    ;
                      BNE Return039F8A                    ;; 039F5D : D0 2B       ;
                      JSR SubHorzPosBnk3                  ;; 039F5F : 20 17 B8    ;
                      LDA.B !_F                           ;; 039F62 : A5 0F       ;
                      CLC                                 ;; 039F64 : 18          ;
                      ADC.B #$70                          ;; 039F65 : 69 70       ;
                      CMP.B #$E0                          ;; 039F67 : C9 E0       ;
                      BCS Return039F8A                    ;; 039F69 : B0 1F       ;
                      LDA.B #$E3                          ;; 039F6B : A9 E3       ;
                      STA.B !SpriteYSpeed,X               ;; 039F6D : 95 AA       ;
                      LDA.W !SpriteYPosHigh,X             ;; 039F6F : BD E0 14    ;
                      STA.W !SpriteMisc151C,X             ;; 039F72 : 9D 1C 15    ;
                      LDA.B !SpriteXPosLow,X              ;; 039F75 : B5 E4       ;
                      STA.W !SpriteMisc1528,X             ;; 039F77 : 9D 28 15    ;
                      LDA.W !SpriteXPosHigh,X             ;; 039F7A : BD D4 14    ;
                      STA.W !SpriteMisc1534,X             ;; 039F7D : 9D 34 15    ;
                      LDA.B !SpriteYPosLow,X              ;; 039F80 : B5 D8       ;
                      STA.W !SpriteMisc1594,X             ;; 039F82 : 9D 94 15    ;
                      JSR CODE_039FC0                     ;; 039F85 : 20 C0 9F    ;
                      INC.B !SpriteTableC2,X              ;; 039F88 : F6 C2       ;
Return039F8A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F8B:          LDA.B !SpriteYSpeed,X               ;; 039F8B : B5 AA       ;
                      CMP.B #$10                          ;; 039F8D : C9 10       ;
                      BMI CODE_039F9B                     ;; 039F8F : 30 0A       ;
                      LDA.B #$50                          ;; 039F91 : A9 50       ;
                      STA.W !SpriteMisc1540,X             ;; 039F93 : 9D 40 15    ;
                      INC.B !SpriteTableC2,X              ;; 039F96 : F6 C2       ;
                      STZ.B !SpriteYSpeed,X               ;; 039F98 : 74 AA       ; Sprite Y Speed = 0 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039F9B:          JSL UpdateYPosNoGvtyW               ;; 039F9B : 22 1A 80 01 ;
                      INC.B !SpriteYSpeed,X               ;; 039F9F : F6 AA       ;
                      INC.B !SpriteYSpeed,X               ;; 039FA1 : F6 AA       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FA4:          LDA.W !SpriteMisc1540,X             ;; 039FA4 : BD 40 15    ;
                      BNE CODE_039FB1                     ;; 039FA7 : D0 08       ;
                      INC.B !SpriteTableC2,X              ;; 039FA9 : F6 C2       ;
                      LDA.B #$0A                          ;; 039FAB : A9 0A       ;
                      STA.W !SpriteMisc1540,X             ;; 039FAD : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FB1:          CMP.B #$20                          ;; 039FB1 : C9 20       ;
                      BCC CODE_039FC0                     ;; 039FB3 : 90 0B       ;
                      AND.B #$1F                          ;; 039FB5 : 29 1F       ;
                      BNE Return039FC7                    ;; 039FB7 : D0 0E       ;
                      LDA.W !SpriteMisc157C,X             ;; 039FB9 : BD 7C 15    ;
                      EOR.B #$01                          ;; 039FBC : 49 01       ;
                      BRA CODE_039FC4                     ;; 039FBE : 80 04       ;
                                                          ;;                      ;
CODE_039FC0:          JSR SubHorzPosBnk3                  ;; 039FC0 : 20 17 B8    ;
                      TYA                                 ;; 039FC3 : 98          ;
CODE_039FC4:          STA.W !SpriteMisc157C,X             ;; 039FC4 : 9D 7C 15    ;
Return039FC7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FC8:          LDA.W !SpriteMisc1540,X             ;; 039FC8 : BD 40 15    ;
                      BEQ CODE_039FD6                     ;; 039FCB : F0 09       ;
                      LDA.B #$20                          ;; 039FCD : A9 20       ;
                      STA.B !SpriteYSpeed,X               ;; 039FCF : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 039FD1 : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_039FD6:          LDA.B #$20                          ;; 039FD6 : A9 20       ;
                      STA.W !SpriteMisc1540,X             ;; 039FD8 : 9D 40 15    ;
                      LDY.W !SpriteMisc157C,X             ;; 039FDB : BC 7C 15    ;
                      LDA.W DATA_039FED,Y                 ;; 039FDE : B9 ED 9F    ;
                      STA.B !SpriteXSpeed,X               ;; 039FE1 : 95 B6       ;
                      LDA.B #$E2                          ;; 039FE3 : A9 E2       ;
                      STA.B !SpriteYSpeed,X               ;; 039FE5 : 95 AA       ;
                      JSR CODE_03A045                     ;; 039FE7 : 20 45 A0    ;
                      INC.B !SpriteTableC2,X              ;; 039FEA : F6 C2       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_039FED:          db $10,$F0                          ;; 039FED               ;
                                                          ;;                      ;
CODE_039FEF:          STZ.W !SpriteMisc1602,X             ;; 039FEF : 9E 02 16    ;
                      LDA.W !SpriteMisc1540,X             ;; 039FF2 : BD 40 15    ;
                      BEQ CODE_03A002                     ;; 039FF5 : F0 0B       ;
                      DEC A                               ;; 039FF7 : 3A          ;
                      BNE CODE_03A038                     ;; 039FF8 : D0 3E       ;
                      LDA.B #$25                          ;; 039FFA : A9 25       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 039FFC : 8D F9 1D    ; / 
                      JSR CODE_03A045                     ;; 039FFF : 20 45 A0    ;
CODE_03A002:          JSL UpdateXPosNoGvtyW               ;; 03A002 : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 03A006 : 22 1A 80 01 ;
                      LDA.B !TrueFrame                    ;; 03A00A : A5 13       ;
                      AND.B #$00                          ;; 03A00C : 29 00       ;
                      BNE CODE_03A012                     ;; 03A00E : D0 02       ;
                      INC.B !SpriteYSpeed,X               ;; 03A010 : F6 AA       ;
CODE_03A012:          LDA.B !SpriteYSpeed,X               ;; 03A012 : B5 AA       ;
                      CMP.B #$20                          ;; 03A014 : C9 20       ;
                      BMI CODE_03A038                     ;; 03A016 : 30 20       ;
                      JSR CODE_03A045                     ;; 03A018 : 20 45 A0    ;
                      STZ.B !SpriteTableC2,X              ;; 03A01B : 74 C2       ;
                      LDA.W !SpriteMisc151C,X             ;; 03A01D : BD 1C 15    ;
                      STA.W !SpriteYPosHigh,X             ;; 03A020 : 9D E0 14    ;
                      LDA.W !SpriteMisc1528,X             ;; 03A023 : BD 28 15    ;
                      STA.B !SpriteXPosLow,X              ;; 03A026 : 95 E4       ;
                      LDA.W !SpriteMisc1534,X             ;; 03A028 : BD 34 15    ;
                      STA.W !SpriteXPosHigh,X             ;; 03A02B : 9D D4 14    ;
                      LDA.W !SpriteMisc1594,X             ;; 03A02E : BD 94 15    ;
                      STA.B !SpriteYPosLow,X              ;; 03A031 : 95 D8       ;
                      LDA.B #$40                          ;; 03A033 : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 03A035 : 9D 40 15    ;
CODE_03A038:          LDA.B !SpriteYSpeed,X               ;; 03A038 : B5 AA       ;
                      CLC                                 ;; 03A03A : 18          ;
                      ADC.B #$06                          ;; 03A03B : 69 06       ;
                      CMP.B #$0C                          ;; 03A03D : C9 0C       ;
                      BCS Return03A044                    ;; 03A03F : B0 03       ;
                      INC.W !SpriteMisc1602,X             ;; 03A041 : FE 02 16    ;
Return03A044:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A045:          LDA.B !SpriteYPosLow,X              ;; 03A045 : B5 D8       ;
                      PHA                                 ;; 03A047 : 48          ;
                      SEC                                 ;; 03A048 : 38          ;
                      SBC.B #$0C                          ;; 03A049 : E9 0C       ;
                      STA.B !SpriteYPosLow,X              ;; 03A04B : 95 D8       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03A04D : BD D4 14    ;
                      PHA                                 ;; 03A050 : 48          ;
                      SBC.B #$00                          ;; 03A051 : E9 00       ;
                      STA.W !SpriteXPosHigh,X             ;; 03A053 : 9D D4 14    ;
                      JSL CODE_028528                     ;; 03A056 : 22 28 85 02 ;
                      PLA                                 ;; 03A05A : 68          ;
                      STA.W !SpriteXPosHigh,X             ;; 03A05B : 9D D4 14    ;
                      PLA                                 ;; 03A05E : 68          ;
                      STA.B !SpriteYPosLow,X              ;; 03A05F : 95 D8       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A062:          JSR GetDrawInfoBnk3                 ;; 03A062 : 20 60 B7    ;
                      LDA.B !SpriteTableC2,X              ;; 03A065 : B5 C2       ;
                      BEQ CODE_03A038                     ;; 03A067 : F0 CF       ;
                      CMP.B #$04                          ;; 03A069 : C9 04       ;
                      BEQ CODE_03A09D                     ;; 03A06B : F0 30       ;
                      JSL GenericSprGfxRt2                ;; 03A06D : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 03A071 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$A0                          ;; 03A074 : A9 A0       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03A076 : 99 02 03    ;
                      LDA.W !OAMTileAttr+$100,Y           ;; 03A079 : B9 03 03    ;
                      AND.B #$CF                          ;; 03A07C : 29 CF       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03A07E : 99 03 03    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A082:          db $F8,$08,$F8,$08,$18,$08,$F8,$08  ;; 03A082               ;
                      db $F8,$E8                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03A08C:          db $F8,$F8,$08,$08,$08              ;; 03A08C               ;
                                                          ;;                      ;
BlarggTilemap:        db $A2,$A4,$C2,$C4,$A6,$A2,$A4,$E6  ;; ?QPWZ?               ;
                      db $C8,$A6                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03A09B:          db $45,$05                          ;; 03A09B               ;
                                                          ;;                      ;
CODE_03A09D:          LDA.W !SpriteMisc1602,X             ;; 03A09D : BD 02 16    ;
                      ASL A                               ;; 03A0A0 : 0A          ;
                      ASL A                               ;; 03A0A1 : 0A          ;
                      ADC.W !SpriteMisc1602,X             ;; 03A0A2 : 7D 02 16    ;
                      STA.B !_3                           ;; 03A0A5 : 85 03       ;
                      LDA.W !SpriteMisc157C,X             ;; 03A0A7 : BD 7C 15    ;
                      STA.B !_2                           ;; 03A0AA : 85 02       ;
                      PHX                                 ;; 03A0AC : DA          ;
                      LDX.B #$04                          ;; 03A0AD : A2 04       ;
CODE_03A0AF:          PHX                                 ;; 03A0AF : DA          ;
                      PHX                                 ;; 03A0B0 : DA          ;
                      LDA.B !_1                           ;; 03A0B1 : A5 01       ;
                      CLC                                 ;; 03A0B3 : 18          ;
                      ADC.W DATA_03A08C,X                 ;; 03A0B4 : 7D 8C A0    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03A0B7 : 99 01 03    ;
                      LDA.B !_2                           ;; 03A0BA : A5 02       ;
                      BNE CODE_03A0C3                     ;; 03A0BC : D0 05       ;
                      TXA                                 ;; 03A0BE : 8A          ;
                      CLC                                 ;; 03A0BF : 18          ;
                      ADC.B #$05                          ;; 03A0C0 : 69 05       ;
                      TAX                                 ;; 03A0C2 : AA          ;
CODE_03A0C3:          LDA.B !_0                           ;; 03A0C3 : A5 00       ;
                      CLC                                 ;; 03A0C5 : 18          ;
                      ADC.W DATA_03A082,X                 ;; 03A0C6 : 7D 82 A0    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03A0C9 : 99 00 03    ;
                      PLA                                 ;; 03A0CC : 68          ;
                      CLC                                 ;; 03A0CD : 18          ;
                      ADC.B !_3                           ;; 03A0CE : 65 03       ;
                      TAX                                 ;; 03A0D0 : AA          ;
                      LDA.W BlarggTilemap,X               ;; 03A0D1 : BD 91 A0    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03A0D4 : 99 02 03    ;
                      LDX.B !_2                           ;; 03A0D7 : A6 02       ;
                      LDA.W DATA_03A09B,X                 ;; 03A0D9 : BD 9B A0    ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03A0DC : 99 03 03    ;
                      PLX                                 ;; 03A0DF : FA          ;
                      INY                                 ;; 03A0E0 : C8          ;
                      INY                                 ;; 03A0E1 : C8          ;
                      INY                                 ;; 03A0E2 : C8          ;
                      INY                                 ;; 03A0E3 : C8          ;
                      DEX                                 ;; 03A0E4 : CA          ;
                      BPL CODE_03A0AF                     ;; 03A0E5 : 10 C8       ;
                      PLX                                 ;; 03A0E7 : FA          ;
                      LDY.B #$02                          ;; 03A0E8 : A0 02       ;
                      LDA.B #$04                          ;; 03A0EA : A9 04       ;
                      JSL FinishOAMWrite                  ;; 03A0EC : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A0F1:          JSL InitSpriteTables                ;; 03A0F1 : 22 D2 F7 07 ;
                      STZ.W !SpriteOffscreenX,X           ;; 03A0F5 : 9E A0 15    ;
                      LDA.B #$80                          ;; 03A0F8 : A9 80       ;
                      STA.B !SpriteYPosLow,X              ;; 03A0FA : 95 D8       ;
                      LDA.B #$FF                          ;; 03A0FC : A9 FF       ;
                      STA.W !SpriteXPosHigh,X             ;; 03A0FE : 9D D4 14    ;
                      LDA.B #$D0                          ;; 03A101 : A9 D0       ;
                      STA.B !SpriteXPosLow,X              ;; 03A103 : 95 E4       ;
                      LDA.B #$00                          ;; 03A105 : A9 00       ;
                      STA.W !SpriteYPosHigh,X             ;; 03A107 : 9D E0 14    ;
                      LDA.B #$02                          ;; 03A10A : A9 02       ;
                      STA.W !SpriteMisc187B,X             ;; 03A10C : 9D 7B 18    ;
                      LDA.B #$03                          ;; 03A10F : A9 03       ;
                      STA.B !SpriteTableC2,X              ;; 03A111 : 95 C2       ;
                      JSL CODE_03DD7D                     ;; 03A113 : 22 7D DD 03 ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
Bnk3CallSprMain:      PHB                                 ;; ?QPWZ? : 8B          ;
                      PHK                                 ;; 03A119 : 4B          ;
                      PLB                                 ;; 03A11A : AB          ;
                      LDA.B !SpriteNumber,X               ;; 03A11B : B5 9E       ;
                      CMP.B #$C8                          ;; 03A11D : C9 C8       ;
                      BNE CODE_03A126                     ;; 03A11F : D0 05       ;
                      JSR LightSwitch                     ;; 03A121 : 20 F5 C1    ;
                      PLB                                 ;; 03A124 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A126:          CMP.B #$C7                          ;; 03A126 : C9 C7       ;
                      BNE CODE_03A12F                     ;; 03A128 : D0 05       ;
                      JSR InvisMushroom                   ;; 03A12A : 20 0F C3    ;
                      PLB                                 ;; 03A12D : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A12F:          CMP.B #$51                          ;; 03A12F : C9 51       ;
                      BNE CODE_03A138                     ;; 03A131 : D0 05       ;
                      JSR Ninji                           ;; 03A133 : 20 4C C3    ;
                      PLB                                 ;; 03A136 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A138:          CMP.B #$1B                          ;; 03A138 : C9 1B       ;
                      BNE CODE_03A141                     ;; 03A13A : D0 05       ;
                      JSR Football                        ;; 03A13C : 20 12 80    ;
                      PLB                                 ;; 03A13F : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A141:          CMP.B #$C6                          ;; 03A141 : C9 C6       ;
                      BNE CODE_03A14A                     ;; 03A143 : D0 05       ;
                      JSR DarkRoomWithLight               ;; 03A145 : 20 DC C4    ;
                      PLB                                 ;; 03A148 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A14A:          CMP.B #$7A                          ;; 03A14A : C9 7A       ;
                      BNE CODE_03A153                     ;; 03A14C : D0 05       ;
                      JSR Firework                        ;; 03A14E : 20 16 C8    ;
                      PLB                                 ;; 03A151 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A153:          CMP.B #$7C                          ;; 03A153 : C9 7C       ;
                      BNE CODE_03A15C                     ;; 03A155 : D0 05       ;
                      JSR PrincessPeach                   ;; 03A157 : 20 97 AC    ;
                      PLB                                 ;; 03A15A : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A15C:          CMP.B #$C5                          ;; 03A15C : C9 C5       ;
                      BNE CODE_03A165                     ;; 03A15E : D0 05       ;
                      JSR BigBooBoss                      ;; 03A160 : 20 87 80    ;
                      PLB                                 ;; 03A163 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A165:          CMP.B #$C4                          ;; 03A165 : C9 C4       ;
                      BNE CODE_03A16E                     ;; 03A167 : D0 05       ;
                      JSR GreyFallingPlat                 ;; 03A169 : 20 54 84    ;
                      PLB                                 ;; 03A16C : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A16E:          CMP.B #$C2                          ;; 03A16E : C9 C2       ;
                      BNE CODE_03A177                     ;; 03A170 : D0 05       ;
                      JSR Blurp                           ;; 03A172 : 20 CA 84    ;
                      PLB                                 ;; 03A175 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A177:          CMP.B #$C3                          ;; 03A177 : C9 C3       ;
                      BNE CODE_03A180                     ;; 03A179 : D0 05       ;
                      JSR PorcuPuffer                     ;; 03A17B : 20 2F 85    ;
                      PLB                                 ;; 03A17E : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A180:          CMP.B #$C1                          ;; 03A180 : C9 C1       ;
                      BNE CODE_03A189                     ;; 03A182 : D0 05       ;
                      JSR FlyingTurnBlocks                ;; 03A184 : 20 F6 85    ;
                      PLB                                 ;; 03A187 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A189:          CMP.B #$C0                          ;; 03A189 : C9 C0       ;
                      BNE CODE_03A192                     ;; 03A18B : D0 05       ;
                      JSR GrayLavaPlatform                ;; 03A18D : 20 FF 86    ;
                      PLB                                 ;; 03A190 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A192:          CMP.B #$BF                          ;; 03A192 : C9 BF       ;
                      BNE CODE_03A19B                     ;; 03A194 : D0 05       ;
                      JSR MegaMole                        ;; 03A196 : 20 70 87    ;
                      PLB                                 ;; 03A199 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A19B:          CMP.B #$BE                          ;; 03A19B : C9 BE       ;
                      BNE CODE_03A1A4                     ;; 03A19D : D0 05       ;
                      JSR Swooper                         ;; 03A19F : 20 A3 88    ;
                      PLB                                 ;; 03A1A2 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1A4:          CMP.B #$BD                          ;; 03A1A4 : C9 BD       ;
                      BNE CODE_03A1AD                     ;; 03A1A6 : D0 05       ;
                      JSR SlidingKoopa                    ;; 03A1A8 : 20 58 89    ;
                      PLB                                 ;; 03A1AB : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1AD:          CMP.B #$BC                          ;; 03A1AD : C9 BC       ;
                      BNE CODE_03A1B6                     ;; 03A1AF : D0 05       ;
                      JSR BowserStatue                    ;; 03A1B1 : 20 3C 8A    ;
                      PLB                                 ;; 03A1B4 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1B6:          CMP.B #$B8                          ;; 03A1B6 : C9 B8       ;
                      BEQ CODE_03A1BE                     ;; 03A1B8 : F0 04       ;
                      CMP.B #$B7                          ;; 03A1BA : C9 B7       ;
                      BNE CODE_03A1C3                     ;; 03A1BC : D0 05       ;
CODE_03A1BE:          JSR CarrotTopLift                   ;; 03A1BE : 20 2F 8C    ;
                      PLB                                 ;; 03A1C1 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1C3:          CMP.B #$B9                          ;; 03A1C3 : C9 B9       ;
                      BNE CODE_03A1CC                     ;; 03A1C5 : D0 05       ;
                      JSR InfoBox                         ;; 03A1C7 : 20 6F 8D    ;
                      PLB                                 ;; 03A1CA : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1CC:          CMP.B #$BA                          ;; 03A1CC : C9 BA       ;
                      BNE CODE_03A1D5                     ;; 03A1CE : D0 05       ;
                      JSR TimedLift                       ;; 03A1D0 : 20 BB 8D    ;
                      PLB                                 ;; 03A1D3 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1D5:          CMP.B #$BB                          ;; 03A1D5 : C9 BB       ;
                      BNE CODE_03A1DE                     ;; 03A1D7 : D0 05       ;
                      JSR GreyCastleBlock                 ;; 03A1D9 : 20 79 8E    ;
                      PLB                                 ;; 03A1DC : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1DE:          CMP.B #$B3                          ;; 03A1DE : C9 B3       ;
                      BNE CODE_03A1E7                     ;; 03A1E0 : D0 05       ;
                      JSR StatueFireball                  ;; 03A1E2 : 20 EC 8E    ;
                      PLB                                 ;; 03A1E5 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1E7:          LDA.B !SpriteNumber,X               ;; 03A1E7 : B5 9E       ;
                      CMP.B #$B2                          ;; 03A1E9 : C9 B2       ;
                      BNE CODE_03A1F2                     ;; 03A1EB : D0 05       ;
                      JSR FallingSpike                    ;; 03A1ED : 20 14 92    ;
                      PLB                                 ;; 03A1F0 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1F2:          CMP.B #$AE                          ;; 03A1F2 : C9 AE       ;
                      BNE CODE_03A1FB                     ;; 03A1F4 : D0 05       ;
                      JSR FishinBoo                       ;; 03A1F6 : 20 65 90    ;
                      PLB                                 ;; 03A1F9 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A1FB:          CMP.B #$B6                          ;; 03A1FB : C9 B6       ;
                      BNE CODE_03A204                     ;; 03A1FD : D0 05       ;
                      JSR ReflectingFireball              ;; 03A1FF : 20 75 8F    ;
                      PLB                                 ;; 03A202 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A204:          CMP.B #$B0                          ;; 03A204 : C9 B0       ;
                      BNE CODE_03A20D                     ;; 03A206 : D0 05       ;
                      JSR BooStream                       ;; 03A208 : 20 7A 8F    ;
                      PLB                                 ;; 03A20B : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A20D:          CMP.B #$B1                          ;; 03A20D : C9 B1       ;
                      BNE CODE_03A216                     ;; 03A20F : D0 05       ;
                      JSR CreateEatBlock                  ;; 03A211 : 20 84 92    ;
                      PLB                                 ;; 03A214 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A216:          CMP.B #$AC                          ;; 03A216 : C9 AC       ;
                      BEQ CODE_03A21E                     ;; 03A218 : F0 04       ;
                      CMP.B #$AD                          ;; 03A21A : C9 AD       ;
                      BNE CODE_03A223                     ;; 03A21C : D0 05       ;
CODE_03A21E:          JSR WoodenSpike                     ;; 03A21E : 20 23 94    ;
                      PLB                                 ;; 03A221 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A223:          CMP.B #$AB                          ;; 03A223 : C9 AB       ;
                      BNE CODE_03A22C                     ;; 03A225 : D0 05       ;
                      JSR RexMainRt                       ;; 03A227 : 20 17 95    ;
                      PLB                                 ;; 03A22A : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A22C:          CMP.B #$AA                          ;; 03A22C : C9 AA       ;
                      BNE CODE_03A235                     ;; 03A22E : D0 05       ;
                      JSR Fishbone                        ;; 03A230 : 20 F6 96    ;
                      PLB                                 ;; 03A233 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A235:          CMP.B #$A9                          ;; 03A235 : C9 A9       ;
                      BNE CODE_03A23E                     ;; 03A237 : D0 05       ;
                      JSR Reznor                          ;; 03A239 : 20 90 98    ;
                      PLB                                 ;; 03A23C : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A23E:          CMP.B #$A8                          ;; 03A23E : C9 A8       ;
                      BNE CODE_03A247                     ;; 03A240 : D0 05       ;
                      JSR Blargg                          ;; 03A242 : 20 38 9F    ;
                      PLB                                 ;; 03A245 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A247:          CMP.B #$A1                          ;; 03A247 : C9 A1       ;
                      BNE CODE_03A250                     ;; 03A249 : D0 05       ;
                      JSR BowserBowlingBall               ;; 03A24B : 20 63 B1    ;
                      PLB                                 ;; 03A24E : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03A250:          CMP.B #$A2                          ;; 03A250 : C9 A2       ;
                      BNE BowserFight                     ;; 03A252 : D0 05       ;
                      JSR MechaKoopa                      ;; 03A254 : 20 A9 B2    ;
                      PLB                                 ;; 03A257 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
BowserFight:          JSL CODE_03DFCC                     ;; ?QPWZ? : 22 CC DF 03 ;
                      JSR CODE_03A279                     ;; 03A25D : 20 79 A2    ;
                      JSR CODE_03B43C                     ;; 03A260 : 20 3C B4    ;
                      PLB                                 ;; 03A263 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A265:          db $04,$03,$02,$01,$00,$01,$02,$03  ;; 03A265               ;
                      db $04,$05,$06,$07,$07,$07,$07,$07  ;; ?QPWZ?               ;
                      db $07,$07,$07,$07                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A279:          LDA.B !Mode7XScale                  ;; 03A279 : A5 38       ;
                      LSR A                               ;; 03A27B : 4A          ;
                      LSR A                               ;; 03A27C : 4A          ;
                      LSR A                               ;; 03A27D : 4A          ;
                      TAY                                 ;; 03A27E : A8          ;
                      LDA.W DATA_03A265,Y                 ;; 03A27F : B9 65 A2    ;
                      STA.W !BowserPalette                ;; 03A282 : 8D 29 14    ;
                      LDA.W !SpriteMisc1570,X             ;; 03A285 : BD 70 15    ;
                      CLC                                 ;; 03A288 : 18          ;
                      ADC.B #$1E                          ;; 03A289 : 69 1E       ;
                      ORA.W !SpriteMisc157C,X             ;; 03A28B : 1D 7C 15    ;
                      STA.W !Mode7TileIndex               ;; 03A28E : 8D A2 1B    ;
                      LDA.B !EffFrame                     ;; 03A291 : A5 14       ;
                      LSR A                               ;; 03A293 : 4A          ;
                      AND.B #$03                          ;; 03A294 : 29 03       ;
                      STA.W !ClownCarPropeller            ;; 03A296 : 8D 28 14    ;
                      LDA.B #$90                          ;; 03A299 : A9 90       ;
                      STA.B !Mode7CenterX                 ;; 03A29B : 85 2A       ;
                      LDA.B #$C8                          ;; 03A29D : A9 C8       ;
                      STA.B !Mode7CenterY                 ;; 03A29F : 85 2C       ;
                      JSL CODE_03DEDF                     ;; 03A2A1 : 22 DF DE 03 ;
                      LDA.W !BrSwingXDist+1               ;; 03A2A5 : AD B5 14    ;
                      BEQ CODE_03A2AD                     ;; 03A2A8 : F0 03       ;
                      JSR CODE_03AF59                     ;; 03A2AA : 20 59 AF    ;
CODE_03A2AD:          LDA.W !SpriteMisc1564,X             ;; 03A2AD : BD 64 15    ;
                      BEQ CODE_03A2B5                     ;; 03A2B0 : F0 03       ;
                      JSR CODE_03A3E2                     ;; 03A2B2 : 20 E2 A3    ;
CODE_03A2B5:          LDA.W !SpriteMisc1594,X             ;; 03A2B5 : BD 94 15    ;
                      BEQ CODE_03A2CE                     ;; 03A2B8 : F0 14       ;
                      DEC A                               ;; 03A2BA : 3A          ;
                      LSR A                               ;; 03A2BB : 4A          ;
                      LSR A                               ;; 03A2BC : 4A          ;
                      PHA                                 ;; 03A2BD : 48          ;
                      LSR A                               ;; 03A2BE : 4A          ;
                      TAY                                 ;; 03A2BF : A8          ;
                      LDA.W DATA_03A8BE,Y                 ;; 03A2C0 : B9 BE A8    ;
                      STA.B !_2                           ;; 03A2C3 : 85 02       ;
                      PLA                                 ;; 03A2C5 : 68          ;
                      AND.B #$03                          ;; 03A2C6 : 29 03       ;
                      STA.B !_3                           ;; 03A2C8 : 85 03       ;
                      JSR CODE_03AA6E                     ;; 03A2CA : 20 6E AA    ;
                      NOP                                 ;; 03A2CD : EA          ;
CODE_03A2CE:          LDA.B !SpriteLock                   ;; 03A2CE : A5 9D       ;
                      BNE Return03A340                    ;; 03A2D0 : D0 6E       ;
                      STZ.W !SpriteMisc1594,X             ;; 03A2D2 : 9E 94 15    ;
                      LDA.B #$30                          ;; 03A2D5 : A9 30       ;
                      STA.B !SpriteProperties             ;; 03A2D7 : 85 64       ;
                      LDA.B !Mode7XScale                  ;; 03A2D9 : A5 38       ;
                      CMP.B #$20                          ;; 03A2DB : C9 20       ;
                      BCS CODE_03A2E1                     ;; 03A2DD : B0 02       ;
                      STZ.B !SpriteProperties             ;; 03A2DF : 64 64       ;
CODE_03A2E1:          JSR CODE_03A661                     ;; 03A2E1 : 20 61 A6    ;
                      LDA.W !BrSwingCenterXPos            ;; 03A2E4 : AD B0 14    ;
                      BEQ CODE_03A2F2                     ;; 03A2E7 : F0 09       ;
                      LDA.B !TrueFrame                    ;; 03A2E9 : A5 13       ;
                      AND.B #$03                          ;; 03A2EB : 29 03       ;
                      BNE CODE_03A2F2                     ;; 03A2ED : D0 03       ;
                      DEC.W !BrSwingCenterXPos            ;; 03A2EF : CE B0 14    ;
CODE_03A2F2:          LDA.B !TrueFrame                    ;; 03A2F2 : A5 13       ;
                      AND.B #$7F                          ;; 03A2F4 : 29 7F       ;
                      BNE CODE_03A305                     ;; 03A2F6 : D0 0D       ;
                      JSL GetRand                         ;; 03A2F8 : 22 F9 AC 01 ;
                      AND.B #$01                          ;; 03A2FC : 29 01       ;
                      BNE CODE_03A305                     ;; 03A2FE : D0 05       ;
                      LDA.B #$0C                          ;; 03A300 : A9 0C       ;
                      STA.W !SpriteMisc1558,X             ;; 03A302 : 9D 58 15    ;
CODE_03A305:          JSR CODE_03B078                     ;; 03A305 : 20 78 B0    ;
                      LDA.W !SpriteMisc151C,X             ;; 03A308 : BD 1C 15    ;
                      CMP.B #$09                          ;; 03A30B : C9 09       ;
                      BEQ CODE_03A31A                     ;; 03A30D : F0 0B       ;
                      STZ.W !ClownCarImage                ;; 03A30F : 9C 27 14    ;
                      LDA.W !SpriteMisc1558,X             ;; 03A312 : BD 58 15    ;
                      BEQ CODE_03A31A                     ;; 03A315 : F0 03       ;
                      INC.W !ClownCarImage                ;; 03A317 : EE 27 14    ;
CODE_03A31A:          JSR CODE_03A5AD                     ;; 03A31A : 20 AD A5    ;
                      JSL UpdateXPosNoGvtyW               ;; 03A31D : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 03A321 : 22 1A 80 01 ;
                      LDA.W !SpriteMisc151C,X             ;; 03A325 : BD 1C 15    ;
                      JSL ExecutePtr                      ;; 03A328 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03A441                      ;; ?QPWZ? : 41 A4       ;
                      dw CODE_03A6F8                      ;; ?QPWZ? : F8 A6       ;
                      dw CODE_03A84B                      ;; ?QPWZ? : 4B A8       ;
                      dw CODE_03A7AD                      ;; ?QPWZ? : AD A7       ;
                      dw CODE_03AB9F                      ;; ?QPWZ? : 9F AB       ;
                      dw CODE_03ABBE                      ;; ?QPWZ? : BE AB       ;
                      dw CODE_03AC03                      ;; ?QPWZ? : 03 AC       ;
                      dw CODE_03A49C                      ;; ?QPWZ? : 9C A4       ;
                      dw CODE_03AB21                      ;; ?QPWZ? : 21 AB       ;
                      dw CODE_03AB64                      ;; ?QPWZ? : 64 AB       ;
                                                          ;;                      ;
Return03A340:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A341:          db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B  ;; 03A341               ;
                      db $D5,$DD,$23,$2B,$D5,$DD,$23,$2B  ;; ?QPWZ?               ;
                      db $D6,$DE,$22,$2A,$D6,$DE,$22,$2A  ;; ?QPWZ?               ;
                      db $D7,$DF,$21,$29,$D7,$DF,$21,$29  ;; ?QPWZ?               ;
                      db $D8,$E0,$20,$28,$D8,$E0,$20,$28  ;; ?QPWZ?               ;
                      db $DA,$E2,$1E,$26,$DA,$E2,$1E,$26  ;; ?QPWZ?               ;
                      db $DC,$E4,$1C,$24,$DC,$E4,$1C,$24  ;; ?QPWZ?               ;
                      db $E0,$E8,$18,$20,$E0,$E8,$18,$20  ;; ?QPWZ?               ;
                      db $E8,$F0,$10,$18,$E8,$F0,$10,$18  ;; ?QPWZ?               ;
DATA_03A389:          db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23  ;; 03A389               ;
                      db $DD,$D5,$D5,$DD,$23,$2B,$2B,$23  ;; ?QPWZ?               ;
                      db $DE,$D6,$D6,$DE,$22,$2A,$2A,$22  ;; ?QPWZ?               ;
                      db $DF,$D7,$D7,$DF,$21,$29,$29,$21  ;; ?QPWZ?               ;
                      db $E0,$D8,$D8,$E0,$20,$28,$28,$20  ;; ?QPWZ?               ;
                      db $E2,$DA,$DA,$E2,$1E,$26,$26,$1E  ;; ?QPWZ?               ;
                      db $E4,$DC,$DC,$E4,$1C,$24,$24,$1C  ;; ?QPWZ?               ;
                      db $E8,$E0,$E0,$E8,$18,$20,$20,$18  ;; ?QPWZ?               ;
                      db $F0,$E8,$E8,$F0,$10,$18,$18,$10  ;; ?QPWZ?               ;
DATA_03A3D1:          db $80,$40,$00,$C0,$00,$C0,$80,$40  ;; 03A3D1               ;
DATA_03A3D9:          db $E3,$ED,$ED,$EB,$EB,$E9,$E9,$E7  ;; 03A3D9               ;
                      db $E7                              ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A3E2:          JSR GetDrawInfoBnk3                 ;; 03A3E2 : 20 60 B7    ;
                      LDA.W !SpriteMisc1564,X             ;; 03A3E5 : BD 64 15    ;
                      DEC A                               ;; 03A3E8 : 3A          ;
                      LSR A                               ;; 03A3E9 : 4A          ;
                      STA.B !_3                           ;; 03A3EA : 85 03       ;
                      ASL A                               ;; 03A3EC : 0A          ;
                      ASL A                               ;; 03A3ED : 0A          ;
                      ASL A                               ;; 03A3EE : 0A          ;
                      STA.B !_2                           ;; 03A3EF : 85 02       ;
                      LDA.B #$70                          ;; 03A3F1 : A9 70       ;
                      STA.W !SpriteOAMIndex,X             ;; 03A3F3 : 9D EA 15    ;
                      TAY                                 ;; 03A3F6 : A8          ;
                      PHX                                 ;; 03A3F7 : DA          ;
                      LDX.B #$07                          ;; 03A3F8 : A2 07       ;
CODE_03A3FA:          PHX                                 ;; 03A3FA : DA          ;
                      TXA                                 ;; 03A3FB : 8A          ;
                      ORA.B !_2                           ;; 03A3FC : 05 02       ;
                      TAX                                 ;; 03A3FE : AA          ;
                      LDA.B !_0                           ;; 03A3FF : A5 00       ;
                      CLC                                 ;; 03A401 : 18          ;
                      ADC.W DATA_03A341,X                 ;; 03A402 : 7D 41 A3    ;
                      CLC                                 ;; 03A405 : 18          ;
                      ADC.B #$08                          ;; 03A406 : 69 08       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03A408 : 99 00 03    ;
                      LDA.B !_1                           ;; 03A40B : A5 01       ;
                      CLC                                 ;; 03A40D : 18          ;
                      ADC.W DATA_03A389,X                 ;; 03A40E : 7D 89 A3    ;
                      CLC                                 ;; 03A411 : 18          ;
                      ADC.B #$30                          ;; 03A412 : 69 30       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03A414 : 99 01 03    ;
                      LDX.B !_3                           ;; 03A417 : A6 03       ;
                      LDA.W DATA_03A3D9,X                 ;; 03A419 : BD D9 A3    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03A41C : 99 02 03    ;
                      PLX                                 ;; 03A41F : FA          ;
                      LDA.W DATA_03A3D1,X                 ;; 03A420 : BD D1 A3    ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03A423 : 99 03 03    ;
                      INY                                 ;; 03A426 : C8          ;
                      INY                                 ;; 03A427 : C8          ;
                      INY                                 ;; 03A428 : C8          ;
                      INY                                 ;; 03A429 : C8          ;
                      DEX                                 ;; 03A42A : CA          ;
                      BPL CODE_03A3FA                     ;; 03A42B : 10 CD       ;
                      PLX                                 ;; 03A42D : FA          ;
                      LDY.B #$02                          ;; 03A42E : A0 02       ;
                      LDA.B #$07                          ;; 03A430 : A9 07       ;
                      JSL FinishOAMWrite                  ;; 03A432 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A437:          db $00,$00,$00,$00,$02,$04,$06,$08  ;; 03A437               ;
                      db $0A,$0E                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A441:          LDA.W !SpriteMisc154C,X             ;; 03A441 : BD 4C 15    ;
                      BNE CODE_03A482                     ;; 03A444 : D0 3C       ;
                      LDA.W !SpriteMisc1540,X             ;; 03A446 : BD 40 15    ;
                      BNE CODE_03A465                     ;; 03A449 : D0 1A       ;
                      LDA.B #$0E                          ;; 03A44B : A9 0E       ;
                      STA.W !SpriteMisc1570,X             ;; 03A44D : 9D 70 15    ;
                      LDA.B #$04                          ;; 03A450 : A9 04       ;
                      STA.B !SpriteYSpeed,X               ;; 03A452 : 95 AA       ;
                      STZ.B !SpriteXSpeed,X               ;; 03A454 : 74 B6       ; Sprite X Speed = 0 
                      LDA.B !SpriteYPosLow,X              ;; 03A456 : B5 D8       ;
                      SEC                                 ;; 03A458 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03A459 : E5 1C       ;
                      CMP.B #$10                          ;; 03A45B : C9 10       ;
                      BNE Return03A464                    ;; 03A45D : D0 05       ;
                      LDA.B #$A4                          ;; 03A45F : A9 A4       ;
                      STA.W !SpriteMisc1540,X             ;; 03A461 : 9D 40 15    ;
Return03A464:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A465:          STZ.B !SpriteYSpeed,X               ;; 03A465 : 74 AA       ; Sprite Y Speed = 0 
                      STZ.B !SpriteXSpeed,X               ;; 03A467 : 74 B6       ; Sprite X Speed = 0 
                      CMP.B #$01                          ;; 03A469 : C9 01       ;
                      BEQ CODE_03A47C                     ;; 03A46B : F0 0F       ;
                      CMP.B #$40                          ;; 03A46D : C9 40       ;
                      BCS Return03A47B                    ;; 03A46F : B0 0A       ;
                      LSR A                               ;; 03A471 : 4A          ;
                      LSR A                               ;; 03A472 : 4A          ;
                      LSR A                               ;; 03A473 : 4A          ;
                      TAY                                 ;; 03A474 : A8          ;
                      LDA.W DATA_03A437,Y                 ;; 03A475 : B9 37 A4    ;
                      STA.W !SpriteMisc1570,X             ;; 03A478 : 9D 70 15    ;
Return03A47B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A47C:          LDA.B #$24                          ;; 03A47C : A9 24       ;
                      STA.W !SpriteMisc154C,X             ;; 03A47E : 9D 4C 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A482:          DEC A                               ;; 03A482 : 3A          ;
                      BNE Return03A48F                    ;; 03A483 : D0 0A       ;
                      LDA.B #$07                          ;; 03A485 : A9 07       ;
                      STA.W !SpriteMisc151C,X             ;; 03A487 : 9D 1C 15    ;
                      LDA.B #$78                          ;; 03A48A : A9 78       ;
                      STA.W !BrSwingCenterXPos            ;; 03A48C : 8D B0 14    ;
Return03A48F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A490:          db $FF,$01                          ;; 03A490               ;
                                                          ;;                      ;
DATA_03A492:          db $C8,$38                          ;; 03A492               ;
                                                          ;;                      ;
DATA_03A494:          db $01,$FF                          ;; 03A494               ;
                                                          ;;                      ;
DATA_03A496:          db $1C,$E4                          ;; 03A496               ;
                                                          ;;                      ;
DATA_03A498:          db $00,$02,$04,$02                  ;; 03A498               ;
                                                          ;;                      ;
CODE_03A49C:          JSR CODE_03A4D2                     ;; 03A49C : 20 D2 A4    ;
                      JSR CODE_03A4FD                     ;; 03A49F : 20 FD A4    ;
                      JSR CODE_03A4ED                     ;; 03A4A2 : 20 ED A4    ;
                      LDA.W !SpriteMisc1528,X             ;; 03A4A5 : BD 28 15    ;
                      AND.B #$01                          ;; 03A4A8 : 29 01       ;
                      TAY                                 ;; 03A4AA : A8          ;
                      LDA.B !SpriteXSpeed,X               ;; 03A4AB : B5 B6       ;
                      CLC                                 ;; 03A4AD : 18          ;
                      ADC.W DATA_03A490,Y                 ;; 03A4AE : 79 90 A4    ;
                      STA.B !SpriteXSpeed,X               ;; 03A4B1 : 95 B6       ;
                      CMP.W DATA_03A492,Y                 ;; 03A4B3 : D9 92 A4    ;
                      BNE CODE_03A4BB                     ;; 03A4B6 : D0 03       ;
                      INC.W !SpriteMisc1528,X             ;; 03A4B8 : FE 28 15    ;
CODE_03A4BB:          LDA.W !SpriteMisc1534,X             ;; 03A4BB : BD 34 15    ;
                      AND.B #$01                          ;; 03A4BE : 29 01       ;
                      TAY                                 ;; 03A4C0 : A8          ;
                      LDA.B !SpriteYSpeed,X               ;; 03A4C1 : B5 AA       ;
                      CLC                                 ;; 03A4C3 : 18          ;
                      ADC.W DATA_03A494,Y                 ;; 03A4C4 : 79 94 A4    ;
                      STA.B !SpriteYSpeed,X               ;; 03A4C7 : 95 AA       ;
                      CMP.W DATA_03A496,Y                 ;; 03A4C9 : D9 96 A4    ;
                      BNE Return03A4D1                    ;; 03A4CC : D0 03       ;
                      INC.W !SpriteMisc1534,X             ;; 03A4CE : FE 34 15    ;
Return03A4D1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A4D2:          LDY.B #$00                          ;; 03A4D2 : A0 00       ;
                      LDA.B !TrueFrame                    ;; 03A4D4 : A5 13       ;
                      AND.B #$E0                          ;; 03A4D6 : 29 E0       ;
                      BNE CODE_03A4E6                     ;; 03A4D8 : D0 0C       ;
                      LDA.B !TrueFrame                    ;; 03A4DA : A5 13       ;
                      AND.B #$18                          ;; 03A4DC : 29 18       ;
                      LSR A                               ;; 03A4DE : 4A          ;
                      LSR A                               ;; 03A4DF : 4A          ;
                      LSR A                               ;; 03A4E0 : 4A          ;
                      TAY                                 ;; 03A4E1 : A8          ;
                      LDA.W DATA_03A498,Y                 ;; 03A4E2 : B9 98 A4    ;
                      TAY                                 ;; 03A4E5 : A8          ;
CODE_03A4E6:          TYA                                 ;; 03A4E6 : 98          ;
                      STA.W !SpriteMisc1570,X             ;; 03A4E7 : 9D 70 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A4EB:          db $80,$00                          ;; 03A4EB               ;
                                                          ;;                      ;
CODE_03A4ED:          LDA.B !TrueFrame                    ;; 03A4ED : A5 13       ;
                      AND.B #$1F                          ;; 03A4EF : 29 1F       ;
                      BNE Return03A4FC                    ;; 03A4F1 : D0 09       ;
                      JSR SubHorzPosBnk3                  ;; 03A4F3 : 20 17 B8    ;
                      LDA.W DATA_03A4EB,Y                 ;; 03A4F6 : B9 EB A4    ;
                      STA.W !SpriteMisc157C,X             ;; 03A4F9 : 9D 7C 15    ;
Return03A4FC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A4FD:          LDA.W !BrSwingCenterXPos            ;; 03A4FD : AD B0 14    ;
                      BNE Return03A52C                    ;; 03A500 : D0 2A       ;
                      LDA.W !SpriteMisc151C,X             ;; 03A502 : BD 1C 15    ;
                      CMP.B #$08                          ;; 03A505 : C9 08       ;
                      BNE CODE_03A51A                     ;; 03A507 : D0 11       ;
                      INC.W !BrSwingPlatXPos              ;; 03A509 : EE B8 14    ;
                      LDA.W !BrSwingPlatXPos              ;; 03A50C : AD B8 14    ;
                      CMP.B #$03                          ;; 03A50F : C9 03       ;
                      BEQ CODE_03A51A                     ;; 03A511 : F0 07       ;
                      LDA.B #$FF                          ;; 03A513 : A9 FF       ;
                      STA.W !BrSwingYDist                 ;; 03A515 : 8D B6 14    ;
                      BRA Return03A52C                    ;; 03A518 : 80 12       ;
                                                          ;;                      ;
CODE_03A51A:          STZ.W !BrSwingPlatXPos              ;; 03A51A : 9C B8 14    ;
                      LDA.W !SpriteStatus                 ;; 03A51D : AD C8 14    ;
                      BEQ CODE_03A527                     ;; 03A520 : F0 05       ;
                      LDA.W !SpriteStatus+1               ;; 03A522 : AD C9 14    ;
                      BNE Return03A52C                    ;; 03A525 : D0 05       ;
CODE_03A527:          LDA.B #$FF                          ;; 03A527 : A9 FF       ;
                      STA.W !BrSwingCenterXPos+1          ;; 03A529 : 8D B1 14    ;
Return03A52C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A52D:          db $00,$00,$00,$00,$00,$00,$00,$00  ;; 03A52D               ;
                      db $00,$02,$04,$06,$08,$0A,$0E,$0E  ;; ?QPWZ?               ;
                      db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E  ;; ?QPWZ?               ;
                      db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E  ;; ?QPWZ?               ;
                      db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E  ;; ?QPWZ?               ;
                      db $0E,$0E,$0A,$08,$06,$04,$02,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
DATA_03A56D:          db $00,$00,$00,$00,$00,$00,$00,$00  ;; 03A56D               ;
                      db $00,$00,$10,$20,$30,$40,$50,$60  ;; ?QPWZ?               ;
                      db $80,$A0,$C0,$E0,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$C0,$80,$60  ;; ?QPWZ?               ;
                      db $40,$30,$20,$10,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A5AD:          LDA.W !BrSwingCenterXPos+1          ;; 03A5AD : AD B1 14    ;
                      BEQ CODE_03A5D8                     ;; 03A5B0 : F0 26       ;
                      DEC.W !BrSwingCenterXPos+1          ;; 03A5B2 : CE B1 14    ;
                      BNE CODE_03A5BD                     ;; 03A5B5 : D0 06       ;
                      LDA.B #$54                          ;; 03A5B7 : A9 54       ;
                      STA.W !BrSwingCenterXPos            ;; 03A5B9 : 8D B0 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A5BD:          LSR A                               ;; 03A5BD : 4A          ;
                      LSR A                               ;; 03A5BE : 4A          ;
                      TAY                                 ;; 03A5BF : A8          ;
                      LDA.W DATA_03A52D,Y                 ;; 03A5C0 : B9 2D A5    ;
                      STA.W !SpriteMisc1570,X             ;; 03A5C3 : 9D 70 15    ;
                      LDA.W !BrSwingCenterXPos+1          ;; 03A5C6 : AD B1 14    ;
                      CMP.B #$80                          ;; 03A5C9 : C9 80       ;
                      BNE CODE_03A5D5                     ;; 03A5CB : D0 08       ;
                      JSR CODE_03B019                     ;; 03A5CD : 20 19 B0    ;
                      LDA.B #$08                          ;; 03A5D0 : A9 08       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03A5D2 : 8D FC 1D    ; / 
CODE_03A5D5:          PLA                                 ;; 03A5D5 : 68          ;
                      PLA                                 ;; 03A5D6 : 68          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A5D8:          LDA.W !BrSwingYDist                 ;; 03A5D8 : AD B6 14    ;
                      BEQ Return03A60D                    ;; 03A5DB : F0 30       ;
                      DEC.W !BrSwingYDist                 ;; 03A5DD : CE B6 14    ;
                      BEQ CODE_03A60E                     ;; 03A5E0 : F0 2C       ;
                      LSR A                               ;; 03A5E2 : 4A          ;
                      LSR A                               ;; 03A5E3 : 4A          ;
                      TAY                                 ;; 03A5E4 : A8          ;
                      LDA.W DATA_03A52D,Y                 ;; 03A5E5 : B9 2D A5    ;
                      STA.W !SpriteMisc1570,X             ;; 03A5E8 : 9D 70 15    ;
                      LDA.W DATA_03A56D,Y                 ;; 03A5EB : B9 6D A5    ;
                      STA.B !Mode7Angle                   ;; 03A5EE : 85 36       ;
                      STZ.B !Mode7Angle+1                 ;; 03A5F0 : 64 37       ;
                      CMP.B #$FF                          ;; 03A5F2 : C9 FF       ;
                      BNE CODE_03A5FC                     ;; 03A5F4 : D0 06       ;
                      STZ.B !Mode7Angle                   ;; 03A5F6 : 64 36       ;
                      INC.B !Mode7Angle+1                 ;; 03A5F8 : E6 37       ;
                      STZ.B !SpriteProperties             ;; 03A5FA : 64 64       ;
CODE_03A5FC:          LDA.W !BrSwingYDist                 ;; 03A5FC : AD B6 14    ;
                      CMP.B #$80                          ;; 03A5FF : C9 80       ;
                      BNE CODE_03A60B                     ;; 03A601 : D0 08       ;
                      LDA.B #$09                          ;; 03A603 : A9 09       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03A605 : 8D FC 1D    ; / 
                      JSR CODE_03A61D                     ;; 03A608 : 20 1D A6    ;
CODE_03A60B:          PLA                                 ;; 03A60B : 68          ;
                      PLA                                 ;; 03A60C : 68          ;
Return03A60D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A60E:          LDA.B #$60                          ;; 03A60E : A9 60       ;
                      LDY.W !BrSwingPlatXPos              ;; 03A610 : AC B8 14    ;
                      CPY.B #$02                          ;; 03A613 : C0 02       ;
                      BEQ CODE_03A619                     ;; 03A615 : F0 02       ;
                      LDA.B #$20                          ;; 03A617 : A9 20       ;
CODE_03A619:          STA.W !BrSwingCenterXPos            ;; 03A619 : 8D B0 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A61D:          LDA.B #$08                          ;; 03A61D : A9 08       ;
                      STA.W !SpriteStatus+8               ;; 03A61F : 8D D0 14    ;
                      LDA.B #$A1                          ;; 03A622 : A9 A1       ;
                      STA.B !SpriteNumber+8               ;; 03A624 : 85 A6       ;
                      LDA.B !SpriteXPosLow,X              ;; 03A626 : B5 E4       ;
                      CLC                                 ;; 03A628 : 18          ;
                      ADC.B #$08                          ;; 03A629 : 69 08       ;
                      STA.B !SpriteXPosLow+8              ;; 03A62B : 85 EC       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03A62D : BD E0 14    ;
                      ADC.B #$00                          ;; 03A630 : 69 00       ;
                      STA.W !SpriteYPosHigh+8             ;; 03A632 : 8D E8 14    ;
                      LDA.B !SpriteYPosLow,X              ;; 03A635 : B5 D8       ;
                      CLC                                 ;; 03A637 : 18          ;
                      ADC.B #$40                          ;; 03A638 : 69 40       ;
                      STA.B !SpriteYPosLow+8              ;; 03A63A : 85 E0       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03A63C : BD D4 14    ;
                      ADC.B #$00                          ;; 03A63F : 69 00       ;
                      STA.W !SpriteXPosHigh+8             ;; 03A641 : 8D DC 14    ;
                      PHX                                 ;; 03A644 : DA          ;
                      LDX.B #$08                          ;; 03A645 : A2 08       ;
                      JSL InitSpriteTables                ;; 03A647 : 22 D2 F7 07 ;
                      PLX                                 ;; 03A64B : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A64D:          db $00,$00,$00,$00,$FC,$F8,$F4,$F0  ;; 03A64D               ;
                      db $F4,$F8,$FC,$00,$04,$08,$0C,$10  ;; ?QPWZ?               ;
                      db $0C,$08,$04,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A661:          LDA.W !BrSwingXDist+1               ;; 03A661 : AD B5 14    ;
                      BEQ Return03A6BF                    ;; 03A664 : F0 59       ;
                      STZ.W !BrSwingCenterXPos+1          ;; 03A666 : 9C B1 14    ;
                      STZ.W !BrSwingYDist                 ;; 03A669 : 9C B6 14    ;
                      DEC.W !BrSwingXDist+1               ;; 03A66C : CE B5 14    ;
                      BNE CODE_03A691                     ;; 03A66F : D0 20       ;
                      LDA.B #$50                          ;; 03A671 : A9 50       ;
                      STA.W !BrSwingCenterXPos            ;; 03A673 : 8D B0 14    ;
                      DEC.W !SpriteMisc187B,X             ;; 03A676 : DE 7B 18    ;
                      BNE CODE_03A691                     ;; 03A679 : D0 16       ;
                      LDA.W !SpriteMisc151C,X             ;; 03A67B : BD 1C 15    ;
                      CMP.B #$09                          ;; 03A67E : C9 09       ;
                      BEQ CODE_03A6C0                     ;; 03A680 : F0 3E       ;
                      LDA.B #$02                          ;; 03A682 : A9 02       ;
                      STA.W !SpriteMisc187B,X             ;; 03A684 : 9D 7B 18    ;
                      LDA.B #$01                          ;; 03A687 : A9 01       ;
                      STA.W !SpriteMisc151C,X             ;; 03A689 : 9D 1C 15    ;
                      LDA.B #$80                          ;; 03A68C : A9 80       ;
                      STA.W !SpriteMisc1540,X             ;; 03A68E : 9D 40 15    ;
CODE_03A691:          PLY                                 ;; 03A691 : 7A          ;
                      PLY                                 ;; 03A692 : 7A          ;
                      PHA                                 ;; 03A693 : 48          ;
                      LDA.W !BrSwingXDist+1               ;; 03A694 : AD B5 14    ;
                      LSR A                               ;; 03A697 : 4A          ;
                      LSR A                               ;; 03A698 : 4A          ;
                      TAY                                 ;; 03A699 : A8          ;
                      LDA.W DATA_03A64D,Y                 ;; 03A69A : B9 4D A6    ;
                      STA.B !Mode7Angle                   ;; 03A69D : 85 36       ;
                      STZ.B !Mode7Angle+1                 ;; 03A69F : 64 37       ;
                      BPL CODE_03A6A5                     ;; 03A6A1 : 10 02       ;
                      INC.B !Mode7Angle+1                 ;; 03A6A3 : E6 37       ;
CODE_03A6A5:          PLA                                 ;; 03A6A5 : 68          ;
                      LDY.B #$0C                          ;; 03A6A6 : A0 0C       ;
                      CMP.B #$40                          ;; 03A6A8 : C9 40       ;
                      BCS CODE_03A6B6                     ;; 03A6AA : B0 0A       ;
CODE_03A6AC:          LDA.B !TrueFrame                    ;; 03A6AC : A5 13       ;
                      LDY.B #$10                          ;; 03A6AE : A0 10       ;
                      AND.B #$04                          ;; 03A6B0 : 29 04       ;
                      BEQ CODE_03A6B6                     ;; 03A6B2 : F0 02       ;
                      LDY.B #$12                          ;; 03A6B4 : A0 12       ;
CODE_03A6B6:          TYA                                 ;; 03A6B6 : 98          ;
                      STA.W !SpriteMisc1570,X             ;; 03A6B7 : 9D 70 15    ;
                      LDA.B #$02                          ;; 03A6BA : A9 02       ;
                      STA.W !ClownCarImage                ;; 03A6BC : 8D 27 14    ;
Return03A6BF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A6C0:          LDA.B #$04                          ;; 03A6C0 : A9 04       ;
                      STA.W !SpriteMisc151C,X             ;; 03A6C2 : 9D 1C 15    ;
                      STZ.B !SpriteXSpeed,X               ;; 03A6C5 : 74 B6       ; Sprite X Speed = 0 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
KillMostSprites:      LDY.B #$09                          ;; ?QPWZ? : A0 09       ;
CODE_03A6CA:          LDA.W !SpriteStatus,Y               ;; 03A6CA : B9 C8 14    ;
                      BEQ CODE_03A6EC                     ;; 03A6CD : F0 1D       ;
                      LDA.W !SpriteNumber,Y               ;; 03A6CF : B9 9E 00    ;
                      CMP.B #$A9                          ;; 03A6D2 : C9 A9       ;
                      BEQ CODE_03A6EC                     ;; 03A6D4 : F0 16       ;
                      CMP.B #$29                          ;; 03A6D6 : C9 29       ;
                      BEQ CODE_03A6EC                     ;; 03A6D8 : F0 12       ;
                      CMP.B #$A0                          ;; 03A6DA : C9 A0       ;
                      BEQ CODE_03A6EC                     ;; 03A6DC : F0 0E       ;
                      CMP.B #$C5                          ;; 03A6DE : C9 C5       ;
                      BEQ CODE_03A6EC                     ;; 03A6E0 : F0 0A       ;
                      LDA.B #$04                          ;; 03A6E2 : A9 04       ; \ Sprite status = Killed by spin jump 
                      STA.W !SpriteStatus,Y               ;; 03A6E4 : 99 C8 14    ; / 
                      LDA.B #$1F                          ;; 03A6E7 : A9 1F       ; \ Time to show cloud of smoke = #$1F 
                      STA.W !SpriteMisc1540,Y             ;; 03A6E9 : 99 40 15    ; / 
CODE_03A6EC:          DEY                                 ;; 03A6EC : 88          ;
                      BPL CODE_03A6CA                     ;; 03A6ED : 10 DB       ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A6F0:          db $0E,$0E,$0A,$08,$06,$04,$02,$00  ;; 03A6F0               ;
                                                          ;;                      ;
CODE_03A6F8:          LDA.W !SpriteMisc1540,X             ;; 03A6F8 : BD 40 15    ;
                      BEQ CODE_03A731                     ;; 03A6FB : F0 34       ;
                      CMP.B #$01                          ;; 03A6FD : C9 01       ;
                      BNE CODE_03A706                     ;; 03A6FF : D0 05       ;
                      LDY.B #$17                          ;; 03A701 : A0 17       ;
                      STY.W !SPCIO2                       ;; 03A703 : 8C FB 1D    ; / Change music 
CODE_03A706:          LSR A                               ;; 03A706 : 4A          ;
                      LSR A                               ;; 03A707 : 4A          ;
                      LSR A                               ;; 03A708 : 4A          ;
                      LSR A                               ;; 03A709 : 4A          ;
                      TAY                                 ;; 03A70A : A8          ;
                      LDA.W DATA_03A6F0,Y                 ;; 03A70B : B9 F0 A6    ;
                      STA.W !SpriteMisc1570,X             ;; 03A70E : 9D 70 15    ;
                      STZ.B !SpriteXSpeed,X               ;; 03A711 : 74 B6       ; Sprite X Speed = 0 
                      STZ.B !SpriteYSpeed,X               ;; 03A713 : 74 AA       ; Sprite Y Speed = 0 
                      STZ.W !SpriteMisc1528,X             ;; 03A715 : 9E 28 15    ;
                      STZ.W !SpriteMisc1534,X             ;; 03A718 : 9E 34 15    ;
                      STZ.W !BrSwingCenterYPos            ;; 03A71B : 9C B2 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A71F:          db $01,$FF                          ;; 03A71F               ;
                                                          ;;                      ;
DATA_03A721:          db $10,$80                          ;; 03A721               ;
                                                          ;;                      ;
DATA_03A723:          db $07,$03                          ;; 03A723               ;
                                                          ;;                      ;
DATA_03A725:          db $FF,$01                          ;; 03A725               ;
                                                          ;;                      ;
DATA_03A727:          db $F0,$08                          ;; 03A727               ;
                                                          ;;                      ;
DATA_03A729:          db $01,$FF                          ;; 03A729               ;
                                                          ;;                      ;
DATA_03A72B:          db $03,$03                          ;; 03A72B               ;
                                                          ;;                      ;
DATA_03A72D:          db $60,$02                          ;; 03A72D               ;
                                                          ;;                      ;
DATA_03A72F:          db $01,$01                          ;; 03A72F               ;
                                                          ;;                      ;
CODE_03A731:          LDY.W !SpriteMisc1528,X             ;; 03A731 : BC 28 15    ;
                      CPY.B #$02                          ;; 03A734 : C0 02       ;
                      BCS CODE_03A74F                     ;; 03A736 : B0 17       ;
                      LDA.B !TrueFrame                    ;; 03A738 : A5 13       ;
                      AND.W DATA_03A723,Y                 ;; 03A73A : 39 23 A7    ;
                      BNE CODE_03A74F                     ;; 03A73D : D0 10       ;
                      LDA.B !SpriteXSpeed,X               ;; 03A73F : B5 B6       ;
                      CLC                                 ;; 03A741 : 18          ;
                      ADC.W DATA_03A71F,Y                 ;; 03A742 : 79 1F A7    ;
                      STA.B !SpriteXSpeed,X               ;; 03A745 : 95 B6       ;
                      CMP.W DATA_03A721,Y                 ;; 03A747 : D9 21 A7    ;
                      BNE CODE_03A74F                     ;; 03A74A : D0 03       ;
                      INC.W !SpriteMisc1528,X             ;; 03A74C : FE 28 15    ;
CODE_03A74F:          LDY.W !SpriteMisc1534,X             ;; 03A74F : BC 34 15    ;
                      CPY.B #$02                          ;; 03A752 : C0 02       ;
                      BCS CODE_03A76D                     ;; 03A754 : B0 17       ;
                      LDA.B !TrueFrame                    ;; 03A756 : A5 13       ;
                      AND.W DATA_03A72B,Y                 ;; 03A758 : 39 2B A7    ;
                      BNE CODE_03A76D                     ;; 03A75B : D0 10       ;
                      LDA.B !SpriteYSpeed,X               ;; 03A75D : B5 AA       ;
                      CLC                                 ;; 03A75F : 18          ;
                      ADC.W DATA_03A725,Y                 ;; 03A760 : 79 25 A7    ;
                      STA.B !SpriteYSpeed,X               ;; 03A763 : 95 AA       ;
                      CMP.W DATA_03A727,Y                 ;; 03A765 : D9 27 A7    ;
                      BNE CODE_03A76D                     ;; 03A768 : D0 03       ;
                      INC.W !SpriteMisc1534,X             ;; 03A76A : FE 34 15    ;
CODE_03A76D:          LDY.W !BrSwingCenterYPos            ;; 03A76D : AC B2 14    ;
                      CPY.B #$02                          ;; 03A770 : C0 02       ;
                      BEQ CODE_03A794                     ;; 03A772 : F0 20       ;
                      LDA.B !TrueFrame                    ;; 03A774 : A5 13       ;
                      AND.W DATA_03A72F,Y                 ;; 03A776 : 39 2F A7    ;
                      BNE CODE_03A78D                     ;; 03A779 : D0 12       ;
                      LDA.B !Mode7XScale                  ;; 03A77B : A5 38       ;
                      CLC                                 ;; 03A77D : 18          ;
                      ADC.W DATA_03A729,Y                 ;; 03A77E : 79 29 A7    ;
                      STA.B !Mode7XScale                  ;; 03A781 : 85 38       ;
                      STA.B !Mode7YScale                  ;; 03A783 : 85 39       ;
                      CMP.W DATA_03A72D,Y                 ;; 03A785 : D9 2D A7    ;
                      BNE CODE_03A78D                     ;; 03A788 : D0 03       ;
                      INC.W !BrSwingCenterYPos            ;; 03A78A : EE B2 14    ;
CODE_03A78D:          LDA.W !SpriteYPosHigh,X             ;; 03A78D : BD E0 14    ;
                      CMP.B #$FE                          ;; 03A790 : C9 FE       ;
                      BNE Return03A7AC                    ;; 03A792 : D0 18       ;
CODE_03A794:          LDA.B #$03                          ;; 03A794 : A9 03       ;
                      STA.W !SpriteMisc151C,X             ;; 03A796 : 9D 1C 15    ;
                      LDA.B #$80                          ;; 03A799 : A9 80       ;
                      STA.W !BrSwingCenterXPos            ;; 03A79B : 8D B0 14    ;
                      JSL GetRand                         ;; 03A79E : 22 F9 AC 01 ;
                      AND.B #$F0                          ;; 03A7A2 : 29 F0       ;
                      STA.W !BrSwingYDist+1               ;; 03A7A4 : 8D B7 14    ;
                      LDA.B #$1D                          ;; 03A7A7 : A9 1D       ;
                      STA.W !SPCIO2                       ;; 03A7A9 : 8D FB 1D    ; / Change music 
Return03A7AC:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7AD:          LDA.B #$60                          ;; 03A7AD : A9 60       ;
                      STA.B !Mode7XScale                  ;; 03A7AF : 85 38       ;
                      STA.B !Mode7YScale                  ;; 03A7B1 : 85 39       ;
                      LDA.B #$FF                          ;; 03A7B3 : A9 FF       ;
                      STA.W !SpriteYPosHigh,X             ;; 03A7B5 : 9D E0 14    ;
                      LDA.B #$60                          ;; 03A7B8 : A9 60       ;
                      STA.B !SpriteXPosLow,X              ;; 03A7BA : 95 E4       ;
                      LDA.W !BrSwingCenterXPos            ;; 03A7BC : AD B0 14    ;
                      BNE CODE_03A7DF                     ;; 03A7BF : D0 1E       ;
                      LDA.B #$18                          ;; 03A7C1 : A9 18       ;
                      STA.W !SPCIO2                       ;; 03A7C3 : 8D FB 1D    ; / Change music 
                      LDA.B #$02                          ;; 03A7C6 : A9 02       ;
                      STA.W !SpriteMisc151C,X             ;; 03A7C8 : 9D 1C 15    ;
                      LDA.B #$18                          ;; 03A7CB : A9 18       ;
                      STA.B !SpriteYPosLow,X              ;; 03A7CD : 95 D8       ;
                      LDA.B #$00                          ;; 03A7CF : A9 00       ;
                      STA.W !SpriteXPosHigh,X             ;; 03A7D1 : 9D D4 14    ;
                      LDA.B #$08                          ;; 03A7D4 : A9 08       ;
                      STA.B !Mode7XScale                  ;; 03A7D6 : 85 38       ;
                      STA.B !Mode7YScale                  ;; 03A7D8 : 85 39       ;
                      LDA.B #$64                          ;; 03A7DA : A9 64       ;
                      STA.B !SpriteXSpeed,X               ;; 03A7DC : 95 B6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7DF:          CMP.B #$60                          ;; 03A7DF : C9 60       ;
                      BCS Return03A840                    ;; 03A7E1 : B0 5D       ;
                      LDA.B !TrueFrame                    ;; 03A7E3 : A5 13       ;
                      AND.B #$1F                          ;; 03A7E5 : 29 1F       ;
                      BNE Return03A840                    ;; 03A7E7 : D0 57       ;
                      LDY.B #$07                          ;; 03A7E9 : A0 07       ;
CODE_03A7EB:          LDA.W !SpriteStatus,Y               ;; 03A7EB : B9 C8 14    ;
                      BEQ CODE_03A7F6                     ;; 03A7EE : F0 06       ;
                      DEY                                 ;; 03A7F0 : 88          ;
                      CPY.B #$01                          ;; 03A7F1 : C0 01       ;
                      BNE CODE_03A7EB                     ;; 03A7F3 : D0 F6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A7F6:          LDA.B #$17                          ;; 03A7F6 : A9 17       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03A7F8 : 8D FC 1D    ; / 
                      LDA.B #$08                          ;; 03A7FB : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03A7FD : 99 C8 14    ; / 
                      LDA.B #$33                          ;; 03A800 : A9 33       ;
                      STA.W !SpriteNumber,Y               ;; 03A802 : 99 9E 00    ;
                      LDA.W !BrSwingYDist+1               ;; 03A805 : AD B7 14    ;
                      PHA                                 ;; 03A808 : 48          ;
                      STA.W !SpriteXPosLow,Y              ;; 03A809 : 99 E4 00    ;
                      CLC                                 ;; 03A80C : 18          ;
                      ADC.B #$20                          ;; 03A80D : 69 20       ;
                      STA.W !BrSwingYDist+1               ;; 03A80F : 8D B7 14    ;
                      LDA.B #$00                          ;; 03A812 : A9 00       ;
                      STA.W !SpriteYPosHigh,Y             ;; 03A814 : 99 E0 14    ;
                      LDA.B #$00                          ;; 03A817 : A9 00       ;
                      STA.W !SpriteYPosLow,Y              ;; 03A819 : 99 D8 00    ;
                      STA.W !SpriteXPosHigh,Y             ;; 03A81C : 99 D4 14    ;
                      PHX                                 ;; 03A81F : DA          ;
                      TYX                                 ;; 03A820 : BB          ;
                      JSL InitSpriteTables                ;; 03A821 : 22 D2 F7 07 ;
                      INC.B !SpriteTableC2,X              ;; 03A825 : F6 C2       ;
                      ASL.W !SpriteTweakerE,X             ;; 03A827 : 1E 86 16    ;
                      LSR.W !SpriteTweakerE,X             ;; 03A82A : 5E 86 16    ;
                      LDA.B #$39                          ;; 03A82D : A9 39       ;
                      STA.W !SpriteTweakerB,X             ;; 03A82F : 9D 62 16    ;
                      PLX                                 ;; 03A832 : FA          ;
                      PLA                                 ;; 03A833 : 68          ;
                      LSR A                               ;; 03A834 : 4A          ;
                      LSR A                               ;; 03A835 : 4A          ;
                      LSR A                               ;; 03A836 : 4A          ;
                      LSR A                               ;; 03A837 : 4A          ;
                      LSR A                               ;; 03A838 : 4A          ;
                      TAY                                 ;; 03A839 : A8          ;
                      LDA.W BowserSound,Y                 ;; 03A83A : B9 41 A8    ;
                      STA.W !SPCIO3                       ;; 03A83D : 8D FC 1D    ; / Play sound effect 
Return03A840:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserSound:          db $2D                              ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserSoundMusic:     db $2E,$2F,$30,$31,$32,$33,$34,$19  ;; ?QPWZ?               ;
                      db $1A                              ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A84B:          STZ.B !SpriteYSpeed,X               ;; 03A84B : 74 AA       ; Sprite Y Speed = 0 
                      LDA.W !SpriteMisc1540,X             ;; 03A84D : BD 40 15    ;
                      BNE CODE_03A86E                     ;; 03A850 : D0 1C       ;
                      LDA.B !SpriteXSpeed,X               ;; 03A852 : B5 B6       ;
                      BEQ CODE_03A858                     ;; 03A854 : F0 02       ;
                      DEC.B !SpriteXSpeed,X               ;; 03A856 : D6 B6       ;
CODE_03A858:          LDA.B !TrueFrame                    ;; 03A858 : A5 13       ;
                      AND.B #$03                          ;; 03A85A : 29 03       ;
                      BNE Return03A86D                    ;; 03A85C : D0 0F       ;
                      INC.B !Mode7XScale                  ;; 03A85E : E6 38       ;
                      INC.B !Mode7YScale                  ;; 03A860 : E6 39       ;
                      LDA.B !Mode7XScale                  ;; 03A862 : A5 38       ;
                      CMP.B #$20                          ;; 03A864 : C9 20       ;
                      BNE Return03A86D                    ;; 03A866 : D0 05       ;
                      LDA.B #$FF                          ;; 03A868 : A9 FF       ;
                      STA.W !SpriteMisc1540,X             ;; 03A86A : 9D 40 15    ;
Return03A86D:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A86E:          CMP.B #$A0                          ;; 03A86E : C9 A0       ;
                      BNE CODE_03A877                     ;; 03A870 : D0 05       ;
                      PHA                                 ;; 03A872 : 48          ;
                      JSR CODE_03A8D6                     ;; 03A873 : 20 D6 A8    ;
                      PLA                                 ;; 03A876 : 68          ;
CODE_03A877:          STZ.B !SpriteXSpeed,X               ;; 03A877 : 74 B6       ; Sprite X Speed = 0 
                      STZ.B !SpriteYSpeed,X               ;; 03A879 : 74 AA       ; Sprite Y Speed = 0 
                      CMP.B #$01                          ;; 03A87B : C9 01       ;
                      BEQ CODE_03A89D                     ;; 03A87D : F0 1E       ;
                      CMP.B #$40                          ;; 03A87F : C9 40       ;
                      BCS CODE_03A8AE                     ;; 03A881 : B0 2B       ;
                      CMP.B #$3F                          ;; 03A883 : C9 3F       ;
                      BNE CODE_03A892                     ;; 03A885 : D0 0B       ;
                      PHA                                 ;; 03A887 : 48          ;
                      LDY.W !BrSwingXDist                 ;; 03A888 : AC B4 14    ;
                      LDA.W BowserSoundMusic,Y            ;; 03A88B : B9 42 A8    ;
                      STA.W !SPCIO2                       ;; 03A88E : 8D FB 1D    ; / Change music 
                      PLA                                 ;; 03A891 : 68          ;
CODE_03A892:          LSR A                               ;; 03A892 : 4A          ;
                      LSR A                               ;; 03A893 : 4A          ;
                      LSR A                               ;; 03A894 : 4A          ;
                      TAY                                 ;; 03A895 : A8          ;
                      LDA.W DATA_03A437,Y                 ;; 03A896 : B9 37 A4    ;
                      STA.W !SpriteMisc1570,X             ;; 03A899 : 9D 70 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A89D:          LDA.W !BrSwingXDist                 ;; 03A89D : AD B4 14    ;
                      INC A                               ;; 03A8A0 : 1A          ;
                      STA.W !SpriteMisc151C,X             ;; 03A8A1 : 9D 1C 15    ;
                      STZ.B !SpriteXSpeed,X               ;; 03A8A4 : 74 B6       ; Sprite X Speed = 0 
                      STZ.B !SpriteYSpeed,X               ;; 03A8A6 : 74 AA       ; Sprite Y Speed = 0 
                      LDA.B #$80                          ;; 03A8A8 : A9 80       ;
                      STA.W !BrSwingCenterXPos            ;; 03A8AA : 8D B0 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A8AE:          CMP.B #$E8                          ;; 03A8AE : C9 E8       ;
                      BNE CODE_03A8B7                     ;; 03A8B0 : D0 05       ;
                      LDY.B #$2A                          ;; 03A8B2 : A0 2A       ; \ Play sound effect 
                      STY.W !SPCIO0                       ;; 03A8B4 : 8C F9 1D    ; / 
CODE_03A8B7:          SEC                                 ;; 03A8B7 : 38          ;
                      SBC.B #$3F                          ;; 03A8B8 : E9 3F       ;
                      STA.W !SpriteMisc1594,X             ;; 03A8BA : 9D 94 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A8BE:          db $00,$00,$00,$08,$10,$14,$14,$16  ;; 03A8BE               ;
                      db $16,$18,$18,$17,$16,$16,$17,$18  ;; ?QPWZ?               ;
                      db $18,$17,$14,$10,$0C,$08,$04,$00  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03A8D6:          LDY.B #$07                          ;; 03A8D6 : A0 07       ;
CODE_03A8D8:          LDA.W !SpriteStatus,Y               ;; 03A8D8 : B9 C8 14    ;
                      BEQ CODE_03A8E3                     ;; 03A8DB : F0 06       ;
                      DEY                                 ;; 03A8DD : 88          ;
                      CPY.B #$01                          ;; 03A8DE : C0 01       ;
                      BNE CODE_03A8D8                     ;; 03A8E0 : D0 F6       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03A8E3:          LDA.B #$10                          ;; 03A8E3 : A9 10       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03A8E5 : 8D F9 1D    ; / 
                      LDA.B #$08                          ;; 03A8E8 : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03A8EA : 99 C8 14    ; / 
                      LDA.B #$74                          ;; 03A8ED : A9 74       ;
                      STA.W !SpriteNumber,Y               ;; 03A8EF : 99 9E 00    ;
                      LDA.B !SpriteXPosLow,X              ;; 03A8F2 : B5 E4       ;
                      CLC                                 ;; 03A8F4 : 18          ;
                      ADC.B #$04                          ;; 03A8F5 : 69 04       ;
                      STA.W !SpriteXPosLow,Y              ;; 03A8F7 : 99 E4 00    ;
                      LDA.W !SpriteYPosHigh,X             ;; 03A8FA : BD E0 14    ;
                      ADC.B #$00                          ;; 03A8FD : 69 00       ;
                      STA.W !SpriteYPosHigh,Y             ;; 03A8FF : 99 E0 14    ;
                      LDA.B !SpriteYPosLow,X              ;; 03A902 : B5 D8       ;
                      CLC                                 ;; 03A904 : 18          ;
                      ADC.B #$18                          ;; 03A905 : 69 18       ;
                      STA.W !SpriteYPosLow,Y              ;; 03A907 : 99 D8 00    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03A90A : BD D4 14    ;
                      ADC.B #$00                          ;; 03A90D : 69 00       ;
                      STA.W !SpriteXPosHigh,Y             ;; 03A90F : 99 D4 14    ;
                      PHX                                 ;; 03A912 : DA          ;
                      TYX                                 ;; 03A913 : BB          ;
                      JSL InitSpriteTables                ;; 03A914 : 22 D2 F7 07 ;
                      LDA.B #$C0                          ;; 03A918 : A9 C0       ;
                      STA.B !SpriteYSpeed,X               ;; 03A91A : 95 AA       ;
                      STZ.W !SpriteMisc157C,X             ;; 03A91C : 9E 7C 15    ;
                      LDY.B #$0C                          ;; 03A91F : A0 0C       ;
                      LDA.B !SpriteXPosLow,X              ;; 03A921 : B5 E4       ;
                      BPL CODE_03A92A                     ;; 03A923 : 10 05       ;
                      LDY.B #$F4                          ;; 03A925 : A0 F4       ;
                      INC.W !SpriteMisc157C,X             ;; 03A927 : FE 7C 15    ;
CODE_03A92A:          STY.B !SpriteXSpeed,X               ;; 03A92A : 94 B6       ;
                      PLX                                 ;; 03A92C : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03A92E:          db $00,$08,$00,$08,$00,$08,$00,$08  ;; 03A92E               ;
                      db $00,$08,$00,$08,$00,$08,$00,$08  ;; ?QPWZ?               ;
                      db $00,$08,$00,$08,$00,$08,$00,$08  ;; ?QPWZ?               ;
                      db $00,$08,$00,$08,$00,$08,$00,$08  ;; ?QPWZ?               ;
                      db $00,$08,$00,$08,$00,$08,$00,$08  ;; ?QPWZ?               ;
                      db $00,$08,$00,$08,$00,$08,$00,$08  ;; ?QPWZ?               ;
                      db $08,$00,$08,$00,$08,$00,$08,$00  ;; ?QPWZ?               ;
                      db $08,$00,$08,$00,$08,$00,$08,$00  ;; ?QPWZ?               ;
                      db $08,$00,$08,$00,$08,$00,$08,$00  ;; ?QPWZ?               ;
                      db $08,$00,$08,$00,$08,$00,$08,$00  ;; ?QPWZ?               ;
DATA_03A97E:          db $00,$00,$08,$08,$00,$00,$08,$08  ;; 03A97E               ;
                      db $00,$00,$08,$08,$00,$00,$08,$08  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
                      db $00,$00,$10,$10,$00,$00,$10,$10  ;; ?QPWZ?               ;
DATA_03A9CE:          db $05,$06,$15,$16,$9D,$9E,$4E,$AE  ;; 03A9CE               ;
                      db $06,$05,$16,$15,$9E,$9D,$AE,$4E  ;; ?QPWZ?               ;
                      db $8A,$8B,$AA,$68,$83,$84,$AA,$68  ;; ?QPWZ?               ;
                      db $8A,$8B,$80,$81,$83,$84,$80,$81  ;; ?QPWZ?               ;
                      db $85,$86,$A5,$A6,$83,$84,$A5,$A6  ;; ?QPWZ?               ;
                      db $82,$83,$A2,$A3,$82,$83,$A2,$A3  ;; ?QPWZ?               ;
                      db $8A,$8B,$AA,$68,$83,$84,$AA,$68  ;; ?QPWZ?               ;
                      db $8A,$8B,$80,$81,$83,$84,$80,$81  ;; ?QPWZ?               ;
                      db $85,$86,$A5,$A6,$83,$84,$A5,$A6  ;; ?QPWZ?               ;
                      db $82,$83,$A2,$A3,$82,$83,$A2,$A3  ;; ?QPWZ?               ;
DATA_03AA1E:          db $01,$01,$01,$01,$01,$01,$01,$01  ;; 03AA1E               ;
                      db $41,$41,$41,$41,$41,$41,$41,$41  ;; ?QPWZ?               ;
                      db $01,$01,$01,$01,$01,$01,$01,$01  ;; ?QPWZ?               ;
                      db $01,$01,$01,$01,$01,$01,$01,$01  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$01,$01,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $41,$41,$41,$41,$41,$41,$41,$41  ;; ?QPWZ?               ;
                      db $41,$41,$41,$41,$41,$41,$41,$41  ;; ?QPWZ?               ;
                      db $40,$40,$40,$40,$41,$41,$40,$40  ;; ?QPWZ?               ;
                      db $40,$40,$40,$40,$40,$40,$40,$40  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AA6E:          LDA.B !SpriteXPosLow,X              ;; 03AA6E : B5 E4       ;
                      CLC                                 ;; 03AA70 : 18          ;
                      ADC.B #$04                          ;; 03AA71 : 69 04       ;
                      SEC                                 ;; 03AA73 : 38          ;
                      SBC.B !Layer1XPos                   ;; 03AA74 : E5 1A       ;
                      STA.B !_0                           ;; 03AA76 : 85 00       ;
                      LDA.B !SpriteYPosLow,X              ;; 03AA78 : B5 D8       ;
                      CLC                                 ;; 03AA7A : 18          ;
                      ADC.B #$20                          ;; 03AA7B : 69 20       ;
                      SEC                                 ;; 03AA7D : 38          ;
                      SBC.B !_2                           ;; 03AA7E : E5 02       ;
                      SEC                                 ;; 03AA80 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03AA81 : E5 1C       ;
                      STA.B !_1                           ;; 03AA83 : 85 01       ;
                      CPY.B #$08                          ;; 03AA85 : C0 08       ;
                      BCC CODE_03AAC6                     ;; 03AA87 : 90 3D       ;
                      CPY.B #$10                          ;; 03AA89 : C0 10       ;
                      BCS CODE_03AAC6                     ;; 03AA8B : B0 39       ;
                      LDA.B !_0                           ;; 03AA8D : A5 00       ;
                      SEC                                 ;; 03AA8F : 38          ;
                      SBC.B #$04                          ;; 03AA90 : E9 04       ;
                      STA.W !OAMTileXPos+$A0              ;; 03AA92 : 8D A0 02    ;
                      CLC                                 ;; 03AA95 : 18          ;
                      ADC.B #$10                          ;; 03AA96 : 69 10       ;
                      STA.W !OAMTileXPos+$A4              ;; 03AA98 : 8D A4 02    ;
                      LDA.B !_1                           ;; 03AA9B : A5 01       ;
                      SEC                                 ;; 03AA9D : 38          ;
                      SBC.B #$18                          ;; 03AA9E : E9 18       ;
                      STA.W !OAMTileYPos+$A0              ;; 03AAA0 : 8D A1 02    ;
                      STA.W !OAMTileYPos+$A4              ;; 03AAA3 : 8D A5 02    ;
                      LDA.B #$20                          ;; 03AAA6 : A9 20       ;
                      STA.W !OAMTileNo+$A0                ;; 03AAA8 : 8D A2 02    ;
                      LDA.B #$22                          ;; 03AAAB : A9 22       ;
                      STA.W !OAMTileNo+$A4                ;; 03AAAD : 8D A6 02    ;
                      LDA.B !EffFrame                     ;; 03AAB0 : A5 14       ;
                      LSR A                               ;; 03AAB2 : 4A          ;
                      AND.B #$06                          ;; 03AAB3 : 29 06       ;
                      INC A                               ;; 03AAB5 : 1A          ;
                      INC A                               ;; 03AAB6 : 1A          ;
                      INC A                               ;; 03AAB7 : 1A          ;
                      STA.W !OAMTileAttr+$A0              ;; 03AAB8 : 8D A3 02    ;
                      STA.W !OAMTileAttr+$A4              ;; 03AABB : 8D A7 02    ;
                      LDA.B #$02                          ;; 03AABE : A9 02       ;
                      STA.W !OAMTileSize+$28              ;; 03AAC0 : 8D 48 04    ;
                      STA.W !OAMTileSize+$29              ;; 03AAC3 : 8D 49 04    ;
CODE_03AAC6:          LDY.B #$70                          ;; 03AAC6 : A0 70       ;
CODE_03AAC8:          LDA.B !_3                           ;; 03AAC8 : A5 03       ;
                      ASL A                               ;; 03AACA : 0A          ;
                      ASL A                               ;; 03AACB : 0A          ;
                      STA.B !_4                           ;; 03AACC : 85 04       ;
                      PHX                                 ;; 03AACE : DA          ;
                      LDX.B #$03                          ;; 03AACF : A2 03       ;
CODE_03AAD1:          PHX                                 ;; 03AAD1 : DA          ;
                      TXA                                 ;; 03AAD2 : 8A          ;
                      CLC                                 ;; 03AAD3 : 18          ;
                      ADC.B !_4                           ;; 03AAD4 : 65 04       ;
                      TAX                                 ;; 03AAD6 : AA          ;
                      LDA.B !_0                           ;; 03AAD7 : A5 00       ;
                      CLC                                 ;; 03AAD9 : 18          ;
                      ADC.W DATA_03A92E,X                 ;; 03AADA : 7D 2E A9    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03AADD : 99 00 03    ;
                      LDA.B !_1                           ;; 03AAE0 : A5 01       ;
                      CLC                                 ;; 03AAE2 : 18          ;
                      ADC.W DATA_03A97E,X                 ;; 03AAE3 : 7D 7E A9    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03AAE6 : 99 01 03    ;
                      LDA.W DATA_03A9CE,X                 ;; 03AAE9 : BD CE A9    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03AAEC : 99 02 03    ;
                      LDA.W DATA_03AA1E,X                 ;; 03AAEF : BD 1E AA    ;
                      PHX                                 ;; 03AAF2 : DA          ;
                      LDX.W !CurSpriteProcess             ;; 03AAF3 : AE E9 15    ; X = Sprite index 
                      CPX.B #$09                          ;; 03AAF6 : E0 09       ;
                      BEQ CODE_03AAFC                     ;; 03AAF8 : F0 02       ;
                      ORA.B #$30                          ;; 03AAFA : 09 30       ;
CODE_03AAFC:          STA.W !OAMTileAttr+$100,Y           ;; 03AAFC : 99 03 03    ;
                      PLX                                 ;; 03AAFF : FA          ;
                      PHY                                 ;; 03AB00 : 5A          ;
                      TYA                                 ;; 03AB01 : 98          ;
                      LSR A                               ;; 03AB02 : 4A          ;
                      LSR A                               ;; 03AB03 : 4A          ;
                      TAY                                 ;; 03AB04 : A8          ;
                      LDA.B #$02                          ;; 03AB05 : A9 02       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03AB07 : 99 60 04    ;
                      PLY                                 ;; 03AB0A : 7A          ;
                      INY                                 ;; 03AB0B : C8          ;
                      INY                                 ;; 03AB0C : C8          ;
                      INY                                 ;; 03AB0D : C8          ;
                      INY                                 ;; 03AB0E : C8          ;
                      PLX                                 ;; 03AB0F : FA          ;
                      DEX                                 ;; 03AB10 : CA          ;
                      BPL CODE_03AAD1                     ;; 03AB11 : 10 BE       ;
                      PLX                                 ;; 03AB13 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AB15:          db $01,$FF                          ;; 03AB15               ;
                                                          ;;                      ;
DATA_03AB17:          db $20,$E0                          ;; 03AB17               ;
                                                          ;;                      ;
DATA_03AB19:          db $02,$FE                          ;; 03AB19               ;
                                                          ;;                      ;
DATA_03AB1B:          db $20,$E0,$01,$FF,$10,$F0          ;; 03AB1B               ;
                                                          ;;                      ;
CODE_03AB21:          JSR CODE_03A4FD                     ;; 03AB21 : 20 FD A4    ;
                      JSR CODE_03A4D2                     ;; 03AB24 : 20 D2 A4    ;
                      JSR CODE_03A4ED                     ;; 03AB27 : 20 ED A4    ;
                      LDA.B !TrueFrame                    ;; 03AB2A : A5 13       ;
                      AND.B #$00                          ;; 03AB2C : 29 00       ;
                      BNE CODE_03AB4B                     ;; 03AB2E : D0 1B       ;
                      LDY.B #$00                          ;; 03AB30 : A0 00       ;
                      LDA.B !SpriteXPosLow,X              ;; 03AB32 : B5 E4       ;
                      CMP.B !PlayerXPosNext               ;; 03AB34 : C5 94       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03AB36 : BD E0 14    ;
                      SBC.B !PlayerXPosNext+1             ;; 03AB39 : E5 95       ;
                      BMI CODE_03AB3E                     ;; 03AB3B : 30 01       ;
                      INY                                 ;; 03AB3D : C8          ;
CODE_03AB3E:          LDA.B !SpriteXSpeed,X               ;; 03AB3E : B5 B6       ;
                      CMP.W DATA_03AB17,Y                 ;; 03AB40 : D9 17 AB    ;
                      BEQ CODE_03AB4B                     ;; 03AB43 : F0 06       ;
                      CLC                                 ;; 03AB45 : 18          ;
                      ADC.W DATA_03AB15,Y                 ;; 03AB46 : 79 15 AB    ;
                      STA.B !SpriteXSpeed,X               ;; 03AB49 : 95 B6       ;
CODE_03AB4B:          LDY.B #$00                          ;; 03AB4B : A0 00       ;
                      LDA.B !SpriteYPosLow,X              ;; 03AB4D : B5 D8       ;
                      CMP.B #$10                          ;; 03AB4F : C9 10       ;
                      BMI CODE_03AB54                     ;; 03AB51 : 30 01       ;
                      INY                                 ;; 03AB53 : C8          ;
CODE_03AB54:          LDA.B !SpriteYSpeed,X               ;; 03AB54 : B5 AA       ;
                      CMP.W DATA_03AB1B,Y                 ;; 03AB56 : D9 1B AB    ;
                      BEQ Return03AB61                    ;; 03AB59 : F0 06       ;
                      CLC                                 ;; 03AB5B : 18          ;
                      ADC.W DATA_03AB19,Y                 ;; 03AB5C : 79 19 AB    ;
                      STA.B !SpriteYSpeed,X               ;; 03AB5F : 95 AA       ;
Return03AB61:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AB62:          db $10,$F0                          ;; 03AB62               ;
                                                          ;;                      ;
CODE_03AB64:          LDA.B #$03                          ;; 03AB64 : A9 03       ;
                      STA.W !ClownCarImage                ;; 03AB66 : 8D 27 14    ;
                      JSR CODE_03A4FD                     ;; 03AB69 : 20 FD A4    ;
                      JSR CODE_03A4D2                     ;; 03AB6C : 20 D2 A4    ;
                      JSR CODE_03A4ED                     ;; 03AB6F : 20 ED A4    ;
                      LDA.B !SpriteYSpeed,X               ;; 03AB72 : B5 AA       ;
                      CLC                                 ;; 03AB74 : 18          ;
                      ADC.B #$03                          ;; 03AB75 : 69 03       ;
                      STA.B !SpriteYSpeed,X               ;; 03AB77 : 95 AA       ;
                      LDA.B !SpriteYPosLow,X              ;; 03AB79 : B5 D8       ;
                      CMP.B #$64                          ;; 03AB7B : C9 64       ;
                      BCC Return03AB9E                    ;; 03AB7D : 90 1F       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03AB7F : BD D4 14    ;
                      BMI Return03AB9E                    ;; 03AB82 : 30 1A       ;
                      LDA.B #$64                          ;; 03AB84 : A9 64       ;
                      STA.B !SpriteYPosLow,X              ;; 03AB86 : 95 D8       ;
                      LDA.B #$A0                          ;; 03AB88 : A9 A0       ;
                      STA.B !SpriteYSpeed,X               ;; 03AB8A : 95 AA       ;
                      LDA.B #$09                          ;; 03AB8C : A9 09       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03AB8E : 8D FC 1D    ; / 
                      JSR SubHorzPosBnk3                  ;; 03AB91 : 20 17 B8    ;
                      LDA.W DATA_03AB62,Y                 ;; 03AB94 : B9 62 AB    ;
                      STA.B !SpriteXSpeed,X               ;; 03AB97 : 95 B6       ;
                      LDA.B #$20                          ;; 03AB99 : A9 20       ; \ Set ground shake timer 
                      STA.W !ScreenShakeTimer             ;; 03AB9B : 8D 87 18    ; / 
Return03AB9E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AB9F:          JSR CODE_03A6AC                     ;; 03AB9F : 20 AC A6    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03ABA2 : BD D4 14    ;
                      BMI CODE_03ABAF                     ;; 03ABA5 : 30 08       ;
                      BNE CODE_03ABB9                     ;; 03ABA7 : D0 10       ;
                      LDA.B !SpriteYPosLow,X              ;; 03ABA9 : B5 D8       ;
                      CMP.B #$10                          ;; 03ABAB : C9 10       ;
                      BCS CODE_03ABB9                     ;; 03ABAD : B0 0A       ;
CODE_03ABAF:          LDA.B #$05                          ;; 03ABAF : A9 05       ;
                      STA.W !SpriteMisc151C,X             ;; 03ABB1 : 9D 1C 15    ;
                      LDA.B #$60                          ;; 03ABB4 : A9 60       ;
                      STA.W !SpriteMisc1540,X             ;; 03ABB6 : 9D 40 15    ;
CODE_03ABB9:          LDA.B #$F8                          ;; 03ABB9 : A9 F8       ;
                      STA.B !SpriteYSpeed,X               ;; 03ABBB : 95 AA       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ABBE:          JSR CODE_03A6AC                     ;; 03ABBE : 20 AC A6    ;
                      STZ.B !SpriteXSpeed,X               ;; 03ABC1 : 74 B6       ; Sprite X Speed = 0 
                      STZ.B !SpriteYSpeed,X               ;; 03ABC3 : 74 AA       ; Sprite Y Speed = 0 
                      LDA.W !SpriteMisc1540,X             ;; 03ABC5 : BD 40 15    ;
                      BNE CODE_03ABEB                     ;; 03ABC8 : D0 21       ;
                      LDA.B !Mode7Angle                   ;; 03ABCA : A5 36       ;
                      CLC                                 ;; 03ABCC : 18          ;
                      ADC.B #$0A                          ;; 03ABCD : 69 0A       ;
                      STA.B !Mode7Angle                   ;; 03ABCF : 85 36       ;
                      LDA.B !Mode7Angle+1                 ;; 03ABD1 : A5 37       ;
                      ADC.B #$00                          ;; 03ABD3 : 69 00       ;
                      STA.B !Mode7Angle+1                 ;; 03ABD5 : 85 37       ;
                      BEQ Return03ABEA                    ;; 03ABD7 : F0 11       ;
                      STZ.B !Mode7Angle                   ;; 03ABD9 : 64 36       ;
                      LDA.B #$20                          ;; 03ABDB : A9 20       ;
                      STA.W !SpriteMisc154C,X             ;; 03ABDD : 9D 4C 15    ;
                      LDA.B #$60                          ;; 03ABE0 : A9 60       ;
                      STA.W !SpriteMisc1540,X             ;; 03ABE2 : 9D 40 15    ;
                      LDA.B #$06                          ;; 03ABE5 : A9 06       ;
                      STA.W !SpriteMisc151C,X             ;; 03ABE7 : 9D 1C 15    ;
Return03ABEA:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ABEB:          CMP.B #$40                          ;; 03ABEB : C9 40       ;
                      BCC Return03AC02                    ;; 03ABED : 90 13       ;
                      CMP.B #$5E                          ;; 03ABEF : C9 5E       ;
                      BNE CODE_03ABF8                     ;; 03ABF1 : D0 05       ;
                      LDY.B #$1B                          ;; 03ABF3 : A0 1B       ;
                      STY.W !SPCIO2                       ;; 03ABF5 : 8C FB 1D    ; / Change music 
CODE_03ABF8:          LDA.W !SpriteMisc1564,X             ;; 03ABF8 : BD 64 15    ;
                      BNE Return03AC02                    ;; 03ABFB : D0 05       ;
                      LDA.B #$12                          ;; 03ABFD : A9 12       ;
                      STA.W !SpriteMisc1564,X             ;; 03ABFF : 9D 64 15    ;
Return03AC02:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC03:          JSR CODE_03A6AC                     ;; 03AC03 : 20 AC A6    ;
                      LDA.W !SpriteMisc154C,X             ;; 03AC06 : BD 4C 15    ;
                      CMP.B #$01                          ;; 03AC09 : C9 01       ;
                      BNE CODE_03AC22                     ;; 03AC0B : D0 15       ;
                      LDA.B #$0B                          ;; 03AC0D : A9 0B       ;
                      STA.B !PlayerAnimation              ;; 03AC0F : 85 71       ;
                      INC.W !FinalCutscene                ;; 03AC11 : EE 0D 19    ;
                      STZ.W !BackgroundColor              ;; 03AC14 : 9C 01 07    ;
                      STZ.W !BackgroundColor+1            ;; 03AC17 : 9C 02 07    ;
                      LDA.B #$03                          ;; 03AC1A : A9 03       ;
                      STA.W !PlayerBehindNet              ;; 03AC1C : 8D F9 13    ;
                      JSR CODE_03AC63                     ;; 03AC1F : 20 63 AC    ;
CODE_03AC22:          LDA.W !SpriteMisc1540,X             ;; 03AC22 : BD 40 15    ;
                      BNE Return03AC4C                    ;; 03AC25 : D0 25       ;
                      LDA.B #$FA                          ;; 03AC27 : A9 FA       ;
                      STA.B !SpriteXSpeed,X               ;; 03AC29 : 95 B6       ;
                      LDA.B #$FC                          ;; 03AC2B : A9 FC       ;
                      STA.B !SpriteYSpeed,X               ;; 03AC2D : 95 AA       ;
                      LDA.B !Mode7Angle                   ;; 03AC2F : A5 36       ;
                      CLC                                 ;; 03AC31 : 18          ;
                      ADC.B #$05                          ;; 03AC32 : 69 05       ;
                      STA.B !Mode7Angle                   ;; 03AC34 : 85 36       ;
                      LDA.B !Mode7Angle+1                 ;; 03AC36 : A5 37       ;
                      ADC.B #$00                          ;; 03AC38 : 69 00       ;
                      STA.B !Mode7Angle+1                 ;; 03AC3A : 85 37       ;
                      LDA.B !TrueFrame                    ;; 03AC3C : A5 13       ;
                      AND.B #$03                          ;; 03AC3E : 29 03       ;
                      BNE Return03AC4C                    ;; 03AC40 : D0 0A       ;
                      LDA.B !Mode7XScale                  ;; 03AC42 : A5 38       ;
                      CMP.B #$80                          ;; 03AC44 : C9 80       ;
                      BCS CODE_03AC4D                     ;; 03AC46 : B0 05       ;
                      INC.B !Mode7XScale                  ;; 03AC48 : E6 38       ;
                      INC.B !Mode7YScale                  ;; 03AC4A : E6 39       ;
Return03AC4C:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC4D:          LDA.W !SpriteInLiquid,X             ;; 03AC4D : BD 4A 16    ;
                      BNE CODE_03AC5A                     ;; 03AC50 : D0 08       ;
                      LDA.B #$1C                          ;; 03AC52 : A9 1C       ;
                      STA.W !SPCIO2                       ;; 03AC54 : 8D FB 1D    ; / Change music 
                      INC.W !SpriteInLiquid,X             ;; 03AC57 : FE 4A 16    ;
CODE_03AC5A:          LDA.B #$FE                          ;; 03AC5A : A9 FE       ;
                      STA.W !SpriteYPosHigh,X             ;; 03AC5C : 9D E0 14    ;
                      STA.W !SpriteXPosHigh,X             ;; 03AC5F : 9D D4 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AC63:          LDA.B #$08                          ;; 03AC63 : A9 08       ;
                      STA.W !SpriteStatus+8               ;; 03AC65 : 8D D0 14    ;
                      LDA.B #$7C                          ;; 03AC68 : A9 7C       ;
                      STA.B !SpriteNumber+8               ;; 03AC6A : 85 A6       ;
                      LDA.B !SpriteXPosLow,X              ;; 03AC6C : B5 E4       ;
                      CLC                                 ;; 03AC6E : 18          ;
                      ADC.B #$08                          ;; 03AC6F : 69 08       ;
                      STA.B !SpriteXPosLow+8              ;; 03AC71 : 85 EC       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03AC73 : BD E0 14    ;
                      ADC.B #$00                          ;; 03AC76 : 69 00       ;
                      STA.W !SpriteYPosHigh+8             ;; 03AC78 : 8D E8 14    ;
                      LDA.B !SpriteYPosLow,X              ;; 03AC7B : B5 D8       ;
                      CLC                                 ;; 03AC7D : 18          ;
                      ADC.B #$47                          ;; 03AC7E : 69 47       ;
                      STA.B !SpriteYPosLow+8              ;; 03AC80 : 85 E0       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03AC82 : BD D4 14    ;
                      ADC.B #$00                          ;; 03AC85 : 69 00       ;
                      STA.W !SpriteXPosHigh+8             ;; 03AC87 : 8D DC 14    ;
                      PHX                                 ;; 03AC8A : DA          ;
                      LDX.B #$08                          ;; 03AC8B : A2 08       ;
                      JSL InitSpriteTables                ;; 03AC8D : 22 D2 F7 07 ;
                      PLX                                 ;; 03AC91 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BlushTileDispY:       db $01,$11                          ;; ?QPWZ?               ;
                                                          ;;                      ;
BlushTiles:           db $6E,$88                          ;; ?QPWZ?               ;
                                                          ;;                      ;
PrincessPeach:        LDA.B !SpriteXPosLow,X              ;; ?QPWZ? : B5 E4       ;
                      SEC                                 ;; 03AC99 : 38          ;
                      SBC.B !Layer1XPos                   ;; 03AC9A : E5 1A       ;
                      STA.B !_0                           ;; 03AC9C : 85 00       ;
                      LDA.B !SpriteYPosLow,X              ;; 03AC9E : B5 D8       ;
                      SEC                                 ;; 03ACA0 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03ACA1 : E5 1C       ;
                      STA.B !_1                           ;; 03ACA3 : 85 01       ;
                      LDA.B !TrueFrame                    ;; 03ACA5 : A5 13       ;
                      AND.B #$7F                          ;; 03ACA7 : 29 7F       ;
                      BNE CODE_03ACB8                     ;; 03ACA9 : D0 0D       ;
                      JSL GetRand                         ;; 03ACAB : 22 F9 AC 01 ;
                      AND.B #$07                          ;; 03ACAF : 29 07       ;
                      BNE CODE_03ACB8                     ;; 03ACB1 : D0 05       ;
                      LDA.B #$0C                          ;; 03ACB3 : A9 0C       ;
                      STA.W !SpriteMisc154C,X             ;; 03ACB5 : 9D 4C 15    ;
CODE_03ACB8:          LDY.W !SpriteMisc1602,X             ;; 03ACB8 : BC 02 16    ;
                      LDA.W !SpriteMisc154C,X             ;; 03ACBB : BD 4C 15    ;
                      BEQ CODE_03ACC1                     ;; 03ACBE : F0 01       ;
                      INY                                 ;; 03ACC0 : C8          ;
CODE_03ACC1:          LDA.W !SpriteMisc157C,X             ;; 03ACC1 : BD 7C 15    ;
                      BNE CODE_03ACCB                     ;; 03ACC4 : D0 05       ;
                      TYA                                 ;; 03ACC6 : 98          ;
                      CLC                                 ;; 03ACC7 : 18          ;
                      ADC.B #$08                          ;; 03ACC8 : 69 08       ;
                      TAY                                 ;; 03ACCA : A8          ;
CODE_03ACCB:          STY.B !_3                           ;; 03ACCB : 84 03       ;
                      LDA.B #$D0                          ;; 03ACCD : A9 D0       ;
                      STA.W !SpriteOAMIndex,X             ;; 03ACCF : 9D EA 15    ;
                      TAY                                 ;; 03ACD2 : A8          ;
                      JSR CODE_03AAC8                     ;; 03ACD3 : 20 C8 AA    ;
                      LDY.B #$02                          ;; 03ACD6 : A0 02       ;
                      LDA.B #$03                          ;; 03ACD8 : A9 03       ;
                      JSL FinishOAMWrite                  ;; 03ACDA : 22 B3 B7 01 ;
                      LDA.W !SpriteMisc1558,X             ;; 03ACDE : BD 58 15    ;
                      BEQ CODE_03AD18                     ;; 03ACE1 : F0 35       ;
                      PHX                                 ;; 03ACE3 : DA          ;
                      LDX.B #$00                          ;; 03ACE4 : A2 00       ;
                      LDA.B !Powerup                      ;; 03ACE6 : A5 19       ;
                      BNE CODE_03ACEB                     ;; 03ACE8 : D0 01       ;
                      INX                                 ;; 03ACEA : E8          ;
CODE_03ACEB:          LDY.B #$4C                          ;; 03ACEB : A0 4C       ;
                      LDA.B !PlayerXPosScrRel             ;; 03ACED : A5 7E       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03ACEF : 99 00 03    ;
                      LDA.B !PlayerYPosScrRel             ;; 03ACF2 : A5 80       ;
                      CLC                                 ;; 03ACF4 : 18          ;
                      ADC.W BlushTileDispY,X              ;; 03ACF5 : 7D 93 AC    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03ACF8 : 99 01 03    ;
                      LDA.W BlushTiles,X                  ;; 03ACFB : BD 95 AC    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03ACFE : 99 02 03    ;
                      PLX                                 ;; 03AD01 : FA          ;
                      LDA.B !PlayerDirection              ;; 03AD02 : A5 76       ;
                      CMP.B #$01                          ;; 03AD04 : C9 01       ;
                      LDA.B #$31                          ;; 03AD06 : A9 31       ;
                      BCC CODE_03AD0C                     ;; 03AD08 : 90 02       ;
                      ORA.B #$40                          ;; 03AD0A : 09 40       ;
CODE_03AD0C:          STA.W !OAMTileAttr+$100,Y           ;; 03AD0C : 99 03 03    ;
                      TYA                                 ;; 03AD0F : 98          ;
                      LSR A                               ;; 03AD10 : 4A          ;
                      LSR A                               ;; 03AD11 : 4A          ;
                      TAY                                 ;; 03AD12 : A8          ;
                      LDA.B #$02                          ;; 03AD13 : A9 02       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03AD15 : 99 60 04    ;
CODE_03AD18:          STZ.B !SpriteXSpeed,X               ;; 03AD18 : 74 B6       ; Sprite X Speed = 0 
                      STZ.B !PlayerXSpeed                 ;; 03AD1A : 64 7B       ;
                      LDA.B #$04                          ;; 03AD1C : A9 04       ;
                      STA.W !SpriteMisc1602,X             ;; 03AD1E : 9D 02 16    ;
                      LDA.B !SpriteTableC2,X              ;; 03AD21 : B5 C2       ;
                      JSL ExecutePtr                      ;; 03AD23 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03AD37                      ;; ?QPWZ? : 37 AD       ;
                      dw CODE_03ADB3                      ;; ?QPWZ? : B3 AD       ;
                      dw CODE_03ADDD                      ;; ?QPWZ? : DD AD       ;
                      dw CODE_03AE25                      ;; ?QPWZ? : 25 AE       ;
                      dw CODE_03AE32                      ;; ?QPWZ? : 32 AE       ;
                      dw CODE_03AEAF                      ;; ?QPWZ? : AF AE       ;
                      dw CODE_03AEE8                      ;; ?QPWZ? : E8 AE       ;
                      dw CODE_03C796                      ;; ?QPWZ? : 96 C7       ;
                                                          ;;                      ;
CODE_03AD37:          LDA.B #$06                          ;; 03AD37 : A9 06       ;
                      STA.W !SpriteMisc1602,X             ;; 03AD39 : 9D 02 16    ;
                      JSL UpdateYPosNoGvtyW               ;; 03AD3C : 22 1A 80 01 ;
                      LDA.B !SpriteYSpeed,X               ;; 03AD40 : B5 AA       ;
                      CMP.B #$08                          ;; 03AD42 : C9 08       ;
                      BCS CODE_03AD4B                     ;; 03AD44 : B0 05       ;
                      CLC                                 ;; 03AD46 : 18          ;
                      ADC.B #$01                          ;; 03AD47 : 69 01       ;
                      STA.B !SpriteYSpeed,X               ;; 03AD49 : 95 AA       ;
CODE_03AD4B:          LDA.W !SpriteXPosHigh,X             ;; 03AD4B : BD D4 14    ;
                      BMI CODE_03AD63                     ;; 03AD4E : 30 13       ;
                      LDA.B !SpriteYPosLow,X              ;; 03AD50 : B5 D8       ;
                      CMP.B #$A0                          ;; 03AD52 : C9 A0       ;
                      BCC CODE_03AD63                     ;; 03AD54 : 90 0D       ;
                      LDA.B #$A0                          ;; 03AD56 : A9 A0       ;
                      STA.B !SpriteYPosLow,X              ;; 03AD58 : 95 D8       ;
                      STZ.B !SpriteYSpeed,X               ;; 03AD5A : 74 AA       ; Sprite Y Speed = 0 
                      LDA.B #$A0                          ;; 03AD5C : A9 A0       ;
                      STA.W !SpriteMisc1540,X             ;; 03AD5E : 9D 40 15    ;
                      INC.B !SpriteTableC2,X              ;; 03AD61 : F6 C2       ;
CODE_03AD63:          LDA.B !TrueFrame                    ;; 03AD63 : A5 13       ;
                      AND.B #$07                          ;; 03AD65 : 29 07       ;
                      BNE Return03AD73                    ;; 03AD67 : D0 0A       ;
                      LDY.B #$0B                          ;; 03AD69 : A0 0B       ;
CODE_03AD6B:          LDA.W !MinExtSpriteNumber,Y         ;; 03AD6B : B9 F0 17    ;
                      BEQ CODE_03AD74                     ;; 03AD6E : F0 04       ;
                      DEY                                 ;; 03AD70 : 88          ;
                      BPL CODE_03AD6B                     ;; 03AD71 : 10 F8       ;
Return03AD73:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AD74:          LDA.B #$05                          ;; 03AD74 : A9 05       ;
                      STA.W !MinExtSpriteNumber,Y         ;; 03AD76 : 99 F0 17    ;
                      JSL GetRand                         ;; 03AD79 : 22 F9 AC 01 ;
                      STZ.B !_0                           ;; 03AD7D : 64 00       ;
                      AND.B #$1F                          ;; 03AD7F : 29 1F       ;
                      CLC                                 ;; 03AD81 : 18          ;
                      ADC.B #$F8                          ;; 03AD82 : 69 F8       ;
                      BPL CODE_03AD88                     ;; 03AD84 : 10 02       ;
                      DEC.B !_0                           ;; 03AD86 : C6 00       ;
CODE_03AD88:          CLC                                 ;; 03AD88 : 18          ;
                      ADC.B !SpriteXPosLow,X              ;; 03AD89 : 75 E4       ;
                      STA.W !MinExtSpriteXPosLow,Y        ;; 03AD8B : 99 08 18    ;
                      LDA.W !SpriteYPosHigh,X             ;; 03AD8E : BD E0 14    ;
                      ADC.B !_0                           ;; 03AD91 : 65 00       ;
                      STA.W !MinExtSpriteXPosHigh,Y       ;; 03AD93 : 99 EA 18    ;
                      LDA.W !RandomNumber+1               ;; 03AD96 : AD 8E 14    ;
                      AND.B #$1F                          ;; 03AD99 : 29 1F       ;
                      ADC.B !SpriteYPosLow,X              ;; 03AD9B : 75 D8       ;
                      STA.W !MinExtSpriteYPosLow,Y        ;; 03AD9D : 99 FC 17    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03ADA0 : BD D4 14    ;
                      ADC.B #$00                          ;; 03ADA3 : 69 00       ;
                      STA.W !MinExtSpriteYPosHigh,Y       ;; 03ADA5 : 99 14 18    ;
                      LDA.B #$00                          ;; 03ADA8 : A9 00       ;
                      STA.W !MinExtSpriteYSpeed,Y         ;; 03ADAA : 99 20 18    ;
                      LDA.B #$17                          ;; 03ADAD : A9 17       ;
                      STA.W !MinExtSpriteXPosSpx,Y        ;; 03ADAF : 99 50 18    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ADB3:          LDA.W !SpriteMisc1540,X             ;; 03ADB3 : BD 40 15    ;
                      BNE CODE_03ADC2                     ;; 03ADB6 : D0 0A       ;
                      INC.B !SpriteTableC2,X              ;; 03ADB8 : F6 C2       ;
                      JSR CODE_03ADCC                     ;; 03ADBA : 20 CC AD    ;
                      BCC CODE_03ADC2                     ;; 03ADBD : 90 03       ;
                      INC.W !SpriteMisc151C,X             ;; 03ADBF : FE 1C 15    ;
CODE_03ADC2:          JSR SubHorzPosBnk3                  ;; 03ADC2 : 20 17 B8    ;
                      TYA                                 ;; 03ADC5 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 03ADC6 : 9D 7C 15    ;
                      STA.B !PlayerDirection              ;; 03ADC9 : 85 76       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03ADCC:          JSL GetSpriteClippingA              ;; 03ADCC : 22 9F B6 03 ;
                      JSL GetMarioClipping                ;; 03ADD0 : 22 64 B6 03 ;
                      JSL CheckForContact                 ;; 03ADD4 : 22 2B B7 03 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03ADD9:          db $08,$F8,$F8,$08                  ;; 03ADD9               ;
                                                          ;;                      ;
CODE_03ADDD:          LDA.B !EffFrame                     ;; 03ADDD : A5 14       ;
                      AND.B #$08                          ;; 03ADDF : 29 08       ;
                      BNE CODE_03ADE8                     ;; 03ADE1 : D0 05       ;
                      LDA.B #$08                          ;; 03ADE3 : A9 08       ;
                      STA.W !SpriteMisc1602,X             ;; 03ADE5 : 9D 02 16    ;
CODE_03ADE8:          JSR CODE_03ADCC                     ;; 03ADE8 : 20 CC AD    ;
                      PHP                                 ;; 03ADEB : 08          ;
                      JSR SubHorzPosBnk3                  ;; 03ADEC : 20 17 B8    ;
                      PLP                                 ;; 03ADEF : 28          ;
                      LDA.W !SpriteMisc151C,X             ;; 03ADF0 : BD 1C 15    ;
                      BNE ADDR_03ADF9                     ;; 03ADF3 : D0 04       ;
                      BCS CODE_03AE14                     ;; 03ADF5 : B0 1D       ;
                      BRA CODE_03ADFF                     ;; 03ADF7 : 80 06       ;
                                                          ;;                      ;
ADDR_03ADF9:          BCC CODE_03AE14                     ;; 03ADF9 : 90 19       ;
                      TYA                                 ;; 03ADFB : 98          ;
                      EOR.B #$01                          ;; 03ADFC : 49 01       ;
                      TAY                                 ;; 03ADFE : A8          ;
CODE_03ADFF:          LDA.W DATA_03ADD9,Y                 ;; 03ADFF : B9 D9 AD    ;
                      STA.B !SpriteXSpeed,X               ;; 03AE02 : 95 B6       ;
                      EOR.B #$FF                          ;; 03AE04 : 49 FF       ;
                      INC A                               ;; 03AE06 : 1A          ;
                      STA.B !PlayerXSpeed                 ;; 03AE07 : 85 7B       ;
                      TYA                                 ;; 03AE09 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 03AE0A : 9D 7C 15    ;
                      STA.B !PlayerDirection              ;; 03AE0D : 85 76       ;
                      JSL UpdateXPosNoGvtyW               ;; 03AE0F : 22 22 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE14:          JSR SubHorzPosBnk3                  ;; 03AE14 : 20 17 B8    ;
                      TYA                                 ;; 03AE17 : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 03AE18 : 9D 7C 15    ;
                      STA.B !PlayerDirection              ;; 03AE1B : 85 76       ;
                      INC.B !SpriteTableC2,X              ;; 03AE1D : F6 C2       ;
                      LDA.B #$60                          ;; 03AE1F : A9 60       ;
                      STA.W !SpriteMisc1540,X             ;; 03AE21 : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE25:          LDA.W !SpriteMisc1540,X             ;; 03AE25 : BD 40 15    ;
                      BNE Return03AE31                    ;; 03AE28 : D0 07       ;
                      INC.B !SpriteTableC2,X              ;; 03AE2A : F6 C2       ;
                      LDA.B #$A0                          ;; 03AE2C : A9 A0       ;
                      STA.W !SpriteMisc1540,X             ;; 03AE2E : 9D 40 15    ;
Return03AE31:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AE32:          LDA.W !SpriteMisc1540,X             ;; 03AE32 : BD 40 15    ;
                      BNE CODE_03AE3F                     ;; 03AE35 : D0 08       ;
                      INC.B !SpriteTableC2,X              ;; 03AE37 : F6 C2       ;
                      STZ.W !Empty188A                    ;; 03AE39 : 9C 8A 18    ;
                      STZ.W !ScrShakePlayerYOffset        ;; 03AE3C : 9C 8B 18    ;
CODE_03AE3F:          CMP.B #$50                          ;; 03AE3F : C9 50       ;
                      BCC Return03AE5A                    ;; 03AE41 : 90 17       ;
                      PHA                                 ;; 03AE43 : 48          ;
                      BNE CODE_03AE4B                     ;; 03AE44 : D0 05       ;
                      LDA.B #$14                          ;; 03AE46 : A9 14       ;
                      STA.W !SpriteMisc154C,X             ;; 03AE48 : 9D 4C 15    ;
CODE_03AE4B:          LDA.B #$0A                          ;; 03AE4B : A9 0A       ;
                      STA.W !SpriteMisc1602,X             ;; 03AE4D : 9D 02 16    ;
                      PLA                                 ;; 03AE50 : 68          ;
                      CMP.B #$68                          ;; 03AE51 : C9 68       ;
                      BNE Return03AE5A                    ;; 03AE53 : D0 05       ;
                      LDA.B #$80                          ;; 03AE55 : A9 80       ;
                      STA.W !SpriteMisc1558,X             ;; 03AE57 : 9D 58 15    ;
Return03AE5A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AE5B:          db $08,$08,$08,$08,$08,$08,$18,$08  ;; 03AE5B               ;
                      db $08,$08,$08,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$08,$08,$20,$08  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$20,$08,$08,$10  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $20,$08,$08,$08,$08,$08,$20,$08  ;; ?QPWZ?               ;
                      db $04,$20,$08,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$08,$08,$10,$08  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $08,$08,$10,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $08,$08,$08,$40                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AEAF:          JSR CODE_03D674                     ;; 03AEAF : 20 74 D6    ;
                      LDA.W !SpriteMisc1540,X             ;; 03AEB2 : BD 40 15    ;
                      BNE Return03AEC7                    ;; 03AEB5 : D0 10       ;
                      LDY.W !FinalMessageTimer            ;; 03AEB7 : AC 21 19    ;
                      CPY.B #$54                          ;; 03AEBA : C0 54       ;
                      BEQ CODE_03AEC8                     ;; 03AEBC : F0 0A       ;
                      INC.W !FinalMessageTimer            ;; 03AEBE : EE 21 19    ;
                      LDA.W DATA_03AE5B,Y                 ;; 03AEC1 : B9 5B AE    ;
                      STA.W !SpriteMisc1540,X             ;; 03AEC4 : 9D 40 15    ;
Return03AEC7:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AEC8:          INC.B !SpriteTableC2,X              ;; 03AEC8 : F6 C2       ;
                      LDA.B #$40                          ;; 03AECA : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 03AECC : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03AED0:          INC.B !SpriteTableC2,X              ;; 03AED0 : F6 C2       ;
                      LDA.B #$80                          ;; 03AED2 : A9 80       ;
                      STA.W !SpriteMisc1FE2+9             ;; 03AED4 : 8D EB 1F    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
                      db $00,$00,$94,$18,$18,$9C,$9C,$FF  ;; 03AED8               ;
                      db $00,$00,$52,$63,$63,$73,$73,$7F  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AEE8:          LDA.W !SpriteMisc1540,X             ;; 03AEE8 : BD 40 15    ;
                      BEQ CODE_03AED0                     ;; 03AEEB : F0 E3       ;
                      LSR A                               ;; 03AEED : 4A          ;
                      STA.B !_0                           ;; 03AEEE : 85 00       ;
                      STZ.B !_1                           ;; 03AEF0 : 64 01       ;
                      REP #$20                            ;; 03AEF2 : C2 20       ; Accum (16 bit) 
                      LDA.B !_0                           ;; 03AEF4 : A5 00       ;
                      ASL A                               ;; 03AEF6 : 0A          ;
                      ASL A                               ;; 03AEF7 : 0A          ;
                      ASL A                               ;; 03AEF8 : 0A          ;
                      ASL A                               ;; 03AEF9 : 0A          ;
                      ASL A                               ;; 03AEFA : 0A          ;
                      ORA.B !_0                           ;; 03AEFB : 05 00       ;
                      STA.B !_0                           ;; 03AEFD : 85 00       ;
                      ASL A                               ;; 03AEFF : 0A          ;
                      ASL A                               ;; 03AF00 : 0A          ;
                      ASL A                               ;; 03AF01 : 0A          ;
                      ASL A                               ;; 03AF02 : 0A          ;
                      ASL A                               ;; 03AF03 : 0A          ;
                      ORA.B !_0                           ;; 03AF04 : 05 00       ;
                      STA.B !_0                           ;; 03AF06 : 85 00       ;
                      SEP #$20                            ;; 03AF08 : E2 20       ; Accum (8 bit) 
                      PHX                                 ;; 03AF0A : DA          ;
                      TAX                                 ;; 03AF0B : AA          ;
                      LDY.W !DynPaletteIndex              ;; 03AF0C : AC 81 06    ;
                      LDA.B #$02                          ;; 03AF0F : A9 02       ;
                      STA.W !DynPaletteTable,Y            ;; 03AF11 : 99 82 06    ;
                      LDA.B #$F1                          ;; 03AF14 : A9 F1       ;
                      STA.W !DynPaletteTable+1,Y          ;; 03AF16 : 99 83 06    ;
                      LDA.B !_0                           ;; 03AF19 : A5 00       ;
                      STA.W !DynPaletteTable+2,Y          ;; 03AF1B : 99 84 06    ;
                      LDA.B !_1                           ;; 03AF1E : A5 01       ;
                      STA.W !DynPaletteTable+3,Y          ;; 03AF20 : 99 85 06    ;
                      LDA.B #$00                          ;; 03AF23 : A9 00       ;
                      STA.W !DynPaletteTable+4,Y          ;; 03AF25 : 99 86 06    ;
                      TYA                                 ;; 03AF28 : 98          ;
                      CLC                                 ;; 03AF29 : 18          ;
                      ADC.B #$04                          ;; 03AF2A : 69 04       ;
                      STA.W !DynPaletteIndex              ;; 03AF2C : 8D 81 06    ;
                      PLX                                 ;; 03AF2F : FA          ;
                      JSR CODE_03D674                     ;; 03AF30 : 20 74 D6    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03AF34:          db $F4,$FF,$0C,$19,$24,$19,$0C,$FF  ;; 03AF34               ;
DATA_03AF3C:          db $FC,$F6,$F4,$F6,$FC,$02,$04,$02  ;; 03AF3C               ;
DATA_03AF44:          db $05,$05,$05,$05,$45,$45,$45,$45  ;; 03AF44               ;
DATA_03AF4C:          db $34,$34,$34,$35,$35,$36,$36,$37  ;; 03AF4C               ;
                      db $38,$3A,$3E,$46,$54              ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03AF59:          JSR GetDrawInfoBnk3                 ;; 03AF59 : 20 60 B7    ;
                      LDA.W !SpriteMisc157C,X             ;; 03AF5C : BD 7C 15    ;
                      STA.B !_4                           ;; 03AF5F : 85 04       ;
                      LDA.B !EffFrame                     ;; 03AF61 : A5 14       ;
                      LSR A                               ;; 03AF63 : 4A          ;
                      LSR A                               ;; 03AF64 : 4A          ;
                      AND.B #$07                          ;; 03AF65 : 29 07       ;
                      STA.B !_2                           ;; 03AF67 : 85 02       ;
                      LDA.B #$EC                          ;; 03AF69 : A9 EC       ;
                      STA.W !SpriteOAMIndex,X             ;; 03AF6B : 9D EA 15    ;
                      TAY                                 ;; 03AF6E : A8          ;
                      PHX                                 ;; 03AF6F : DA          ;
                      LDX.B #$03                          ;; 03AF70 : A2 03       ;
CODE_03AF72:          PHX                                 ;; 03AF72 : DA          ;
                      TXA                                 ;; 03AF73 : 8A          ;
                      ASL A                               ;; 03AF74 : 0A          ;
                      ASL A                               ;; 03AF75 : 0A          ;
                      ADC.B !_2                           ;; 03AF76 : 65 02       ;
                      AND.B #$07                          ;; 03AF78 : 29 07       ;
                      TAX                                 ;; 03AF7A : AA          ;
                      LDA.B !_0                           ;; 03AF7B : A5 00       ;
                      CLC                                 ;; 03AF7D : 18          ;
                      ADC.W DATA_03AF34,X                 ;; 03AF7E : 7D 34 AF    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03AF81 : 99 00 03    ;
                      LDA.B !_1                           ;; 03AF84 : A5 01       ;
                      CLC                                 ;; 03AF86 : 18          ;
                      ADC.W DATA_03AF3C,X                 ;; 03AF87 : 7D 3C AF    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03AF8A : 99 01 03    ;
                      LDA.B #$59                          ;; 03AF8D : A9 59       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03AF8F : 99 02 03    ;
                      LDA.W DATA_03AF44,X                 ;; 03AF92 : BD 44 AF    ;
                      ORA.B !SpriteProperties             ;; 03AF95 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03AF97 : 99 03 03    ;
                      PLX                                 ;; 03AF9A : FA          ;
                      INY                                 ;; 03AF9B : C8          ;
                      INY                                 ;; 03AF9C : C8          ;
                      INY                                 ;; 03AF9D : C8          ;
                      INY                                 ;; 03AF9E : C8          ;
                      DEX                                 ;; 03AF9F : CA          ;
                      BPL CODE_03AF72                     ;; 03AFA0 : 10 D0       ;
                      LDA.W !BrSwingCenterYPos+1          ;; 03AFA2 : AD B3 14    ;
                      INC.W !BrSwingCenterYPos+1          ;; 03AFA5 : EE B3 14    ;
                      LSR A                               ;; 03AFA8 : 4A          ;
                      LSR A                               ;; 03AFA9 : 4A          ;
                      LSR A                               ;; 03AFAA : 4A          ;
                      CMP.B #$0D                          ;; 03AFAB : C9 0D       ;
                      BCS CODE_03AFD7                     ;; 03AFAD : B0 28       ;
                      TAX                                 ;; 03AFAF : AA          ;
                      LDY.B #$FC                          ;; 03AFB0 : A0 FC       ;
                      LDA.B !_4                           ;; 03AFB2 : A5 04       ;
                      ASL A                               ;; 03AFB4 : 0A          ;
                      ROL A                               ;; 03AFB5 : 2A          ;
                      ASL A                               ;; 03AFB6 : 0A          ;
                      ASL A                               ;; 03AFB7 : 0A          ;
                      ASL A                               ;; 03AFB8 : 0A          ;
                      ADC.B !_0                           ;; 03AFB9 : 65 00       ;
                      CLC                                 ;; 03AFBB : 18          ;
                      ADC.B #$15                          ;; 03AFBC : 69 15       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03AFBE : 99 00 03    ;
                      LDA.B !_1                           ;; 03AFC1 : A5 01       ;
                      CLC                                 ;; 03AFC3 : 18          ;
                      ADC.L DATA_03AF4C,X                 ;; 03AFC4 : 7F 4C AF 03 ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03AFC8 : 99 01 03    ;
                      LDA.B #$49                          ;; 03AFCB : A9 49       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03AFCD : 99 02 03    ;
                      LDA.B #$07                          ;; 03AFD0 : A9 07       ;
                      ORA.B !SpriteProperties             ;; 03AFD2 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03AFD4 : 99 03 03    ;
CODE_03AFD7:          PLX                                 ;; 03AFD7 : FA          ;
                      LDY.B #$00                          ;; 03AFD8 : A0 00       ;
                      LDA.B #$04                          ;; 03AFDA : A9 04       ;
                      JSL FinishOAMWrite                  ;; 03AFDC : 22 B3 B7 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 03AFE0 : BC EA 15    ; Y = Index into sprite OAM 
                      PHX                                 ;; 03AFE3 : DA          ;
                      LDX.B #$04                          ;; 03AFE4 : A2 04       ;
CODE_03AFE6:          LDA.W !OAMTileXPos+$100,Y           ;; 03AFE6 : B9 00 03    ;
                      STA.W !OAMTileXPos,Y                ;; 03AFE9 : 99 00 02    ;
                      LDA.W !OAMTileYPos+$100,Y           ;; 03AFEC : B9 01 03    ;
                      STA.W !OAMTileYPos,Y                ;; 03AFEF : 99 01 02    ;
                      LDA.W !OAMTileNo+$100,Y             ;; 03AFF2 : B9 02 03    ;
                      STA.W !OAMTileNo,Y                  ;; 03AFF5 : 99 02 02    ;
                      LDA.W !OAMTileAttr+$100,Y           ;; 03AFF8 : B9 03 03    ;
                      STA.W !OAMTileAttr,Y                ;; 03AFFB : 99 03 02    ;
                      PHY                                 ;; 03AFFE : 5A          ;
                      TYA                                 ;; 03AFFF : 98          ;
                      LSR A                               ;; 03B000 : 4A          ;
                      LSR A                               ;; 03B001 : 4A          ;
                      TAY                                 ;; 03B002 : A8          ;
                      LDA.W !OAMTileSize+$40,Y            ;; 03B003 : B9 60 04    ;
                      STA.W !OAMTileSize,Y                ;; 03B006 : 99 20 04    ;
                      PLY                                 ;; 03B009 : 7A          ;
                      INY                                 ;; 03B00A : C8          ;
                      INY                                 ;; 03B00B : C8          ;
                      INY                                 ;; 03B00C : C8          ;
                      INY                                 ;; 03B00D : C8          ;
                      DEX                                 ;; 03B00E : CA          ;
                      BPL CODE_03AFE6                     ;; 03B00F : 10 D5       ;
                      PLX                                 ;; 03B011 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B013:          db $00,$10                          ;; 03B013               ;
                                                          ;;                      ;
DATA_03B015:          db $00,$00                          ;; 03B015               ;
                                                          ;;                      ;
DATA_03B017:          db $F8,$08                          ;; 03B017               ;
                                                          ;;                      ;
CODE_03B019:          STZ.B !_2                           ;; 03B019 : 64 02       ;
                      JSR CODE_03B020                     ;; 03B01B : 20 20 B0    ;
                      INC.B !_2                           ;; 03B01E : E6 02       ;
CODE_03B020:          LDY.B #$01                          ;; 03B020 : A0 01       ;
CODE_03B022:          LDA.W !SpriteStatus,Y               ;; 03B022 : B9 C8 14    ;
                      BEQ CODE_03B02B                     ;; 03B025 : F0 04       ;
                      DEY                                 ;; 03B027 : 88          ;
                      BPL CODE_03B022                     ;; 03B028 : 10 F8       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B02B:          LDA.B #$08                          ;; 03B02B : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03B02D : 99 C8 14    ; / 
                      LDA.B #$A2                          ;; 03B030 : A9 A2       ;
                      STA.W !SpriteNumber,Y               ;; 03B032 : 99 9E 00    ;
                      LDA.B !SpriteYPosLow,X              ;; 03B035 : B5 D8       ;
                      CLC                                 ;; 03B037 : 18          ;
                      ADC.B #$10                          ;; 03B038 : 69 10       ;
                      STA.W !SpriteYPosLow,Y              ;; 03B03A : 99 D8 00    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03B03D : BD D4 14    ;
                      ADC.B #$00                          ;; 03B040 : 69 00       ;
                      STA.W !SpriteXPosHigh,Y             ;; 03B042 : 99 D4 14    ;
                      LDA.B !SpriteXPosLow,X              ;; 03B045 : B5 E4       ;
                      STA.B !_0                           ;; 03B047 : 85 00       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03B049 : BD E0 14    ;
                      STA.B !_1                           ;; 03B04C : 85 01       ;
                      PHX                                 ;; 03B04E : DA          ;
                      LDX.B !_2                           ;; 03B04F : A6 02       ;
                      LDA.B !_0                           ;; 03B051 : A5 00       ;
                      CLC                                 ;; 03B053 : 18          ;
                      ADC.W DATA_03B013,X                 ;; 03B054 : 7D 13 B0    ;
                      STA.W !SpriteXPosLow,Y              ;; 03B057 : 99 E4 00    ;
                      LDA.B !_1                           ;; 03B05A : A5 01       ;
                      ADC.W DATA_03B015,X                 ;; 03B05C : 7D 15 B0    ;
                      STA.W !SpriteYPosHigh,Y             ;; 03B05F : 99 E0 14    ;
                      TYX                                 ;; 03B062 : BB          ;
                      JSL InitSpriteTables                ;; 03B063 : 22 D2 F7 07 ;
                      LDY.B !_2                           ;; 03B067 : A4 02       ;
                      LDA.W DATA_03B017,Y                 ;; 03B069 : B9 17 B0    ;
                      STA.B !SpriteXSpeed,X               ;; 03B06C : 95 B6       ;
                      LDA.B #$C0                          ;; 03B06E : A9 C0       ;
                      STA.B !SpriteYSpeed,X               ;; 03B070 : 95 AA       ;
                      PLX                                 ;; 03B072 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B074:          db $40,$C0                          ;; 03B074               ;
                                                          ;;                      ;
DATA_03B076:          db $10,$F0                          ;; 03B076               ;
                                                          ;;                      ;
CODE_03B078:          LDA.B !Mode7XScale                  ;; 03B078 : A5 38       ;
                      CMP.B #$20                          ;; 03B07A : C9 20       ;
                      BNE Return03B0DB                    ;; 03B07C : D0 5D       ;
                      LDA.W !SpriteMisc151C,X             ;; 03B07E : BD 1C 15    ;
                      CMP.B #$07                          ;; 03B081 : C9 07       ;
                      BCC Return03B0F2                    ;; 03B083 : 90 6D       ;
                      LDA.B !Mode7Angle                   ;; 03B085 : A5 36       ;
                      ORA.B !Mode7Angle+1                 ;; 03B087 : 05 37       ;
                      BNE Return03B0F2                    ;; 03B089 : D0 67       ;
                      JSR CODE_03B0DC                     ;; 03B08B : 20 DC B0    ;
                      LDA.W !SpriteMisc154C,X             ;; 03B08E : BD 4C 15    ;
                      BNE Return03B0DB                    ;; 03B091 : D0 48       ;
                      LDA.B #$24                          ;; 03B093 : A9 24       ;
                      STA.W !SpriteTweakerB,X             ;; 03B095 : 9D 62 16    ;
                      JSL MarioSprInteract                ;; 03B098 : 22 DC A7 01 ;
                      BCC CODE_03B0BD                     ;; 03B09C : 90 1F       ;
                      JSR CODE_03B0D6                     ;; 03B09E : 20 D6 B0    ;
                      STZ.B !PlayerYSpeed                 ;; 03B0A1 : 64 7D       ;
                      JSR SubHorzPosBnk3                  ;; 03B0A3 : 20 17 B8    ;
                      LDA.W !BrSwingCenterXPos+1          ;; 03B0A6 : AD B1 14    ;
                      ORA.W !BrSwingYDist                 ;; 03B0A9 : 0D B6 14    ;
                      BEQ CODE_03B0B3                     ;; 03B0AC : F0 05       ;
                      LDA.W DATA_03B076,Y                 ;; 03B0AE : B9 76 B0    ;
                      BRA CODE_03B0B6                     ;; 03B0B1 : 80 03       ;
                                                          ;;                      ;
CODE_03B0B3:          LDA.W DATA_03B074,Y                 ;; 03B0B3 : B9 74 B0    ;
CODE_03B0B6:          STA.B !PlayerXSpeed                 ;; 03B0B6 : 85 7B       ;
                      LDA.B #$01                          ;; 03B0B8 : A9 01       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03B0BA : 8D F9 1D    ; / 
CODE_03B0BD:          INC.W !SpriteTweakerB,X             ;; 03B0BD : FE 62 16    ;
                      JSL MarioSprInteract                ;; 03B0C0 : 22 DC A7 01 ;
                      BCC CODE_03B0C9                     ;; 03B0C4 : 90 03       ;
                      JSR CODE_03B0D2                     ;; 03B0C6 : 20 D2 B0    ;
CODE_03B0C9:          INC.W !SpriteTweakerB,X             ;; 03B0C9 : FE 62 16    ;
                      JSL MarioSprInteract                ;; 03B0CC : 22 DC A7 01 ;
                      BCC Return03B0DB                    ;; 03B0D0 : 90 09       ;
CODE_03B0D2:          JSL HurtMario                       ;; 03B0D2 : 22 B7 F5 00 ;
CODE_03B0D6:          LDA.B #$20                          ;; 03B0D6 : A9 20       ;
                      STA.W !SpriteMisc154C,X             ;; 03B0D8 : 9D 4C 15    ;
Return03B0DB:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B0DC:          LDY.B #$01                          ;; 03B0DC : A0 01       ;
CODE_03B0DE:          PHY                                 ;; 03B0DE : 5A          ;
                      LDA.W !SpriteStatus,Y               ;; 03B0DF : B9 C8 14    ;
                      CMP.B #$09                          ;; 03B0E2 : C9 09       ;
                      BNE CODE_03B0EE                     ;; 03B0E4 : D0 08       ;
                      LDA.W !SpriteOffscreenX,Y           ;; 03B0E6 : B9 A0 15    ;
                      BNE CODE_03B0EE                     ;; 03B0E9 : D0 03       ;
                      JSR CODE_03B0F3                     ;; 03B0EB : 20 F3 B0    ;
CODE_03B0EE:          PLY                                 ;; 03B0EE : 7A          ;
                      DEY                                 ;; 03B0EF : 88          ;
                      BPL CODE_03B0DE                     ;; 03B0F0 : 10 EC       ;
Return03B0F2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B0F3:          PHX                                 ;; 03B0F3 : DA          ;
                      TYX                                 ;; 03B0F4 : BB          ;
                      JSL GetSpriteClippingB              ;; 03B0F5 : 22 E5 B6 03 ;
                      PLX                                 ;; 03B0F9 : FA          ;
                      LDA.B #$24                          ;; 03B0FA : A9 24       ;
                      STA.W !SpriteTweakerB,X             ;; 03B0FC : 9D 62 16    ;
                      JSL GetSpriteClippingA              ;; 03B0FF : 22 9F B6 03 ;
                      JSL CheckForContact                 ;; 03B103 : 22 2B B7 03 ;
                      BCS CODE_03B142                     ;; 03B107 : B0 39       ;
                      INC.W !SpriteTweakerB,X             ;; 03B109 : FE 62 16    ;
                      JSL GetSpriteClippingA              ;; 03B10C : 22 9F B6 03 ;
                      JSL CheckForContact                 ;; 03B110 : 22 2B B7 03 ;
                      BCC Return03B160                    ;; 03B114 : 90 4A       ;
                      LDA.W !BrSwingXDist+1               ;; 03B116 : AD B5 14    ;
                      BNE Return03B160                    ;; 03B119 : D0 45       ;
                      LDA.B #$4C                          ;; 03B11B : A9 4C       ;
                      STA.W !BrSwingXDist+1               ;; 03B11D : 8D B5 14    ;
                      STZ.W !BrSwingCenterYPos+1          ;; 03B120 : 9C B3 14    ;
                      LDA.W !SpriteMisc151C,X             ;; 03B123 : BD 1C 15    ;
                      STA.W !BrSwingXDist                 ;; 03B126 : 8D B4 14    ;
                      LDA.B #$28                          ;; 03B129 : A9 28       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03B12B : 8D FC 1D    ; / 
                      LDA.W !SpriteMisc151C,X             ;; 03B12E : BD 1C 15    ;
                      CMP.B #$09                          ;; 03B131 : C9 09       ;
                      BNE CODE_03B142                     ;; 03B133 : D0 0D       ;
                      LDA.W !SpriteMisc187B,X             ;; 03B135 : BD 7B 18    ;
                      CMP.B #$01                          ;; 03B138 : C9 01       ;
                      BNE CODE_03B142                     ;; 03B13A : D0 06       ;
                      PHY                                 ;; 03B13C : 5A          ;
                      JSL KillMostSprites                 ;; 03B13D : 22 C8 A6 03 ;
                      PLY                                 ;; 03B141 : 7A          ;
CODE_03B142:          LDA.B #$00                          ;; 03B142 : A9 00       ;
                      STA.W !SpriteXSpeed,Y               ;; 03B144 : 99 B6 00    ;
                      PHX                                 ;; 03B147 : DA          ;
                      LDX.B #$10                          ;; 03B148 : A2 10       ;
                      LDA.W !SpriteYSpeed,Y               ;; 03B14A : B9 AA 00    ;
                      BMI CODE_03B151                     ;; 03B14D : 30 02       ;
                      LDX.B #$D0                          ;; 03B14F : A2 D0       ;
CODE_03B151:          TXA                                 ;; 03B151 : 8A          ;
                      STA.W !SpriteYSpeed,Y               ;; 03B152 : 99 AA 00    ;
                      LDA.B #$02                          ;; 03B155 : A9 02       ; \ Sprite status = Killed 
                      STA.W !SpriteStatus,Y               ;; 03B157 : 99 C8 14    ; / 
                      TYX                                 ;; 03B15A : BB          ;
                      JSL CODE_01AB6F                     ;; 03B15B : 22 6F AB 01 ;
                      PLX                                 ;; 03B15F : FA          ;
Return03B160:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserBallSpeed:      db $10,$F0                          ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBowlingBall:    JSR BowserBallGfx                   ;; ?QPWZ? : 20 21 B2    ;
                      LDA.B !SpriteLock                   ;; 03B166 : A5 9D       ;
                      BNE Return03B1D4                    ;; 03B168 : D0 6A       ;
                      JSR SubOffscreen0Bnk3               ;; 03B16A : 20 5D B8    ;
                      JSL MarioSprInteract                ;; 03B16D : 22 DC A7 01 ;
                      JSL UpdateXPosNoGvtyW               ;; 03B171 : 22 22 80 01 ;
                      JSL UpdateYPosNoGvtyW               ;; 03B175 : 22 1A 80 01 ;
                      LDA.B !SpriteYSpeed,X               ;; 03B179 : B5 AA       ;
                      CMP.B #$40                          ;; 03B17B : C9 40       ;
                      BPL CODE_03B186                     ;; 03B17D : 10 07       ;
                      CLC                                 ;; 03B17F : 18          ;
                      ADC.B #$03                          ;; 03B180 : 69 03       ;
                      STA.B !SpriteYSpeed,X               ;; 03B182 : 95 AA       ;
                      BRA CODE_03B18A                     ;; 03B184 : 80 04       ;
                                                          ;;                      ;
CODE_03B186:          LDA.B #$40                          ;; 03B186 : A9 40       ;
                      STA.B !SpriteYSpeed,X               ;; 03B188 : 95 AA       ;
CODE_03B18A:          LDA.B !SpriteYSpeed,X               ;; 03B18A : B5 AA       ;
                      BMI CODE_03B1C5                     ;; 03B18C : 30 37       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03B18E : BD D4 14    ;
                      BMI CODE_03B1C5                     ;; 03B191 : 30 32       ;
                      LDA.B !SpriteYPosLow,X              ;; 03B193 : B5 D8       ;
                      CMP.B #$B0                          ;; 03B195 : C9 B0       ;
                      BCC CODE_03B1C5                     ;; 03B197 : 90 2C       ;
                      LDA.B #$B0                          ;; 03B199 : A9 B0       ;
                      STA.B !SpriteYPosLow,X              ;; 03B19B : 95 D8       ;
                      LDA.B !SpriteYSpeed,X               ;; 03B19D : B5 AA       ;
                      CMP.B #$3E                          ;; 03B19F : C9 3E       ;
                      BCC CODE_03B1AD                     ;; 03B1A1 : 90 0A       ;
                      LDY.B #$25                          ;; 03B1A3 : A0 25       ; \ Play sound effect 
                      STY.W !SPCIO3                       ;; 03B1A5 : 8C FC 1D    ; / 
                      LDY.B #$20                          ;; 03B1A8 : A0 20       ; \ Set ground shake timer 
                      STY.W !ScreenShakeTimer             ;; 03B1AA : 8C 87 18    ; / 
CODE_03B1AD:          CMP.B #$08                          ;; 03B1AD : C9 08       ;
                      BCC CODE_03B1B6                     ;; 03B1AF : 90 05       ;
                      LDA.B #$01                          ;; 03B1B1 : A9 01       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03B1B3 : 8D F9 1D    ; / 
CODE_03B1B6:          JSR CODE_03B7F8                     ;; 03B1B6 : 20 F8 B7    ;
                      LDA.B !SpriteXSpeed,X               ;; 03B1B9 : B5 B6       ;
                      BNE CODE_03B1C5                     ;; 03B1BB : D0 08       ;
                      JSR SubHorzPosBnk3                  ;; 03B1BD : 20 17 B8    ;
                      LDA.W BowserBallSpeed,Y             ;; 03B1C0 : B9 61 B1    ;
                      STA.B !SpriteXSpeed,X               ;; 03B1C3 : 95 B6       ;
CODE_03B1C5:          LDA.B !SpriteXSpeed,X               ;; 03B1C5 : B5 B6       ;
                      BEQ Return03B1D4                    ;; 03B1C7 : F0 0B       ;
                      BMI CODE_03B1D1                     ;; 03B1C9 : 30 06       ;
                      DEC.W !SpriteMisc1570,X             ;; 03B1CB : DE 70 15    ;
                      DEC.W !SpriteMisc1570,X             ;; 03B1CE : DE 70 15    ;
CODE_03B1D1:          INC.W !SpriteMisc1570,X             ;; 03B1D1 : FE 70 15    ;
Return03B1D4:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserBallDispX:      db $F0,$00,$10,$F0,$00,$10,$F0,$00  ;; ?QPWZ?               ;
                      db $10,$00,$00,$F8                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallDispY:      db $E2,$E2,$E2,$F2,$F2,$F2,$02,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$EA                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallTiles:      db $45,$47,$45,$65,$66,$65,$45,$47  ;; ?QPWZ?               ;
                      db $45,$39,$38,$63                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallGfxProp:    db $0D,$0D,$4D,$0D,$0D,$4D,$8D,$8D  ;; ?QPWZ?               ;
                      db $CD,$0D,$0D,$0D                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallTileSize:   db $02,$02,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $02,$00,$00,$02                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallDispX2:     db $04,$0D,$10,$0D,$04,$FB,$F8,$FB  ;; ?QPWZ?               ;
BowserBallDispY2:     db $00,$FD,$F4,$EB,$E8,$EB,$F4,$FD  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserBallGfx:        LDA.B #$70                          ;; ?QPWZ? : A9 70       ;
                      STA.W !SpriteOAMIndex,X             ;; 03B223 : 9D EA 15    ;
                      JSR GetDrawInfoBnk3                 ;; 03B226 : 20 60 B7    ;
                      PHX                                 ;; 03B229 : DA          ;
                      LDX.B #$0B                          ;; 03B22A : A2 0B       ;
CODE_03B22C:          LDA.B !_0                           ;; 03B22C : A5 00       ;
                      CLC                                 ;; 03B22E : 18          ;
                      ADC.W BowserBallDispX,X             ;; 03B22F : 7D D5 B1    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03B232 : 99 00 03    ;
                      LDA.B !_1                           ;; 03B235 : A5 01       ;
                      CLC                                 ;; 03B237 : 18          ;
                      ADC.W BowserBallDispY,X             ;; 03B238 : 7D E1 B1    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03B23B : 99 01 03    ;
                      LDA.W BowserBallTiles,X             ;; 03B23E : BD ED B1    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03B241 : 99 02 03    ;
                      LDA.W BowserBallGfxProp,X           ;; 03B244 : BD F9 B1    ;
                      ORA.B !SpriteProperties             ;; 03B247 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03B249 : 99 03 03    ;
                      PHY                                 ;; 03B24C : 5A          ;
                      TYA                                 ;; 03B24D : 98          ;
                      LSR A                               ;; 03B24E : 4A          ;
                      LSR A                               ;; 03B24F : 4A          ;
                      TAY                                 ;; 03B250 : A8          ;
                      LDA.W BowserBallTileSize,X          ;; 03B251 : BD 05 B2    ;
                      STA.W !OAMTileSize+$40,Y            ;; 03B254 : 99 60 04    ;
                      PLY                                 ;; 03B257 : 7A          ;
                      INY                                 ;; 03B258 : C8          ;
                      INY                                 ;; 03B259 : C8          ;
                      INY                                 ;; 03B25A : C8          ;
                      INY                                 ;; 03B25B : C8          ;
                      DEX                                 ;; 03B25C : CA          ;
                      BPL CODE_03B22C                     ;; 03B25D : 10 CD       ;
                      PLX                                 ;; 03B25F : FA          ;
                      PHX                                 ;; 03B260 : DA          ;
                      LDY.W !SpriteOAMIndex,X             ;; 03B261 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.W !SpriteMisc1570,X             ;; 03B264 : BD 70 15    ;
                      LSR A                               ;; 03B267 : 4A          ;
                      LSR A                               ;; 03B268 : 4A          ;
                      LSR A                               ;; 03B269 : 4A          ;
                      AND.B #$07                          ;; 03B26A : 29 07       ;
                      PHA                                 ;; 03B26C : 48          ;
                      TAX                                 ;; 03B26D : AA          ;
                      LDA.W !OAMTileXPos+$104,Y           ;; 03B26E : B9 04 03    ;
                      CLC                                 ;; 03B271 : 18          ;
                      ADC.W BowserBallDispX2,X            ;; 03B272 : 7D 11 B2    ;
                      STA.W !OAMTileXPos+$104,Y           ;; 03B275 : 99 04 03    ;
                      LDA.W !OAMTileYPos+$104,Y           ;; 03B278 : B9 05 03    ;
                      CLC                                 ;; 03B27B : 18          ;
                      ADC.W BowserBallDispY2,X            ;; 03B27C : 7D 19 B2    ;
                      STA.W !OAMTileYPos+$104,Y           ;; 03B27F : 99 05 03    ;
                      PLA                                 ;; 03B282 : 68          ;
                      CLC                                 ;; 03B283 : 18          ;
                      ADC.B #$02                          ;; 03B284 : 69 02       ;
                      AND.B #$07                          ;; 03B286 : 29 07       ;
                      TAX                                 ;; 03B288 : AA          ;
                      LDA.W !OAMTileXPos+$108,Y           ;; 03B289 : B9 08 03    ;
                      CLC                                 ;; 03B28C : 18          ;
                      ADC.W BowserBallDispX2,X            ;; 03B28D : 7D 11 B2    ;
                      STA.W !OAMTileXPos+$108,Y           ;; 03B290 : 99 08 03    ;
                      LDA.W !OAMTileYPos+$108,Y           ;; 03B293 : B9 09 03    ;
                      CLC                                 ;; 03B296 : 18          ;
                      ADC.W BowserBallDispY2,X            ;; 03B297 : 7D 19 B2    ;
                      STA.W !OAMTileYPos+$108,Y           ;; 03B29A : 99 09 03    ;
                      PLX                                 ;; 03B29D : FA          ;
                      LDA.B #$0B                          ;; 03B29E : A9 0B       ;
                      LDY.B #$FF                          ;; 03B2A0 : A0 FF       ;
                      JSL FinishOAMWrite                  ;; 03B2A2 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechakoopaSpeed:      db $08,$F8                          ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopa:           JSL CODE_03B307                     ;; ?QPWZ? : 22 07 B3 03 ;
                      LDA.W !SpriteStatus,X               ;; 03B2AD : BD C8 14    ;
                      CMP.B #$08                          ;; 03B2B0 : C9 08       ;
                      BNE Return03B306                    ;; 03B2B2 : D0 52       ;
                      LDA.B !SpriteLock                   ;; 03B2B4 : A5 9D       ;
                      BNE Return03B306                    ;; 03B2B6 : D0 4E       ;
                      JSR SubOffscreen0Bnk3               ;; 03B2B8 : 20 5D B8    ;
                      JSL SprSpr_MarioSprRts              ;; 03B2BB : 22 3A 80 01 ;
                      JSL UpdateSpritePos                 ;; 03B2BF : 22 2A 80 01 ;
                      LDA.W !SpriteBlockedDirs,X          ;; 03B2C3 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 03B2C6 : 29 04       ;  | 
                      BEQ CODE_03B2E3                     ;; 03B2C8 : F0 19       ; / 
                      STZ.B !SpriteYSpeed,X               ;; 03B2CA : 74 AA       ; Sprite Y Speed = 0 
                      LDY.W !SpriteMisc157C,X             ;; 03B2CC : BC 7C 15    ;
                      LDA.W MechakoopaSpeed,Y             ;; 03B2CF : B9 A7 B2    ;
                      STA.B !SpriteXSpeed,X               ;; 03B2D2 : 95 B6       ;
                      LDA.B !SpriteTableC2,X              ;; 03B2D4 : B5 C2       ;
                      INC.B !SpriteTableC2,X              ;; 03B2D6 : F6 C2       ;
                      AND.B #$3F                          ;; 03B2D8 : 29 3F       ;
                      BNE CODE_03B2E3                     ;; 03B2DA : D0 07       ;
                      JSR SubHorzPosBnk3                  ;; 03B2DC : 20 17 B8    ;
                      TYA                                 ;; 03B2DF : 98          ;
                      STA.W !SpriteMisc157C,X             ;; 03B2E0 : 9D 7C 15    ;
CODE_03B2E3:          LDA.W !SpriteBlockedDirs,X          ;; 03B2E3 : BD 88 15    ; \ Branch if not touching object 
                      AND.B #$03                          ;; 03B2E6 : 29 03       ;  | 
                      BEQ CODE_03B2F9                     ;; 03B2E8 : F0 0F       ; / 
                      LDA.B !SpriteXSpeed,X               ;; 03B2EA : B5 B6       ;
                      EOR.B #$FF                          ;; 03B2EC : 49 FF       ;
                      INC A                               ;; 03B2EE : 1A          ;
                      STA.B !SpriteXSpeed,X               ;; 03B2EF : 95 B6       ;
                      LDA.W !SpriteMisc157C,X             ;; 03B2F1 : BD 7C 15    ;
                      EOR.B #$01                          ;; 03B2F4 : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 03B2F6 : 9D 7C 15    ;
CODE_03B2F9:          INC.W !SpriteMisc1570,X             ;; 03B2F9 : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 03B2FC : BD 70 15    ;
                      AND.B #$0C                          ;; 03B2FF : 29 0C       ;
                      LSR A                               ;; 03B301 : 4A          ;
                      LSR A                               ;; 03B302 : 4A          ;
                      STA.W !SpriteMisc1602,X             ;; 03B303 : 9D 02 16    ;
Return03B306:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B307:          PHB                                 ;; 03B307 : 8B          ; Wrapper 
                      PHK                                 ;; 03B308 : 4B          ;
                      PLB                                 ;; 03B309 : AB          ;
                      JSR MechaKoopaGfx                   ;; 03B30A : 20 55 B3    ;
                      PLB                                 ;; 03B30D : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechakoopaDispX:      db $F8,$08,$F8,$00,$08,$00,$10,$00  ;; ?QPWZ?               ;
MechakoopaDispY:      db $F8,$F8,$08,$00,$F9,$F9,$09,$00  ;; ?QPWZ?               ;
                      db $F8,$F8,$08,$00,$F9,$F9,$09,$00  ;; ?QPWZ?               ;
                      db $FD,$00,$05,$00,$00,$00,$08,$00  ;; ?QPWZ?               ;
MechakoopaTiles:      db $40,$42,$60,$51,$40,$42,$60,$0A  ;; ?QPWZ?               ;
                      db $40,$42,$60,$0C,$40,$42,$60,$0E  ;; ?QPWZ?               ;
                      db $00,$02,$10,$01,$00,$02,$10,$01  ;; ?QPWZ?               ;
MechakoopaGfxProp:    db $00,$00,$00,$00,$40,$40,$40,$40  ;; ?QPWZ?               ;
MechakoopaTileSize:   db $02,$00,$00,$02                  ;; ?QPWZ?               ;
                                                          ;;                      ;
MechakoopaPalette:    db $0B,$05                          ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopaGfx:        LDA.B #$0B                          ;; ?QPWZ? : A9 0B       ;
                      STA.W !SpriteOBJAttribute,X         ;; 03B357 : 9D F6 15    ;
                      LDA.W !SpriteMisc1540,X             ;; 03B35A : BD 40 15    ;
                      BEQ CODE_03B37F                     ;; 03B35D : F0 20       ;
                      LDY.B #$05                          ;; 03B35F : A0 05       ;
                      CMP.B #$05                          ;; 03B361 : C9 05       ;
                      BCC CODE_03B369                     ;; 03B363 : 90 04       ;
                      CMP.B #$FA                          ;; 03B365 : C9 FA       ;
                      BCC CODE_03B36B                     ;; 03B367 : 90 02       ;
CODE_03B369:          LDY.B #$04                          ;; 03B369 : A0 04       ;
CODE_03B36B:          TYA                                 ;; 03B36B : 98          ;
                      STA.W !SpriteMisc1602,X             ;; 03B36C : 9D 02 16    ;
                      LDA.W !SpriteMisc1540,X             ;; 03B36F : BD 40 15    ;
                      CMP.B #$30                          ;; 03B372 : C9 30       ;
                      BCS CODE_03B37F                     ;; 03B374 : B0 09       ;
                      AND.B #$01                          ;; 03B376 : 29 01       ;
                      TAY                                 ;; 03B378 : A8          ;
                      LDA.W MechakoopaPalette,Y           ;; 03B379 : B9 53 B3    ;
                      STA.W !SpriteOBJAttribute,X         ;; 03B37C : 9D F6 15    ;
CODE_03B37F:          JSR GetDrawInfoBnk3                 ;; 03B37F : 20 60 B7    ;
                      LDA.W !SpriteOBJAttribute,X         ;; 03B382 : BD F6 15    ;
                      STA.B !_4                           ;; 03B385 : 85 04       ;
                      TYA                                 ;; 03B387 : 98          ;
                      CLC                                 ;; 03B388 : 18          ;
                      ADC.B #$0C                          ;; 03B389 : 69 0C       ;
                      TAY                                 ;; 03B38B : A8          ;
                      LDA.W !SpriteMisc1602,X             ;; 03B38C : BD 02 16    ;
                      ASL A                               ;; 03B38F : 0A          ;
                      ASL A                               ;; 03B390 : 0A          ;
                      STA.B !_3                           ;; 03B391 : 85 03       ;
                      LDA.W !SpriteMisc157C,X             ;; 03B393 : BD 7C 15    ;
                      ASL A                               ;; 03B396 : 0A          ;
                      ASL A                               ;; 03B397 : 0A          ;
                      EOR.B #$04                          ;; 03B398 : 49 04       ;
                      STA.B !_2                           ;; 03B39A : 85 02       ;
                      PHX                                 ;; 03B39C : DA          ;
                      LDX.B #$03                          ;; 03B39D : A2 03       ;
CODE_03B39F:          PHX                                 ;; 03B39F : DA          ;
                      PHY                                 ;; 03B3A0 : 5A          ;
                      TYA                                 ;; 03B3A1 : 98          ;
                      LSR A                               ;; 03B3A2 : 4A          ;
                      LSR A                               ;; 03B3A3 : 4A          ;
                      TAY                                 ;; 03B3A4 : A8          ;
                      LDA.W MechakoopaTileSize,X          ;; 03B3A5 : BD 4F B3    ;
                      STA.W !OAMTileSize+$40,Y            ;; 03B3A8 : 99 60 04    ;
                      PLY                                 ;; 03B3AB : 7A          ;
                      PLA                                 ;; 03B3AC : 68          ;
                      PHA                                 ;; 03B3AD : 48          ;
                      CLC                                 ;; 03B3AE : 18          ;
                      ADC.B !_2                           ;; 03B3AF : 65 02       ;
                      TAX                                 ;; 03B3B1 : AA          ;
                      LDA.B !_0                           ;; 03B3B2 : A5 00       ;
                      CLC                                 ;; 03B3B4 : 18          ;
                      ADC.W MechakoopaDispX,X             ;; 03B3B5 : 7D 0F B3    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03B3B8 : 99 00 03    ;
                      LDA.W MechakoopaGfxProp,X           ;; 03B3BB : BD 47 B3    ;
                      ORA.B !_4                           ;; 03B3BE : 05 04       ;
                      ORA.B !SpriteProperties             ;; 03B3C0 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03B3C2 : 99 03 03    ;
                      PLA                                 ;; 03B3C5 : 68          ;
                      PHA                                 ;; 03B3C6 : 48          ;
                      CLC                                 ;; 03B3C7 : 18          ;
                      ADC.B !_3                           ;; 03B3C8 : 65 03       ;
                      TAX                                 ;; 03B3CA : AA          ;
                      LDA.W MechakoopaTiles,X             ;; 03B3CB : BD 2F B3    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03B3CE : 99 02 03    ;
                      LDA.B !_1                           ;; 03B3D1 : A5 01       ;
                      CLC                                 ;; 03B3D3 : 18          ;
                      ADC.W MechakoopaDispY,X             ;; 03B3D4 : 7D 17 B3    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03B3D7 : 99 01 03    ;
                      PLX                                 ;; 03B3DA : FA          ;
                      DEY                                 ;; 03B3DB : 88          ;
                      DEY                                 ;; 03B3DC : 88          ;
                      DEY                                 ;; 03B3DD : 88          ;
                      DEY                                 ;; 03B3DE : 88          ;
                      DEX                                 ;; 03B3DF : CA          ;
                      BPL CODE_03B39F                     ;; 03B3E0 : 10 BD       ;
                      PLX                                 ;; 03B3E2 : FA          ;
                      LDY.B #$FF                          ;; 03B3E3 : A0 FF       ;
                      LDA.B #$03                          ;; 03B3E5 : A9 03       ;
                      JSL FinishOAMWrite                  ;; 03B3E7 : 22 B3 B7 01 ;
                      JSR MechaKoopaKeyGfx                ;; 03B3EB : 20 F7 B3    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
MechaKeyDispX:        db $F9,$0F                          ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKeyGfxProp:      db $4D,$0D                          ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKeyTiles:        db $70,$71,$72,$71                  ;; ?QPWZ?               ;
                                                          ;;                      ;
MechaKoopaKeyGfx:     LDA.W !SpriteOAMIndex,X             ;; ?QPWZ? : BD EA 15    ;
                      CLC                                 ;; 03B3FA : 18          ;
                      ADC.B #$10                          ;; 03B3FB : 69 10       ;
                      STA.W !SpriteOAMIndex,X             ;; 03B3FD : 9D EA 15    ;
                      JSR GetDrawInfoBnk3                 ;; 03B400 : 20 60 B7    ;
                      PHX                                 ;; 03B403 : DA          ;
                      LDA.W !SpriteMisc1570,X             ;; 03B404 : BD 70 15    ;
                      LSR A                               ;; 03B407 : 4A          ;
                      LSR A                               ;; 03B408 : 4A          ;
                      AND.B #$03                          ;; 03B409 : 29 03       ;
                      STA.B !_2                           ;; 03B40B : 85 02       ;
                      LDA.W !SpriteMisc157C,X             ;; 03B40D : BD 7C 15    ;
                      TAX                                 ;; 03B410 : AA          ;
                      LDA.B !_0                           ;; 03B411 : A5 00       ;
                      CLC                                 ;; 03B413 : 18          ;
                      ADC.W MechaKeyDispX,X               ;; 03B414 : 7D EF B3    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03B417 : 99 00 03    ;
                      LDA.B !_1                           ;; 03B41A : A5 01       ;
                      SEC                                 ;; 03B41C : 38          ;
                      SBC.B #$00                          ;; 03B41D : E9 00       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03B41F : 99 01 03    ;
                      LDA.W MechaKeyGfxProp,X             ;; 03B422 : BD F1 B3    ;
                      ORA.B !SpriteProperties             ;; 03B425 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03B427 : 99 03 03    ;
                      LDX.B !_2                           ;; 03B42A : A6 02       ;
                      LDA.W MechaKeyTiles,X               ;; 03B42C : BD F3 B3    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03B42F : 99 02 03    ;
                      PLX                                 ;; 03B432 : FA          ;
                      LDY.B #$00                          ;; 03B433 : A0 00       ;
                      LDA.B #$00                          ;; 03B435 : A9 00       ;
                      JSL FinishOAMWrite                  ;; 03B437 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B43C:          JSR BowserItemBoxGfx                ;; 03B43C : 20 4F B4    ;
                      JSR BowserSceneGfx                  ;; 03B43F : 20 AC B4    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserItemBoxPosX:    db $70,$80,$70,$80                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxPosY:    db $07,$07,$17,$17                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxProp:    db $37,$77,$B7,$F7                  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserItemBoxGfx:     LDA.W !FinalCutscene                ;; ?QPWZ? : AD 0D 19    ;
                      BEQ CODE_03B457                     ;; 03B452 : F0 03       ;
                      STZ.W !PlayerItembox                ;; 03B454 : 9C C2 0D    ;
CODE_03B457:          LDA.W !PlayerItembox                ;; 03B457 : AD C2 0D    ;
                      BEQ Return03B48B                    ;; 03B45A : F0 2F       ;
                      PHX                                 ;; 03B45C : DA          ;
                      LDX.B #$03                          ;; 03B45D : A2 03       ;
                      LDY.B #$04                          ;; 03B45F : A0 04       ;
CODE_03B461:          LDA.W BowserItemBoxPosX,X           ;; 03B461 : BD 43 B4    ;
                      STA.W !OAMTileXPos,Y                ;; 03B464 : 99 00 02    ;
                      LDA.W BowserItemBoxPosY,X           ;; 03B467 : BD 47 B4    ;
                      STA.W !OAMTileYPos,Y                ;; 03B46A : 99 01 02    ;
                      LDA.B #$43                          ;; 03B46D : A9 43       ;
                      STA.W !OAMTileNo,Y                  ;; 03B46F : 99 02 02    ;
                      LDA.W BowserItemBoxProp,X           ;; 03B472 : BD 4B B4    ;
                      STA.W !OAMTileAttr,Y                ;; 03B475 : 99 03 02    ;
                      PHY                                 ;; 03B478 : 5A          ;
                      TYA                                 ;; 03B479 : 98          ;
                      LSR A                               ;; 03B47A : 4A          ;
                      LSR A                               ;; 03B47B : 4A          ;
                      TAY                                 ;; 03B47C : A8          ;
                      LDA.B #$02                          ;; 03B47D : A9 02       ;
                      STA.W !OAMTileSize,Y                ;; 03B47F : 99 20 04    ;
                      PLY                                 ;; 03B482 : 7A          ;
                      INY                                 ;; 03B483 : C8          ;
                      INY                                 ;; 03B484 : C8          ;
                      INY                                 ;; 03B485 : C8          ;
                      INY                                 ;; 03B486 : C8          ;
                      DEX                                 ;; 03B487 : CA          ;
                      BPL CODE_03B461                     ;; 03B488 : 10 D7       ;
                      PLX                                 ;; 03B48A : FA          ;
Return03B48B:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
BowserRoofPosX:       db $00,$30,$60,$90,$C0,$F0,$00,$30  ;; ?QPWZ?               ;
                      db $40,$50,$60,$90,$A0,$B0,$C0,$F0  ;; ?QPWZ?               ;
BowserRoofPosY:       db $B0,$B0,$B0,$B0,$B0,$B0,$D0,$D0  ;; ?QPWZ?               ;
                      db $D0,$D0,$D0,$D0,$D0,$D0,$D0,$D0  ;; ?QPWZ?               ;
                                                          ;;                      ;
BowserSceneGfx:       PHX                                 ;; ?QPWZ? : DA          ;
                      LDY.B #$BC                          ;; 03B4AD : A0 BC       ;
                      STZ.B !_1                           ;; 03B4AF : 64 01       ;
                      LDA.W !FinalCutscene                ;; 03B4B1 : AD 0D 19    ;
                      STA.B !_F                           ;; 03B4B4 : 85 0F       ;
                      CMP.B #$01                          ;; 03B4B6 : C9 01       ;
                      LDX.B #$10                          ;; 03B4B8 : A2 10       ;
                      BCC CODE_03B4BF                     ;; 03B4BA : 90 03       ;
                      LDY.B #$90                          ;; 03B4BC : A0 90       ;
                      DEX                                 ;; 03B4BE : CA          ;
CODE_03B4BF:          LDA.B #$C0                          ;; 03B4BF : A9 C0       ;
                      SEC                                 ;; 03B4C1 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03B4C2 : E5 1C       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03B4C4 : 99 01 03    ;
                      LDA.B !_1                           ;; 03B4C7 : A5 01       ;
                      SEC                                 ;; 03B4C9 : 38          ;
                      SBC.B !Layer1XPos                   ;; 03B4CA : E5 1A       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03B4CC : 99 00 03    ;
                      CLC                                 ;; 03B4CF : 18          ;
                      ADC.B #$10                          ;; 03B4D0 : 69 10       ;
                      STA.B !_1                           ;; 03B4D2 : 85 01       ;
                      LDA.B #$08                          ;; 03B4D4 : A9 08       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03B4D6 : 99 02 03    ;
                      LDA.B #$0D                          ;; 03B4D9 : A9 0D       ;
                      ORA.B !SpriteProperties             ;; 03B4DB : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03B4DD : 99 03 03    ;
                      PHY                                 ;; 03B4E0 : 5A          ;
                      TYA                                 ;; 03B4E1 : 98          ;
                      LSR A                               ;; 03B4E2 : 4A          ;
                      LSR A                               ;; 03B4E3 : 4A          ;
                      TAY                                 ;; 03B4E4 : A8          ;
                      LDA.B #$02                          ;; 03B4E5 : A9 02       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03B4E7 : 99 60 04    ;
                      PLY                                 ;; 03B4EA : 7A          ;
                      INY                                 ;; 03B4EB : C8          ;
                      INY                                 ;; 03B4EC : C8          ;
                      INY                                 ;; 03B4ED : C8          ;
                      INY                                 ;; 03B4EE : C8          ;
                      DEX                                 ;; 03B4EF : CA          ;
                      BPL CODE_03B4BF                     ;; 03B4F0 : 10 CD       ;
                      LDX.B #$0F                          ;; 03B4F2 : A2 0F       ;
                      LDA.B !_F                           ;; 03B4F4 : A5 0F       ;
                      BNE CODE_03B532                     ;; 03B4F6 : D0 3A       ;
                      LDY.B #$14                          ;; 03B4F8 : A0 14       ;
CODE_03B4FA:          LDA.W BowserRoofPosX,X              ;; 03B4FA : BD 8C B4    ;
                      SEC                                 ;; 03B4FD : 38          ;
                      SBC.B !Layer1XPos                   ;; 03B4FE : E5 1A       ;
                      STA.W !OAMTileXPos,Y                ;; 03B500 : 99 00 02    ;
                      LDA.W BowserRoofPosY,X              ;; 03B503 : BD 9C B4    ;
                      SEC                                 ;; 03B506 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03B507 : E5 1C       ;
                      STA.W !OAMTileYPos,Y                ;; 03B509 : 99 01 02    ;
                      LDA.B #$08                          ;; 03B50C : A9 08       ;
                      CPX.B #$06                          ;; 03B50E : E0 06       ;
                      BCS CODE_03B514                     ;; 03B510 : B0 02       ;
                      LDA.B #$03                          ;; 03B512 : A9 03       ;
CODE_03B514:          STA.W !OAMTileNo,Y                  ;; 03B514 : 99 02 02    ;
                      LDA.B #$0D                          ;; 03B517 : A9 0D       ;
                      ORA.B !SpriteProperties             ;; 03B519 : 05 64       ;
                      STA.W !OAMTileAttr,Y                ;; 03B51B : 99 03 02    ;
                      PHY                                 ;; 03B51E : 5A          ;
                      TYA                                 ;; 03B51F : 98          ;
                      LSR A                               ;; 03B520 : 4A          ;
                      LSR A                               ;; 03B521 : 4A          ;
                      TAY                                 ;; 03B522 : A8          ;
                      LDA.B #$02                          ;; 03B523 : A9 02       ;
                      STA.W !OAMTileSize,Y                ;; 03B525 : 99 20 04    ;
                      PLY                                 ;; 03B528 : 7A          ;
                      INY                                 ;; 03B529 : C8          ;
                      INY                                 ;; 03B52A : C8          ;
                      INY                                 ;; 03B52B : C8          ;
                      INY                                 ;; 03B52C : C8          ;
                      DEX                                 ;; 03B52D : CA          ;
                      BPL CODE_03B4FA                     ;; 03B52E : 10 CA       ;
                      BRA CODE_03B56A                     ;; 03B530 : 80 38       ;
                                                          ;;                      ;
CODE_03B532:          LDY.B #$50                          ;; 03B532 : A0 50       ;
CODE_03B534:          LDA.W BowserRoofPosX,X              ;; 03B534 : BD 8C B4    ;
                      SEC                                 ;; 03B537 : 38          ;
                      SBC.B !Layer1XPos                   ;; 03B538 : E5 1A       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03B53A : 99 00 03    ;
                      LDA.W BowserRoofPosY,X              ;; 03B53D : BD 9C B4    ;
                      SEC                                 ;; 03B540 : 38          ;
                      SBC.B !Layer1YPos                   ;; 03B541 : E5 1C       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03B543 : 99 01 03    ;
                      LDA.B #$08                          ;; 03B546 : A9 08       ;
                      CPX.B #$06                          ;; 03B548 : E0 06       ;
                      BCS CODE_03B54E                     ;; 03B54A : B0 02       ;
                      LDA.B #$03                          ;; 03B54C : A9 03       ;
CODE_03B54E:          STA.W !OAMTileNo+$100,Y             ;; 03B54E : 99 02 03    ;
                      LDA.B #$0D                          ;; 03B551 : A9 0D       ;
                      ORA.B !SpriteProperties             ;; 03B553 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03B555 : 99 03 03    ;
                      PHY                                 ;; 03B558 : 5A          ;
                      TYA                                 ;; 03B559 : 98          ;
                      LSR A                               ;; 03B55A : 4A          ;
                      LSR A                               ;; 03B55B : 4A          ;
                      TAY                                 ;; 03B55C : A8          ;
                      LDA.B #$02                          ;; 03B55D : A9 02       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03B55F : 99 60 04    ;
                      PLY                                 ;; 03B562 : 7A          ;
                      INY                                 ;; 03B563 : C8          ;
                      INY                                 ;; 03B564 : C8          ;
                      INY                                 ;; 03B565 : C8          ;
                      INY                                 ;; 03B566 : C8          ;
                      DEX                                 ;; 03B567 : CA          ;
                      BPL CODE_03B534                     ;; 03B568 : 10 CA       ;
CODE_03B56A:          PLX                                 ;; 03B56A : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
SprClippingDispX:     db $02,$02,$10,$14,$00,$00,$01,$08  ;; ?QPWZ?               ;
                      db $F8,$FE,$03,$06,$01,$00,$06,$02  ;; ?QPWZ?               ;
                      db $00,$E8,$FC,$FC,$04,$00,$FC,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$02,$00,$02,$E0,$F0  ;; ?QPWZ?               ;
                      db $FC,$FC,$00,$F8,$F4,$F2,$00,$FC  ;; ?QPWZ?               ;
                      db $F2,$F0,$02,$00,$F8,$04,$02,$02  ;; ?QPWZ?               ;
                      db $08,$00,$00,$00,$FC,$03,$08,$00  ;; ?QPWZ?               ;
                      db $08,$04,$F8,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingWidth:     db $0C,$0C,$10,$08,$30,$50,$0E,$28  ;; ?QPWZ?               ;
                      db $20,$14,$01,$03,$0D,$0F,$14,$24  ;; ?QPWZ?               ;
                      db $0F,$40,$08,$08,$18,$0F,$18,$0C  ;; ?QPWZ?               ;
                      db $0C,$0C,$0C,$0C,$0A,$1C,$30,$30  ;; ?QPWZ?               ;
                      db $08,$08,$10,$20,$38,$3C,$20,$18  ;; ?QPWZ?               ;
                      db $1C,$20,$0C,$10,$10,$08,$1C,$1C  ;; ?QPWZ?               ;
                      db $10,$30,$30,$40,$08,$12,$34,$0F  ;; ?QPWZ?               ;
                      db $20,$08,$20,$10                  ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingDispY:     db $03,$03,$FE,$08,$FE,$FE,$02,$08  ;; ?QPWZ?               ;
                      db $FE,$08,$07,$06,$FE,$FC,$06,$FE  ;; ?QPWZ?               ;
                      db $FE,$E8,$10,$10,$02,$FE,$F4,$08  ;; ?QPWZ?               ;
                      db $13,$23,$33,$43,$0A,$FD,$F8,$FC  ;; ?QPWZ?               ;
                      db $E8,$10,$00,$E8,$20,$04,$58,$FC  ;; ?QPWZ?               ;
                      db $E8,$FC,$F8,$02,$F8,$04,$FE,$FE  ;; ?QPWZ?               ;
                      db $F2,$FE,$FE,$FE,$FC,$00,$08,$F8  ;; ?QPWZ?               ;
                      db $10,$03,$10,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
SprClippingHeight:    db $0A,$15,$12,$08,$0E,$0E,$18,$30  ;; ?QPWZ?               ;
                      db $10,$1E,$02,$03,$16,$10,$14,$12  ;; ?QPWZ?               ;
                      db $20,$40,$34,$74,$0C,$0E,$18,$45  ;; ?QPWZ?               ;
                      db $3A,$2A,$1A,$0A,$30,$1B,$20,$12  ;; ?QPWZ?               ;
                      db $18,$18,$10,$20,$38,$14,$08,$18  ;; ?QPWZ?               ;
                      db $28,$1B,$13,$4C,$10,$04,$22,$20  ;; ?QPWZ?               ;
                      db $1C,$12,$12,$12,$08,$20,$2E,$14  ;; ?QPWZ?               ;
                      db $28,$0A,$10,$0D                  ;; ?QPWZ?               ;
                                                          ;;                      ;
MairoClipDispY:       db $06,$14,$10,$18                  ;; ?QPWZ?               ;
                                                          ;;                      ;
MarioClippingHeight:  db $1A,$0C,$20,$18                  ;; ?QPWZ?               ;
                                                          ;;                      ;
GetMarioClipping:     PHX                                 ;; ?QPWZ? : DA          ;
                      LDA.B !PlayerXPosNext               ;; 03B665 : A5 94       ; \ 
                      CLC                                 ;; 03B667 : 18          ;  | 
                      ADC.B #$02                          ;; 03B668 : 69 02       ;  | 
                      STA.B !_0                           ;; 03B66A : 85 00       ;  | $00 = (Mario X position + #$02) Low byte 
                      LDA.B !PlayerXPosNext+1             ;; 03B66C : A5 95       ;  | 
                      ADC.B #$00                          ;; 03B66E : 69 00       ;  | 
                      STA.B !_8                           ;; 03B670 : 85 08       ; / $08 = (Mario X position + #$02) High byte 
                      LDA.B #$0C                          ;; 03B672 : A9 0C       ; \ $06 = Clipping width X (#$0C) 
                      STA.B !_2                           ;; 03B674 : 85 02       ; / 
                      LDX.B #$00                          ;; 03B676 : A2 00       ; \ If mario small or ducking, X = #$01 
                      LDA.B !PlayerIsDucking              ;; 03B678 : A5 73       ;  | else, X = #$00 
                      BNE CODE_03B680                     ;; 03B67A : D0 04       ;  | 
                      LDA.B !Powerup                      ;; 03B67C : A5 19       ;  | 
                      BNE CODE_03B681                     ;; 03B67E : D0 01       ;  | 
CODE_03B680:          INX                                 ;; 03B680 : E8          ; / 
CODE_03B681:          LDA.W !PlayerRidingYoshi            ;; 03B681 : AD 7A 18    ; \ If on Yoshi, X += #$02 
                      BEQ CODE_03B688                     ;; 03B684 : F0 02       ;  | 
                      INX                                 ;; 03B686 : E8          ;  | 
                      INX                                 ;; 03B687 : E8          ; / 
CODE_03B688:          LDA.L MarioClippingHeight,X         ;; 03B688 : BF 60 B6 03 ; \ $03 = Clipping height 
                      STA.B !_3                           ;; 03B68C : 85 03       ; / 
                      LDA.B !PlayerYPosNext               ;; 03B68E : A5 96       ; \ 
                      CLC                                 ;; 03B690 : 18          ;  | 
                      ADC.L MairoClipDispY,X              ;; 03B691 : 7F 5C B6 03 ;  | 
                      STA.B !_1                           ;; 03B695 : 85 01       ;  | $01 = (Mario Y position + displacement) Low byte 
                      LDA.B !PlayerYPosNext+1             ;; 03B697 : A5 97       ;  | 
                      ADC.B #$00                          ;; 03B699 : 69 00       ;  | 
                      STA.B !_9                           ;; 03B69B : 85 09       ; / $09 = (Mario Y position + displacement) High byte 
                      PLX                                 ;; 03B69D : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
GetSpriteClippingA:   PHY                                 ;; ?QPWZ? : 5A          ;
                      PHX                                 ;; 03B6A0 : DA          ;
                      TXY                                 ;; 03B6A1 : 9B          ; Y = Sprite index 
                      LDA.W !SpriteTweakerB,X             ;; 03B6A2 : BD 62 16    ; \ X = Clipping table index 
                      AND.B #$3F                          ;; 03B6A5 : 29 3F       ;  | 
                      TAX                                 ;; 03B6A7 : AA          ; / 
                      STZ.B !_F                           ;; 03B6A8 : 64 0F       ; \ 
                      LDA.L SprClippingDispX,X            ;; 03B6AA : BF 6C B5 03 ;  | Load low byte of X displacement 
                      BPL CODE_03B6B2                     ;; 03B6AE : 10 02       ;  | 
                      DEC.B !_F                           ;; 03B6B0 : C6 0F       ;  | $0F = High byte of X displacement 
CODE_03B6B2:          CLC                                 ;; 03B6B2 : 18          ;  | 
                      ADC.W !SpriteXPosLow,Y              ;; 03B6B3 : 79 E4 00    ;  | 
                      STA.B !_4                           ;; 03B6B6 : 85 04       ;  | $04 = (Sprite X position + displacement) Low byte 
                      LDA.W !SpriteYPosHigh,Y             ;; 03B6B8 : B9 E0 14    ;  | 
                      ADC.B !_F                           ;; 03B6BB : 65 0F       ;  | 
                      STA.B !_A                           ;; 03B6BD : 85 0A       ; / $0A = (Sprite X position + displacement) High byte 
                      LDA.L SprClippingWidth,X            ;; 03B6BF : BF A8 B5 03 ; \ $06 = Clipping width 
                      STA.B !_6                           ;; 03B6C3 : 85 06       ; / 
                      STZ.B !_F                           ;; 03B6C5 : 64 0F       ; \ 
                      LDA.L SprClippingDispY,X            ;; 03B6C7 : BF E4 B5 03 ;  | Load low byte of Y displacement 
                      BPL CODE_03B6CF                     ;; 03B6CB : 10 02       ;  | 
                      DEC.B !_F                           ;; 03B6CD : C6 0F       ;  | $0F = High byte of Y displacement 
CODE_03B6CF:          CLC                                 ;; 03B6CF : 18          ;  | 
                      ADC.W !SpriteYPosLow,Y              ;; 03B6D0 : 79 D8 00    ;  | 
                      STA.B !_5                           ;; 03B6D3 : 85 05       ;  | $05 = (Sprite Y position + displacement) Low byte 
                      LDA.W !SpriteXPosHigh,Y             ;; 03B6D5 : B9 D4 14    ;  | 
                      ADC.B !_F                           ;; 03B6D8 : 65 0F       ;  | 
                      STA.B !_B                           ;; 03B6DA : 85 0B       ; / $0B = (Sprite Y position + displacement) High byte 
                      LDA.L SprClippingHeight,X           ;; 03B6DC : BF 20 B6 03 ; \ $07 = Clipping height 
                      STA.B !_7                           ;; 03B6E0 : 85 07       ; / 
                      PLX                                 ;; 03B6E2 : FA          ; X = Sprite index 
                      PLY                                 ;; 03B6E3 : 7A          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
GetSpriteClippingB:   PHY                                 ;; ?QPWZ? : 5A          ;
                      PHX                                 ;; 03B6E6 : DA          ;
                      TXY                                 ;; 03B6E7 : 9B          ; Y = Sprite index 
                      LDA.W !SpriteTweakerB,X             ;; 03B6E8 : BD 62 16    ; \ X = Clipping table index 
                      AND.B #$3F                          ;; 03B6EB : 29 3F       ;  | 
                      TAX                                 ;; 03B6ED : AA          ; / 
                      STZ.B !_F                           ;; 03B6EE : 64 0F       ; \ 
                      LDA.L SprClippingDispX,X            ;; 03B6F0 : BF 6C B5 03 ;  | Load low byte of X displacement 
                      BPL CODE_03B6F8                     ;; 03B6F4 : 10 02       ;  | 
                      DEC.B !_F                           ;; 03B6F6 : C6 0F       ;  | $0F = High byte of X displacement 
CODE_03B6F8:          CLC                                 ;; 03B6F8 : 18          ;  | 
                      ADC.W !SpriteXPosLow,Y              ;; 03B6F9 : 79 E4 00    ;  | 
                      STA.B !_0                           ;; 03B6FC : 85 00       ;  | $00 = (Sprite X position + displacement) Low byte 
                      LDA.W !SpriteYPosHigh,Y             ;; 03B6FE : B9 E0 14    ;  | 
                      ADC.B !_F                           ;; 03B701 : 65 0F       ;  | 
                      STA.B !_8                           ;; 03B703 : 85 08       ; / $08 = (Sprite X position + displacement) High byte 
                      LDA.L SprClippingWidth,X            ;; 03B705 : BF A8 B5 03 ; \ $02 = Clipping width 
                      STA.B !_2                           ;; 03B709 : 85 02       ; / 
                      STZ.B !_F                           ;; 03B70B : 64 0F       ; \ 
                      LDA.L SprClippingDispY,X            ;; 03B70D : BF E4 B5 03 ;  | Load low byte of Y displacement 
                      BPL CODE_03B715                     ;; 03B711 : 10 02       ;  | 
                      DEC.B !_F                           ;; 03B713 : C6 0F       ;  | $0F = High byte of Y displacement 
CODE_03B715:          CLC                                 ;; 03B715 : 18          ;  | 
                      ADC.W !SpriteYPosLow,Y              ;; 03B716 : 79 D8 00    ;  | 
                      STA.B !_1                           ;; 03B719 : 85 01       ;  | $01 = (Sprite Y position + displacement) Low byte 
                      LDA.W !SpriteXPosHigh,Y             ;; 03B71B : B9 D4 14    ;  | 
                      ADC.B !_F                           ;; 03B71E : 65 0F       ;  | 
                      STA.B !_9                           ;; 03B720 : 85 09       ; / $09 = (Sprite Y position + displacement) High byte 
                      LDA.L SprClippingHeight,X           ;; 03B722 : BF 20 B6 03 ; \ $03 = Clipping height 
                      STA.B !_3                           ;; 03B726 : 85 03       ; / 
                      PLX                                 ;; 03B728 : FA          ; X = Sprite index 
                      PLY                                 ;; 03B729 : 7A          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CheckForContact:      PHX                                 ;; ?QPWZ? : DA          ;
                      LDX.B #$01                          ;; 03B72C : A2 01       ;
CODE_03B72E:          LDA.B !_0,X                         ;; 03B72E : B5 00       ;
                      SEC                                 ;; 03B730 : 38          ;
                      SBC.B !_4,X                         ;; 03B731 : F5 04       ;
                      PHA                                 ;; 03B733 : 48          ;
                      LDA.B !_8,X                         ;; 03B734 : B5 08       ;
                      SBC.B !_A,X                         ;; 03B736 : F5 0A       ;
                      STA.B !_C                           ;; 03B738 : 85 0C       ;
                      PLA                                 ;; 03B73A : 68          ;
                      CLC                                 ;; 03B73B : 18          ;
                      ADC.B #$80                          ;; 03B73C : 69 80       ;
                      LDA.B !_C                           ;; 03B73E : A5 0C       ;
                      ADC.B #$00                          ;; 03B740 : 69 00       ;
                      BNE CODE_03B75A                     ;; 03B742 : D0 16       ;
                      LDA.B !_4,X                         ;; 03B744 : B5 04       ;
                      SEC                                 ;; 03B746 : 38          ;
                      SBC.B !_0,X                         ;; 03B747 : F5 00       ;
                      CLC                                 ;; 03B749 : 18          ;
                      ADC.B !_6,X                         ;; 03B74A : 75 06       ;
                      STA.B !_F                           ;; 03B74C : 85 0F       ;
                      LDA.B !_2,X                         ;; 03B74E : B5 02       ;
                      CLC                                 ;; 03B750 : 18          ;
                      ADC.B !_6,X                         ;; 03B751 : 75 06       ;
                      CMP.B !_F                           ;; 03B753 : C5 0F       ;
                      BCC CODE_03B75A                     ;; 03B755 : 90 03       ;
                      DEX                                 ;; 03B757 : CA          ;
                      BPL CODE_03B72E                     ;; 03B758 : 10 D4       ;
CODE_03B75A:          PLX                                 ;; 03B75A : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B75C:          db $0C,$1C                          ;; 03B75C               ;
                                                          ;;                      ;
DATA_03B75E:          db $01,$02                          ;; 03B75E               ;
                                                          ;;                      ;
GetDrawInfoBnk3:      STZ.W !SpriteOffscreenVert,X        ;; ?QPWZ? : 9E 6C 18    ; Reset sprite offscreen flag, vertical 
                      STZ.W !SpriteOffscreenX,X           ;; 03B763 : 9E A0 15    ; Reset sprite offscreen flag, horizontal 
                      LDA.B !SpriteXPosLow,X              ;; 03B766 : B5 E4       ; \ 
                      CMP.B !Layer1XPos                   ;; 03B768 : C5 1A       ;  | Set horizontal offscreen if necessary 
                      LDA.W !SpriteYPosHigh,X             ;; 03B76A : BD E0 14    ;  | 
                      SBC.B !Layer1XPos+1                 ;; 03B76D : E5 1B       ;  | 
                      BEQ CODE_03B774                     ;; 03B76F : F0 03       ;  | 
                      INC.W !SpriteOffscreenX,X           ;; 03B771 : FE A0 15    ; / 
CODE_03B774:          LDA.W !SpriteYPosHigh,X             ;; 03B774 : BD E0 14    ; \ 
                      XBA                                 ;; 03B777 : EB          ;  | Mark sprite invalid if far enough off screen 
                      LDA.B !SpriteXPosLow,X              ;; 03B778 : B5 E4       ;  | 
                      REP #$20                            ;; 03B77A : C2 20       ; Accum (16 bit) 
                      SEC                                 ;; 03B77C : 38          ;  | 
                      SBC.B !Layer1XPos                   ;; 03B77D : E5 1A       ;  | 
                      CLC                                 ;; 03B77F : 18          ;  | 
                      ADC.W #$0040                        ;; 03B780 : 69 40 00    ;  | 
                      CMP.W #$0180                        ;; 03B783 : C9 80 01    ;  | 
                      SEP #$20                            ;; 03B786 : E2 20       ; Accum (8 bit) 
                      ROL A                               ;; 03B788 : 2A          ;  | 
                      AND.B #$01                          ;; 03B789 : 29 01       ;  | 
                      STA.W !SpriteWayOffscreenX,X        ;; 03B78B : 9D C4 15    ;  | 
                      BNE CODE_03B7CF                     ;; 03B78E : D0 3F       ; /  
                      LDY.B #$00                          ;; 03B790 : A0 00       ; \ set up loop: 
                      LDA.W !SpriteTweakerB,X             ;; 03B792 : BD 62 16    ;  |  
                      AND.B #$20                          ;; 03B795 : 29 20       ;  | if not smushed (1662 & 0x20), go through loop twice 
                      BEQ CODE_03B79A                     ;; 03B797 : F0 01       ;  | else, go through loop once 
                      INY                                 ;; 03B799 : C8          ; /                        
CODE_03B79A:          LDA.B !SpriteYPosLow,X              ;; 03B79A : B5 D8       ; \                        
                      CLC                                 ;; 03B79C : 18          ;  | set vertical offscree 
                      ADC.W DATA_03B75C,Y                 ;; 03B79D : 79 5C B7    ;  |                       
                      PHP                                 ;; 03B7A0 : 08          ;  |                       
                      CMP.B !Layer1YPos                   ;; 03B7A1 : C5 1C       ;  | (vert screen boundry) 
                      ROL.B !_0                           ;; 03B7A3 : 26 00       ;  |                       
                      PLP                                 ;; 03B7A5 : 28          ;  |                       
                      LDA.W !SpriteXPosHigh,X             ;; 03B7A6 : BD D4 14    ;  |                       
                      ADC.B #$00                          ;; 03B7A9 : 69 00       ;  |                       
                      LSR.B !_0                           ;; 03B7AB : 46 00       ;  |                       
                      SBC.B !Layer1YPos+1                 ;; 03B7AD : E5 1D       ;  |                       
                      BEQ CODE_03B7BA                     ;; 03B7AF : F0 09       ;  |                       
                      LDA.W !SpriteOffscreenVert,X        ;; 03B7B1 : BD 6C 18    ;  | (vert offscreen)      
                      ORA.W DATA_03B75E,Y                 ;; 03B7B4 : 19 5E B7    ;  |                       
                      STA.W !SpriteOffscreenVert,X        ;; 03B7B7 : 9D 6C 18    ;  |                       
CODE_03B7BA:          DEY                                 ;; 03B7BA : 88          ;  |                       
                      BPL CODE_03B79A                     ;; 03B7BB : 10 DD       ; /                        
                      LDY.W !SpriteOAMIndex,X             ;; 03B7BD : BC EA 15    ; get offset to sprite OAM                           
                      LDA.B !SpriteXPosLow,X              ;; 03B7C0 : B5 E4       ; \ 
                      SEC                                 ;; 03B7C2 : 38          ;  |                                                     
                      SBC.B !Layer1XPos                   ;; 03B7C3 : E5 1A       ;  |                                                    
                      STA.B !_0                           ;; 03B7C5 : 85 00       ; / $00 = sprite x position relative to screen boarder 
                      LDA.B !SpriteYPosLow,X              ;; 03B7C7 : B5 D8       ; \                                                     
                      SEC                                 ;; 03B7C9 : 38          ;  |                                                     
                      SBC.B !Layer1YPos                   ;; 03B7CA : E5 1C       ;  |                                                    
                      STA.B !_1                           ;; 03B7CC : 85 01       ; / $01 = sprite y position relative to screen boarder 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03B7CF:          PLA                                 ;; 03B7CF : 68          ; \ Return from *main gfx routine* subroutine... 
                      PLA                                 ;; 03B7D0 : 68          ;  |    ...(not just this subroutine) 
                      RTS                                 ;; ?QPWZ? : 60          ; / 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B7D2:          db $00,$00,$00,$F8,$F8,$F8,$F8,$F8  ;; 03B7D2               ;
                      db $F8,$F7,$F6,$F5,$F4,$F3,$F2,$E8  ;; ?QPWZ?               ;
                      db $E8,$E8,$E8,$00,$00,$00,$00,$FE  ;; ?QPWZ?               ;
                      db $FC,$F8,$EC,$EC,$EC,$E8,$E4,$E0  ;; ?QPWZ?               ;
                      db $DC,$D8,$D4,$D0,$CC,$C8          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03B7F8:          LDA.B !SpriteYSpeed,X               ;; 03B7F8 : B5 AA       ;
                      PHA                                 ;; 03B7FA : 48          ;
                      STZ.B !SpriteYSpeed,X               ;; 03B7FB : 74 AA       ; Sprite Y Speed = 0 
                      PLA                                 ;; 03B7FD : 68          ;
                      LSR A                               ;; 03B7FE : 4A          ;
                      LSR A                               ;; 03B7FF : 4A          ;
                      TAY                                 ;; 03B800 : A8          ;
                      LDA.B !SpriteNumber,X               ;; 03B801 : B5 9E       ;
                      CMP.B #$A1                          ;; 03B803 : C9 A1       ;
                      BNE CODE_03B80C                     ;; 03B805 : D0 05       ;
                      TYA                                 ;; 03B807 : 98          ;
                      CLC                                 ;; 03B808 : 18          ;
                      ADC.B #$13                          ;; 03B809 : 69 13       ;
                      TAY                                 ;; 03B80B : A8          ;
CODE_03B80C:          LDA.W DATA_03B7D2,Y                 ;; 03B80C : B9 D2 B7    ;
                      LDY.W !SpriteBlockedDirs,X          ;; 03B80F : BC 88 15    ;
                      BMI Return03B816                    ;; 03B812 : 30 02       ;
                      STA.B !SpriteYSpeed,X               ;; 03B814 : 95 AA       ;
Return03B816:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SubHorzPosBnk3:       LDY.B #$00                          ;; ?QPWZ? : A0 00       ;
                      LDA.B !PlayerXPosNext               ;; 03B819 : A5 94       ;
                      SEC                                 ;; 03B81B : 38          ;
                      SBC.B !SpriteXPosLow,X              ;; 03B81C : F5 E4       ;
                      STA.B !_F                           ;; 03B81E : 85 0F       ;
                      LDA.B !PlayerXPosNext+1             ;; 03B820 : A5 95       ;
                      SBC.W !SpriteYPosHigh,X             ;; 03B822 : FD E0 14    ;
                      BPL Return03B828                    ;; 03B825 : 10 01       ;
                      INY                                 ;; 03B827 : C8          ;
Return03B828:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
SubVertPosBnk3:       LDY.B #$00                          ;; ?QPWZ? : A0 00       ;
                      LDA.B !PlayerYPosNext               ;; 03B82B : A5 96       ;
                      SEC                                 ;; 03B82D : 38          ;
                      SBC.B !SpriteYPosLow,X              ;; 03B82E : F5 D8       ;
                      STA.B !_F                           ;; 03B830 : 85 0F       ;
                      LDA.B !PlayerYPosNext+1             ;; 03B832 : A5 97       ;
                      SBC.W !SpriteXPosHigh,X             ;; 03B834 : FD D4 14    ;
                      BPL Return03B83A                    ;; 03B837 : 10 01       ;
                      INY                                 ;; 03B839 : C8          ;
Return03B83A:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03B83B:          db $40,$B0                          ;; 03B83B               ;
                                                          ;;                      ;
DATA_03B83D:          db $01,$FF                          ;; 03B83D               ;
                                                          ;;                      ;
DATA_03B83F:          db $30,$C0,$A0,$80,$A0,$40,$60,$B0  ;; 03B83F               ;
DATA_03B847:          db $01,$FF,$01,$FF,$01,$00,$01,$FF  ;; 03B847               ;
                                                          ;;                      ;
SubOffscreen3Bnk3:    LDA.B #$06                          ;; ?QPWZ? : A9 06       ; \ Entry point of routine determines value of $03 
                      BRA CODE_03B859                     ;; 03B851 : 80 06       ;  | 
                                                          ;;                      ;
                      LDA.B #$04                          ;; ?QPWZ? : A9 04       ;  | 
                      BRA CODE_03B859                     ;; 03B855 : 80 02       ;  | 
                                                          ;;                      ;
                      LDA.B #$02                          ;; ?QPWZ? : A9 02       ;  | 
CODE_03B859:          STA.B !_3                           ;; 03B859 : 85 03       ;  | 
                      BRA CODE_03B85F                     ;; 03B85B : 80 02       ;  | 
                                                          ;;                      ;
SubOffscreen0Bnk3:    STZ.B !_3                           ;; ?QPWZ? : 64 03       ; / 
CODE_03B85F:          JSR IsSprOffScreenBnk3              ;; 03B85F : 20 FB B8    ; \ if sprite is not off screen, return 
                      BEQ Return03B8C2                    ;; 03B862 : F0 5E       ; / 
                      LDA.B !ScreenMode                   ;; 03B864 : A5 5B       ; \  vertical level 
                      AND.B #$01                          ;; 03B866 : 29 01       ;  | 
                      BNE VerticalLevelBnk3               ;; 03B868 : D0 59       ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03B86A : B5 D8       ; \ 
                      CLC                                 ;; 03B86C : 18          ;  | 
                      ADC.B #$50                          ;; 03B86D : 69 50       ;  | if the sprite has gone off the bottom of the level... 
                      LDA.W !SpriteXPosHigh,X             ;; 03B86F : BD D4 14    ;  | (if adding 0x50 to the sprite y position would make the high byte >= 2) 
                      ADC.B #$00                          ;; 03B872 : 69 00       ;  | 
                      CMP.B #$02                          ;; 03B874 : C9 02       ;  | 
                      BPL OffScrEraseSprBnk3              ;; 03B876 : 10 34       ; /    ...erase the sprite 
                      LDA.W !SpriteTweakerD,X             ;; 03B878 : BD 7A 16    ; \ if "process offscreen" flag is set, return 
                      AND.B #$04                          ;; 03B87B : 29 04       ;  | 
                      BNE Return03B8C2                    ;; 03B87D : D0 43       ; / 
                      LDA.B !TrueFrame                    ;; 03B87F : A5 13       ;
                      AND.B #$01                          ;; 03B881 : 29 01       ;
                      ORA.B !_3                           ;; 03B883 : 05 03       ;
                      STA.B !_1                           ;; 03B885 : 85 01       ;
                      TAY                                 ;; 03B887 : A8          ;
                      LDA.B !Layer1XPos                   ;; 03B888 : A5 1A       ;
                      CLC                                 ;; 03B88A : 18          ;
                      ADC.W DATA_03B83F,Y                 ;; 03B88B : 79 3F B8    ;
                      ROL.B !_0                           ;; 03B88E : 26 00       ;
                      CMP.B !SpriteXPosLow,X              ;; 03B890 : D5 E4       ;
                      PHP                                 ;; 03B892 : 08          ;
                      LDA.B !Layer1XPos+1                 ;; 03B893 : A5 1B       ;
                      LSR.B !_0                           ;; 03B895 : 46 00       ;
                      ADC.W DATA_03B847,Y                 ;; 03B897 : 79 47 B8    ;
                      PLP                                 ;; 03B89A : 28          ;
                      SBC.W !SpriteYPosHigh,X             ;; 03B89B : FD E0 14    ;
                      STA.B !_0                           ;; 03B89E : 85 00       ;
                      LSR.B !_1                           ;; 03B8A0 : 46 01       ;
                      BCC CODE_03B8A8                     ;; 03B8A2 : 90 04       ;
                      EOR.B #$80                          ;; 03B8A4 : 49 80       ;
                      STA.B !_0                           ;; 03B8A6 : 85 00       ;
CODE_03B8A8:          LDA.B !_0                           ;; 03B8A8 : A5 00       ;
                      BPL Return03B8C2                    ;; 03B8AA : 10 16       ;
OffScrEraseSprBnk3:   LDA.W !SpriteStatus,X               ;; ?QPWZ? : BD C8 14    ; \ If sprite status < 8, permanently erase sprite 
                      CMP.B #$08                          ;; 03B8AF : C9 08       ;  | 
                      BCC OffScrKillSprBnk3               ;; 03B8B1 : 90 0C       ; / 
                      LDY.W !SpriteLoadIndex,X            ;; 03B8B3 : BC 1A 16    ; \ Branch if should permanently erase sprite 
                      CPY.B #$FF                          ;; 03B8B6 : C0 FF       ;  | 
                      BEQ OffScrKillSprBnk3               ;; 03B8B8 : F0 05       ; / 
                      LDA.B #$00                          ;; 03B8BA : A9 00       ; \ Allow sprite to be reloaded by level loading routine 
                      STA.W !SpriteLoadStatus,Y           ;; 03B8BC : 99 38 19    ; / 
OffScrKillSprBnk3:    STZ.W !SpriteStatus,X               ;; ?QPWZ? : 9E C8 14    ;
Return03B8C2:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
VerticalLevelBnk3:    LDA.W !SpriteTweakerD,X             ;; ?QPWZ? : BD 7A 16    ; \ If "process offscreen" flag is set, return 
                      AND.B #$04                          ;; 03B8C6 : 29 04       ;  | 
                      BNE Return03B8C2                    ;; 03B8C8 : D0 F8       ; / 
                      LDA.B !TrueFrame                    ;; 03B8CA : A5 13       ; \ Return every other frame 
                      LSR A                               ;; 03B8CC : 4A          ;  | 
                      BCS Return03B8C2                    ;; 03B8CD : B0 F3       ; / 
                      AND.B #$01                          ;; 03B8CF : 29 01       ;
                      STA.B !_1                           ;; 03B8D1 : 85 01       ;
                      TAY                                 ;; 03B8D3 : A8          ;
                      LDA.B !Layer1YPos                   ;; 03B8D4 : A5 1C       ;
                      CLC                                 ;; 03B8D6 : 18          ;
                      ADC.W DATA_03B83B,Y                 ;; 03B8D7 : 79 3B B8    ;
                      ROL.B !_0                           ;; 03B8DA : 26 00       ;
                      CMP.B !SpriteYPosLow,X              ;; 03B8DC : D5 D8       ;
                      PHP                                 ;; 03B8DE : 08          ;
                      LDA.W !Layer1YPos+1                 ;; 03B8DF : AD 1D 00    ;
                      LSR.B !_0                           ;; 03B8E2 : 46 00       ;
                      ADC.W DATA_03B83D,Y                 ;; 03B8E4 : 79 3D B8    ;
                      PLP                                 ;; 03B8E7 : 28          ;
                      SBC.W !SpriteXPosHigh,X             ;; 03B8E8 : FD D4 14    ;
                      STA.B !_0                           ;; 03B8EB : 85 00       ;
                      LDY.B !_1                           ;; 03B8ED : A4 01       ;
                      BEQ CODE_03B8F5                     ;; 03B8EF : F0 04       ;
                      EOR.B #$80                          ;; 03B8F1 : 49 80       ;
                      STA.B !_0                           ;; 03B8F3 : 85 00       ;
CODE_03B8F5:          LDA.B !_0                           ;; 03B8F5 : A5 00       ;
                      BPL Return03B8C2                    ;; 03B8F7 : 10 C9       ;
                      BMI OffScrEraseSprBnk3              ;; 03B8F9 : 30 B1       ;
IsSprOffScreenBnk3:   LDA.W !SpriteOffscreenX,X           ;; ?QPWZ? : BD A0 15    ; \ If sprite is on screen, A = 0  
                      ORA.W !SpriteOffscreenVert,X        ;; 03B8FE : 1D 6C 18    ;  | 
                      RTS                                 ;; ?QPWZ? : 60          ; / Return 
                                                          ;;                      ;
                                                          ;;                      ;
MagiKoopaPals:        db $FF,$7F,$4A,$29,$00,$00,$00,$14  ;; ?QPWZ?               ;
                      db $00,$20,$92,$7E,$0A,$00,$2A,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$AD,$35,$00,$00,$00,$24  ;; ?QPWZ?               ;
                      db $00,$2C,$2F,$72,$0D,$00,$AD,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$10,$42,$00,$00,$00,$30  ;; ?QPWZ?               ;
                      db $00,$38,$CC,$65,$50,$00,$10,$01  ;; ?QPWZ?               ;
                      db $FF,$7F,$73,$4E,$00,$00,$00,$3C  ;; ?QPWZ?               ;
                      db $41,$44,$69,$59,$B3,$00,$73,$01  ;; ?QPWZ?               ;
                      db $FF,$7F,$D6,$5A,$00,$00,$00,$48  ;; ?QPWZ?               ;
                      db $A4,$50,$06,$4D,$16,$01,$D6,$01  ;; ?QPWZ?               ;
                      db $FF,$7F,$39,$67,$00,$00,$42,$54  ;; ?QPWZ?               ;
                      db $07,$5D,$A3,$40,$79,$01,$39,$02  ;; ?QPWZ?               ;
                      db $FF,$7F,$9C,$73,$00,$00,$A5,$60  ;; ?QPWZ?               ;
                      db $6A,$69,$40,$34,$DC,$01,$9C,$02  ;; ?QPWZ?               ;
                      db $FF,$7F,$FF,$7F,$00,$00,$08,$6D  ;; ?QPWZ?               ;
                      db $CD,$75,$00,$28,$3F,$02,$FF,$02  ;; ?QPWZ?               ;
BooBossPals:          db $FF,$7F,$63,$0C,$00,$00,$00,$0C  ;; ?QPWZ?               ;
                      db $00,$0C,$00,$0C,$00,$0C,$03,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$E7,$1C,$00,$00,$00,$1C  ;; ?QPWZ?               ;
                      db $00,$1C,$20,$1C,$81,$1C,$07,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$6B,$2D,$00,$00,$00,$2C  ;; ?QPWZ?               ;
                      db $40,$2C,$A2,$2C,$05,$2D,$0B,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$EF,$3D,$00,$00,$60,$3C  ;; ?QPWZ?               ;
                      db $C3,$3C,$26,$3D,$89,$3D,$0F,$00  ;; ?QPWZ?               ;
                      db $FF,$7F,$73,$4E,$00,$00,$E4,$4C  ;; ?QPWZ?               ;
                      db $47,$4D,$AA,$4D,$0D,$4E,$13,$10  ;; ?QPWZ?               ;
                      db $FF,$7F,$F7,$5E,$00,$00,$68,$5D  ;; ?QPWZ?               ;
                      db $CB,$5D,$2E,$5E,$91,$5E,$17,$20  ;; ?QPWZ?               ;
                      db $FF,$7F,$7B,$6F,$00,$00,$EC,$6D  ;; ?QPWZ?               ;
                      db $4F,$6E,$B2,$6E,$15,$6F,$1B,$30  ;; ?QPWZ?               ;
                      db $FF,$7F,$FF,$7F,$00,$00,$70,$7E  ;; ?QPWZ?               ;
                      db $D3,$7E,$36,$7F,$99,$7F,$1F,$40  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; 03BA02               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF          ;; ?QPWZ?               ;
                                                          ;;                      ;
GenTileFromSpr2:      STA.B !Map16TileGenerate            ;; ?QPWZ? : 85 9C       ; $9C = tile to generate 
                      LDA.B !SpriteXPosLow,X              ;; 03C002 : B5 E4       ; \ $9A = Sprite X position + #$08 
                      SEC                                 ;; 03C004 : 38          ;  | for block creation 
                      SBC.B #$08                          ;; 03C005 : E9 08       ;  | 
                      STA.B !TouchBlockXPos               ;; 03C007 : 85 9A       ;  | 
                      LDA.W !SpriteYPosHigh,X             ;; 03C009 : BD E0 14    ;  | 
                      SBC.B #$00                          ;; 03C00C : E9 00       ;  | 
                      STA.B !TouchBlockXPos+1             ;; 03C00E : 85 9B       ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03C010 : B5 D8       ; \ $98 = Sprite Y position + #$08 
                      CLC                                 ;; 03C012 : 18          ;  | for block creation 
                      ADC.B #$08                          ;; 03C013 : 69 08       ;  | 
                      STA.B !TouchBlockYPos               ;; 03C015 : 85 98       ;  | 
                      LDA.W !SpriteXPosHigh,X             ;; 03C017 : BD D4 14    ;  | 
                      ADC.B #$00                          ;; 03C01A : 69 00       ;  | 
                      STA.B !TouchBlockYPos+1             ;; 03C01C : 85 99       ; / 
                      JSL GenerateTile                    ;; 03C01E : 22 B0 BE 00 ; Generate the tile 
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03C023:          PHB                                 ;; 03C023 : 8B          ; Wrapper 
                      PHK                                 ;; 03C024 : 4B          ;
                      PLB                                 ;; 03C025 : AB          ;
                      JSR CODE_03C02F                     ;; 03C026 : 20 2F C0    ;
                      PLB                                 ;; 03C029 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C02B:          db $74,$75,$77,$76                  ;; 03C02B               ;
                                                          ;;                      ;
CODE_03C02F:          LDY.W !SpriteMisc160E,X             ;; 03C02F : BC 0E 16    ;
                      LDA.B #$00                          ;; 03C032 : A9 00       ;
                      STA.W !SpriteStatus,Y               ;; 03C034 : 99 C8 14    ;
                      LDA.B #$06                          ;; 03C037 : A9 06       ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03C039 : 8D F9 1D    ; / 
                      LDA.W !SpriteMisc160E,Y             ;; 03C03C : B9 0E 16    ;
                      BNE CODE_03C09B                     ;; 03C03F : D0 5A       ;
                      LDA.W !SpriteNumber,Y               ;; 03C041 : B9 9E 00    ;
                      CMP.B #$81                          ;; 03C044 : C9 81       ;
                      BNE CODE_03C054                     ;; 03C046 : D0 0C       ;
                      LDA.B !EffFrame                     ;; 03C048 : A5 14       ;
                      LSR A                               ;; 03C04A : 4A          ;
                      LSR A                               ;; 03C04B : 4A          ;
                      LSR A                               ;; 03C04C : 4A          ;
                      LSR A                               ;; 03C04D : 4A          ;
                      AND.B #$03                          ;; 03C04E : 29 03       ;
                      TAY                                 ;; 03C050 : A8          ;
                      LDA.W DATA_03C02B,Y                 ;; 03C051 : B9 2B C0    ;
CODE_03C054:          CMP.B #$74                          ;; 03C054 : C9 74       ;
                      BCC CODE_03C09B                     ;; 03C056 : 90 43       ;
                      CMP.B #$78                          ;; 03C058 : C9 78       ;
                      BCS CODE_03C09B                     ;; 03C05A : B0 3F       ;
ADDR_03C05C:          STZ.W !YoshiSwallowTimer            ;; 03C05C : 9C AC 18    ;
                      STZ.W !YoshiHasWingsEvt             ;; 03C05F : 9C 1E 14    ; No Yoshi wing ability 
                      LDA.B #$35                          ;; 03C062 : A9 35       ;
                      STA.W !SpriteNumber,X               ;; 03C064 : 9D 9E 00    ;
                      LDA.B #$08                          ;; 03C067 : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,X               ;; 03C069 : 9D C8 14    ; / 
                      LDA.B #$1F                          ;; 03C06C : A9 1F       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03C06E : 8D FC 1D    ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03C071 : B5 D8       ;
                      SBC.B #$10                          ;; 03C073 : E9 10       ;
                      STA.B !SpriteYPosLow,X              ;; 03C075 : 95 D8       ;
                      LDA.W !SpriteXPosHigh,X             ;; 03C077 : BD D4 14    ;
                      SBC.B #$00                          ;; 03C07A : E9 00       ;
                      STA.W !SpriteXPosHigh,X             ;; 03C07C : 9D D4 14    ;
                      LDA.W !SpriteOBJAttribute,X         ;; 03C07F : BD F6 15    ;
                      PHA                                 ;; 03C082 : 48          ;
                      JSL InitSpriteTables                ;; 03C083 : 22 D2 F7 07 ;
                      PLA                                 ;; 03C087 : 68          ;
                      AND.B #$FE                          ;; 03C088 : 29 FE       ;
                      STA.W !SpriteOBJAttribute,X         ;; 03C08A : 9D F6 15    ;
                      LDA.B #$0C                          ;; 03C08D : A9 0C       ;
                      STA.W !SpriteMisc1602,X             ;; 03C08F : 9D 02 16    ;
                      DEC.W !SpriteMisc160E,X             ;; 03C092 : DE 0E 16    ;
                      LDA.B #$40                          ;; 03C095 : A9 40       ;
                      STA.W !YoshiGrowingTimer            ;; 03C097 : 8D E8 18    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C09B:          INC.W !SpriteMisc1570,X             ;; 03C09B : FE 70 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 03C09E : BD 70 15    ;
                      CMP.B #$05                          ;; 03C0A1 : C9 05       ;
                      BNE CODE_03C0A7                     ;; 03C0A3 : D0 02       ;
                      BRA ADDR_03C05C                     ;; 03C0A5 : 80 B5       ;
                                                          ;;                      ;
CODE_03C0A7:          JSL CODE_05B34A                     ;; 03C0A7 : 22 4A B3 05 ;
                      LDA.B #$01                          ;; 03C0AB : A9 01       ;
                      JSL GivePoints                      ;; 03C0AD : 22 E5 AC 02 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C0B2:          db $68,$6A,$6C,$6E                  ;; 03C0B2               ;
                                                          ;;                      ;
DATA_03C0B6:          db $00,$03,$01,$02,$04,$02,$00,$01  ;; 03C0B6               ;
                      db $00,$04,$00,$02,$00,$03,$04,$01  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C0C6:          LDA.B !SpriteLock                   ;; 03C0C6 : A5 9D       ;
                      BNE CODE_03C0CD                     ;; 03C0C8 : D0 03       ;
                      JSR CODE_03C11E                     ;; 03C0CA : 20 1E C1    ;
CODE_03C0CD:          STZ.B !_0                           ;; 03C0CD : 64 00       ;
                      LDX.B #$13                          ;; 03C0CF : A2 13       ;
                      LDY.B #$B0                          ;; 03C0D1 : A0 B0       ;
CODE_03C0D3:          STX.B !_2                           ;; 03C0D3 : 86 02       ;
                      LDA.B !_0                           ;; 03C0D5 : A5 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03C0D7 : 99 00 03    ;
                      CLC                                 ;; 03C0DA : 18          ;
                      ADC.B #$10                          ;; 03C0DB : 69 10       ;
                      STA.B !_0                           ;; 03C0DD : 85 00       ;
                      LDA.B #$C4                          ;; 03C0DF : A9 C4       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03C0E1 : 99 01 03    ;
                      LDA.B !SpriteProperties             ;; 03C0E4 : A5 64       ;
                      ORA.B #$09                          ;; 03C0E6 : 09 09       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C0E8 : 99 03 03    ;
                      PHX                                 ;; 03C0EB : DA          ;
                      LDA.B !EffFrame                     ;; 03C0EC : A5 14       ;
                      LSR A                               ;; 03C0EE : 4A          ;
                      LSR A                               ;; 03C0EF : 4A          ;
                      LSR A                               ;; 03C0F0 : 4A          ;
                      CLC                                 ;; 03C0F1 : 18          ;
                      ADC.L DATA_03C0B6,X                 ;; 03C0F2 : 7F B6 C0 03 ;
                      AND.B #$03                          ;; 03C0F6 : 29 03       ;
                      TAX                                 ;; 03C0F8 : AA          ;
                      LDA.L DATA_03C0B2,X                 ;; 03C0F9 : BF B2 C0 03 ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C0FD : 99 02 03    ;
                      TYA                                 ;; 03C100 : 98          ;
                      LSR A                               ;; 03C101 : 4A          ;
                      LSR A                               ;; 03C102 : 4A          ;
                      TAX                                 ;; 03C103 : AA          ;
                      LDA.B #$02                          ;; 03C104 : A9 02       ;
                      STA.W !OAMTileSize+$40,X            ;; 03C106 : 9D 60 04    ;
                      PLX                                 ;; 03C109 : FA          ;
                      INY                                 ;; 03C10A : C8          ;
                      INY                                 ;; 03C10B : C8          ;
                      INY                                 ;; 03C10C : C8          ;
                      INY                                 ;; 03C10D : C8          ;
                      DEX                                 ;; 03C10E : CA          ;
                      BPL CODE_03C0D3                     ;; 03C10F : 10 C2       ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
IggyPlatSpeed:        db $FF,$01,$FF,$01                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C116:          db $FF,$00,$FF,$00                  ;; 03C116               ;
                                                          ;;                      ;
IggyPlatBounds:       db $E7,$18,$D7,$28                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C11E:          LDA.B !SpriteLock                   ;; 03C11E : A5 9D       ; \ If sprites locked... 
                      ORA.W !EndLevelTimer                ;; 03C120 : 0D 93 14    ;  | ...or battle is over (set to FF when over)... 
                      BNE Return03C175                    ;; 03C123 : D0 50       ; / ...return 
                      LDA.W !IggyLarryPlatWait            ;; 03C125 : AD 06 19    ; \ If platform at a maximum tilt, (stationary timer > 0) 
                      BEQ CODE_03C12D                     ;; 03C128 : F0 03       ;  | 
                      DEC.W !IggyLarryPlatWait            ;; 03C12A : CE 06 19    ; / decrement stationary timer 
CODE_03C12D:          LDA.B !TrueFrame                    ;; 03C12D : A5 13       ; \ Return every other time through... 
                      AND.B #$01                          ;; 03C12F : 29 01       ;  | 
                      ORA.W !IggyLarryPlatWait            ;; 03C131 : 0D 06 19    ;  | ...return if stationary 
                      BNE Return03C175                    ;; 03C134 : D0 3F       ; / 
                      LDA.W !IggyLarryPlatTilt            ;; 03C136 : AD 05 19    ; $1907 holds the total number of tilts made 
                      AND.B #$01                          ;; 03C139 : 29 01       ; \ X=1 if platform tilted up to the right (/)... 
                      TAX                                 ;; 03C13B : AA          ; / ...else X=0 
                      LDA.W !IggyLarryPlatPhase           ;; 03C13C : AD 07 19    ; $1907 holds the current phase: 0/ 1\ 2/ 3\ 4// 5\\ 
                      CMP.B #$04                          ;; 03C13F : C9 04       ; \ If this is phase 4 or 5... 
                      BCC CODE_03C145                     ;; 03C141 : 90 02       ;  | ...cause a steep tilt by setting X=X+2 
                      INX                                 ;; 03C143 : E8          ;  | 
                      INX                                 ;; 03C144 : E8          ; / 
CODE_03C145:          LDA.B !Mode7Angle                   ;; 03C145 : A5 36       ; $36 is tilt of platform: //D8 /E8 -0- 18\ 28\\ 
                      CLC                                 ;; 03C147 : 18          ; \ Get new tilt of platform by adding value 
                      ADC.L IggyPlatSpeed,X               ;; 03C148 : 7F 12 C1 03 ;  | 
                      STA.B !Mode7Angle                   ;; 03C14C : 85 36       ; / 
                      PHA                                 ;; 03C14E : 48          ;
                      LDA.B !Mode7Angle+1                 ;; 03C14F : A5 37       ; $37 is boolean tilt of platform: 0\ /1 
                      ADC.L DATA_03C116,X                 ;; 03C151 : 7F 16 C1 03 ; \ if tilted up to left,  $37=0 
                      AND.B #$01                          ;; 03C155 : 29 01       ;  | if tilted up to right, $37=1 
                      STA.B !Mode7Angle+1                 ;; 03C157 : 85 37       ; / 
                      PLA                                 ;; 03C159 : 68          ;
                      CMP.L IggyPlatBounds,X              ;; 03C15A : DF 1A C1 03 ; \ Return if platform not at a maximum tilt 
                      BNE Return03C175                    ;; 03C15E : D0 15       ; / 
                      INC.W !IggyLarryPlatTilt            ;; 03C160 : EE 05 19    ; Increment total number of tilts made 
                      LDA.B #$40                          ;; 03C163 : A9 40       ; \ Set timer to stay stationary 
                      STA.W !IggyLarryPlatWait            ;; 03C165 : 8D 06 19    ; / 
                      INC.W !IggyLarryPlatPhase           ;; 03C168 : EE 07 19    ; Increment phase 
                      LDA.W !IggyLarryPlatPhase           ;; 03C16B : AD 07 19    ; \ If phase > 5, phase = 0 
                      CMP.B #$06                          ;; 03C16E : C9 06       ;  | 
                      BNE Return03C175                    ;; 03C170 : D0 03       ;  | 
                      STZ.W !IggyLarryPlatPhase           ;; 03C172 : 9C 07 19    ; / 
Return03C175:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C176:          db $0C,$0C,$0C,$0C,$0C,$0C,$0D,$0D  ;; 03C176               ;
                      db $0D,$0D,$FC,$FC,$FC,$FC,$FC,$FC  ;; ?QPWZ?               ;
                      db $FB,$FB,$FB,$FB,$0C,$0C,$0C,$0C  ;; ?QPWZ?               ;
                      db $0C,$0C,$0D,$0D,$0D,$0D,$FC,$FC  ;; ?QPWZ?               ;
                      db $FC,$FC,$FC,$FC,$FB,$FB,$FB,$FB  ;; ?QPWZ?               ;
DATA_03C19E:          db $0E,$0E,$0E,$0D,$0D,$0D,$0C,$0C  ;; 03C19E               ;
                      db $0B,$0B,$0E,$0E,$0E,$0D,$0D,$0D  ;; ?QPWZ?               ;
                      db $0C,$0C,$0B,$0B,$12,$12,$12,$11  ;; ?QPWZ?               ;
                      db $11,$11,$10,$10,$0F,$0F,$12,$12  ;; ?QPWZ?               ;
                      db $12,$11,$11,$11,$10,$10,$0F,$0F  ;; ?QPWZ?               ;
DATA_03C1C6:          db $02,$FE                          ;; 03C1C6               ;
                                                          ;;                      ;
DATA_03C1C8:          db $00,$FF                          ;; 03C1C8               ;
                                                          ;;                      ;
CODE_03C1CA:          PHB                                 ;; 03C1CA : 8B          ;
                      PHK                                 ;; 03C1CB : 4B          ;
                      PLB                                 ;; 03C1CC : AB          ;
                      LDY.B #$00                          ;; 03C1CD : A0 00       ;
                      LDA.W !SpriteSlope,X                ;; 03C1CF : BD B8 15    ;
                      BPL CODE_03C1D5                     ;; 03C1D2 : 10 01       ;
                      INY                                 ;; 03C1D4 : C8          ;
CODE_03C1D5:          LDA.B !SpriteXPosLow,X              ;; 03C1D5 : B5 E4       ;
                      CLC                                 ;; 03C1D7 : 18          ;
                      ADC.W DATA_03C1C6,Y                 ;; 03C1D8 : 79 C6 C1    ;
                      STA.B !SpriteXPosLow,X              ;; 03C1DB : 95 E4       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03C1DD : BD E0 14    ;
                      ADC.W DATA_03C1C8,Y                 ;; 03C1E0 : 79 C8 C1    ;
                      STA.W !SpriteYPosHigh,X             ;; 03C1E3 : 9D E0 14    ;
                      LDA.B #$18                          ;; 03C1E6 : A9 18       ;
                      STA.B !SpriteYSpeed,X               ;; 03C1E8 : 95 AA       ;
                      PLB                                 ;; 03C1EA : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C1EC:          db $00,$04,$07,$08,$08,$07,$04,$00  ;; 03C1EC               ;
                      db $00                              ;; ?QPWZ?               ;
                                                          ;;                      ;
LightSwitch:          LDA.B !SpriteLock                   ;; ?QPWZ? : A5 9D       ;
                      BNE CODE_03C22B                     ;; 03C1F7 : D0 32       ;
                      JSL InvisBlkMainRt                  ;; 03C1F9 : 22 4F B4 01 ;
                      JSR SubOffscreen0Bnk3               ;; 03C1FD : 20 5D B8    ;
                      LDA.W !SpriteMisc1558,X             ;; 03C200 : BD 58 15    ;
                      CMP.B #$05                          ;; 03C203 : C9 05       ;
                      BNE CODE_03C22B                     ;; 03C205 : D0 24       ;
                      STZ.B !SpriteTableC2,X              ;; 03C207 : 74 C2       ;
                      LDY.B #$0B                          ;; 03C209 : A0 0B       ; \ Play sound effect 
                      STY.W !SPCIO0                       ;; 03C20B : 8C F9 1D    ; / 
                      PHA                                 ;; 03C20E : 48          ;
                      LDY.B #$09                          ;; 03C20F : A0 09       ;
CODE_03C211:          LDA.W !SpriteStatus,Y               ;; 03C211 : B9 C8 14    ;
                      CMP.B #$08                          ;; 03C214 : C9 08       ;
                      BNE CODE_03C227                     ;; 03C216 : D0 0F       ;
                      LDA.W !SpriteNumber,Y               ;; 03C218 : B9 9E 00    ;
                      CMP.B #$C6                          ;; 03C21B : C9 C6       ;
                      BNE CODE_03C227                     ;; 03C21D : D0 08       ;
                      LDA.W !SpriteTableC2,Y              ;; 03C21F : B9 C2 00    ;
                      EOR.B #$01                          ;; 03C222 : 49 01       ;
                      STA.W !SpriteTableC2,Y              ;; 03C224 : 99 C2 00    ;
CODE_03C227:          DEY                                 ;; 03C227 : 88          ;
                      BPL CODE_03C211                     ;; 03C228 : 10 E7       ;
                      PLA                                 ;; 03C22A : 68          ;
CODE_03C22B:          LDA.W !SpriteMisc1558,X             ;; 03C22B : BD 58 15    ;
                      LSR A                               ;; 03C22E : 4A          ;
                      TAY                                 ;; 03C22F : A8          ;
                      LDA.B !Layer1YPos                   ;; 03C230 : A5 1C       ;
                      PHA                                 ;; 03C232 : 48          ;
                      CLC                                 ;; 03C233 : 18          ;
                      ADC.W DATA_03C1EC,Y                 ;; 03C234 : 79 EC C1    ;
                      STA.B !Layer1YPos                   ;; 03C237 : 85 1C       ;
                      LDA.B !Layer1YPos+1                 ;; 03C239 : A5 1D       ;
                      PHA                                 ;; 03C23B : 48          ;
                      ADC.B #$00                          ;; 03C23C : 69 00       ;
                      STA.B !Layer1YPos+1                 ;; 03C23E : 85 1D       ;
                      JSL GenericSprGfxRt2                ;; 03C240 : 22 B2 90 01 ;
                      LDY.W !SpriteOAMIndex,X             ;; 03C244 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$2A                          ;; 03C247 : A9 2A       ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C249 : 99 02 03    ;
                      LDA.W !OAMTileAttr+$100,Y           ;; 03C24C : B9 03 03    ;
                      AND.B #$BF                          ;; 03C24F : 29 BF       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C251 : 99 03 03    ;
                      PLA                                 ;; 03C254 : 68          ;
                      STA.B !Layer1YPos+1                 ;; 03C255 : 85 1D       ;
                      PLA                                 ;; 03C257 : 68          ;
                      STA.B !Layer1YPos                   ;; 03C258 : 85 1C       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ChainsawMotorTiles:   db $E0,$C2,$C0,$C2                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C25F:          db $F2,$0E                          ;; 03C25F               ;
                                                          ;;                      ;
DATA_03C261:          db $33,$B3                          ;; 03C261               ;
                                                          ;;                      ;
CODE_03C263:          PHB                                 ;; 03C263 : 8B          ; Wrapper 
                      PHK                                 ;; 03C264 : 4B          ;
                      PLB                                 ;; 03C265 : AB          ;
                      JSR ChainsawGfx                     ;; 03C266 : 20 6B C2    ;
                      PLB                                 ;; 03C269 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
ChainsawGfx:          JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      PHX                                 ;; 03C26E : DA          ;
                      LDA.B !SpriteNumber,X               ;; 03C26F : B5 9E       ;
                      SEC                                 ;; 03C271 : 38          ;
                      SBC.B #$65                          ;; 03C272 : E9 65       ;
                      TAX                                 ;; 03C274 : AA          ;
                      LDA.W DATA_03C25F,X                 ;; 03C275 : BD 5F C2    ;
                      STA.B !_3                           ;; 03C278 : 85 03       ;
                      LDA.W DATA_03C261,X                 ;; 03C27A : BD 61 C2    ;
                      STA.B !_4                           ;; 03C27D : 85 04       ;
                      PLX                                 ;; 03C27F : FA          ;
                      LDA.B !EffFrame                     ;; 03C280 : A5 14       ;
                      AND.B #$02                          ;; 03C282 : 29 02       ;
                      STA.B !_2                           ;; 03C284 : 85 02       ;
                      LDA.B !_0                           ;; 03C286 : A5 00       ;
                      SEC                                 ;; 03C288 : 38          ;
                      SBC.B #$08                          ;; 03C289 : E9 08       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03C28B : 99 00 03    ;
                      STA.W !OAMTileXPos+$104,Y           ;; 03C28E : 99 04 03    ;
                      STA.W !OAMTileXPos+$108,Y           ;; 03C291 : 99 08 03    ;
                      LDA.B !_1                           ;; 03C294 : A5 01       ;
                      SEC                                 ;; 03C296 : 38          ;
                      SBC.B #$08                          ;; 03C297 : E9 08       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03C299 : 99 01 03    ;
                      CLC                                 ;; 03C29C : 18          ;
                      ADC.B !_3                           ;; 03C29D : 65 03       ;
                      CLC                                 ;; 03C29F : 18          ;
                      ADC.B !_2                           ;; 03C2A0 : 65 02       ;
                      STA.W !OAMTileYPos+$104,Y           ;; 03C2A2 : 99 05 03    ;
                      CLC                                 ;; 03C2A5 : 18          ;
                      ADC.B !_3                           ;; 03C2A6 : 65 03       ;
                      STA.W !OAMTileYPos+$108,Y           ;; 03C2A8 : 99 09 03    ;
                      LDA.B !EffFrame                     ;; 03C2AB : A5 14       ;
                      LSR A                               ;; 03C2AD : 4A          ;
                      LSR A                               ;; 03C2AE : 4A          ;
                      AND.B #$03                          ;; 03C2AF : 29 03       ;
                      PHX                                 ;; 03C2B1 : DA          ;
                      TAX                                 ;; 03C2B2 : AA          ;
                      LDA.W ChainsawMotorTiles,X          ;; 03C2B3 : BD 5B C2    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C2B6 : 99 02 03    ;
                      PLX                                 ;; 03C2B9 : FA          ;
                      LDA.B #$AE                          ;; 03C2BA : A9 AE       ;
                      STA.W !OAMTileNo+$104,Y             ;; 03C2BC : 99 06 03    ;
                      LDA.B #$8E                          ;; 03C2BF : A9 8E       ;
                      STA.W !OAMTileNo+$108,Y             ;; 03C2C1 : 99 0A 03    ;
                      LDA.B #$37                          ;; 03C2C4 : A9 37       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C2C6 : 99 03 03    ;
                      LDA.B !_4                           ;; 03C2C9 : A5 04       ;
                      STA.W !OAMTileAttr+$104,Y           ;; 03C2CB : 99 07 03    ;
                      STA.W !OAMTileAttr+$108,Y           ;; 03C2CE : 99 0B 03    ;
                      LDY.B #$02                          ;; 03C2D1 : A0 02       ;
                      TYA                                 ;; 03C2D3 : 98          ;
                      JSL FinishOAMWrite                  ;; 03C2D4 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
TriggerInivis1Up:     PHX                                 ;; ?QPWZ? : DA          ; \ Find free sprite slot (#$0B-#$00) 
                      LDX.B #$0B                          ;; 03C2DA : A2 0B       ;  | 
CODE_03C2DC:          LDA.W !SpriteStatus,X               ;; 03C2DC : BD C8 14    ;  | 
                      BEQ Generate1Up                     ;; 03C2DF : F0 05       ;  | 
                      DEX                                 ;; 03C2E1 : CA          ;  | 
                      BPL CODE_03C2DC                     ;; 03C2E2 : 10 F8       ;  | 
                      PLX                                 ;; 03C2E4 : FA          ;  | 
                      RTL                                 ;; ?QPWZ? : 6B          ; / 
                                                          ;;                      ;
Generate1Up:          LDA.B #$08                          ;; ?QPWZ? : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,X               ;; 03C2E8 : 9D C8 14    ; / 
                      LDA.B #$78                          ;; 03C2EB : A9 78       ; \ Sprite = 1Up 
                      STA.B !SpriteNumber,X               ;; 03C2ED : 95 9E       ; / 
                      LDA.B !PlayerXPosNext               ;; 03C2EF : A5 94       ; \ Sprite X position = Mario X position 
                      STA.B !SpriteXPosLow,X              ;; 03C2F1 : 95 E4       ;  | 
                      LDA.B !PlayerXPosNext+1             ;; 03C2F3 : A5 95       ;  | 
                      STA.W !SpriteYPosHigh,X             ;; 03C2F5 : 9D E0 14    ; / 
                      LDA.B !PlayerYPosNext               ;; 03C2F8 : A5 96       ; \ Sprite Y position = Matio Y position 
                      STA.B !SpriteYPosLow,X              ;; 03C2FA : 95 D8       ;  | 
                      LDA.B !PlayerYPosNext+1             ;; 03C2FC : A5 97       ;  | 
                      STA.W !SpriteXPosHigh,X             ;; 03C2FE : 9D D4 14    ; / 
                      JSL InitSpriteTables                ;; 03C301 : 22 D2 F7 07 ; Load sprite tables 
                      LDA.B #$10                          ;; 03C305 : A9 10       ; \ Disable interaction timer = #$10 
                      STA.W !SpriteMisc154C,X             ;; 03C307 : 9D 4C 15    ; / 
                      JSR PopupMushroom                   ;; 03C30A : 20 34 C3    ;
                      PLX                                 ;; 03C30D : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
InvisMushroom:        JSR GetDrawInfoBnk3                 ;; ?QPWZ? : 20 60 B7    ;
                      JSL MarioSprInteract                ;; 03C312 : 22 DC A7 01 ; \ Return if no interaction 
                      BCC Return03C347                    ;; 03C316 : 90 2F       ; / 
                      LDA.B #$74                          ;; 03C318 : A9 74       ; \ Replace, Sprite = Mushroom 
                      STA.B !SpriteNumber,X               ;; 03C31A : 95 9E       ; / 
                      JSL InitSpriteTables                ;; 03C31C : 22 D2 F7 07 ; Reset sprite tables 
                      LDA.B #$20                          ;; 03C320 : A9 20       ; \ Disable interaction timer = #$20 
                      STA.W !SpriteMisc154C,X             ;; 03C322 : 9D 4C 15    ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03C325 : B5 D8       ; \ Sprite Y position = Mario Y position - $000F 
                      SEC                                 ;; 03C327 : 38          ;  | 
                      SBC.B #$0F                          ;; 03C328 : E9 0F       ;  | 
                      STA.B !SpriteYPosLow,X              ;; 03C32A : 95 D8       ;  | 
                      LDA.W !SpriteXPosHigh,X             ;; 03C32C : BD D4 14    ;  | 
                      SBC.B #$00                          ;; 03C32F : E9 00       ;  | 
                      STA.W !SpriteXPosHigh,X             ;; 03C331 : 9D D4 14    ; / 
PopupMushroom:        LDA.B #$00                          ;; ?QPWZ? : A9 00       ; \ Sprite direction = dirction of Mario's X speed 
                      LDY.B !PlayerXSpeed                 ;; 03C336 : A4 7B       ;  | 
                      BPL CODE_03C33B                     ;; 03C338 : 10 01       ;  | 
                      INC A                               ;; 03C33A : 1A          ;  | 
CODE_03C33B:          STA.W !SpriteMisc157C,X             ;; 03C33B : 9D 7C 15    ; / 
                      LDA.B #$C0                          ;; 03C33E : A9 C0       ; \ Set upward speed 
                      STA.B !SpriteYSpeed,X               ;; 03C340 : 95 AA       ; / 
                      LDA.B #$02                          ;; 03C342 : A9 02       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03C344 : 8D FC 1D    ; / 
Return03C347:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
NinjiSpeedY:          db $D0,$C0,$B0,$D0                  ;; ?QPWZ?               ;
                                                          ;;                      ;
Ninji:                JSL GenericSprGfxRt2                ;; ?QPWZ? : 22 B2 90 01 ; Draw sprite uing the routine for sprites <= 53 
                      LDA.B !SpriteLock                   ;; 03C350 : A5 9D       ; \ Return if sprites locked			 
                      BNE Return03C38F                    ;; 03C352 : D0 3B       ; /						 
                      JSR SubHorzPosBnk3                  ;; 03C354 : 20 17 B8    ; \ Always face mario				 
                      TYA                                 ;; 03C357 : 98          ;  |						 
                      STA.W !SpriteMisc157C,X             ;; 03C358 : 9D 7C 15    ; /						 
                      JSR SubOffscreen0Bnk3               ;; 03C35B : 20 5D B8    ; Only process while onscreen			 
                      JSL SprSpr_MarioSprRts              ;; 03C35E : 22 3A 80 01 ; Interact with mario				 
                      JSL UpdateSpritePos                 ;; 03C362 : 22 2A 80 01 ; Update position based on speed values       
                      LDA.W !SpriteBlockedDirs,X          ;; 03C366 : BD 88 15    ; \ Branch if not on ground 
                      AND.B #$04                          ;; 03C369 : 29 04       ;  | 
                      BEQ CODE_03C385                     ;; 03C36B : F0 18       ; / 
                      STZ.B !SpriteYSpeed,X               ;; 03C36D : 74 AA       ; Sprite Y Speed = 0 
                      LDA.W !SpriteMisc1540,X             ;; 03C36F : BD 40 15    ;
                      BNE CODE_03C385                     ;; 03C372 : D0 11       ;
                      LDA.B #$60                          ;; 03C374 : A9 60       ;
                      STA.W !SpriteMisc1540,X             ;; 03C376 : 9D 40 15    ;
                      INC.B !SpriteTableC2,X              ;; 03C379 : F6 C2       ;
                      LDA.B !SpriteTableC2,X              ;; 03C37B : B5 C2       ;
                      AND.B #$03                          ;; 03C37D : 29 03       ;
                      TAY                                 ;; 03C37F : A8          ;
                      LDA.W NinjiSpeedY,Y                 ;; 03C380 : B9 48 C3    ;
                      STA.B !SpriteYSpeed,X               ;; 03C383 : 95 AA       ;
CODE_03C385:          LDA.B #$00                          ;; 03C385 : A9 00       ;
                      LDY.B !SpriteYSpeed,X               ;; 03C387 : B4 AA       ;
                      BMI CODE_03C38C                     ;; 03C389 : 30 01       ;
                      INC A                               ;; 03C38B : 1A          ;
CODE_03C38C:          STA.W !SpriteMisc1602,X             ;; 03C38C : 9D 02 16    ;
Return03C38F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C390:          PHB                                 ;; 03C390 : 8B          ;
                      PHK                                 ;; 03C391 : 4B          ;
                      PLB                                 ;; 03C392 : AB          ;
                      LDA.W !SpriteMisc157C,X             ;; 03C393 : BD 7C 15    ;
                      PHA                                 ;; 03C396 : 48          ;
                      LDY.W !SpriteMisc15AC,X             ;; 03C397 : BC AC 15    ;
                      BEQ CODE_03C3A5                     ;; 03C39A : F0 09       ;
                      CPY.B #$05                          ;; 03C39C : C0 05       ;
                      BCC CODE_03C3A5                     ;; 03C39E : 90 05       ;
                      EOR.B #$01                          ;; 03C3A0 : 49 01       ;
                      STA.W !SpriteMisc157C,X             ;; 03C3A2 : 9D 7C 15    ;
CODE_03C3A5:          JSR CODE_03C3DA                     ;; 03C3A5 : 20 DA C3    ;
                      PLA                                 ;; 03C3A8 : 68          ;
                      STA.W !SpriteMisc157C,X             ;; 03C3A9 : 9D 7C 15    ;
                      PLB                                 ;; 03C3AC : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03C3AE:          JSL GenericSprGfxRt2                ;; 03C3AE : 22 B2 90 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DryBonesTileDispX:    db $00,$08,$00,$00,$F8,$00,$00,$04  ;; ?QPWZ?               ;
                      db $00,$00,$FC,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesGfxProp:      db $43,$43,$43,$03,$03,$03          ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesTileDispY:    db $F4,$F0,$00,$F4,$F1,$00,$F4,$F0  ;; ?QPWZ?               ;
                      db $00                              ;; ?QPWZ?               ;
                                                          ;;                      ;
DryBonesTiles:        db $00,$64,$66,$00,$64,$68,$82,$64  ;; ?QPWZ?               ;
                      db $E6                              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C3D7:          db $00,$00,$FF                      ;; 03C3D7               ;
                                                          ;;                      ;
CODE_03C3DA:          LDA.B !SpriteNumber,X               ;; 03C3DA : B5 9E       ;
                      CMP.B #$31                          ;; 03C3DC : C9 31       ;
                      BEQ CODE_03C3AE                     ;; 03C3DE : F0 CE       ;
                      JSR GetDrawInfoBnk3                 ;; 03C3E0 : 20 60 B7    ;
                      LDA.W !SpriteMisc15AC,X             ;; 03C3E3 : BD AC 15    ;
                      STA.B !_5                           ;; 03C3E6 : 85 05       ;
                      LDA.W !SpriteMisc157C,X             ;; 03C3E8 : BD 7C 15    ;
                      ASL A                               ;; 03C3EB : 0A          ;
                      ADC.W !SpriteMisc157C,X             ;; 03C3EC : 7D 7C 15    ;
                      STA.B !_2                           ;; 03C3EF : 85 02       ;
                      PHX                                 ;; 03C3F1 : DA          ;
                      LDA.W !SpriteMisc1602,X             ;; 03C3F2 : BD 02 16    ;
                      PHA                                 ;; 03C3F5 : 48          ;
                      ASL A                               ;; 03C3F6 : 0A          ;
                      ADC.W !SpriteMisc1602,X             ;; 03C3F7 : 7D 02 16    ;
                      STA.B !_3                           ;; 03C3FA : 85 03       ;
                      PLX                                 ;; 03C3FC : FA          ;
                      LDA.W DATA_03C3D7,X                 ;; 03C3FD : BD D7 C3    ;
                      STA.B !_4                           ;; 03C400 : 85 04       ;
                      LDX.B #$02                          ;; 03C402 : A2 02       ;
CODE_03C404:          PHX                                 ;; 03C404 : DA          ;
                      TXA                                 ;; 03C405 : 8A          ;
                      CLC                                 ;; 03C406 : 18          ;
                      ADC.B !_2                           ;; 03C407 : 65 02       ;
                      TAX                                 ;; 03C409 : AA          ;
                      PHX                                 ;; 03C40A : DA          ;
                      LDA.B !_5                           ;; 03C40B : A5 05       ;
                      BEQ CODE_03C414                     ;; 03C40D : F0 05       ;
                      TXA                                 ;; 03C40F : 8A          ;
                      CLC                                 ;; 03C410 : 18          ;
                      ADC.B #$06                          ;; 03C411 : 69 06       ;
                      TAX                                 ;; 03C413 : AA          ;
CODE_03C414:          LDA.B !_0                           ;; 03C414 : A5 00       ;
                      CLC                                 ;; 03C416 : 18          ;
                      ADC.W DryBonesTileDispX,X           ;; 03C417 : 7D B3 C3    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03C41A : 99 00 03    ;
                      PLX                                 ;; 03C41D : FA          ;
                      LDA.W DryBonesGfxProp,X             ;; 03C41E : BD BF C3    ;
                      ORA.B !SpriteProperties             ;; 03C421 : 05 64       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C423 : 99 03 03    ;
                      PLA                                 ;; 03C426 : 68          ;
                      PHA                                 ;; 03C427 : 48          ;
                      CLC                                 ;; 03C428 : 18          ;
                      ADC.B !_3                           ;; 03C429 : 65 03       ;
                      TAX                                 ;; 03C42B : AA          ;
                      LDA.B !_1                           ;; 03C42C : A5 01       ;
                      CLC                                 ;; 03C42E : 18          ;
                      ADC.W DryBonesTileDispY,X           ;; 03C42F : 7D C5 C3    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03C432 : 99 01 03    ;
                      LDA.W DryBonesTiles,X               ;; 03C435 : BD CE C3    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C438 : 99 02 03    ;
                      PLX                                 ;; 03C43B : FA          ;
                      INY                                 ;; 03C43C : C8          ;
                      INY                                 ;; 03C43D : C8          ;
                      INY                                 ;; 03C43E : C8          ;
                      INY                                 ;; 03C43F : C8          ;
                      DEX                                 ;; 03C440 : CA          ;
                      CPX.B !_4                           ;; 03C441 : E4 04       ;
                      BNE CODE_03C404                     ;; 03C443 : D0 BF       ;
                      PLX                                 ;; 03C445 : FA          ;
                      LDY.B #$02                          ;; 03C446 : A0 02       ;
                      TYA                                 ;; 03C448 : 98          ;
                      JSL FinishOAMWrite                  ;; 03C449 : 22 B3 B7 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C44E:          LDA.W !SpriteOffscreenX,X           ;; 03C44E : BD A0 15    ;
                      ORA.W !SpriteOffscreenVert,X        ;; 03C451 : 1D 6C 18    ;
                      BNE Return03C460                    ;; 03C454 : D0 0A       ;
                      LDY.B #$07                          ;; 03C456 : A0 07       ; \ Find a free extended sprite slot 
CODE_03C458:          LDA.W !ExtSpriteNumber,Y            ;; 03C458 : B9 0B 17    ;  | 
                      BEQ CODE_03C461                     ;; 03C45B : F0 04       ;  | 
                      DEY                                 ;; 03C45D : 88          ;  | 
                      BPL CODE_03C458                     ;; 03C45E : 10 F8       ;  | 
Return03C460:         RTL                                 ;; ?QPWZ? : 6B          ; / Return if no free slots 
                                                          ;;                      ;
CODE_03C461:          LDA.B #$06                          ;; 03C461 : A9 06       ; \ Extended sprite = Bone 
                      STA.W !ExtSpriteNumber,Y            ;; 03C463 : 99 0B 17    ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03C466 : B5 D8       ;
                      SEC                                 ;; 03C468 : 38          ;
                      SBC.B #$10                          ;; 03C469 : E9 10       ;
                      STA.W !ExtSpriteYPosLow,Y           ;; 03C46B : 99 15 17    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03C46E : BD D4 14    ;
                      SBC.B #$00                          ;; 03C471 : E9 00       ;
                      STA.W !ExtSpriteYPosHigh,Y          ;; 03C473 : 99 29 17    ;
                      LDA.B !SpriteXPosLow,X              ;; 03C476 : B5 E4       ;
                      STA.W !ExtSpriteXPosLow,Y           ;; 03C478 : 99 1F 17    ;
                      LDA.W !SpriteYPosHigh,X             ;; 03C47B : BD E0 14    ;
                      STA.W !ExtSpriteXPosHigh,Y          ;; 03C47E : 99 33 17    ;
                      LDA.W !SpriteMisc157C,X             ;; 03C481 : BD 7C 15    ;
                      LSR A                               ;; 03C484 : 4A          ;
                      LDA.B #$18                          ;; 03C485 : A9 18       ;
                      BCC CODE_03C48B                     ;; 03C487 : 90 02       ;
                      LDA.B #$E8                          ;; 03C489 : A9 E8       ;
CODE_03C48B:          STA.W !ExtSpriteXSpeed,Y            ;; 03C48B : 99 47 17    ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C48F:          db $01,$FF                          ;; 03C48F               ;
                                                          ;;                      ;
DATA_03C491:          db $FF,$90                          ;; 03C491               ;
                                                          ;;                      ;
DiscoBallTiles:       db $80,$82,$84,$86,$88,$8C,$C0,$C2  ;; ?QPWZ?               ;
                      db $C2                              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C49C:          db $31,$33,$35,$37,$31,$33,$35,$37  ;; 03C49C               ;
                      db $39                              ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C4A5:          LDY.W !SpriteOAMIndex,X             ;; 03C4A5 : BC EA 15    ; Y = Index into sprite OAM 
                      LDA.B #$78                          ;; 03C4A8 : A9 78       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03C4AA : 99 00 03    ;
                      LDA.B #$28                          ;; 03C4AD : A9 28       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03C4AF : 99 01 03    ;
                      PHX                                 ;; 03C4B2 : DA          ;
                      LDA.B !SpriteTableC2,X              ;; 03C4B3 : B5 C2       ;
                      LDX.B #$08                          ;; 03C4B5 : A2 08       ;
                      AND.B #$01                          ;; 03C4B7 : 29 01       ;
                      BEQ CODE_03C4C1                     ;; 03C4B9 : F0 06       ;
                      LDA.B !TrueFrame                    ;; 03C4BB : A5 13       ;
                      LSR A                               ;; 03C4BD : 4A          ;
                      AND.B #$07                          ;; 03C4BE : 29 07       ;
                      TAX                                 ;; 03C4C0 : AA          ;
CODE_03C4C1:          LDA.W DiscoBallTiles,X              ;; 03C4C1 : BD 93 C4    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C4C4 : 99 02 03    ;
                      LDA.W DATA_03C49C,X                 ;; 03C4C7 : BD 9C C4    ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C4CA : 99 03 03    ;
                      TYA                                 ;; 03C4CD : 98          ;
                      LSR A                               ;; 03C4CE : 4A          ;
                      LSR A                               ;; 03C4CF : 4A          ;
                      TAY                                 ;; 03C4D0 : A8          ;
                      LDA.B #$02                          ;; 03C4D1 : A9 02       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03C4D3 : 99 60 04    ;
                      PLX                                 ;; 03C4D6 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C4D8:          db $10,$8C                          ;; 03C4D8               ;
                                                          ;;                      ;
DATA_03C4DA:          db $42,$31                          ;; 03C4DA               ;
                                                          ;;                      ;
DarkRoomWithLight:    LDA.W !SpriteMisc1534,X             ;; ?QPWZ? : BD 34 15    ;
                      BNE CODE_03C500                     ;; 03C4DF : D0 1F       ;
                      LDY.B #$09                          ;; 03C4E1 : A0 09       ;
CODE_03C4E3:          CPY.W !CurSpriteProcess             ;; 03C4E3 : CC E9 15    ;
                      BEQ CODE_03C4FA                     ;; 03C4E6 : F0 12       ;
                      LDA.W !SpriteStatus,Y               ;; 03C4E8 : B9 C8 14    ;
                      CMP.B #$08                          ;; 03C4EB : C9 08       ;
                      BNE CODE_03C4FA                     ;; 03C4ED : D0 0B       ;
                      LDA.W !SpriteNumber,Y               ;; 03C4EF : B9 9E 00    ;
                      CMP.B #$C6                          ;; 03C4F2 : C9 C6       ;
                      BNE CODE_03C4FA                     ;; 03C4F4 : D0 04       ;
                      STZ.W !SpriteStatus,X               ;; 03C4F6 : 9E C8 14    ;
Return03C4F9:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C4FA:          DEY                                 ;; 03C4FA : 88          ;
                      BPL CODE_03C4E3                     ;; 03C4FB : 10 E6       ;
                      INC.W !SpriteMisc1534,X             ;; 03C4FD : FE 34 15    ;
CODE_03C500:          JSR CODE_03C4A5                     ;; 03C500 : 20 A5 C4    ;
                      LDA.B #$FF                          ;; 03C503 : A9 FF       ;
                      STA.B !ColorSettings                ;; 03C505 : 85 40       ;
                      LDA.B #$20                          ;; 03C507 : A9 20       ;
                      STA.B !ColorAddition                ;; 03C509 : 85 44       ;
                      LDA.B #$20                          ;; 03C50B : A9 20       ;
                      STA.B !OBJCWWindow                  ;; 03C50D : 85 43       ;
                      LDA.B #$80                          ;; 03C50F : A9 80       ;
                      STA.W !HDMAEnable                   ;; 03C511 : 8D 9F 0D    ;
                      LDA.B !SpriteTableC2,X              ;; 03C514 : B5 C2       ;
                      AND.B #$01                          ;; 03C516 : 29 01       ;
                      TAY                                 ;; 03C518 : A8          ;
                      LDA.W DATA_03C4D8,Y                 ;; 03C519 : B9 D8 C4    ;
                      STA.W !BackgroundColor              ;; 03C51C : 8D 01 07    ;
                      LDA.W DATA_03C4DA,Y                 ;; 03C51F : B9 DA C4    ;
                      STA.W !BackgroundColor+1            ;; 03C522 : 8D 02 07    ;
                      LDA.B !SpriteLock                   ;; 03C525 : A5 9D       ;
                      BNE Return03C4F9                    ;; 03C527 : D0 D0       ;
                      LDA.W !LightSkipInit                ;; 03C529 : AD 82 14    ;
                      BNE CODE_03C54D                     ;; 03C52C : D0 1F       ;
                      LDA.B #$00                          ;; 03C52E : A9 00       ;
                      STA.W !LightBotWinOpenPos           ;; 03C530 : 8D 76 14    ;
                      LDA.B #$90                          ;; 03C533 : A9 90       ;
                      STA.W !LightBotWinClosePos          ;; 03C535 : 8D 78 14    ;
                      LDA.B #$78                          ;; 03C538 : A9 78       ;
                      STA.W !LightTopWinOpenPos           ;; 03C53A : 8D 72 14    ;
                      LDA.B #$87                          ;; 03C53D : A9 87       ;
                      STA.W !LightTopWinClosePos          ;; 03C53F : 8D 74 14    ;
                      LDA.B #$01                          ;; 03C542 : A9 01       ;
                      STA.W !LightExists                  ;; 03C544 : 8D 86 14    ;
                      STZ.W !LightMoveDir                 ;; 03C547 : 9C 83 14    ;
                      INC.W !LightSkipInit                ;; 03C54A : EE 82 14    ;
CODE_03C54D:          LDY.W !LightMoveDir                 ;; 03C54D : AC 83 14    ;
                      LDA.W !LightBotWinOpenPos           ;; 03C550 : AD 76 14    ;
                      CLC                                 ;; 03C553 : 18          ;
                      ADC.W DATA_03C48F,Y                 ;; 03C554 : 79 8F C4    ;
                      STA.W !LightBotWinOpenPos           ;; 03C557 : 8D 76 14    ;
                      LDA.W !LightBotWinClosePos          ;; 03C55A : AD 78 14    ;
                      CLC                                 ;; 03C55D : 18          ;
                      ADC.W DATA_03C48F,Y                 ;; 03C55E : 79 8F C4    ;
                      STA.W !LightBotWinClosePos          ;; 03C561 : 8D 78 14    ;
                      CMP.W DATA_03C491,Y                 ;; 03C564 : D9 91 C4    ;
                      BNE CODE_03C572                     ;; 03C567 : D0 09       ;
                      LDA.W !LightMoveDir                 ;; 03C569 : AD 83 14    ;
                      INC A                               ;; 03C56C : 1A          ;
                      AND.B #$01                          ;; 03C56D : 29 01       ;
                      STA.W !LightMoveDir                 ;; 03C56F : 8D 83 14    ;
CODE_03C572:          LDA.B !TrueFrame                    ;; 03C572 : A5 13       ;
                      AND.B #$03                          ;; 03C574 : 29 03       ;
                      BNE Return03C4F9                    ;; 03C576 : D0 81       ;
                      LDY.B #$00                          ;; 03C578 : A0 00       ;
                      LDA.W !LightTopWinOpenPos           ;; 03C57A : AD 72 14    ;
                      STA.W !LightWinOpenCalc             ;; 03C57D : 8D 7A 14    ;
                      SEC                                 ;; 03C580 : 38          ;
                      SBC.W !LightBotWinOpenPos           ;; 03C581 : ED 76 14    ;
                      BCS CODE_03C58A                     ;; 03C584 : B0 04       ;
                      INY                                 ;; 03C586 : C8          ;
                      EOR.B #$FF                          ;; 03C587 : 49 FF       ;
                      INC A                               ;; 03C589 : 1A          ;
CODE_03C58A:          STA.W !LightLeftWidth               ;; 03C58A : 8D 80 14    ;
                      STY.W !LightLeftRelPos              ;; 03C58D : 8C 84 14    ;
                      STZ.W !LightWinOpenMove             ;; 03C590 : 9C 7E 14    ;
                      LDY.B #$00                          ;; 03C593 : A0 00       ;
                      LDA.W !LightTopWinClosePos          ;; 03C595 : AD 74 14    ;
                      STA.W !LightWinCloseCalc            ;; 03C598 : 8D 7C 14    ;
                      SEC                                 ;; 03C59B : 38          ;
                      SBC.W !LightBotWinClosePos          ;; 03C59C : ED 78 14    ;
                      BCS CODE_03C5A5                     ;; 03C59F : B0 04       ;
                      INY                                 ;; 03C5A1 : C8          ;
                      EOR.B #$FF                          ;; 03C5A2 : 49 FF       ;
                      INC A                               ;; 03C5A4 : 1A          ;
CODE_03C5A5:          STA.W !LightRightWidth              ;; 03C5A5 : 8D 81 14    ;
                      STY.W !LightRightRelPos             ;; 03C5A8 : 8C 85 14    ;
                      STZ.W !LightWinCloseMove            ;; 03C5AB : 9C 7F 14    ;
                      LDA.B !SpriteTableC2,X              ;; 03C5AE : B5 C2       ;
                      STA.B !_F                           ;; 03C5B0 : 85 0F       ;
                      PHX                                 ;; 03C5B2 : DA          ;
                      REP #$10                            ;; 03C5B3 : C2 10       ; Index (16 bit) 
                      LDX.W #$0000                        ;; 03C5B5 : A2 00 00    ;
CODE_03C5B8:          CPX.W #$005F                        ;; 03C5B8 : E0 5F 00    ;
                      BCC CODE_03C607                     ;; 03C5BB : 90 4A       ;
                      LDA.W !LightWinOpenMove             ;; 03C5BD : AD 7E 14    ;
                      CLC                                 ;; 03C5C0 : 18          ;
                      ADC.W !LightLeftWidth               ;; 03C5C1 : 6D 80 14    ;
                      STA.W !LightWinOpenMove             ;; 03C5C4 : 8D 7E 14    ;
                      BCS CODE_03C5CD                     ;; 03C5C7 : B0 04       ;
                      CMP.B #$CF                          ;; 03C5C9 : C9 CF       ;
                      BCC CODE_03C5E0                     ;; 03C5CB : 90 13       ;
CODE_03C5CD:          SBC.B #$CF                          ;; 03C5CD : E9 CF       ;
                      STA.W !LightWinOpenMove             ;; 03C5CF : 8D 7E 14    ;
                      INC.W !LightWinOpenCalc             ;; 03C5D2 : EE 7A 14    ;
                      LDA.W !LightLeftRelPos              ;; 03C5D5 : AD 84 14    ;
                      BNE CODE_03C5E0                     ;; 03C5D8 : D0 06       ;
                      DEC.W !LightWinOpenCalc             ;; 03C5DA : CE 7A 14    ;
                      DEC.W !LightWinOpenCalc             ;; 03C5DD : CE 7A 14    ;
CODE_03C5E0:          LDA.W !LightWinCloseMove            ;; 03C5E0 : AD 7F 14    ;
                      CLC                                 ;; 03C5E3 : 18          ;
                      ADC.W !LightRightWidth              ;; 03C5E4 : 6D 81 14    ;
                      STA.W !LightWinCloseMove            ;; 03C5E7 : 8D 7F 14    ;
                      BCS CODE_03C5F0                     ;; 03C5EA : B0 04       ;
                      CMP.B #$CF                          ;; 03C5EC : C9 CF       ;
                      BCC CODE_03C603                     ;; 03C5EE : 90 13       ;
CODE_03C5F0:          SBC.B #$CF                          ;; 03C5F0 : E9 CF       ;
                      STA.W !LightWinCloseMove            ;; 03C5F2 : 8D 7F 14    ;
                      INC.W !LightWinCloseCalc            ;; 03C5F5 : EE 7C 14    ;
                      LDA.W !LightRightRelPos             ;; 03C5F8 : AD 85 14    ;
                      BNE CODE_03C603                     ;; 03C5FB : D0 06       ;
                      DEC.W !LightWinCloseCalc            ;; 03C5FD : CE 7C 14    ;
                      DEC.W !LightWinCloseCalc            ;; 03C600 : CE 7C 14    ;
CODE_03C603:          LDA.B !_F                           ;; 03C603 : A5 0F       ;
                      BNE CODE_03C60F                     ;; 03C605 : D0 08       ;
CODE_03C607:          LDA.B #$01                          ;; 03C607 : A9 01       ;
                      STA.W !WindowTable,X                ;; 03C609 : 9D A0 04    ;
                      DEC A                               ;; 03C60C : 3A          ;
                      BRA CODE_03C618                     ;; 03C60D : 80 09       ;
                                                          ;;                      ;
CODE_03C60F:          LDA.W !LightWinOpenCalc             ;; 03C60F : AD 7A 14    ;
                      STA.W !WindowTable,X                ;; 03C612 : 9D A0 04    ;
                      LDA.W !LightWinCloseCalc            ;; 03C615 : AD 7C 14    ;
CODE_03C618:          STA.W !WindowTable+1,X              ;; 03C618 : 9D A1 04    ;
                      INX                                 ;; 03C61B : E8          ;
                      INX                                 ;; 03C61C : E8          ;
                      CPX.W #$01C0                        ;; 03C61D : E0 C0 01    ;
                      BNE CODE_03C5B8                     ;; 03C620 : D0 96       ;
                      SEP #$10                            ;; 03C622 : E2 10       ; Index (8 bit) 
                      PLX                                 ;; 03C624 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C626:          db $14,$28,$38,$20,$30,$4C,$40,$34  ;; 03C626               ;
                      db $2C,$1C,$08,$0C,$04,$0C,$1C,$24  ;; ?QPWZ?               ;
                      db $2C,$38,$40,$48,$50,$5C,$5C,$6C  ;; ?QPWZ?               ;
                      db $4C,$58,$24,$78,$64,$70,$78,$7C  ;; ?QPWZ?               ;
                      db $70,$68,$58,$4C,$40,$34,$24,$04  ;; ?QPWZ?               ;
                      db $18,$2C,$0C,$0C,$14,$18,$1C,$24  ;; ?QPWZ?               ;
                      db $2C,$28,$24,$30,$30,$34,$38,$3C  ;; ?QPWZ?               ;
                      db $44,$54,$48,$5C,$68,$40,$4C,$40  ;; ?QPWZ?               ;
                      db $3C,$40,$50,$54,$60,$54,$4C,$5C  ;; ?QPWZ?               ;
                      db $5C,$68,$74,$6C,$7C,$78,$68,$80  ;; ?QPWZ?               ;
                      db $18,$48,$2C,$1C                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C67A:          db $1C,$0C,$08,$1C,$14,$08,$14,$24  ;; 03C67A               ;
                      db $28,$2C,$30,$3C,$44,$4C,$44,$34  ;; ?QPWZ?               ;
                      db $40,$34,$24,$1C,$10,$0C,$18,$18  ;; ?QPWZ?               ;
                      db $2C,$28,$68,$28,$34,$34,$38,$40  ;; ?QPWZ?               ;
                      db $44,$44,$38,$3C,$44,$48,$4C,$5C  ;; ?QPWZ?               ;
                      db $5C,$54,$64,$74,$74,$88,$80,$94  ;; ?QPWZ?               ;
                      db $8C,$78,$6C,$64,$70,$7C,$8C,$98  ;; ?QPWZ?               ;
                      db $90,$98,$84,$84,$88,$78,$78,$6C  ;; ?QPWZ?               ;
                      db $5C,$50,$50,$48,$50,$5C,$64,$64  ;; ?QPWZ?               ;
                      db $74,$78,$74,$64,$60,$58,$54,$50  ;; ?QPWZ?               ;
                      db $50,$58,$30,$34                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C6CE:          db $20,$30,$39,$47,$50,$60,$70,$7C  ;; 03C6CE               ;
                      db $7B,$80,$7D,$78,$6E,$60,$4F,$47  ;; ?QPWZ?               ;
                      db $41,$38,$30,$2A,$20,$10,$04,$00  ;; ?QPWZ?               ;
                      db $00,$08,$10,$20,$1A,$10,$0A,$06  ;; ?QPWZ?               ;
                      db $0F,$17,$16,$1C,$1F,$21,$10,$18  ;; ?QPWZ?               ;
                      db $20,$2C,$2E,$3B,$30,$30,$2D,$2A  ;; ?QPWZ?               ;
                      db $34,$36,$3A,$3F,$45,$4D,$5F,$54  ;; ?QPWZ?               ;
                      db $4E,$67,$70,$67,$70,$5C,$4E,$40  ;; ?QPWZ?               ;
                      db $48,$56,$57,$5F,$68,$72,$77,$6F  ;; ?QPWZ?               ;
                      db $66,$60,$67,$5C,$57,$4B,$4D,$54  ;; ?QPWZ?               ;
                      db $48,$43,$3D,$3C                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C722:          db $18,$1E,$25,$22,$1A,$17,$20,$30  ;; 03C722               ;
                      db $41,$4F,$61,$70,$7F,$8C,$94,$92  ;; ?QPWZ?               ;
                      db $A0,$86,$93,$88,$88,$78,$66,$50  ;; ?QPWZ?               ;
                      db $40,$30,$22,$20,$2C,$30,$40,$4F  ;; ?QPWZ?               ;
                      db $59,$51,$3F,$39,$4C,$5F,$6A,$6F  ;; ?QPWZ?               ;
                      db $77,$7E,$6C,$60,$58,$48,$3D,$2F  ;; ?QPWZ?               ;
                      db $28,$38,$44,$30,$36,$27,$21,$2F  ;; ?QPWZ?               ;
                      db $39,$2A,$2F,$39,$40,$3F,$49,$50  ;; ?QPWZ?               ;
                      db $60,$59,$4C,$51,$48,$4F,$56,$67  ;; ?QPWZ?               ;
                      db $5B,$68,$75,$7D,$87,$8A,$7A,$6B  ;; ?QPWZ?               ;
                      db $70,$82,$73,$92                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C776:          db $60,$B0,$40,$80                  ;; 03C776               ;
                                                          ;;                      ;
FireworkSfx1:         db $26,$00,$26,$28                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx2:         db $00,$2B,$00,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx3:         db $27,$00,$27,$29                  ;; ?QPWZ?               ;
                                                          ;;                      ;
FireworkSfx4:         db $00,$2C,$00,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03C78A:          db $00,$AA,$FF,$AA                  ;; 03C78A               ;
                                                          ;;                      ;
DATA_03C78E:          db $00,$7E,$27,$7E                  ;; 03C78E               ;
                                                          ;;                      ;
DATA_03C792:          db $C0,$C0,$FF,$C0                  ;; 03C792               ;
                                                          ;;                      ;
CODE_03C796:          LDA.W !SpriteMisc1564,X             ;; 03C796 : BD 64 15    ;
                      BEQ CODE_03C7A7                     ;; 03C799 : F0 0C       ;
                      DEC A                               ;; 03C79B : 3A          ;
                      BNE Return03C7A6                    ;; 03C79C : D0 08       ;
                      INC.W !CutsceneID                   ;; 03C79E : EE C6 13    ;
                      LDA.B #$FF                          ;; 03C7A1 : A9 FF       ;
                      STA.W !EndLevelTimer                ;; 03C7A3 : 8D 93 14    ;
Return03C7A6:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C7A7:          LDA.W !SpriteMisc1564+9             ;; 03C7A7 : AD 6D 15    ;
                      AND.B #$03                          ;; 03C7AA : 29 03       ;
                      TAY                                 ;; 03C7AC : A8          ;
                      LDA.W DATA_03C78A,Y                 ;; 03C7AD : B9 8A C7    ;
                      STA.W !BackgroundColor              ;; 03C7B0 : 8D 01 07    ;
                      LDA.W DATA_03C78E,Y                 ;; 03C7B3 : B9 8E C7    ;
                      STA.W !BackgroundColor+1            ;; 03C7B6 : 8D 02 07    ;
                      LDA.W !SpriteMisc1FE2+9             ;; 03C7B9 : AD EB 1F    ;
                      BNE Return03C80F                    ;; 03C7BC : D0 51       ;
                      LDA.W !SpriteMisc1534,X             ;; 03C7BE : BD 34 15    ;
                      CMP.B #$04                          ;; 03C7C1 : C9 04       ;
                      BEQ CODE_03C810                     ;; 03C7C3 : F0 4B       ;
                      LDY.B #$01                          ;; 03C7C5 : A0 01       ;
CODE_03C7C7:          LDA.W !SpriteStatus,Y               ;; 03C7C7 : B9 C8 14    ;
                      BEQ CODE_03C7D0                     ;; 03C7CA : F0 04       ;
                      DEY                                 ;; 03C7CC : 88          ;
                      BPL CODE_03C7C7                     ;; 03C7CD : 10 F8       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C7D0:          LDA.B #$08                          ;; 03C7D0 : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03C7D2 : 99 C8 14    ; / 
                      LDA.B #$7A                          ;; 03C7D5 : A9 7A       ;
                      STA.W !SpriteNumber,Y               ;; 03C7D7 : 99 9E 00    ;
                      LDA.B #$00                          ;; 03C7DA : A9 00       ;
                      STA.W !SpriteYPosHigh,Y             ;; 03C7DC : 99 E0 14    ;
                      LDA.B #$A8                          ;; 03C7DF : A9 A8       ;
                      CLC                                 ;; 03C7E1 : 18          ;
                      ADC.B !Layer1YPos                   ;; 03C7E2 : 65 1C       ;
                      STA.W !SpriteYPosLow,Y              ;; 03C7E4 : 99 D8 00    ;
                      LDA.B !Layer1YPos+1                 ;; 03C7E7 : A5 1D       ;
                      ADC.B #$00                          ;; 03C7E9 : 69 00       ;
                      STA.W !SpriteXPosHigh,Y             ;; 03C7EB : 99 D4 14    ;
                      PHX                                 ;; 03C7EE : DA          ;
                      TYX                                 ;; 03C7EF : BB          ;
                      JSL InitSpriteTables                ;; 03C7F0 : 22 D2 F7 07 ;
                      PLX                                 ;; 03C7F4 : FA          ;
                      PHX                                 ;; 03C7F5 : DA          ;
                      LDA.W !SpriteMisc1534,X             ;; 03C7F6 : BD 34 15    ;
                      AND.B #$03                          ;; 03C7F9 : 29 03       ;
                      STA.W !SpriteMisc1534,Y             ;; 03C7FB : 99 34 15    ;
                      TAX                                 ;; 03C7FE : AA          ;
                      LDA.W DATA_03C792,X                 ;; 03C7FF : BD 92 C7    ;
                      STA.W !SpriteMisc1FE2+9             ;; 03C802 : 8D EB 1F    ;
                      LDA.W DATA_03C776,X                 ;; 03C805 : BD 76 C7    ;
                      STA.W !SpriteXPosLow,Y              ;; 03C808 : 99 E4 00    ;
                      PLX                                 ;; 03C80B : FA          ;
                      INC.W !SpriteMisc1534,X             ;; 03C80C : FE 34 15    ;
Return03C80F:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03C810:          LDA.B #$70                          ;; 03C810 : A9 70       ;
                      STA.W !SpriteMisc1564,X             ;; 03C812 : 9D 64 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
Firework:             LDA.B !SpriteTableC2,X              ;; ?QPWZ? : B5 C2       ;
                      JSL ExecutePtr                      ;; 03C818 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03C828                      ;; ?QPWZ? : 28 C8       ;
                      dw CODE_03C845                      ;; ?QPWZ? : 45 C8       ;
                      dw CODE_03C88D                      ;; ?QPWZ? : 8D C8       ;
                      dw CODE_03C941                      ;; ?QPWZ? : 41 C9       ;
                                                          ;;                      ;
FireworkSpeedY:       db $E4,$E6,$E4,$E2                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C828:          LDY.W !SpriteMisc1534,X             ;; 03C828 : BC 34 15    ;
                      LDA.W FireworkSpeedY,Y              ;; 03C82B : B9 24 C8    ;
                      STA.B !SpriteYSpeed,X               ;; 03C82E : 95 AA       ;
                      LDA.B #$25                          ;; 03C830 : A9 25       ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03C832 : 8D FC 1D    ; / 
                      LDA.B #$10                          ;; 03C835 : A9 10       ;
                      STA.W !SpriteMisc1564,X             ;; 03C837 : 9D 64 15    ;
                      INC.B !SpriteTableC2,X              ;; 03C83A : F6 C2       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C83D:          db $14,$0C,$10,$15                  ;; 03C83D               ;
                                                          ;;                      ;
DATA_03C841:          db $08,$10,$0C,$05                  ;; 03C841               ;
                                                          ;;                      ;
CODE_03C845:          LDA.W !SpriteMisc1564,X             ;; 03C845 : BD 64 15    ;
                      CMP.B #$01                          ;; 03C848 : C9 01       ;
                      BNE CODE_03C85B                     ;; 03C84A : D0 0F       ;
                      LDY.W !SpriteMisc1534,X             ;; 03C84C : BC 34 15    ;
                      LDA.W FireworkSfx1,Y                ;; 03C84F : B9 7A C7    ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03C852 : 8D F9 1D    ; / 
                      LDA.W FireworkSfx2,Y                ;; 03C855 : B9 7E C7    ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03C858 : 8D FC 1D    ; / 
CODE_03C85B:          JSL UpdateYPosNoGvtyW               ;; 03C85B : 22 1A 80 01 ;
                      INC.B !SpriteXSpeed,X               ;; 03C85F : F6 B6       ;
                      LDA.B !SpriteXSpeed,X               ;; 03C861 : B5 B6       ;
                      AND.B #$03                          ;; 03C863 : 29 03       ;
                      BNE CODE_03C869                     ;; 03C865 : D0 02       ;
                      INC.B !SpriteYSpeed,X               ;; 03C867 : F6 AA       ;
CODE_03C869:          LDA.B !SpriteYSpeed,X               ;; 03C869 : B5 AA       ;
                      CMP.B #$FC                          ;; 03C86B : C9 FC       ;
                      BNE CODE_03C885                     ;; 03C86D : D0 16       ;
                      INC.B !SpriteTableC2,X              ;; 03C86F : F6 C2       ;
                      LDY.W !SpriteMisc1534,X             ;; 03C871 : BC 34 15    ;
                      LDA.W DATA_03C83D,Y                 ;; 03C874 : B9 3D C8    ;
                      STA.W !SpriteMisc151C,X             ;; 03C877 : 9D 1C 15    ;
                      LDA.W DATA_03C841,Y                 ;; 03C87A : B9 41 C8    ;
                      STA.W !SpriteMisc15AC,X             ;; 03C87D : 9D AC 15    ;
                      LDA.B #$08                          ;; 03C880 : A9 08       ;
                      STA.W !SpriteMisc1564+9             ;; 03C882 : 8D 6D 15    ;
CODE_03C885:          JSR CODE_03C96D                     ;; 03C885 : 20 6D C9    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C889:          db $FF,$80,$C0,$FF                  ;; 03C889               ;
                                                          ;;                      ;
CODE_03C88D:          LDA.W !SpriteMisc15AC,X             ;; 03C88D : BD AC 15    ;
                      DEC A                               ;; 03C890 : 3A          ;
                      BNE CODE_03C8A2                     ;; 03C891 : D0 0F       ;
                      LDY.W !SpriteMisc1534,X             ;; 03C893 : BC 34 15    ;
                      LDA.W FireworkSfx3,Y                ;; 03C896 : B9 82 C7    ; \ Play sound effect 
                      STA.W !SPCIO0                       ;; 03C899 : 8D F9 1D    ; / 
                      LDA.W FireworkSfx4,Y                ;; 03C89C : B9 86 C7    ; \ Play sound effect 
                      STA.W !SPCIO3                       ;; 03C89F : 8D FC 1D    ; / 
CODE_03C8A2:          JSR CODE_03C8B1                     ;; 03C8A2 : 20 B1 C8    ;
                      LDA.B !SpriteTableC2,X              ;; 03C8A5 : B5 C2       ;
                      CMP.B #$02                          ;; 03C8A7 : C9 02       ;
                      BNE CODE_03C8AE                     ;; 03C8A9 : D0 03       ;
                      JSR CODE_03C8B1                     ;; 03C8AB : 20 B1 C8    ;
CODE_03C8AE:          JMP CODE_03C9E9                     ;; 03C8AE : 4C E9 C9    ;
                                                          ;;                      ;
CODE_03C8B1:          LDY.W !SpriteMisc1534,X             ;; 03C8B1 : BC 34 15    ;
                      LDA.W !SpriteMisc1570,X             ;; 03C8B4 : BD 70 15    ;
                      CLC                                 ;; 03C8B7 : 18          ;
                      ADC.W !SpriteMisc151C,X             ;; 03C8B8 : 7D 1C 15    ;
                      STA.W !SpriteMisc1570,X             ;; 03C8BB : 9D 70 15    ;
                      BCS ADDR_03C8DB                     ;; 03C8BE : B0 1B       ;
                      CMP.W DATA_03C889,Y                 ;; 03C8C0 : D9 89 C8    ;
                      BCS CODE_03C8E0                     ;; 03C8C3 : B0 1B       ;
                      LDA.W !SpriteMisc151C,X             ;; 03C8C5 : BD 1C 15    ;
                      CMP.B #$02                          ;; 03C8C8 : C9 02       ;
                      BCC CODE_03C8D4                     ;; 03C8CA : 90 08       ;
                      SEC                                 ;; 03C8CC : 38          ;
                      SBC.B #$01                          ;; 03C8CD : E9 01       ;
                      STA.W !SpriteMisc151C,X             ;; 03C8CF : 9D 1C 15    ;
                      BCS CODE_03C8E4                     ;; 03C8D2 : B0 10       ;
CODE_03C8D4:          LDA.B #$01                          ;; 03C8D4 : A9 01       ;
                      STA.W !SpriteMisc151C,X             ;; 03C8D6 : 9D 1C 15    ;
                      BRA CODE_03C8E4                     ;; 03C8D9 : 80 09       ;
                                                          ;;                      ;
ADDR_03C8DB:          LDA.B #$FF                          ;; 03C8DB : A9 FF       ;
                      STA.W !SpriteMisc1570,X             ;; 03C8DD : 9D 70 15    ;
CODE_03C8E0:          INC.B !SpriteTableC2,X              ;; 03C8E0 : F6 C2       ;
                      STZ.B !SpriteYSpeed,X               ;; 03C8E2 : 74 AA       ; Sprite Y Speed = 0 
CODE_03C8E4:          LDA.W !SpriteMisc151C,X             ;; 03C8E4 : BD 1C 15    ;
                      AND.B #$FF                          ;; 03C8E7 : 29 FF       ;
                      TAY                                 ;; 03C8E9 : A8          ;
                      LDA.W DATA_03C8F1,Y                 ;; 03C8EA : B9 F1 C8    ;
                      STA.W !SpriteMisc1602,X             ;; 03C8ED : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C8F1:          db $06,$05,$04,$03,$03,$03,$03,$02  ;; 03C8F1               ;
                      db $02,$02,$02,$02,$02,$02,$01,$01  ;; ?QPWZ?               ;
                      db $01,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $03,$03,$03,$03,$03,$03,$03,$03  ;; ?QPWZ?               ;
                      db $03,$03,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $02,$02,$02,$02,$02,$02,$02,$02  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03C941:          LDA.B !TrueFrame                    ;; 03C941 : A5 13       ;
                      AND.B #$07                          ;; 03C943 : 29 07       ;
                      BNE CODE_03C949                     ;; 03C945 : D0 02       ;
                      INC.B !SpriteYSpeed,X               ;; 03C947 : F6 AA       ;
CODE_03C949:          JSL UpdateYPosNoGvtyW               ;; 03C949 : 22 1A 80 01 ;
                      LDA.B #$07                          ;; 03C94D : A9 07       ;
                      LDY.B !SpriteYSpeed,X               ;; 03C94F : B4 AA       ;
                      CPY.B #$08                          ;; 03C951 : C0 08       ;
                      BNE CODE_03C958                     ;; 03C953 : D0 03       ;
                      STZ.W !SpriteStatus,X               ;; 03C955 : 9E C8 14    ;
CODE_03C958:          CPY.B #$03                          ;; 03C958 : C0 03       ;
                      BCC CODE_03C962                     ;; 03C95A : 90 06       ;
                      INC A                               ;; 03C95C : 1A          ;
                      CPY.B #$05                          ;; 03C95D : C0 05       ;
                      BCC CODE_03C962                     ;; 03C95F : 90 01       ;
                      INC A                               ;; 03C961 : 1A          ;
CODE_03C962:          STA.W !SpriteMisc1602,X             ;; 03C962 : 9D 02 16    ;
                      JSR CODE_03C9E9                     ;; 03C965 : 20 E9 C9    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C969:          db $EC,$8E,$EC,$EC                  ;; 03C969               ;
                                                          ;;                      ;
CODE_03C96D:          TXA                                 ;; 03C96D : 8A          ;
                      EOR.B !TrueFrame                    ;; 03C96E : 45 13       ;
                      AND.B #$03                          ;; 03C970 : 29 03       ;
                      BNE Return03C9B8                    ;; 03C972 : D0 44       ;
                      JSR GetDrawInfoBnk3                 ;; 03C974 : 20 60 B7    ;
                      LDY.B #$00                          ;; 03C977 : A0 00       ;
                      LDA.B !_0                           ;; 03C979 : A5 00       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03C97B : 99 00 03    ;
                      STA.W !OAMTileXPos+$104,Y           ;; 03C97E : 99 04 03    ;
                      LDA.B !_1                           ;; 03C981 : A5 01       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03C983 : 99 01 03    ;
                      PHX                                 ;; 03C986 : DA          ;
                      LDA.W !SpriteMisc1534,X             ;; 03C987 : BD 34 15    ;
                      TAX                                 ;; 03C98A : AA          ;
                      LDA.B !TrueFrame                    ;; 03C98B : A5 13       ;
                      LSR A                               ;; 03C98D : 4A          ;
                      LSR A                               ;; 03C98E : 4A          ;
                      AND.B #$02                          ;; 03C98F : 29 02       ;
                      LSR A                               ;; 03C991 : 4A          ;
                      ADC.W DATA_03C969,X                 ;; 03C992 : 7D 69 C9    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03C995 : 99 02 03    ;
                      PLX                                 ;; 03C998 : FA          ;
                      LDA.B !TrueFrame                    ;; 03C999 : A5 13       ;
                      ASL A                               ;; 03C99B : 0A          ;
                      AND.B #$0E                          ;; 03C99C : 29 0E       ;
                      STA.B !_2                           ;; 03C99E : 85 02       ;
                      LDA.B !TrueFrame                    ;; 03C9A0 : A5 13       ;
                      ASL A                               ;; 03C9A2 : 0A          ;
                      ASL A                               ;; 03C9A3 : 0A          ;
                      ASL A                               ;; 03C9A4 : 0A          ;
                      ASL A                               ;; 03C9A5 : 0A          ;
                      AND.B #$40                          ;; 03C9A6 : 29 40       ;
                      ORA.B !_2                           ;; 03C9A8 : 05 02       ;
                      ORA.B #$31                          ;; 03C9AA : 09 31       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03C9AC : 99 03 03    ;
                      TYA                                 ;; 03C9AF : 98          ;
                      LSR A                               ;; 03C9B0 : 4A          ;
                      LSR A                               ;; 03C9B1 : 4A          ;
                      TAY                                 ;; 03C9B2 : A8          ;
                      LDA.B #$00                          ;; 03C9B3 : A9 00       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03C9B5 : 99 60 04    ;
Return03C9B8:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03C9B9:          db $36,$35,$C7,$34,$34,$34,$34,$24  ;; 03C9B9               ;
                      db $03,$03,$36,$35,$C7,$34,$34,$24  ;; ?QPWZ?               ;
                      db $24,$24,$24,$03,$36,$35,$C7,$34  ;; ?QPWZ?               ;
                      db $34,$34,$24,$24,$03,$24,$36,$35  ;; ?QPWZ?               ;
                      db $C7,$34,$24,$24,$24,$24,$24,$03  ;; ?QPWZ?               ;
DATA_03C9E1:          db $00,$01,$01,$00,$00,$FF,$FF,$00  ;; 03C9E1               ;
                                                          ;;                      ;
CODE_03C9E9:          TXA                                 ;; 03C9E9 : 8A          ;
                      EOR.B !TrueFrame                    ;; 03C9EA : 45 13       ;
                      STA.B !_5                           ;; 03C9EC : 85 05       ;
                      LDA.W !SpriteMisc1570,X             ;; 03C9EE : BD 70 15    ;
                      STA.B !_6                           ;; 03C9F1 : 85 06       ;
                      LDA.W !SpriteMisc1602,X             ;; 03C9F3 : BD 02 16    ;
                      STA.B !_7                           ;; 03C9F6 : 85 07       ;
                      LDA.B !SpriteXPosLow,X              ;; 03C9F8 : B5 E4       ;
                      STA.B !_8                           ;; 03C9FA : 85 08       ;
                      LDA.B !SpriteYPosLow,X              ;; 03C9FC : B5 D8       ;
                      SEC                                 ;; 03C9FE : 38          ;
                      SBC.B !Layer1YPos                   ;; 03C9FF : E5 1C       ;
                      STA.B !_9                           ;; 03CA01 : 85 09       ;
                      LDA.W !SpriteMisc1534,X             ;; 03CA03 : BD 34 15    ;
                      STA.B !_A                           ;; 03CA06 : 85 0A       ;
                      PHX                                 ;; 03CA08 : DA          ;
                      LDX.B #$3F                          ;; 03CA09 : A2 3F       ;
                      LDY.B #$00                          ;; 03CA0B : A0 00       ;
CODE_03CA0D:          STX.B !_4                           ;; 03CA0D : 86 04       ;
                      LDA.B !_A                           ;; 03CA0F : A5 0A       ;
                      CMP.B #$03                          ;; 03CA11 : C9 03       ;
                      LDA.W DATA_03C626,X                 ;; 03CA13 : BD 26 C6    ;
                      BCC CODE_03CA1B                     ;; 03CA16 : 90 03       ;
                      LDA.W DATA_03C6CE,X                 ;; 03CA18 : BD CE C6    ;
CODE_03CA1B:          SEC                                 ;; 03CA1B : 38          ;
                      SBC.B #$40                          ;; 03CA1C : E9 40       ;
                      STA.B !_0                           ;; 03CA1E : 85 00       ;
                      PHY                                 ;; 03CA20 : 5A          ;
                      LDA.B !_A                           ;; 03CA21 : A5 0A       ;
                      CMP.B #$03                          ;; 03CA23 : C9 03       ;
                      LDA.W DATA_03C67A,X                 ;; 03CA25 : BD 7A C6    ;
                      BCC CODE_03CA2D                     ;; 03CA28 : 90 03       ;
                      LDA.W DATA_03C722,X                 ;; 03CA2A : BD 22 C7    ;
CODE_03CA2D:          SEC                                 ;; 03CA2D : 38          ;
                      SBC.B #$50                          ;; 03CA2E : E9 50       ;
                      STA.B !_1                           ;; 03CA30 : 85 01       ;
                      LDA.B !_0                           ;; 03CA32 : A5 00       ;
                      BPL CODE_03CA39                     ;; 03CA34 : 10 03       ;
                      EOR.B #$FF                          ;; 03CA36 : 49 FF       ;
                      INC A                               ;; 03CA38 : 1A          ;
CODE_03CA39:          STA.W !HW_WRMPYA                    ;; 03CA39 : 8D 02 42    ; Multiplicand A
                      LDA.B !_6                           ;; 03CA3C : A5 06       ;
                      STA.W !HW_WRMPYB                    ;; 03CA3E : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03CA41 : EA          ;
                      NOP                                 ;; 03CA42 : EA          ;
                      NOP                                 ;; 03CA43 : EA          ;
                      NOP                                 ;; 03CA44 : EA          ;
                      LDA.W !HW_RDMPY+1                   ;; 03CA45 : AD 17 42    ; Product/Remainder Result (High Byte)
                      LDY.B !_0                           ;; 03CA48 : A4 00       ;
                      BPL CODE_03CA4F                     ;; 03CA4A : 10 03       ;
                      EOR.B #$FF                          ;; 03CA4C : 49 FF       ;
                      INC A                               ;; 03CA4E : 1A          ;
CODE_03CA4F:          STA.B !_2                           ;; 03CA4F : 85 02       ;
                      LDA.B !_1                           ;; 03CA51 : A5 01       ;
                      BPL CODE_03CA58                     ;; 03CA53 : 10 03       ;
                      EOR.B #$FF                          ;; 03CA55 : 49 FF       ;
                      INC A                               ;; 03CA57 : 1A          ;
CODE_03CA58:          STA.W !HW_WRMPYA                    ;; 03CA58 : 8D 02 42    ; Multiplicand A
                      LDA.B !_6                           ;; 03CA5B : A5 06       ;
                      STA.W !HW_WRMPYB                    ;; 03CA5D : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03CA60 : EA          ;
                      NOP                                 ;; 03CA61 : EA          ;
                      NOP                                 ;; 03CA62 : EA          ;
                      NOP                                 ;; 03CA63 : EA          ;
                      LDA.W !HW_RDMPY+1                   ;; 03CA64 : AD 17 42    ; Product/Remainder Result (High Byte)
                      LDY.B !_1                           ;; 03CA67 : A4 01       ;
                      BPL CODE_03CA6E                     ;; 03CA69 : 10 03       ;
                      EOR.B #$FF                          ;; 03CA6B : 49 FF       ;
                      INC A                               ;; 03CA6D : 1A          ;
CODE_03CA6E:          STA.B !_3                           ;; 03CA6E : 85 03       ;
                      LDY.B #$00                          ;; 03CA70 : A0 00       ;
                      LDA.B !_7                           ;; 03CA72 : A5 07       ;
                      CMP.B #$06                          ;; 03CA74 : C9 06       ;
                      BCC CODE_03CA82                     ;; 03CA76 : 90 0A       ;
                      LDA.B !_5                           ;; 03CA78 : A5 05       ;
                      CLC                                 ;; 03CA7A : 18          ;
                      ADC.B !_4                           ;; 03CA7B : 65 04       ;
                      LSR A                               ;; 03CA7D : 4A          ;
                      LSR A                               ;; 03CA7E : 4A          ;
                      AND.B #$07                          ;; 03CA7F : 29 07       ;
                      TAY                                 ;; 03CA81 : A8          ;
CODE_03CA82:          LDA.W DATA_03C9E1,Y                 ;; 03CA82 : B9 E1 C9    ;
                      PLY                                 ;; 03CA85 : 7A          ;
                      CLC                                 ;; 03CA86 : 18          ;
                      ADC.B !_2                           ;; 03CA87 : 65 02       ;
                      CLC                                 ;; 03CA89 : 18          ;
                      ADC.B !_8                           ;; 03CA8A : 65 08       ;
                      STA.W !OAMTileXPos,Y                ;; 03CA8C : 99 00 02    ;
                      LDA.B !_3                           ;; 03CA8F : A5 03       ;
                      CLC                                 ;; 03CA91 : 18          ;
                      ADC.B !_9                           ;; 03CA92 : 65 09       ;
                      STA.W !OAMTileYPos,Y                ;; 03CA94 : 99 01 02    ;
                      PHX                                 ;; 03CA97 : DA          ;
                      LDA.B !_5                           ;; 03CA98 : A5 05       ;
                      AND.B #$03                          ;; 03CA9A : 29 03       ;
                      STA.B !_F                           ;; 03CA9C : 85 0F       ;
                      ASL A                               ;; 03CA9E : 0A          ;
                      ASL A                               ;; 03CA9F : 0A          ;
                      ASL A                               ;; 03CAA0 : 0A          ;
                      ADC.B !_F                           ;; 03CAA1 : 65 0F       ;
                      ADC.B !_F                           ;; 03CAA3 : 65 0F       ;
                      ADC.B !_7                           ;; 03CAA5 : 65 07       ;
                      TAX                                 ;; 03CAA7 : AA          ;
                      LDA.W DATA_03C9B9,X                 ;; 03CAA8 : BD B9 C9    ;
                      STA.W !OAMTileNo,Y                  ;; 03CAAB : 99 02 02    ;
                      PLX                                 ;; 03CAAE : FA          ;
                      LDA.B !_5                           ;; 03CAAF : A5 05       ;
                      LSR A                               ;; 03CAB1 : 4A          ;
                      NOP                                 ;; 03CAB2 : EA          ;
                      NOP                                 ;; 03CAB3 : EA          ;
                      PHX                                 ;; 03CAB4 : DA          ;
                      LDX.B !_A                           ;; 03CAB5 : A6 0A       ;
                      CPX.B #$03                          ;; 03CAB7 : E0 03       ;
                      BEQ CODE_03CABD                     ;; 03CAB9 : F0 02       ;
                      EOR.B !_4                           ;; 03CABB : 45 04       ;
CODE_03CABD:          AND.B #$0E                          ;; 03CABD : 29 0E       ;
                      ORA.B #$31                          ;; 03CABF : 09 31       ;
                      STA.W !OAMTileAttr,Y                ;; 03CAC1 : 99 03 02    ;
                      PLX                                 ;; 03CAC4 : FA          ;
                      PHY                                 ;; 03CAC5 : 5A          ;
                      TYA                                 ;; 03CAC6 : 98          ;
                      LSR A                               ;; 03CAC7 : 4A          ;
                      LSR A                               ;; 03CAC8 : 4A          ;
                      TAY                                 ;; 03CAC9 : A8          ;
                      LDA.B #$00                          ;; 03CACA : A9 00       ;
                      STA.W !OAMTileSize,Y                ;; 03CACC : 99 20 04    ;
                      PLY                                 ;; 03CACF : 7A          ;
                      INY                                 ;; 03CAD0 : C8          ;
                      INY                                 ;; 03CAD1 : C8          ;
                      INY                                 ;; 03CAD2 : C8          ;
                      INY                                 ;; 03CAD3 : C8          ;
                      DEX                                 ;; 03CAD4 : CA          ;
                      BMI CODE_03CADA                     ;; 03CAD5 : 30 03       ;
                      JMP CODE_03CA0D                     ;; 03CAD7 : 4C 0D CA    ;
                                                          ;;                      ;
CODE_03CADA:          LDX.B #$53                          ;; 03CADA : A2 53       ;
CODE_03CADC:          STX.B !_4                           ;; 03CADC : 86 04       ;
                      LDA.B !_A                           ;; 03CADE : A5 0A       ;
                      CMP.B #$03                          ;; 03CAE0 : C9 03       ;
                      LDA.W DATA_03C626,X                 ;; 03CAE2 : BD 26 C6    ;
                      BCC CODE_03CAEA                     ;; 03CAE5 : 90 03       ;
                      LDA.W DATA_03C6CE,X                 ;; 03CAE7 : BD CE C6    ;
CODE_03CAEA:          SEC                                 ;; 03CAEA : 38          ;
                      SBC.B #$40                          ;; 03CAEB : E9 40       ;
                      STA.B !_0                           ;; 03CAED : 85 00       ;
                      LDA.B !_A                           ;; 03CAEF : A5 0A       ;
                      CMP.B #$03                          ;; 03CAF1 : C9 03       ;
                      LDA.W DATA_03C67A,X                 ;; 03CAF3 : BD 7A C6    ;
                      BCC CODE_03CAFB                     ;; 03CAF6 : 90 03       ;
                      LDA.W DATA_03C722,X                 ;; 03CAF8 : BD 22 C7    ;
CODE_03CAFB:          SEC                                 ;; 03CAFB : 38          ;
                      SBC.B #$50                          ;; 03CAFC : E9 50       ;
                      STA.B !_1                           ;; 03CAFE : 85 01       ;
                      PHY                                 ;; 03CB00 : 5A          ;
                      LDA.B !_0                           ;; 03CB01 : A5 00       ;
                      BPL CODE_03CB08                     ;; 03CB03 : 10 03       ;
                      EOR.B #$FF                          ;; 03CB05 : 49 FF       ;
                      INC A                               ;; 03CB07 : 1A          ;
CODE_03CB08:          STA.W !HW_WRMPYA                    ;; 03CB08 : 8D 02 42    ; Multiplicand A
                      LDA.B !_6                           ;; 03CB0B : A5 06       ;
                      STA.W !HW_WRMPYB                    ;; 03CB0D : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03CB10 : EA          ;
                      NOP                                 ;; 03CB11 : EA          ;
                      NOP                                 ;; 03CB12 : EA          ;
                      NOP                                 ;; 03CB13 : EA          ;
                      LDA.W !HW_RDMPY+1                   ;; 03CB14 : AD 17 42    ; Product/Remainder Result (High Byte)
                      LDY.B !_0                           ;; 03CB17 : A4 00       ;
                      BPL CODE_03CB1E                     ;; 03CB19 : 10 03       ;
                      EOR.B #$FF                          ;; 03CB1B : 49 FF       ;
                      INC A                               ;; 03CB1D : 1A          ;
CODE_03CB1E:          STA.B !_2                           ;; 03CB1E : 85 02       ;
                      LDA.B !_1                           ;; 03CB20 : A5 01       ;
                      BPL CODE_03CB27                     ;; 03CB22 : 10 03       ;
                      EOR.B #$FF                          ;; 03CB24 : 49 FF       ;
                      INC A                               ;; 03CB26 : 1A          ;
CODE_03CB27:          STA.W !HW_WRMPYA                    ;; 03CB27 : 8D 02 42    ; Multiplicand A
                      LDA.B !_6                           ;; 03CB2A : A5 06       ;
                      STA.W !HW_WRMPYB                    ;; 03CB2C : 8D 03 42    ; Multplier B
                      NOP                                 ;; 03CB2F : EA          ;
                      NOP                                 ;; 03CB30 : EA          ;
                      NOP                                 ;; 03CB31 : EA          ;
                      NOP                                 ;; 03CB32 : EA          ;
                      LDA.W !HW_RDMPY+1                   ;; 03CB33 : AD 17 42    ; Product/Remainder Result (High Byte)
                      LDY.B !_1                           ;; 03CB36 : A4 01       ;
                      BPL CODE_03CB3D                     ;; 03CB38 : 10 03       ;
                      EOR.B #$FF                          ;; 03CB3A : 49 FF       ;
                      INC A                               ;; 03CB3C : 1A          ;
CODE_03CB3D:          STA.B !_3                           ;; 03CB3D : 85 03       ;
                      LDY.B #$00                          ;; 03CB3F : A0 00       ;
                      LDA.B !_7                           ;; 03CB41 : A5 07       ;
                      CMP.B #$06                          ;; 03CB43 : C9 06       ;
                      BCC CODE_03CB51                     ;; 03CB45 : 90 0A       ;
                      LDA.B !_5                           ;; 03CB47 : A5 05       ;
                      CLC                                 ;; 03CB49 : 18          ;
                      ADC.B !_4                           ;; 03CB4A : 65 04       ;
                      LSR A                               ;; 03CB4C : 4A          ;
                      LSR A                               ;; 03CB4D : 4A          ;
                      AND.B #$07                          ;; 03CB4E : 29 07       ;
                      TAY                                 ;; 03CB50 : A8          ;
CODE_03CB51:          LDA.W DATA_03C9E1,Y                 ;; 03CB51 : B9 E1 C9    ;
                      PLY                                 ;; 03CB54 : 7A          ;
                      CLC                                 ;; 03CB55 : 18          ;
                      ADC.B !_2                           ;; 03CB56 : 65 02       ;
                      CLC                                 ;; 03CB58 : 18          ;
                      ADC.B !_8                           ;; 03CB59 : 65 08       ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03CB5B : 99 00 03    ;
                      LDA.B !_3                           ;; 03CB5E : A5 03       ;
                      CLC                                 ;; 03CB60 : 18          ;
                      ADC.B !_9                           ;; 03CB61 : 65 09       ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03CB63 : 99 01 03    ;
                      PHX                                 ;; 03CB66 : DA          ;
                      LDA.B !_5                           ;; 03CB67 : A5 05       ;
                      AND.B #$03                          ;; 03CB69 : 29 03       ;
                      STA.B !_F                           ;; 03CB6B : 85 0F       ;
                      ASL A                               ;; 03CB6D : 0A          ;
                      ASL A                               ;; 03CB6E : 0A          ;
                      ASL A                               ;; 03CB6F : 0A          ;
                      ADC.B !_F                           ;; 03CB70 : 65 0F       ;
                      ADC.B !_F                           ;; 03CB72 : 65 0F       ;
                      ADC.B !_7                           ;; 03CB74 : 65 07       ;
                      TAX                                 ;; 03CB76 : AA          ;
                      LDA.W DATA_03C9B9,X                 ;; 03CB77 : BD B9 C9    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03CB7A : 99 02 03    ;
                      PLX                                 ;; 03CB7D : FA          ;
                      LDA.B !_5                           ;; 03CB7E : A5 05       ;
                      LSR A                               ;; 03CB80 : 4A          ;
                      NOP                                 ;; 03CB81 : EA          ;
                      NOP                                 ;; 03CB82 : EA          ;
                      PHX                                 ;; 03CB83 : DA          ;
                      LDX.B !_A                           ;; 03CB84 : A6 0A       ;
                      CPX.B #$03                          ;; 03CB86 : E0 03       ;
                      BEQ CODE_03CB8C                     ;; 03CB88 : F0 02       ;
                      EOR.B !_4                           ;; 03CB8A : 45 04       ;
CODE_03CB8C:          AND.B #$0E                          ;; 03CB8C : 29 0E       ;
                      ORA.B #$31                          ;; 03CB8E : 09 31       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03CB90 : 99 03 03    ;
                      PLX                                 ;; 03CB93 : FA          ;
                      PHY                                 ;; 03CB94 : 5A          ;
                      TYA                                 ;; 03CB95 : 98          ;
                      LSR A                               ;; 03CB96 : 4A          ;
                      LSR A                               ;; 03CB97 : 4A          ;
                      TAY                                 ;; 03CB98 : A8          ;
                      LDA.B #$00                          ;; 03CB99 : A9 00       ;
                      STA.W !OAMTileSize+$40,Y            ;; 03CB9B : 99 60 04    ;
                      PLY                                 ;; 03CB9E : 7A          ;
                      INY                                 ;; 03CB9F : C8          ;
                      INY                                 ;; 03CBA0 : C8          ;
                      INY                                 ;; 03CBA1 : C8          ;
                      INY                                 ;; 03CBA2 : C8          ;
                      DEX                                 ;; 03CBA3 : CA          ;
                      CPX.B #$3F                          ;; 03CBA4 : E0 3F       ;
                      BEQ CODE_03CBAB                     ;; 03CBA6 : F0 03       ;
                      JMP CODE_03CADC                     ;; 03CBA8 : 4C DC CA    ;
                                                          ;;                      ;
CODE_03CBAB:          PLX                                 ;; 03CBAB : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
ChuckSprGenDispX:     db $14,$EC                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ChuckSprGenSpeedHi:   db $00,$FF                          ;; ?QPWZ?               ;
                                                          ;;                      ;
ChuckSprGenSpeedLo:   db $18,$E8                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CBB3:          JSL FindFreeSprSlot                 ;; 03CBB3 : 22 E4 A9 02 ; \ Return if no free slots 
                      BMI Return03CC08                    ;; 03CBB7 : 30 4F       ; / 
                      LDA.B #$1B                          ;; 03CBB9 : A9 1B       ; \ Sprite = Football 
                      STA.W !SpriteNumber,Y               ;; 03CBBB : 99 9E 00    ; / 
                      PHX                                 ;; 03CBBE : DA          ;
                      TYX                                 ;; 03CBBF : BB          ;
                      JSL InitSpriteTables                ;; 03CBC0 : 22 D2 F7 07 ;
                      PLX                                 ;; 03CBC4 : FA          ;
                      LDA.B #$08                          ;; 03CBC5 : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03CBC7 : 99 C8 14    ; / 
                      LDA.B !SpriteYPosLow,X              ;; 03CBCA : B5 D8       ;
                      STA.W !SpriteYPosLow,Y              ;; 03CBCC : 99 D8 00    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03CBCF : BD D4 14    ;
                      STA.W !SpriteXPosHigh,Y             ;; 03CBD2 : 99 D4 14    ;
                      LDA.B !SpriteXPosLow,X              ;; 03CBD5 : B5 E4       ;
                      STA.B !_1                           ;; 03CBD7 : 85 01       ;
                      LDA.W !SpriteYPosHigh,X             ;; 03CBD9 : BD E0 14    ;
                      STA.B !_0                           ;; 03CBDC : 85 00       ;
                      PHX                                 ;; 03CBDE : DA          ;
                      LDA.W !SpriteMisc157C,X             ;; 03CBDF : BD 7C 15    ;
                      TAX                                 ;; 03CBE2 : AA          ;
                      LDA.B !_1                           ;; 03CBE3 : A5 01       ;
                      CLC                                 ;; 03CBE5 : 18          ;
                      ADC.L ChuckSprGenDispX,X            ;; 03CBE6 : 7F AD CB 03 ;
                      STA.W !SpriteXPosLow,Y              ;; 03CBEA : 99 E4 00    ;
                      LDA.B !_0                           ;; 03CBED : A5 00       ;
                      ADC.L ChuckSprGenSpeedHi,X          ;; 03CBEF : 7F AF CB 03 ;
                      STA.W !SpriteYPosHigh,Y             ;; 03CBF3 : 99 E0 14    ;
                      LDA.L ChuckSprGenSpeedLo,X          ;; 03CBF6 : BF B1 CB 03 ;
                      STA.W !SpriteXSpeed,Y               ;; 03CBFA : 99 B6 00    ;
                      LDA.B #$E0                          ;; 03CBFD : A9 E0       ;
                      STA.W !SpriteYSpeed,Y               ;; 03CBFF : 99 AA 00    ;
                      LDA.B #$10                          ;; 03CC02 : A9 10       ;
                      STA.W !SpriteMisc1540,Y             ;; 03CC04 : 99 40 15    ;
                      PLX                                 ;; 03CC07 : FA          ;
Return03CC08:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03CC09:          PHB                                 ;; 03CC09 : 8B          ; Wrapper 
                      PHK                                 ;; 03CC0A : 4B          ;
                      PLB                                 ;; 03CC0B : AB          ;
                      STZ.W !SpriteTweakerB,X             ;; 03CC0C : 9E 62 16    ;
                      JSR CODE_03CC14                     ;; 03CC0F : 20 14 CC    ;
                      PLB                                 ;; 03CC12 : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03CC14:          JSR CODE_03D484                     ;; 03CC14 : 20 84 D4    ;
                      LDA.W !SpriteStatus,X               ;; 03CC17 : BD C8 14    ;
                      CMP.B #$08                          ;; 03CC1A : C9 08       ;
                      BNE Return03CC37                    ;; 03CC1C : D0 19       ;
                      LDA.B !SpriteLock                   ;; 03CC1E : A5 9D       ;
                      BNE Return03CC37                    ;; 03CC20 : D0 15       ;
                      LDA.W !SpriteMisc151C,X             ;; 03CC22 : BD 1C 15    ;
                      JSL ExecutePtr                      ;; 03CC25 : 22 DF 86 00 ;
                                                          ;;                      ;
                      dw CODE_03CC8A                      ;; ?QPWZ? : 8A CC       ;
                      dw CODE_03CD21                      ;; ?QPWZ? : 21 CD       ;
                      dw CODE_03CDC7                      ;; ?QPWZ? : C7 CD       ;
                      dw CODE_03CDEF                      ;; ?QPWZ? : EF CD       ;
                      dw CODE_03CE0E                      ;; ?QPWZ? : 0E CE       ;
                      dw CODE_03CE5A                      ;; ?QPWZ? : 5A CE       ;
                      dw CODE_03CE89                      ;; ?QPWZ? : 89 CE       ;
                                                          ;;                      ;
Return03CC37:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CC38:          db $18,$38,$58,$78,$98,$B8,$D8,$78  ;; 03CC38               ;
DATA_03CC40:          db $40,$50,$50,$40,$30,$40,$50,$40  ;; 03CC40               ;
DATA_03CC48:          db $50,$4A,$50,$4A,$4A,$40,$4A,$48  ;; 03CC48               ;
                      db $4A                              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CC51:          db $02,$04,$06,$08,$0B,$0C,$0E,$10  ;; 03CC51               ;
                      db $13                              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CC5A:          db $00,$01,$02,$03,$04,$05,$06,$00  ;; 03CC5A               ;
                      db $01,$02,$03,$04,$05,$06,$00,$01  ;; ?QPWZ?               ;
                      db $02,$03,$04,$05,$06,$00,$01,$02  ;; ?QPWZ?               ;
                      db $03,$04,$05,$06,$00,$01,$02,$03  ;; ?QPWZ?               ;
                      db $04,$05,$06,$00,$01,$02,$03,$04  ;; ?QPWZ?               ;
                      db $05,$06,$00,$01,$02,$03,$04,$05  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CC8A:          LDA.W !SpriteMisc1540,X             ;; 03CC8A : BD 40 15    ;
                      BNE Return03CCDF                    ;; 03CC8D : D0 50       ;
                      LDA.W !SpriteMisc1570,X             ;; 03CC8F : BD 70 15    ;
                      BNE CODE_03CC9D                     ;; 03CC92 : D0 09       ;
                      JSL GetRand                         ;; 03CC94 : 22 F9 AC 01 ;
                      AND.B #$0F                          ;; 03CC98 : 29 0F       ;
                      STA.W !SpriteMisc160E,X             ;; 03CC9A : 9D 0E 16    ;
CODE_03CC9D:          LDA.W !SpriteMisc160E,X             ;; 03CC9D : BD 0E 16    ;
                      ORA.W !SpriteMisc1570,X             ;; 03CCA0 : 1D 70 15    ;
                      TAY                                 ;; 03CCA3 : A8          ;
                      LDA.W DATA_03CC5A,Y                 ;; 03CCA4 : B9 5A CC    ;
                      TAY                                 ;; 03CCA7 : A8          ;
                      LDA.W DATA_03CC38,Y                 ;; 03CCA8 : B9 38 CC    ;
                      STA.B !SpriteXPosLow,X              ;; 03CCAB : 95 E4       ;
                      LDA.B !SpriteTableC2,X              ;; 03CCAD : B5 C2       ;
                      CMP.B #$06                          ;; 03CCAF : C9 06       ;
                      LDA.W DATA_03CC40,Y                 ;; 03CCB1 : B9 40 CC    ;
                      BCC CODE_03CCB8                     ;; 03CCB4 : 90 02       ;
                      LDA.B #$50                          ;; 03CCB6 : A9 50       ;
CODE_03CCB8:          STA.B !SpriteYPosLow,X              ;; 03CCB8 : 95 D8       ;
                      LDA.B #$08                          ;; 03CCBA : A9 08       ;
                      LDY.W !SpriteMisc1570,X             ;; 03CCBC : BC 70 15    ;
                      BNE CODE_03CCCC                     ;; 03CCBF : D0 0B       ;
                      JSR CODE_03CCE2                     ;; 03CCC1 : 20 E2 CC    ;
                      JSL GetRand                         ;; 03CCC4 : 22 F9 AC 01 ;
                      LSR A                               ;; 03CCC8 : 4A          ;
                      LSR A                               ;; 03CCC9 : 4A          ;
                      AND.B #$07                          ;; 03CCCA : 29 07       ;
CODE_03CCCC:          STA.W !SpriteMisc1528,X             ;; 03CCCC : 9D 28 15    ;
                      TAY                                 ;; 03CCCF : A8          ;
                      LDA.W DATA_03CC48,Y                 ;; 03CCD0 : B9 48 CC    ;
                      STA.W !SpriteMisc1540,X             ;; 03CCD3 : 9D 40 15    ;
                      INC.W !SpriteMisc151C,X             ;; 03CCD6 : FE 1C 15    ;
                      LDA.W DATA_03CC51,Y                 ;; 03CCD9 : B9 51 CC    ;
                      STA.W !SpriteMisc1602,X             ;; 03CCDC : 9D 02 16    ;
Return03CCDF:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CCE0:          db $10,$20                          ;; 03CCE0               ;
                                                          ;;                      ;
CODE_03CCE2:          LDY.B #$01                          ;; 03CCE2 : A0 01       ;
                      JSR CODE_03CCE8                     ;; 03CCE4 : 20 E8 CC    ;
                      DEY                                 ;; 03CCE7 : 88          ;
CODE_03CCE8:          LDA.B #$08                          ;; 03CCE8 : A9 08       ; \ Sprite status = Normal 
                      STA.W !SpriteStatus,Y               ;; 03CCEA : 99 C8 14    ; / 
                      LDA.B #$29                          ;; 03CCED : A9 29       ;
                      STA.W !SpriteNumber,Y               ;; 03CCEF : 99 9E 00    ;
                      PHX                                 ;; 03CCF2 : DA          ;
                      TYX                                 ;; 03CCF3 : BB          ;
                      JSL InitSpriteTables                ;; 03CCF4 : 22 D2 F7 07 ;
                      PLX                                 ;; 03CCF8 : FA          ;
                      LDA.W DATA_03CCE0,Y                 ;; 03CCF9 : B9 E0 CC    ;
                      STA.W !SpriteMisc1570,Y             ;; 03CCFC : 99 70 15    ;
                      LDA.B !SpriteTableC2,X              ;; 03CCFF : B5 C2       ;
                      STA.W !SpriteTableC2,Y              ;; 03CD01 : 99 C2 00    ;
                      LDA.W !SpriteMisc160E,X             ;; 03CD04 : BD 0E 16    ;
                      STA.W !SpriteMisc160E,Y             ;; 03CD07 : 99 0E 16    ;
                      LDA.B !SpriteXPosLow,X              ;; 03CD0A : B5 E4       ;
                      STA.W !SpriteXPosLow,Y              ;; 03CD0C : 99 E4 00    ;
                      LDA.W !SpriteYPosHigh,X             ;; 03CD0F : BD E0 14    ;
                      STA.W !SpriteYPosHigh,Y             ;; 03CD12 : 99 E0 14    ;
                      LDA.B !SpriteYPosLow,X              ;; 03CD15 : B5 D8       ;
                      STA.W !SpriteYPosLow,Y              ;; 03CD17 : 99 D8 00    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03CD1A : BD D4 14    ;
                      STA.W !SpriteXPosHigh,Y             ;; 03CD1D : 99 D4 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CD21:          LDA.W !SpriteMisc1540,X             ;; 03CD21 : BD 40 15    ;
                      BNE CODE_03CD2E                     ;; 03CD24 : D0 08       ;
                      LDA.B #$40                          ;; 03CD26 : A9 40       ;
                      STA.W !SpriteMisc1540,X             ;; 03CD28 : 9D 40 15    ;
                      INC.W !SpriteMisc151C,X             ;; 03CD2B : FE 1C 15    ;
CODE_03CD2E:          LDA.B #$F8                          ;; 03CD2E : A9 F8       ;
                      STA.B !SpriteYSpeed,X               ;; 03CD30 : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 03CD32 : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CD37:          db $02,$02,$02,$02,$03,$03,$03,$03  ;; 03CD37               ;
                      db $03,$03,$03,$03,$02,$02,$02,$02  ;; ?QPWZ?               ;
                      db $04,$04,$04,$04,$05,$05,$04,$05  ;; ?QPWZ?               ;
                      db $05,$04,$05,$05,$04,$04,$04,$04  ;; ?QPWZ?               ;
                      db $06,$06,$06,$06,$07,$07,$07,$07  ;; ?QPWZ?               ;
                      db $07,$07,$07,$07,$06,$06,$06,$06  ;; ?QPWZ?               ;
                      db $08,$08,$08,$08,$08,$09,$09,$08  ;; ?QPWZ?               ;
                      db $08,$09,$09,$08,$08,$08,$08,$08  ;; ?QPWZ?               ;
                      db $0B,$0B,$0B,$0B,$0B,$0A,$0B,$0A  ;; ?QPWZ?               ;
                      db $0B,$0A,$0B,$0A,$0B,$0B,$0B,$0B  ;; ?QPWZ?               ;
                      db $0C,$0C,$0C,$0C,$0D,$0C,$0D,$0C  ;; ?QPWZ?               ;
                      db $0D,$0C,$0D,$0C,$0D,$0D,$0D,$0D  ;; ?QPWZ?               ;
                      db $0E,$0E,$0E,$0E,$0E,$0F,$0E,$0F  ;; ?QPWZ?               ;
                      db $0E,$0F,$0E,$0F,$0E,$0E,$0E,$0E  ;; ?QPWZ?               ;
                      db $10,$10,$10,$10,$11,$12,$11,$10  ;; ?QPWZ?               ;
                      db $11,$12,$11,$10,$11,$11,$11,$11  ;; ?QPWZ?               ;
                      db $13,$13,$13,$13,$13,$13,$13,$13  ;; ?QPWZ?               ;
                      db $13,$13,$13,$13,$13,$13,$13,$13  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03CDC7:          JSR CODE_03CEA7                     ;; 03CDC7 : 20 A7 CE    ;
                      LDA.W !SpriteMisc1540,X             ;; 03CDCA : BD 40 15    ;
                      BNE CODE_03CDDA                     ;; 03CDCD : D0 0B       ;
CODE_03CDCF:          LDA.B #$24                          ;; 03CDCF : A9 24       ;
                      STA.W !SpriteMisc1540,X             ;; 03CDD1 : 9D 40 15    ;
                      LDA.B #$03                          ;; 03CDD4 : A9 03       ;
                      STA.W !SpriteMisc151C,X             ;; 03CDD6 : 9D 1C 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDDA:          LSR A                               ;; 03CDDA : 4A          ;
                      LSR A                               ;; 03CDDB : 4A          ;
                      STA.B !_0                           ;; 03CDDC : 85 00       ;
                      LDA.W !SpriteMisc1528,X             ;; 03CDDE : BD 28 15    ;
                      ASL A                               ;; 03CDE1 : 0A          ;
                      ASL A                               ;; 03CDE2 : 0A          ;
                      ASL A                               ;; 03CDE3 : 0A          ;
                      ASL A                               ;; 03CDE4 : 0A          ;
                      ORA.B !_0                           ;; 03CDE5 : 05 00       ;
                      TAY                                 ;; 03CDE7 : A8          ;
                      LDA.W DATA_03CD37,Y                 ;; 03CDE8 : B9 37 CD    ;
                      STA.W !SpriteMisc1602,X             ;; 03CDEB : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDEF:          LDA.W !SpriteMisc1540,X             ;; 03CDEF : BD 40 15    ;
                      BNE CODE_03CE05                     ;; 03CDF2 : D0 11       ;
                      LDA.W !SpriteMisc1570,X             ;; 03CDF4 : BD 70 15    ;
                      BEQ CODE_03CDFD                     ;; 03CDF7 : F0 04       ;
                      STZ.W !SpriteStatus,X               ;; 03CDF9 : 9E C8 14    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CDFD:          STZ.W !SpriteMisc151C,X             ;; 03CDFD : 9E 1C 15    ;
                      LDA.B #$30                          ;; 03CE00 : A9 30       ;
                      STA.W !SpriteMisc1540,X             ;; 03CE02 : 9D 40 15    ;
CODE_03CE05:          LDA.B #$10                          ;; 03CE05 : A9 10       ;
                      STA.B !SpriteYSpeed,X               ;; 03CE07 : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 03CE09 : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE0E:          LDA.W !SpriteMisc1540,X             ;; 03CE0E : BD 40 15    ;
                      BNE CODE_03CE2A                     ;; 03CE11 : D0 17       ;
                      INC.W !SpriteMisc1534,X             ;; 03CE13 : FE 34 15    ;
                      LDA.W !SpriteMisc1534,X             ;; 03CE16 : BD 34 15    ;
                      CMP.B #$03                          ;; 03CE19 : C9 03       ;
                      BNE CODE_03CDCF                     ;; 03CE1B : D0 B2       ;
                      LDA.B #$05                          ;; 03CE1D : A9 05       ;
                      STA.W !SpriteMisc151C,X             ;; 03CE1F : 9D 1C 15    ;
                      STZ.B !SpriteYSpeed,X               ;; 03CE22 : 74 AA       ; Sprite Y Speed = 0 
                      LDA.B #$23                          ;; 03CE24 : A9 23       ;
                      STA.W !SPCIO0                       ;; 03CE26 : 8D F9 1D    ; / Play sound effect 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE2A:          LDY.W !SpriteMisc1570,X             ;; 03CE2A : BC 70 15    ;
                      BNE CODE_03CE42                     ;; 03CE2D : D0 13       ;
CODE_03CE2F:          CMP.B #$24                          ;; 03CE2F : C9 24       ;
                      BNE CODE_03CE38                     ;; 03CE31 : D0 05       ;
                      LDY.B #$29                          ;; 03CE33 : A0 29       ;
                      STY.W !SPCIO3                       ;; 03CE35 : 8C FC 1D    ; / Play sound effect 
CODE_03CE38:          LDA.B !EffFrame                     ;; 03CE38 : A5 14       ;
                      LSR A                               ;; 03CE3A : 4A          ;
                      LSR A                               ;; 03CE3B : 4A          ;
                      AND.B #$01                          ;; 03CE3C : 29 01       ;
                      STA.W !SpriteMisc1602,X             ;; 03CE3E : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CE42:          CMP.B #$10                          ;; 03CE42 : C9 10       ;
                      BNE CODE_03CE4B                     ;; 03CE44 : D0 05       ;
                      LDY.B #$2A                          ;; 03CE46 : A0 2A       ;
                      STY.W !SPCIO3                       ;; 03CE48 : 8C FC 1D    ; / Play sound effect 
CODE_03CE4B:          LSR A                               ;; 03CE4B : 4A          ;
                      LSR A                               ;; 03CE4C : 4A          ;
                      LSR A                               ;; 03CE4D : 4A          ;
                      TAY                                 ;; 03CE4E : A8          ;
                      LDA.W DATA_03CE56,Y                 ;; 03CE4F : B9 56 CE    ;
                      STA.W !SpriteMisc1602,X             ;; 03CE52 : 9D 02 16    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CE56:          db $16,$16,$15,$14                  ;; 03CE56               ;
                                                          ;;                      ;
CODE_03CE5A:          JSL UpdateYPosNoGvtyW               ;; 03CE5A : 22 1A 80 01 ;
                      LDA.B !SpriteYSpeed,X               ;; 03CE5E : B5 AA       ;
                      CMP.B #$40                          ;; 03CE60 : C9 40       ;
                      BPL CODE_03CE69                     ;; 03CE62 : 10 05       ;
                      CLC                                 ;; 03CE64 : 18          ;
                      ADC.B #$03                          ;; 03CE65 : 69 03       ;
                      STA.B !SpriteYSpeed,X               ;; 03CE67 : 95 AA       ;
CODE_03CE69:          LDA.W !SpriteXPosHigh,X             ;; 03CE69 : BD D4 14    ;
                      BEQ CODE_03CE87                     ;; 03CE6C : F0 19       ;
                      LDA.B !SpriteYPosLow,X              ;; 03CE6E : B5 D8       ;
                      CMP.B #$85                          ;; 03CE70 : C9 85       ;
                      BCC CODE_03CE87                     ;; 03CE72 : 90 13       ;
                      LDA.B #$06                          ;; 03CE74 : A9 06       ;
                      STA.W !SpriteMisc151C,X             ;; 03CE76 : 9D 1C 15    ;
                      LDA.B #$80                          ;; 03CE79 : A9 80       ;
                      STA.W !SpriteMisc1540,X             ;; 03CE7B : 9D 40 15    ;
                      LDA.B #$20                          ;; 03CE7E : A9 20       ;
                      STA.W !SPCIO3                       ;; 03CE80 : 8D FC 1D    ; / Play sound effect 
                      JSL CODE_028528                     ;; 03CE83 : 22 28 85 02 ;
CODE_03CE87:          BRA CODE_03CE2F                     ;; 03CE87 : 80 A6       ;
                                                          ;;                      ;
CODE_03CE89:          LDA.W !SpriteMisc1540,X             ;; 03CE89 : BD 40 15    ;
                      BNE CODE_03CE9E                     ;; 03CE8C : D0 10       ;
                      STZ.W !SpriteStatus,X               ;; 03CE8E : 9E C8 14    ;
                      INC.W !CutsceneID                   ;; 03CE91 : EE C6 13    ;
                      LDA.B #$FF                          ;; 03CE94 : A9 FF       ;
                      STA.W !EndLevelTimer                ;; 03CE96 : 8D 93 14    ;
                      LDA.B #$0B                          ;; 03CE99 : A9 0B       ;
                      STA.W !SPCIO2                       ;; 03CE9B : 8D FB 1D    ; / Change music 
CODE_03CE9E:          LDA.B #$04                          ;; 03CE9E : A9 04       ;
                      STA.B !SpriteYSpeed,X               ;; 03CEA0 : 95 AA       ;
                      JSL UpdateYPosNoGvtyW               ;; 03CEA2 : 22 1A 80 01 ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CEA7:          JSL MarioSprInteract                ;; 03CEA7 : 22 DC A7 01 ;
                      BCC Return03CEF1                    ;; 03CEAB : 90 44       ;
                      LDA.B !PlayerYSpeed                 ;; 03CEAD : A5 7D       ;
                      CMP.B #$10                          ;; 03CEAF : C9 10       ;
                      BMI CODE_03CEED                     ;; 03CEB1 : 30 3A       ;
                      JSL DisplayContactGfx               ;; 03CEB3 : 22 99 AB 01 ;
                      LDA.B #$02                          ;; 03CEB7 : A9 02       ;
                      JSL GivePoints                      ;; 03CEB9 : 22 E5 AC 02 ;
                      JSL BoostMarioSpeed                 ;; 03CEBD : 22 33 AA 01 ;
                      LDA.B #$02                          ;; 03CEC1 : A9 02       ;
                      STA.W !SPCIO0                       ;; 03CEC3 : 8D F9 1D    ; / Play sound effect 
                      LDA.W !SpriteMisc1570,X             ;; 03CEC6 : BD 70 15    ;
                      BNE CODE_03CEDB                     ;; 03CEC9 : D0 10       ;
                      LDA.B #$28                          ;; 03CECB : A9 28       ;
                      STA.W !SPCIO3                       ;; 03CECD : 8D FC 1D    ; / Play sound effect 
                      LDA.W !SpriteMisc1534,X             ;; 03CED0 : BD 34 15    ;
                      CMP.B #$02                          ;; 03CED3 : C9 02       ;
                      BNE CODE_03CEDB                     ;; 03CED5 : D0 04       ;
                      JSL KillMostSprites                 ;; 03CED7 : 22 C8 A6 03 ;
CODE_03CEDB:          LDA.B #$04                          ;; 03CEDB : A9 04       ;
                      STA.W !SpriteMisc151C,X             ;; 03CEDD : 9D 1C 15    ;
                      LDA.B #$50                          ;; 03CEE0 : A9 50       ;
                      LDY.W !SpriteMisc1570,X             ;; 03CEE2 : BC 70 15    ;
                      BEQ CODE_03CEE9                     ;; 03CEE5 : F0 02       ;
                      LDA.B #$1F                          ;; 03CEE7 : A9 1F       ;
CODE_03CEE9:          STA.W !SpriteMisc1540,X             ;; 03CEE9 : 9D 40 15    ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03CEED:          JSL HurtMario                       ;; 03CEED : 22 B7 F5 00 ;
Return03CEF1:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03CEF2:          db $F8,$08,$F8,$08,$00,$00,$F8,$08  ;; 03CEF2               ;
                      db $F8,$08,$00,$00,$F8,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$FB,$00,$FB,$03,$00,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$08,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$F8,$00,$08,$00,$00,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$06,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$02,$00,$00,$F8,$08,$00,$04  ;; ?QPWZ?               ;
                      db $00,$08,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $08,$00,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03CF7C:          db $F8,$08,$F8,$08,$00,$00,$F8,$08  ;; 03CF7C               ;
                      db $F8,$08,$00,$00,$F8,$00,$08,$00  ;; ?QPWZ?               ;
                      db $00,$00,$FB,$00,$FB,$03,$00,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$08,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$00,$08,$00  ;; ?QPWZ?               ;
                      db $00,$00,$F8,$00,$08,$00,$00,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$06,$00,$08,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$02,$00,$08,$F8,$08,$00,$04  ;; ?QPWZ?               ;
                      db $00,$08,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $08,$00,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$F8,$08,$00,$00,$08,$00  ;; ?QPWZ?               ;
                      db $F8,$08,$00,$00,$00,$00,$F8,$08  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$F8,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D006:          db $04,$04,$14,$14,$00,$00,$04,$04  ;; 03D006               ;
                      db $14,$14,$00,$00,$00,$08,$F8,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$08,$F8,$F8,$00,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$F8,$F8,$00,$05,$05  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$08,$F8,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$08,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$F8,$00,$00,$05,$05  ;; ?QPWZ?               ;
                      db $00,$F8,$00,$00,$05,$05,$00,$0F  ;; ?QPWZ?               ;
                      db $F8,$F8,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$05,$05,$00,$F8  ;; ?QPWZ?               ;
                      db $F8,$00,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $04,$04,$02,$00,$00,$00,$04,$04  ;; ?QPWZ?               ;
                      db $01,$00,$00,$00,$04,$04,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$00,$00,$00,$05,$05  ;; ?QPWZ?               ;
                      db $03,$00,$00,$00,$05,$05,$04,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D090:          db $04,$04,$14,$14,$00,$00,$04,$04  ;; 03D090               ;
                      db $14,$14,$00,$00,$00,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$08,$F8,$F8,$00,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$F8,$F8,$00,$05,$05  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$08,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$08,$08,$00,$00,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$F8,$F8,$00,$05,$05  ;; ?QPWZ?               ;
                      db $00,$F8,$F8,$00,$05,$05,$00,$0F  ;; ?QPWZ?               ;
                      db $F8,$F8,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$05,$05,$00,$F8  ;; ?QPWZ?               ;
                      db $F8,$00,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $04,$04,$02,$00,$00,$00,$04,$04  ;; ?QPWZ?               ;
                      db $01,$00,$00,$00,$04,$04,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$05,$00,$F8,$F8,$00  ;; ?QPWZ?               ;
                      db $05,$05,$00,$00,$00,$00,$05,$05  ;; ?QPWZ?               ;
                      db $03,$00,$00,$00,$05,$05,$04,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D11A:          db $20,$20,$26,$26,$08,$00,$2E,$2E  ;; 03D11A               ;
                      db $24,$24,$08,$00,$00,$28,$02,$00  ;; ?QPWZ?               ;
                      db $00,$00,$04,$28,$12,$12,$00,$00  ;; ?QPWZ?               ;
                      db $22,$22,$04,$12,$12,$00,$20,$20  ;; ?QPWZ?               ;
                      db $08,$00,$00,$00,$00,$28,$02,$00  ;; ?QPWZ?               ;
                      db $00,$00,$0A,$28,$13,$00,$00,$00  ;; ?QPWZ?               ;
                      db $20,$20,$0C,$02,$00,$00,$20,$20  ;; ?QPWZ?               ;
                      db $0C,$02,$00,$00,$22,$22,$06,$03  ;; ?QPWZ?               ;
                      db $12,$12,$20,$20,$06,$12,$12,$00  ;; ?QPWZ?               ;
                      db $2A,$2A,$00,$00,$00,$00,$2C,$2C  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$20,$20,$06,$12  ;; ?QPWZ?               ;
                      db $12,$00,$20,$20,$06,$12,$12,$00  ;; ?QPWZ?               ;
                      db $22,$22,$08,$00,$00,$00,$20,$20  ;; ?QPWZ?               ;
                      db $08,$00,$00,$00,$2E,$2E,$08,$00  ;; ?QPWZ?               ;
                      db $00,$00,$4E,$4E,$60,$43,$43,$00  ;; ?QPWZ?               ;
                      db $4E,$4E,$64,$00,$00,$00,$62,$62  ;; ?QPWZ?               ;
                      db $64,$00,$00,$00,$62,$62,$64,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D1A4:          db $20,$20,$26,$26,$48,$00,$2E,$2E  ;; 03D1A4               ;
                      db $24,$24,$48,$00,$40,$28,$42,$00  ;; ?QPWZ?               ;
                      db $00,$00,$44,$28,$52,$52,$00,$00  ;; ?QPWZ?               ;
                      db $22,$22,$44,$52,$52,$00,$20,$20  ;; ?QPWZ?               ;
                      db $48,$00,$00,$00,$40,$28,$42,$00  ;; ?QPWZ?               ;
                      db $00,$00,$4A,$28,$53,$00,$00,$00  ;; ?QPWZ?               ;
                      db $20,$20,$4C,$1E,$1F,$00,$20,$20  ;; ?QPWZ?               ;
                      db $4C,$1F,$1E,$00,$22,$22,$44,$03  ;; ?QPWZ?               ;
                      db $52,$52,$20,$20,$44,$52,$52,$00  ;; ?QPWZ?               ;
                      db $2A,$2A,$00,$00,$00,$00,$2C,$2C  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$20,$20,$46,$52  ;; ?QPWZ?               ;
                      db $52,$00,$20,$20,$46,$52,$52,$00  ;; ?QPWZ?               ;
                      db $22,$22,$48,$00,$00,$00,$20,$20  ;; ?QPWZ?               ;
                      db $48,$00,$00,$00,$2E,$2E,$48,$00  ;; ?QPWZ?               ;
                      db $00,$00,$4E,$4E,$66,$68,$68,$00  ;; ?QPWZ?               ;
                      db $4E,$4E,$6A,$00,$00,$00,$62,$62  ;; ?QPWZ?               ;
                      db $6A,$00,$00,$00,$62,$62,$6A,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
LemmyGfxProp:         db $05,$45,$05,$45,$05,$00,$05,$45  ;; ?QPWZ?               ;
                      db $05,$45,$05,$00,$05,$05,$05,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$05,$05,$45,$00,$00  ;; ?QPWZ?               ;
                      db $05,$45,$05,$05,$45,$00,$05,$45  ;; ?QPWZ?               ;
                      db $05,$00,$00,$00,$05,$05,$05,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$05,$05,$00,$00,$00  ;; ?QPWZ?               ;
                      db $05,$45,$05,$05,$00,$00,$05,$45  ;; ?QPWZ?               ;
                      db $45,$45,$00,$00,$05,$45,$05,$05  ;; ?QPWZ?               ;
                      db $05,$45,$05,$45,$45,$05,$45,$00  ;; ?QPWZ?               ;
                      db $05,$45,$00,$00,$00,$00,$05,$45  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$05,$45,$45,$05  ;; ?QPWZ?               ;
                      db $45,$00,$05,$45,$05,$05,$45,$00  ;; ?QPWZ?               ;
                      db $05,$45,$05,$00,$00,$00,$05,$45  ;; ?QPWZ?               ;
                      db $05,$00,$00,$00,$05,$45,$05,$00  ;; ?QPWZ?               ;
                      db $00,$00,$07,$47,$07,$07,$47,$00  ;; ?QPWZ?               ;
                      db $07,$47,$07,$00,$00,$00,$07,$47  ;; ?QPWZ?               ;
                      db $07,$00,$00,$00,$07,$47,$07,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
WendyGfxProp:         db $09,$49,$09,$49,$09,$00,$09,$49  ;; ?QPWZ?               ;
                      db $09,$49,$09,$00,$09,$09,$09,$00  ;; ?QPWZ?               ;
                      db $00,$00,$09,$09,$09,$49,$00,$00  ;; ?QPWZ?               ;
                      db $09,$49,$09,$09,$49,$00,$09,$49  ;; ?QPWZ?               ;
                      db $09,$00,$00,$00,$09,$09,$09,$00  ;; ?QPWZ?               ;
                      db $00,$00,$09,$09,$09,$00,$00,$00  ;; ?QPWZ?               ;
                      db $09,$49,$09,$09,$09,$00,$09,$49  ;; ?QPWZ?               ;
                      db $49,$49,$49,$00,$09,$49,$09,$09  ;; ?QPWZ?               ;
                      db $09,$49,$09,$49,$49,$09,$49,$00  ;; ?QPWZ?               ;
                      db $09,$49,$00,$00,$00,$00,$09,$49  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$09,$49,$49,$09  ;; ?QPWZ?               ;
                      db $49,$00,$09,$49,$09,$09,$49,$00  ;; ?QPWZ?               ;
                      db $09,$49,$09,$00,$00,$00,$09,$49  ;; ?QPWZ?               ;
                      db $09,$00,$00,$00,$09,$49,$09,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$45,$05,$05,$45,$00  ;; ?QPWZ?               ;
                      db $05,$45,$05,$00,$00,$00,$05,$45  ;; ?QPWZ?               ;
                      db $05,$00,$00,$00,$05,$45,$05,$00  ;; ?QPWZ?               ;
                      db $00,$00                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D342:          db $02,$02,$02,$02,$02,$04,$02,$02  ;; 03D342               ;
                      db $02,$02,$02,$04,$02,$02,$00,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$00,$00,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$00,$00,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$00,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$00,$04,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$00,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$00,$04,$04,$02,$02,$02,$00  ;; ?QPWZ?               ;
                      db $00,$00,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$04,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $04,$04,$04,$04,$02,$02,$02,$00  ;; ?QPWZ?               ;
                      db $00,$04,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$02,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$02,$04  ;; ?QPWZ?               ;
                      db $04,$04                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D3CC:          db $02,$02,$02,$02,$02,$04,$02,$02  ;; 03D3CC               ;
                      db $02,$02,$02,$04,$02,$02,$00,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$00,$00,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$00,$00,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$00,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$00,$04,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$00,$00,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$00,$00,$04,$02,$02,$02,$00  ;; ?QPWZ?               ;
                      db $00,$00,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$04,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $04,$04,$04,$04,$02,$02,$02,$00  ;; ?QPWZ?               ;
                      db $00,$04,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$02,$04  ;; ?QPWZ?               ;
                      db $04,$04,$02,$02,$02,$00,$00,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$04,$04,$02,$02  ;; ?QPWZ?               ;
                      db $02,$04,$04,$04,$02,$02,$02,$04  ;; ?QPWZ?               ;
                      db $04,$04                          ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D456:          db $04,$04,$02,$03,$04,$02,$02,$02  ;; 03D456               ;
                      db $03,$03,$05,$04,$01,$01,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$02,$02,$02      ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D46D:          db $04,$04,$02,$03,$04,$02,$02,$02  ;; 03D46D               ;
                      db $04,$04,$05,$04,$01,$01,$04,$04  ;; ?QPWZ?               ;
                      db $02,$02,$02,$04,$02,$02,$02      ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D484:          JSR GetDrawInfoBnk3                 ;; 03D484 : 20 60 B7    ;
                      LDA.W !SpriteMisc1602,X             ;; 03D487 : BD 02 16    ;
                      ASL A                               ;; 03D48A : 0A          ;
                      ASL A                               ;; 03D48B : 0A          ;
                      ADC.W !SpriteMisc1602,X             ;; 03D48C : 7D 02 16    ;
                      ADC.W !SpriteMisc1602,X             ;; 03D48F : 7D 02 16    ;
                      STA.B !_2                           ;; 03D492 : 85 02       ;
                      LDA.B !SpriteTableC2,X              ;; 03D494 : B5 C2       ;
                      CMP.B #$06                          ;; 03D496 : C9 06       ;
                      BEQ CODE_03D4DF                     ;; 03D498 : F0 45       ;
                      PHX                                 ;; 03D49A : DA          ;
                      LDA.W !SpriteMisc1602,X             ;; 03D49B : BD 02 16    ;
                      TAX                                 ;; 03D49E : AA          ;
                      LDA.W DATA_03D456,X                 ;; 03D49F : BD 56 D4    ;
                      TAX                                 ;; 03D4A2 : AA          ;
CODE_03D4A3:          PHX                                 ;; 03D4A3 : DA          ;
                      TXA                                 ;; 03D4A4 : 8A          ;
                      CLC                                 ;; 03D4A5 : 18          ;
                      ADC.B !_2                           ;; 03D4A6 : 65 02       ;
                      TAX                                 ;; 03D4A8 : AA          ;
                      LDA.B !_0                           ;; 03D4A9 : A5 00       ;
                      CLC                                 ;; 03D4AB : 18          ;
                      ADC.W DATA_03CEF2,X                 ;; 03D4AC : 7D F2 CE    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03D4AF : 99 00 03    ;
                      LDA.B !_1                           ;; 03D4B2 : A5 01       ;
                      CLC                                 ;; 03D4B4 : 18          ;
                      ADC.W DATA_03D006,X                 ;; 03D4B5 : 7D 06 D0    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03D4B8 : 99 01 03    ;
                      LDA.W DATA_03D11A,X                 ;; 03D4BB : BD 1A D1    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03D4BE : 99 02 03    ;
                      LDA.W LemmyGfxProp,X                ;; 03D4C1 : BD 2E D2    ;
                      ORA.B #$10                          ;; 03D4C4 : 09 10       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03D4C6 : 99 03 03    ;
                      PHY                                 ;; 03D4C9 : 5A          ;
                      TYA                                 ;; 03D4CA : 98          ;
                      LSR A                               ;; 03D4CB : 4A          ;
                      LSR A                               ;; 03D4CC : 4A          ;
                      TAY                                 ;; 03D4CD : A8          ;
                      LDA.W DATA_03D342,X                 ;; 03D4CE : BD 42 D3    ;
                      STA.W !OAMTileSize+$40,Y            ;; 03D4D1 : 99 60 04    ;
                      PLY                                 ;; 03D4D4 : 7A          ;
                      INY                                 ;; 03D4D5 : C8          ;
                      INY                                 ;; 03D4D6 : C8          ;
                      INY                                 ;; 03D4D7 : C8          ;
                      INY                                 ;; 03D4D8 : C8          ;
                      PLX                                 ;; 03D4D9 : FA          ;
                      DEX                                 ;; 03D4DA : CA          ;
                      BPL CODE_03D4A3                     ;; 03D4DB : 10 C6       ;
CODE_03D4DD:          PLX                                 ;; 03D4DD : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D4DF:          PHX                                 ;; 03D4DF : DA          ;
                      LDA.W !SpriteMisc1602,X             ;; 03D4E0 : BD 02 16    ;
                      TAX                                 ;; 03D4E3 : AA          ;
                      LDA.W DATA_03D46D,X                 ;; 03D4E4 : BD 6D D4    ;
                      TAX                                 ;; 03D4E7 : AA          ;
CODE_03D4E8:          PHX                                 ;; 03D4E8 : DA          ;
                      TXA                                 ;; 03D4E9 : 8A          ;
                      CLC                                 ;; 03D4EA : 18          ;
                      ADC.B !_2                           ;; 03D4EB : 65 02       ;
                      TAX                                 ;; 03D4ED : AA          ;
                      LDA.B !_0                           ;; 03D4EE : A5 00       ;
                      CLC                                 ;; 03D4F0 : 18          ;
                      ADC.W DATA_03CF7C,X                 ;; 03D4F1 : 7D 7C CF    ;
                      STA.W !OAMTileXPos+$100,Y           ;; 03D4F4 : 99 00 03    ;
                      LDA.B !_1                           ;; 03D4F7 : A5 01       ;
                      CLC                                 ;; 03D4F9 : 18          ;
                      ADC.W DATA_03D090,X                 ;; 03D4FA : 7D 90 D0    ;
                      STA.W !OAMTileYPos+$100,Y           ;; 03D4FD : 99 01 03    ;
                      LDA.W DATA_03D1A4,X                 ;; 03D500 : BD A4 D1    ;
                      STA.W !OAMTileNo+$100,Y             ;; 03D503 : 99 02 03    ;
                      LDA.W WendyGfxProp,X                ;; 03D506 : BD B8 D2    ;
                      ORA.B #$10                          ;; 03D509 : 09 10       ;
                      STA.W !OAMTileAttr+$100,Y           ;; 03D50B : 99 03 03    ;
                      PHY                                 ;; 03D50E : 5A          ;
                      TYA                                 ;; 03D50F : 98          ;
                      LSR A                               ;; 03D510 : 4A          ;
                      LSR A                               ;; 03D511 : 4A          ;
                      TAY                                 ;; 03D512 : A8          ;
                      LDA.W DATA_03D3CC,X                 ;; 03D513 : BD CC D3    ;
                      STA.W !OAMTileSize+$40,Y            ;; 03D516 : 99 60 04    ;
                      PLY                                 ;; 03D519 : 7A          ;
                      INY                                 ;; 03D51A : C8          ;
                      INY                                 ;; 03D51B : C8          ;
                      INY                                 ;; 03D51C : C8          ;
                      INY                                 ;; 03D51D : C8          ;
                      PLX                                 ;; 03D51E : FA          ;
                      DEX                                 ;; 03D51F : CA          ;
                      BPL CODE_03D4E8                     ;; 03D520 : 10 C6       ;
                      BRA CODE_03D4DD                     ;; 03D522 : 80 B9       ;
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03D524:          db $18,$20                          ;; 03D524               ;
                                                          ;;                      ;
DATA_03D526:          db $A1,$0E,$20,$20,$88,$0E,$28,$20  ;; 03D526               ;
                      db $AB,$0E,$30,$20,$99,$0E,$38,$20  ;; ?QPWZ?               ;
                      db $A8,$0E,$40,$20,$BF,$0E,$48,$20  ;; ?QPWZ?               ;
                      db $AC,$0E,$58,$20,$88,$0E,$60,$20  ;; ?QPWZ?               ;
                      db $8B,$0E,$68,$20,$AF,$0E,$70,$20  ;; ?QPWZ?               ;
                      db $8C,$0E,$78,$20,$9E,$0E,$80,$20  ;; ?QPWZ?               ;
                      db $AD,$0E,$88,$20,$AE,$0E,$90,$20  ;; ?QPWZ?               ;
                      db $AB,$0E,$98,$20,$8C,$0E,$A8,$20  ;; ?QPWZ?               ;
                      db $99,$0E,$B0,$20,$AC,$0E,$C0,$20  ;; ?QPWZ?               ;
                      db $A8,$0E,$C8,$20,$AF,$0E,$D0,$20  ;; ?QPWZ?               ;
                      db $8C,$0E,$D8,$20,$AB,$0E,$E0,$20  ;; ?QPWZ?               ;
                      db $BD,$0E,$18,$30,$A1,$0E,$20,$30  ;; ?QPWZ?               ;
                      db $88,$0E,$28,$30,$AB,$0E,$30,$30  ;; ?QPWZ?               ;
                      db $99,$0E,$38,$30,$A8,$0E,$40,$30  ;; ?QPWZ?               ;
                      db $BE,$0E,$48,$30,$AD,$0E,$50,$30  ;; ?QPWZ?               ;
                      db $98,$0E,$58,$30,$8C,$0E,$68,$30  ;; ?QPWZ?               ;
                      db $A0,$0E,$70,$30,$AB,$0E,$78,$30  ;; ?QPWZ?               ;
                      db $99,$0E,$80,$30,$9E,$0E,$88,$30  ;; ?QPWZ?               ;
                      db $8A,$0E,$90,$30,$8C,$0E,$98,$30  ;; ?QPWZ?               ;
                      db $AC,$0E,$A0,$30,$AC,$0E,$A8,$30  ;; ?QPWZ?               ;
                      db $BE,$0E,$B0,$30,$B0,$0E,$B8,$30  ;; ?QPWZ?               ;
                      db $A8,$0E,$C0,$30,$AC,$0E,$C8,$30  ;; ?QPWZ?               ;
                      db $98,$0E,$D0,$30,$99,$0E,$D8,$30  ;; ?QPWZ?               ;
                      db $BE,$0E,$18,$40,$88,$0E,$20,$40  ;; ?QPWZ?               ;
                      db $9E,$0E,$28,$40,$8B,$0E,$38,$40  ;; ?QPWZ?               ;
                      db $98,$0E,$40,$40,$99,$0E,$48,$40  ;; ?QPWZ?               ;
                      db $AC,$0E,$58,$40,$8D,$0E,$60,$40  ;; ?QPWZ?               ;
                      db $AB,$0E,$68,$40,$99,$0E,$70,$40  ;; ?QPWZ?               ;
                      db $8C,$0E,$78,$40,$9E,$0E,$80,$40  ;; ?QPWZ?               ;
                      db $8B,$0E,$88,$40,$AC,$0E,$98,$40  ;; ?QPWZ?               ;
                      db $88,$0E,$A0,$40,$AB,$0E,$A8,$40  ;; ?QPWZ?               ;
                      db $8C,$0E,$B8,$40,$8E,$0E,$C0,$40  ;; ?QPWZ?               ;
                      db $A8,$0E,$C8,$40,$99,$0E,$D0,$40  ;; ?QPWZ?               ;
                      db $9E,$0E,$D8,$40,$8E,$0E,$18,$50  ;; ?QPWZ?               ;
                      db $AD,$0E,$20,$50,$A8,$0E,$30,$50  ;; ?QPWZ?               ;
                      db $AD,$0E,$38,$50,$88,$0E,$40,$50  ;; ?QPWZ?               ;
                      db $9B,$0E,$48,$50,$8C,$0E,$58,$50  ;; ?QPWZ?               ;
                      db $88,$0E,$68,$50,$AF,$0E,$70,$50  ;; ?QPWZ?               ;
                      db $88,$0E,$78,$50,$8A,$0E,$80,$50  ;; ?QPWZ?               ;
                      db $88,$0E,$88,$50,$AD,$0E,$90,$50  ;; ?QPWZ?               ;
                      db $99,$0E,$98,$50,$A8,$0E,$A0,$50  ;; ?QPWZ?               ;
                      db $9E,$0E,$A8,$50,$BD,$0E          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D674:          PHX                                 ;; 03D674 : DA          ;
                      REP #$30                            ;; 03D675 : C2 30       ; Index (16 bit) Accum (16 bit) 
                      LDX.W !FinalMessageTimer            ;; 03D677 : AE 21 19    ;
                      BEQ CODE_03D6A8                     ;; 03D67A : F0 2C       ;
                      DEX                                 ;; 03D67C : CA          ;
                      LDY.W #$0000                        ;; 03D67D : A0 00 00    ;
CODE_03D680:          PHX                                 ;; 03D680 : DA          ;
                      TXA                                 ;; 03D681 : 8A          ;
                      ASL A                               ;; 03D682 : 0A          ;
                      ASL A                               ;; 03D683 : 0A          ;
                      TAX                                 ;; 03D684 : AA          ;
                      LDA.W DATA_03D524,X                 ;; 03D685 : BD 24 D5    ;
                      STA.W !OAMTileXPos,Y                ;; 03D688 : 99 00 02    ;
                      LDA.W DATA_03D526,X                 ;; 03D68B : BD 26 D5    ;
                      STA.W !OAMTileNo,Y                  ;; 03D68E : 99 02 02    ;
                      PHY                                 ;; 03D691 : 5A          ;
                      TYA                                 ;; 03D692 : 98          ;
                      LSR A                               ;; 03D693 : 4A          ;
                      LSR A                               ;; 03D694 : 4A          ;
                      TAY                                 ;; 03D695 : A8          ;
                      SEP #$20                            ;; 03D696 : E2 20       ; Accum (8 bit) 
                      LDA.B #$00                          ;; 03D698 : A9 00       ;
                      STA.W !OAMTileSize,Y                ;; 03D69A : 99 20 04    ;
                      REP #$20                            ;; 03D69D : C2 20       ; Accum (16 bit) 
                      PLY                                 ;; 03D69F : 7A          ;
                      PLX                                 ;; 03D6A0 : FA          ;
                      INY                                 ;; 03D6A1 : C8          ;
                      INY                                 ;; 03D6A2 : C8          ;
                      INY                                 ;; 03D6A3 : C8          ;
                      INY                                 ;; 03D6A4 : C8          ;
                      DEX                                 ;; 03D6A5 : CA          ;
                      BPL CODE_03D680                     ;; 03D6A6 : 10 D8       ;
CODE_03D6A8:          SEP #$30                            ;; 03D6A8 : E2 30       ; Index (8 bit) Accum (8 bit) 
                      PLX                                 ;; 03D6AA : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; 03D6AC               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF                  ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03D700:          db $B0,$A0,$90,$80,$70,$60,$50,$40  ;; 03D700               ;
                      db $30,$20,$10,$00                  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D70C:          PHX                                 ;; 03D70C : DA          ;
                      LDA.W !SpriteMisc151C+4             ;; 03D70D : AD 20 15    ; \ Return if less than 2 reznors killed 
                      CLC                                 ;; 03D710 : 18          ;  | 
                      ADC.W !SpriteMisc151C+5             ;; 03D711 : 6D 21 15    ;  | 
                      ADC.W !SpriteMisc151C+6             ;; 03D714 : 6D 22 15    ;  | 
                      ADC.W !SpriteMisc151C+7             ;; 03D717 : 6D 23 15    ;  | 
                      CMP.B #$02                          ;; 03D71A : C9 02       ;  | 
                      BCC CODE_03D757                     ;; 03D71C : 90 39       ; / 
                      LDX.W !ReznorBridgeCount            ;; ?QPWZ? : AE 9F 1B    ;
                      CPX.B #$0C                          ;; 03D721 : E0 0C       ;
                      BCS CODE_03D757                     ;; 03D723 : B0 32       ;
                      LDA.L DATA_03D700,X                 ;; 03D725 : BF 00 D7 03 ;
                      STA.B !TouchBlockXPos               ;; 03D729 : 85 9A       ;
                      STZ.B !TouchBlockXPos+1             ;; 03D72B : 64 9B       ;
                      LDA.B #$B0                          ;; 03D72D : A9 B0       ;
                      STA.B !TouchBlockYPos               ;; 03D72F : 85 98       ;
                      STZ.B !TouchBlockYPos+1             ;; 03D731 : 64 99       ;
                      LDA.W !ReznorBridgeTimer            ;; 03D733 : AD A7 14    ;
                      BEQ CODE_03D74A                     ;; 03D736 : F0 12       ;
                      CMP.B #$3C                          ;; 03D738 : C9 3C       ;
                      BNE CODE_03D757                     ;; 03D73A : D0 1B       ;
                      JSR CODE_03D77F                     ;; 03D73C : 20 7F D7    ;
                      JSR CODE_03D759                     ;; 03D73F : 20 59 D7    ;
                      JSR CODE_03D77F                     ;; 03D742 : 20 7F D7    ;
                      INC.W !ReznorBridgeCount            ;; 03D745 : EE 9F 1B    ;
                      BRA CODE_03D757                     ;; 03D748 : 80 0D       ;
                                                          ;;                      ;
CODE_03D74A:          JSR CODE_03D766                     ;; 03D74A : 20 66 D7    ;
                      LDA.B #$40                          ;; 03D74D : A9 40       ;
                      STA.W !ReznorBridgeTimer            ;; 03D74F : 8D A7 14    ;
                      LDA.B #$07                          ;; 03D752 : A9 07       ;
                      STA.W !SPCIO3                       ;; 03D754 : 8D FC 1D    ; / Play sound effect 
CODE_03D757:          PLX                                 ;; 03D757 : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03D759:          REP #$20                            ;; 03D759 : C2 20       ; Accum (16 bit) 
                      LDA.W #$0170                        ;; 03D75B : A9 70 01    ;
                      SEC                                 ;; 03D75E : 38          ;
                      SBC.B !TouchBlockXPos               ;; 03D75F : E5 9A       ;
                      STA.B !TouchBlockXPos               ;; 03D761 : 85 9A       ;
                      SEP #$20                            ;; 03D763 : E2 20       ; Accum (8 bit) 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D766:          JSR CODE_03D76C                     ;; 03D766 : 20 6C D7    ;
                      JSR CODE_03D759                     ;; 03D769 : 20 59 D7    ;
CODE_03D76C:          REP #$20                            ;; 03D76C : C2 20       ; Accum (16 bit) 
                      LDA.B !TouchBlockXPos               ;; 03D76E : A5 9A       ;
                      SEC                                 ;; 03D770 : 38          ;
                      SBC.B !Layer1XPos                   ;; 03D771 : E5 1A       ;
                      CMP.W #$0100                        ;; 03D773 : C9 00 01    ;
                      SEP #$20                            ;; 03D776 : E2 20       ; Accum (8 bit) 
                      BCS Return03D77E                    ;; 03D778 : B0 04       ;
                      JSL CODE_028A44                     ;; 03D77A : 22 44 8A 02 ;
Return03D77E:         RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03D77F:          LDA.B !TouchBlockXPos               ;; 03D77F : A5 9A       ;
                      LSR A                               ;; 03D781 : 4A          ;
                      LSR A                               ;; 03D782 : 4A          ;
                      LSR A                               ;; 03D783 : 4A          ;
                      STA.B !_1                           ;; 03D784 : 85 01       ;
                      LSR A                               ;; 03D786 : 4A          ;
                      ORA.B !TouchBlockYPos               ;; 03D787 : 05 98       ;
                      REP #$20                            ;; 03D789 : C2 20       ; Accum (16 bit) 
                      AND.W #$00FF                        ;; 03D78B : 29 FF 00    ;
                      LDX.B !TouchBlockXPos+1             ;; 03D78E : A6 9B       ;
                      BEQ CODE_03D798                     ;; 03D790 : F0 06       ;
                      CLC                                 ;; 03D792 : 18          ;
                      ADC.W #$01B0                        ;; 03D793 : 69 B0 01    ;
                      LDX.B #$04                          ;; 03D796 : A2 04       ;
CODE_03D798:          STX.B !_0                           ;; 03D798 : 86 00       ;
                      REP #$10                            ;; 03D79A : C2 10       ; Index (16 bit) 
                      TAX                                 ;; 03D79C : AA          ;
                      SEP #$20                            ;; 03D79D : E2 20       ; Accum (8 bit) 
                      LDA.B #$25                          ;; 03D79F : A9 25       ;
                      STA.L !Map16TilesLow,X              ;; 03D7A1 : 9F 00 C8 7E ;
                      LDA.B #$00                          ;; 03D7A5 : A9 00       ;
                      STA.L !Map16TilesHigh,X             ;; 03D7A7 : 9F 00 C8 7F ;
                      REP #$20                            ;; 03D7AB : C2 20       ; Accum (16 bit) 
                      LDA.L !DynStripeImgSize             ;; 03D7AD : AF 7B 83 7F ;
                      TAX                                 ;; 03D7B1 : AA          ;
                      LDA.W #$C05A                        ;; 03D7B2 : A9 5A C0    ;
                      CLC                                 ;; 03D7B5 : 18          ;
                      ADC.B !_0                           ;; 03D7B6 : 65 00       ;
                      STA.L !DynamicStripeImage,X         ;; 03D7B8 : 9F 7D 83 7F ;
                      ORA.W #$2000                        ;; 03D7BC : 09 00 20    ;
                      STA.L !DynamicStripeImage+6,X       ;; 03D7BF : 9F 83 83 7F ;
                      LDA.W #$0240                        ;; 03D7C3 : A9 40 02    ;
                      STA.L !DynamicStripeImage+2,X       ;; 03D7C6 : 9F 7F 83 7F ;
                      STA.L !DynamicStripeImage+8,X       ;; 03D7CA : 9F 85 83 7F ;
                      LDA.W #$38FC                        ;; 03D7CE : A9 FC 38    ;
                      STA.L !DynamicStripeImage+4,X       ;; 03D7D1 : 9F 81 83 7F ;
                      STA.L !DynamicStripeImage+$0A,X     ;; 03D7D5 : 9F 87 83 7F ;
                      LDA.W #$00FF                        ;; 03D7D9 : A9 FF 00    ;
                      STA.L !DynamicStripeImage+$0C,X     ;; 03D7DC : 9F 89 83 7F ;
                      TXA                                 ;; 03D7E0 : 8A          ;
                      CLC                                 ;; 03D7E1 : 18          ;
                      ADC.W #$000C                        ;; 03D7E2 : 69 0C 00    ;
                      STA.L !DynStripeImgSize             ;; 03D7E5 : 8F 7B 83 7F ;
                      SEP #$30                            ;; 03D7E9 : E2 30       ; Index (8 bit) Accum (8 bit) 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$15,$16,$17,$18,$17,$18  ;; ?QPWZ?               ;
                      db $17,$18,$17,$18,$19,$1A,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$01,$02,$03,$04,$03,$04  ;; ?QPWZ?               ;
                      db $03,$04,$03,$04,$05,$12,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$07,$04,$03,$04,$03  ;; ?QPWZ?               ;
                      db $04,$03,$04,$03,$08,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$09,$0A,$04,$03,$04  ;; ?QPWZ?               ;
                      db $03,$04,$03,$0B,$0C,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$0D,$0E,$04,$03  ;; ?QPWZ?               ;
                      db $04,$03,$0F,$10,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$11,$02,$03,$04  ;; ?QPWZ?               ;
                      db $03,$04,$05,$12,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$07,$04,$03  ;; ?QPWZ?               ;
                      db $04,$03,$08,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$09,$0A,$04  ;; ?QPWZ?               ;
                      db $03,$0B,$0C,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$13,$03  ;; ?QPWZ?               ;
                      db $04,$14,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$13  ;; ?QPWZ?               ;
                      db $14,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
DATA_03D8EC:          db $FF,$FF                          ;; 03D8EC               ;
                                                          ;;                      ;
DATA_03D8EE:          db $FF,$FF,$FF,$FF,$24,$34,$25,$0B  ;; 03D8EE               ;
                      db $26,$36,$0E,$1B,$0C,$1C,$0D,$1D  ;; ?QPWZ?               ;
                      db $0E,$1E,$29,$39,$2A,$3A,$2B,$3B  ;; ?QPWZ?               ;
                      db $26,$38,$20,$30,$21,$31,$27,$37  ;; ?QPWZ?               ;
                      db $28,$38,$FF,$FF,$22,$32,$0E,$33  ;; ?QPWZ?               ;
                      db $0C,$1C,$0D,$1D,$0E,$3C,$2D,$3D  ;; ?QPWZ?               ;
                      db $FF,$FF,$07,$17,$0E,$23,$0E,$04  ;; ?QPWZ?               ;
                      db $0C,$1C,$0D,$1D,$0E,$09,$0E,$2C  ;; ?QPWZ?               ;
                      db $0A,$1A,$FF,$FF,$24,$34,$2B,$3B  ;; ?QPWZ?               ;
                      db $FF,$FF,$07,$17,$0E,$18,$0E,$19  ;; ?QPWZ?               ;
                      db $0A,$1A,$02,$12,$03,$13,$03,$08  ;; ?QPWZ?               ;
                      db $03,$05,$03,$05,$03,$14,$03,$15  ;; ?QPWZ?               ;
                      db $03,$05,$03,$05,$03,$08,$03,$06  ;; ?QPWZ?               ;
                      db $0F,$1F                          ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03D958:          REP #$10                            ;; 03D958 : C2 10       ; Index (16 bit) 
                      STZ.W !HW_VMAINC                    ;; 03D95A : 9C 15 21    ; VRAM Address Increment Value
                      STZ.W !HW_VMADD                     ;; 03D95D : 9C 16 21    ; Address for VRAM Read/Write (Low Byte)
                      STZ.W !HW_VMADD+1                   ;; 03D960 : 9C 17 21    ; Address for VRAM Read/Write (High Byte)
                      LDX.W #$4000                        ;; 03D963 : A2 00 40    ;
                      LDA.B #$FF                          ;; 03D966 : A9 FF       ;
CODE_03D968:          STA.W !HW_VMDATA                    ;; 03D968 : 8D 18 21    ; Data for VRAM Write (Low Byte)
                      DEX                                 ;; 03D96B : CA          ;
                      BNE CODE_03D968                     ;; 03D96C : D0 FA       ;
                      SEP #$10                            ;; 03D96E : E2 10       ; Index (8 bit) 
                      BIT.W !IRQNMICommand                ;; 03D970 : 2C 9B 0D    ;
                      BVS Return03D990                    ;; 03D973 : 70 1B       ;
                      PHB                                 ;; 03D975 : 8B          ;
                      PHK                                 ;; 03D976 : 4B          ;
                      PLB                                 ;; 03D977 : AB          ;
                      LDA.B #$EC                          ;; 03D978 : A9 EC       ;
                      STA.B !_5                           ;; 03D97A : 85 05       ;
                      LDA.B #$D7                          ;; 03D97C : A9 D7       ;
                      STA.B !_6                           ;; 03D97E : 85 06       ;
                      LDA.B #$03                          ;; 03D980 : A9 03       ;
                      STA.B !_7                           ;; 03D982 : 85 07       ;
                      LDA.B #$10                          ;; 03D984 : A9 10       ;
                      STA.B !_0                           ;; 03D986 : 85 00       ;
                      LDA.B #$08                          ;; 03D988 : A9 08       ;
                      STA.B !_1                           ;; 03D98A : 85 01       ;
                      JSR CODE_03D991                     ;; 03D98C : 20 91 D9    ;
                      PLB                                 ;; 03D98F : AB          ;
Return03D990:         RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03D991:          STZ.W !HW_VMAINC                    ;; 03D991 : 9C 15 21    ; VRAM Address Increment Value
                      LDY.B #$00                          ;; 03D994 : A0 00       ;
CODE_03D996:          STY.B !_2                           ;; 03D996 : 84 02       ;
                      LDA.B #$00                          ;; 03D998 : A9 00       ;
CODE_03D99A:          STA.B !_3                           ;; 03D99A : 85 03       ;
                      LDA.B !_0                           ;; 03D99C : A5 00       ;
                      STA.W !HW_VMADD                     ;; 03D99E : 8D 16 21    ; Address for VRAM Read/Write (Low Byte)
                      LDA.B !_1                           ;; 03D9A1 : A5 01       ;
                      STA.W !HW_VMADD+1                   ;; 03D9A3 : 8D 17 21    ; Address for VRAM Read/Write (High Byte)
                      LDY.B !_2                           ;; 03D9A6 : A4 02       ;
                      LDA.B #$10                          ;; 03D9A8 : A9 10       ;
                      STA.B !_4                           ;; 03D9AA : 85 04       ;
CODE_03D9AC:          LDA.B [!_5],Y                       ;; 03D9AC : B7 05       ;
                      STA.W !GfxDecompOWAni,Y             ;; 03D9AE : 99 F6 0A    ;
                      ASL A                               ;; 03D9B1 : 0A          ;
                      ASL A                               ;; 03D9B2 : 0A          ;
                      ORA.B !_3                           ;; 03D9B3 : 05 03       ;
                      TAX                                 ;; 03D9B5 : AA          ;
                      LDA.L DATA_03D8EC,X                 ;; 03D9B6 : BF EC D8 03 ;
                      STA.W !HW_VMDATA                    ;; 03D9BA : 8D 18 21    ; Data for VRAM Write (Low Byte)
                      LDA.L DATA_03D8EE,X                 ;; 03D9BD : BF EE D8 03 ;
                      STA.W !HW_VMDATA                    ;; 03D9C1 : 8D 18 21    ; Data for VRAM Write (Low Byte)
                      INY                                 ;; 03D9C4 : C8          ;
                      DEC.B !_4                           ;; 03D9C5 : C6 04       ;
                      BNE CODE_03D9AC                     ;; 03D9C7 : D0 E3       ;
                      LDA.B !_0                           ;; 03D9C9 : A5 00       ;
                      CLC                                 ;; 03D9CB : 18          ;
                      ADC.B #$80                          ;; 03D9CC : 69 80       ;
                      STA.B !_0                           ;; 03D9CE : 85 00       ;
                      BCC CODE_03D9D4                     ;; 03D9D0 : 90 02       ;
                      INC.B !_1                           ;; 03D9D2 : E6 01       ;
CODE_03D9D4:          LDA.B !_3                           ;; 03D9D4 : A5 03       ;
                      EOR.B #$01                          ;; 03D9D6 : 49 01       ;
                      BNE CODE_03D99A                     ;; 03D9D8 : D0 C0       ;
                      TYA                                 ;; 03D9DA : 98          ;
                      BNE CODE_03D996                     ;; 03D9DB : D0 B9       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03D9DE:          db $FF,$00,$FF,$FF,$02,$04,$06,$FF  ;; 03D9DE               ;
                      db $08,$0A,$0C,$FF,$0E,$10,$12,$FF  ;; ?QPWZ?               ;
                      db $FF,$00,$FF,$FF,$02,$04,$06,$FF  ;; ?QPWZ?               ;
                      db $08,$0A,$0C,$FF,$0E,$14,$16,$FF  ;; ?QPWZ?               ;
                      db $FF,$00,$FF,$FF,$02,$04,$06,$FF  ;; ?QPWZ?               ;
                      db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $46,$48,$4A,$FF,$4C,$4E,$50,$FF  ;; ?QPWZ?               ;
                      db $52,$54,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$B2,$B4,$06,$FF  ;; ?QPWZ?               ;
                      db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $FF,$1C,$FF,$FF,$1E,$20,$22,$FF  ;; ?QPWZ?               ;
                      db $24,$26,$28,$FF,$FF,$2A,$2C,$FF  ;; ?QPWZ?               ;
                      db $FF,$2E,$30,$FF,$32,$34,$35,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $FF,$2E,$30,$FF,$32,$34,$35,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $FF,$2E,$30,$FF,$32,$34,$35,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$3E,$40,$41,$3F  ;; ?QPWZ?               ;
                      db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF  ;; ?QPWZ?               ;
                      db $08,$0A,$0C,$FF,$0E,$10,$12,$FF  ;; ?QPWZ?               ;
                      db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF  ;; ?QPWZ?               ;
                      db $08,$0A,$0C,$FF,$0E,$14,$16,$FF  ;; ?QPWZ?               ;
                      db $5A,$FF,$FF,$FF,$5C,$5E,$06,$FF  ;; ?QPWZ?               ;
                      db $08,$0A,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $6C,$6E,$FF,$FF,$72,$74,$50,$FF  ;; ?QPWZ?               ;
                      db $52,$54,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $FF,$BE,$FF,$FF,$DC,$DE,$06,$FF  ;; ?QPWZ?               ;
                      db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $60,$62,$FF,$FF,$64,$66,$22,$FF  ;; ?QPWZ?               ;
                      db $24,$26,$28,$FF,$FF,$2A,$2C,$FF  ;; ?QPWZ?               ;
                      db $FF,$68,$69,$FF,$32,$6A,$6B,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $FF,$68,$69,$FF,$32,$6A,$6B,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $FF,$68,$69,$FF,$32,$6A,$6B,$33  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$3E,$40,$41,$3F  ;; ?QPWZ?               ;
                      db $7A,$7C,$FF,$FF,$7E,$80,$82,$FF  ;; ?QPWZ?               ;
                      db $84,$86,$0C,$FF,$0E,$10,$12,$FF  ;; ?QPWZ?               ;
                      db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF  ;; ?QPWZ?               ;
                      db $84,$86,$0C,$FF,$0E,$14,$16,$FF  ;; ?QPWZ?               ;
                      db $7A,$7C,$FF,$FF,$7E,$80,$06,$FF  ;; ?QPWZ?               ;
                      db $84,$86,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $A0,$A2,$A4,$FF,$A6,$A8,$AA,$FF  ;; ?QPWZ?               ;
                      db $52,$54,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $FF,$B8,$FF,$FF,$D6,$D8,$DA,$FF  ;; ?QPWZ?               ;
                      db $D2,$D4,$0C,$FF,$0E,$18,$1A,$FF  ;; ?QPWZ?               ;
                      db $88,$8A,$8C,$FF,$8E,$90,$92,$FF  ;; ?QPWZ?               ;
                      db $94,$96,$28,$FF,$FF,$2A,$2C,$FF  ;; ?QPWZ?               ;
                      db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$42,$44,$45,$43  ;; ?QPWZ?               ;
                      db $98,$9A,$9B,$99,$9C,$9E,$9F,$9D  ;; ?QPWZ?               ;
                      db $36,$38,$39,$37,$3E,$40,$41,$3F  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF  ;; ?QPWZ?               ;
                      db $C0,$C2,$C4,$FF,$E0,$E2,$E4,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$CC,$FF,$FF  ;; ?QPWZ?               ;
                      db $C6,$C8,$CA,$FF,$E6,$E8,$EA,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$CD,$FF,$FF  ;; ?QPWZ?               ;
                      db $C5,$C3,$C1,$FF,$E5,$E3,$E1,$FF  ;; ?QPWZ?               ;
                      db $FF,$90,$92,$94,$96,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$B0,$B2,$B4,$B6,$38,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF  ;; ?QPWZ?               ;
                      db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF  ;; ?QPWZ?               ;
                      db $FF,$90,$92,$94,$96,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$98,$9A,$9C,$B6,$38,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$D0,$D2,$D4,$D6,$58,$5A,$FF  ;; ?QPWZ?               ;
                      db $FF,$F0,$F2,$F4,$F6,$78,$7A,$FF  ;; ?QPWZ?               ;
                      db $FF,$90,$92,$94,$96,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF  ;; ?QPWZ?               ;
                      db $FF,$F8,$FA,$FC,$F6,$78,$7A,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$90,$92,$94,$96,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$D8,$DA,$DC,$D6,$58,$5A  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$90,$92,$94,$96,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$98,$BA,$BC,$B6,$38,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$90,$92,$94,$96,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$90,$92,$94,$96,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$98,$BA,$BC,$B6,$38,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$D8,$DA,$DC,$D6,$58,$5A,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $04,$06,$08,$0A,$0B,$09,$07,$05  ;; ?QPWZ?               ;
                      db $24,$26,$28,$2A,$2C,$29,$27,$25  ;; ?QPWZ?               ;
                      db $FF,$84,$86,$88,$89,$87,$85,$FF  ;; ?QPWZ?               ;
                      db $FF,$A4,$A6,$A8,$A9,$A7,$A5,$FF  ;; ?QPWZ?               ;
                      db $04,$06,$08,$0A,$0B,$09,$07,$05  ;; ?QPWZ?               ;
                      db $24,$26,$28,$2D,$2B,$29,$27,$25  ;; ?QPWZ?               ;
                      db $FF,$84,$86,$88,$89,$87,$85,$FF  ;; ?QPWZ?               ;
                      db $FF,$A4,$A6,$0C,$0D,$A7,$A5,$FF  ;; ?QPWZ?               ;
                      db $80,$82,$83,$8A,$82,$83,$8C,$8E  ;; ?QPWZ?               ;
                      db $A0,$A2,$A3,$C4,$A2,$A3,$AC,$AE  ;; ?QPWZ?               ;
                      db $80,$8A,$8A,$8A,$8A,$8A,$8C,$8E  ;; ?QPWZ?               ;
                      db $A0,$60,$61,$C4,$60,$61,$AC,$AE  ;; ?QPWZ?               ;
                      db $80,$03,$01,$8A,$00,$02,$8C,$8E  ;; ?QPWZ?               ;
                      db $A0,$23,$21,$C4,$20,$22,$AC,$AE  ;; ?QPWZ?               ;
                      db $80,$00,$02,$8A,$03,$01,$AA,$8E  ;; ?QPWZ?               ;
                      db $A0,$20,$22,$C4,$23,$21,$AC,$AE  ;; ?QPWZ?               ;
                      db $C0,$C2,$C4,$C4,$C4,$CA,$CC,$CE  ;; ?QPWZ?               ;
                      db $E0,$E2,$E4,$E6,$E8,$EA,$EC,$EE  ;; ?QPWZ?               ;
                      db $40,$42,$44,$46,$48,$4A,$4C,$4E  ;; ?QPWZ?               ;
                      db $FF,$62,$64,$66,$68,$6A,$6C,$FF  ;; ?QPWZ?               ;
                      db $10,$12,$14,$16,$18,$1A,$1C,$1E  ;; ?QPWZ?               ;
                      db $10,$30,$32,$34,$36,$1A,$1C,$1E  ;; ?QPWZ?               ;
KoopaPalPtrLo:        db $BC,$A4,$98,$78,$6C              ;; ?QPWZ?               ;
                                                          ;;                      ;
KoopaPalPtrHi:        db $B2,$B2,$B2,$B3,$B3              ;; ?QPWZ?               ;
                                                          ;;                      ;
DATA_03DD78:          db $0B,$0B,$0B,$21,$00              ;; 03DD78               ;
                                                          ;;                      ;
CODE_03DD7D:          PHX                                 ;; 03DD7D : DA          ;
                      PHB                                 ;; 03DD7E : 8B          ;
                      PHK                                 ;; 03DD7F : 4B          ;
                      PLB                                 ;; 03DD80 : AB          ;
                      LDY.B !SpriteTableC2,X              ;; 03DD81 : B4 C2       ;
                      STY.W !ActiveBoss                   ;; 03DD83 : 8C FC 13    ;
                      CPY.B #$04                          ;; 03DD86 : C0 04       ;
                      BNE CODE_03DD97                     ;; 03DD88 : D0 0D       ;
                      JSR CODE_03DE8E                     ;; 03DD8A : 20 8E DE    ;
                      LDA.B #$48                          ;; 03DD8D : A9 48       ;
                      STA.B !Mode7CenterY                 ;; 03DD8F : 85 2C       ;
                      LDA.B #$14                          ;; 03DD91 : A9 14       ;
                      STA.B !Mode7XScale                  ;; 03DD93 : 85 38       ;
                      STA.B !Mode7YScale                  ;; 03DD95 : 85 39       ;
CODE_03DD97:          LDA.B #$FF                          ;; 03DD97 : A9 FF       ;
                      STA.B !LevelScrLength               ;; 03DD99 : 85 5D       ;
                      INC A                               ;; 03DD9B : 1A          ;
                      STA.B !LastScreenHoriz              ;; 03DD9C : 85 5E       ;
                      LDY.W !ActiveBoss                   ;; 03DD9E : AC FC 13    ;
                      LDX.W DATA_03DD78,Y                 ;; 03DDA1 : BE 78 DD    ;
                      LDA.W KoopaPalPtrLo,Y               ;; 03DDA4 : B9 6E DD    ; \ $00 = Pointer in bank 0 (from above tables) 
                      STA.B !_0                           ;; 03DDA7 : 85 00       ;  | 
                      LDA.W KoopaPalPtrHi,Y               ;; 03DDA9 : B9 73 DD    ;  | 
                      STA.B !_1                           ;; 03DDAC : 85 01       ;  | 
                      STZ.B !_2                           ;; 03DDAE : 64 02       ; / 
                      LDY.B #$0B                          ;; 03DDB0 : A0 0B       ; \ Read 0B bytes and put them in $0707 
CODE_03DDB2:          LDA.B [!_0],Y                       ;; 03DDB2 : B7 00       ;  | 
                      STA.W !MainPalette+4,Y              ;; 03DDB4 : 99 07 07    ;  | 
                      DEY                                 ;; 03DDB7 : 88          ;  | 
                      BPL CODE_03DDB2                     ;; 03DDB8 : 10 F8       ; / 
                      LDA.B #$80                          ;; 03DDBA : A9 80       ;
                      STA.W !HW_VMAINC                    ;; 03DDBC : 8D 15 21    ; VRAM Address Increment Value
                      STZ.W !HW_VMADD                     ;; 03DDBF : 9C 16 21    ; Address for VRAM Read/Write (Low Byte)
                      STZ.W !HW_VMADD+1                   ;; 03DDC2 : 9C 17 21    ; Address for VRAM Read/Write (High Byte)
                      TXY                                 ;; 03DDC5 : 9B          ;
                      BEQ CODE_03DDD7                     ;; 03DDC6 : F0 0F       ;
                      JSL CODE_00BA28                     ;; 03DDC8 : 22 28 BA 00 ;
                      LDA.B #$80                          ;; 03DDCC : A9 80       ;
                      STA.B !_3                           ;; 03DDCE : 85 03       ;
CODE_03DDD0:          JSR CODE_03DDE5                     ;; 03DDD0 : 20 E5 DD    ;
                      DEC.B !_3                           ;; 03DDD3 : C6 03       ;
                      BNE CODE_03DDD0                     ;; 03DDD5 : D0 F9       ;
CODE_03DDD7:          LDX.B #$5F                          ;; 03DDD7 : A2 5F       ;
CODE_03DDD9:          LDA.B #$FF                          ;; 03DDD9 : A9 FF       ;
                      STA.L !Mode7BossTilemap,X           ;; 03DDDB : 9F 80 C6 7E ;
                      DEX                                 ;; 03DDDF : CA          ;
                      BPL CODE_03DDD9                     ;; 03DDE0 : 10 F7       ;
                      PLB                                 ;; 03DDE2 : AB          ;
                      PLX                                 ;; 03DDE3 : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03DDE5:          LDX.B #$00                          ;; 03DDE5 : A2 00       ;
                      TXY                                 ;; 03DDE7 : 9B          ;
                      LDA.B #$08                          ;; 03DDE8 : A9 08       ;
                      STA.B !_5                           ;; 03DDEA : 85 05       ;
CODE_03DDEC:          JSR CODE_03DE39                     ;; 03DDEC : 20 39 DE    ;
                      PHY                                 ;; 03DDEF : 5A          ;
                      TYA                                 ;; 03DDF0 : 98          ;
                      LSR A                               ;; 03DDF1 : 4A          ;
                      CLC                                 ;; 03DDF2 : 18          ;
                      ADC.B #$0F                          ;; 03DDF3 : 69 0F       ;
                      TAY                                 ;; 03DDF5 : A8          ;
                      JSR CODE_03DE3C                     ;; 03DDF6 : 20 3C DE    ;
                      LDY.B #$08                          ;; 03DDF9 : A0 08       ;
CODE_03DDFB:          LDA.W !Mode7GfxBuffer,X             ;; 03DDFB : BD A3 1B    ;
                      ASL A                               ;; 03DDFE : 0A          ;
                      ROL A                               ;; 03DDFF : 2A          ;
                      ROL A                               ;; 03DE00 : 2A          ;
                      ROL A                               ;; 03DE01 : 2A          ;
                      AND.B #$07                          ;; 03DE02 : 29 07       ;
                      STA.W !Mode7GfxBuffer,X             ;; 03DE04 : 9D A3 1B    ;
                      STA.W $2119                         ;; 03DE07 : 8D 19 21    ; Data for VRAM Write (High Byte)
                      INX                                 ;; 03DE0A : E8          ;
                      DEY                                 ;; 03DE0B : 88          ;
                      BNE CODE_03DDFB                     ;; 03DE0C : D0 ED       ;
                      PLY                                 ;; 03DE0E : 7A          ;
                      DEC.B !_5                           ;; 03DE0F : C6 05       ;
                      BNE CODE_03DDEC                     ;; 03DE11 : D0 D9       ;
                      LDA.B #$07                          ;; 03DE13 : A9 07       ;
CODE_03DE15:          TAX                                 ;; 03DE15 : AA          ;
                      LDY.B #$08                          ;; 03DE16 : A0 08       ;
                      STY.B !_5                           ;; 03DE18 : 84 05       ;
CODE_03DE1A:          LDY.W !Mode7GfxBuffer,X             ;; 03DE1A : BC A3 1B    ;
                      STY.W $2119                         ;; 03DE1D : 8C 19 21    ; Data for VRAM Write (High Byte)
                      DEX                                 ;; 03DE20 : CA          ;
                      DEC.B !_5                           ;; 03DE21 : C6 05       ;
                      BNE CODE_03DE1A                     ;; 03DE23 : D0 F5       ;
                      CLC                                 ;; 03DE25 : 18          ;
                      ADC.B #$08                          ;; 03DE26 : 69 08       ;
                      CMP.B #$40                          ;; 03DE28 : C9 40       ;
                      BCC CODE_03DE15                     ;; 03DE2A : 90 E9       ;
                      REP #$20                            ;; 03DE2C : C2 20       ; Accum (16 bit) 
                      LDA.B !_0                           ;; 03DE2E : A5 00       ;
                      CLC                                 ;; 03DE30 : 18          ;
                      ADC.W #$0018                        ;; 03DE31 : 69 18 00    ;
                      STA.B !_0                           ;; 03DE34 : 85 00       ;
                      SEP #$20                            ;; 03DE36 : E2 20       ; Accum (8 bit) 
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
CODE_03DE39:          JSR CODE_03DE3C                     ;; 03DE39 : 20 3C DE    ;
CODE_03DE3C:          PHX                                 ;; 03DE3C : DA          ;
                      LDA.B [!_0],Y                       ;; 03DE3D : B7 00       ;
                      PHY                                 ;; 03DE3F : 5A          ;
                      LDY.B #$08                          ;; 03DE40 : A0 08       ;
CODE_03DE42:          ASL A                               ;; 03DE42 : 0A          ;
                      ROR.W !Mode7GfxBuffer,X             ;; 03DE43 : 7E A3 1B    ;
                      INX                                 ;; 03DE46 : E8          ;
                      DEY                                 ;; 03DE47 : 88          ;
                      BNE CODE_03DE42                     ;; 03DE48 : D0 F8       ;
                      PLY                                 ;; 03DE4A : 7A          ;
                      INY                                 ;; 03DE4B : C8          ;
                      PLX                                 ;; 03DE4C : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DE4E:          db $40,$41,$42,$43,$44,$45,$46,$47  ;; 03DE4E               ;
                      db $50,$51,$52,$53,$54,$55,$56,$57  ;; ?QPWZ?               ;
                      db $60,$61,$62,$63,$64,$65,$66,$67  ;; ?QPWZ?               ;
                      db $70,$71,$72,$73,$74,$75,$76,$77  ;; ?QPWZ?               ;
                      db $48,$49,$4A,$4B,$4C,$4D,$4E,$4F  ;; ?QPWZ?               ;
                      db $58,$59,$5A,$5B,$5C,$5D,$5E,$5F  ;; ?QPWZ?               ;
                      db $68,$69,$6A,$6B,$6C,$6D,$6E,$6F  ;; ?QPWZ?               ;
                      db $78,$79,$7A,$7B,$7C,$7D,$7E,$3F  ;; ?QPWZ?               ;
                                                          ;;                      ;
CODE_03DE8E:          STZ.W !HW_VMAINC                    ;; 03DE8E : 9C 15 21    ; VRAM Address Increment Value
                      REP #$20                            ;; 03DE91 : C2 20       ; Accum (16 bit) 
                      LDA.W #$0A1C                        ;; 03DE93 : A9 1C 0A    ;
                      STA.B !_0                           ;; 03DE96 : 85 00       ;
                      LDX.B #$00                          ;; 03DE98 : A2 00       ;
CODE_03DE9A:          REP #$20                            ;; 03DE9A : C2 20       ; Accum (16 bit) 
                      LDA.B !_0                           ;; 03DE9C : A5 00       ;
                      CLC                                 ;; 03DE9E : 18          ;
                      ADC.W #$0080                        ;; 03DE9F : 69 80 00    ;
                      STA.B !_0                           ;; 03DEA2 : 85 00       ;
                      STA.W !HW_VMADD                     ;; 03DEA4 : 8D 16 21    ; Address for VRAM Read/Write (Low Byte)
                      SEP #$20                            ;; 03DEA7 : E2 20       ; Accum (8 bit) 
                      LDY.B #$08                          ;; 03DEA9 : A0 08       ;
CODE_03DEAB:          LDA.L DATA_03DE4E,X                 ;; 03DEAB : BF 4E DE 03 ;
                      STA.W !HW_VMDATA                    ;; 03DEAF : 8D 18 21    ; Data for VRAM Write (Low Byte)
                      INX                                 ;; 03DEB2 : E8          ;
                      DEY                                 ;; 03DEB3 : 88          ;
                      BNE CODE_03DEAB                     ;; 03DEB4 : D0 F5       ;
                      CPX.B #$40                          ;; 03DEB6 : E0 40       ;
                      BCC CODE_03DE9A                     ;; 03DEB8 : 90 E0       ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DEBB:          db $00,$01,$10,$01                  ;; 03DEBB               ;
                                                          ;;                      ;
DATA_03DEBF:          db $6E,$70,$FF,$50,$FE,$FE,$FF,$57  ;; 03DEBF               ;
DATA_03DEC7:          db $72,$74,$52,$54,$3C,$3E,$55,$53  ;; 03DEC7               ;
DATA_03DECF:          db $76,$56,$56,$FF,$FF,$FF,$51,$FF  ;; 03DECF               ;
DATA_03DED7:          db $20,$03,$30,$03,$40,$03,$50,$03  ;; 03DED7               ;
                                                          ;;                      ;
CODE_03DEDF:          PHB                                 ;; 03DEDF : 8B          ;
                      PHK                                 ;; 03DEE0 : 4B          ;
                      PLB                                 ;; 03DEE1 : AB          ;
                      LDA.W !SpriteYPosHigh,X             ;; 03DEE2 : BD E0 14    ;
                      XBA                                 ;; 03DEE5 : EB          ;
                      LDA.B !SpriteXPosLow,X              ;; 03DEE6 : B5 E4       ;
                      LDY.B #$00                          ;; 03DEE8 : A0 00       ;
                      JSR CODE_03DFAE                     ;; 03DEEA : 20 AE DF    ;
                      LDA.W !SpriteXPosHigh,X             ;; 03DEED : BD D4 14    ;
                      XBA                                 ;; 03DEF0 : EB          ;
                      LDA.B !SpriteYPosLow,X              ;; 03DEF1 : B5 D8       ;
                      LDY.B #$02                          ;; 03DEF3 : A0 02       ;
                      JSR CODE_03DFAE                     ;; 03DEF5 : 20 AE DF    ;
                      PHX                                 ;; 03DEF8 : DA          ;
                      REP #$30                            ;; 03DEF9 : C2 30       ; Index (16 bit) Accum (16 bit) 
                      STZ.B !_6                           ;; 03DEFB : 64 06       ;
                      LDY.W #$0003                        ;; 03DEFD : A0 03 00    ;
                      LDA.W !IRQNMICommand                ;; 03DF00 : AD 9B 0D    ;
                      LSR A                               ;; 03DF03 : 4A          ;
                      BCC CODE_03DF44                     ;; 03DF04 : 90 3E       ;
                      LDA.W !ClownCarPropeller            ;; 03DF06 : AD 28 14    ;
                      AND.W #$0003                        ;; 03DF09 : 29 03 00    ;
                      ASL A                               ;; 03DF0C : 0A          ;
                      TAX                                 ;; 03DF0D : AA          ;
                      LDA.L DATA_03DEBF,X                 ;; 03DF0E : BF BF DE 03 ;
                      STA.L !Mode7BossTilemap+1           ;; 03DF12 : 8F 81 C6 7E ;
                      LDA.L DATA_03DEC7,X                 ;; 03DF16 : BF C7 DE 03 ;
                      STA.L !Mode7BossTilemap+3           ;; 03DF1A : 8F 83 C6 7E ;
                      LDA.L DATA_03DECF,X                 ;; 03DF1E : BF CF DE 03 ;
                      STA.L !Mode7BossTilemap+5           ;; 03DF22 : 8F 85 C6 7E ;
                      LDA.W #$0008                        ;; 03DF26 : A9 08 00    ;
                      STA.B !_6                           ;; 03DF29 : 85 06       ;
                      LDX.W #$0380                        ;; 03DF2B : A2 80 03    ;
                      LDA.W !Mode7TileIndex               ;; 03DF2E : AD A2 1B    ;
                      AND.W #$007F                        ;; 03DF31 : 29 7F 00    ;
                      CMP.W #$002C                        ;; 03DF34 : C9 2C 00    ;
                      BCC CODE_03DF3C                     ;; 03DF37 : 90 03       ;
                      LDX.W #$0388                        ;; 03DF39 : A2 88 03    ;
CODE_03DF3C:          TXA                                 ;; 03DF3C : 8A          ;
                      LDX.W #$000A                        ;; 03DF3D : A2 0A 00    ;
                      LDY.W #$0007                        ;; 03DF40 : A0 07 00    ;
                      SEC                                 ;; 03DF43 : 38          ;
CODE_03DF44:          STY.B !_0                           ;; 03DF44 : 84 00       ;
                      BCS CODE_03DF55                     ;; 03DF46 : B0 0D       ;
CODE_03DF48:          LDA.W !Mode7TileIndex               ;; 03DF48 : AD A2 1B    ;
                      AND.W #$007F                        ;; 03DF4B : 29 7F 00    ;
                      ASL A                               ;; 03DF4E : 0A          ;
                      ASL A                               ;; 03DF4F : 0A          ;
                      ASL A                               ;; 03DF50 : 0A          ;
                      ASL A                               ;; 03DF51 : 0A          ;
                      LDX.W #$0003                        ;; 03DF52 : A2 03 00    ;
CODE_03DF55:          STX.B !_2                           ;; 03DF55 : 86 02       ;
                      PHA                                 ;; 03DF57 : 48          ;
                      LDY.W !LevelLoadObjectTile          ;; 03DF58 : AC A1 1B    ;
                      BPL CODE_03DF60                     ;; 03DF5B : 10 03       ;
                      CLC                                 ;; 03DF5D : 18          ;
                      ADC.B !_0                           ;; 03DF5E : 65 00       ;
CODE_03DF60:          TAY                                 ;; 03DF60 : A8          ;
                      SEP #$20                            ;; 03DF61 : E2 20       ; Accum (8 bit) 
                      LDX.B !_6                           ;; 03DF63 : A6 06       ;
                      LDA.B !_0                           ;; 03DF65 : A5 00       ;
                      STA.B !_4                           ;; 03DF67 : 85 04       ;
CODE_03DF69:          LDA.W DATA_03D9DE,Y                 ;; 03DF69 : B9 DE D9    ;
                      INY                                 ;; 03DF6C : C8          ;
                      BIT.W !Mode7TileIndex               ;; 03DF6D : 2C A2 1B    ;
                      BPL CODE_03DF76                     ;; 03DF70 : 10 04       ;
                      EOR.B #$01                          ;; 03DF72 : 49 01       ;
                      DEY                                 ;; 03DF74 : 88          ;
                      DEY                                 ;; 03DF75 : 88          ;
CODE_03DF76:          STA.L !Mode7BossTilemap,X           ;; 03DF76 : 9F 80 C6 7E ;
                      INX                                 ;; 03DF7A : E8          ;
                      DEC.B !_4                           ;; 03DF7B : C6 04       ;
                      BPL CODE_03DF69                     ;; 03DF7D : 10 EA       ;
                      STX.B !_6                           ;; 03DF7F : 86 06       ;
                      REP #$20                            ;; 03DF81 : C2 20       ; Accum (16 bit) 
                      PLA                                 ;; 03DF83 : 68          ;
                      SEC                                 ;; 03DF84 : 38          ;
                      ADC.B !_0                           ;; 03DF85 : 65 00       ;
                      LDX.B !_2                           ;; 03DF87 : A6 02       ;
                      CPX.W #$0004                        ;; 03DF89 : E0 04 00    ;
                      BEQ CODE_03DF48                     ;; 03DF8C : F0 BA       ;
                      CPX.W #$0008                        ;; 03DF8E : E0 08 00    ;
                      BNE CODE_03DF96                     ;; 03DF91 : D0 03       ;
                      LDA.W #$0360                        ;; 03DF93 : A9 60 03    ;
CODE_03DF96:          CPX.W #$000A                        ;; 03DF96 : E0 0A 00    ;
                      BNE CODE_03DFA6                     ;; 03DF99 : D0 0B       ;
                      LDA.W !ClownCarImage                ;; 03DF9B : AD 27 14    ;
                      AND.W #$0003                        ;; 03DF9E : 29 03 00    ;
                      ASL A                               ;; 03DFA1 : 0A          ;
                      TAY                                 ;; 03DFA2 : A8          ;
                      LDA.W DATA_03DED7,Y                 ;; 03DFA3 : B9 D7 DE    ;
CODE_03DFA6:          DEX                                 ;; 03DFA6 : CA          ;
                      BPL CODE_03DF55                     ;; 03DFA7 : 10 AC       ;
                      SEP #$30                            ;; 03DFA9 : E2 30       ; Index (8 bit) Accum (8 bit) 
                      PLX                                 ;; 03DFAB : FA          ;
                      PLB                                 ;; 03DFAC : AB          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
CODE_03DFAE:          PHX                                 ;; 03DFAE : DA          ;
                      TYX                                 ;; 03DFAF : BB          ;
                      REP #$20                            ;; 03DFB0 : C2 20       ; Accum (16 bit) 
                      EOR.W #$FFFF                        ;; 03DFB2 : 49 FF FF    ;
                      INC A                               ;; 03DFB5 : 1A          ;
                      CLC                                 ;; 03DFB6 : 18          ;
                      ADC.L DATA_03DEBB,X                 ;; 03DFB7 : 7F BB DE 03 ;
                      CLC                                 ;; 03DFBB : 18          ;
                      ADC.B !Layer1XPos,X                 ;; 03DFBC : 75 1A       ;
                      STA.B !Mode7XPos,X                  ;; 03DFBE : 95 3A       ;
                      SEP #$20                            ;; 03DFC0 : E2 20       ; Accum (8 bit) 
                      PLX                                 ;; 03DFC2 : FA          ;
                      RTS                                 ;; ?QPWZ? : 60          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
DATA_03DFC4:          db $00,$0E,$1C,$2A,$38,$46,$54,$62  ;; 03DFC4               ;
                                                          ;;                      ;
CODE_03DFCC:          PHX                                 ;; 03DFCC : DA          ;
                      LDX.W !DynPaletteIndex              ;; 03DFCD : AE 81 06    ;
                      LDA.B #$10                          ;; 03DFD0 : A9 10       ;
                      STA.W !DynPaletteTable,X            ;; 03DFD2 : 9D 82 06    ;
                      STZ.W !DynPaletteTable+1,X          ;; 03DFD5 : 9E 83 06    ;
                      STZ.W !DynPaletteTable+2,X          ;; 03DFD8 : 9E 84 06    ;
                      STZ.W !DynPaletteTable+3,X          ;; 03DFDB : 9E 85 06    ;
                      TXY                                 ;; 03DFDE : 9B          ;
                      LDX.W !LightningFlashIndex          ;; 03DFDF : AE FB 1F    ;
                      BNE CODE_03E01B                     ;; 03DFE2 : D0 37       ;
                      LDA.W !FinalCutscene                ;; 03DFE4 : AD 0D 19    ;
                      BEQ CODE_03DFF0                     ;; 03DFE7 : F0 07       ;
                      REP #$20                            ;; 03DFE9 : C2 20       ; Accum (16 bit) 
                      LDA.W !BackgroundColor              ;; 03DFEB : AD 01 07    ;
                      BRA CODE_03E031                     ;; 03DFEE : 80 41       ;
                                                          ;;                      ;
CODE_03DFF0:          LDA.B !EffFrame                     ;; 03DFF0 : A5 14       ; Accum (8 bit) 
                      LSR A                               ;; 03DFF2 : 4A          ;
                      BCC CODE_03E036                     ;; 03DFF3 : 90 41       ;
                      DEC.W !LightningWaitTimer           ;; 03DFF5 : CE FC 1F    ;
                      BNE CODE_03E036                     ;; 03DFF8 : D0 3C       ;
                      TAX                                 ;; 03DFFA : AA          ;
                      LDA.L CODE_04F708,X                 ;; 03DFFB : BF 08 F7 04 ;
                      AND.B #$07                          ;; 03DFFF : 29 07       ;
                      TAX                                 ;; 03E001 : AA          ;
                      LDA.L DATA_04F6F8,X                 ;; 03E002 : BF F8 F6 04 ;
                      STA.W !LightningWaitTimer           ;; 03E006 : 8D FC 1F    ;
                      LDA.L DATA_04F700,X                 ;; 03E009 : BF 00 F7 04 ;
                      STA.W !LightningFlashIndex          ;; 03E00D : 8D FB 1F    ;
                      TAX                                 ;; 03E010 : AA          ;
                      LDA.B #$08                          ;; 03E011 : A9 08       ;
                      STA.W !LightningTimer               ;; 03E013 : 8D FD 1F    ;
                      LDA.B #$18                          ;; 03E016 : A9 18       ;
                      STA.W !SPCIO3                       ;; 03E018 : 8D FC 1D    ; / Play sound effect 
CODE_03E01B:          DEC.W !LightningTimer               ;; 03E01B : CE FD 1F    ;
                      BPL CODE_03E028                     ;; 03E01E : 10 08       ;
                      DEC.W !LightningFlashIndex          ;; 03E020 : CE FB 1F    ;
                      LDA.B #$04                          ;; 03E023 : A9 04       ;
                      STA.W !LightningTimer               ;; 03E025 : 8D FD 1F    ;
CODE_03E028:          TXA                                 ;; 03E028 : 8A          ;
                      ASL A                               ;; 03E029 : 0A          ;
                      TAX                                 ;; 03E02A : AA          ;
                      REP #$20                            ;; 03E02B : C2 20       ; Accum (16 bit) 
                      LDA.L DATA_00B5DE,X                 ;; 03E02D : BF DE B5 00 ;
CODE_03E031:          STA.W !DynPaletteTable+2,Y          ;; 03E031 : 99 84 06    ;
                      SEP #$20                            ;; 03E034 : E2 20       ; Accum (8 bit) 
CODE_03E036:          LDX.W !BowserPalette                ;; 03E036 : AE 29 14    ;
                      LDA.L DATA_03DFC4,X                 ;; 03E039 : BF C4 DF 03 ;
                      TAX                                 ;; 03E03D : AA          ;
                      LDA.B #$0E                          ;; 03E03E : A9 0E       ;
                      STA.B !_0                           ;; 03E040 : 85 00       ;
CODE_03E042:          LDA.L DATA_00B69E,X                 ;; 03E042 : BF 9E B6 00 ;
                      STA.W !DynPaletteTable+4,Y          ;; 03E046 : 99 86 06    ;
                      INX                                 ;; 03E049 : E8          ;
                      INY                                 ;; 03E04A : C8          ;
                      DEC.B !_0                           ;; 03E04B : C6 00       ;
                      BNE CODE_03E042                     ;; 03E04D : D0 F3       ;
                      TYX                                 ;; 03E04F : BB          ;
                      STZ.W !DynPaletteTable+4,X          ;; 03E050 : 9E 86 06    ;
                      INX                                 ;; 03E053 : E8          ;
                      INX                                 ;; 03E054 : E8          ;
                      INX                                 ;; 03E055 : E8          ;
                      INX                                 ;; 03E056 : E8          ;
                      STX.W !DynPaletteIndex              ;; 03E057 : 8E 81 06    ;
                      PLX                                 ;; 03E05A : FA          ;
                      RTL                                 ;; ?QPWZ? : 6B          ; Return 
                                                          ;;                      ;
                                                          ;;                      ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; 03E05C               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF                  ;; ?QPWZ?               ;
                                                          ;;                      ;
                      DEC.B !Powerup                      ;; 03E400 : C6 19       ; \ Unreachable 
                      RTS                                 ;; ?QPWZ? : 60          ; / Decrease Mario's Status 
                                                          ;;                      ;
                                                          ;;                      ;
                      db $13,$78,$13,$BE,$14,$F2,$14,$1C  ;; 03E403               ;
                      db $16,$78,$13,$BE,$14,$F2,$14,$1C  ;; ?QPWZ?               ;
                      db $16,$78,$13,$BE,$14,$F2,$14,$1C  ;; ?QPWZ?               ;
                      db $16,$9E,$13,$AE,$13,$BE,$13,$DE  ;; ?QPWZ?               ;
                      db $13,$CE,$13,$EE,$13,$FE,$13,$0E  ;; ?QPWZ?               ;
                      db $14,$1E,$14,$2E,$14,$3E,$14,$4E  ;; ?QPWZ?               ;
                      db $14,$5E,$14,$6E,$14,$7E,$14,$8E  ;; ?QPWZ?               ;
                      db $14,$9E,$14,$AE,$14,$00,$00,$94  ;; ?QPWZ?               ;
                      db $21,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$97  ;; ?QPWZ?               ;
                      db $21,$BB,$21,$51,$22,$F7,$21,$33  ;; ?QPWZ?               ;
                      db $22,$15,$22,$D9,$21,$73,$22,$92  ;; ?QPWZ?               ;
                      db $22,$B4,$23,$E2,$23,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$CC,$23,$0F,$24,$C9  ;; ?QPWZ?               ;
                      db $22,$B4,$23,$E2,$23,$00,$23,$00  ;; ?QPWZ?               ;
                      db $00,$1A,$23,$CC,$23,$0F,$24,$44  ;; ?QPWZ?               ;
                      db $24,$6B,$24,$AF,$24,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$8E,$24,$DF,$24,$35  ;; ?QPWZ?               ;
                      db $25,$6E,$25,$B2,$25,$5C,$25,$00  ;; ?QPWZ?               ;
                      db $00,$0F,$25,$91,$25,$E2,$25,$12  ;; ?QPWZ?               ;
                      db $26,$8D,$26,$B1,$26,$61,$26,$00  ;; ?QPWZ?               ;
                      db $00,$3A,$26,$A0,$26,$E1,$26,$11  ;; ?QPWZ?               ;
                      db $27,$7E,$27,$A8,$27,$54,$27,$00  ;; ?QPWZ?               ;
                      db $00,$33,$27,$94,$27,$0F,$24,$D1  ;; ?QPWZ?               ;
                      db $22,$B4,$23,$E2,$23,$00,$23,$7E  ;; ?QPWZ?               ;
                      db $23,$50,$23,$CC,$23,$0F,$24,$14  ;; ?QPWZ?               ;
                      db $28,$54,$28,$80,$28,$4C,$28,$2C  ;; ?QPWZ?               ;
                      db $28,$FD,$27,$6B,$28,$A4,$28,$C8  ;; ?QPWZ?               ;
                      db $28,$E7,$28,$7D,$29,$23,$29,$5F  ;; ?QPWZ?               ;
                      db $29,$41,$29,$05,$29,$9F,$29,$D1  ;; ?QPWZ?               ;
                      db $22,$BE,$29,$E2,$23,$00,$23,$7E  ;; ?QPWZ?               ;
                      db $23,$50,$23,$CC,$23,$0F,$24,$14  ;; ?QPWZ?               ;
                      db $28,$F5,$29,$0D,$2A,$4C,$28,$2C  ;; ?QPWZ?               ;
                      db $28,$FD,$27,$6B,$28,$A4,$28,$47  ;; ?QPWZ?               ;
                      db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0  ;; ?QPWZ?               ;
                      db $2A,$C0,$2A,$84,$2A,$24,$2B,$79  ;; ?QPWZ?               ;
                      db $2B,$43,$2B,$E2,$23,$00,$23,$E2  ;; ?QPWZ?               ;
                      db $2B,$AE,$2B,$CC,$23,$0F,$24,$47  ;; ?QPWZ?               ;
                      db $2C,$18,$2C,$0D,$2A,$4C,$28,$5F  ;; ?QPWZ?               ;
                      db $2C,$30,$2C,$6B,$28,$A4,$28,$25  ;; ?QPWZ?               ;
                      db $2A,$66,$2A,$00,$2B,$A2,$2A,$E0  ;; ?QPWZ?               ;
                      db $2A,$C0,$2A,$84,$2A,$24,$2B,$7F  ;; ?QPWZ?               ;
                      db $2C,$98,$2C,$0C,$2D,$C8,$2C,$F6  ;; ?QPWZ?               ;
                      db $2C,$E0,$2C,$B0,$2C,$00,$00,$C2  ;; ?QPWZ?               ;
                      db $14,$00,$00,$76,$1E,$C5,$1E,$F0  ;; ?QPWZ?               ;
                      db $1E,$A2,$1E,$03,$1F,$2A,$1F,$49  ;; ?QPWZ?               ;
                      db $1F,$68,$1F,$A4,$1F,$0A,$20,$4C  ;; ?QPWZ?               ;
                      db $20,$E9,$1F,$C8,$1F,$83,$1F,$2C  ;; ?QPWZ?               ;
                      db $20,$7B,$20,$A6,$20,$C8,$20,$5A  ;; ?QPWZ?               ;
                      db $21,$04,$21,$3E,$21,$22,$21,$E6  ;; ?QPWZ?               ;
                      db $20,$7A,$21,$D2,$14,$E2,$14,$2C  ;; ?QPWZ?               ;
                      db $15,$4C,$15,$3C,$15,$5C,$15,$6C  ;; ?QPWZ?               ;
                      db $15,$7C,$15,$8C,$15,$9C,$15,$AC  ;; ?QPWZ?               ;
                      db $15,$CC,$15,$BC,$15,$DC,$15,$EC  ;; ?QPWZ?               ;
                      db $15,$AE,$13,$4E,$14,$5E,$14,$6E  ;; ?QPWZ?               ;
                      db $14,$7E,$14,$8E,$14,$6E,$14,$FC  ;; ?QPWZ?               ;
                      db $15,$6E,$14,$7E,$14,$8E,$14,$9E  ;; ?QPWZ?               ;
                      db $14,$0C,$16,$00,$00,$3D,$16,$93  ;; ?QPWZ?               ;
                      db $17,$BD,$17,$1B,$17,$57,$17,$99  ;; ?QPWZ?               ;
                      db $16,$00,$00,$E7,$17,$3D,$16,$93  ;; ?QPWZ?               ;
                      db $17,$BD,$17,$1B,$17,$57,$17,$DE  ;; ?QPWZ?               ;
                      db $16,$00,$00,$E7,$17,$00,$18,$EF  ;; ?QPWZ?               ;
                      db $18,$10,$19,$89,$18,$BC,$18,$55  ;; ?QPWZ?               ;
                      db $18,$00,$00,$E7,$17,$31,$19,$E4  ;; ?QPWZ?               ;
                      db $19,$05,$1A,$8A,$19,$B7,$19,$5F  ;; ?QPWZ?               ;
                      db $19,$00,$00,$E7,$17,$C8,$1A,$AB  ;; ?QPWZ?               ;
                      db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91  ;; ?QPWZ?               ;
                      db $1B,$00,$00,$E7,$17,$ED,$1B,$6E  ;; ?QPWZ?               ;
                      db $1C,$8F,$1C,$1B,$1C,$48,$1C,$5B  ;; ?QPWZ?               ;
                      db $1C,$00,$00,$E7,$17,$C8,$1A,$AB  ;; ?QPWZ?               ;
                      db $1B,$CC,$1B,$3F,$1B,$77,$1B,$91  ;; ?QPWZ?               ;
                      db $1B,$01,$1B,$E7,$17,$B0,$1C,$70  ;; ?QPWZ?               ;
                      db $1D,$90,$1D,$19,$1D,$4A,$1D,$5D  ;; ?QPWZ?               ;
                      db $1D,$E2,$1C,$AE,$1D,$3D,$16,$93  ;; ?QPWZ?               ;
                      db $17,$BD,$17,$1B,$17,$57,$17,$99  ;; ?QPWZ?               ;
                      db $16,$7C,$16,$E7,$17,$3D,$16,$93  ;; ?QPWZ?               ;
                      db $17,$BD,$17,$1B,$17,$57,$17,$DE  ;; ?QPWZ?               ;
                      db $16,$7C,$16,$E7,$17,$00,$18,$EF  ;; ?QPWZ?               ;
                      db $18,$10,$19,$89,$18,$BC,$18,$55  ;; ?QPWZ?               ;
                      db $18,$34,$18,$E7,$17,$26,$1A,$A6  ;; ?QPWZ?               ;
                      db $1A,$B7,$1A,$4E,$1A,$67,$1A,$80  ;; ?QPWZ?               ;
                      db $1A,$40,$1A,$E7,$17,$32,$16,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$3A,$16,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$C1,$1D,$D4  ;; ?QPWZ?               ;
                      db $1D,$58,$1E,$F8,$1D,$3E,$1E,$0A  ;; ?QPWZ?               ;
                      db $1E,$E6,$1D,$24,$1E,$2C,$15,$4C  ;; ?QPWZ?               ;
                      db $15,$2C,$15,$5C,$15,$6C,$15,$7C  ;; ?QPWZ?               ;
                      db $15,$6C,$15,$9C,$15,$FF,$00,$1C  ;; ?QPWZ?               ;
                      db $16,$00,$00,$DA,$04,$E2,$16,$E3  ;; ?QPWZ?               ;
                      db $90,$1B,$00,$E4,$01,$00,$DA,$12  ;; ?QPWZ?               ;
                      db $E2,$1E,$DB,$0A,$DE,$14,$19,$27  ;; ?QPWZ?               ;
                      db $0C,$6D,$B4,$0C,$2E,$B7,$B9,$30  ;; ?QPWZ?               ;
                      db $6E,$B7,$0C,$2D,$B9,$0C,$6E,$BB  ;; ?QPWZ?               ;
                      db $C6,$0C,$2D,$BB,$30,$6E,$B9,$0C  ;; ?QPWZ?               ;
                      db $2D,$B3,$0C,$6E,$B4,$0C,$2D,$B7  ;; ?QPWZ?               ;
                      db $B9,$30,$6E,$B7,$0C,$2D,$B8,$0C  ;; ?QPWZ?               ;
                      db $6E,$B9,$C6,$0C,$2D,$B9,$30,$6E  ;; ?QPWZ?               ;
                      db $B7,$0C,$2D,$B8,$00,$DA,$12,$DB  ;; ?QPWZ?               ;
                      db $0F,$DE,$14,$14,$20,$48,$6D,$B7  ;; ?QPWZ?               ;
                      db $18,$B9,$48,$B7,$0C,$B4,$B5,$30  ;; ?QPWZ?               ;
                      db $B7,$0C,$C6,$B9,$B7,$B9,$48,$B7  ;; ?QPWZ?               ;
                      db $18,$B4,$DA,$00,$DB,$05,$DE,$14  ;; ?QPWZ?               ;
                      db $19,$27,$30,$6B,$C7,$0C,$C7,$B7  ;; ?QPWZ?               ;
                      db $0C,$2C,$B9,$BC,$06,$7B,$BB,$BC  ;; ?QPWZ?               ;
                      db $0C,$69,$BB,$18,$C6,$0C,$C7,$B3  ;; ?QPWZ?               ;
                      db $0C,$2C,$B7,$BB,$06,$7B,$B9,$BB  ;; ?QPWZ?               ;
                      db $0C,$69,$B9,$18,$C6,$0C,$C7,$B2  ;; ?QPWZ?               ;
                      db $0C,$2C,$B4,$B9,$06,$7B,$B7,$B9  ;; ?QPWZ?               ;
                      db $0C,$69,$B7,$18,$C6,$0C,$C7,$06  ;; ?QPWZ?               ;
                      db $4B,$AD,$AF,$B0,$B2,$B4,$B5,$30  ;; ?QPWZ?               ;
                      db $6B,$B4,$0C,$C7,$B7,$0C,$2C,$B9  ;; ?QPWZ?               ;
                      db $BC,$06,$7B,$BB,$BC,$0C,$69,$BB  ;; ?QPWZ?               ;
                      db $18,$C6,$0C,$C7,$B3,$0C,$2C,$B7  ;; ?QPWZ?               ;
                      db $BB,$06,$7B,$B9,$BB,$0C,$69,$B9  ;; ?QPWZ?               ;
                      db $18,$C6,$0C,$C7,$B2,$0C,$2C,$B4  ;; ?QPWZ?               ;
                      db $B9,$06,$7B,$B7,$B9,$0C,$69,$B7  ;; ?QPWZ?               ;
                      db $18,$C6,$0C,$C7,$06,$4B,$AD,$AF  ;; ?QPWZ?               ;
                      db $B0,$B2,$B4,$B5,$DA,$12,$DB,$08  ;; ?QPWZ?               ;
                      db $DE,$14,$1F,$25,$0C,$6D,$B0,$0C  ;; ?QPWZ?               ;
                      db $2E,$B4,$B4,$30,$6E,$B4,$0C,$2D  ;; ?QPWZ?               ;
                      db $B4,$0C,$6E,$B7,$C6,$0C,$2D,$B7  ;; ?QPWZ?               ;
                      db $30,$6E,$B3,$0C,$2D,$AF,$0C,$6E  ;; ?QPWZ?               ;
                      db $AE,$0C,$2D,$B2,$B2,$30,$6E,$B2  ;; ?QPWZ?               ;
                      db $0C,$2D,$B2,$0C,$6E,$B4,$C6,$0C  ;; ?QPWZ?               ;
                      db $2D,$B4,$30,$6E,$B4,$0C,$2D,$B4  ;; ?QPWZ?               ;
                      db $DA,$12,$DB,$0C,$DE,$14,$1B,$26  ;; ?QPWZ?               ;
                      db $0C,$6D,$AB,$0C,$2E,$B0,$B0,$30  ;; ?QPWZ?               ;
                      db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B3  ;; ?QPWZ?               ;
                      db $C6,$0C,$2D,$B3,$30,$6E,$AF,$0C  ;; ?QPWZ?               ;
                      db $2D,$AB,$0C,$6E,$AB,$0C,$2E,$AE  ;; ?QPWZ?               ;
                      db $AE,$30,$6E,$AE,$0C,$2D,$AE,$0C  ;; ?QPWZ?               ;
                      db $6E,$B1,$C6,$0C,$2D,$B1,$30,$6E  ;; ?QPWZ?               ;
                      db $B1,$0C,$2D,$B1,$DA,$04,$DB,$08  ;; ?QPWZ?               ;
                      db $DE,$14,$19,$28,$0C,$3B,$C7,$9C  ;; ?QPWZ?               ;
                      db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9B  ;; ?QPWZ?               ;
                      db $C7,$9B,$C7,$9B,$C7,$9B,$C7,$9A  ;; ?QPWZ?               ;
                      db $C7,$9A,$C7,$9A,$C7,$9A,$C7,$99  ;; ?QPWZ?               ;
                      db $C7,$99,$C7,$99,$C7,$99,$DA,$08  ;; ?QPWZ?               ;
                      db $DB,$0C,$DE,$14,$19,$28,$0C,$6E  ;; ?QPWZ?               ;
                      db $98,$9F,$93,$9F,$98,$9F,$93,$9F  ;; ?QPWZ?               ;
                      db $97,$9F,$93,$9F,$97,$9F,$93,$9F  ;; ?QPWZ?               ;
                      db $96,$9F,$93,$9F,$96,$9F,$93,$9F  ;; ?QPWZ?               ;
                      db $95,$9C,$90,$9C,$95,$9C,$90,$9C  ;; ?QPWZ?               ;
                      db $DA,$05,$DB,$14,$DE,$00,$00,$00  ;; ?QPWZ?               ;
                      db $E9,$F3,$17,$08,$0C,$4B,$D1,$0C  ;; ?QPWZ?               ;
                      db $4C,$D2,$0C,$49,$D1,$0C,$4B,$D2  ;; ?QPWZ?               ;
                      db $00,$0C,$6E,$B9,$0C,$2D,$BB,$BC  ;; ?QPWZ?               ;
                      db $30,$6E,$B9,$0C,$2D,$B8,$0C,$6E  ;; ?QPWZ?               ;
                      db $B7,$0C,$2D,$B8,$B9,$30,$6E,$B4  ;; ?QPWZ?               ;
                      db $0C,$C7,$12,$6E,$B4,$06,$6D,$B3  ;; ?QPWZ?               ;
                      db $0C,$2C,$B2,$12,$6E,$B4,$06,$6D  ;; ?QPWZ?               ;
                      db $B3,$0C,$2C,$B2,$0C,$2E,$B4,$B2  ;; ?QPWZ?               ;
                      db $30,$4E,$B7,$C6,$00,$30,$6D,$B0  ;; ?QPWZ?               ;
                      db $0C,$C6,$AF,$C6,$AD,$AB,$AC,$AD  ;; ?QPWZ?               ;
                      db $B4,$30,$C6,$24,$B4,$18,$B0,$0C  ;; ?QPWZ?               ;
                      db $AF,$B0,$B1,$30,$B2,$06,$C7,$AB  ;; ?QPWZ?               ;
                      db $AD,$AF,$B0,$B2,$B4,$B5,$06,$7B  ;; ?QPWZ?               ;
                      db $B4,$B5,$0C,$69,$B4,$18,$C6,$0C  ;; ?QPWZ?               ;
                      db $C7,$06,$4B,$AF,$B0,$B2,$B4,$B5  ;; ?QPWZ?               ;
                      db $B6,$06,$7B,$B7,$B9,$0C,$69,$B7  ;; ?QPWZ?               ;
                      db $18,$C6,$0C,$C7,$06,$4B,$B2,$B4  ;; ?QPWZ?               ;
                      db $B5,$B7,$B9,$BB,$30,$BC,$C6,$BB  ;; ?QPWZ?               ;
                      db $0C,$C7,$06,$4B,$BB,$BC,$BB,$B9  ;; ?QPWZ?               ;
                      db $B7,$B5,$0C,$6E,$B5,$0C,$2D,$B5  ;; ?QPWZ?               ;
                      db $B9,$30,$6E,$B6,$0C,$2D,$B6,$0C  ;; ?QPWZ?               ;
                      db $6E,$B4,$0C,$2D,$B4,$B4,$30,$6E  ;; ?QPWZ?               ;
                      db $B1,$0C,$C7,$12,$6E,$AD,$06,$6D  ;; ?QPWZ?               ;
                      db $AD,$0C,$2C,$AD,$12,$6E,$AD,$06  ;; ?QPWZ?               ;
                      db $6D,$AD,$0C,$2C,$AD,$0C,$2E,$AD  ;; ?QPWZ?               ;
                      db $AD,$30,$4E,$B2,$C6,$0C,$6E,$B0  ;; ?QPWZ?               ;
                      db $0C,$2D,$B0,$B5,$30,$6E,$B0,$0C  ;; ?QPWZ?               ;
                      db $2D,$B0,$0C,$6E,$B0,$0C,$2D,$B0  ;; ?QPWZ?               ;
                      db $B0,$30,$6E,$AB,$0C,$C7,$12,$6E  ;; ?QPWZ?               ;
                      db $A9,$06,$6D,$A9,$0C,$2C,$A9,$12  ;; ?QPWZ?               ;
                      db $6E,$A9,$06,$6D,$A9,$0C,$2C,$A9  ;; ?QPWZ?               ;
                      db $0C,$2E,$A9,$A9,$30,$4E,$AF,$C6  ;; ?QPWZ?               ;
                      db $0C,$C7,$9D,$C7,$9D,$C7,$9E,$C7  ;; ?QPWZ?               ;
                      db $9E,$C7,$9C,$C7,$9C,$C7,$99,$C7  ;; ?QPWZ?               ;
                      db $99,$C7,$9A,$C7,$9A,$C7,$9A,$C7  ;; ?QPWZ?               ;
                      db $9A,$C7,$97,$C7,$97,$C7,$97,$C7  ;; ?QPWZ?               ;
                      db $97,$0C,$91,$A1,$98,$A1,$92,$A1  ;; ?QPWZ?               ;
                      db $98,$A1,$93,$9F,$98,$9F,$95,$9F  ;; ?QPWZ?               ;
                      db $90,$9F,$8E,$9D,$95,$9D,$8E,$9D  ;; ?QPWZ?               ;
                      db $90,$91,$93,$9D,$8E,$9D,$93,$9D  ;; ?QPWZ?               ;
                      db $8E,$9D,$0C,$6E,$B9,$0C,$2D,$BB  ;; ?QPWZ?               ;
                      db $BC,$30,$6E,$B9,$0C,$2D,$B8,$0C  ;; ?QPWZ?               ;
                      db $6E,$B7,$0C,$2D,$B8,$B9,$30,$6E  ;; ?QPWZ?               ;
                      db $C0,$0C,$C7,$0C,$6E,$C0,$0C,$2D  ;; ?QPWZ?               ;
                      db $BF,$C0,$18,$6E,$BC,$0C,$2E,$BC  ;; ?QPWZ?               ;
                      db $18,$6E,$B9,$30,$4E,$BC,$C6,$00  ;; ?QPWZ?               ;
                      db $06,$7B,$B4,$B5,$0C,$69,$B4,$18  ;; ?QPWZ?               ;
                      db $C6,$0C,$C7,$06,$4B,$AF,$B0,$B2  ;; ?QPWZ?               ;
                      db $B4,$B5,$B6,$06,$7B,$B7,$B9,$0C  ;; ?QPWZ?               ;
                      db $69,$B7,$18,$C6,$0C,$C7,$06,$4B  ;; ?QPWZ?               ;
                      db $B2,$B4,$B5,$B7,$B9,$BB,$30,$BC  ;; ?QPWZ?               ;
                      db $BB,$60,$BC,$0C,$6E,$B5,$0C,$2D  ;; ?QPWZ?               ;
                      db $B5,$B9,$30,$6E,$B6,$0C,$2D,$B6  ;; ?QPWZ?               ;
                      db $0C,$6E,$B4,$0C,$2D,$B4,$B4,$30  ;; ?QPWZ?               ;
                      db $6E,$BD,$0C,$C7,$0C,$6E,$B9,$0C  ;; ?QPWZ?               ;
                      db $2D,$B9,$B9,$18,$6E,$B9,$0C,$2E  ;; ?QPWZ?               ;
                      db $B5,$18,$6E,$B5,$30,$4E,$B7,$C6  ;; ?QPWZ?               ;
                      db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30  ;; ?QPWZ?               ;
                      db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0  ;; ?QPWZ?               ;
                      db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C  ;; ?QPWZ?               ;
                      db $C7,$0C,$6E,$B5,$0C,$2D,$B5,$B5  ;; ?QPWZ?               ;
                      db $18,$6E,$B5,$0C,$2E,$B2,$18,$6E  ;; ?QPWZ?               ;
                      db $B2,$30,$4E,$B4,$C6,$0C,$C7,$98  ;; ?QPWZ?               ;
                      db $C7,$98,$C7,$98,$C7,$98,$C7,$9C  ;; ?QPWZ?               ;
                      db $C7,$9C,$C7,$99,$C7,$99,$C7,$95  ;; ?QPWZ?               ;
                      db $C7,$95,$C7,$97,$C7,$97,$C7,$9C  ;; ?QPWZ?               ;
                      db $C7,$9C,$C7,$9C,$C7,$9C,$0C,$91  ;; ?QPWZ?               ;
                      db $9D,$98,$9D,$92,$9E,$98,$9E,$93  ;; ?QPWZ?               ;
                      db $9F,$9A,$9F,$95,$A1,$9C,$A1,$8E  ;; ?QPWZ?               ;
                      db $9A,$95,$9A,$93,$9F,$9A,$9F,$98  ;; ?QPWZ?               ;
                      db $9F,$93,$9F,$98,$98,$97,$96,$0C  ;; ?QPWZ?               ;
                      db $6E,$B9,$0C,$2D,$BB,$BC,$30,$6E  ;; ?QPWZ?               ;
                      db $B9,$0C,$2D,$B8,$0C,$6E,$B7,$0C  ;; ?QPWZ?               ;
                      db $2D,$B8,$B9,$30,$6E,$C0,$0C,$C7  ;; ?QPWZ?               ;
                      db $00,$30,$6D,$B0,$0C,$C6,$AF,$C6  ;; ?QPWZ?               ;
                      db $AD,$AB,$AC,$AD,$B4,$30,$C6,$0C  ;; ?QPWZ?               ;
                      db $6E,$B5,$0C,$2D,$B5,$B9,$30,$6E  ;; ?QPWZ?               ;
                      db $B6,$0C,$2D,$B6,$0C,$6E,$B4,$0C  ;; ?QPWZ?               ;
                      db $2D,$B4,$B4,$30,$6E,$BD,$0C,$C7  ;; ?QPWZ?               ;
                      db $0C,$6E,$B0,$0C,$2D,$B0,$B5,$30  ;; ?QPWZ?               ;
                      db $6E,$B0,$0C,$2D,$B0,$0C,$6E,$B0  ;; ?QPWZ?               ;
                      db $0C,$2D,$B0,$B0,$30,$6E,$B7,$0C  ;; ?QPWZ?               ;
                      db $C7,$06,$7B,$B4,$B5,$0C,$69,$B4  ;; ?QPWZ?               ;
                      db $18,$C6,$0C,$C7,$06,$4B,$AF,$B0  ;; ?QPWZ?               ;
                      db $B2,$B4,$B5,$B6,$06,$7B,$B7,$B9  ;; ?QPWZ?               ;
                      db $0C,$69,$B7,$18,$C6,$0C,$C7,$06  ;; ?QPWZ?               ;
                      db $4B,$B2,$B4,$B5,$B7,$B9,$BB,$0C  ;; ?QPWZ?               ;
                      db $C7,$98,$C7,$98,$C7,$98,$C7,$98  ;; ?QPWZ?               ;
                      db $C7,$9C,$C7,$9C,$C7,$99,$C7,$99  ;; ?QPWZ?               ;
                      db $0C,$91,$9D,$98,$9D,$92,$9E,$98  ;; ?QPWZ?               ;
                      db $9E,$93,$9F,$9A,$9F,$95,$A1,$9C  ;; ?QPWZ?               ;
                      db $A1,$DA,$12,$18,$6D,$AD,$0C,$B4  ;; ?QPWZ?               ;
                      db $C7,$C7,$0C,$2D,$B4,$0C,$6E,$B3  ;; ?QPWZ?               ;
                      db $0C,$2D,$B4,$0C,$6E,$B5,$0C,$2D  ;; ?QPWZ?               ;
                      db $B4,$B1,$30,$6E,$AD,$0C,$2D,$AD  ;; ?QPWZ?               ;
                      db $0C,$6E,$B4,$0C,$2D,$B2,$0C,$6D  ;; ?QPWZ?               ;
                      db $B4,$0C,$2D,$B2,$0C,$6E,$B4,$0C  ;; ?QPWZ?               ;
                      db $2D,$B2,$C7,$0C,$6D,$AD,$30,$C6  ;; ?QPWZ?               ;
                      db $C7,$00,$DB,$0F,$DE,$14,$14,$20  ;; ?QPWZ?               ;
                      db $DA,$12,$18,$6D,$B9,$0C,$C0,$C7  ;; ?QPWZ?               ;
                      db $C7,$0C,$2D,$C0,$0C,$6E,$BF,$0C  ;; ?QPWZ?               ;
                      db $2D,$C0,$0C,$6E,$C1,$0C,$2D,$C0  ;; ?QPWZ?               ;
                      db $BD,$30,$6E,$B9,$0C,$2D,$B9,$0C  ;; ?QPWZ?               ;
                      db $6E,$C0,$0C,$2D,$BE,$0C,$6D,$C0  ;; ?QPWZ?               ;
                      db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D  ;; ?QPWZ?               ;
                      db $BE,$C7,$0C,$6D,$B9,$30,$C6,$C7  ;; ?QPWZ?               ;
                      db $DA,$12,$18,$6D,$A8,$0C,$AB,$C7  ;; ?QPWZ?               ;
                      db $C7,$0C,$2D,$AB,$0C,$6E,$AA,$0C  ;; ?QPWZ?               ;
                      db $2D,$AB,$0C,$6E,$AD,$0C,$2D,$AB  ;; ?QPWZ?               ;
                      db $A8,$30,$6E,$A5,$0C,$2D,$A5,$0C  ;; ?QPWZ?               ;
                      db $6E,$AB,$0C,$2D,$AA,$0C,$6D,$AB  ;; ?QPWZ?               ;
                      db $0C,$2D,$AA,$0C,$6E,$AB,$0C,$2D  ;; ?QPWZ?               ;
                      db $AA,$C7,$0C,$6D,$A4,$30,$C6,$C7  ;; ?QPWZ?               ;
                      db $DB,$05,$DE,$19,$19,$35,$DA,$00  ;; ?QPWZ?               ;
                      db $30,$6B,$A8,$0C,$C6,$A7,$A8,$AD  ;; ?QPWZ?               ;
                      db $48,$B4,$0C,$B3,$B4,$30,$B9,$B4  ;; ?QPWZ?               ;
                      db $60,$B2,$DB,$08,$DE,$19,$18,$34  ;; ?QPWZ?               ;
                      db $DA,$00,$30,$6B,$9F,$0C,$C6,$9E  ;; ?QPWZ?               ;
                      db $9F,$A5,$48,$AB,$0C,$AA,$AB,$30  ;; ?QPWZ?               ;
                      db $B4,$AB,$60,$AA,$0C,$C7,$99,$C7  ;; ?QPWZ?               ;
                      db $99,$C7,$99,$C7,$99,$C7,$99,$C7  ;; ?QPWZ?               ;
                      db $99,$C7,$99,$C7,$99,$C7,$98,$C7  ;; ?QPWZ?               ;
                      db $98,$C7,$98,$C7,$98,$C7,$98,$C7  ;; ?QPWZ?               ;
                      db $98,$C7,$98,$C7,$98,$0C,$95,$9F  ;; ?QPWZ?               ;
                      db $90,$9F,$95,$9F,$90,$9F,$95,$9F  ;; ?QPWZ?               ;
                      db $90,$9F,$95,$9F,$90,$8F,$8E,$9E  ;; ?QPWZ?               ;
                      db $95,$9E,$8E,$9E,$95,$9E,$8E,$9E  ;; ?QPWZ?               ;
                      db $95,$9E,$8E,$9E,$90,$92,$18,$6D  ;; ?QPWZ?               ;
                      db $AB,$0C,$B2,$C7,$C7,$0C,$2D,$B2  ;; ?QPWZ?               ;
                      db $0C,$6E,$B1,$0C,$2D,$B2,$0C,$6E  ;; ?QPWZ?               ;
                      db $B4,$0C,$2D,$B2,$AF,$30,$6E,$AB  ;; ?QPWZ?               ;
                      db $0C,$2D,$B2,$18,$4E,$B0,$B0,$10  ;; ?QPWZ?               ;
                      db $6D,$B0,$10,$6E,$B2,$10,$6E,$B3  ;; ?QPWZ?               ;
                      db $30,$B4,$C7,$00,$18,$6D,$A3,$0C  ;; ?QPWZ?               ;
                      db $A9,$C7,$C7,$0C,$2D,$A9,$0C,$6E  ;; ?QPWZ?               ;
                      db $A8,$0C,$2D,$A9,$0C,$6E,$AB,$0C  ;; ?QPWZ?               ;
                      db $2D,$A9,$A6,$30,$6E,$A3,$0C,$2D  ;; ?QPWZ?               ;
                      db $A9,$18,$4E,$A8,$A8,$10,$6D,$A8  ;; ?QPWZ?               ;
                      db $10,$6E,$A9,$10,$6E,$AA,$30,$AC  ;; ?QPWZ?               ;
                      db $C7,$30,$69,$AB,$0C,$C6,$A9,$AB  ;; ?QPWZ?               ;
                      db $AF,$48,$B2,$0C,$B0,$B2,$48,$B0  ;; ?QPWZ?               ;
                      db $18,$B2,$60,$B4,$30,$69,$A3,$0C  ;; ?QPWZ?               ;
                      db $C6,$A3,$A6,$A9,$48,$AB,$0C,$A9  ;; ?QPWZ?               ;
                      db $AB,$48,$A8,$18,$AB,$60,$AC,$0C  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$97,$C7,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$97,$C7,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $C7,$9C,$C7,$9C,$C7,$9C,$C7,$9C  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$97,$C7,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $0C,$93,$9D,$8E,$9D,$93,$9D,$8E  ;; ?QPWZ?               ;
                      db $9D,$93,$9D,$8E,$9D,$93,$9D,$95  ;; ?QPWZ?               ;
                      db $97,$98,$9F,$93,$9F,$98,$9F,$93  ;; ?QPWZ?               ;
                      db $9F,$90,$A0,$97,$A0,$90,$A0,$92  ;; ?QPWZ?               ;
                      db $94,$18,$6D,$AB,$0C,$B2,$C7,$C7  ;; ?QPWZ?               ;
                      db $0C,$2D,$B2,$0C,$6E,$B1,$0C,$2D  ;; ?QPWZ?               ;
                      db $B2,$0C,$6E,$B4,$0C,$2D,$B2,$C7  ;; ?QPWZ?               ;
                      db $30,$6E,$AB,$0C,$2D,$B2,$18,$4E  ;; ?QPWZ?               ;
                      db $B0,$B0,$10,$6D,$B0,$10,$6E,$B2  ;; ?QPWZ?               ;
                      db $10,$6E,$B3,$18,$2E,$B4,$C7,$30  ;; ?QPWZ?               ;
                      db $4E,$B7,$00,$18,$6D,$B7,$0C,$BE  ;; ?QPWZ?               ;
                      db $C7,$C7,$0C,$2D,$BE,$0C,$6E,$BD  ;; ?QPWZ?               ;
                      db $0C,$2D,$BE,$0C,$6E,$C0,$0C,$2D  ;; ?QPWZ?               ;
                      db $BE,$C7,$30,$6E,$B7,$0C,$2D,$BE  ;; ?QPWZ?               ;
                      db $18,$4E,$BC,$BC,$10,$6D,$BC,$10  ;; ?QPWZ?               ;
                      db $6E,$BE,$10,$6E,$BF,$18,$2E,$C0  ;; ?QPWZ?               ;
                      db $C7,$06,$C7,$AB,$AD,$AF,$B0,$B2  ;; ?QPWZ?               ;
                      db $B4,$B5,$18,$6D,$A3,$0C,$A9,$C7  ;; ?QPWZ?               ;
                      db $C7,$0C,$2D,$A9,$0C,$6E,$A8,$0C  ;; ?QPWZ?               ;
                      db $2D,$A9,$0C,$6E,$AB,$0C,$2D,$A9  ;; ?QPWZ?               ;
                      db $C7,$30,$6E,$A3,$0C,$2D,$A9,$18  ;; ?QPWZ?               ;
                      db $4E,$A8,$A8,$10,$6D,$A8,$10,$6E  ;; ?QPWZ?               ;
                      db $A9,$10,$6E,$AA,$18,$2E,$AB,$C7  ;; ?QPWZ?               ;
                      db $30,$4E,$AF,$30,$69,$AB,$0C,$C6  ;; ?QPWZ?               ;
                      db $A9,$AB,$AF,$48,$B2,$0C,$B0,$B2  ;; ?QPWZ?               ;
                      db $30,$B0,$B2,$30,$B4,$B3,$30,$69  ;; ?QPWZ?               ;
                      db $A3,$0C,$C6,$A3,$A6,$A9,$48,$AB  ;; ?QPWZ?               ;
                      db $0C,$A9,$AB,$30,$A8,$AB,$30,$AB  ;; ?QPWZ?               ;
                      db $AF,$0C,$C7,$97,$C7,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$97,$C7,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$9C,$C7,$9C,$C7,$9C  ;; ?QPWZ?               ;
                      db $C7,$9C,$DA,$01,$18,$AF,$C7,$A7  ;; ?QPWZ?               ;
                      db $C6,$0C,$93,$9D,$8E,$9D,$93,$9D  ;; ?QPWZ?               ;
                      db $8E,$9D,$93,$9D,$8E,$9D,$93,$9D  ;; ?QPWZ?               ;
                      db $95,$97,$98,$9F,$93,$9F,$98,$9F  ;; ?QPWZ?               ;
                      db $93,$9F,$18,$8C,$C7,$93,$C6,$DA  ;; ?QPWZ?               ;
                      db $05,$DB,$14,$DE,$00,$00,$00,$E9  ;; ?QPWZ?               ;
                      db $F3,$17,$06,$18,$4C,$D1,$C7,$30  ;; ?QPWZ?               ;
                      db $6D,$D2,$DA,$04,$DB,$0A,$DE,$22  ;; ?QPWZ?               ;
                      db $19,$38,$60,$5E,$BC,$C6,$DA,$01  ;; ?QPWZ?               ;
                      db $60,$C6,$C6,$C6,$00,$DA,$04,$DB  ;; ?QPWZ?               ;
                      db $08,$DE,$20,$18,$36,$60,$5D,$B4  ;; ?QPWZ?               ;
                      db $C6,$DA,$01,$60,$C6,$C6,$C6,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0C,$DE,$21,$1A,$37,$60  ;; ?QPWZ?               ;
                      db $5D,$AB,$C6,$DA,$01,$60,$C6,$C6  ;; ?QPWZ?               ;
                      db $C6,$DA,$04,$DB,$0A,$DE,$22,$18  ;; ?QPWZ?               ;
                      db $36,$60,$5D,$A4,$C6,$DA,$01,$60  ;; ?QPWZ?               ;
                      db $C6,$C6,$C6,$DA,$04,$DB,$0F,$10  ;; ?QPWZ?               ;
                      db $5D,$B0,$C7,$B0,$AE,$C7,$AE,$AD  ;; ?QPWZ?               ;
                      db $C7,$AD,$AC,$C7,$AC,$30,$AB,$24  ;; ?QPWZ?               ;
                      db $A7,$6C,$A6,$60,$C6,$DA,$04,$DB  ;; ?QPWZ?               ;
                      db $0F,$10,$5D,$AB,$C7,$AB,$A8,$C7  ;; ?QPWZ?               ;
                      db $A8,$A9,$C7,$A9,$A9,$C7,$A9,$30  ;; ?QPWZ?               ;
                      db $A6,$24,$A3,$6C,$A2,$60,$C6,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0F,$10,$5D,$A8,$C7,$A8  ;; ?QPWZ?               ;
                      db $A4,$C7,$A4,$A4,$C7,$A4,$A4,$C7  ;; ?QPWZ?               ;
                      db $A4,$30,$A3,$24,$9D,$6C,$9C,$60  ;; ?QPWZ?               ;
                      db $C6,$DA,$08,$DB,$0A,$DE,$22,$19  ;; ?QPWZ?               ;
                      db $38,$10,$5D,$8C,$8C,$8C,$90,$90  ;; ?QPWZ?               ;
                      db $90,$91,$91,$91,$92,$92,$92,$30  ;; ?QPWZ?               ;
                      db $93,$24,$93,$6C,$8C,$60,$C6,$DA  ;; ?QPWZ?               ;
                      db $01,$E2,$12,$DB,$0A,$DE,$14,$19  ;; ?QPWZ?               ;
                      db $28,$18,$7C,$A7,$0C,$A8,$AB,$AD  ;; ?QPWZ?               ;
                      db $30,$AB,$0C,$AD,$AF,$C6,$AF,$30  ;; ?QPWZ?               ;
                      db $AD,$0C,$A7,$A8,$AB,$AD,$30,$AB  ;; ?QPWZ?               ;
                      db $0C,$AC,$AD,$C6,$AD,$60,$AB,$60  ;; ?QPWZ?               ;
                      db $77,$C6,$00,$DA,$02,$DB,$0A,$18  ;; ?QPWZ?               ;
                      db $79,$A7,$0C,$A8,$AB,$AD,$30,$AB  ;; ?QPWZ?               ;
                      db $0C,$AD,$AF,$C6,$AF,$30,$AD,$0C  ;; ?QPWZ?               ;
                      db $A7,$A8,$AB,$AD,$30,$AB,$0C,$AC  ;; ?QPWZ?               ;
                      db $AD,$C6,$AD,$60,$AB,$C6,$DA,$01  ;; ?QPWZ?               ;
                      db $DB,$0C,$DE,$14,$19,$28,$06,$C6  ;; ?QPWZ?               ;
                      db $18,$79,$A7,$0C,$A8,$AB,$AD,$30  ;; ?QPWZ?               ;
                      db $AB,$0C,$AD,$AF,$C6,$AF,$30,$AD  ;; ?QPWZ?               ;
                      db $0C,$A7,$A8,$AB,$AD,$30,$AB,$0C  ;; ?QPWZ?               ;
                      db $AC,$AD,$C6,$AD,$60,$AB,$60,$75  ;; ?QPWZ?               ;
                      db $C6,$DA,$01,$DB,$0A,$DE,$14,$19  ;; ?QPWZ?               ;
                      db $28,$18,$7B,$C7,$60,$98,$97,$96  ;; ?QPWZ?               ;
                      db $95,$C6,$C6,$C6,$DA,$01,$DB,$0A  ;; ?QPWZ?               ;
                      db $DE,$14,$19,$28,$18,$7B,$C7,$0C  ;; ?QPWZ?               ;
                      db $C7,$24,$9F,$30,$B0,$0C,$C7,$24  ;; ?QPWZ?               ;
                      db $9F,$30,$AF,$0C,$C7,$24,$9F,$30  ;; ?QPWZ?               ;
                      db $AE,$0C,$C7,$24,$9F,$30,$B1,$60  ;; ?QPWZ?               ;
                      db $C6,$C6,$C6,$DA,$01,$DB,$0A,$DE  ;; ?QPWZ?               ;
                      db $14,$19,$28,$18,$7B,$C7,$18,$C7  ;; ?QPWZ?               ;
                      db $48,$A8,$18,$C7,$48,$A7,$18,$C7  ;; ?QPWZ?               ;
                      db $48,$A6,$18,$C7,$48,$A5,$60,$C6  ;; ?QPWZ?               ;
                      db $C6,$C6,$DA,$01,$DB,$0A,$DE,$14  ;; ?QPWZ?               ;
                      db $19,$28,$18,$7B,$C7,$24,$C7,$3C  ;; ?QPWZ?               ;
                      db $AB,$24,$C7,$3C,$AB,$24,$C7,$3C  ;; ?QPWZ?               ;
                      db $AB,$24,$C7,$3C,$AB,$60,$C6,$C6  ;; ?QPWZ?               ;
                      db $C6,$DA,$01,$DB,$0A,$DE,$14,$19  ;; ?QPWZ?               ;
                      db $28,$18,$7B,$C7,$30,$C7,$B4,$30  ;; ?QPWZ?               ;
                      db $C7,$B3,$30,$C7,$B2,$30,$C7,$B4  ;; ?QPWZ?               ;
                      db $60,$C6,$C6,$C6,$DA,$04,$DB,$08  ;; ?QPWZ?               ;
                      db $DE,$22,$18,$14,$08,$5C,$C7,$A9  ;; ?QPWZ?               ;
                      db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24  ;; ?QPWZ?               ;
                      db $AB,$0C,$C7,$08,$C7,$E2,$1C,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0A,$DE,$22,$18,$14,$08  ;; ?QPWZ?               ;
                      db $5D,$AC,$AD,$C7,$AF,$B0,$C7,$24  ;; ?QPWZ?               ;
                      db $AD,$0C,$C7,$08,$AC,$AB,$C7,$AC  ;; ?QPWZ?               ;
                      db $AD,$C7,$24,$B4,$0C,$C7,$08,$C7  ;; ?QPWZ?               ;
                      db $00,$DA,$04,$DB,$0C,$DE,$22,$18  ;; ?QPWZ?               ;
                      db $14,$08,$5C,$C7,$A4,$C7,$A4,$A9  ;; ?QPWZ?               ;
                      db $C7,$24,$A4,$0C,$C7,$08,$A4,$A4  ;; ?QPWZ?               ;
                      db $C7,$A4,$A4,$C7,$24,$A5,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$C7,$DA,$06,$DB,$0A,$DE,$22  ;; ?QPWZ?               ;
                      db $18,$14,$08,$5D,$B8,$B9,$C7,$BB  ;; ?QPWZ?               ;
                      db $BC,$C7,$24,$B9,$0C,$C7,$08,$B8  ;; ?QPWZ?               ;
                      db $B7,$C7,$B8,$B9,$C7,$24,$C0,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$C7,$DA,$0D,$DB,$0F,$DE  ;; ?QPWZ?               ;
                      db $22,$18,$14,$01,$C7,$08,$C7,$18  ;; ?QPWZ?               ;
                      db $4E,$C7,$9D,$C7,$9E,$C7,$9F,$C7  ;; ?QPWZ?               ;
                      db $9F,$18,$9E,$08,$C7,$C7,$9D,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$C7,$C7,$AB,$DA,$0D,$DB  ;; ?QPWZ?               ;
                      db $0F,$DE,$22,$18,$14,$08,$C7,$18  ;; ?QPWZ?               ;
                      db $4E,$C7,$98,$C7,$98,$C7,$9A,$C7  ;; ?QPWZ?               ;
                      db $99,$18,$A1,$08,$C7,$C7,$A3,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$C7,$C7,$A4,$DA,$08,$DB  ;; ?QPWZ?               ;
                      db $0A,$DE,$22,$18,$14,$08,$C7,$18  ;; ?QPWZ?               ;
                      db $5F,$91,$08,$C7,$C7,$91,$18,$92  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$92,$18,$93,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$93,$18,$95,$08,$95,$90,$8F  ;; ?QPWZ?               ;
                      db $18,$8E,$08,$C6,$C7,$93,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$98,$DA,$04,$DB,$14  ;; ?QPWZ?               ;
                      db $08,$C7,$18,$6C,$D1,$08,$D2,$C7  ;; ?QPWZ?               ;
                      db $D1,$18,$D1,$08,$D2,$C7,$D1,$18  ;; ?QPWZ?               ;
                      db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1  ;; ?QPWZ?               ;
                      db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7  ;; ?QPWZ?               ;
                      db $D2,$18,$C6,$08,$C7,$C7,$D2,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0A,$DE,$22,$19,$38,$18  ;; ?QPWZ?               ;
                      db $4D,$B4,$08,$C7,$C7,$B4,$E3,$60  ;; ?QPWZ?               ;
                      db $18,$18,$B4,$08,$C7,$C7,$B7,$18  ;; ?QPWZ?               ;
                      db $B7,$08,$C7,$C7,$B7,$18,$B7,$C7  ;; ?QPWZ?               ;
                      db $00,$DA,$04,$DB,$08,$DE,$20,$18  ;; ?QPWZ?               ;
                      db $36,$18,$4D,$A4,$08,$C7,$C7,$A4  ;; ?QPWZ?               ;
                      db $18,$A4,$08,$C7,$C7,$A7,$18,$A7  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$A7,$18,$A7,$C7,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0C,$DE,$21,$1A,$37,$18  ;; ?QPWZ?               ;
                      db $4D,$AD,$08,$C7,$C7,$AD,$18,$AD  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$AF,$18,$AF,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$AF,$18,$AF,$C7,$DA,$04,$DB  ;; ?QPWZ?               ;
                      db $0A,$DE,$22,$18,$36,$18,$4D,$A9  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$A9,$18,$A9,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$AB,$18,$AB,$08,$C7,$C7,$AB  ;; ?QPWZ?               ;
                      db $18,$AB,$C7,$DA,$04,$DB,$0F,$08  ;; ?QPWZ?               ;
                      db $4D,$C7,$C7,$9A,$18,$9A,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$9A,$18,$9A,$08,$C7,$C7,$9F  ;; ?QPWZ?               ;
                      db $18,$9F,$18,$C7,$18,$7D,$9F,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$0F,$08,$4C,$C7,$C7,$8E  ;; ?QPWZ?               ;
                      db $18,$8E,$08,$C7,$C7,$8E,$18,$8E  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$93,$18,$93,$18,$C7  ;; ?QPWZ?               ;
                      db $18,$7E,$93,$DA,$08,$DB,$0A,$DE  ;; ?QPWZ?               ;
                      db $22,$19,$38,$08,$5F,$C7,$C7,$8E  ;; ?QPWZ?               ;
                      db $18,$8E,$08,$C7,$C7,$8E,$18,$8E  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$93,$18,$93,$18,$C7  ;; ?QPWZ?               ;
                      db $18,$7F,$93,$DA,$00,$DB,$0A,$08  ;; ?QPWZ?               ;
                      db $6C,$C7,$C7,$D0,$18,$D0,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$D0,$18,$D0,$08,$C7,$C7,$D0  ;; ?QPWZ?               ;
                      db $18,$D0,$18,$C7,$D0,$24,$C7,$00  ;; ?QPWZ?               ;
                      db $DA,$04,$E2,$16,$E3,$90,$1C,$DB  ;; ?QPWZ?               ;
                      db $0A,$DE,$22,$19,$38,$18,$4C,$B4  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$B4,$18,$B4,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$B7,$18,$B7,$08,$C7,$C7,$B7  ;; ?QPWZ?               ;
                      db $18,$B7,$C7,$00,$DA,$04,$DB,$08  ;; ?QPWZ?               ;
                      db $DE,$20,$18,$36,$18,$4C,$A4,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$A4,$18,$A4,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $A7,$18,$A7,$08,$C7,$C7,$A7,$18  ;; ?QPWZ?               ;
                      db $A7,$C7,$DA,$04,$DB,$0C,$DE,$21  ;; ?QPWZ?               ;
                      db $1A,$37,$18,$4C,$AD,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $AD,$18,$AD,$08,$C7,$C7,$AF,$18  ;; ?QPWZ?               ;
                      db $AF,$08,$C7,$C7,$AF,$18,$AF,$C7  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$0A,$DE,$22,$18,$36  ;; ?QPWZ?               ;
                      db $18,$4C,$A9,$08,$C7,$C7,$A9,$18  ;; ?QPWZ?               ;
                      db $A9,$08,$C7,$C7,$AB,$18,$AB,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$AB,$18,$AB,$C7,$DA,$04  ;; ?QPWZ?               ;
                      db $DB,$0F,$08,$4C,$C7,$C7,$9A,$18  ;; ?QPWZ?               ;
                      db $9A,$08,$C7,$C7,$9A,$18,$9A,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$9F,$18,$9F,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $C7,$18,$7D,$9F,$DA,$04,$DB,$0F  ;; ?QPWZ?               ;
                      db $08,$4B,$C7,$C7,$8E,$18,$8E,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $93,$18,$93,$08,$C7,$C7,$C7,$18  ;; ?QPWZ?               ;
                      db $7E,$93,$DA,$08,$DB,$0A,$DE,$22  ;; ?QPWZ?               ;
                      db $19,$38,$08,$5E,$C7,$C7,$8E,$18  ;; ?QPWZ?               ;
                      db $8E,$08,$C7,$C7,$8E,$18,$8E,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$93,$18,$93,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $C7,$18,$7F,$93,$DA,$00,$DB,$0A  ;; ?QPWZ?               ;
                      db $08,$6B,$C7,$C7,$D0,$18,$D0,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$D0,$18,$D0,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $D0,$18,$D0,$C7,$08,$D0,$DB,$14  ;; ?QPWZ?               ;
                      db $08,$D1,$D1,$DA,$00,$DB,$0A,$DE  ;; ?QPWZ?               ;
                      db $22,$19,$38,$08,$5D,$A8,$C7,$AB  ;; ?QPWZ?               ;
                      db $AD,$C7,$24,$AB,$0C,$C7,$08,$AD  ;; ?QPWZ?               ;
                      db $AF,$C7,$B0,$AF,$AE,$24,$AD,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$A7,$A8,$C7,$AB,$AD,$C7  ;; ?QPWZ?               ;
                      db $24,$AB,$0C,$C7,$08,$AC,$AD,$C7  ;; ?QPWZ?               ;
                      db $AE,$AD,$AC,$24,$AB,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $AC,$00,$DA,$06,$DB,$0A,$DE,$22  ;; ?QPWZ?               ;
                      db $19,$38,$08,$5D,$A8,$C7,$AB,$AD  ;; ?QPWZ?               ;
                      db $C7,$24,$AB,$0C,$C7,$08,$AD,$AF  ;; ?QPWZ?               ;
                      db $C7,$B0,$AF,$AE,$24,$AD,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$A7,$A8,$C7,$AB,$AD,$C7,$24  ;; ?QPWZ?               ;
                      db $AB,$0C,$C7,$08,$AC,$AD,$C7,$AE  ;; ?QPWZ?               ;
                      db $AD,$AC,$24,$AB,$0C,$C7,$08,$AC  ;; ?QPWZ?               ;
                      db $00,$DA,$12,$DB,$05,$DE,$22,$19  ;; ?QPWZ?               ;
                      db $28,$60,$6B,$B4,$30,$B3,$08,$C6  ;; ?QPWZ?               ;
                      db $C6,$B3,$BB,$C6,$B9,$48,$B7,$18  ;; ?QPWZ?               ;
                      db $B2,$60,$B1,$DA,$06,$DB,$08,$DE  ;; ?QPWZ?               ;
                      db $14,$1F,$30,$08,$6B,$A4,$C7,$A4  ;; ?QPWZ?               ;
                      db $A8,$C7,$24,$A4,$0C,$C7,$08,$A8  ;; ?QPWZ?               ;
                      db $AB,$C7,$AB,$A7,$A7,$24,$A7,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$A3,$A2,$C7,$A6,$A6,$C7  ;; ?QPWZ?               ;
                      db $24,$A6,$0C,$C7,$08,$A6,$A8,$C7  ;; ?QPWZ?               ;
                      db $AB,$A8,$A8,$24,$A8,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $A8,$08,$6D,$A4,$C7,$A4,$A8,$C7  ;; ?QPWZ?               ;
                      db $24,$A4,$0C,$C7,$08,$A8,$AB,$C7  ;; ?QPWZ?               ;
                      db $AB,$A7,$A7,$24,$A7,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $A3,$A2,$C7,$A6,$A6,$C7,$24,$A6  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$A6,$A8,$C7,$AB,$A8  ;; ?QPWZ?               ;
                      db $A8,$24,$A8,$0C,$C7,$08,$A8,$DA  ;; ?QPWZ?               ;
                      db $06,$DB,$0C,$DE,$14,$1F,$30,$08  ;; ?QPWZ?               ;
                      db $6D,$9F,$C7,$A8,$A4,$C7,$24,$A8  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$A4,$A7,$C7,$A7,$AB  ;; ?QPWZ?               ;
                      db $AB,$24,$A3,$0C,$C7,$08,$9F,$9F  ;; ?QPWZ?               ;
                      db $C7,$A2,$A2,$C7,$24,$A2,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$A2,$A5,$C7,$A8,$A5,$A5,$24  ;; ?QPWZ?               ;
                      db $A5,$0C,$C7,$08,$A5,$DA,$0D,$DB  ;; ?QPWZ?               ;
                      db $0F,$01,$C7,$18,$4E,$C7,$9F,$C7  ;; ?QPWZ?               ;
                      db $9F,$C7,$9F,$C7,$9F,$C7,$9F,$C7  ;; ?QPWZ?               ;
                      db $9F,$C7,$9F,$C7,$9F,$DA,$0D,$DB  ;; ?QPWZ?               ;
                      db $0F,$18,$4E,$C7,$9C,$C7,$9C,$C7  ;; ?QPWZ?               ;
                      db $9B,$C7,$9B,$C7,$9A,$C7,$9A,$C7  ;; ?QPWZ?               ;
                      db $99,$C7,$99,$DA,$08,$DB,$0A,$DE  ;; ?QPWZ?               ;
                      db $14,$1F,$30,$18,$6F,$98,$C7,$18  ;; ?QPWZ?               ;
                      db $93,$08,$C7,$C7,$93,$18,$97,$C7  ;; ?QPWZ?               ;
                      db $18,$93,$08,$C7,$C7,$93,$18,$96  ;; ?QPWZ?               ;
                      db $C7,$18,$93,$08,$C7,$C7,$93,$18  ;; ?QPWZ?               ;
                      db $95,$C7,$18,$90,$08,$C7,$C7,$90  ;; ?QPWZ?               ;
                      db $DA,$00,$DB,$14,$18,$6B,$D1,$08  ;; ?QPWZ?               ;
                      db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7  ;; ?QPWZ?               ;
                      db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1  ;; ?QPWZ?               ;
                      db $C7,$D1,$D2,$D1,$D1,$18,$D1,$08  ;; ?QPWZ?               ;
                      db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7  ;; ?QPWZ?               ;
                      db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1  ;; ?QPWZ?               ;
                      db $C7,$D1,$D2,$D1,$D1,$08,$AD,$C7  ;; ?QPWZ?               ;
                      db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $AC,$AB,$C7,$AC,$AD,$C7,$24,$A8  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$C7,$A8,$C7,$A4,$A1  ;; ?QPWZ?               ;
                      db $C7,$A8,$A4,$C7,$A1,$A4,$C7,$AB  ;; ?QPWZ?               ;
                      db $30,$C6,$C7,$00,$01,$C7,$18,$C7  ;; ?QPWZ?               ;
                      db $9D,$C7,$9E,$C7,$9F,$C7,$9F,$18  ;; ?QPWZ?               ;
                      db $9E,$08,$C7,$C7,$9E,$18,$C6,$08  ;; ?QPWZ?               ;
                      db $9E,$C7,$9F,$18,$C6,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $A3,$A4,$C7,$A4,$A6,$C7,$A6,$18  ;; ?QPWZ?               ;
                      db $C7,$98,$C7,$98,$C7,$9A,$C7,$99  ;; ?QPWZ?               ;
                      db $18,$A1,$08,$C7,$C7,$A1,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$A1,$C7,$A3,$18,$C6,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$9A,$9C,$C7,$9C,$9D,$C7,$9D  ;; ?QPWZ?               ;
                      db $18,$91,$08,$C7,$C7,$91,$18,$92  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$92,$18,$93,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$93,$18,$95,$08,$95,$90,$8F  ;; ?QPWZ?               ;
                      db $18,$8E,$08,$C6,$C7,$8E,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$8E,$C7,$93,$18,$C6,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$93,$95,$C7,$95,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $18,$D1,$08,$D2,$C7,$D1,$18,$D1  ;; ?QPWZ?               ;
                      db $08,$D2,$C7,$D1,$18,$D1,$08,$D2  ;; ?QPWZ?               ;
                      db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1  ;; ?QPWZ?               ;
                      db $18,$D2,$08,$C6,$C7,$D2,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$D2,$C7,$D2,$18,$C6,$08,$C6  ;; ?QPWZ?               ;
                      db $C7,$D1,$D2,$C7,$D1,$D2,$D1,$D1  ;; ?QPWZ?               ;
                      db $08,$A9,$C7,$A9,$AD,$C7,$24,$AA  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$A9,$A8,$C7,$A8,$A8  ;; ?QPWZ?               ;
                      db $C7,$24,$AB,$0C,$C7,$08,$C7,$AD  ;; ?QPWZ?               ;
                      db $C7,$AD,$AD,$C7,$A9,$C7,$C7,$A9  ;; ?QPWZ?               ;
                      db $A9,$C7,$A8,$30,$C6,$C7,$08,$AD  ;; ?QPWZ?               ;
                      db $C7,$AF,$B0,$C7,$24,$AD,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$AC,$AB,$C7,$AC,$AD,$C7,$24  ;; ?QPWZ?               ;
                      db $B4,$0C,$C7,$08,$C7,$B4,$C7,$B3  ;; ?QPWZ?               ;
                      db $B4,$C7,$B0,$C7,$C7,$B0,$AD,$C7  ;; ?QPWZ?               ;
                      db $B0,$30,$C6,$C7,$00,$48,$B0,$08  ;; ?QPWZ?               ;
                      db $AD,$C6,$B0,$48,$B4,$08,$B3,$C6  ;; ?QPWZ?               ;
                      db $B4,$30,$B9,$30,$B4,$60,$B0,$01  ;; ?QPWZ?               ;
                      db $C7,$18,$C7,$9D,$C7,$9E,$C7,$9F  ;; ?QPWZ?               ;
                      db $C7,$9F,$18,$9E,$08,$C7,$C7,$9D  ;; ?QPWZ?               ;
                      db $18,$C6,$08,$C7,$C7,$AB,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$B0,$C7,$B0,$AF,$C7,$AF,$AE  ;; ?QPWZ?               ;
                      db $C7,$AE,$18,$C7,$98,$C7,$98,$C7  ;; ?QPWZ?               ;
                      db $9A,$C7,$99,$18,$A1,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $A3,$18,$C6,$08,$C7,$C7,$A4,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$A8,$C7,$A8,$A7,$C7,$A7  ;; ?QPWZ?               ;
                      db $A6,$C7,$A6,$18,$91,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $91,$18,$92,$08,$C7,$C7,$92,$18  ;; ?QPWZ?               ;
                      db $93,$08,$C7,$C7,$93,$18,$95,$08  ;; ?QPWZ?               ;
                      db $95,$90,$8F,$18,$8E,$08,$C6,$C7  ;; ?QPWZ?               ;
                      db $93,$18,$C6,$08,$C7,$C7,$98,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$98,$C7,$98,$97,$C7,$97  ;; ?QPWZ?               ;
                      db $96,$C7,$96,$18,$D1,$08,$D2,$C7  ;; ?QPWZ?               ;
                      db $D1,$18,$D1,$08,$D2,$C7,$D1,$18  ;; ?QPWZ?               ;
                      db $D1,$08,$D2,$C7,$D1,$D1,$C7,$D1  ;; ?QPWZ?               ;
                      db $D2,$D1,$D1,$18,$D2,$08,$C6,$C7  ;; ?QPWZ?               ;
                      db $D2,$18,$C6,$08,$C7,$C7,$D2,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$D2,$C7,$D1,$D2,$C7,$D1  ;; ?QPWZ?               ;
                      db $D2,$C7,$D1,$DA,$04,$18,$6C,$AD  ;; ?QPWZ?               ;
                      db $B4,$08,$B4,$C7,$B4,$B3,$C7,$B4  ;; ?QPWZ?               ;
                      db $B5,$C6,$B4,$B1,$C7,$24,$AD,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$AD,$B4,$C6,$B2,$B4,$C6  ;; ?QPWZ?               ;
                      db $B2,$B4,$C6,$B2,$B0,$C7,$AD,$30  ;; ?QPWZ?               ;
                      db $C6,$C7,$00,$DA,$04,$18,$6B,$A8  ;; ?QPWZ?               ;
                      db $AB,$08,$AB,$C7,$AB,$AA,$C7,$AB  ;; ?QPWZ?               ;
                      db $AD,$C6,$AB,$A8,$C7,$24,$A5,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$A5,$AB,$C6,$AA,$AB,$C6  ;; ?QPWZ?               ;
                      db $AA,$AB,$C6,$AA,$A8,$C7,$A4,$30  ;; ?QPWZ?               ;
                      db $C6,$C7,$18,$C7,$08,$AD,$C6,$AC  ;; ?QPWZ?               ;
                      db $AD,$C6,$B4,$C6,$C6,$AD,$AD,$C6  ;; ?QPWZ?               ;
                      db $AC,$AD,$C6,$B4,$C6,$C6,$AD,$AF  ;; ?QPWZ?               ;
                      db $C6,$B1,$18,$C7,$08,$AD,$C6,$AC  ;; ?QPWZ?               ;
                      db $AD,$C6,$B2,$C6,$C6,$AD,$AD,$C6  ;; ?QPWZ?               ;
                      db $AC,$AD,$C6,$B2,$30,$C6,$01,$C7  ;; ?QPWZ?               ;
                      db $18,$C7,$9F,$C7,$9F,$C7,$9F,$C7  ;; ?QPWZ?               ;
                      db $9F,$C7,$9E,$C7,$9E,$C7,$9E,$C7  ;; ?QPWZ?               ;
                      db $9E,$18,$C7,$99,$C7,$99,$C7,$99  ;; ?QPWZ?               ;
                      db $C7,$99,$C7,$98,$C7,$98,$C7,$98  ;; ?QPWZ?               ;
                      db $C7,$98,$18,$95,$08,$C7,$C7,$95  ;; ?QPWZ?               ;
                      db $18,$90,$08,$C7,$C7,$90,$18,$95  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$95,$18,$95,$08,$95  ;; ?QPWZ?               ;
                      db $90,$8F,$18,$8E,$08,$C7,$C7,$8E  ;; ?QPWZ?               ;
                      db $18,$95,$08,$C7,$C7,$95,$18,$8E  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$8E,$8E,$C7,$8E,$90  ;; ?QPWZ?               ;
                      db $C7,$92,$18,$D1,$08,$D2,$C7,$D1  ;; ?QPWZ?               ;
                      db $18,$D1,$08,$D2,$C7,$D1,$18,$D1  ;; ?QPWZ?               ;
                      db $08,$D2,$C7,$D1,$D1,$C7,$D1,$D2  ;; ?QPWZ?               ;
                      db $D1,$D1,$18,$D1,$08,$D2,$C7,$D1  ;; ?QPWZ?               ;
                      db $18,$D1,$08,$D2,$C7,$D1,$18,$D1  ;; ?QPWZ?               ;
                      db $08,$D2,$C7,$D1,$D2,$C7,$D1,$D2  ;; ?QPWZ?               ;
                      db $C7,$D1,$18,$AB,$B2,$08,$B2,$C7  ;; ?QPWZ?               ;
                      db $B2,$B1,$C7,$B2,$B4,$C6,$B2,$AF  ;; ?QPWZ?               ;
                      db $C7,$24,$AB,$0C,$C7,$08,$B2,$18  ;; ?QPWZ?               ;
                      db $B0,$B0,$10,$B0,$B2,$B3,$18,$B4  ;; ?QPWZ?               ;
                      db $C7,$AB,$C6,$00,$18,$A3,$A9,$08  ;; ?QPWZ?               ;
                      db $A9,$C7,$A9,$A8,$C7,$A9,$AB,$C6  ;; ?QPWZ?               ;
                      db $A9,$A6,$C7,$24,$A3,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $A9,$18,$A8,$A8,$10,$A8,$A9,$AA  ;; ?QPWZ?               ;
                      db $18,$AB,$C7,$A3,$C6,$18,$C7,$08  ;; ?QPWZ?               ;
                      db $AB,$C6,$AA,$AB,$C6,$B2,$C6,$C6  ;; ?QPWZ?               ;
                      db $AB,$AB,$C6,$AA,$AB,$C6,$B2,$C6  ;; ?QPWZ?               ;
                      db $C6,$AB,$AD,$C6,$AF,$30,$B0,$10  ;; ?QPWZ?               ;
                      db $B0,$AF,$AD,$AB,$06,$AD,$AF,$B0  ;; ?QPWZ?               ;
                      db $B2,$B3,$B4,$B5,$B6,$30,$B7,$01  ;; ?QPWZ?               ;
                      db $C7,$18,$C7,$9D,$C7,$9D,$C7,$9D  ;; ?QPWZ?               ;
                      db $C7,$9D,$C7,$9C,$10,$9C,$9D,$9E  ;; ?QPWZ?               ;
                      db $18,$9F,$C7,$9B,$C6,$18,$C7,$97  ;; ?QPWZ?               ;
                      db $C7,$97,$C7,$97,$C7,$97,$C7,$9F  ;; ?QPWZ?               ;
                      db $10,$9F,$A0,$A1,$18,$A3,$C7,$A3  ;; ?QPWZ?               ;
                      db $C6,$18,$93,$08,$C7,$C7,$93,$18  ;; ?QPWZ?               ;
                      db $8E,$08,$C7,$C7,$8E,$18,$93,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$93,$18,$93,$08,$93,$95  ;; ?QPWZ?               ;
                      db $97,$18,$98,$08,$C7,$C7,$98,$10  ;; ?QPWZ?               ;
                      db $98,$9A,$9B,$18,$9C,$C7,$93,$C6  ;; ?QPWZ?               ;
                      db $18,$D1,$08,$D2,$C7,$D1,$18,$D1  ;; ?QPWZ?               ;
                      db $08,$D2,$C7,$D1,$18,$D1,$08,$D2  ;; ?QPWZ?               ;
                      db $C7,$D1,$D1,$C7,$D1,$D2,$D1,$D1  ;; ?QPWZ?               ;
                      db $18,$D1,$08,$D2,$C7,$D1,$10,$D2  ;; ?QPWZ?               ;
                      db $D2,$D2,$18,$D1,$08,$D2,$C7,$D1  ;; ?QPWZ?               ;
                      db $D2,$C7,$D1,$D2,$D1,$D1,$08,$A9  ;; ?QPWZ?               ;
                      db $C7,$A9,$AD,$C7,$24,$AA,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$A9,$A8,$C7,$A8,$A8,$C7,$24  ;; ?QPWZ?               ;
                      db $AB,$0C,$C7,$08,$C7,$08,$AD,$C7  ;; ?QPWZ?               ;
                      db $AF,$B0,$C7,$24,$AD,$0C,$C7,$08  ;; ?QPWZ?               ;
                      db $AC,$AB,$C7,$AC,$AD,$C7,$24,$B4  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$C7,$00,$DA,$04,$DB  ;; ?QPWZ?               ;
                      db $0C,$DE,$22,$18,$14,$08,$5C,$A4  ;; ?QPWZ?               ;
                      db $C7,$A4,$A9,$C7,$24,$A4,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$A4,$A4,$C7,$A4,$A4,$C7,$24  ;; ?QPWZ?               ;
                      db $A5,$0C,$C7,$08,$C7,$48,$B0,$08  ;; ?QPWZ?               ;
                      db $AD,$C6,$B0,$60,$B4,$01,$C7,$18  ;; ?QPWZ?               ;
                      db $C7,$9D,$C7,$9E,$C7,$9F,$C7,$9F  ;; ?QPWZ?               ;
                      db $18,$9E,$08,$C7,$C7,$9D,$18,$C6  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$AB,$18,$C7,$98,$C7  ;; ?QPWZ?               ;
                      db $98,$C7,$9A,$C7,$99,$18,$A1,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$A3,$18,$C6,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $A4,$18,$91,$08,$C7,$C7,$91,$18  ;; ?QPWZ?               ;
                      db $92,$08,$C7,$C7,$92,$18,$93,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$93,$18,$95,$08,$95,$90  ;; ?QPWZ?               ;
                      db $8F,$18,$8E,$08,$C6,$C7,$93,$18  ;; ?QPWZ?               ;
                      db $C6,$08,$C7,$C7,$98,$18,$D1,$08  ;; ?QPWZ?               ;
                      db $D2,$C7,$D1,$18,$D1,$08,$D2,$C7  ;; ?QPWZ?               ;
                      db $D1,$18,$D1,$08,$D2,$C7,$D1,$D1  ;; ?QPWZ?               ;
                      db $C7,$D1,$D2,$D1,$D1,$18,$D2,$08  ;; ?QPWZ?               ;
                      db $C6,$C7,$D2,$18,$C6,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $D2,$DA,$04,$DB,$0A,$DE,$22,$19  ;; ?QPWZ?               ;
                      db $38,$18,$4D,$B4,$08,$C7,$C7,$B4  ;; ?QPWZ?               ;
                      db $18,$B4,$08,$C7,$C7,$B7,$18,$B7  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$B7,$18,$B7,$C7,$00  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$08,$DE,$20,$18,$36  ;; ?QPWZ?               ;
                      db $18,$4D,$A4,$08,$C7,$C7,$A4,$18  ;; ?QPWZ?               ;
                      db $A4,$08,$C7,$C7,$A7,$18,$A7,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$A7,$18,$A7,$C7,$DA,$04  ;; ?QPWZ?               ;
                      db $DB,$0C,$DE,$21,$1A,$37,$18,$4D  ;; ?QPWZ?               ;
                      db $AD,$08,$C7,$C7,$AD,$18,$AD,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$AF,$18,$AF,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $AF,$18,$AF,$C7,$DA,$04,$DB,$0A  ;; ?QPWZ?               ;
                      db $DE,$22,$18,$36,$18,$4D,$A9,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$A9,$18,$A9,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $AB,$18,$AB,$08,$C7,$C7,$AB,$18  ;; ?QPWZ?               ;
                      db $AB,$C7,$DA,$04,$DB,$0F,$08,$4D  ;; ?QPWZ?               ;
                      db $C7,$C7,$9A,$18,$9A,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $9A,$18,$9A,$08,$C7,$C7,$9F,$18  ;; ?QPWZ?               ;
                      db $9F,$08,$C7,$C7,$C7,$18,$7D,$9F  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$0F,$08,$4C,$C7,$C7  ;; ?QPWZ?               ;
                      db $8E,$18,$8E,$08,$C7,$C7,$8E,$18  ;; ?QPWZ?               ;
                      db $8E,$08,$C7,$C7,$93,$18,$93,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$C7,$18,$7E,$93,$DA,$08  ;; ?QPWZ?               ;
                      db $DB,$0A,$DE,$22,$19,$38,$08,$5F  ;; ?QPWZ?               ;
                      db $C7,$C7,$8E,$18,$8E,$08,$C7,$C7  ;; ?QPWZ?               ;
                      db $8E,$18,$8E,$08,$C7,$C7,$93,$18  ;; ?QPWZ?               ;
                      db $93,$08,$C7,$C7,$C7,$18,$7F,$93  ;; ?QPWZ?               ;
                      db $DA,$00,$DB,$0A,$08,$6C,$C7,$C7  ;; ?QPWZ?               ;
                      db $D0,$18,$D0,$08,$C7,$C7,$D0,$18  ;; ?QPWZ?               ;
                      db $D0,$08,$C7,$C7,$D0,$18,$D0,$C7  ;; ?QPWZ?               ;
                      db $08,$D0,$DB,$14,$08,$D1,$D1,$DA  ;; ?QPWZ?               ;
                      db $06,$DB,$0A,$DE,$22,$19,$38,$08  ;; ?QPWZ?               ;
                      db $6F,$B4,$C7,$B7,$B9,$C7,$24,$B7  ;; ?QPWZ?               ;
                      db $0C,$C7,$08,$B9,$BB,$C7,$BC,$BB  ;; ?QPWZ?               ;
                      db $BA,$24,$B9,$0C,$C7,$08,$B3,$B4  ;; ?QPWZ?               ;
                      db $C7,$B7,$B9,$C7,$24,$B7,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$B8,$B9,$C7,$BA,$B9,$B8,$24  ;; ?QPWZ?               ;
                      db $B7,$0C,$C7,$08,$B8,$00,$08,$B9  ;; ?QPWZ?               ;
                      db $C7,$BB,$BC,$C7,$24,$B9,$0C,$C7  ;; ?QPWZ?               ;
                      db $08,$B8,$B7,$C7,$B8,$B9,$C7,$24  ;; ?QPWZ?               ;
                      db $C0,$0C,$C7,$08,$C7,$00,$18,$91  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$91,$18,$92,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$92,$18,$93,$08,$C7,$C7,$93  ;; ?QPWZ?               ;
                      db $18,$95,$08,$C7,$C7,$95,$DA,$04  ;; ?QPWZ?               ;
                      db $DB,$0A,$DE,$22,$19,$38,$18,$5D  ;; ?QPWZ?               ;
                      db $C0,$08,$C7,$C7,$C0,$E3,$78,$18  ;; ?QPWZ?               ;
                      db $18,$C0,$08,$C7,$C7,$C3,$18,$C3  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$C3,$18,$C3,$C3,$00  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$0A,$DE,$22,$19,$38  ;; ?QPWZ?               ;
                      db $18,$5D,$C0,$08,$C7,$C7,$C0,$18  ;; ?QPWZ?               ;
                      db $C0,$08,$C7,$C7,$C3,$18,$C3,$08  ;; ?QPWZ?               ;
                      db $C7,$C7,$C3,$18,$C3,$C3,$00,$DA  ;; ?QPWZ?               ;
                      db $04,$DB,$08,$DE,$20,$18,$36,$18  ;; ?QPWZ?               ;
                      db $5D,$A4,$08,$C7,$C7,$A4,$18,$A4  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$A7,$18,$A7,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$A7,$18,$A7,$A7,$DA,$04,$DB  ;; ?QPWZ?               ;
                      db $0C,$DE,$21,$1A,$37,$18,$5D,$B9  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$B9,$18,$B9,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$BB,$18,$BB,$08,$C7,$C7,$BB  ;; ?QPWZ?               ;
                      db $18,$BB,$BB,$DA,$04,$DB,$0A,$DE  ;; ?QPWZ?               ;
                      db $22,$18,$36,$18,$5D,$A9,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$A9,$18,$A9,$08,$C7,$C7,$AB  ;; ?QPWZ?               ;
                      db $18,$AB,$08,$C7,$C7,$AB,$18,$AB  ;; ?QPWZ?               ;
                      db $AB,$DA,$04,$DB,$0F,$08,$5D,$C7  ;; ?QPWZ?               ;
                      db $C7,$9A,$18,$9A,$08,$C7,$C7,$9A  ;; ?QPWZ?               ;
                      db $18,$9A,$08,$C7,$C7,$9F,$18,$9F  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$9F,$08,$7D,$C7,$C7  ;; ?QPWZ?               ;
                      db $9F,$DA,$04,$DB,$0F,$08,$5C,$C7  ;; ?QPWZ?               ;
                      db $C7,$8E,$18,$8E,$08,$C7,$C7,$8E  ;; ?QPWZ?               ;
                      db $18,$8E,$08,$C7,$C7,$93,$18,$93  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$93,$08,$7E,$C7,$C7  ;; ?QPWZ?               ;
                      db $93,$DA,$08,$DB,$0A,$DE,$22,$19  ;; ?QPWZ?               ;
                      db $38,$08,$5F,$C7,$C7,$8E,$18,$8E  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$8E,$18,$8E,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$93,$18,$93,$08,$C7,$C7,$C7  ;; ?QPWZ?               ;
                      db $08,$7F,$C7,$C7,$93,$DA,$00,$DB  ;; ?QPWZ?               ;
                      db $0A,$08,$6C,$C7,$C7,$D0,$18,$D0  ;; ?QPWZ?               ;
                      db $08,$C7,$C7,$D0,$18,$D0,$08,$C7  ;; ?QPWZ?               ;
                      db $C7,$D0,$18,$D0,$C7,$08,$D0,$DB  ;; ?QPWZ?               ;
                      db $14,$08,$D1,$D1,$DA,$04,$DE,$14  ;; ?QPWZ?               ;
                      db $19,$30,$DB,$0A,$08,$4F,$B9,$C6  ;; ?QPWZ?               ;
                      db $B7,$B9,$C6,$24,$B7,$0C,$C6,$08  ;; ?QPWZ?               ;
                      db $B9,$BB,$C6,$C7,$BB,$C6,$24,$B9  ;; ?QPWZ?               ;
                      db $0C,$C6,$08,$C6,$B9,$C6,$B7,$B9  ;; ?QPWZ?               ;
                      db $C6,$24,$B7,$0C,$C6,$08,$B8,$B9  ;; ?QPWZ?               ;
                      db $C6,$C7,$B9,$C6,$24,$B7,$0C,$C6  ;; ?QPWZ?               ;
                      db $08,$B8,$DE,$16,$18,$30,$DB,$0A  ;; ?QPWZ?               ;
                      db $08,$4E,$AD,$C6,$AB,$AD,$C6,$24  ;; ?QPWZ?               ;
                      db $AB,$0C,$C6,$08,$AD,$AF,$C6,$C7  ;; ?QPWZ?               ;
                      db $AF,$C6,$24,$AD,$0C,$C6,$08,$C6  ;; ?QPWZ?               ;
                      db $AD,$C6,$AB,$AD,$C6,$24,$AB,$0C  ;; ?QPWZ?               ;
                      db $C7,$08,$AC,$AD,$C6,$C7,$AD,$C6  ;; ?QPWZ?               ;
                      db $24,$AB,$0C,$C6,$08,$AC,$00,$DE  ;; ?QPWZ?               ;
                      db $15,$19,$31,$DB,$08,$08,$4E,$A8  ;; ?QPWZ?               ;
                      db $C6,$A4,$A8,$C6,$24,$A8,$0C,$C6  ;; ?QPWZ?               ;
                      db $08,$A8,$AB,$C6,$C7,$AB,$C6,$24  ;; ?QPWZ?               ;
                      db $A7,$0C,$C6,$08,$C6,$A6,$C6,$A6  ;; ?QPWZ?               ;
                      db $A6,$C6,$24,$A6,$0C,$C6,$08,$A6  ;; ?QPWZ?               ;
                      db $A8,$C6,$C7,$A8,$C6,$24,$A8,$0C  ;; ?QPWZ?               ;
                      db $C6,$08,$A8,$DA,$06,$DB,$0C,$DE  ;; ?QPWZ?               ;
                      db $14,$1A,$30,$08,$4E,$A4,$C6,$A4  ;; ?QPWZ?               ;
                      db $A4,$C6,$24,$A4,$0C,$C6,$08,$A4  ;; ?QPWZ?               ;
                      db $A7,$C6,$C7,$A7,$C6,$24,$A3,$0C  ;; ?QPWZ?               ;
                      db $C6,$08,$C6,$A2,$C6,$A2,$A2,$C6  ;; ?QPWZ?               ;
                      db $24,$A2,$0C,$C6,$08,$A2,$A5,$C6  ;; ?QPWZ?               ;
                      db $C7,$A5,$C6,$24,$A5,$0C,$C6,$08  ;; ?QPWZ?               ;
                      db $A5,$08,$B9,$C6,$BB,$BC,$C6,$24  ;; ?QPWZ?               ;
                      db $B9,$0C,$C6,$08,$B8,$B7,$C6,$B8  ;; ?QPWZ?               ;
                      db $B9,$C6,$24,$C0,$0C,$C6,$08,$C6  ;; ?QPWZ?               ;
                      db $00,$08,$A9,$C6,$A9,$AD,$C6,$24  ;; ?QPWZ?               ;
                      db $AA,$0C,$C6,$08,$A9,$A8,$C6,$A8  ;; ?QPWZ?               ;
                      db $A8,$C6,$24,$AB,$0C,$C6,$08,$C6  ;; ?QPWZ?               ;
                      db $08,$AD,$C6,$AF,$B0,$C6,$24,$AD  ;; ?QPWZ?               ;
                      db $0C,$C6,$08,$AC,$AB,$C6,$AC,$AD  ;; ?QPWZ?               ;
                      db $C6,$24,$B4,$0C,$C6,$08,$C6,$00  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$0C,$DE,$22,$18,$14  ;; ?QPWZ?               ;
                      db $08,$5C,$A4,$C6,$A4,$A9,$C6,$24  ;; ?QPWZ?               ;
                      db $A4,$0C,$C6,$08,$A4,$A4,$C6,$A4  ;; ?QPWZ?               ;
                      db $A4,$C6,$24,$A5,$0C,$C6,$08,$C6  ;; ?QPWZ?               ;
                      db $DA,$04,$DB,$0A,$DE,$22,$19,$38  ;; ?QPWZ?               ;
                      db $60,$5E,$BC,$C6,$DA,$01,$10,$9F  ;; ?QPWZ?               ;
                      db $C6,$C6,$C6,$AF,$C6,$60,$C6,$C6  ;; ?QPWZ?               ;
                      db $00,$DA,$04,$DB,$08,$DE,$20,$18  ;; ?QPWZ?               ;
                      db $36,$60,$5D,$B4,$C6,$DA,$01,$10  ;; ?QPWZ?               ;
                      db $C7,$A3,$C6,$C6,$C6,$B3,$60,$C6  ;; ?QPWZ?               ;
                      db $C6,$DA,$04,$DB,$0C,$DE,$21,$1A  ;; ?QPWZ?               ;
                      db $37,$60,$5D,$AB,$C6,$DA,$01,$10  ;; ?QPWZ?               ;
                      db $C7,$C7,$A7,$C6,$C6,$C6,$60,$B7  ;; ?QPWZ?               ;
                      db $C6,$DA,$04,$DB,$0A,$DE,$22,$18  ;; ?QPWZ?               ;
                      db $36,$60,$5D,$A4,$C6,$DA,$01,$10  ;; ?QPWZ?               ;
                      db $C7,$C7,$C7,$AB,$C6,$C6,$60,$C6  ;; ?QPWZ?               ;
                      db $C6,$DA,$04,$DB,$0F,$10,$5D,$A4  ;; ?QPWZ?               ;
                      db $C7,$A4,$A2,$C7,$A2,$A1,$C7,$A1  ;; ?QPWZ?               ;
                      db $A0,$C7,$A0,$60,$9F,$9B,$C6,$DA  ;; ?QPWZ?               ;
                      db $0D,$DB,$0F,$10,$5D,$9C,$C7,$9C  ;; ?QPWZ?               ;
                      db $9C,$C7,$9C,$98,$C7,$98,$98,$C7  ;; ?QPWZ?               ;
                      db $98,$60,$97,$97,$C6,$DA,$08,$DB  ;; ?QPWZ?               ;
                      db $0A,$DE,$22,$19,$38,$10,$5D,$98  ;; ?QPWZ?               ;
                      db $C7,$98,$96,$C7,$96,$95,$C7,$95  ;; ?QPWZ?               ;
                      db $94,$C7,$94,$60,$93,$93,$C6,$00  ;; ?QPWZ?               ;
                      db $00,$00,$05,$E8,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00,$00,$00,$00  ;; ?QPWZ?               ;
                      db $00,$00,$00,$00,$00              ;; ?QPWZ?               ;
                                                          ;;                      ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; 03FDE0               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
                      db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ;; ?QPWZ?               ;
