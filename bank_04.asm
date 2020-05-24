                      ORG $048000                               ;;  J |  U + SS / E0 \ E1 ;
                                                                ;;                        ;
DATA_048000:          dw $B480,$B498,$B4B0                      ;;8000|8000+8000/8000\8000;
                                                                ;;                        ;
DATA_048006:          dw $B300,$B318,$B330,$B348                ;;8006|8006+8006/8006\8006;
                      dw $B360,$B378,$B390,$B3A8                ;;800E|800E+800E/800E\800E;
                      dw $B3C0,$B3D8,$B3F0,$B408                ;;8016|8016+8016/8016\8016;
                      dw $B420,$B438,$B450,$B468                ;;801E|801E+801E/801E\801E;
                      dw $B480,$B498,$B4B0,$B4C8                ;;8026|8026+8026/8026\8026;
                      dw $B4E0,$B4F8,$B510,$B528                ;;802E|802E+802E/802E\802E;
                      dw $B540,$B558,$B570,$B588                ;;8036|8036+8036/8036\8036;
                      dw $B5A0,$B5B8,$B5D0,$B5E8                ;;803E|803E+803E/803E\803E;
                      dw $B600,$B618,$B630,$B648                ;;8046|8046+8046/8046\8046;
                      dw $B660,$B678,$B690,$B6A8                ;;804E|804E+804E/804E\804E;
                      dw $B6C0,$B6D8,$B6F0,$B708                ;;8056|8056+8056/8056\8056;
                      dw $B720,$B738,$B750,$B768                ;;805E|805E+805E/805E\805E;
                      dw $B780,$B798,$B7B0,$B7C8                ;;8066|8066+8066/8066\8066;
                      dw $B7E0,$B7F8,$B810,$B828                ;;806E|806E+806E/806E\806E;
                      dw $B840,$B858,$B870,$B888                ;;8076|8076+8076/8076\8076;
                      dw $B8A0,$B8B8,$B8D0,$B8E8                ;;807E|807E+807E/807E\807E;
                                                                ;;                        ;
CODE_048086:          REP #$30                                  ;;8086|8086+8086/8086\8086; Index (16 bit) Accum (16 bit) 
                      STZ.B !_3                                 ;;8088|8088+8088/8088\8088;
                      STZ.B !_5                                 ;;808A|808A+808A/808A\808A;
                    - LDX.B !_3                                 ;;808C|808C+808C/808C\808C;
                      LDA.W DATA_048000,X                       ;;808E|808E+808E/808E\808E;
                      STA.B !_0                                 ;;8091|8091+8091/8091\8091;
                      SEP #$10                                  ;;8093|8093+8093/8093\8093; Index (8 bit) 
                      LDY.B #$7E                                ;;8095|8095+8095/8095\8095;
                      STY.B !_2                                 ;;8097|8097+8097/8097\8097;
                      REP #$10                                  ;;8099|8099+8099/8099\8099; Index (16 bit) 
                      LDX.B !_5                                 ;;809B|809B+809B/809B\809B;
                      JSR CODE_0480B9                           ;;809D|809D+809D/809D\809D;
                      LDA.B !_5                                 ;;80A0|80A0+80A0/80A0\80A0;
                      CLC                                       ;;80A2|80A2+80A2/80A2\80A2;
                      ADC.W #$0020                              ;;80A3|80A3+80A3/80A3\80A3;
                      STA.B !_5                                 ;;80A6|80A6+80A6/80A6\80A6;
                      LDA.B !_3                                 ;;80A8|80A8+80A8/80A8\80A8;
                      INC A                                     ;;80AA|80AA+80AA/80AA\80AA;
                      INC A                                     ;;80AB|80AB+80AB/80AB\80AB;
                      STA.B !_3                                 ;;80AC|80AC+80AC/80AC\80AC;
                      AND.W #$00FF                              ;;80AE|80AE+80AE/80AE\80AE;
                      CMP.W #$0006                              ;;80B1|80B1+80B1/80B1\80B1;
                      BNE -                                     ;;80B4|80B4+80B4/80B4\80B4;
                      SEP #$30                                  ;;80B6|80B6+80B6/80B6\80B6; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;80B8|80B8+80B8/80B8\80B8; Return 
                                                                ;;                        ;
CODE_0480B9:          LDY.W #$0000                              ;;80B9|80B9+80B9/80B9\80B9; Index (16 bit) Accum (16 bit) 
                      LDA.W #$0008                              ;;80BC|80BC+80BC/80BC\80BC;
                      STA.B !_7                                 ;;80BF|80BF+80BF/80BF\80BF;
                      STA.B !_9                                 ;;80C1|80C1+80C1/80C1\80C1;
                    - LDA.B [!_0],Y                             ;;80C3|80C3+80C3/80C3\80C3;
                      STA.W !GfxDecompOWAni,X                   ;;80C5|80C5+80C5/80C5\80C5;
                      INY                                       ;;80C8|80C8+80C8/80C8\80C8;
                      INY                                       ;;80C9|80C9+80C9/80C9\80C9;
                      INX                                       ;;80CA|80CA+80CA/80CA\80CA;
                      INX                                       ;;80CB|80CB+80CB/80CB\80CB;
                      DEC.B !_7                                 ;;80CC|80CC+80CC/80CC\80CC;
                      BNE -                                     ;;80CE|80CE+80CE/80CE\80CE;
                    - LDA.B [!_0],Y                             ;;80D0|80D0+80D0/80D0\80D0;
                      AND.W #$00FF                              ;;80D2|80D2+80D2/80D2\80D2;
                      STA.W !GfxDecompOWAni,X                   ;;80D5|80D5+80D5/80D5\80D5;
                      INY                                       ;;80D8|80D8+80D8/80D8\80D8;
                      INX                                       ;;80D9|80D9+80D9/80D9\80D9;
                      INX                                       ;;80DA|80DA+80DA/80DA\80DA;
                      DEC.B !_9                                 ;;80DB|80DB+80DB/80DB\80DB;
                      BNE -                                     ;;80DD|80DD+80DD/80DD\80DD;
                      RTS                                       ;;80DF|80DF+80DF/80DF\80DF; Return 
                                                                ;;                        ;
OW_Tile_Animation:    LDA.B !TrueFrame                          ;;80E0|80E0+80E0/80E0\80E0; \ ; Index (8 bit) Accum (8 bit) 
                      AND.B #$07                                ;;80E2|80E2+80E2/80E2\80E2;  |If lower 3 bits of frame counter isn't 0, 
                      BNE CODE_048101                           ;;80E4|80E4+80E4/80E4\80E4; / don't update the water animation 
                      LDX.B #$1F                                ;;80E6|80E6+80E6/80E6\80E6;
CODE_0480E8:          LDA.W !GfxDecompOWAni,X                   ;;80E8|80E8+80E8/80E8\80E8;
                      STA.B !_0                                 ;;80EB|80EB+80EB/80EB\80EB;
                      TXA                                       ;;80ED|80ED+80ED/80ED\80ED;
                      AND.B #$08                                ;;80EE|80EE+80EE/80EE\80EE;
                      BNE CODE_0480F9                           ;;80F0|80F0+80F0/80F0\80F0;
                      ASL.B !_0                                 ;;80F2|80F2+80F2/80F2\80F2;
                      ROL.W !GfxDecompOWAni,X                   ;;80F4|80F4+80F4/80F4\80F4;
                      BRA +                                     ;;80F7|80F7+80F7/80F7\80F7;
                                                                ;;                        ;
CODE_0480F9:          LSR.B !_0                                 ;;80F9|80F9+80F9/80F9\80F9;
                      ROR.W !GfxDecompOWAni,X                   ;;80FB|80FB+80FB/80FB\80FB;
                    + DEX                                       ;;80FE|80FE+80FE/80FE\80FE;
                      BPL CODE_0480E8                           ;;80FF|80FF+80FF/80FF\80FF;
CODE_048101:          LDA.B !TrueFrame                          ;;8101|8101+8101/8101\8101; \ 
                      AND.B #$07                                ;;8103|8103+8103/8103\8103;  |If lower 3 bits of frame counter isn't 0, 
                      BNE +                                     ;;8105|8105+8105/8105\8105; / don't update the waterfall animation 
                      LDX.B #$20                                ;;8107|8107+8107/8107\8107;
                      JSR CODE_048172                           ;;8109|8109+8109/8109\8109;
                    + LDA.B !TrueFrame                          ;;810C|810C+810C/810C\810C; \ 
                      AND.B #$07                                ;;810E|810E+810E/810E\810E;  |If lower 3 bits of frame counter isn't 0, 
                      BNE CODE_048123                           ;;8110|8110+8110/8110\8110; / branch to $8123 
                      LDX.B #$1F                                ;;8112|8112+8112/8112\8112;
                    - LDA.W !GfxDecompOWAni+$40,X               ;;8114|8114+8114/8114\8114;
                      ASL A                                     ;;8117|8117+8117/8117\8117;
                      ROL.W !GfxDecompOWAni+$40,X               ;;8118|8118+8118/8118\8118;
                      DEX                                       ;;811B|811B+811B/811B\811B;
                      BPL -                                     ;;811C|811C+811C/811C\811C;
                      LDX.B #$40                                ;;811E|811E+811E/811E\811E;
                      JSR CODE_048172                           ;;8120|8120+8120/8120\8120;
CODE_048123:          REP #$30                                  ;;8123|8123+8123/8123\8123; Index (16 bit) Accum (16 bit) 
                      LDA.W #$0060                              ;;8125|8125+8125/8125\8125;
                      STA.B !_D                                 ;;8128|8128+8128/8128\8128;
                      STZ.B !_B                                 ;;812A|812A+812A/812A\812A;
CODE_04812C:          LDX.W #$0038                              ;;812C|812C+812C/812C\812C;
                      LDA.B !_B                                 ;;812F|812F+812F/812F\812F;
                      CMP.W #$0020                              ;;8131|8131+8131/8131\8131;
                      BCS +                                     ;;8134|8134+8134/8134\8134;
                      LDX.W #$0070                              ;;8136|8136+8136/8136\8136;
                    + TXA                                       ;;8139|8139+8139/8139\8139;
                      AND.B !TrueFrame                          ;;813A|813A+813A/813A\813A;
                      LSR A                                     ;;813C|813C+813C/813C\813C;
                      LSR A                                     ;;813D|813D+813D/813D\813D;
                      CPX.W #$0038                              ;;813E|813E+813E/813E\813E;
                      BEQ +                                     ;;8141|8141+8141/8141\8141;
                      LSR A                                     ;;8143|8143+8143/8143\8143;
                    + CLC                                       ;;8144|8144+8144/8144\8144;
                      ADC.B !_B                                 ;;8145|8145+8145/8145\8145;
                      TAX                                       ;;8147|8147+8147/8147\8147;
                      LDA.W DATA_048006,X                       ;;8148|8148+8148/8148\8148;
                      STA.B !_0                                 ;;814B|814B+814B/814B\814B;
                      SEP #$10                                  ;;814D|814D+814D/814D\814D; Index (8 bit) 
                      LDY.B #$7E                                ;;814F|814F+814F/814F\814F;
                      STY.B !_2                                 ;;8151|8151+8151/8151\8151;
                      REP #$10                                  ;;8153|8153+8153/8153\8153; Index (16 bit) 
                      LDX.B !_D                                 ;;8155|8155+8155/8155\8155;
                      JSR CODE_0480B9                           ;;8157|8157+8157/8157\8157;
                      LDA.B !_D                                 ;;815A|815A+815A/815A\815A;
                      CLC                                       ;;815C|815C+815C/815C\815C;
                      ADC.W #$0020                              ;;815D|815D+815D/815D\815D;
                      STA.B !_D                                 ;;8160|8160+8160/8160\8160;
                      LDA.B !_B                                 ;;8162|8162+8162/8162\8162;
                      CLC                                       ;;8164|8164+8164/8164\8164;
                      ADC.W #$0010                              ;;8165|8165+8165/8165\8165;
                      STA.B !_B                                 ;;8168|8168+8168/8168\8168;
                      CMP.W #$0080                              ;;816A|816A+816A/816A\816A;
                      BNE CODE_04812C                           ;;816D|816D+816D/816D\816D;
                      SEP #$30                                  ;;816F|816F+816F/816F\816F; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;8171|8171+8171/8171\8171; Return 
                                                                ;;                        ;
CODE_048172:          REP #$20                                  ;;8172|8172+8172/8172\8172; Accum (16 bit) 
                      LDY.B #$00                                ;;8174|8174+8174/8174\8174;
                    - PHX                                       ;;8176|8176+8176/8176\8176;
                      TXA                                       ;;8177|8177+8177/8177\8177;
                      CLC                                       ;;8178|8178+8178/8178\8178;
                      ADC.W #$000E                              ;;8179|8179+8179/8179\8179;
                      TAX                                       ;;817C|817C+817C/817C\817C;
                      LDA.W !GfxDecompOWAni,X                   ;;817D|817D+817D/817D\817D;
                      STA.B !_0                                 ;;8180|8180+8180/8180\8180;
                      PLX                                       ;;8182|8182+8182/8182\8182;
CODE_048183:          LDA.W !GfxDecompOWAni,X                   ;;8183|8183+8183/8183\8183;
                      STA.B !_2                                 ;;8186|8186+8186/8186\8186;
                      LDA.B !_0                                 ;;8188|8188+8188/8188\8188;
                      STA.W !GfxDecompOWAni,X                   ;;818A|818A+818A/818A\818A;
                      LDA.B !_2                                 ;;818D|818D+818D/818D\818D;
                      STA.B !_0                                 ;;818F|818F+818F/818F\818F;
                      INX                                       ;;8191|8191+8191/8191\8191;
                      INX                                       ;;8192|8192+8192/8192\8192;
                      INY                                       ;;8193|8193+8193/8193\8193;
                      CPY.B #$08                                ;;8194|8194+8194/8194\8194;
                      BEQ -                                     ;;8196|8196+8196/8196\8196;
                      CPY.B #$10                                ;;8198|8198+8198/8198\8198;
                      BNE CODE_048183                           ;;819A|819A+819A/819A\819A;
                      SEP #$20                                  ;;819C|819C+819C/819C\819C; Accum (8 bit) 
                      RTS                                       ;;819E|819E+819E/819E\819E; Return 
                                                                ;;                        ;
                                                                ;;                        ;
OWScrollArrowStripe:  db $50,$CF,$00,$03,$7E,$78,$7E,$38        ;;819F|819F+819F/819F\819F;
                      db $50,$EF,$00,$03,$7F,$38,$7F,$78        ;;81A7|81A7+81A7/81A7\81A7;
                      db $51,$C3,$00,$03,$7E,$78,$7D,$78        ;;81AF|81AF+81AF/81AF\81AF;
                      db $51,$E3,$00,$03,$7E,$F8,$7D,$F8        ;;81B7|81B7+81B7/81B7\81B7;
                      db $51,$DB,$00,$03,$7D,$38,$7E,$38        ;;81BF|81BF+81BF/81BF\81BF;
                      db $51,$FB,$00,$03,$7D,$B8,$7E,$B8        ;;81C7|81C7+81C7/81C7\81C7;
                      db $52,$EF,$00,$03,$7F,$B8,$7F,$F8        ;;81CF|81CF+81CF/81CF\81CF;
                      db $53,$0F,$00,$03,$7E,$F8,$7E,$B8        ;;81D7|81D7+81D7/81D7\81D7;
                      db $FF                                    ;;81DF|81DF+81DF/81DF\81DF;
                                                                ;;                        ;
OWScrollEraseStripe:  db $50,$CF,$40,$02,$FC,$00,$50,$EF        ;;81E0|81E0+81E0/81E0\81E0;
                      db $40,$02,$FC,$00,$51,$C3,$40,$02        ;;81E8|81E8+81E8/81E8\81E8;
                      db $FC,$00,$51,$E3,$40,$02,$FC,$00        ;;81F0|81F0+81F0/81F0\81F0;
                      db $51,$DB,$40,$02,$FC,$00,$51,$FB        ;;81F8|81F8+81F8/81F8\81F8;
                      db $40,$02,$FC,$00,$52,$EF,$40,$02        ;;8200|8200+8200/8200\8200;
                      db $FC,$00,$53,$0F,$40,$02,$FC,$00        ;;8208|8208+8208/8208\8208;
                      db $FF                                    ;;8210|8210+8210/8210\8210;
                                                                ;;                        ;
OWScrollSpeed:        db $00,$00,$02,$00,$FE,$FF,$02,$00        ;;8211|8211+8211/8211\8211;
                      db $00,$00,$02,$00,$FE,$FF,$02,$00        ;;8219|8219+8219/8219\8219;
OWMaxScrollRange:     db $00,$00,$11,$01,$EF,$FF,$11,$01        ;;8221|8221+8221/8221\8221;
                      db $00,$00,$32,$01,$D7,$FF,$32,$01        ;;8229|8229+8229/8229\8229;
DATA_048231:          db $0F,$0F,$07,$07,$07,$03,$03,$03        ;;8231|8231+8231/8231\8231;
                      db $01,$01,$03,$03,$03,$07,$07,$07        ;;8239|8239+8239/8239\8239;
                                                                ;;                        ;
GameMode_0E_Prim:     PHB                                       ;;8241|8241+8241/8241\8241;
                      PHK                                       ;;8242|8242+8242/8242\8242;
                      PLB                                       ;;8243|8243+8243/8243\8243;
                      LDX.B #$01                                ;;8244|8244+8244/8244\8244; \ If player 1 pushes select... 
CODE_048246:          LDA.W !byetudlrP1Frame,X                  ;;8246|8246+8246/8246\8246;  | 
                      AND.B #$20                                ;;8249|8249+8249/8249\8249;  | ...disabled by BRA 
                      BRA CODE_048261                           ;;824B|824B+824B/824B\824B; / Change to BEQ to enable debug code below 
                                                                ;;                        ;
                      LDA.W !SavedPlayerYoshi,X                 ;;824D|824D+824D/824D\824D; \ Unreachable 
                      INC A                                     ;;8250|8250+8250/8250\8250;  | Debug: Change Yoshi color 
                      INC A                                     ;;8251|8251+8251/8251\8251;  | 
                      CMP.B #$04                                ;;8252|8252+8252/8252\8252;  | 
                      BCS +                                     ;;8254|8254+8254/8254\8254;  | 
                      LDA.B #$04                                ;;8256|8256+8256/8256\8256;  | 
                    + CMP.B #$0B                                ;;8258|8258+8258/8258\8258;  | 
                      BCC +                                     ;;825A|825A+825A/825A\825A;  | 
                      LDA.B #$00                                ;;825C|825C+825C/825C\825C;  | 
                    + STA.W !SavedPlayerYoshi,X                 ;;825E|825E+825E/825E\825E; / 
CODE_048261:          DEX                                       ;;8261|8261+8261/8261\8261;
                      BPL CODE_048246                           ;;8262|8262+8262/8262\8262;
                      JSR CODE_0485A7                           ;;8264|8264+8264/8264\8264;
                      JSR OW_Tile_Animation                     ;;8267|8267+8267/8267\8267;
                      LDA.W !SwitchPalaceColor                  ;;826A|826A+826A/826A\826A; \ If "! blocks flying away color" is 0, 
                      BEQ +                                     ;;826D|826D+826D/826D\826D; / don't play the animation 
                      JSR CODE_04F290                           ;;826F|826F+826F/826F\826F;
                      JMP CODE_04840D                           ;;8272|8272+8272/8272\8272;
                                                                ;;                        ;
                    + LDA.W !ShowContinueEnd                    ;;8275|8275+8275/8275\8275; \ If not showing Continue/End message, 
                      BEQ +                                     ;;8278|8278+8278/8278\8278; / branch to $8281 
                      JSL CODE_009B80                           ;;827A|827A+827A/827A\827A;
                      JMP CODE_048410                           ;;827E|827E+827E/827E\827E;
                                                                ;;                        ;
                    + LDA.W !OverworldPromptProcess             ;;8281|8281+8281/8281\8281;
                      BEQ CODE_048295                           ;;8284|8284+8284/8284\8284;
                      CMP.B #$05                                ;;8286|8286+8286/8286\8286;
                      BCS CODE_04828F                           ;;8288|8288+8288/8288\8288;
                      LDY.W !IsTwoPlayerGame                    ;;828A|828A+828A/828A\828A;
                      BEQ CODE_048295                           ;;828D|828D+828D/828D\828D;
CODE_04828F:          JSR CODE_04F3E5                           ;;828F|828F+828F/828F\828F;
                      JMP CODE_048413                           ;;8292|8292+8292/8292\8292;
                                                                ;;                        ;
CODE_048295:          LDA.W !PauseFlag                          ;;8295|8295+8295/8295\8295;
                      LSR A                                     ;;8298|8298+8298/8298\8298;
                      BNE +                                     ;;8299|8299+8299/8299\8299;
                      JMP CODE_048356                           ;;829B|829B+829B/829B\829B;
                                                                ;;                        ;
                    + REP #$20                                  ;;829E|829E+829E/829E\829E; Accum (16 bit) 
                      LDA.W !OverworldFreeCamYPos               ;;82A0|82A0+82A0/82A0\82A0;
                      SEC                                       ;;82A3|82A3+82A3/82A3\82A3;
                      SBC.B !Layer1YPos                         ;;82A4|82A4+82A4/82A4\82A4;
                      STA.B !_1                                 ;;82A6|82A6+82A6/82A6\82A6;
                      BPL +                                     ;;82A8|82A8+82A8/82A8\82A8;
                      EOR.W #$FFFF                              ;;82AA|82AA+82AA/82AA\82AA;
                      INC A                                     ;;82AD|82AD+82AD/82AD\82AD;
                    + LSR A                                     ;;82AE|82AE+82AE/82AE\82AE;
                      SEP #$20                                  ;;82AF|82AF+82AF/82AF\82AF; Accum (8 bit) 
                      STA.B !_5                                 ;;82B1|82B1+82B1/82B1\82B1;
                      REP #$20                                  ;;82B3|82B3+82B3/82B3\82B3; Accum (16 bit) 
                      LDA.W !OverworldFreeCamXPos               ;;82B5|82B5+82B5/82B5\82B5;
                      SEC                                       ;;82B8|82B8+82B8/82B8\82B8;
                      SBC.B !Layer1XPos                         ;;82B9|82B9+82B9/82B9\82B9;
                      STA.B !_0                                 ;;82BB|82BB+82BB/82BB\82BB;
                      BPL +                                     ;;82BD|82BD+82BD/82BD\82BD;
                      EOR.W #$FFFF                              ;;82BF|82BF+82BF/82BF\82BF;
                      INC A                                     ;;82C2|82C2+82C2/82C2\82C2;
                    + LSR A                                     ;;82C3|82C3+82C3/82C3\82C3;
                      SEP #$20                                  ;;82C4|82C4+82C4/82C4\82C4; Accum (8 bit) 
                      STA.B !_4                                 ;;82C6|82C6+82C6/82C6\82C6;
                      LDX.B #$01                                ;;82C8|82C8+82C8/82C8\82C8;
                      CMP.B !_5                                 ;;82CA|82CA+82CA/82CA\82CA;
                      BCS +                                     ;;82CC|82CC+82CC/82CC\82CC;
                      DEX                                       ;;82CE|82CE+82CE/82CE\82CE;
                      LDA.B !_5                                 ;;82CF|82CF+82CF/82CF\82CF;
                    + CMP.B #$02                                ;;82D1|82D1+82D1/82D1\82D1;
                      BCS +                                     ;;82D3|82D3+82D3/82D3\82D3;
                      REP #$20                                  ;;82D5|82D5+82D5/82D5\82D5; Accum (16 bit) 
                      LDA.W !OverworldFreeCamXPos               ;;82D7|82D7+82D7/82D7\82D7;
                      STA.B !Layer1XPos                         ;;82DA|82DA+82DA/82DA\82DA;
                      STA.B !Layer2XPos                         ;;82DC|82DC+82DC/82DC\82DC;
                      LDA.W !OverworldFreeCamYPos               ;;82DE|82DE+82DE/82DE\82DE;
                      STA.B !Layer1YPos                         ;;82E1|82E1+82E1/82E1\82E1;
                      STA.B !Layer2YPos                         ;;82E3|82E3+82E3/82E3\82E3;
                      SEP #$20                                  ;;82E5|82E5+82E5/82E5\82E5; Accum (8 bit) 
                      STZ.W !PauseFlag                          ;;82E7|82E7+82E7/82E7\82E7;
                      JMP CODE_0483BD                           ;;82EA|82EA+82EA/82EA\82EA;
                                                                ;;                        ;
                    + STZ.W !HW_WRDIV                           ;;82ED|82ED+82ED/82ED\82ED; Dividend (Low Byte)
                      LDY.B !_4,X                               ;;82F0|82F0+82F0/82F0\82F0;
                      STY.W !HW_WRDIV+1                         ;;82F2|82F2+82F2/82F2\82F2; Dividend (High-Byte)
                      STA.W !HW_WRDIV+2                         ;;82F5|82F5+82F5/82F5\82F5; Divisor B
                      NOP                                       ;;82F8|82F8+82F8/82F8\82F8; \ 
                      NOP                                       ;;82F9|82F9+82F9/82F9\82F9;  | 
                      NOP                                       ;;82FA|82FA+82FA/82FA\82FA;  |Makes you wonder what used to be here... 
                      NOP                                       ;;82FB|82FB+82FB/82FB\82FB;  | 
                      NOP                                       ;;82FC|82FC+82FC/82FC\82FC;  | 
                      NOP                                       ;;82FD|82FD+82FD/82FD\82FD; / 
                      REP #$20                                  ;;82FE|82FE+82FE/82FE\82FE; Accum (16 bit) 
                      LDA.W !HW_RDDIV                           ;;8300|8300+8300/8300\8300; Quotient of Divide Result (Low Byte)
                      LSR A                                     ;;8303|8303+8303/8303\8303;
                      LSR A                                     ;;8304|8304+8304/8304\8304;
                      SEP #$20                                  ;;8305|8305+8305/8305\8305; Accum (8 bit) 
                      LDY.B !_1,X                               ;;8307|8307+8307/8307\8307;
                      BPL +                                     ;;8309|8309+8309/8309\8309;
                      EOR.B #$FF                                ;;830B|830B+830B/830B\830B;
                      INC A                                     ;;830D|830D+830D/830D\830D;
                    + STA.B !_1,X                               ;;830E|830E+830E/830E\830E;
                      TXA                                       ;;8310|8310+8310/8310\8310;
                      EOR.B #$01                                ;;8311|8311+8311/8311\8311;
                      TAX                                       ;;8313|8313+8313/8313\8313;
                      LDA.B #$40                                ;;8314|8314+8314/8314\8314;
                      LDY.B !_1,X                               ;;8316|8316+8316/8316\8316;
                      BPL +                                     ;;8318|8318+8318/8318\8318;
                      LDA.B #$C0                                ;;831A|831A+831A/831A\831A;
                    + STA.B !_1,X                               ;;831C|831C+831C/831C\831C;
                      LDY.B #$01                                ;;831E|831E+831E/831E\831E;
CODE_048320:          TYA                                       ;;8320|8320+8320/8320\8320;
                      ASL A                                     ;;8321|8321+8321/8321\8321;
                      TAX                                       ;;8322|8322+8322/8322\8322;
                      LDA.W !_1,Y                               ;;8323|8323+8323/8323\8323;
                      ASL A                                     ;;8326|8326+8326/8326\8326;
                      ASL A                                     ;;8327|8327+8327/8327\8327;
                      ASL A                                     ;;8328|8328+8328/8328\8328;
                      ASL A                                     ;;8329|8329+8329/8329\8329;
                      CLC                                       ;;832A|832A+832A/832A\832A;
                      ADC.W !Layer1PosSpx,Y                     ;;832B|832B+832B/832B\832B;
                      STA.W !Layer1PosSpx,Y                     ;;832E|832E+832E/832E\832E;
                      LDA.W !_1,Y                               ;;8331|8331+8331/8331\8331;
                      PHY                                       ;;8334|8334+8334/8334\8334;
                      PHP                                       ;;8335|8335+8335/8335\8335;
                      LSR A                                     ;;8336|8336+8336/8336\8336;
                      LSR A                                     ;;8337|8337+8337/8337\8337;
                      LSR A                                     ;;8338|8338+8338/8338\8338;
                      LSR A                                     ;;8339|8339+8339/8339\8339;
                      LDY.B #$00                                ;;833A|833A+833A/833A\833A;
                      PLP                                       ;;833C|833C+833C/833C\833C;
                      BPL +                                     ;;833D|833D+833D/833D\833D;
                      ORA.B #$F0                                ;;833F|833F+833F/833F\833F;
                      DEY                                       ;;8341|8341+8341/8341\8341;
                    + ADC.B !Layer1XPos,X                       ;;8342|8342+8342/8342\8342;
                      STA.B !Layer1XPos,X                       ;;8344|8344+8344/8344\8344;
                      STA.B !Layer2XPos,X                       ;;8346|8346+8346/8346\8346;
                      TYA                                       ;;8348|8348+8348/8348\8348;
                      ADC.B !Layer1XPos+1,X                     ;;8349|8349+8349/8349\8349;
                      STA.B !Layer1XPos+1,X                     ;;834B|834B+834B/834B\834B;
                      STA.B !Layer2XPos+1,X                     ;;834D|834D+834D/834D\834D;
                      PLY                                       ;;834F|834F+834F/834F\834F;
                      DEY                                       ;;8350|8350+8350/8350\8350;
                      BPL CODE_048320                           ;;8351|8351+8351/8351\8351;
                      JMP CODE_04840D                           ;;8353|8353+8353/8353\8353;
                                                                ;;                        ;
CODE_048356:          LDA.W !OverworldProcess                   ;;8356|8356+8356/8356\8356;
                      CMP.B #$03                                ;;8359|8359+8359/8359\8359;
                      BEQ CODE_048366                           ;;835B|835B+835B/835B\835B;
                      CMP.B #$04                                ;;835D|835D+835D/835D\835D;
                      BNE CODE_04839A                           ;;835F|835F+835F/835F\835F;
                      LDA.W !PlayerSwitching                    ;;8361|8361+8361/8361\8361;
                      BNE CODE_04839A                           ;;8364|8364+8364/8364\8364;
CODE_048366:                                                    ;;                        ;
                   if ver_is_console(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; J, U, E0, & E1
                      LDA.W !axlr0000P1Frame                    ;;8366|8366     /8366\8366;
                      ORA.W !axlr0000P2Frame                    ;;8369|8369     /8369\8369;
                      AND.B #$30                                ;;836C|836C     /836C\836C;
                      BEQ +                                     ;;836E|836E     /836E\836E;
                      LDA.B #$01                                ;;8370|8370     /8370\8370;
                      STA.W !OverworldPromptProcess             ;;8372|8372     /8372\8372;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                    + LDX.W !PlayerTurnLvl                      ;;8375|8375+8366/8375\8375;
                      LDA.W !OWPlayerSubmap,X                   ;;8378|8378+8369/8378\8378;
                      BNE CODE_04839A                           ;;837B|837B+836C/837B\837B;
                      LDA.B !byetudlrFrame                      ;;837D|837D+836E/837D\837D;
                      AND.B #$10                                ;;837F|837F+8370/837F\837F;
                      BEQ CODE_04839A                           ;;8381|8381+8372/8381\8381;
                      INC.W !PauseFlag                          ;;8383|8383+8374/8383\8383; Look around overworld 
                      LDA.W !PauseFlag                          ;;8386|8386+8377/8386\8386;
                      LSR A                                     ;;8389|8389+837A/8389\8389;
                      BNE CODE_04839A                           ;;838A|838A+837B/838A\838A;
                      REP #$20                                  ;;838C|838C+837D/838C\838C; Accum (16 bit) 
                      LDA.B !Layer1XPos                         ;;838E|838E+837F/838E\838E;
                      STA.W !OverworldFreeCamXPos               ;;8390|8390+8381/8390\8390;
                      LDA.B !Layer1YPos                         ;;8393|8393+8384/8393\8393;
                      STA.W !OverworldFreeCamYPos               ;;8395|8395+8386/8395\8395;
                      SEP #$20                                  ;;8398|8398+8389/8398\8398; Accum (8 bit) 
CODE_04839A:          LDA.W !PauseFlag                          ;;839A|839A+838B/839A\839A;
                      BEQ CODE_0483C3                           ;;839D|839D+838E/839D\839D;
                      LDX.B #$00                                ;;839F|839F+8390/839F\839F;
                      LDA.B !byetudlrHold                       ;;83A1|83A1+8392/83A1\83A1;
                      AND.B #$03                                ;;83A3|83A3+8394/83A3\83A3;
                      ASL A                                     ;;83A5|83A5+8396/83A5\83A5;
                      JSR OWFreeLook                            ;;83A6|83A6+8397/83A6\83A6;
                      LDX.B #$02                                ;;83A9|83A9+839A/83A9\83A9;
                      LDA.B !byetudlrHold                       ;;83AB|83AB+839C/83AB\83AB;
                      AND.B #$0C                                ;;83AD|83AD+839E/83AD\83AD;
                      ORA.B #$10                                ;;83AF|83AF+83A0/83AF\83AF;
                      LSR A                                     ;;83B1|83B1+83A2/83B1\83B1;
                      JSR OWFreeLook                            ;;83B2|83B2+83A3/83B2\83B2;
                      LDY.B #$15                                ;;83B5|83B5+83A6/83B5\83B5;
                      LDA.B !TrueFrame                          ;;83B7|83B7+83A8/83B7\83B7;
                      AND.B #$18                                ;;83B9|83B9+83AA/83B9\83B9;
                      BNE +                                     ;;83BB|83BB+83AC/83BB\83BB;
CODE_0483BD:          LDY.B #$18                                ;;83BD|83BD+83AE/83BD\83BD;
                    + STY.B !StripeImage                        ;;83BF|83BF+83B0/83BF\83BF;
                      BRA CODE_04840D                           ;;83C1|83C1+83B2/83C1\83C1;
                                                                ;;                        ;
CODE_0483C3:          LDX.W !OverworldEarthquake                ;;83C3|83C3+83B4/83C3\83C3;
                      BEQ CODE_04840A                           ;;83C6|83C6+83B7/83C6\83C6;
                      CPX.B #$FE                                ;;83C8|83C8+83B9/83C8\83C8;
                      BNE +                                     ;;83CA|83CA+83BB/83CA\83CA;
                      LDA.B #!SFX_RUMBLINGON                    ;;83CC|83CC+83BD/83CC\83CC;
                      STA.W !SPCIO0                             ;;83CE|83CE+83BF/83CE\83CE; / Play sound effect 
                      LDA.B #!BGM_VALLEYOPENS                   ;;83D1|83D1+83C2/83D1\83D1;
                      STA.W !SPCIO2                             ;;83D3|83D3+83C4/83D3\83D3; / Change music 
                    + TXA                                       ;;83D6|83D6+83C7/83D6\83D6;
                      LSR A                                     ;;83D7|83D7+83C8/83D7\83D7;
                      LSR A                                     ;;83D8|83D8+83C9/83D8\83D8;
                      LSR A                                     ;;83D9|83D9+83CA/83D9\83D9;
                      LSR A                                     ;;83DA|83DA+83CB/83DA\83DA;
                      TAY                                       ;;83DB|83DB+83CC/83DB\83DB;
                      LDA.B !TrueFrame                          ;;83DC|83DC+83CD/83DC\83DC;
                      AND.W DATA_048231,Y                       ;;83DE|83DE+83CF/83DE\83DE;
                      BNE +                                     ;;83E1|83E1+83D2/83E1\83E1;
                      LDA.B !Layer1XPos                         ;;83E3|83E3+83D4/83E3\83E3;
                      EOR.B #$01                                ;;83E5|83E5+83D6/83E5\83E5;
                      STA.B !Layer1XPos                         ;;83E7|83E7+83D8/83E7\83E7;
                      STA.B !Layer2XPos                         ;;83E9|83E9+83DA/83E9\83E9;
                      LDA.B !Layer1YPos                         ;;83EB|83EB+83DC/83EB\83EB;
                      EOR.B #$01                                ;;83ED|83ED+83DE/83ED\83ED;
                      STA.B !Layer1YPos                         ;;83EF|83EF+83E0/83EF\83EF;
                      STA.B !Layer2YPos                         ;;83F1|83F1+83E2/83F1\83F1;
                    + CPX.B #$80                                ;;83F3|83F3+83E4/83F3\83F3;
                      BCS CODE_0483FE                           ;;83F5|83F5+83E6/83F5\83F5;
                      LDA.W !OverworldProcess                   ;;83F7|83F7+83E8/83F7\83F7;
                      CMP.B #$02                                ;;83FA|83FA+83EB/83FA\83FA;
                      BNE CODE_04840A                           ;;83FC|83FC+83ED/83FC\83FC;
CODE_0483FE:          DEC.W !OverworldEarthquake                ;;83FE|83FE+83EF/83FE\83FE;
                      BNE CODE_04840D                           ;;8401|8401+83F2/8401\8401;
                      LDA.B #!SFX_RUMBLINGOFF                   ;;8403|8403+83F4/8403\8403;
                      STA.W !SPCIO0                             ;;8405|8405+83F6/8405\8405; / Play sound effect 
                      BRA CODE_04840D                           ;;8408|8408+83F9/8408\8408;
                                                                ;;                        ;
CODE_04840A:          JSR CODE_048576                           ;;840A|840A+83FB/840A\840A;
CODE_04840D:          JSR CODE_04F708                           ;;840D|840D+83FE/840D\840D;
CODE_048410:          JSR CODE_04862E                           ;;8410|8410+8401/8410\8410;
CODE_048413:          PLB                                       ;;8413|8413+8404/8413\8413;
                      RTL                                       ;;8414|8414+8405/8414\8414; Return 
                                                                ;;                        ;
OWFreeLook:           TAY                                       ;;8415|8415+8406/8415\8415; A=$2,X=$0 for right; A=$4,X=$0 for left; A=$A,X=$2 for down; A=$C,X=$2 for up
                      REP #$20                                  ;;8416|8416+8407/8416\8416; Accum (16 bit) 
                      LDA.B !Layer1XPos,X                       ;;8418|8418+8409/8418\8418; \
                      CLC                                       ;;841A|841A+840B/841A\841A; | Add appropriate offset to X/Y position
                      ADC.W OWScrollSpeed,Y                     ;;841B|841B+840C/841B\841B; / (+$0002 or +$FFFE)
                      PHA                                       ;;841E|841E+840F/841E\841E; \
                      SEC                                       ;;841F|841F+8410/841F\841F; |
                      SBC.W OWMaxScrollRange,Y                  ;;8420|8420+8411/8420\8420; | If we go beyond the max scroll range
                      EOR.W OWScrollSpeed,Y                     ;;8423|8423+8414/8423\8423; | Don't change the scroll
                      ASL A                                     ;;8426|8426+8417/8426\8426; |
                      PLA                                       ;;8427|8427+8418/8427\8427; |
                      BCC +                                     ;;8428|8428+8419/8428\8428; /
                      STA.B !Layer1XPos,X                       ;;842A|842A+841B/842A\842A;
                      STA.B !Layer2XPos,X                       ;;842C|842C+841D/842C\842C;
                    + SEP #$20                                  ;;842E|842E+841F/842E\842E; Accum (8 bit) 
                      RTS                                       ;;8430|8430+8421/8430\8430; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_048431:          db $11,$00,$0A,$00,$09,$00,$0B,$00        ;;8431|8431+8422/8431\8431;
                      db $12,$00,$0A,$00,$07,$00,$0A,$02        ;;8439|8439+842A/8439\8439;
                      db $03,$02,$10,$04,$12,$04,$1C,$04        ;;8441|8441+8432/8441\8441;
                      db $14,$04,$12,$06,$00,$02,$12,$06        ;;8449|8449+843A/8449\8449;
                      db $10,$00,$17,$06,$14,$00,$1C,$06        ;;8451|8451+8442/8451\8451;
                      db $14,$00,$1C,$06,$17,$06,$11,$05        ;;8459|8459+844A/8459\8459;
                      db $11,$05,$14,$04,$06,$01                ;;8461|8461+8452/8461\8461;
                                                                ;;                        ;
DATA_048467:          db $07,$00,$03,$00,$10,$00,$0E,$00        ;;8467|8467+8458/8467\8467;
                      db $17,$00,$18,$00,$12,$00,$14,$00        ;;846F|846F+8460/846F\846F;
                      db $0B,$00,$03,$00,$01,$00,$09,$00        ;;8477|8477+8468/8477\8477;
                      db $09,$00,$1D,$00,$0E,$00,$18,$00        ;;847F|847F+8470/847F\847F;
                      db $0F,$00,$16,$00,$10,$00,$18,$00        ;;8487|8487+8478/8487\8487;
                      db $02,$00,$1D,$00,$18,$00,$13,$00        ;;848F|848F+8480/848F\848F;
                      db $11,$00,$03,$00,$07,$00                ;;8497|8497+8488/8497\8497;
                                                                ;;                        ;
DATA_04849D:          db $A8,$04,$38,$04,$08,$09,$28,$09        ;;849D|849D+848E/849D\849D;
                      db $C8,$09,$48,$09,$28,$0D,$18,$01        ;;84A5|84A5+8496/84A5\84A5;
                      db $A8,$00,$98,$00,$B8,$00,$28,$01        ;;84AD|84AD+849E/84AD\84AD;
                      db $A8,$00,$78,$00,$28,$0D,$08,$04        ;;84B5|84B5+84A6/84B5\84B5;
                      db $78,$0D,$08,$01,$C8,$0D,$48,$01        ;;84BD|84BD+84AE/84BD\84BD;
                      db $C8,$0D,$48,$09,$18,$0B,$78,$0D        ;;84C5|84C5+84B6/84C5\84C5;
                      db $68,$02,$C8,$0D,$28,$0D                ;;84CD|84CD+84BE/84CD\84CD;
                                                                ;;                        ;
DATA_0484D3:          db $48,$01,$B8,$00,$38,$00,$18,$00        ;;84D3|84D3+84C4/84D3\84D3;
                      db $98,$00,$98,$00,$D8,$01,$78,$00        ;;84DB|84DB+84CC/84DB\84DB;
                      db $38,$00,$08,$01,$E8,$00,$78,$01        ;;84E3|84E3+84D4/84E3\84E3;
                      db $88,$01,$28,$01,$88,$01,$E8,$00        ;;84EB|84EB+84DC/84EB\84EB;
                      db $68,$01,$F8,$00,$88,$01,$08,$01        ;;84F3|84F3+84E4/84F3\84F3;
                      db $D8,$01,$38,$00,$38,$01,$88,$01        ;;84FB|84FB+84EC/84FB\84FB;
                      db $78,$00,$D8,$01,$D8,$01                ;;8503|8503+84F4/8503\8503;
                                                                ;;                        ;
CODE_048509:          LDY.W !PlayerTurnLvl                      ;;8509|8509+84FA/8509\8509; \ Get current player's submap 
                      LDA.W !OWPlayerSubmap,Y                   ;;850C|850C+84FD/850C\850C; / 
                      STA.B !_1                                 ;;850F|850F+8500/850F\850F; Store it in $01 
                      STZ.B !_0                                 ;;8511|8511+8502/8511\8511; Store x00 in $00 
                      REP #$20                                  ;;8513|8513+8504/8513\8513; 16 bit A ; Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;8515|8515+8506/8515\8515; Set X to Current character*4 
                      LDY.B #$34                                ;;8518|8518+8509/8518\8518; Set Y to x34 
CODE_04851A:          LDA.W DATA_048431,Y                       ;;851A|851A+850B/851A\851A;
                      EOR.B !_0                                 ;;851D|851D+850E/851D\851D;
                      CMP.W #$0200                              ;;851F|851F+8510/851F\851F;
                      BCS CODE_048531                           ;;8522|8522+8513/8522\8522;
                      CMP.W !OWPlayerXPosPtr,X                  ;;8524|8524+8515/8524\8524;
                      BNE CODE_048531                           ;;8527|8527+8518/8527\8527;
                      LDA.W !OWPlayerYPosPtr,X                  ;;8529|8529+851A/8529\8529;
                      CMP.W DATA_048467,Y                       ;;852C|852C+851D/852C\852C;
                      BEQ CODE_048535                           ;;852F|852F+8520/852F\852F;
CODE_048531:          DEY                                       ;;8531|8531+8522/8531\8531;
                      DEY                                       ;;8532|8532+8523/8532\8532;
                      BPL CODE_04851A                           ;;8533|8533+8524/8533\8533;
CODE_048535:          STY.W !StarWarpIndex                      ;;8535|8535+8526/8535\8535; Store Y in "Warp destination" 
                      SEP #$20                                  ;;8538|8538+8529/8538\8538; 8 bit A ; Accum (8 bit) 
                      RTS                                       ;;853A|853A+852B/853A\853A; Return 
                                                                ;;                        ;
CODE_04853B:          PHB                                       ;;853B|853B+852C/853B\853B;
                      PHK                                       ;;853C|853C+852D/853C\853C;
                      PLB                                       ;;853D|853D+852E/853D\853D;
                      REP #$20                                  ;;853E|853E+852F/853E\853E; Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;8540|8540+8531/8540\8540;
                      LDY.W !StarWarpIndex                      ;;8543|8543+8534/8543\8543;
                      LDA.W DATA_04849D,Y                       ;;8546|8546+8537/8546\8546;
                      PHA                                       ;;8549|8549+853A/8549\8549;
                      AND.W #$01FF                              ;;854A|854A+853B/854A\854A;
                      STA.W !OWPlayerXPos,X                     ;;854D|854D+853E/854D\854D;
                      LSR A                                     ;;8550|8550+8541/8550\8550;
                      LSR A                                     ;;8551|8551+8542/8551\8551;
                      LSR A                                     ;;8552|8552+8543/8552\8552;
                      LSR A                                     ;;8553|8553+8544/8553\8553;
                      STA.W !OWPlayerXPosPtr,X                  ;;8554|8554+8545/8554\8554;
                      LDA.W DATA_0484D3,Y                       ;;8557|8557+8548/8557\8557;
                      STA.W !OWPlayerYPos,X                     ;;855A|855A+854B/855A\855A;
                      LSR A                                     ;;855D|855D+854E/855D\855D;
                      LSR A                                     ;;855E|855E+854F/855E\855E;
                      LSR A                                     ;;855F|855F+8550/855F\855F;
                      LSR A                                     ;;8560|8560+8551/8560\8560;
                      STA.W !OWPlayerYPosPtr,X                  ;;8561|8561+8552/8561\8561;
                      PLA                                       ;;8564|8564+8555/8564\8564;
                      LSR A                                     ;;8565|8565+8556/8565\8565;
                      XBA                                       ;;8566|8566+8557/8566\8566;
                      AND.W #$000F                              ;;8567|8567+8558/8567\8567;
                      STA.W !CurrentSubmap                      ;;856A|856A+855B/856A\856A;
                      REP #$10                                  ;;856D|856D+855E/856D\856D; Index (16 bit) 
                      JSR CODE_049A93                           ;;856F|856F+8560/856F\856F;
                      SEP #$30                                  ;;8572|8572+8563/8572\8572; Index (8 bit) Accum (8 bit) 
                      PLB                                       ;;8574|8574+8565/8574\8574;
                      RTL                                       ;;8575|8575+8566/8575\8575; Return 
                                                                ;;                        ;
CODE_048576:          LDA.W !OverworldProcess                   ;;8576|8576+8567/8576\8576;
                      JSL ExecutePtrLong                        ;;8579|8579+856A/8579\8579;
                                                                ;;                        ;
                      dl CODE_048EF1                            ;;857D|857D+856E/857D\857D;
                      dl CODE_04E570                            ;;8580|8580+8571/8580\8580;
                      dl CODE_048F87                            ;;8583|8583+8574/8583\8583;
                      dl CODE_049120                            ;;8586|8586+8577/8586\8586;
                      dl CODE_04945D                            ;;8589|8589+857A/8589\8589;
                      dl CODE_049D9A                            ;;858C|858C+857D/858C\858C;
                      dl CODE_049E22                            ;;858F|858F+8580/858F\858F;
                      dl CODE_049DD1                            ;;8592|8592+8583/8592\8592;
                      dl CODE_049E22                            ;;8595|8595+8586/8595\8595;
                      dl CODE_049E4C                            ;;8598|8598+8589/8598\8598;
                      dl CODE_04DAEF                            ;;859B|859B+858C/859B\859B;
                      dl CODE_049E52                            ;;859E|859E+858F/859E\859E;
                      dl CODE_0498C6                            ;;85A1|85A1+8592/85A1\85A1;
                                                                ;;                        ;
DrawOWBoarder_:       JSR CODE_04862E                           ;;85A4|85A4+8595/85A4\85A4;
CODE_0485A7:          REP #$20                                  ;;85A7|85A7+8598/85A7\85A7; Accum (16 bit) 
                      LDA.W #$001E                              ;;85A9|85A9+859A/85A9\85A9; \ Mario X postion = #$001E 
                      CLC                                       ;;85AC|85AC+859D/85AC\85AC;  | (On overworld boarder) 
                      ADC.B !Layer1XPos                         ;;85AD|85AD+859E/85AD\85AD;  | 
                      STA.B !PlayerXPosNext                     ;;85AF|85AF+85A0/85AF\85AF; / 
                      LDA.W #$0006                              ;;85B1|85B1+85A2/85B1\85B1; \ Mario Y postion = #$0006 
                      CLC                                       ;;85B4|85B4+85A5/85B4\85B4;  | (On overworld boarder) 
                      ADC.B !Layer1YPos                         ;;85B5|85B5+85A6/85B5\85B5;  | 
                      STA.B !PlayerYPosNext                     ;;85B7|85B7+85A8/85B7\85B7; / 
                      SEP #$20                                  ;;85B9|85B9+85AA/85B9\85B9; Accum (8 bit) 
                      LDA.B #$08                                ;;85BB|85BB+85AC/85BB\85BB;
                      STA.W !PlayerXSpeed                       ;;85BD|85BD+85AE/85BD\85BD;
                      PHB                                       ;;85C0|85C0+85B1/85C0\85C0;
                      LDA.B #$00                                ;;85C1|85C1+85B2/85C1\85C1;
                      PHA                                       ;;85C3|85C3+85B4/85C3\85C3;
                      PLB                                       ;;85C4|85C4+85B5/85C4\85C4;
                      JSL CODE_00CEB1                           ;;85C5|85C5+85B6/85C5\85C5;
                      PLB                                       ;;85C9|85C9+85BA/85C9\85C9;
                      LDA.B #$03                                ;;85CA|85CA+85BB/85CA\85CA;
                      STA.W !PlayerBehindNet                    ;;85CC|85CC+85BD/85CC\85CC;
                      JSL CODE_00E2BD                           ;;85CF|85CF+85C0/85CF\85CF;
                      LDA.B #$06                                ;;85D3|85D3+85C4/85D3\85D3;
                      STA.W !PlayerGfxTileCount                 ;;85D5|85D5+85C6/85D5\85D5;
                      LDA.W !PlayerAniTimer                     ;;85D8|85D8+85C9/85D8\85D8;
                      BEQ +                                     ;;85DB|85DB+85CC/85DB\85DB;
                      DEC.W !PlayerAniTimer                     ;;85DD|85DD+85CE/85DD\85DD;
                    + LDA.W !CapeAniTimer                       ;;85E0|85E0+85D1/85E0\85E0;
                      BEQ +                                     ;;85E3|85E3+85D4/85E3\85E3;
                      DEC.W !CapeAniTimer                       ;;85E5|85E5+85D6/85E5\85E5;
                    + LDA.B #$18                                ;;85E8|85E8+85D9/85E8\85E8;
                      STA.B !_0                                 ;;85EA|85EA+85DB/85EA\85EA;
                      LDA.B #$07                                ;;85EC|85EC+85DD/85EC\85EC;
                      STA.B !_1                                 ;;85EE|85EE+85DF/85EE\85EE;
                      LDY.B #$00                                ;;85F0|85F0+85E1/85F0\85F0;
                      TYX                                       ;;85F2|85F2+85E3/85F2\85F2;
CODE_0485F3:          LDA.B !_0                                 ;;85F3|85F3+85E4/85F3\85F3;
                      STA.W !OAMTileXPos,X                      ;;85F5|85F5+85E6/85F5\85F5;
                      CLC                                       ;;85F8|85F8+85E9/85F8\85F8;
                      ADC.B #$08                                ;;85F9|85F9+85EA/85F9\85F9;
                      STA.B !_0                                 ;;85FB|85FB+85EC/85FB\85FB;
                      LDA.B !_1                                 ;;85FD|85FD+85EE/85FD\85FD;
                      STA.W !OAMTileYPos,X                      ;;85FF|85FF+85F0/85FF\85FF;
                      LDA.B #$7E                                ;;8602|8602+85F3/8602\8602;
                      STA.W !OAMTileNo,X                        ;;8604|8604+85F5/8604\8604;
                      LDA.B #$36                                ;;8607|8607+85F8/8607\8607;
                      STA.W !OAMTileAttr,X                      ;;8609|8609+85FA/8609\8609;
                      PHX                                       ;;860C|860C+85FD/860C\860C;
                      TYX                                       ;;860D|860D+85FE/860D\860D;
                      LDA.B #$00                                ;;860E|860E+85FF/860E\860E;
                      STA.W !OAMTileSize,X                      ;;8610|8610+8601/8610\8610;
                      PLX                                       ;;8613|8613+8604/8613\8613;
                      INY                                       ;;8614|8614+8605/8614\8614;
                      TYA                                       ;;8615|8615+8606/8615\8615;
                      AND.B #$03                                ;;8616|8616+8607/8616\8616;
                      BNE +                                     ;;8618|8618+8609/8618\8618;
                      LDA.B #$18                                ;;861A|861A+860B/861A\861A;
                      STA.B !_0                                 ;;861C|861C+860D/861C\861C;
                      LDA.B !_1                                 ;;861E|861E+860F/861E\861E;
                      CLC                                       ;;8620|8620+8611/8620\8620;
                      ADC.B #$08                                ;;8621|8621+8612/8621\8621;
                      STA.B !_1                                 ;;8623|8623+8614/8623\8623;
                    + INX                                       ;;8625|8625+8616/8625\8625;
                      INX                                       ;;8626|8626+8617/8626\8626;
                      INX                                       ;;8627|8627+8618/8627\8627;
                      INX                                       ;;8628|8628+8619/8628\8628;
                      CPY.B #$10                                ;;8629|8629+861A/8629\8629;
                      BNE CODE_0485F3                           ;;862B|862B+861C/862B\862B;
                      RTS                                       ;;862D|862D+861E/862D\862D; Return 
                                                                ;;                        ;
CODE_04862E:          REP #$30                                  ;;862E|862E+861F/862E\862E; Index (16 bit) Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;8630|8630+8621/8630\8630; X = player x 4
                      LDA.W !OWPlayerXPos,X                     ;;8633|8633+8624/8633\8633; A = player X-pos on OW
                      SEC                                       ;;8636|8636+8627/8636\8636; 
                      SBC.B !Layer1XPos                         ;;8637|8637+8628/8637\8637; A = X-pos on screen
                      CMP.W #$0100                              ;;8639|8639+862A/8639\8639; 
                      BCS CODE_04864D                           ;;863C|863C+862D/863C\863C; \ if < #$0100
                      STA.B !_0                                 ;;863E|863E+862F/863E\863E; | $00 = X-pos on screen
                      STA.B !_8                                 ;;8640|8640+8631/8640\8640; | $08 = X-pos on screen
                      LDA.W !OWPlayerYPos,X                     ;;8642|8642+8633/8642\8642; | A = player Y-pos on OW
                      SEC                                       ;;8645|8645+8636/8645\8645; |
                      SBC.B !Layer1YPos                         ;;8646|8646+8637/8646\8646; | A = Y-pos on screen
                      CMP.W #$0100                              ;;8648|8648+8639/8648\8648; |
                      BCC +                                     ;;864B|864B+863C/864B\864B; /
CODE_04864D:          LDA.W #$00F0                              ;;864D|864D+863E/864D\864D; \ 
                    + STA.B !_2                                 ;;8650|8650+8641/8650\8650; | $02 = Y-pos on screen
                      STA.B !_A                                 ;;8652|8652+8643/8652\8652; / $0A = Y-pos on screen
                      TXA                                       ;;8654|8654+8645/8654\8654; A = player x 4
                      EOR.W #$0004                              ;;8655|8655+8646/8655\8655; A = other player x 4
                      TAX                                       ;;8658|8658+8649/8658\8658; X = other player x 4
                      LDA.W !OWPlayerXPos,X                     ;;8659|8659+864A/8659\8659; \
                      SEC                                       ;;865C|865C+864D/865C\865C; | (same as above, but for luigi)
                      SBC.B !Layer1XPos                         ;;865D|865D+864E/865D\865D; |
                      CMP.W #$0100                              ;;865F|865F+8650/865F\865F; |
                      BCS CODE_048673                           ;;8662|8662+8653/8662\8662; |
                      STA.B !_4                                 ;;8664|8664+8655/8664\8664; | $04 = X-pos on screen
                      STA.B !_C                                 ;;8666|8666+8657/8666\8666; | $0C = X-pos on screen
                      LDA.W !OWPlayerYPos,X                     ;;8668|8668+8659/8668\8668; |
                      SEC                                       ;;866B|866B+865C/866B\866B; |
                      SBC.B !Layer1YPos                         ;;866C|866C+865D/866C\866C; |
                      CMP.W #$0100                              ;;866E|866E+865F/866E\866E; |
                      BCC +                                     ;;8671|8671+8662/8671\8671; |
CODE_048673:          LDA.W #$00F0                              ;;8673|8673+8664/8673\8673; |
                    + STA.B !_6                                 ;;8676|8676+8667/8676\8676; | $06 = Y-pos on screen
                      STA.B !_E                                 ;;8678|8678+8669/8678\8678; / $0E = Y-pos on screen
                      SEP #$30                                  ;;867A|867A+866B/867A\867A; Index (8 bit) Accum (8 bit) 
                      LDA.B !_0                                 ;;867C|867C+866D/867C\867C;
                      SEC                                       ;;867E|867E+866F/867E\867E;
                      SBC.B #$08                                ;;867F|867F+8670/867F\867F; subtract 8 from 1P X-pos
                      STA.B !_0                                 ;;8681|8681+8672/8681\8681; $00 = 1P X-pos on screen
                      LDA.B !_2                                 ;;8683|8683+8674/8683\8683;
                      SEC                                       ;;8685|8685+8676/8685\8685;
                      SBC.B #$09                                ;;8686|8686+8677/8686\8686; subtract 9 from 1P Y-pos
                      STA.B !_1                                 ;;8688|8688+8679/8688\8688; $01 = 1P Y-pos on screen
                      LDA.B !_4                                 ;;868A|868A+867B/868A\868A;
                      SEC                                       ;;868C|868C+867D/868C\868C;
                      SBC.B #$08                                ;;868D|868D+867E/868D\868D; subtract 8 from 2P X-pos
                      STA.B !_2                                 ;;868F|868F+8680/868F\868F; $02 = 2P X-pos on screen
                      LDA.B !_6                                 ;;8691|8691+8682/8691\8691;
                      SEC                                       ;;8693|8693+8684/8693\8693;
                      SBC.B #$09                                ;;8694|8694+8685/8694\8694; subtract 9 from 2P Y-pos
                      STA.B !_3                                 ;;8696|8696+8687/8696\8696; $03 = 2P Y-pos on screen
                      LDA.B #$03                                ;;8698|8698+8689/8698\8698;
                      STA.B !GraphicsCompPtr+2                  ;;869A|869A+868B/869A\869A; $8C = #$03
                      LDA.B !_0                                 ;;869C|869C+868D/869C\869C;
                      STA.B !_6                                 ;;869E|869E+868F/869E\869E; $06 = 1P X-pos on screen
                      STA.B !GraphicsCompPtr                    ;;86A0|86A0+8691/86A0\86A0; $8A = 1P X-pos on screen
                      LDA.B !_1                                 ;;86A2|86A2+8693/86A2\86A2;
                      STA.B !_7                                 ;;86A4|86A4+8695/86A4\86A4; $07 = 1P Y-pos on screen
                      STA.B !GraphicsCompPtr+1                  ;;86A6|86A6+8697/86A6\86A6; $8B = 1P Y-pos on screen
                      LDA.W !PlayerTurnOW                       ;;86A8|86A8+8699/86A8\86A8; A = player x 4
                      LSR A                                     ;;86AB|86AB+869C/86AB\86AB; A = player x 2
                      TAY                                       ;;86AC|86AC+869D/86AC\86AC; Y = player x 2
                      LDA.W !OWPlayerAnimation,Y                ;;86AD|86AD+869E/86AD\86AD; A = player OW animation type
                      CMP.B #$12                                ;;86B0|86B0+86A1/86B0\86B0;
                      BEQ CODE_0486C5                           ;;86B2|86B2+86A3/86B2\86B2; skip if enter level in water animation
                      CMP.B #$07                                ;;86B4|86B4+86A5/86B4\86B4;
                      BCC CODE_0486BC                           ;;86B6|86B6+86A7/86B6\86B6; don't skip if moving on land
                      CMP.B #$0F                                ;;86B8|86B8+86A9/86B8\86B8;
                      BCC CODE_0486C5                           ;;86BA|86BA+86AB/86BA\86BA; skip if moving in water
CODE_0486BC:          LDA.B !GraphicsCompPtr+1                  ;;86BC|86BC+86AD/86BC\86BC;
                      SEC                                       ;;86BE|86BE+86AF/86BE\86BE;
                      SBC.B #$05                                ;;86BF|86BF+86B0/86BF\86BF; subtract 5 from Y-pos if on land
                      STA.B !GraphicsCompPtr+1                  ;;86C1|86C1+86B2/86C1\86C1; $8B = 1P Y-pos on screen
                      STA.B !_7                                 ;;86C3|86C3+86B4/86C3\86C3; $07 = 1P Y-pos on screen
CODE_0486C5:          REP #$30                                  ;;86C5|86C5+86B6/86C5\86C5; Index (16 bit) Accum (16 bit) 
                      LDA.W !PlayerTurnOW                       ;;86C7|86C7+86B8/86C7\86C7; A = player x 4
                      XBA                                       ;;86CA|86CA+86BB/86CA\86CA; A = player x #$400
                      LSR A                                     ;;86CB|86CB+86BC/86CB\86CB; A = player x #$200
                      STA.B !_4                                 ;;86CC|86CC+86BD/86CC\86CC; $04 = player x #$200
                      LDX.W #$0000                              ;;86CE|86CE+86BF/86CE\86CE; X = #$0000
                      JSR CODE_048789                           ;;86D1|86D1+86C2/86D1\86D1; draw halo if out of lives
                      LDA.W !PlayerTurnOW                       ;;86D4|86D4+86C5/86D4\86D4; A = player x 4
                      LSR A                                     ;;86D7|86D7+86C8/86D7\86D7; A = player x 2
                      TAY                                       ;;86D8|86D8+86C9/86D8\86D8; Y = player x 2
                      LDX.W #$0000                              ;;86D9|86D9+86CA/86D9\86D9; X = #$0000
                      JSR CODE_04894F                           ;;86DC|86DC+86CD/86DC\86DC;
                      SEP #$30                                  ;;86DF|86DF+86D0/86DF\86DF; Index (8 bit) Accum (8 bit) 
                      STZ.W !OAMTileSize+$27                    ;;86E1|86E1+86D2/86E1\86E1; \
                      STZ.W !OAMTileSize+$28                    ;;86E4|86E4+86D5/86E4\86E4; | make OAM tiles 8x8
                      STZ.W !OAMTileSize+$29                    ;;86E7|86E7+86D8/86E7\86E7; |
                      STZ.W !OAMTileSize+$2A                    ;;86EA|86EA+86DB/86EA\86EA; |
                      STZ.W !OAMTileSize+$2B                    ;;86ED|86ED+86DE/86ED\86ED; |
                      STZ.W !OAMTileSize+$2C                    ;;86F0|86F0+86E1/86F0\86F0; |
                      STZ.W !OAMTileSize+$2D                    ;;86F3|86F3+86E4/86F3\86F3; |
                      STZ.W !OAMTileSize+$2E                    ;;86F6|86F6+86E7/86F6\86F6; /
                      LDA.B #$03                                ;;86F9|86F9+86EA/86F9\86F9;
                      STA.B !GraphicsCompPtr+2                  ;;86FB|86FB+86EC/86FB\86FB; $8C = #$03
                      LDA.W !OWPlayerSubmap                     ;;86FD|86FD+86EE/86FD\86FD; A = 1P submap
                      LDY.W !OverworldProcess                   ;;8700|8700+86F1/8700\8700; Y = overworld process
                      CPY.B #$0A                                ;;8703|8703+86F4/8703\8703;
                      BNE +                                     ;;8705|8705+86F6/8705\8705;
                      EOR.B #$01                                ;;8707|8707+86F8/8707\8707; ??
                    + CMP.W !OWPlayerSubmap+1                   ;;8709|8709+86FA/8709\8709;
                      BNE CODE_048786                           ;;870C|870C+86FD/870C\870C; skip everything if 1P and 2P are on different submaps
                      LDA.B !_2                                 ;;870E|870E+86FF/870E\870E;
                      STA.B !_6                                 ;;8710|8710+8701/8710\8710; $06 = 2P X-pos on screen
                      STA.B !GraphicsCompPtr                    ;;8712|8712+8703/8712\8712; $8A = 2P X-pos on screen
                      LDA.B !_3                                 ;;8714|8714+8705/8714\8714;
                      STA.B !_7                                 ;;8716|8716+8707/8716\8716; $07 = 2P Y-pos on screen
                      STA.B !GraphicsCompPtr+1                  ;;8718|8718+8709/8718\8718; $8B = 2P Y-pos on screen
                      LDA.W !PlayerTurnOW                       ;;871A|871A+870B/871A\871A; A = player x 4
                      LSR A                                     ;;871D|871D+870E/871D\871D; A = player x 2
                      EOR.B #$02                                ;;871E|871E+870F/871E\871E; A = other player x 2
                      TAY                                       ;;8720|8720+8711/8720\8720; Y = other player x 2
                      LDA.W !OWPlayerAnimation,Y                ;;8721|8721+8712/8721\8721; A = other player OW animation type
                      CMP.B #$12                                ;;8724|8724+8715/8724\8724;
                      BEQ CODE_048739                           ;;8726|8726+8717/8726\8726; skip if enter level in water animation
                      CMP.B #$07                                ;;8728|8728+8719/8728\8728;
                      BCC CODE_048730                           ;;872A|872A+871B/872A\872A; don't skip if moving on land
                      CMP.B #$0F                                ;;872C|872C+871D/872C\872C;
                      BCC CODE_048739                           ;;872E|872E+871F/872E\872E; skip if moving in water
CODE_048730:          LDA.B !GraphicsCompPtr+1                  ;;8730|8730+8721/8730\8730;
                      SEC                                       ;;8732|8732+8723/8732\8732;
                      SBC.B #$05                                ;;8733|8733+8724/8733\8733; subtract 5 from Y-pos if on land
                      STA.B !GraphicsCompPtr+1                  ;;8735|8735+8726/8735\8735; $8B = 2P Y-pos on screen
                      STA.B !_7                                 ;;8737|8737+8728/8737\8737; $07 = 2P Y-pos on screen
CODE_048739:          REP #$30                                  ;;8739|8739+872A/8739\8739; Index (16 bit) Accum (16 bit) 
                      LDA.W !IsTwoPlayerGame                    ;;873B|873B+872C/873B\873B;
                      AND.W #$00FF                              ;;873E|873E+872F/873E\873E;
                      BEQ CODE_048786                           ;;8741|8741+8732/8741\8741; skip everything if we are in a 1P-game (why check that so late?)
                      LDA.B !_C                                 ;;8743|8743+8734/8743\8743;
                      CMP.W #$00F0                              ;;8745|8745+8736/8745\8745;
                      BCS CODE_048786                           ;;8748|8748+8739/8748\8748; skip if 2P is offscreen in the X direction
                      LDA.B !_E                                 ;;874A|874A+873B/874A\874A;
                      CMP.W #$00F0                              ;;874C|874C+873D/874C\874C;
                      BCS CODE_048786                           ;;874F|874F+8740/874F\874F; skip if 2P is offscreen in the Y direction
                      LDA.B !_4                                 ;;8751|8751+8742/8751\8751; A = player x #$200
                      EOR.W #$0200                              ;;8753|8753+8744/8753\8753; A = other player x #$200
                      STA.B !_4                                 ;;8756|8756+8747/8756\8756; $04 = other player x #$200
                      LDX.W #$0020                              ;;8758|8758+8749/8758\8758; X = #$0020
                      JSR CODE_048789                           ;;875B|875B+874C/875B\875B; draw halo if out of lives
                      LDA.W !PlayerTurnOW                       ;;875E|875E+874F/875E\875E; A = player x 4
                      LSR A                                     ;;8761|8761+8752/8761\8761; A = player x 2
                      EOR.W #$0002                              ;;8762|8762+8753/8762\8762; A = other player x 2
                      TAY                                       ;;8765|8765+8756/8765\8765; Y = other player x 2
                      LDX.W #$0020                              ;;8766|8766+8757/8766\8766; X = #$0020
                      JSR CODE_04894F                           ;;8769|8769+875A/8769\8769;
                      SEP #$30                                  ;;876C|876C+875D/876C\876C; Index (8 bit) Accum (8 bit) 
                      STZ.W !OAMTileSize+$2F                    ;;876E|876E+875F/876E\876E; \
                      STZ.W !OAMTileSize+$30                    ;;8771|8771+8762/8771\8771; | make OAM tiles 8x8
                      STZ.W !OAMTileSize+$31                    ;;8774|8774+8765/8774\8774; |
                      STZ.W !OAMTileSize+$32                    ;;8777|8777+8768/8777\8777; |
                      STZ.W !OAMTileSize+$33                    ;;877A|877A+876B/877A\877A; |
                      STZ.W !OAMTileSize+$34                    ;;877D|877D+876E/877D\877D; |
                      STZ.W !OAMTileSize+$35                    ;;8780|8780+8771/8780\8780; |
                      STZ.W !OAMTileSize+$36                    ;;8783|8783+8774/8783\8783; /
CODE_048786:          SEP #$30                                  ;;8786|8786+8777/8786\8786; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;8788|8788+8779/8788\8788; Return 
                                                                ;;                        ;
CODE_048789:          LDA.B !GraphicsCompPtr                    ;;8789|8789+877A/8789\8789; A = Y-pos on screen | X-pos on screen
                      PHA                                       ;;878B|878B+877C/878B\878B;
                      PHX                                       ;;878C|878C+877D/878C\878C; X = player x #$20
                      LDA.B !_4                                 ;;878D|878D+877E/878D\878D; A = player x #$200
                      XBA                                       ;;878F|878F+8780/878F\878F; A = player x 2
                      LSR A                                     ;;8790|8790+8781/8790\8790; A = player
                      TAX                                       ;;8791|8791+8782/8791\8791; X = player
                      LDA.W !SavedPlayerLives-1,X               ;;8792|8792+8783/8792\8792; A = player lives | junk
                      PLX                                       ;;8795|8795+8786/8795\8795; X = player x #$20
                      AND.W #$FF00                              ;;8796|8796+8787/8796\8796; A = player lives | #$00
                      BPL +                                     ;;8799|8799+878A/8799\8799; skip if player lives positive
                      SEP #$20                                  ;;879B|879B+878C/879B\879B; Accum (8 bit) 
                      LDA.B !GraphicsCompPtr                    ;;879D|879D+878E/879D\879D;
                      STA.W !OAMTileXPos+$B4,X                  ;;879F|879F+8790/879F\879F; OAM X-pos of 1st halo tile
                      CLC                                       ;;87A2|87A2+8793/87A2\87A2;
                      ADC.B #$08                                ;;87A3|87A3+8794/87A3\87A3;
                      STA.W !OAMTileXPos+$B8,X                  ;;87A5|87A5+8796/87A5\87A5; OAM X-pos of 2nd halo tile
                      LDA.B !GraphicsCompPtr+1                  ;;87A8|87A8+8799/87A8\87A8;
                      CLC                                       ;;87AA|87AA+879B/87AA\87AA;
                      ADC.B #$F9                                ;;87AB|87AB+879C/87AB\87AB;
                      STA.W !OAMTileYPos+$B4,X                  ;;87AD|87AD+879E/87AD\87AD; OAM Y-pos of 1st halo tile
                      STA.W !OAMTileYPos+$B8,X                  ;;87B0|87B0+87A1/87B0\87B0; OAM Y-pos of 2nd halo tile
                      LDA.B #$7C                                ;;87B3|87B3+87A4/87B3\87B3;
                      STA.W !OAMTileNo+$B4,X                    ;;87B5|87B5+87A6/87B5\87B5; OAM tile number of 1st halo tile
                      STA.W !OAMTileNo+$B8,X                    ;;87B8|87B8+87A9/87B8\87B8; OAM tile number of 2nd halo tile
                      LDA.B #$20                                ;;87BB|87BB+87AC/87BB\87BB;
                      STA.W !OAMTileAttr+$B4,X                  ;;87BD|87BD+87AE/87BD\87BD; OAM yxppccct of 1st halo tile
                      LDA.B #$60                                ;;87C0|87C0+87B1/87C0\87C0;
                      STA.W !OAMTileAttr+$B8,X                  ;;87C2|87C2+87B3/87C2\87C2; OAM yxppccct of 2nd halo tile
                      REP #$20                                  ;;87C5|87C5+87B6/87C5\87C5; Accum (16 bit) 
                    + PLA                                       ;;87C7|87C7+87B8/87C7\87C7; A = Y-pos on screen | X-pos on screen
                      STA.B !GraphicsCompPtr                    ;;87C8|87C8+87B9/87C8\87C8; $8A = X-pos on screen, $8B = Y-pos on screen
                      RTS                                       ;;87CA|87CA+87BB/87CA\87CA; Return 
                                                                ;;                        ;
                                                                ;;                        ;
OWPlayerTiles:        db $0E,$24,$0F,$24,$1E,$24,$1F,$24        ;;87CB|87CB+87BC/87CB\87CB;
                      db $20,$24,$21,$24,$30,$24,$31,$24        ;;87D3|87D3+87C4/87D3\87D3;
                      db $0E,$24,$0F,$24,$1E,$24,$1F,$24        ;;87DB|87DB+87CC/87DB\87DB;
                      db $20,$24,$21,$24,$31,$64,$30,$64        ;;87E3|87E3+87D4/87E3\87E3;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;87EB|87EB+87DC/87EB\87EB;
                      db $0C,$24,$0D,$24,$1C,$24,$1D,$24        ;;87F3|87F3+87E4/87F3\87F3;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;87FB|87FB+87EC/87FB\87FB;
                      db $0C,$24,$0D,$24,$1D,$64,$1C,$64        ;;8803|8803+87F4/8803\8803;
                      db $08,$24,$09,$24,$18,$24,$19,$24        ;;880B|880B+87FC/880B\880B;
                      db $06,$24,$07,$24,$16,$24,$17,$24        ;;8813|8813+8804/8813\8813;
                      db $08,$24,$09,$24,$18,$24,$19,$24        ;;881B|881B+880C/881B\881B;
                      db $06,$24,$07,$24,$16,$24,$17,$24        ;;8823|8823+8814/8823\8823;
                      db $09,$64,$08,$64,$19,$64,$18,$64        ;;882B|882B+881C/882B\882B;
                      db $07,$64,$06,$64,$17,$64,$16,$64        ;;8833|8833+8824/8833\8833;
                      db $09,$64,$08,$64,$19,$64,$18,$64        ;;883B|883B+882C/883B\883B;
                      db $07,$64,$06,$64,$17,$64,$16,$64        ;;8843|8843+8834/8843\8843;
                      db $0E,$24,$0F,$24,$38,$24,$38,$64        ;;884B|884B+883C/884B\884B;
                      db $20,$24,$21,$24,$39,$24,$39,$64        ;;8853|8853+8844/8853\8853;
                      db $0E,$24,$0F,$24,$38,$24,$38,$64        ;;885B|885B+884C/885B\885B;
                      db $20,$24,$21,$24,$39,$24,$39,$64        ;;8863|8863+8854/8863\8863;
                      db $0A,$24,$0B,$24,$38,$24,$38,$64        ;;886B|886B+885C/886B\886B;
                      db $0C,$24,$0D,$24,$39,$24,$39,$64        ;;8873|8873+8864/8873\8873;
                      db $0A,$24,$0B,$24,$38,$24,$38,$64        ;;887B|887B+886C/887B\887B;
                      db $0C,$24,$0D,$24,$39,$24,$39,$64        ;;8883|8883+8874/8883\8883;
                      db $08,$24,$09,$24,$38,$24,$38,$64        ;;888B|888B+887C/888B\888B;
                      db $06,$24,$07,$24,$39,$24,$39,$64        ;;8893|8893+8884/8893\8893;
                      db $08,$24,$09,$24,$38,$24,$38,$64        ;;889B|889B+888C/889B\889B;
                      db $06,$24,$07,$24,$39,$24,$39,$64        ;;88A3|88A3+8894/88A3\88A3;
                      db $09,$64,$08,$64,$38,$24,$38,$64        ;;88AB|88AB+889C/88AB\88AB;
                      db $07,$64,$06,$64,$39,$24,$39,$64        ;;88B3|88B3+88A4/88B3\88B3;
                      db $09,$64,$08,$64,$38,$24,$38,$64        ;;88BB|88BB+88AC/88BB\88BB;
                      db $07,$64,$06,$64,$39,$24,$39,$64        ;;88C3|88C3+88B4/88C3\88C3;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;88CB|88CB+88BC/88CB\88CB;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;88D3|88D3+88C4/88D3\88D3;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;88DB|88DB+88CC/88DB\88DB;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;88E3|88E3+88D4/88E3\88E3;
                      db $24,$24,$25,$24,$38,$24,$38,$64        ;;88EB|88EB+88DC/88EB\88EB;
                      db $24,$24,$25,$24,$38,$24,$38,$64        ;;88F3|88F3+88E4/88F3\88F3;
                      db $24,$24,$25,$24,$38,$24,$38,$64        ;;88FB|88FB+88EC/88FB\88FB;
                      db $24,$24,$25,$24,$38,$24,$38,$64        ;;8903|8903+88F4/8903\8903;
                      db $46,$24,$47,$24,$56,$24,$57,$24        ;;890B|890B+88FC/890B\890B;
                      db $47,$64,$46,$64,$57,$64,$56,$64        ;;8913|8913+8904/8913\8913;
                      db $46,$24,$47,$24,$56,$24,$57,$24        ;;891B|891B+890C/891B\891B;
                      db $47,$64,$46,$64,$57,$64,$56,$64        ;;8923|8923+8914/8923\8923;
                      db $46,$24,$47,$24,$56,$24,$57,$24        ;;892B|892B+891C/892B\892B;
                      db $47,$64,$46,$64,$57,$64,$56,$64        ;;8933|8933+8924/8933\8933;
                      db $46,$24,$47,$24,$56,$24,$57,$24        ;;893B|893B+892C/893B\893B;
                      db $47,$64,$46,$64,$57,$64,$56,$64        ;;8943|8943+8934/8943\8943;
OWWarpIndex:          db $20,$60,$00,$40                        ;;894B|894B+893C/894B\894B;
                                                                ;;                        ;
CODE_04894F:          SEP #$30                                  ;;894F|894F+8940/894F\894F; Index (8 bit) Accum (8 bit) 
                      PHY                                       ;;8951|8951+8942/8951\8951; Y = player x 2
                      TYA                                       ;;8952|8952+8943/8952\8952; A = player x 2
                      LSR A                                     ;;8953|8953+8944/8953\8953; A = player
                      TAY                                       ;;8954|8954+8945/8954\8954; Y = player
                      LDA.W !SavedPlayerYoshi,Y                 ;;8955|8955+8946/8955\8955; A = player's yoshi color
                      BEQ +                                     ;;8958|8958+8949/8958\8958; branch if no yoshi
                      STA.B !_E                                 ;;895A|895A+894B/895A\895A; $0E = player's yoshi color
                      STZ.B !_F                                 ;;895C|895C+894D/895C\895C; $0F = #$00
                      PLY                                       ;;895E|895E+894F/895E\895E; Y = player x 2
                      JMP CODE_048CE6                           ;;895F|895F+8950/895F\895F; jump
                                                                ;;                        ;
                    + PLY                                       ;;8962|8962+8953/8962\8962; Y = player x 2
                      REP #$30                                  ;;8963|8963+8954/8963\8963; Index (16 bit) Accum (16 bit) 
                      LDA.W !OWPlayerAnimation,Y                ;;8965|8965+8956/8965\8965; A = player OW animation type
                      ASL A                                     ;;8968|8968+8959/8968\8968;
                      ASL A                                     ;;8969|8969+895A/8969\8969;
                      ASL A                                     ;;896A|896A+895B/896A\896A;
                      ASL A                                     ;;896B|896B+895C/896B\896B; A = player OW animation type x #$10
                      STA.B !_0                                 ;;896C|896C+895D/896C\896C; $00 = player OW animation type x #$10
                      LDA.B !TrueFrame                          ;;896E|896E+895F/896E\896E; A = frame counter
                      AND.W #$0018                              ;;8970|8970+8961/8970\8970; A = 5 LSB of frame counter
                      CLC                                       ;;8973|8973+8964/8973\8973;
                      ADC.B !_0                                 ;;8974|8974+8965/8974\8974; A = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
                      TAY                                       ;;8976|8976+8967/8976\8976; Y = that index ^
                      PHX                                       ;;8977|8977+8968/8977\8977; X = player x #$20
                      LDA.B !_4                                 ;;8978|8978+8969/8978\8978; A = player x #$200
                      XBA                                       ;;897A|897A+896B/897A\897A; A = player x 2
                      LSR A                                     ;;897B|897B+896C/897B\897B; A = player
                      TAX                                       ;;897C|897C+896D/897C\897C; X = player
                      LDA.W !SavedPlayerLives-1,X               ;;897D|897D+896E/897D\897D; A = player's lives | junk
                      PLX                                       ;;8980|8980+8971/8980\8980; X = player x #$20
                      AND.W #$FF00                              ;;8981|8981+8972/8981\8981; A = player's lives | #$00
                      BPL CODE_04898B                           ;;8984|8984+8975/8984\8984; branch if player's lives positive
                      LDA.B !_0                                 ;;8986|8986+8977/8986\8986; A = player OW animation type x #$10
                      TAY                                       ;;8988|8988+8979/8988\8988; Y = player OW animation type x #$10
                      BRA CODE_0489A7                           ;;8989|8989+897A/8989\8989; branch (basically, if player is out of lives, their sprite is static)
                                                                ;;                        ;
CODE_04898B:          CPX.W #$0000                              ;;898B|898B+897C/898B\898B;
                      BNE CODE_0489A7                           ;;898E|898E+897F/898E\898E; skip if 2P
                      LDA.W !OverworldProcess                   ;;8990|8990+8981/8990\8990;
                      CMP.W #$000B                              ;;8993|8993+8984/8993\8993;
                      BNE CODE_0489A7                           ;;8996|8996+8987/8996\8996; skip if not on star warp
                      LDA.B !TrueFrame                          ;;8998|8998+8989/8998\8998; A = frame counter
                      AND.W #$000C                              ;;899A|899A+898B/899A\899A; A = 0000 ff00 (f = frame counter bits)
                      LSR A                                     ;;899D|899D+898E/899D\899D;
                      LSR A                                     ;;899E|899E+898F/899E\899E; A = 2 LSB of frame counter / 4
                      TAY                                       ;;899F|899F+8990/899F\899F; Y = 2 LSB of frame counter / 4
                      LDA.W OWWarpIndex,Y                       ;;89A0|89A0+8991/89A0\89A0; A = index to use when using a star warp (overrides that complicated thing)
                      AND.W #$00FF                              ;;89A3|89A3+8994/89A3\89A3;
                      TAY                                       ;;89A6|89A6+8997/89A6\89A6; Y = index into tilemap table
CODE_0489A7:          REP #$20                                  ;;89A7|89A7+8998/89A7\89A7; Accum (16 bit) 
                      LDA.B !GraphicsCompPtr                    ;;89A9|89A9+899A/89A9\89A9; A = Y-pos on screen | X-pos on screen 
                      STA.W !OAMTileXPos+$9C,X                  ;;89AB|89AB+899C/89AB\89AB; OAM y-pos and x-pos for tile
                      LDA.W OWPlayerTiles,Y                     ;;89AE|89AE+899F/89AE\89AE; get tile | yxppccct
                      CLC                                       ;;89B1|89B1+89A2/89B1\89B1;
                      ADC.B !_4                                 ;;89B2|89B2+89A3/89B2\89B2; add player x #$200 (increment palette of tile by 1)
                      STA.W !OAMTileNo+$9C,X                    ;;89B4|89B4+89A5/89B4\89B4; OAM tile and yxppccct for tile
                      SEP #$20                                  ;;89B7|89B7+89A8/89B7\89B7; Accum (8 bit) 
                      INX                                       ;;89B9|89B9+89AA/89B9\89B9;
                      INX                                       ;;89BA|89BA+89AB/89BA\89BA;
                      INX                                       ;;89BB|89BB+89AC/89BB\89BB;
                      INX                                       ;;89BC|89BC+89AD/89BC\89BC; increment X to next OAM tile
                      INY                                       ;;89BD|89BD+89AE/89BD\89BD;
                      INY                                       ;;89BE|89BE+89AF/89BE\89BE; increment index to tilemap table
                      LDA.B !GraphicsCompPtr                    ;;89BF|89BF+89B0/89BF\89BF;
                      CLC                                       ;;89C1|89C1+89B2/89C1\89C1;
                      ADC.B #$08                                ;;89C2|89C2+89B3/89C2\89C2; \
                      STA.B !GraphicsCompPtr                    ;;89C4|89C4+89B5/89C4\89C4; | update X and Y position of tile
                      DEC.B !GraphicsCompPtr+2                  ;;89C6|89C6+89B7/89C6\89C6; | (zig zag pattern)
                      LDA.B !GraphicsCompPtr+2                  ;;89C8|89C8+89B9/89C8\89C8; |
                      AND.B #$01                                ;;89CA|89CA+89BB/89CA\89CA; |
                      BEQ +                                     ;;89CC|89CC+89BD/89CC\89CC; |
                      LDA.B !_6                                 ;;89CE|89CE+89BF/89CE\89CE; |
                      STA.B !GraphicsCompPtr                    ;;89D0|89D0+89C1/89D0\89D0; |
                      LDA.B !GraphicsCompPtr+1                  ;;89D2|89D2+89C3/89D2\89D2; |
                      CLC                                       ;;89D4|89D4+89C5/89D4\89D4; |
                      ADC.B #$08                                ;;89D5|89D5+89C6/89D5\89D5; |
                      STA.B !GraphicsCompPtr+1                  ;;89D7|89D7+89C8/89D7\89D7; /
                    + LDA.B !GraphicsCompPtr+2                  ;;89D9|89D9+89CA/89D9\89D9;
                      BPL CODE_0489A7                           ;;89DB|89DB+89CC/89DB\89DB; loop if we have tiles left
                      RTS                                       ;;89DD|89DD+89CE/89DD\89DD; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_0489DE:          db $66,$24,$67,$24,$76,$24,$77,$24        ;;89DE|89DE+89CF/89DE\89DE;
                      db $2F,$62,$2E,$62,$3F,$62,$3E,$62        ;;89E6|89E6+89D7/89E6\89E6;
                      db $66,$24,$67,$24,$76,$24,$77,$24        ;;89EE|89EE+89DF/89EE\89EE;
                      db $2E,$22,$2F,$22,$3E,$22,$3F,$22        ;;89F6|89F6+89E7/89F6\89F6;
                      db $2F,$62,$2E,$62,$3F,$62,$3E,$62        ;;89FE|89FE+89EF/89FE\89FE;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;8A06|8A06+89F7/8A06\8A06;
                      db $2E,$22,$2F,$22,$3E,$22,$3F,$22        ;;8A0E|8A0E+89FF/8A0E\8A0E;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;8A16|8A16+8A07/8A16\8A16;
                      db $64,$24,$65,$24,$74,$24,$75,$24        ;;8A1E|8A1E+8A0F/8A1E\8A1E;
                      db $40,$22,$41,$22,$50,$22,$51,$22        ;;8A26|8A26+8A17/8A26\8A26;
                      db $64,$24,$65,$24,$74,$24,$75,$24        ;;8A2E|8A2E+8A1F/8A2E\8A2E;
                      db $42,$22,$43,$24,$52,$24,$53,$24        ;;8A36|8A36+8A27/8A36\8A36;
                      db $65,$64,$64,$64,$75,$64,$74,$64        ;;8A3E|8A3E+8A2F/8A3E\8A3E;
                      db $41,$62,$40,$62,$51,$62,$50,$62        ;;8A46|8A46+8A37/8A46\8A46;
                      db $65,$64,$64,$64,$75,$64,$74,$64        ;;8A4E|8A4E+8A3F/8A4E\8A4E;
                      db $43,$62,$42,$62,$53,$62,$52,$62        ;;8A56|8A56+8A47/8A56\8A56;
                      db $38,$24,$38,$64,$66,$24,$67,$24        ;;8A5E|8A5E+8A4F/8A5E\8A5E;
                      db $76,$24,$77,$24,$FF,$FF,$FF,$FF        ;;8A66|8A66+8A57/8A66\8A66;
                      db $39,$24,$39,$64,$66,$24,$67,$24        ;;8A6E|8A6E+8A5F/8A6E\8A6E;
                      db $76,$24,$77,$24,$FF,$FF,$FF,$FF        ;;8A76|8A76+8A67/8A76\8A76;
                      db $38,$24,$38,$64,$2F,$62,$2E,$62        ;;8A7E|8A7E+8A6F/8A7E\8A7E;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;8A86|8A86+8A77/8A86\8A86;
                      db $39,$24,$39,$24,$2E,$22,$2F,$22        ;;8A8E|8A8E+8A7F/8A8E\8A8E;
                      db $0A,$24,$0B,$24,$1A,$24,$1B,$24        ;;8A96|8A96+8A87/8A96\8A96;
                      db $38,$24,$38,$64,$64,$24,$65,$24        ;;8A9E|8A9E+8A8F/8A9E\8A9E;
                      db $74,$24,$75,$24,$40,$22,$41,$22        ;;8AA6|8AA6+8A97/8AA6\8AA6;
                      db $39,$24,$39,$64,$64,$24,$65,$24        ;;8AAE|8AAE+8A9F/8AAE\8AAE;
                      db $74,$24,$75,$24,$42,$22,$42,$22        ;;8AB6|8AB6+8AA7/8AB6\8AB6;
                      db $38,$24,$38,$64,$65,$64,$64,$64        ;;8ABE|8ABE+8AAF/8ABE\8ABE;
                      db $75,$64,$74,$64,$41,$62,$40,$62        ;;8AC6|8AC6+8AB7/8AC6\8AC6;
                      db $39,$24,$39,$64,$65,$64,$64,$64        ;;8ACE|8ACE+8ABF/8ACE\8ACE;
                      db $75,$64,$74,$64,$43,$62,$42,$62        ;;8AD6|8AD6+8AC7/8AD6\8AD6;
                      db $2F,$62,$2E,$62,$3F,$62,$3E,$62        ;;8ADE|8ADE+8ACF/8ADE\8ADE;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;8AE6|8AE6+8AD7/8AE6\8AE6;
                      db $2E,$22,$2F,$22,$3E,$22,$3F,$22        ;;8AEE|8AEE+8ADF/8AEE\8AEE;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;8AF6|8AF6+8AE7/8AF6\8AF6;
                      db $38,$24,$38,$64,$2F,$62,$2E,$62        ;;8AFE|8AFE+8AEF/8AFE\8AFE;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;8B06|8B06+8AF7/8B06\8B06;
                      db $39,$24,$39,$64,$2E,$22,$2F,$22        ;;8B0E|8B0E+8AFF/8B0E\8B0E;
                      db $24,$24,$25,$24,$34,$24,$35,$24        ;;8B16|8B16+8B07/8B16\8B16;
                      db $66,$24,$67,$24,$76,$24,$77,$24        ;;8B1E|8B1E+8B0F/8B1E\8B1E;
                      db $2F,$62,$2E,$62,$3F,$62,$3E,$62        ;;8B26|8B26+8B17/8B26\8B26;
                      db $66,$24,$67,$24,$76,$24,$77,$24        ;;8B2E|8B2E+8B1F/8B2E\8B2E;
                      db $2E,$22,$2F,$22,$3E,$22,$3F,$22        ;;8B36|8B36+8B27/8B36\8B36;
                      db $66,$24,$67,$24,$76,$24,$77,$24        ;;8B3E|8B3E+8B2F/8B3E\8B3E;
                      db $2F,$62,$2E,$62,$3F,$62,$3E,$62        ;;8B46|8B46+8B37/8B46\8B46;
                      db $66,$24,$67,$24,$76,$24,$77,$24        ;;8B4E|8B4E+8B3F/8B4E\8B4E;
                      db $2E,$22,$2F,$22,$3E,$22,$3F,$22        ;;8B56|8B56+8B47/8B56\8B56;
DATA_048B5E:          db $00,$08,$00,$08,$00,$08,$00,$08        ;;8B5E|8B5E+8B4F/8B5E\8B5E;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8B66|8B66+8B57/8B66\8B66;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8B6E|8B6E+8B5F/8B6E\8B6E;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8B76|8B76+8B67/8B76\8B76;
                      db $07,$0F,$07,$0F,$00,$08,$00,$08        ;;8B7E|8B7E+8B6F/8B7E\8B7E;
                      db $07,$0F,$07,$0F,$00,$08,$00,$08        ;;8B86|8B86+8B77/8B86\8B86;
                      db $F9,$01,$F9,$01,$00,$08,$00,$08        ;;8B8E|8B8E+8B7F/8B8E\8B8E;
                      db $F9,$01,$F9,$01,$00,$08,$00,$08        ;;8B96|8B96+8B87/8B96\8B96;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8B9E|8B9E+8B8F/8B9E\8B9E;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BA6|8BA6+8B97/8BA6\8BA6;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BAE|8BAE+8B9F/8BAE\8BAE;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BB6|8BB6+8BA7/8BB6\8BB6;
                      db $00,$08,$07,$0F,$07,$0F,$00,$08        ;;8BBE|8BBE+8BAF/8BBE\8BBE;
                      db $00,$08,$07,$0F,$07,$0F,$00,$08        ;;8BC6|8BC6+8BB7/8BC6\8BC6;
                      db $00,$08,$F9,$01,$F9,$01,$00,$08        ;;8BCE|8BCE+8BBF/8BCE\8BCE;
                      db $00,$08,$F9,$01,$F9,$01,$00,$08        ;;8BD6|8BD6+8BC7/8BD6\8BD6;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BDE|8BDE+8BCF/8BDE\8BDE;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BE6|8BE6+8BD7/8BE6\8BE6;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BEE|8BEE+8BDF/8BEE\8BEE;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BF6|8BF6+8BE7/8BF6\8BF6;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8BFE|8BFE+8BEF/8BFE\8BFE;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8C06|8C06+8BF7/8C06\8C06;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8C0E|8C0E+8BFF/8C0E\8C0E;
                      db $00,$08,$00,$08,$00,$08,$00,$08        ;;8C16|8C16+8C07/8C16\8C16;
DATA_048C1E:          db $FB,$FB,$03,$03,$00,$00,$08,$08        ;;8C1E|8C1E+8C0F/8C1E\8C1E;
                      db $FA,$FA,$02,$02,$00,$00,$08,$08        ;;8C26|8C26+8C17/8C26\8C26;
                      db $00,$00,$08,$08,$F8,$F8,$00,$00        ;;8C2E|8C2E+8C1F/8C2E\8C2E;
                      db $00,$00,$08,$08,$F9,$F9,$01,$01        ;;8C36|8C36+8C27/8C36\8C36;
                      db $FC,$FC,$04,$04,$00,$00,$08,$08        ;;8C3E|8C3E+8C2F/8C3E\8C3E;
                      db $FB,$FB,$03,$03,$00,$00,$08,$08        ;;8C46|8C46+8C37/8C46\8C46;
                      db $FC,$FC,$04,$04,$00,$00,$08,$08        ;;8C4E|8C4E+8C3F/8C4E\8C4E;
                      db $FB,$FB,$03,$03,$00,$00,$08,$08        ;;8C56|8C56+8C47/8C56\8C56;
                      db $08,$08,$FB,$FB,$03,$03,$00,$00        ;;8C5E|8C5E+8C4F/8C5E\8C5E;
                      db $08,$08,$FA,$FA,$02,$02,$00,$00        ;;8C66|8C66+8C57/8C66\8C66;
                      db $08,$08,$00,$00,$F8,$F8,$00,$00        ;;8C6E|8C6E+8C5F/8C6E\8C6E;
                      db $08,$08,$00,$00,$F9,$F9,$01,$01        ;;8C76|8C76+8C67/8C76\8C76;
                      db $08,$08,$FC,$FC,$04,$04,$00,$00        ;;8C7E|8C7E+8C6F/8C7E\8C7E;
                      db $08,$08,$FB,$FB,$03,$03,$00,$00        ;;8C86|8C86+8C77/8C86\8C86;
                      db $08,$08,$FC,$FC,$04,$04,$00,$00        ;;8C8E|8C8E+8C7F/8C8E\8C8E;
                      db $08,$08,$FB,$FB,$03,$03,$00,$00        ;;8C96|8C96+8C87/8C96\8C96;
                      db $00,$00,$08,$08,$F8,$F8,$00,$00        ;;8C9E|8C9E+8C8F/8C9E\8C9E;
                      db $00,$00,$08,$08,$F8,$F8,$00,$00        ;;8CA6|8CA6+8C97/8CA6\8CA6;
                      db $08,$08,$00,$00,$F8,$F8,$00,$00        ;;8CAE|8CAE+8C9F/8CAE\8CAE;
                      db $08,$08,$00,$00,$F8,$F8,$00,$00        ;;8CB6|8CB6+8CA7/8CB6\8CB6;
                      db $FB,$FB,$03,$03,$00,$00,$08,$08        ;;8CBE|8CBE+8CAF/8CBE\8CBE;
                      db $FA,$FA,$02,$02,$00,$00,$08,$08        ;;8CC6|8CC6+8CB7/8CC6\8CC6;
                      db $FB,$FB,$03,$03,$00,$00,$08,$08        ;;8CCE|8CCE+8CBF/8CCE\8CCE;
                      db $FA,$FA,$02,$02,$00,$00,$08,$08        ;;8CD6|8CD6+8CC7/8CD6\8CD6;
DATA_048CDE:          db $00,$00,$00,$02,$00,$04,$00,$06        ;;8CDE|8CDE+8CCF/8CDE\8CDE;
                                                                ;;                        ;
CODE_048CE6:          LDA.B #$07                                ;;8CE6|8CE6+8CD7/8CE6\8CE6;
                      STA.B !GraphicsCompPtr+2                  ;;8CE8|8CE8+8CD9/8CE8\8CE8; $8C = #$07
                      REP #$30                                  ;;8CEA|8CEA+8CDB/8CEA\8CEA; Index (16 bit) Accum (16 bit) 
                      LDA.W !OWPlayerAnimation,Y                ;;8CEC|8CEC+8CDD/8CEC\8CEC;
                      ASL A                                     ;;8CEF|8CEF+8CE0/8CEF\8CEF;
                      ASL A                                     ;;8CF0|8CF0+8CE1/8CF0\8CF0;
                      ASL A                                     ;;8CF1|8CF1+8CE2/8CF1\8CF1;
                      ASL A                                     ;;8CF2|8CF2+8CE3/8CF2\8CF2;
                      STA.B !_0                                 ;;8CF3|8CF3+8CE4/8CF3\8CF3;
                      LDA.B !TrueFrame                          ;;8CF5|8CF5+8CE6/8CF5\8CF5;
                      AND.W #$0008                              ;;8CF7|8CF7+8CE8/8CF7\8CF7;
                      ASL A                                     ;;8CFA|8CFA+8CEB/8CFA\8CFA;
                      CLC                                       ;;8CFB|8CFB+8CEC/8CFB\8CFB;
                      ADC.B !_0                                 ;;8CFC|8CFC+8CED/8CFC\8CFC;
                      TAY                                       ;;8CFE|8CFE+8CEF/8CFE\8CFE; Y = 0000 000a aaaf ffff (a = animation type, f = 5 LSB of frame counter)
                      CPX.W #$0000                              ;;8CFF|8CFF+8CF0/8CFF\8CFF;
                      BNE CODE_048D1B                           ;;8D02|8D02+8CF3/8D02\8D02; skip if not 1P
                      LDA.W !OverworldProcess                   ;;8D04|8D04+8CF5/8D04\8D04;
                      CMP.W #$000B                              ;;8D07|8D07+8CF8/8D07\8D07;
                      BNE CODE_048D1B                           ;;8D0A|8D0A+8CFB/8D0A\8D0A; skip if not star warp
                      LDA.B !TrueFrame                          ;;8D0C|8D0C+8CFD/8D0C\8D0C;
                      AND.W #$000C                              ;;8D0E|8D0E+8CFF/8D0E\8D0E;
                      LSR A                                     ;;8D11|8D11+8D02/8D11\8D11;
                      LSR A                                     ;;8D12|8D12+8D03/8D12\8D12;
                      TAY                                       ;;8D13|8D13+8D04/8D13\8D13; Y = 2 LSB of frame counter / 4
                      LDA.W OWWarpIndex,Y                       ;;8D14|8D14+8D05/8D14\8D14;
                      AND.W #$00FF                              ;;8D17|8D17+8D08/8D17\8D17;
                      TAY                                       ;;8D1A|8D1A+8D0B/8D1A\8D1A; Y = index into tilemap table
CODE_048D1B:          REP #$20                                  ;;8D1B|8D1B+8D0C/8D1B\8D1B; Accum (16 bit) 
                      PHY                                       ;;8D1D|8D1D+8D0E/8D1D\8D1D; Y = index into tilemap table
                      TYA                                       ;;8D1E|8D1E+8D0F/8D1E\8D1E; A = index into tilemap table
                      LSR A                                     ;;8D1F|8D1F+8D10/8D1F\8D1F; / 2
                      TAY                                       ;;8D20|8D20+8D11/8D20\8D20; Y = index into tilemap table / 2
                      SEP #$20                                  ;;8D21|8D21+8D12/8D21\8D21; Accum (8 bit) 
                      LDA.W DATA_048B5E,Y                       ;;8D23|8D23+8D14/8D23\8D23; X offset table for riding yoshi sprites
                      CLC                                       ;;8D26|8D26+8D17/8D26\8D26;
                      ADC.B !GraphicsCompPtr                    ;;8D27|8D27+8D18/8D27\8D27;
                      STA.W !OAMTileXPos+$9C,X                  ;;8D29|8D29+8D1A/8D29\8D29; OAM X-position
                      LDA.W DATA_048C1E,Y                       ;;8D2C|8D2C+8D1D/8D2C\8D2C; Y offset table for riding yoshi sprites
                      CLC                                       ;;8D2F|8D2F+8D20/8D2F\8D2F;
                      ADC.B !GraphicsCompPtr+1                  ;;8D30|8D30+8D21/8D30\8D30;
                      STA.W !OAMTileYPos+$9C,X                  ;;8D32|8D32+8D23/8D32\8D32; OAM Y-position
                      PLY                                       ;;8D35|8D35+8D26/8D35\8D35;
                      REP #$20                                  ;;8D36|8D36+8D27/8D36\8D36; Accum (16 bit) 
                      LDA.W DATA_0489DE,Y                       ;;8D38|8D38+8D29/8D38\8D38; 
                      CMP.W #$FFFF                              ;;8D3B|8D3B+8D2C/8D3B\8D3B;
                      BEQ CODE_048D67                           ;;8D3E|8D3E+8D2F/8D3E\8D3E;
                      PHA                                       ;;8D40|8D40+8D31/8D40\8D40;
                      AND.W #$0F00                              ;;8D41|8D41+8D32/8D41\8D41;
                      CMP.W #$0200                              ;;8D44|8D44+8D35/8D44\8D44;
                      BNE CODE_048D5E                           ;;8D47|8D47+8D38/8D47\8D47;
                      STY.B !_8                                 ;;8D49|8D49+8D3A/8D49\8D49;
                      LDA.B !_E                                 ;;8D4B|8D4B+8D3C/8D4B\8D4B;
                      SEC                                       ;;8D4D|8D4D+8D3E/8D4D\8D4D;
                      SBC.W #$0004                              ;;8D4E|8D4E+8D3F/8D4E\8D4E;
                      TAY                                       ;;8D51|8D51+8D42/8D51\8D51;
                      PLA                                       ;;8D52|8D52+8D43/8D52\8D52;
                      AND.W #$F0FF                              ;;8D53|8D53+8D44/8D53\8D53;
                      ORA.W DATA_048CDE,Y                       ;;8D56|8D56+8D47/8D56\8D56;
                      PHA                                       ;;8D59|8D59+8D4A/8D59\8D59;
                      LDY.B !_8                                 ;;8D5A|8D5A+8D4B/8D5A\8D5A;
                      BRA +                                     ;;8D5C|8D5C+8D4D/8D5C\8D5C;
                                                                ;;                        ;
CODE_048D5E:          PLA                                       ;;8D5E|8D5E+8D4F/8D5E\8D5E;
                      CLC                                       ;;8D5F|8D5F+8D50/8D5F\8D5F;
                      ADC.B !_4                                 ;;8D60|8D60+8D51/8D60\8D60;
                      PHA                                       ;;8D62|8D62+8D53/8D62\8D62;
                    + PLA                                       ;;8D63|8D63+8D54/8D63\8D63;
                      STA.W !OAMTileNo+$9C,X                    ;;8D64|8D64+8D55/8D64\8D64;
CODE_048D67:          SEP #$20                                  ;;8D67|8D67+8D58/8D67\8D67; Accum (8 bit) 
                      INX                                       ;;8D69|8D69+8D5A/8D69\8D69;
                      INX                                       ;;8D6A|8D6A+8D5B/8D6A\8D6A;
                      INX                                       ;;8D6B|8D6B+8D5C/8D6B\8D6B;
                      INX                                       ;;8D6C|8D6C+8D5D/8D6C\8D6C;
                      INY                                       ;;8D6D|8D6D+8D5E/8D6D\8D6D;
                      INY                                       ;;8D6E|8D6E+8D5F/8D6E\8D6E;
                      DEC.B !GraphicsCompPtr+2                  ;;8D6F|8D6F+8D60/8D6F\8D6F;
                      BPL CODE_048D1B                           ;;8D71|8D71+8D62/8D71\8D71;
                      RTS                                       ;;8D73|8D73+8D64/8D73\8D73; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_048D74:          db $0B,$00,$13,$00,$1A,$00,$1B,$00        ;;8D74|8D74+8D65/8D74\8D74;
                      db $1F,$00,$20,$00,$31,$00,$32,$00        ;;8D7C|8D7C+8D6D/8D7C\8D7C;
                      db $34,$00,$35,$00,$40,$00                ;;8D84|8D84+8D75/8D84\8D84;
                                                                ;;                        ;
OverworldMusic:       db !BGM_DONUTPLAINS                       ;;8D8A|8D8A+8D7B/8D8A\8D8A;
                      db !BGM_YOSHISISLAND                      ;;8D8B|8D8B+8D7C/8D8B\8D8B;
                      db !BGM_VANILLADOME                       ;;8D8C|8D8C+8D7D/8D8C\8D8C;
                      db !BGM_FORESTOFILLUSION                  ;;8D8D|8D8D+8D7E/8D8D\8D8D;
                      db !BGM_VALLEYOFBOWSER                    ;;8D8E|8D8E+8D7F/8D8E\8D8E;
                      db !BGM_SPECIALWORLD                      ;;8D8F|8D8F+8D80/8D8F\8D8F;
                      db !BGM_STARWORLD                         ;;8D90|8D90+8D81/8D90\8D90;
                                                                ;;                        ;
CODE_048D91:          PHB                                       ;;8D91|8D91+8D82/8D91\8D91; Index (8 bit) 
                      PHK                                       ;;8D92|8D92+8D83/8D92\8D92;
                      PLB                                       ;;8D93|8D93+8D84/8D93\8D93;
                      STZ.W !SwapOverworldMusic                 ;;8D94|8D94+8D85/8D94\8D94;
                      LDA.B #$0F                                ;;8D97|8D97+8D88/8D97\8D97;
                      STA.W !Layer1ScrollXPosUpd                ;;8D99|8D99+8D8A/8D99\8D99;
                      LDX.B #$02                                ;;8D9C|8D9C+8D8D/8D9C\8D9C;
                      LDA.W !OWPlayerAnimation                  ;;8D9E|8D9E+8D8F/8D9E\8D9E;
                      CMP.B #$12                                ;;8DA1|8DA1+8D92/8DA1\8DA1;
                      BEQ CODE_048DA9                           ;;8DA3|8DA3+8D94/8DA3\8DA3;
                      AND.B #$08                                ;;8DA5|8DA5+8D96/8DA5\8DA5;
                      BEQ +                                     ;;8DA7|8DA7+8D98/8DA7\8DA7;
CODE_048DA9:          LDX.B #$0A                                ;;8DA9|8DA9+8D9A/8DA9\8DA9;
                    + STX.W !OWPlayerAnimation                  ;;8DAB|8DAB+8D9C/8DAB\8DAB;
                      LDX.B #$02                                ;;8DAE|8DAE+8D9F/8DAE\8DAE;
                      LDA.W !OWPlayerAnimation+2                ;;8DB0|8DB0+8DA1/8DB0\8DB0;
                      CMP.B #$12                                ;;8DB3|8DB3+8DA4/8DB3\8DB3;
                      BEQ CODE_048DBB                           ;;8DB5|8DB5+8DA6/8DB5\8DB5;
                      AND.B #$08                                ;;8DB7|8DB7+8DA8/8DB7\8DB7;
                      BEQ +                                     ;;8DB9|8DB9+8DAA/8DB9\8DB9;
CODE_048DBB:          LDX.B #$0A                                ;;8DBB|8DBB+8DAC/8DBB\8DBB;
                    + STX.W !OWPlayerAnimation+2                ;;8DBD|8DBD+8DAE/8DBD\8DBD;
                      SEP #$10                                  ;;8DC0|8DC0+8DB1/8DC0\8DC0; Index (8 bit) 
                      JSR CODE_048E55                           ;;8DC2|8DC2+8DB3/8DC2\8DC2;
                      REP #$30                                  ;;8DC5|8DC5+8DB6/8DC5\8DC5; Index (16 bit) Accum (16 bit) 
                      LDA.W !OWLevelExitMode-1                  ;;8DC7|8DC7+8DB8/8DC7\8DC7;
                      AND.W #$FF00                              ;;8DCA|8DCA+8DBB/8DCA\8DCA;
                      BEQ CODE_048DDF                           ;;8DCD|8DCD+8DBE/8DCD\8DCD;
                      BMI CODE_048DDF                           ;;8DCF|8DCF+8DC0/8DCF\8DCF;
                      LDA.W !TranslevelNo                       ;;8DD1|8DD1+8DC2/8DD1\8DD1;
                      AND.W #$00FF                              ;;8DD4|8DD4+8DC5/8DD4\8DD4;
                      CMP.W #$0018                              ;;8DD7|8DD7+8DC8/8DD7\8DD7;
                      BNE CODE_048DDF                           ;;8DDA|8DDA+8DCB/8DDA\8DDA;
                      BRL CODE_048E34                           ;;8DDC|8DDC+8DCD/8DDC\8DDC;
CODE_048DDF:          LDA.W !CutsceneID                         ;;8DDF|8DDF+8DD0/8DDF\8DDF;
                      AND.W #$00FF                              ;;8DE2|8DE2+8DD3/8DE2\8DE2;
                      BEQ CODE_048E38                           ;;8DE5|8DE5+8DD6/8DE5\8DE5;
                      LDA.W !CutsceneID                         ;;8DE7|8DE7+8DD8/8DE7\8DE7;
                      AND.W #$FF00                              ;;8DEA|8DEA+8DDB/8DEA\8DEA;
                      STA.W !CutsceneID                         ;;8DED|8DED+8DDE/8DED\8DED;
                   if ver_is_english(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; U, SS, E0, & E1
                      SEP #$10                                  ;;    |8DF0+8DE1/8DF0\8DF0; Index (8 bit) 
                      LDX.W !PlayerTurnOW                       ;;    |8DF2+8DE3/8DF2\8DF2; this code block prevents the music from
                      LDA.W !OWPlayerXPos,X                     ;;    |8DF5+8DE6/8DF5\8DF5; being disabled after beating a boss for
                      LSR A                                     ;;    |8DF8+8DE9/8DF8\8DF8; a second time
                      LSR A                                     ;;    |8DF9+8DEA/8DF9\8DF9;
                      LSR A                                     ;;    |8DFA+8DEB/8DFA\8DFA;
                      LSR A                                     ;;    |8DFB+8DEC/8DFB\8DFB;
                      STA.B !_0                                 ;;    |8DFC+8DED/8DFC\8DFC;
                      LDA.W !OWPlayerYPos,X                     ;;    |8DFE+8DEF/8DFE\8DFE;
                      LSR A                                     ;;    |8E01+8DF2/8E01\8E01;
                      LSR A                                     ;;    |8E02+8DF3/8E02\8E02;
                      LSR A                                     ;;    |8E03+8DF4/8E03\8E03;
                      LSR A                                     ;;    |8E04+8DF5/8E04\8E04;
                      STA.B !_2                                 ;;    |8E05+8DF6/8E05\8E05;
                      TXA                                       ;;    |8E07+8DF8/8E07\8E07;
                      LSR A                                     ;;    |8E08+8DF9/8E08\8E08;
                      LSR A                                     ;;    |8E09+8DFA/8E09\8E09;
                      TAX                                       ;;    |8E0A+8DFB/8E0A\8E0A;
                      JSR OW_TilePos_Calc                       ;;    |8E0B+8DFC/8E0B\8E0B;
                      REP #$10                                  ;;    |8E0E+8DFF/8E0E\8E0E; Index (16 bit) 
                      LDX.B !_4                                 ;;    |8E10+8E01/8E10\8E10;
                      LDA.L !OWLayer1Translevel,X               ;;    |8E12+8E03/8E12\8E12;
                      AND.W #$00FF                              ;;    |8E16+8E07/8E16\8E16;
                      TAX                                       ;;    |8E19+8E0A/8E19\8E19;
                      LDA.W !OWLevelTileSettings,X              ;;    |8E1A+8E0B/8E1A\8E1A;
                      AND.W #$0080                              ;;    |8E1D+8E0E/8E1D\8E1D;
                      BNE CODE_048E38                           ;;    |8E20+8E11/8E20\8E20;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                      LDY.W #$0014                              ;;8DF0|8E22+8E13/8E22\8E22;
CODE_048E25:          LDA.W !TranslevelNo                       ;;8DF3|8E25+8E16/8E25\8E25;
                      AND.W #$00FF                              ;;8DF6|8E28+8E19/8E28\8E28;
                      CMP.W DATA_048D74,Y                       ;;8DF9|8E2B+8E1C/8E2B\8E2B;
                      BEQ CODE_048E38                           ;;8DFC|8E2E+8E1F/8E2E\8E2E;
                      DEY                                       ;;8DFE|8E30+8E21/8E30\8E30;
                      DEY                                       ;;8DFF|8E31+8E22/8E31\8E31;
                      BPL CODE_048E25                           ;;8E00|8E32+8E23/8E32\8E32;
CODE_048E34:          SEP #$30                                  ;;8E02|8E34+8E25/8E34\8E34; Index (8 bit) Accum (8 bit) 
                      BRA +                                     ;;8E04|8E36+8E27/8E36\8E36;
                                                                ;;                        ;
CODE_048E38:          SEP #$30                                  ;;8E06|8E38+8E29/8E38\8E38; Index (8 bit) Accum (8 bit) 
                      LDX.W !PlayerTurnLvl                      ;;8E08|8E3A+8E2B/8E3A\8E3A;
                      LDA.W !OWPlayerSubmap,X                   ;;8E0B|8E3D+8E2E/8E3D\8E3D;
                      TAX                                       ;;8E0E|8E40+8E31/8E40\8E40;
                      LDA.W OverworldMusic,X                    ;;8E0F|8E41+8E32/8E41\8E41;
                      STA.W !SPCIO2                             ;;8E12|8E44+8E35/8E44\8E44; / Change music 
                    + PLB                                       ;;8E15|8E47+8E38/8E47\8E47;
                      RTL                                       ;;8E16|8E48+8E39/8E48\8E48; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_048E49:          db $28,$01,$00,$00,$88,$01                ;;8E17|8E49+8E3A/8E49\8E49;
                                                                ;;                        ;
DATA_048E4F:          db $C8,$01,$00,$00,$D8,$01                ;;8E1D|8E4F+8E40/8E4F\8E4F;
                                                                ;;                        ;
CODE_048E55:          REP #$30                                  ;;8E23|8E55+8E46/8E55\8E55; Index (16 bit) Accum (16 bit) 
                      LDA.W !PlayerTurnLvl                      ;;8E25|8E57+8E48/8E57\8E57;
                      AND.W #$00FF                              ;;8E28|8E5A+8E4B/8E5A\8E5A;
                      ASL A                                     ;;8E2B|8E5D+8E4E/8E5D\8E5D;
                      ASL A                                     ;;8E2C|8E5E+8E4F/8E5E\8E5E;
                      STA.W !PlayerTurnOW                       ;;8E2D|8E5F+8E50/8E5F\8E5F;
                      LDX.W !PlayerTurnOW                       ;;8E30|8E62+8E53/8E62\8E62;
                      LDA.W !OWPlayerXPosPtr,X                  ;;8E33|8E65+8E56/8E65\8E65;
                      STA.B !_0                                 ;;8E36|8E68+8E59/8E68\8E68;
                      LDA.W !OWPlayerYPosPtr,X                  ;;8E38|8E6A+8E5B/8E6A\8E6A;
                      STA.B !_2                                 ;;8E3B|8E6D+8E5E/8E6D\8E6D;
                      TXA                                       ;;8E3D|8E6F+8E60/8E6F\8E6F;
                      LSR A                                     ;;8E3E|8E70+8E61/8E70\8E70;
                      LSR A                                     ;;8E3F|8E71+8E62/8E71\8E71;
                      TAX                                       ;;8E40|8E72+8E63/8E72\8E72;
                      JSR OW_TilePos_Calc                       ;;8E41|8E73+8E64/8E73\8E73;
                      STZ.B !_0                                 ;;8E44|8E76+8E67/8E76\8E76;
                      LDX.B !_4                                 ;;8E46|8E78+8E69/8E78\8E78;
                      LDA.L !OWLayer1Translevel,X               ;;8E48|8E7A+8E6B/8E7A\8E7A;
                      AND.W #$00FF                              ;;8E4C|8E7E+8E6F/8E7E\8E7E;
                      ASL A                                     ;;8E4F|8E81+8E72/8E81\8E81;
                      TAX                                       ;;8E50|8E82+8E73/8E82\8E82;
                      LDA.W LevelNames,X                        ;;8E51|8E83+8E74/8E83\8E83;
                      STA.B !_0                                 ;;8E54|8E86+8E77/8E86\8E86;
                      JSR CODE_049D07                           ;;8E56|8E88+8E79/8E88\8E88;
                      LDX.B !_4                                 ;;8E59|8E8B+8E7C/8E8B\8E8B;
                      BMI +                                     ;;8E5B|8E8D+8E7E/8E8D\8E8D;
                      CPX.W #$0800                              ;;8E5D|8E8F+8E80/8E8F\8E8F;
                      BCS +                                     ;;8E60|8E92+8E83/8E92\8E92;
                      LDA.L !Map16TilesLow,X                    ;;8E62|8E94+8E85/8E94\8E94;
                      AND.W #$00FF                              ;;8E66|8E98+8E89/8E98\8E98;
                      STA.W !OverworldLayer1Tile                ;;8E69|8E9B+8E8C/8E9B\8E9B;
                    + SEP #$30                                  ;;8E6C|8E9E+8E8F/8E9E\8E9E; Index (8 bit) Accum (8 bit) 
                      LDX.W !EnterLevelAuto                     ;;8E6E|8EA0+8E91/8EA0\8EA0;
                      BEQ CODE_048EE1                           ;;8E71|8EA3+8E94/8EA3\8EA3;
                      BPL ADDR_048ED9                           ;;8E73|8EA5+8E96/8EA5\8EA5;
                      TXA                                       ;;8E75|8EA7+8E98/8EA7\8EA7;
                      AND.B #$7F                                ;;8E76|8EA8+8E99/8EA8\8EA8;
                      TAX                                       ;;8E78|8EAA+8E9B/8EAA\8EAA;
                      STZ.W !OWSpriteMisc0DF5,X                 ;;8E79|8EAB+8E9C/8EAB\8EAB;
                      LDA.W !KoopaKidTile                       ;;8E7C|8EAE+8E9F/8EAE\8EAE;
                      LDX.W !OWLevelExitMode                    ;;8E7F|8EB1+8EA2/8EB1\8EB1;
                      BPL ADDR_048ECD                           ;;8E82|8EB4+8EA5/8EB4\8EB4;
                      ASL A                                     ;;8E84|8EB6+8EA7/8EB6\8EB6;
                      TAX                                       ;;8E85|8EB7+8EA8/8EB7\8EB7;
                      REP #$20                                  ;;8E86|8EB8+8EA9/8EB8\8EB8; Accum (16 bit) 
                      LDY.W !PlayerTurnOW                       ;;8E88|8EBA+8EAB/8EBA\8EBA;
                      LDA.W DATA_048E49,X                       ;;8E8B|8EBD+8EAE/8EBD\8EBD;
                      STA.W !OWPlayerXPos,Y                     ;;8E8E|8EC0+8EB1/8EC0\8EC0;
                      LDA.W DATA_048E4F,X                       ;;8E91|8EC3+8EB4/8EC3\8EC3;
                      STA.W !OWPlayerYPos,Y                     ;;8E94|8EC6+8EB7/8EC6\8EC6;
                      SEP #$20                                  ;;8E97|8EC9+8EBA/8EC9\8EC9; Accum (8 bit) 
                      BRA CODE_048EE1                           ;;8E99|8ECB+8EBC/8ECB\8ECB;
                                                                ;;                        ;
ADDR_048ECD:          TAX                                       ;;8E9B|8ECD+8EBE/8ECD\8ECD;
                      LDA.W DATA_04FB85,X                       ;;8E9C|8ECE+8EBF/8ECE\8ECE;
                      ORA.W !KoopaKidActive                     ;;8E9F|8ED1+8EC2/8ED1\8ED1;
                      STA.W !KoopaKidActive                     ;;8EA2|8ED4+8EC5/8ED4\8ED4;
                      BRA CODE_048EE1                           ;;8EA5|8ED7+8EC8/8ED7\8ED7;
                                                                ;;                        ;
ADDR_048ED9:          LDA.W !OWLevelExitMode                    ;;8EA7|8ED9+8ECA/8ED9\8ED9;
                      BMI CODE_048EE1                           ;;8EAA|8EDC+8ECD/8EDC\8EDC;
                      STZ.W !OWSpriteNumber,X                   ;;8EAC|8EDE+8ECF/8EDE\8EDE;
CODE_048EE1:          REP #$30                                  ;;8EAF|8EE1+8ED2/8EE1\8EE1; Index (16 bit) Accum (16 bit) 
                      JSR OWMoveScroll                          ;;8EB1|8EE3+8ED4/8EE3\8EE3;
                      SEP #$30                                  ;;8EB4|8EE6+8ED7/8EE6\8EE6; Index (8 bit) Accum (8 bit) 
                      JSR DrawOWBoarder_                        ;;8EB6|8EE8+8ED9/8EE8\8EE8;
                      JSR CODE_048086                           ;;8EB9|8EEB+8EDC/8EEB\8EEB;
                      JMP OW_Tile_Animation                     ;;8EBC|8EEE+8EDF/8EEE\8EEE;
                                                                ;;                        ;
CODE_048EF1:          LDA.B #$08                                ;;8EBF|8EF1+8EE2/8EF1\8EF1;
                      STA.W !KeepModeActive                     ;;8EC1|8EF3+8EE4/8EF3\8EF3;
                      LDA.W !OWPlayerSubmap                     ;;8EC4|8EF6+8EE7/8EF6\8EF6;
                      CMP.B #$01                                ;;8EC7|8EF9+8EEA/8EF9\8EF9;
                      BNE CODE_048F13                           ;;8EC9|8EFB+8EEC/8EFB\8EFB;
                      LDA.W !OWPlayerXPos                       ;;8ECB|8EFD+8EEE/8EFD\8EFD;
                      CMP.B #$68                                ;;8ECE|8F00+8EF1/8F00\8F00;
                      BNE CODE_048F13                           ;;8ED0|8F02+8EF3/8F02\8F02;
                      LDA.W !OWPlayerYPos                       ;;8ED2|8F04+8EF5/8F04\8F04;
                      CMP.B #$8E                                ;;8ED5|8F07+8EF8/8F07\8F07;
                      BNE CODE_048F13                           ;;8ED7|8F09+8EFA/8F09\8F09;
                      LDA.B #$0C                                ;;8ED9|8F0B+8EFC/8F0B\8F0B;
                      STA.W !OverworldProcess                   ;;8EDB|8F0D+8EFE/8F0D\8F0D;
                      BRL CODE_048F7A                           ;;8EDE|8F10+8F01/8F10\8F10;
CODE_048F13:          REP #$20                                  ;;8EE1|8F13+8F04/8F13\8F13; Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;8EE3|8F15+8F06/8F15\8F15;
                      LDA.W !OWPlayerXPos,X                     ;;8EE6|8F18+8F09/8F18\8F18;
                      LSR A                                     ;;8EE9|8F1B+8F0C/8F1B\8F1B;
                      LSR A                                     ;;8EEA|8F1C+8F0D/8F1C\8F1C;
                      LSR A                                     ;;8EEB|8F1D+8F0E/8F1D\8F1D;
                      LSR A                                     ;;8EEC|8F1E+8F0F/8F1E\8F1E;
                      STA.B !_0                                 ;;8EED|8F1F+8F10/8F1F\8F1F;
                      LDA.W !OWPlayerYPos,X                     ;;8EEF|8F21+8F12/8F21\8F21;
                      LSR A                                     ;;8EF2|8F24+8F15/8F24\8F24;
                      LSR A                                     ;;8EF3|8F25+8F16/8F25\8F25;
                      LSR A                                     ;;8EF4|8F26+8F17/8F26\8F26;
                      LSR A                                     ;;8EF5|8F27+8F18/8F27\8F27;
                      STA.B !_2                                 ;;8EF6|8F28+8F19/8F28\8F28;
                      TXA                                       ;;8EF8|8F2A+8F1B/8F2A\8F2A;
                      LSR A                                     ;;8EF9|8F2B+8F1C/8F2B\8F2B;
                      LSR A                                     ;;8EFA|8F2C+8F1D/8F2C\8F2C;
                      TAX                                       ;;8EFB|8F2D+8F1E/8F2D\8F2D;
                      JSR OW_TilePos_Calc                       ;;8EFC|8F2E+8F1F/8F2E\8F2E;
                      REP #$10                                  ;;8EFF|8F31+8F22/8F31\8F31; Index (16 bit) 
                      SEP #$20                                  ;;8F01|8F33+8F24/8F33\8F33; Accum (8 bit) 
                      LDA.W !MidwayFlag                         ;;8F03|8F35+8F26/8F35\8F35;
                      BEQ CODE_048F56                           ;;8F06|8F38+8F29/8F38\8F38;
                      LDA.W !OWLevelExitMode                    ;;8F08|8F3A+8F2B/8F3A\8F3A;
                      BEQ CODE_048F56                           ;;8F0B|8F3D+8F2E/8F3D\8F3D;
                      BPL CODE_048F5F                           ;;8F0D|8F3F+8F30/8F3F\8F3F;
                      REP #$20                                  ;;8F0F|8F41+8F32/8F41\8F41; Accum (16 bit) 
                      LDX.B !_4                                 ;;8F11|8F43+8F34/8F43\8F43;
                      LDA.L !OWLayer1Translevel,X               ;;8F13|8F45+8F36/8F45\8F45;
                      AND.W #$00FF                              ;;8F17|8F49+8F3A/8F49\8F49;
                      TAX                                       ;;8F1A|8F4C+8F3D/8F4C\8F4C;
                      LDA.W !OWLevelTileSettings,X              ;;8F1B|8F4D+8F3E/8F4D\8F4D;
                      ORA.W #$0040                              ;;8F1E|8F50+8F41/8F50\8F50;
                      STA.W !OWLevelTileSettings,X              ;;8F21|8F53+8F44/8F53\8F53;
CODE_048F56:          SEP #$20                                  ;;8F24|8F56+8F47/8F56\8F56; Accum (8 bit) 
                      LDA.B #$05                                ;;8F26|8F58+8F49/8F58\8F58;
                      STA.W !OverworldProcess                   ;;8F28|8F5A+8F4B/8F5A\8F5A;
                      BRA CODE_048F7A                           ;;8F2B|8F5D+8F4E/8F5D\8F5D;
                                                                ;;                        ;
CODE_048F5F:          REP #$20                                  ;;8F2D|8F5F+8F50/8F5F\8F5F; Accum (16 bit) 
                      LDX.B !_4                                 ;;8F2F|8F61+8F52/8F61\8F61;
                      LDA.L !OWLayer1Translevel,X               ;;8F31|8F63+8F54/8F63\8F63;
                      AND.W #$00FF                              ;;8F35|8F67+8F58/8F67\8F67;
                      TAX                                       ;;8F38|8F6A+8F5B/8F6A\8F6A;
                      LDA.W !OWLevelTileSettings,X              ;;8F39|8F6B+8F5C/8F6B\8F6B;
                      ORA.W #$0080                              ;;8F3C|8F6E+8F5F/8F6E\8F6E;
                      AND.W #$FFBF                              ;;8F3F|8F71+8F62/8F71\8F71;
                      STA.W !OWLevelTileSettings,X              ;;8F42|8F74+8F65/8F74\8F74;
                      INC.W !OverworldProcess                   ;;8F45|8F77+8F68/8F77\8F77;
CODE_048F7A:          REP #$30                                  ;;8F48|8F7A+8F6B/8F7A\8F7A; Index (16 bit) Accum (16 bit) 
                      JMP OWMoveScroll                          ;;8F4A|8F7C+8F6D/8F7C\8F7C;
                                                                ;;                        ;
                                                                ;;                        ;
DATA_048F7F:          db $58,$59,$5D,$63,$77,$79,$7E,$80        ;;8F4D|8F7F+8F70/8F7F\8F7F;
                                                                ;;                        ;
CODE_048F87:          JSR CODE_049903                           ;;8F55|8F87+8F78/8F87\8F87; Index (8 bit) 
                   if ver_is_console(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; J, U, E0, & E1
                      LDX.B #$07                                ;;8F58|8F8A     /8F8A\8F8A;
CODE_048F8C:          LDA.W !OverworldLayer1Tile                ;;8F5A|8F8C     /8F8C\8F8C;
                      CMP.W DATA_048F7F,X                       ;;8F5D|8F8F     /8F8F\8F8F;
                      BNE CODE_049000                           ;;8F60|8F92     /8F92\8F92;
                      LDX.B #$2C                                ;;8F62|8F94     /8F94\8F94;
                    - LDA.W !OWEventsActivated,X                ;;8F64|8F96     /8F96\8F96;
                      STA.W !SaveDataBufferEvents,X             ;;8F67|8F99     /8F99\8F99;
                      DEX                                       ;;8F6A|8F9C     /8F9C\8F9C;
                      BPL -                                     ;;8F6B|8F9D     /8F9D\8F9D;
                      REP #$30                                  ;;8F6D|8F9F     /8F9F\8F9F; Index (16 bit) Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;8F6F|8FA1     /8FA1\8FA1;
                      TXA                                       ;;8F72|8FA4     /8FA4\8FA4;
                      EOR.W #$0004                              ;;8F73|8FA5     /8FA5\8FA5;
                      TAY                                       ;;8F76|8FA8     /8FA8\8FA8;
                      LDA.W !SaveDataBufferXPos,X               ;;8F77|8FA9     /8FA9\8FA9;
                      STA.W !SaveDataBufferXPos,Y               ;;8F7A|8FAC     /8FAC\8FAC;
                      LDA.W !SaveDataBufferYPos,X               ;;8F7D|8FAF     /8FAF\8FAF;
                      STA.W !SaveDataBufferYPos,Y               ;;8F80|8FB2     /8FB2\8FB2;
                      LDA.W !SaveDataBufferXPosPtr,X            ;;8F83|8FB5     /8FB5\8FB5;
                      STA.W !SaveDataBufferXPosPtr,Y            ;;8F86|8FB8     /8FB8\8FB8;
                      LDA.W !SaveDataBufferYPosPtr,X            ;;8F89|8FBB     /8FBB\8FBB;
                      STA.W !SaveDataBufferYPosPtr,Y            ;;8F8C|8FBE     /8FBE\8FBE;
                      TXA                                       ;;8F8F|8FC1     /8FC1\8FC1;
                      LSR A                                     ;;8F90|8FC2     /8FC2\8FC2;
                      TAX                                       ;;8F91|8FC3     /8FC3\8FC3;
                      EOR.W #$0002                              ;;8F92|8FC4     /8FC4\8FC4;
                      TAY                                       ;;8F95|8FC7     /8FC7\8FC7;
                      LDA.W !SaveDataBufferAni,X                ;;8F96|8FC8     /8FC8\8FC8;
                      STA.W !SaveDataBufferAni,Y                ;;8F99|8FCB     /8FCB\8FCB;
                      TXA                                       ;;8F9C|8FCE     /8FCE\8FCE;
                      SEP #$30                                  ;;8F9D|8FCF     /8FCF\8FCF; Index (8 bit) Accum (8 bit) 
                      LSR A                                     ;;8F9F|8FD1     /8FD1\8FD1;
                      TAX                                       ;;8FA0|8FD2     /8FD2\8FD2;
                      EOR.B #$01                                ;;8FA1|8FD3     /8FD3\8FD3;
                      TAY                                       ;;8FA3|8FD5     /8FD5\8FD5;
                      LDA.W !SaveDataBufferSubmap,X             ;;8FA4|8FD6     /8FD6\8FD6;
                      STA.W !SaveDataBufferSubmap,Y             ;;8FA7|8FD9     /8FD9\8FD9;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                      LDA.W !OWLevelExitMode                    ;;8FAA|8FDC+8F7B/8FDC\8FDC;
                      CMP.B #$E0                                ;;8FAD|8FDF+8F7E/8FDF\8FDF;
                      BNE CODE_048FFB                           ;;8FAF|8FE1+8F80/8FE1\8FE1;
                      DEC.W !KeepModeActive                     ;;8FB1|8FE3+8F82/8FE3\8FE3;
                      BMI +                                     ;;8FB4|8FE6+8F85/8FE6\8FE6;
                      RTS                                       ;;8FB6|8FE8+8F87/8FE8\8FE8; Return 
                                                                ;;                        ;
                    + INC.W !ShowSavePrompt                     ;;8FB7|8FE9+8F88/8FE9\8FE9;
                      JSR CODE_049037                           ;;8FBA|8FEC+8F8B/8FEC\8FEC;
                      LDA.B #$02                                ;;8FBD|8FEF+8F8E/8FEF\8FEF;
                      STA.W !KeepModeActive                     ;;8FBF|8FF1+8F90/8FF1\8FF1;
                      LDA.B #$04                                ;;8FC2|8FF4+8F93/8FF4\8FF4;
                      STA.W !OverworldProcess                   ;;8FC4|8FF6+8F95/8FF6\8FF6;
                      BRA CODE_049003                           ;;8FC7|8FF9+8F98/8FF9\8FF9;
                                                                ;;                        ;
CODE_048FFB:          INC.W !ShowSavePrompt                     ;;8FC9|8FFB+8F9A/8FFB\8FFB;
                      BRA CODE_049003                           ;;8FCC|8FFE+8F9D/8FFE\8FFE;
                                                                ;;                        ;
                   if ver_is_console(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; J, U, E0, & E1
CODE_049000:          DEX                                       ;;8FCE|9000     /9000\9000;
                      BPL CODE_048F8C                           ;;8FCF|9001     /9001\9001;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
CODE_049003:          REP #$20                                  ;;8FD1|9003+8F9F/9003\9003; Accum (16 bit) 
                      STZ.B !_6                                 ;;8FD3|9005+8FA1/9005\9005;
                      LDX.W !PlayerTurnOW                       ;;8FD5|9007+8FA3/9007\9007;
                      LDA.W !OWPlayerXPos,X                     ;;8FD8|900A+8FA6/900A\900A;
                      LSR A                                     ;;8FDB|900D+8FA9/900D\900D;
                      LSR A                                     ;;8FDC|900E+8FAA/900E\900E;
                      LSR A                                     ;;8FDD|900F+8FAB/900F\900F;
                      LSR A                                     ;;8FDE|9010+8FAC/9010\9010;
                      STA.B !_0                                 ;;8FDF|9011+8FAD/9011\9011;
                      LDA.W !OWPlayerYPos,X                     ;;8FE1|9013+8FAF/9013\9013;
                      LSR A                                     ;;8FE4|9016+8FB2/9016\9016;
                      LSR A                                     ;;8FE5|9017+8FB3/9017\9017;
                      LSR A                                     ;;8FE6|9018+8FB4/9018\9018;
                      LSR A                                     ;;8FE7|9019+8FB5/9019\9019;
                      STA.B !_2                                 ;;8FE8|901A+8FB6/901A\901A;
                      TXA                                       ;;8FEA|901C+8FB8/901C\901C;
                      LSR A                                     ;;8FEB|901D+8FB9/901D\901D;
                      LSR A                                     ;;8FEC|901E+8FBA/901E\901E;
                      TAX                                       ;;8FED|901F+8FBB/901F\901F;
                      JSR OW_TilePos_Calc                       ;;8FEE|9020+8FBC/9020\9020;
                      REP #$10                                  ;;8FF1|9023+8FBF/9023\9023; Index (16 bit) 
                      LDX.B !_4                                 ;;8FF3|9025+8FC1/9025\9025;
                      LDA.L !Map16TilesLow,X                    ;;8FF5|9027+8FC3/9027\9027;
                      AND.W #$00FF                              ;;8FF9|902B+8FC7/902B\902B;
                      STA.W !OverworldLayer1Tile                ;;8FFC|902E+8FCA/902E\902E;
                      SEP #$30                                  ;;8FFF|9031+8FCD/9031\9031; Index (8 bit) Accum (8 bit) 
                      INC.W !OverworldProcess                   ;;9001|9033+8FCF/9033\9033;
                      RTS                                       ;;9004|9036+8FD2/9036\9036; Return 
                                                                ;;                        ;
CODE_049037:          PHX                                       ;;9005|9037+8FD3/9037\9037;
                      PHY                                       ;;9006|9038+8FD4/9038\9038;
                      PHP                                       ;;9007|9039+8FD5/9039\9039;
                      SEP #$30                                  ;;9008|903A+8FD6/903A\903A; Index (8 bit) Accum (8 bit) 
                      LDA.W !ShowSavePrompt                     ;;900A|903C+8FD8/903C\903C;
                      BEQ CODE_049054                           ;;900D|903F+8FDB/903F\903F;
                   if ver_is_console(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; J, U, E0, & E1
                      LDX.B #$5F                                ;;900F|9041     /9041\9041;
                    - LDA.W !OWLevelTileSettings,X              ;;9011|9043     /9043\9043;
                      STA.W !SaveDataBuffer,X                   ;;9014|9046     /9046\9046;
                      DEX                                       ;;9017|9049     /9049\9049;
                      BPL -                                     ;;9018|904A     /904A\904A;
                      STZ.W !ShowSavePrompt                     ;;901A|904C     /904C\904C;
                      LDA.B #$05                                ;;901D|904F     /904F\904F;
                      STA.W !OverworldPromptProcess             ;;901F|9051     /9051\9051;
                   else                               ;<  ELSE  ;;++++++++++++++++++++++++; SS
                      LDX.B #$2C                                ;;         +8FDD          ;
                    - LDA.W !OWEventsActivated,X                ;;         +8FDF          ;
                      STA.W !SaveDataBufferEvents,X             ;;         +8FE2          ;
                      DEX                                       ;;         +8FE5          ;
                      BPL -                                     ;;         +8FE6          ;
                      REP #$30                                  ;;         +8FE8          ;
                      LDX.W !PlayerTurnOW                       ;;         +8FEA          ;
                      TXA                                       ;;         +8FED          ;
                      EOR.W #$0004                              ;;         +8FEE          ;
                      TAY                                       ;;         +8FF1          ;
                      LDA.W !SaveDataBufferXPos,X               ;;         +8FF2          ;
                      STA.W !SaveDataBufferXPos,Y               ;;         +8FF5          ;
                      LDA.W !SaveDataBufferYPos,X               ;;         +8FF8          ;
                      STA.W !SaveDataBufferYPos,Y               ;;         +8FFB          ;
                      LDA.W !SaveDataBufferXPosPtr,X            ;;         +8FFE          ;
                      STA.W !SaveDataBufferXPosPtr,Y            ;;         +9001          ;
                      LDA.W !SaveDataBufferYPosPtr,X            ;;         +9004          ;
                      STA.W !SaveDataBufferYPosPtr,Y            ;;         +9007          ;
                      TXA                                       ;;         +900A          ;
                      LSR A                                     ;;         +900B          ;
                      TAX                                       ;;         +900C          ;
                      EOR.W #$0002                              ;;         +900D          ;
                      TAY                                       ;;         +9010          ;
                      LDA.W !SaveDataBufferAni,X                ;;         +9011          ;
                      STA.W !SaveDataBufferAni,Y                ;;         +9014          ;
                      TXA                                       ;;         +9017          ;
                      SEP #$30                                  ;;         +9018          ;
                      LSR A                                     ;;         +901A          ;
                      TAX                                       ;;         +901B          ;
                      EOR.B #$01                                ;;         +901C          ;
                      TAY                                       ;;         +901E          ;
                      LDA.W !SaveDataBufferSubmap,X             ;;         +901F          ;
                      STA.W !SaveDataBufferSubmap,Y             ;;         +9022          ;
                      LDX.B #$5F                                ;;         +9025          ;
                    - LDA.W !OWLevelTileSettings,X              ;;         +9027          ;
                      STA.W !SaveDataBuffer,X                   ;;         +902A          ;
                      DEX                                       ;;         +902D          ;
                      BPL -                                     ;;         +902E          ;
                      STZ.W !ShowSavePrompt                     ;;         +9030          ;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
CODE_049054:          PLP                                       ;;9022|9054+9033/9054\9054;
                      PLY                                       ;;9023|9055+9034/9055\9055;
                      PLX                                       ;;9024|9056+9035/9056\9056;
                      RTS                                       ;;9025|9057+9036/9057\9057; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_049058:          db $FF,$FF,$01,$00,$FF,$FF,$01,$00        ;;9026|9058+9037/9058\9058;
DATA_049060:          db $05,$03,$01,$00                        ;;902E|9060+903F/9060\9060;
                                                                ;;                        ;
DATA_049064:          db $00,$00,$02,$00,$04,$00,$06,$00        ;;9032|9064+9043/9064\9064;
DATA_04906C:          db $28,$00,$08,$00,$14,$00,$36,$00        ;;903A|906C+904B/906C\906C;
                      db $3F,$00,$45,$00                        ;;9042|9074+9053/9074\9074;
                                                                ;;                        ;
HardCodedOWPaths:     db $09,$15,$23,$1B,$43,$44,$24,$FF        ;;9046|9078+9057/9078\9078;
                      db $30,$31                                ;;904E|9080+905F/9080\9080;
                                                                ;;                        ;
DATA_049082:          db $78,$01                                ;;9050|9082+9061/9082\9082;
                                                                ;;                        ;
DATA_049084:          db $28,$01                                ;;9052|9084+9063/9084\9084;
                                                                ;;                        ;
OWHardCodedTiles:                                               ;;                        ;
OWPathDP2_DP1:        db $10,$10,$1E,$19,$16,$66                ;;9054|9086+9065/9086\9086;
OWPathDP1_DP2:        db $16,$19,$1E,$10,$10,$66                ;;905A|908C+906B/908C\908C;
OWPathCI3_CF:         db $04,$04,$04,$58                        ;;9060|9092+9071/9092\9092;
OWPathCF_CI3:         db $04,$04,$04,$66                        ;;9064|9096+9075/9096\9096;
OWPathFoI4_FoI2:      db $04,$04,$04,$04,$04,$6A                ;;9068|909A+9079/909A\909A;
OWPathFoI2_FoI4:      db $04,$04,$04,$04,$04,$66                ;;906E|90A0+907F/90A0\90A0;
OWPathCI2_Pipe:       db $1E,$19,$06,$09,$0F,$20,$1A,$21        ;;9074|90A6+9085/90A6\90A6;
                      db $1A,$14,$19,$18,$1F,$17,$82            ;;907C|90AE+908D/90AE\90AE;
OWPathPipe_CI2:       db $17,$1F,$18,$19,$14,$1A,$21,$1A        ;;9083|90B5+9094/90B5\90B5;
                      db $20,$0F,$09,$06,$19,$1E,$66            ;;908B|90BD+909C/90BD\90BD;
OWPathStar_FD:        db $04,$04,$58                            ;;9092|90C4+90A3/90C4\90C4;
OWPathFD_Star:        db $04,$04,$5F                            ;;9095|90C7+90A6/90C7\90C7;
                                                                ;;                        ;
OWHardCodedDirs:                                                ;;                        ;
OWDirDP2_DP1:         db $02,$02,$02,$02,$06,$06                ;;9098|90CA+90A9/90CA\90CA;
OWDirDP1_DP2:         db $04,$04,$00,$00,$00,$00                ;;909E|90D0+90AF/90D0\90D0;
OWDirCI3_CF:          db $04,$04,$04,$04                        ;;90A4|90D6+90B5/90D6\90D6;
OWDirCF_CI3:          db $06,$06,$06,$06                        ;;90A8|90DA+90B9/90DA\90DA;
OWDirFoI4_FoI2:       db $06,$06,$06,$06,$06,$06                ;;90AC|90DE+90BD/90DE\90DE;
OWDirFoI2_FoI4:       db $04,$04,$04,$04,$04,$04                ;;90B2|90E4+90C3/90E4\90E4;
OWDirCI2_Pipe:        db $02,$02,$06,$06,$00,$00,$00,$04        ;;90B8|90EA+90C9/90EA\90EA;
                      db $00,$04,$04,$00,$04,$00,$04            ;;90C0|90F2+90D1/90F2\90F2;
OWDirPipe_CI2:        db $06,$02,$06,$02,$06,$06,$02,$06        ;;90C7|90F9+90D8/90F9\90F9;
                      db $02,$02,$02,$04,$04,$00,$00            ;;90CF|9001+90E0/9001\9001;
OWDirStar_FD:         db $06,$06,$06                            ;;90D6|9008+90E7/9008\9008;
OWDirFD_Star:         db $04,$04,$04                            ;;90D9|900B+90EA/900B\900B;
                                                                ;;                        ;
DATA_04910E:          db OWPathDP2_DP1-OWHardCodedTiles         ;;90DC|900E+90ED/900E\900E;
                      db OWPathDP1_DP2-OWHardCodedTiles         ;;90DD|900F+90EE/900F\900F;
                      db OWPathCI3_CF-OWHardCodedTiles          ;;90DE|9010+90EF/9010\9010;
                      db OWPathCF_CI3-OWHardCodedTiles          ;;90DF|9011+90F0/9011\9011;
                      db OWPathFoI4_FoI2-OWHardCodedTiles       ;;90E0|9012+90F1/9012\9012;
                      db OWPathFoI2_FoI4-OWHardCodedTiles       ;;90E1|9013+90F2/9013\9013;
                      db OWPathCI2_Pipe-OWHardCodedTiles        ;;90E2|9014+90F3/9014\9014;
                      db OWPathPipe_CI2-OWHardCodedTiles        ;;90E3|9015+90F4/9015\9015;
                      db OWPathStar_FD-OWHardCodedTiles         ;;90E4|9016+90F5/9016\9016;
                      db OWPathFD_Star-OWHardCodedTiles         ;;90E5|9017+90F6/9017\9017;
                                                                ;;                        ;
DATA_049118:          db $08,$00,$04,$00,$02,$00,$01,$00        ;;90E6|9118+90F7/9118\9118;
                                                                ;;                        ;
CODE_049120:          STZ.W !PlayerSwitching                    ;;90EE|9120+90FF/9120\9120;
                      LDY.W !EnterLevelAuto                     ;;90F1|9123+9102/9123\9123;
                      BMI OWPU_NotOnPipe                        ;;90F4|9126+9105/9126\9126;
                      LDA.W !OWLevelExitMode                    ;;90F6|9128+9107/9128\9128;
                      BMI CODE_049132                           ;;90F9|912B+910A/912B\912B;
                      BEQ CODE_049132                           ;;90FB|912D+910C/912D\912D;
                      BRL CODE_0491E9                           ;;90FD|912F+910E/912F\912F;
CODE_049132:          LDA.B !byetudlrFrame                      ;;9100|9132+9111/9132\9132;
                      AND.B #$20                                ;;9102|9134+9113/9134\9134;
                      BRA +                                     ;;9104|9136+9115/9136\9136; Change to BEQ to enable below debug code 
                                                                ;;                        ;
                      LDA.W !OverworldLayer1Tile                ;;9106|9138+9117/9138\9138; \ Unreachable 
                      BEQ CODE_049165                           ;;9109|913B+911A/913B\913B;  | Debug: Warp to star road from Yoshi's house 
                      CMP.B #$56                                ;;910B|913D+911C/913D\913D;  | 
                      BEQ CODE_049165                           ;;910D|913F+911E/913F\913F; / 
                   if ver_is_english(!_VER)           ;\   IF   ;;++++++++++++++++++++++++; U, SS, E0, & E1
                    + LDA.B !axlr0000Hold                       ;;    |9141+9120/9141\9141; \ 
                      AND.B #$30                                ;;    |9143+9122/9143\9143;  |If L and R aren't pressed, 
                      CMP.B #$30                                ;;    |9145+9124/9145\9145;  |branch to OWPU_NoLR 
                      BNE +                                     ;;    |9147+9126/9147\9147; / 
                      LDA.W !OverworldLayer1Tile                ;;    |9149+9128/9149\9149; \ 
                      CMP.B #$81                                ;;    |914C+912B/914C\914C;  |If Mario is standing on Destroyed Castle, 
                      BEQ OWPU_EnterLevel                       ;;    |914E+912D/914E\914E; / branch to OWPU_EnterLevel 
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                    + LDA.B !byetudlrFrame                      ;;910F|9150+912F/9150\9150; \ 
                      ORA.B !axlr0000Frame                      ;;9111|9152+9131/9152\9152;  |If A, B, X or Y are pressed, 
                      AND.B #$C0                                ;;9113|9154+9133/9154\9154;  |branch to OWPU_ABXY 
                      BNE OWPU_ABXY                             ;;9115|9156+9135/9156\9156;  |Otherwise, 
                      BRL CODE_0491E9                           ;;9117|9158+9137/9158\9158; / branch to $91E9 
OWPU_ABXY:            STZ.W !SwapOverworldMusic                 ;;911A|915B+913A/915B\915B;
                      LDA.W !OverworldLayer1Tile                ;;911D|915E+913D/915E\915E; \ 
                      CMP.B #$5F                                ;;9120|9161+9140/9161\9161;  |If not standing on a star tile, 
                      BNE OWPU_NotOnStar                        ;;9122|9163+9142/9163\9163; / branch to OWPU_NotOnStar 
CODE_049165:          JSR CODE_048509                           ;;9124|9165+9144/9165\9165;
                      BNE OWPU_IsOnPipeRTS                      ;;9127|9168+9147/9168\9168;
                      STZ.W !StarWarpLaunchSpeed                ;;9129|916A+9149/916A\916A; Set "Fly away" speed to 0 
                      STZ.W !StarWarpLaunchTimer                ;;912C|916D+914C/916D\916D; Set "Stay on ground" timer to 0 (31 = Fly away) 
                      LDA.B #!SFX_FEATHER                       ;;912F|9170+914F/9170\9170; \ Star Road sound effect 
                      STA.W !SPCIO0                             ;;9131|9172+9151/9172\9172; / 
                      LDA.B #$0B                                ;;9134|9175+9154/9175\9175; \ Activate star warp 
                      STA.W !OverworldProcess                   ;;9136|9177+9156/9177\9177; / 
                      JMP CODE_049E52                           ;;9139|917A+9159/917A\917A;
                                                                ;;                        ;
OWPU_NotOnStar:       LDA.W !OverworldLayer1Tile                ;;913C|917D+915C/917D\917D; \ 
                      CMP.B #$82                                ;;913F|9180+915F/9180\9180;  |If standing on Pipe#1 (unused), 
                      BEQ OWPU_IsOnPipe                         ;;9141|9182+9161/9182\9182; / branch to OWPU_IsOnPipe 
                      CMP.B #$5B                                ;;9143|9184+9163/9184\9184; \ If not standing on Pipe#2, 
                      BNE OWPU_NotOnPipe                        ;;9145|9186+9165/9186\9186; / branch to OWPU_NotOnPipe 
OWPU_IsOnPipe:        JSR CODE_048509                           ;;9147|9188+9167/9188\9188;
                      BNE OWPU_IsOnPipeRTS                      ;;914A|918B+916A/918B\918B;
CODE_04918D:          INC.W !EnteringStarWarp                   ;;914C|918D+916C/918D\918D;
                      STZ.W !OWLevelExitMode                    ;;914F|9190+916F/9190\9190; Set auto-walk to 0 
                      LDA.B #$0B                                ;;9152|9193+9172/9193\9193; \ Fade to overworld 
                      STA.W !GameMode                           ;;9154|9195+9174/9195\9195; / 
OWPU_IsOnPipeRTS:     RTS                                       ;;9157|9198+9177/9198\9198; Return 
                                                                ;;                        ;
OWPU_NotOnPipe:       CMP.B #$81                                ;;9158|9199+9178/9199\9199; \ 
                      BEQ CODE_0491E9                           ;;915A|919B+917A/919B\919B;  |If standing on a tile >= (?) Destroyed Castle, 
                      BCS CODE_0491E9                           ;;915C|919D+917C/919D\919D; / branch to $91E9 
OWPU_EnterLevel:      LDA.W !PlayerTurnOW                       ;;915E|919F+917E/919F\919F; \ 
                      LSR A                                     ;;9161|91A2+9181/91A2\91A2;  |If current player is Luigi, 
                      AND.B #$02                                ;;9162|91A3+9182/91A3\91A3;  |change Luigi's animation in the following lines 
                      TAX                                       ;;9164|91A5+9184/91A5\91A5; / 
                      LDY.B #$10                                ;;9165|91A6+9185/91A6\91A6; \ 
                      LDA.W !OWPlayerAnimation,X                ;;9167|91A8+9187/91A8\91A8;  | 
                      AND.B #$08                                ;;916A|91AB+918A/91AB\91AB;  |If Mario isn't swimming, use "raise hand" animation 
                      BEQ +                                     ;;916C|91AD+918C/91AD\91AD;  |Otherwise, use "raise hand, swimming" animation 
                      LDY.B #$12                                ;;916E|91AF+918E/91AF\91AF;  | 
                    + TYA                                       ;;9170|91B1+9190/91B1\91B1;  | 
                      STA.W !OWPlayerAnimation,X                ;;9171|91B2+9191/91B2\91B2; / 
                      LDX.W !PlayerTurnLvl                      ;;9174|91B5+9194/91B5\91B5; Get current character 
                      LDA.W !SavedPlayerCoins,X                 ;;9177|91B8+9197/91B8\91B8; \ Get character's coins 
                      STA.W !PlayerCoins                        ;;917A|91BB+919A/91BB\91BB; / 
                      LDA.W !SavedPlayerLives,X                 ;;917D|91BE+919D/91BE\91BE; \ Get character's lives 
                      STA.W !PlayerLives                        ;;9180|91C1+91A0/91C1\91C1; / 
                      LDA.W !SavedPlayerPowerup,X               ;;9183|91C4+91A3/91C4\91C4; \ Get character's powerup 
                      STA.B !Powerup                            ;;9186|91C7+91A6/91C7\91C7; / 
                      LDA.W !SavedPlayerYoshi,X                 ;;9188|91C9+91A8/91C9\91C9; \ 
                      STA.W !CarryYoshiThruLvls                 ;;918B|91CC+91AB/91CC\91CC;  |Get character's Yoshi color 
                      STA.W !YoshiColor                         ;;918E|91CF+91AE/91CF\91CF;  | 
                      STA.W !PlayerRidingYoshi                  ;;9191|91D2+91B1/91D2\91D2; / 
                      LDA.W !SavedPlayerItembox,X               ;;9194|91D5+91B4/91D5\91D5; \ Get character's reserved item 
                      STA.W !PlayerItembox                      ;;9197|91D8+91B7/91D8\91D8; / 
                      LDA.B #$02                                ;;919A|91DB+91BA/91DB\91DB; \ Related to fade speed 
                      STA.W !KeepModeActive                     ;;919C|91DD+91BC/91DD\91DD; / 
                      LDA.B #!BGM_FADEOUT                       ;;919F|91E0+91BF/91E0\91E0; \ Music fade out 
                      STA.W !SPCIO2                             ;;91A1|91E2+91C1/91E2\91E2; / 
                      INC.W !GameMode                           ;;91A4|91E5+91C4/91E5\91E5; Fade to level 
                      RTS                                       ;;91A7|91E8+91C7/91E8\91E8; Return 
                                                                ;;                        ;
CODE_0491E9:          REP #$20                                  ;;91A8|91E9+91C8/91E9\91E9; 16 bit A ; Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;91AA|91EB+91CA/91EB\91EB; Get current character * 4 
                      LDA.W !OWPlayerXPos,X                     ;;91AD|91EE+91CD/91EE\91EE; Get character's X coordinate 
                      LSR A                                     ;;91B0|91F1+91D0/91F1\91F1; \ 
                      LSR A                                     ;;91B1|91F2+91D1/91F2\91F2;  |Divide X coordinate by 16 
                      LSR A                                     ;;91B2|91F3+91D2/91F3\91F3;  | 
                      LSR A                                     ;;91B3|91F4+91D3/91F4\91F4; / 
                      STA.B !_0                                 ;;91B4|91F5+91D4/91F5\91F5; \ Store in $00 and $1F1F,x 
                      STA.W !OWPlayerXPosPtr,X                  ;;91B6|91F7+91D6/91F7\91F7; / 
                      LDA.W !OWPlayerYPos,X                     ;;91B9|91FA+91D9/91FA\91FA; Get character's Y coordinate 
                      LSR A                                     ;;91BC|91FD+91DC/91FD\91FD; \ 
                      LSR A                                     ;;91BD|91FE+91DD/91FE\91FE;  |Divide Y coordinate by 16 
                      LSR A                                     ;;91BE|91FF+91DE/91FF\91FF;  | 
                      LSR A                                     ;;91BF|9200+91DF/9200\9200; / 
                      STA.B !_2                                 ;;91C0|9201+91E0/9201\9201; \ Store in $02 and $1F21,x 
                      STA.W !OWPlayerYPosPtr,X                  ;;91C2|9203+91E2/9203\9203; / 
                      TXA                                       ;;91C5|9206+91E5/9206\9206; \ 
                      LSR A                                     ;;91C6|9207+91E6/9207\9207;  |Divide (current character * 4) by 4 
                      LSR A                                     ;;91C7|9208+91E7/9208\9208;  | 
                      TAX                                       ;;91C8|9209+91E8/9209\9209; / 
                      JSR OW_TilePos_Calc                       ;;91C9|920A+91E9/920A\920A; Calculate current tile pos 
                      SEP #$20                                  ;;91CC|920D+91EC/920D\920D; 8 bit A ; Accum (8 bit) 
                      LDX.W !OWLevelExitMode                    ;;91CE|920F+91EE/920F\920F; \ If auto-walk=0, 
                      BEQ OWPU_NotAutoWalk                      ;;91D1|9212+91F1/9212\9212; / branch to OWPU_NotAutoWalk 
                      DEX                                       ;;91D3|9214+91F3/9214\9214;
                      LDA.W DATA_049060,X                       ;;91D4|9215+91F4/9215\9215;
                      STA.B !_8                                 ;;91D7|9218+91F7/9218\9218;
                      STZ.B !_9                                 ;;91D9|921A+91F9/921A\921A;
                      REP #$30                                  ;;91DB|921C+91FB/921C\921C; 16 bit A,X,Y ; Index (16 bit) Accum (16 bit) 
                      LDX.B !_4                                 ;;91DD|921E+91FD/921E\921E; X = tile pos 
                      LDA.L !OWLayer1Translevel,X               ;;91DF|9220+91FF/9220\9220; \ Get level number of current tile pos 
                      AND.W #$00FF                              ;;91E3|9224+9203/9224\9224; / 
                      LDY.W #$000A                              ;;91E6|9227+9206/9227\9227;
CODE_04922A:          CMP.W DATA_04906C,Y                       ;;91E9|922A+9209/922A\922A;
                      BNE CODE_04923B                           ;;91EC|922D+920C/922D\922D;
                      LDA.W #$0005                              ;;91EE|922F+920E/922F\922F;
                      STA.W !OverworldProcess                   ;;91F1|9232+9211/9232\9232;
                      JSR CODE_049037                           ;;91F4|9235+9214/9235\9235;
                      BRL CODE_049411                           ;;91F7|9238+9217/9238\9238;
CODE_04923B:          DEY                                       ;;91FA|923B+921A/923B\923B;
                      DEY                                       ;;91FB|923C+921B/923C\923C;
                      BPL CODE_04922A                           ;;91FC|923D+921C/923D\923D;
                      LDA.L !OWLayer2Directions,X               ;;91FE|923F+921E/923F\923F;
                      AND.W #$00FF                              ;;9202|9243+9222/9243\9243;
                      LDX.B !_8                                 ;;9205|9246+9225/9246\9246;
                      BEQ CODE_04924E                           ;;9207|9248+9227/9248\9248;
                    - LSR A                                     ;;9209|924A+9229/924A\924A;
                      DEX                                       ;;920A|924B+922A/924B\924B;
                      BPL -                                     ;;920B|924C+922B/924C\924C;
CODE_04924E:          AND.W #$0003                              ;;920D|924E+922D/924E\924E;
                      ASL A                                     ;;9210|9251+9230/9251\9251;
                      TAX                                       ;;9211|9252+9231/9252\9252;
                      LDA.W DATA_049064,X                       ;;9212|9253+9232/9253\9253;
                      TAY                                       ;;9215|9256+9235/9256\9256;
                      JMP CODE_0492BC                           ;;9216|9257+9236/9257\9257;
                                                                ;;                        ;
OWPU_NotAutoWalk:     SEP #$30                                  ;;9219|925A+9239/925A\925A; 8 bit A,X,Y ; Index (8 bit) Accum (8 bit) 
                      STZ.W !OWLevelExitMode                    ;;921B|925C+923B/925C\925C; Set auto-walk to 0 
                      LDA.B !byetudlrFrame                      ;;921E|925F+923E/925F\925F; \ 
                      AND.B #$0F                                ;;9220|9261+9240/9261\9261;  |If no dir button is pressed (one frame), 
                      BEQ CODE_04926E                           ;;9222|9263+9242/9263\9263; / branch to $926E 
                      LDX.W !OverworldLayer1Tile                ;;9224|9265+9244/9265\9265; \ 
                      CPX.B #$82                                ;;9227|9268+9247/9268\9268;  |If standing on Pipe#2, 
                      BEQ CODE_0492AD                           ;;9229|926A+9249/926A\926A;  |branch to $92AD 
                      BRA CODE_04928C                           ;;922B|926C+924B/926C\926C; / Otherwise, branch to $928C 
                                                                ;;                        ;
CODE_04926E:          DEC.W !Layer1ScrollXPosUpd                ;;922D|926E+924D/926E\926E; \ Decrease "Face walking dir" timer 
                      BPL +                                     ;;9230|9271+9250/9271\9271; / If >= 0, branch to $9287 
                      STZ.W !Layer1ScrollXPosUpd                ;;9232|9273+9252/9273\9273; Set "Face walking dir" timer to 0 
                      LDA.W !PlayerTurnOW                       ;;9235|9276+9255/9276\9276; \ 
                      LSR A                                     ;;9238|9279+9258/9279\9279;  |Set X to current character * 2 
                      AND.B #$02                                ;;9239|927A+9259/927A\927A;  | 
                      TAX                                       ;;923B|927C+925B/927C\927C; / 
                      LDA.W !OWPlayerAnimation,X                ;;923C|927D+925C/927D\927D; \ 
                      AND.B #$08                                ;;923F|9280+925F/9280\9280;  |Set current character's animation to "facing down" 
                      ORA.B #$02                                ;;9241|9282+9261/9282\9282;  |or "facing down in water", depending on if character 
                      STA.W !OWPlayerAnimation,X                ;;9243|9284+9263/9284\9284; / is in water or not. 
                    + REP #$30                                  ;;9246|9287+9266/9287\9287; Index (16 bit) Accum (16 bit) 
                      JMP OWMoveScroll                          ;;9248|9289+9268/9289\9289;
                                                                ;;                        ;
CODE_04928C:          REP #$30                                  ;;924B|928C+926B/928C\928C; Index (16 bit) Accum (16 bit) 
                      AND.W #$00FF                              ;;924D|928E+926D/928E\928E;
                      NOP                                       ;;9250|9291+9270/9291\9291;
                      NOP                                       ;;9251|9292+9271/9292\9292;
                      NOP                                       ;;9252|9293+9272/9293\9293;
                      PHA                                       ;;9253|9294+9273/9294\9294;
                      STZ.B !_6                                 ;;9254|9295+9274/9295\9295;
                      LDX.B !_4                                 ;;9256|9297+9276/9297\9297;
                      LDA.L !OWLayer1Translevel,X               ;;9258|9299+9278/9299\9299;
                      AND.W #$00FF                              ;;925C|929D+927C/929D\929D;
                      TAX                                       ;;925F|92A0+927F/92A0\92A0;
                      PLA                                       ;;9260|92A1+9280/92A1\92A1;
                      AND.W !OWLevelTileSettings,X              ;;9261|92A2+9281/92A2\92A2;
                      AND.W #$000F                              ;;9264|92A5+9284/92A5\92A5;
                      BNE CODE_0492AD                           ;;9267|92A8+9287/92A8\92A8;
                      JMP CODE_049411                           ;;9269|92AA+9289/92AA\92AA;
                                                                ;;                        ;
CODE_0492AD:          REP #$30                                  ;;926C|92AD+928C/92AD\92AD; Index (16 bit) Accum (16 bit) 
                      AND.W #$00FF                              ;;926E|92AF+928E/92AF\92AF;
                      LDY.W #$0006                              ;;9271|92B2+9291/92B2\92B2;
CODE_0492B5:          LSR A                                     ;;9274|92B5+9294/92B5\92B5;
                      BCS CODE_0492BC                           ;;9275|92B6+9295/92B6\92B6;
                      DEY                                       ;;9277|92B8+9297/92B8\92B8;
                      DEY                                       ;;9278|92B9+9298/92B9\92B9;
                      BPL CODE_0492B5                           ;;9279|92BA+9299/92BA\92BA;
CODE_0492BC:          TYA                                       ;;927B|92BC+929B/92BC\92BC;
                      STA.W !OWPlayerDirection                  ;;927C|92BD+929C/92BD\92BD;
                      LDX.W #$0000                              ;;927F|92C0+929F/92C0\92C0;
                      CPY.W #$0004                              ;;9282|92C3+92A2/92C3\92C3;
                      BCS +                                     ;;9285|92C6+92A5/92C6\92C6;
                      LDX.W #$0002                              ;;9287|92C8+92A7/92C8\92C8;
                    + LDA.B !_4                                 ;;928A|92CB+92AA/92CB\92CB;
                      STA.B !_8                                 ;;928C|92CD+92AC/92CD\92CD;
                      LDA.B !_0,X                               ;;928E|92CF+92AE/92CF\92CF;
                      CLC                                       ;;9290|92D1+92B0/92D1\92D1;
                      ADC.W DATA_049058,Y                       ;;9291|92D2+92B1/92D2\92D2;
                      STA.B !_0,X                               ;;9294|92D5+92B4/92D5\92D5;
                      LDA.W !PlayerTurnOW                       ;;9296|92D7+92B6/92D7\92D7;
                      LSR A                                     ;;9299|92DA+92B9/92DA\92DA;
                      LSR A                                     ;;929A|92DB+92BA/92DB\92DB;
                      TAX                                       ;;929B|92DC+92BB/92DC\92DC;
                      JSR OW_TilePos_Calc                       ;;929C|92DD+92BC/92DD\92DD;
                      LDX.B !_4                                 ;;929F|92E0+92BF/92E0\92E0;
                      BMI CODE_049301                           ;;92A1|92E2+92C1/92E2\92E2;
                      CMP.W #$0800                              ;;92A3|92E4+92C3/92E4\92E4;
                      BCS CODE_049301                           ;;92A6|92E7+92C6/92E7\92E7;
                      LDA.L !Map16TilesLow,X                    ;;92A8|92E9+92C8/92E9\92E9;
                      AND.W #$00FF                              ;;92AC|92ED+92CC/92ED\92ED;
                      BEQ CODE_049301                           ;;92AF|92F0+92CF/92F0\92F0;
                      CMP.W #$0056                              ;;92B1|92F2+92D1/92F2\92F2;
                      BCC CODE_0492FE                           ;;92B4|92F5+92D4/92F5\92F5;
                      CMP.W #$0087                              ;;92B6|92F7+92D6/92F7\92F7;
                      BCC CODE_0492FE                           ;;92B9|92FA+92D9/92FA\92FA;
                      BRA CODE_049301                           ;;92BB|92FC+92DB/92FC\92FC;
                                                                ;;                        ;
CODE_0492FE:          BRL CODE_049384                           ;;92BD|92FE+92DD/92FE\92FE;
CODE_049301:          STZ.W !HardcodedPathIsUsed                ;;92C0|9301+92E0/9301\9301;
                      STZ.W !HardcodedPathIndex                 ;;92C3|9304+92E3/9304\9304;
                      LDX.B !_8                                 ;;92C6|9307+92E6/9307\9307;
                      LDA.L !OWLayer1Translevel,X               ;;92C8|9309+92E8/9309\9309;
                      AND.W #$00FF                              ;;92CC|930D+92EC/930D\930D;
                      STA.B !_0                                 ;;92CF|9310+92EF/9310\9310;
                      LDX.W #$0009                              ;;92D1|9312+92F1/9312\9312;
CODE_049315:          LDA.W HardCodedOWPaths,X                  ;;92D4|9315+92F4/9315\9315;
                      AND.W #$00FF                              ;;92D7|9318+92F7/9318\9318;
                      CMP.W #$00FF                              ;;92DA|931B+92FA/931B\931B;
                      BNE CODE_049349                           ;;92DD|931E+92FD/931E\931E;
                      PHX                                       ;;92DF|9320+92FF/9320\9320;
                      LDX.W !PlayerTurnOW                       ;;92E0|9321+9300/9321\9321;
                      LDA.W !OWPlayerYPos,X                     ;;92E3|9324+9303/9324\9324;
                      CMP.W DATA_049082                         ;;92E6|9327+9306/9327\9327;
                      BNE CODE_049346                           ;;92E9|932A+9309/932A\932A;
                      LDA.W !OWPlayerXPos,X                     ;;92EB|932C+930B/932C\932C;
                      CMP.W DATA_049084                         ;;92EE|932F+930E/932F\932F;
                      BNE CODE_049346                           ;;92F1|9332+9311/9332\9332;
                      LDA.W !PlayerTurnLvl                      ;;92F3|9334+9313/9334\9334;
                      AND.W #$00FF                              ;;92F6|9337+9316/9337\9337;
                      TAX                                       ;;92F9|933A+9319/933A\933A;
                      LDA.W !OWPlayerSubmap,X                   ;;92FA|933B+931A/933B\933B;
                      AND.W #$00FF                              ;;92FD|933E+931D/933E\933E;
                      BNE CODE_049346                           ;;9300|9341+9320/9341\9341;
                      PLX                                       ;;9302|9343+9322/9343\9343;
                      BRA CODE_04934D                           ;;9303|9344+9323/9344\9344;
                                                                ;;                        ;
CODE_049346:          PLX                                       ;;9305|9346+9325/9346\9346;
                      BRA CODE_049374                           ;;9306|9347+9326/9347\9347;
                                                                ;;                        ;
CODE_049349:          CMP.B !_0                                 ;;9308|9349+9328/9349\9349;
                      BNE CODE_049374                           ;;930A|934B+932A/934B\934B;
CODE_04934D:          STX.B !_0                                 ;;930C|934D+932C/934D\934D;
                      LDA.W DATA_04910E,X                       ;;930E|934F+932E/934F\934F;
                      AND.W #$00FF                              ;;9311|9352+9331/9352\9352;
                      TAX                                       ;;9314|9355+9334/9355\9355;
                      DEC A                                     ;;9315|9356+9335/9356\9356;
                      STA.W !HardcodedPathIndex                 ;;9316|9357+9336/9357\9357;
                      STY.B !_2                                 ;;9319|935A+9339/935A\935A;
                      LDA.W OWHardCodedDirs,X                   ;;931B|935C+933B/935C\935C;
                      AND.W #$00FF                              ;;931E|935F+933E/935F\935F;
                      CMP.B !_2                                 ;;9321|9362+9341/9362\9362;
                      BNE CODE_04937A                           ;;9323|9364+9343/9364\9364;
                      LDA.W #$0001                              ;;9325|9366+9345/9366\9366;
                      STA.W !HardcodedPathIsUsed                ;;9328|9369+9348/9369\9369;
                      LDA.W OWHardCodedTiles,X                  ;;932B|936C+934B/936C\936C;
                      AND.W #$00FF                              ;;932E|936F+934E/936F\936F;
                      BRA CODE_049384                           ;;9331|9372+9351/9372\9372;
                                                                ;;                        ;
CODE_049374:          DEX                                       ;;9333|9374+9353/9374\9374;
                      BMI CODE_04937A                           ;;9334|9375+9354/9375\9375;
                      BRL CODE_049315                           ;;9336|9377+9356/9377\9377;
CODE_04937A:          SEP #$20                                  ;;9339|937A+9359/937A\937A; Accum (8 bit) 
                      STZ.W !OWLevelExitMode                    ;;933B|937C+935B/937C\937C;
                      REP #$20                                  ;;933E|937F+935E/937F\937F; Accum (16 bit) 
                      JMP CODE_049411                           ;;9340|9381+9360/9381\9381;
                                                                ;;                        ;
CODE_049384:          STA.W !OverworldLayer1Tile                ;;9343|9384+9363/9384\9384;
                      STA.B !_0                                 ;;9346|9387+9366/9387\9387;
                      STZ.B !_2                                 ;;9348|9389+9368/9389\9389;
                      LDX.W #$0017                              ;;934A|938B+936A/938B\938B;
CODE_04938E:          LDA.W DATA_04A03C,X                       ;;934D|938E+936D/938E\938E;
                      AND.W #$00FF                              ;;9350|9391+9370/9391\9391;
                      CMP.B !_0                                 ;;9353|9394+9373/9394\9394;
                      BNE CODE_0493B5                           ;;9355|9396+9375/9396\9396;
                      LDA.W DATA_04A0E4,X                       ;;9357|9398+9377/9398\9398;
                      CLC                                       ;;935A|939B+937A/939B\939B;
                      ADC.W !PlayerTurnOW                       ;;935B|939C+937B/939C\939C;
                      PHA                                       ;;935E|939F+937E/939F\939F;
                      TXA                                       ;;935F|93A0+937F/93A0\93A0;
                      ASL A                                     ;;9360|93A1+9380/93A1\93A1;
                      ASL A                                     ;;9361|93A2+9381/93A2\93A2;
                      TAX                                       ;;9362|93A3+9382/93A3\93A3;
                      LDA.W DATA_04A084,X                       ;;9363|93A4+9383/93A4\93A4;
                      STA.B !_0                                 ;;9366|93A7+9386/93A7\93A7;
                      LDA.W DATA_04A086,X                       ;;9368|93A9+9388/93A9\93A9;
                      STA.B !_2                                 ;;936B|93AC+938B/93AC\93AC;
                      PLA                                       ;;936D|93AE+938D/93AE\93AE;
                      AND.W #$00FF                              ;;936E|93AF+938E/93AF\93AF;
                      TAX                                       ;;9371|93B2+9391/93B2\93B2;
                      BRA CODE_0493DA                           ;;9372|93B3+9392/93B3\93B3;
                                                                ;;                        ;
CODE_0493B5:          DEX                                       ;;9374|93B5+9394/93B5\93B5;
                      BPL CODE_04938E                           ;;9375|93B6+9395/93B6\93B6;
                      LDX.W #$0008                              ;;9377|93B8+9397/93B8\93B8;
                      TYA                                       ;;937A|93BB+939A/93BB\93BB;
                      AND.W #$0002                              ;;937B|93BC+939B/93BC\93BC;
                      BNE +                                     ;;937E|93BF+939E/93BF\93BF;
                      TXA                                       ;;9380|93C1+93A0/93C1\93C1;
                      EOR.W #$FFFF                              ;;9381|93C2+93A1/93C2\93C2;
                      INC A                                     ;;9384|93C5+93A4/93C5\93C5;
                      TAX                                       ;;9385|93C6+93A5/93C6\93C6;
                    + STX.B !_0                                 ;;9386|93C7+93A6/93C7\93C7;
                      LDX.W #$0000                              ;;9388|93C9+93A8/93C9\93C9;
                      CPY.W #$0004                              ;;938B|93CC+93AB/93CC\93CC;
                      BCS +                                     ;;938E|93CF+93AE/93CF\93CF;
                      LDX.W #$0002                              ;;9390|93D1+93B0/93D1\93D1;
                    + TXA                                       ;;9393|93D4+93B3/93D4\93D4;
                      CLC                                       ;;9394|93D5+93B4/93D5\93D5;
                      ADC.W !PlayerTurnOW                       ;;9395|93D6+93B5/93D6\93D6;
                      TAX                                       ;;9398|93D9+93B8/93D9\93D9;
CODE_0493DA:          LDA.B !_0                                 ;;9399|93DA+93B9/93DA\93DA;
                      CLC                                       ;;939B|93DC+93BB/93DC\93DC;
                      ADC.W !OWPlayerXPos,X                     ;;939C|93DD+93BC/93DD\93DD;
                      STA.W !OverworldDestXPos,X                ;;939F|93E0+93BF/93E0\93E0;
                      TXA                                       ;;93A2|93E3+93C2/93E3\93E3;
                      EOR.W #$0002                              ;;93A3|93E4+93C3/93E4\93E4;
                      TAX                                       ;;93A6|93E7+93C6/93E7\93E7;
                      LDA.B !_2                                 ;;93A7|93E8+93C7/93E8\93E8;
                      CLC                                       ;;93A9|93EA+93C9/93EA\93EA;
                      ADC.W !OWPlayerXPos,X                     ;;93AA|93EB+93CA/93EB\93EB;
                      STA.W !OverworldDestXPos,X                ;;93AD|93EE+93CD/93EE\93EE;
                      TXA                                       ;;93B0|93F1+93D0/93F1\93F1;
                      LSR A                                     ;;93B1|93F2+93D1/93F2\93F2;
                      AND.W #$0002                              ;;93B2|93F3+93D2/93F3\93F3;
                      TAX                                       ;;93B5|93F6+93D5/93F6\93F6;
                      TYA                                       ;;93B6|93F7+93D6/93F7\93F7;
                      STA.B !_0                                 ;;93B7|93F8+93D7/93F8\93F8;
                      LDA.W !OWPlayerAnimation,X                ;;93B9|93FA+93D9/93FA\93FA;
                      AND.W #$0008                              ;;93BC|93FD+93DC/93FD\93FD;
                      ORA.B !_0                                 ;;93BF|9400+93DF/9400\9400;
                      STA.W !OWPlayerAnimation,X                ;;93C1|9402+93E1/9402\9402;
                      LDA.W #$000F                              ;;93C4|9405+93E4/9405\9405;
                      STA.W !Layer1ScrollXPosUpd                ;;93C7|9408+93E7/9408\9408;
                      INC.W !OverworldProcess                   ;;93CA|940B+93EA/940B\940B;
                      STZ.W !Layer1ScrollTimer                  ;;93CD|940E+93ED/940E\940E;
CODE_049411:          JMP OWMoveScroll                          ;;93D0|9411+93F0/9411\9411;
                                                                ;;                        ;
                                                                ;;                        ;
DATA_049414:          db $0D,$08                                ;;93D3|9414+93F3/9414\9414;
                                                                ;;                        ;
DATA_049416:          db $EF,$FF,$D7,$FF                        ;;93D5|9416+93F5/9416\9416;
                                                                ;;                        ;
DATA_04941A:          db $11,$01,$31,$01                        ;;93D9|941A+93F9/941A\941A;
                                                                ;;                        ;
DATA_04941E:          db $08,$00,$04,$00,$02,$00,$01,$00        ;;93DD|941E+93FD/941E\941E;
DATA_049426:          db $44,$43,$45,$46,$47,$48,$25,$40        ;;93E5|9426+9405/9426\9426;
                      db $42,$4D                                ;;93ED|942E+940D/942E\942E;
                                                                ;;                        ;
DATA_049430:          db $0C                                    ;;93EF|9430+940F/9430\9430;
                                                                ;;                        ;
DATA_049431:          db $00,$0E,$00,$10,$06,$12,$00,$18        ;;93F0|9431+9410/9431\9431;
                      db $04,$1A,$02,$20,$06,$42,$06,$4E        ;;93F8|9439+9418/9439\9439;
                      db $04,$50,$02,$58,$06,$5A,$00,$70        ;;9400|9441+9420/9441\9441;
                      db $06,$90,$00,$A0,$06                    ;;9408|9449+9428/9449\9449;
                                                                ;;                        ;
DATA_04944E:          db $01,$01,$00,$01,$01,$00,$00,$00        ;;940D|944E+942D/944E\944E;
                      db $01,$00,$00,$01,$00,$01,$00            ;;9415|9456+9435/9456\9456;
                                                                ;;                        ;
CODE_04945D:          LDA.W !PlayerSwitching                    ;;941C|945D+943C/945D\945D; Accum (8 bit) 
                      BEQ +                                     ;;941F|9460+943F/9460\9460;
                      LDA.B #$08                                ;;9421|9462+9441/9462\9462;
                      STA.W !OverworldProcess                   ;;9423|9464+9443/9464\9464;
                      RTS                                       ;;9426|9467+9446/9467\9467; Return 
                                                                ;;                        ;
                    + REP #$30                                  ;;9427|9468+9447/9468\9468; Index (16 bit) Accum (16 bit) 
                      LDA.W !PlayerTurnOW                       ;;9429|946A+9449/946A\946A;
                      CLC                                       ;;942C|946D+944C/946D\946D;
                      ADC.W #$0002                              ;;942D|946E+944D/946E\946E;
                      TAY                                       ;;9430|9471+9450/9471\9471;
                      LDX.W #$0002                              ;;9431|9472+9451/9472\9472;
CODE_049475:          LDA.W !OverworldDestXPos,Y                ;;9434|9475+9454/9475\9475;
                      SEC                                       ;;9437|9478+9457/9478\9478;
                      SBC.W !OWPlayerXPos,Y                     ;;9438|9479+9458/9479\9479;
                      STA.B !_0,X                               ;;943B|947C+945B/947C\947C;
                      BPL +                                     ;;943D|947E+945D/947E\947E;
                      EOR.W #$FFFF                              ;;943F|9480+945F/9480\9480;
                      INC A                                     ;;9442|9483+9462/9483\9483;
                    + STA.B !_4,X                               ;;9443|9484+9463/9484\9484;
                      DEY                                       ;;9445|9486+9465/9486\9486;
                      DEY                                       ;;9446|9487+9466/9487\9487;
                      DEX                                       ;;9447|9488+9467/9488\9488;
                      DEX                                       ;;9448|9489+9468/9489\9489;
                      BPL CODE_049475                           ;;9449|948A+9469/948A\948A;
                      LDY.W #$FFFF                              ;;944B|948C+946B/948C\948C;
                      LDA.B !_4                                 ;;944E|948F+946E/948F\948F;
                      STA.B !_A                                 ;;9450|9491+9470/9491\9491;
                      LDA.B !_6                                 ;;9452|9493+9472/9493\9493;
                      STA.B !_C                                 ;;9454|9495+9474/9495\9495;
                      CMP.B !_4                                 ;;9456|9497+9476/9497\9497;
                      BCC +                                     ;;9458|9499+9478/9499\9499;
                      STA.B !_A                                 ;;945A|949B+947A/949B\949B;
                      LDA.B !_4                                 ;;945C|949D+947C/949D\949D;
                      STA.B !_C                                 ;;945E|949F+947E/949F\949F;
                      LDY.W #$0001                              ;;9460|94A1+9480/94A1\94A1;
                    + STY.B !_8                                 ;;9463|94A4+9483/94A4\94A4;
                      SEP #$20                                  ;;9465|94A6+9485/94A6\94A6; Accum (8 bit) 
                      LDX.W !OverworldClimbing                  ;;9467|94A8+9487/94A8\94A8;
                      LDA.W DATA_049414,X                       ;;946A|94AB+948A/94AB\94AB;
                      ASL A                                     ;;946D|94AE+948D/94AE\94AE;
                      ASL A                                     ;;946E|94AF+948E/94AF\94AF;
                      ASL A                                     ;;946F|94B0+948F/94B0\94B0;
                      ASL A                                     ;;9470|94B1+9490/94B1\94B1;
                      STA.W !HW_WRMPYA                          ;;9471|94B2+9491/94B2\94B2; Multiplicand A
                      LDA.B !_C                                 ;;9474|94B5+9494/94B5\94B5;
                      BEQ +                                     ;;9476|94B7+9496/94B7\94B7;
                      STA.W !HW_WRMPYB                          ;;9478|94B9+9498/94B9\94B9; Multplier B
                      NOP                                       ;;947B|94BC+949B/94BC\94BC;
                      NOP                                       ;;947C|94BD+949C/94BD\94BD;
                      NOP                                       ;;947D|94BE+949D/94BE\94BE;
                      NOP                                       ;;947E|94BF+949E/94BF\94BF;
                      REP #$20                                  ;;947F|94C0+949F/94C0\94C0; Accum (16 bit) 
                      LDA.W !HW_RDMPY                           ;;9481|94C2+94A1/94C2\94C2; Product/Remainder Result (Low Byte)
                      STA.W !HW_WRDIV                           ;;9484|94C5+94A4/94C5\94C5; Dividend (Low Byte)
                      SEP #$20                                  ;;9487|94C8+94A7/94C8\94C8; Accum (8 bit) 
                      LDA.B !_A                                 ;;9489|94CA+94A9/94CA\94CA;
                      STA.W !HW_WRDIV+2                         ;;948B|94CC+94AB/94CC\94CC; Divisor B
                      NOP                                       ;;948E|94CF+94AE/94CF\94CF;
                      NOP                                       ;;948F|94D0+94AF/94D0\94D0;
                      NOP                                       ;;9490|94D1+94B0/94D1\94D1;
                      NOP                                       ;;9491|94D2+94B1/94D2\94D2;
                      NOP                                       ;;9492|94D3+94B2/94D3\94D3;
                      NOP                                       ;;9493|94D4+94B3/94D4\94D4;
                      REP #$20                                  ;;9494|94D5+94B4/94D5\94D5; Accum (16 bit) 
                      LDA.W !HW_RDDIV                           ;;9496|94D7+94B6/94D7\94D7; Quotient of Divide Result (Low Byte)
                    + REP #$20                                  ;;9499|94DA+94B9/94DA\94DA; Accum (16 bit) 
                      STA.B !_E                                 ;;949B|94DC+94BB/94DC\94DC;
                      LDX.W !OverworldClimbing                  ;;949D|94DE+94BD/94DE\94DE;
                      LDA.W DATA_049414,X                       ;;94A0|94E1+94C0/94E1\94E1;
                      AND.W #$00FF                              ;;94A3|94E4+94C3/94E4\94E4;
                      ASL A                                     ;;94A6|94E7+94C6/94E7\94E7;
                      ASL A                                     ;;94A7|94E8+94C7/94E8\94E8;
                      ASL A                                     ;;94A8|94E9+94C8/94E9\94E9;
                      ASL A                                     ;;94A9|94EA+94C9/94EA\94EA;
                      STA.B !_A                                 ;;94AA|94EB+94CA/94EB\94EB;
                      LDX.W #$0002                              ;;94AC|94ED+94CC/94ED\94ED;
CODE_0494F0:          LDA.B !_8                                 ;;94AF|94F0+94CF/94F0\94F0;
                      BMI CODE_0494F8                           ;;94B1|94F2+94D1/94F2\94F2;
                      LDA.B !_A                                 ;;94B3|94F4+94D3/94F4\94F4;
                      BRA +                                     ;;94B5|94F6+94D5/94F6\94F6;
                                                                ;;                        ;
CODE_0494F8:          LDA.B !_E                                 ;;94B7|94F8+94D7/94F8\94F8;
                    + BIT.B !_0,X                               ;;94B9|94FA+94D9/94FA\94FA;
                      BPL +                                     ;;94BB|94FC+94DB/94FC\94FC;
                      EOR.W #$FFFF                              ;;94BD|94FE+94DD/94FE\94FE;
                      INC A                                     ;;94C0|9501+94E0/9501\9501;
                    + STA.W !OWPlayerSpeed,X                    ;;94C1|9502+94E1/9502\9502;
                      LDA.B !_8                                 ;;94C4|9505+94E4/9505\9505;
                      EOR.W #$FFFF                              ;;94C6|9507+94E6/9507\9507;
                      INC A                                     ;;94C9|950A+94E9/950A\950A;
                      STA.B !_8                                 ;;94CA|950B+94EA/950B\950B;
                      DEX                                       ;;94CC|950D+94EC/950D\950D;
                      DEX                                       ;;94CD|950E+94ED/950E\950E;
                      BPL CODE_0494F0                           ;;94CE|950F+94EE/950F\950F;
                      LDX.W #$0000                              ;;94D0|9511+94F0/9511\9511;
                      LDA.B !_8                                 ;;94D3|9514+94F3/9514\9514;
                      BMI +                                     ;;94D5|9516+94F5/9516\9516;
                      LDX.W #$0002                              ;;94D7|9518+94F7/9518\9518;
                    + LDA.B !_0,X                               ;;94DA|951B+94FA/951B\951B;
                      BEQ +                                     ;;94DC|951D+94FC/951D\951D;
                      JMP CODE_049801                           ;;94DE|951F+94FE/951F\951F;
                                                                ;;                        ;
                    + LDA.W !Layer1ScrollTimer                  ;;94E1|9522+9501/9522\9522;
                      BEQ +                                     ;;94E4|9525+9504/9525\9525;
                      STZ.W !HardcodedPathIsUsed                ;;94E6|9527+9506/9527\9527;
                      LDX.W !PlayerTurnOW                       ;;94E9|952A+9509/952A\952A;
                      LDA.W !OWPlayerXPosPtr,X                  ;;94EC|952D+950C/952D\952D;
                      STA.B !_0                                 ;;94EF|9530+950F/9530\9530;
                      LDA.W !OWPlayerYPosPtr,X                  ;;94F1|9532+9511/9532\9532;
                      STA.B !_2                                 ;;94F4|9535+9514/9535\9535;
                      TXA                                       ;;94F6|9537+9516/9537\9537;
                      LSR A                                     ;;94F7|9538+9517/9538\9538;
                      LSR A                                     ;;94F8|9539+9518/9539\9539;
                      TAX                                       ;;94F9|953A+9519/953A\953A;
                      JSR OW_TilePos_Calc                       ;;94FA|953B+951A/953B\953B;
                      STZ.B !_0                                 ;;94FD|953E+951D/953E\953E;
                      LDX.B !_4                                 ;;94FF|9540+951F/9540\9540;
                      LDA.L !OWLayer1Translevel,X               ;;9501|9542+9521/9542\9542;
                      AND.W #$00FF                              ;;9505|9546+9525/9546\9546;
                      ASL A                                     ;;9508|9549+9528/9549\9549;
                      TAX                                       ;;9509|954A+9529/954A\954A;
                      LDA.W LevelNames,X                        ;;950A|954B+952A/954B\954B;
                      STA.B !_0                                 ;;950D|954E+952D/954E\954E;
                      JSR CODE_049D07                           ;;950F|9550+952F/9550\9550;
                      INC.W !OverworldProcess                   ;;9512|9553+9532/9553\9553;
                      JSR CODE_049037                           ;;9515|9556+9535/9556\9556;
                      JMP OWMoveScroll                          ;;9518|9559+9538/9559\9559;
                                                                ;;                        ;
                    + LDA.W !OverworldLayer1Tile                ;;951B|955C+953B/955C\955C;
                      STA.W !OverworldTightPath                 ;;951E|955F+953E/955F\955F;
                      LDA.W #$0008                              ;;9521|9562+9541/9562\9562;
                      STA.B !_8                                 ;;9524|9565+9544/9565\9565;
                      LDY.W !OWPlayerDirection                  ;;9526|9567+9546/9567\9567;
                      TYA                                       ;;9529|956A+9549/956A\956A;
                      AND.W #$00FF                              ;;952A|956B+954A/956B\956B;
                      EOR.W #$0002                              ;;952D|956E+954D/956E\956E;
                      STA.B !_A                                 ;;9530|9571+9550/9571\9571;
                      BRA CODE_049582                           ;;9532|9573+9552/9573\9573;
                                                                ;;                        ;
ADDR_049575:          LDA.B !_8                                 ;;9534|9575+9554/9575\9575;
                      SEC                                       ;;9536|9577+9556/9577\9577;
                      SBC.W #$0002                              ;;9537|9578+9557/9578\9578;
                      STA.B !_8                                 ;;953A|957B+955A/957B\957B;
                      CMP.B !_A                                 ;;953C|957D+955C/957D\957D;
                      BEQ ADDR_049575                           ;;953E|957F+955E/957F\957F;
                      TAY                                       ;;9540|9581+9560/9581\9581;
CODE_049582:          LDX.W !PlayerTurnOW                       ;;9541|9582+9561/9582\9582;
                      LDA.W !OWPlayerXPosPtr,X                  ;;9544|9585+9564/9585\9585;
                      STA.B !_0                                 ;;9547|9588+9567/9588\9588;
                      LDA.W !OWPlayerYPosPtr,X                  ;;9549|958A+9569/958A\958A;
                      STA.B !_2                                 ;;954C|958D+956C/958D\958D;
                      LDX.W #$0000                              ;;954E|958F+956E/958F\958F;
                      CPY.W #$0004                              ;;9551|9592+9571/9592\9592;
                      BCS +                                     ;;9554|9595+9574/9595\9595;
                      LDX.W #$0002                              ;;9556|9597+9576/9597\9597;
                    + LDA.B !_0,X                               ;;9559|959A+9579/959A\959A;
                      CLC                                       ;;955B|959C+957B/959C\959C;
                      ADC.W DATA_049058,Y                       ;;955C|959D+957C/959D\959D;
                      STA.B !_0,X                               ;;955F|95A0+957F/95A0\95A0;
                      LDA.W !PlayerTurnOW                       ;;9561|95A2+9581/95A2\95A2;
                      LSR A                                     ;;9564|95A5+9584/95A5\95A5;
                      LSR A                                     ;;9565|95A6+9585/95A6\95A6;
                      TAX                                       ;;9566|95A7+9586/95A7\95A7;
                      JSR OW_TilePos_Calc                       ;;9567|95A8+9587/95A8\95A8;
                      LDA.W !HardcodedPathIsUsed                ;;956A|95AB+958A/95AB\95AB;
                      BEQ CODE_0495CE                           ;;956D|95AE+958D/95AE\95AE;
                      STY.B !_6                                 ;;956F|95B0+958F/95B0\95B0;
                      LDX.W !HardcodedPathIndex                 ;;9571|95B2+9591/95B2\95B2;
                      INX                                       ;;9574|95B5+9594/95B5\95B5;
                      LDA.W OWHardCodedDirs,X                   ;;9575|95B6+9595/95B6\95B6;
                      AND.W #$00FF                              ;;9578|95B9+9598/95B9\95B9;
                      CMP.B !_6                                 ;;957B|95BC+959B/95BC\95BC;
                      BNE ADDR_049575                           ;;957D|95BE+959D/95BE\95BE;
                      STX.W !HardcodedPathIndex                 ;;957F|95C0+959F/95C0\95C0;
                      LDA.W OWHardCodedTiles,X                  ;;9582|95C3+95A2/95C3\95C3;
                      AND.W #$00FF                              ;;9585|95C6+95A5/95C6\95C6;
                      CMP.W #$0058                              ;;9588|95C9+95A8/95C9\95C9;
                      BNE CODE_0495DE                           ;;958B|95CC+95AB/95CC\95CC;
CODE_0495CE:          LDX.B !_4                                 ;;958D|95CE+95AD/95CE\95CE;
                      BMI ADDR_049575                           ;;958F|95D0+95AF/95D0\95D0;
                      CMP.W #$0800                              ;;9591|95D2+95B1/95D2\95D2;
                      BCS ADDR_049575                           ;;9594|95D5+95B4/95D5\95D5;
                      LDA.L !Map16TilesLow,X                    ;;9596|95D7+95B6/95D7\95D7; \ Load OW tile number 
                      AND.W #$00FF                              ;;959A|95DB+95BA/95DB\95DB; / 
CODE_0495DE:          STA.W !OverworldLayer1Tile                ;;959D|95DE+95BD/95DE\95DE; Set "Current OW tile" 
                      BEQ ADDR_049575                           ;;95A0|95E1+95C0/95E1\95E1;
                      CMP.W #$0087                              ;;95A2|95E3+95C2/95E3\95E3;
                      BCS ADDR_049575                           ;;95A5|95E6+95C5/95E6\95E6;
                      PHA                                       ;;95A7|95E8+95C7/95E8\95E8;
                      PHY                                       ;;95A8|95E9+95C8/95E9\95E9;
                      TAX                                       ;;95A9|95EA+95C9/95EA\95EA;
                      DEX                                       ;;95AA|95EB+95CA/95EB\95EB;
                      LDY.W #$0000                              ;;95AB|95EC+95CB/95EC\95EC;
                      LDA.W DATA_049FEB,X                       ;;95AE|95EF+95CE/95EF\95EF;
                      STA.B !_E                                 ;;95B1|95F2+95D1/95F2\95F2;
                      AND.W #$00FF                              ;;95B3|95F4+95D3/95F4\95F4;
                      CMP.W #$0014                              ;;95B6|95F7+95D6/95F7\95F7;
                      BNE +                                     ;;95B9|95FA+95D9/95FA\95FA;
                      LDY.W #$0001                              ;;95BB|95FC+95DB/95FC\95FC;
                    + STY.W !OverworldClimbing                  ;;95BE|95FF+95DE/95FF\95FF;
                      LDX.W !PlayerTurnOW                       ;;95C1|9602+95E1/9602\9602;
                      LDA.B !_0                                 ;;95C4|9605+95E4/9605\9605;
                      STA.W !OWPlayerXPosPtr,X                  ;;95C6|9607+95E6/9607\9607;
                      LDA.B !_2                                 ;;95C9|960A+95E9/960A\960A;
                      STA.W !OWPlayerYPosPtr,X                  ;;95CB|960C+95EB/960C\960C;
                      PLY                                       ;;95CE|960F+95EE/960F\960F;
                      PLA                                       ;;95CF|9610+95EF/9610\9610;
                      PHA                                       ;;95D0|9611+95F0/9611\9611;
                      SEP #$30                                  ;;95D1|9612+95F1/9612\9612; Index (8 bit) Accum (8 bit) 
                      LDX.B #$09                                ;;95D3|9614+95F3/9614\9614;
CODE_049616:          CMP.W DATA_049426,X                       ;;95D5|9616+95F5/9616\9616;
                      BNE CODE_049645                           ;;95D8|9619+95F8/9619\9619;
                      PHY                                       ;;95DA|961B+95FA/961B\961B;
                      JSR CODE_049A24                           ;;95DB|961C+95FB/961C\961C;
                      PLY                                       ;;95DE|961F+95FE/961F\961F;
                      LDA.B #$01                                ;;95DF|9620+95FF/9620\9620;
                      STA.W !SwapOverworldMusic                 ;;95E1|9622+9601/9622\9622;
                      JSR CODE_04F407                           ;;95E4|9625+9604/9625\9625;
                      STZ.W !OWTransitionFlag                   ;;95E7|9628+9607/9628\9628;
                      REP #$20                                  ;;95EA|962B+960A/962B\962B; Accum (16 bit) 
                      STZ.W !BackgroundColor                    ;;95EC|962D+960C/962D\962D;
                      LDA.W #$7000                              ;;95EF|9630+960F/9630\9630;
                      STA.W !OWTransitionXCalc                  ;;95F2|9633+9612/9633\9633;
                      LDA.W #$5400                              ;;95F5|9636+9615/9636\9636;
                      STA.W !OWTransitionYCalc                  ;;95F8|9639+9618/9639\9639;
                      SEP #$20                                  ;;95FB|963C+961B/963C\963C; Accum (8 bit) 
                      LDA.B #$0A                                ;;95FD|963E+961D/963E\963E;
                      STA.W !OverworldProcess                   ;;95FF|9640+961F/9640\9640;
                      BRA CODE_049648                           ;;9602|9643+9622/9643\9643;
                                                                ;;                        ;
CODE_049645:          DEX                                       ;;9604|9645+9624/9645\9645;
                      BPL CODE_049616                           ;;9605|9646+9625/9646\9646;
CODE_049648:          REP #$30                                  ;;9607|9648+9627/9648\9648; Index (16 bit) Accum (16 bit) 
                      PLA                                       ;;9609|964A+9629/964A\964A;
                      PHA                                       ;;960A|964B+962A/964B\964B;
                      CMP.W #$0056                              ;;960B|964C+962B/964C\964C;
                      BCS +                                     ;;960E|964F+962E/964F\964F;
                      JMP CODE_04971D                           ;;9610|9651+9630/9651\9651;
                                                                ;;                        ;
                    + CMP.W #$0080                              ;;9613|9654+9633/9654\9654;
                      BEQ CODE_049663                           ;;9616|9657+9636/9657\9657;
                      CMP.W #$006A                              ;;9618|9659+9638/9659\9659;
                      BCC CODE_049676                           ;;961B|965C+963B/965C\965C;
                      CMP.W #$006E                              ;;961D|965E+963D/965E\965E;
                      BCS CODE_049676                           ;;9620|9661+9640/9661\9661;
CODE_049663:          LDA.W !PlayerTurnOW                       ;;9622|9663+9642/9663\9663;
                      LSR A                                     ;;9625|9666+9645/9666\9666;
                      AND.W #$0002                              ;;9626|9667+9646/9667\9667;
                      TAX                                       ;;9629|966A+9649/966A\966A;
                      LDA.W !OWPlayerAnimation,X                ;;962A|966B+964A/966B\966B;
                      ORA.W #$0008                              ;;962D|966E+964D/966E\966E;
                      STA.W !OWPlayerAnimation,X                ;;9630|9671+9650/9671\9671;
                      BRA +                                     ;;9633|9674+9653/9674\9674;
                                                                ;;                        ;
CODE_049676:          LDA.W !PlayerTurnOW                       ;;9635|9676+9655/9676\9676;
                      LSR A                                     ;;9638|9679+9658/9679\9679;
                      AND.W #$0002                              ;;9639|967A+9659/967A\967A;
                      TAX                                       ;;963C|967D+965C/967D\967D;
                      LDA.W !OWPlayerAnimation,X                ;;963D|967E+965D/967E\967E;
                      AND.W #$00F7                              ;;9640|9681+9660/9681\9681;
                      STA.W !OWPlayerAnimation,X                ;;9643|9684+9663/9684\9684;
                    + LDA.W #$0001                              ;;9646|9687+9666/9687\9687;
                      STA.W !Layer1ScrollTimer                  ;;9649|968A+9669/968A\968A;
                      LDA.W !OverworldLayer1Tile                ;;964C|968D+966C/968D\968D;
                      CMP.W #$005F                              ;;964F|9690+966F/9690\9690;
                      BEQ +                                     ;;9652|9693+9672/9693\9693;
                      CMP.W #$005B                              ;;9654|9695+9674/9695\9695;
                      BEQ +                                     ;;9657|9698+9677/9698\9698;
                      CMP.W #$0082                              ;;9659|969A+9679/969A\969A;
                      BEQ +                                     ;;965C|969D+967C/969D\969D;
                      LDA.W #!SFX_BEEP                          ;;965E|969F+967E/969F\969F;
                      STA.W !SPCIO3                             ;;9661|96A2+9681/96A2\96A2; / Play sound effect 
                    + NOP                                       ;;9664|96A5+9684/96A5\96A5;
                      NOP                                       ;;9665|96A6+9685/96A6\96A6;
                      NOP                                       ;;9666|96A7+9686/96A7\96A7;
                      LDA.W !OverworldLayer1Tile                ;;9667|96A8+9687/96A8\96A8;
                      AND.W #$00FF                              ;;966A|96AB+968A/96AB\96AB;
                      CMP.W #$0082                              ;;966D|96AE+968D/96AE\96AE;
                      BEQ +                                     ;;9670|96B1+9690/96B1\96B1;
                      PHY                                       ;;9672|96B3+9692/96B3\96B3;
                      TYA                                       ;;9673|96B4+9693/96B4\96B4;
                      AND.W #$00FF                              ;;9674|96B5+9694/96B5\96B5;
                      EOR.W #$0002                              ;;9677|96B8+9697/96B8\96B8;
                      TAY                                       ;;967A|96BB+969A/96BB\96BB;
                      STZ.B !_6                                 ;;967B|96BC+969B/96BC\96BC;
                      LDX.B !_4                                 ;;967D|96BE+969D/96BE\96BE;
                      LDA.L !OWLayer1Translevel,X               ;;967F|96C0+969F/96C0\96C0;
                      AND.W #$00FF                              ;;9683|96C4+96A3/96C4\96C4;
                      TAX                                       ;;9686|96C7+96A6/96C7\96C7;
                      LDA.W DATA_04941E,Y                       ;;9687|96C8+96A7/96C8\96C8;
                      ORA.W !OWLevelTileSettings,X              ;;968A|96CB+96AA/96CB\96CB;
                      STA.W !OWLevelTileSettings,X              ;;968D|96CE+96AD/96CE\96CE;
                      PLY                                       ;;9690|96D1+96B0/96D1\96D1;
                    + LDA.W !PlayerTurnOW                       ;;9691|96D2+96B1/96D2\96D2;
                      LSR A                                     ;;9694|96D5+96B4/96D5\96D5;
                      AND.W #$0002                              ;;9695|96D6+96B5/96D6\96D6;
                      TAX                                       ;;9698|96D9+96B8/96D9\96D9;
                      LDA.W !OWPlayerAnimation,X                ;;9699|96DA+96B9/96DA\96DA;
                      AND.W #$000C                              ;;969C|96DD+96BC/96DD\96DD;
                      STA.B !_E                                 ;;969F|96E0+96BF/96E0\96E0;
                      LDA.W #$0001                              ;;96A1|96E2+96C1/96E2\96E2;
                      STA.B !_4                                 ;;96A4|96E5+96C4/96E5\96E5;
                      LDA.W !OverworldTightPath                 ;;96A6|96E7+96C6/96E7\96E7;
                      AND.W #$00FF                              ;;96A9|96EA+96C9/96EA\96EA;
                      STA.B !_0                                 ;;96AC|96ED+96CC/96ED\96ED;
                      LDX.W #$0017                              ;;96AE|96EF+96CE/96EF\96EF;
CODE_0496F2:          LDA.W DATA_04A03C,X                       ;;96B1|96F2+96D1/96F2\96F2;
                      AND.W #$00FF                              ;;96B4|96F5+96D4/96F5\96F5;
                      CMP.B !_0                                 ;;96B7|96F8+96D7/96F8\96F8;
                      BNE CODE_049704                           ;;96B9|96FA+96D9/96FA\96FA;
                      TXA                                       ;;96BB|96FC+96DB/96FC\96FC;
                      ASL A                                     ;;96BC|96FD+96DC/96FD\96FD;
                      TAX                                       ;;96BD|96FE+96DD/96FE\96FE;
                      LDA.W DATA_04A054,X                       ;;96BE|96FF+96DE/96FF\96FF;
                      BRA CODE_049718                           ;;96C1|9702+96E1/9702\9702;
                                                                ;;                        ;
CODE_049704:          DEX                                       ;;96C3|9704+96E3/9704\9704;
                      BPL CODE_0496F2                           ;;96C4|9705+96E4/9705\9705;
                      LDA.W #$0000                              ;;96C6|9707+96E6/9707\9707;
                      ORA.W #$0800                              ;;96C9|970A+96E9/970A\970A;
                      CPY.W #$0004                              ;;96CC|970D+96EC/970D\970D;
                      BCC CODE_049718                           ;;96CF|9710+96EF/9710\9710;
                      LDA.W #$0000                              ;;96D1|9712+96F1/9712\9712;
                      ORA.W #$0008                              ;;96D4|9715+96F4/9715\9715;
CODE_049718:          LDX.W #$0000                              ;;96D7|9718+96F7/9718\9718;
                      BRA +                                     ;;96DA|971B+96FA/971B\971B;
                                                                ;;                        ;
CODE_04971D:          DEC A                                     ;;96DC|971D+96FC/971D\971D;
                      ASL A                                     ;;96DD|971E+96FD/971E\971E;
                      TAX                                       ;;96DE|971F+96FE/971F\971F;
                      LDA.W DATA_049F49,X                       ;;96DF|9720+96FF/9720\9720;
                      STA.B !_4                                 ;;96E2|9723+9702/9723\9723;
                      LDA.W DATA_049EA7,X                       ;;96E4|9725+9704/9725\9725;
                    + STA.B !_0                                 ;;96E7|9728+9707/9728\9728;
                      TXA                                       ;;96E9|972A+9709/972A\972A;
                      SEP #$20                                  ;;96EA|972B+970A/972B\972B; Accum (8 bit) 
                      LDX.W #$001C                              ;;96EC|972D+970C/972D\972D;
CODE_049730:          CMP.W DATA_049430,X                       ;;96EF|9730+970F/9730\9730;
                      BEQ CODE_04973B                           ;;96F2|9733+9712/9733\9733;
                      DEX                                       ;;96F4|9735+9714/9735\9735;
                      DEX                                       ;;96F5|9736+9715/9736\9736;
                      BPL CODE_049730                           ;;96F6|9737+9716/9737\9737;
                      BRA CODE_04974A                           ;;96F8|9739+9718/9739\9739;
                                                                ;;                        ;
CODE_04973B:          TYA                                       ;;96FA|973B+971A/973B\973B;
                      CMP.W DATA_049431,X                       ;;96FB|973C+971B/973C\973C;
                      BEQ CODE_04974A                           ;;96FE|973F+971E/973F\973F;
                      TXA                                       ;;9700|9741+9720/9741\9741;
                      LSR A                                     ;;9701|9742+9721/9742\9742;
                      TAX                                       ;;9702|9743+9722/9743\9743;
                      LDA.W DATA_04944E,X                       ;;9703|9744+9723/9744\9744;
                      TAX                                       ;;9706|9747+9726/9747\9747;
                      BRA +                                     ;;9707|9748+9727/9748\9748;
                                                                ;;                        ;
CODE_04974A:          LDX.W #$0000                              ;;9709|974A+9729/974A\974A;
                      TYA                                       ;;970C|974D+972C/974D\974D;
                      AND.B #$02                                ;;970D|974E+972D/974E\974E;
                      BEQ +                                     ;;970F|9750+972F/9750\9750;
                      LDX.W #$0001                              ;;9711|9752+9731/9752\9752;
                    + LDA.B !_4,X                               ;;9714|9755+9734/9755\9755;
                      BEQ +                                     ;;9716|9757+9736/9757\9757;
                      LDA.B !_0                                 ;;9718|9759+9738/9759\9759;
                      EOR.B #$FF                                ;;971A|975B+973A/975B\975B;
                      INC A                                     ;;971C|975D+973C/975D\975D;
                      STA.B !_0                                 ;;971D|975E+973D/975E\975E;
                      LDA.B !_1                                 ;;971F|9760+973F/9760\9760;
                      EOR.B #$FF                                ;;9721|9762+9741/9762\9762;
                      INC A                                     ;;9723|9764+9743/9764\9764;
                      STA.B !_1                                 ;;9724|9765+9744/9765\9765;
                    + REP #$20                                  ;;9726|9767+9746/9767\9767; Accum (16 bit) 
                      PLA                                       ;;9728|9769+9748/9769\9769;
                      LDX.W #$0000                              ;;9729|976A+9749/976A\976A;
                      LDA.B !_E                                 ;;972C|976D+974C/976D\976D;
                      AND.W #$0007                              ;;972E|976F+974E/976F\976F;
                      BNE +                                     ;;9731|9772+9751/9772\9772;
                      LDX.W #$0001                              ;;9733|9774+9753/9774\9774;
                    + LDA.B !_E                                 ;;9736|9777+9756/9777\9777;
                      AND.W #$00FF                              ;;9738|9779+9758/9779\9779;
                      STA.B !_4                                 ;;973B|977C+975B/977C\977C;
                      LDA.B !_0,X                               ;;973D|977E+975D/977E\977E;
                      AND.W #$00FF                              ;;973F|9780+975F/9780\9780;
                      CMP.W #$0080                              ;;9742|9783+9762/9783\9783;
                      BCS +                                     ;;9745|9786+9765/9786\9786;
                      LDA.B !_4                                 ;;9747|9788+9767/9788\9788;
                      CLC                                       ;;9749|978A+9769/978A\978A;
                      ADC.W #$0002                              ;;974A|978B+976A/978B\978B;
                      STA.B !_4                                 ;;974D|978E+976D/978E\978E;
                    + LDA.W !PlayerTurnOW                       ;;974F|9790+976F/9790\9790;
                      LSR A                                     ;;9752|9793+9772/9793\9793;
                      AND.W #$0002                              ;;9753|9794+9773/9794\9794;
                      TAX                                       ;;9756|9797+9776/9797\9797;
                      LDA.B !_4                                 ;;9757|9798+9777/9798\9798;
                      STA.W !OWPlayerAnimation,X                ;;9759|979A+9779/979A\979A;
                      LDX.W !PlayerTurnOW                       ;;975C|979D+977C/979D\979D;
                      LDA.B !_0                                 ;;975F|97A0+977F/97A0\97A0;
                      AND.W #$00FF                              ;;9761|97A2+9781/97A2\97A2;
                      CMP.W #$0080                              ;;9764|97A5+9784/97A5\97A5;
                      BCC +                                     ;;9767|97A8+9787/97A8\97A8;
                      ORA.W #$FF00                              ;;9769|97AA+9789/97AA\97AA;
                    + CLC                                       ;;976C|97AD+978C/97AD\97AD;
                      ADC.W !OWPlayerXPos,X                     ;;976D|97AE+978D/97AE\97AE;
                      AND.W #$FFFC                              ;;9770|97B1+9790/97B1\97B1;
                      STA.W !OverworldDestXPos,X                ;;9773|97B4+9793/97B4\97B4;
                      LDA.B !_1                                 ;;9776|97B7+9796/97B7\97B7;
                      AND.W #$00FF                              ;;9778|97B9+9798/97B9\97B9;
                      CMP.W #$0080                              ;;977B|97BC+979B/97BC\97BC;
                      BCC +                                     ;;977E|97BF+979E/97BF\97BF;
                      ORA.W #$FF00                              ;;9780|97C1+97A0/97C1\97C1;
                    + CLC                                       ;;9783|97C4+97A3/97C4\97C4;
                      ADC.W !OWPlayerYPos,X                     ;;9784|97C5+97A4/97C5\97C5;
                      AND.W #$FFFC                              ;;9787|97C8+97A7/97C8\97C8;
                      STA.W !OverworldDestYPos,X                ;;978A|97CB+97AA/97CB\97CB;
                      SEP #$20                                  ;;978D|97CE+97AD/97CE\97CE; Accum (8 bit) 
                      LDA.W !OverworldDestXPos,X                ;;978F|97D0+97AF/97D0\97D0;
                      AND.B #$0F                                ;;9792|97D3+97B2/97D3\97D3;
                      BNE CODE_0497E3                           ;;9794|97D5+97B4/97D5\97D5;
                      LDY.W #$0004                              ;;9796|97D7+97B6/97D7\97D7;
                      LDA.B !_0                                 ;;9799|97DA+97B9/97DA\97DA;
                      BMI +                                     ;;979B|97DC+97BB/97DC\97DC;
                      LDY.W #$0006                              ;;979D|97DE+97BD/97DE\97DE;
                    + BRA +                                     ;;97A0|97E1+97C0/97E1\97E1;
                                                                ;;                        ;
CODE_0497E3:          LDA.W !OverworldDestYPos,X                ;;97A2|97E3+97C2/97E3\97E3;
                      AND.B #$0F                                ;;97A5|97E6+97C5/97E6\97E6;
                      BNE +                                     ;;97A7|97E8+97C7/97E8\97E8;
                      LDY.W #$0000                              ;;97A9|97EA+97C9/97EA\97EA;
                      LDA.B !_1                                 ;;97AC|97ED+97CC/97ED\97ED;
                      BMI +                                     ;;97AE|97EF+97CE/97EF\97EF;
                      LDY.W #$0002                              ;;97B0|97F1+97D0/97F1\97F1;
                    + STY.W !OWPlayerDirection                  ;;97B3|97F4+97D3/97F4\97F4;
                      LDA.W !OverworldProcess                   ;;97B6|97F7+97D6/97F7\97F7;
                      CMP.B #$0A                                ;;97B9|97FA+97D9/97FA\97FA;
                      BEQ OWMoveScroll                          ;;97BB|97FC+97DB/97FC\97FC;
                      JMP CODE_04945D                           ;;97BD|97FE+97DD/97FE\97FE;
                                                                ;;                        ;
CODE_049801:          REP #$20                                  ;;97C0|9801+97E0/9801\9801; Accum (16 bit) 
                      LDA.W !PlayerTurnOW                       ;;97C2|9803+97E2/9803\9803;
                      CLC                                       ;;97C5|9806+97E5/9806\9806;
                      ADC.W #$0002                              ;;97C6|9807+97E6/9807\9807;
                      TAX                                       ;;97C9|980A+97E9/980A\980A;
                      LDY.W #$0002                              ;;97CA|980B+97EA/980B\980B;
CODE_04980E:          LDA.W !Layer3ScrollType,Y                 ;;97CD|980E+97ED/980E\980E;
                      AND.W #$00FF                              ;;97D0|9811+97F0/9811\9811;
                      CLC                                       ;;97D3|9814+97F3/9814\9814;
                      ADC.W !OWPlayerSpeed,Y                    ;;97D4|9815+97F4/9815\9815;
                      STA.W !Layer3ScrollType,Y                 ;;97D7|9818+97F7/9818\9818;
                      AND.W #$FF00                              ;;97DA|981B+97FA/981B\981B;
                      BPL +                                     ;;97DD|981E+97FD/981E\981E;
                      ORA.W #$00FF                              ;;97DF|9820+97FF/9820\9820;
                    + XBA                                       ;;97E2|9823+9802/9823\9823;
                      CLC                                       ;;97E3|9824+9803/9824\9824;
                      ADC.W !OWPlayerXPos,X                     ;;97E4|9825+9804/9825\9825;
                      STA.W !OWPlayerXPos,X                     ;;97E7|9828+9807/9828\9828;
                      DEX                                       ;;97EA|982B+980A/982B\982B;
                      DEX                                       ;;97EB|982C+980B/982C\982C;
                      DEY                                       ;;97EC|982D+980C/982D\982D;
                      DEY                                       ;;97ED|982E+980D/982E\982E;
                      BPL CODE_04980E                           ;;97EE|982F+980E/982F\982F;
OWMoveScroll:         SEP #$20                                  ;;97F0|9831+9810/9831\9831; Accum (8 bit) 
                      LDA.W !OverworldProcess                   ;;97F2|9833+9812/9833\9833; \
                      CMP.B #$0A                                ;;97F5|9836+9815/9836\9836; | Skip when in overworld mode $0A
                      BEQ OWCancelMoveScroll                    ;;97F7|9838+9817/9838\9838; /
                      LDA.W !OverworldEarthquake                ;;97F9|983A+9819/983A\983A; \
                      BNE OWCancelMoveScroll                    ;;97FC|983D+981C/983D\983D; / Skip if earthquake happening
CODE_04983F:          REP #$30                                  ;;97FE|983F+981E/983F\983F; Index (16 bit) Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;9800|9841+9820/9841\9841; \
                      LDA.W !OWPlayerXPos,X                     ;;9803|9844+9823/9844\9844; | Save player overworld X and Y positons
                      STA.B !_0                                 ;;9806|9847+9826/9847\9847; | To $00-$03
                      LDA.W !OWPlayerYPos,X                     ;;9808|9849+9828/9849\9849; | X: $00-$01, Y: $02-$03
                      STA.B !_2                                 ;;980B|984C+982B/984C\984C; /
                      TXA                                       ;;980D|984E+982D/984E\984E; \
                      LSR A                                     ;;980E|984F+982E/984F\984F; | X = 0 for Mario
                      LSR A                                     ;;980F|9850+982F/9850\9850; | X = 1 for Luigi
                      TAX                                       ;;9810|9851+9830/9851\9851; /
                      LDA.W !OWPlayerSubmap,X                   ;;9811|9852+9831/9852\9852; \
                      AND.W #$00FF                              ;;9814|9855+9834/9855\9855; | Don't scroll for any subworld
                      BNE OWCancelMoveScroll                    ;;9817|9858+9837/9858\9858; /
                      LDX.W #$0002                              ;;9819|985A+9839/985A\985A;
                      TXY                                       ;;981C|985D+983C/985D\985D;
CheckOWScrollBounds:  LDA.B !_0,X                               ;;981D|985E+983D/985E\985E; \ This section is done once for Y position then for X position
                      SEC                                       ;;981F|9860+983F/9860\9860; | If the player's position is >= #$0080
                      SBC.W #$0080                              ;;9820|9861+9840/9861\9861; | Try to scroll checking upper bound
                      BPL ++                                    ;;9823|9864+9843/9864\9864; /
                      CMP.W DATA_049416,Y                       ;;9825|9866+9845/9866\9866; \
                      BCS +                                     ;;9828|9869+9848/9869\9869; | If player less than lower bound 
                      LDA.W DATA_049416,Y                       ;;982A|986B+984A/986B\986B; | Set scroll to lower bound
                      BRA +                                     ;;982D|986E+984D/986E\986E; /
                                                                ;;                        ;
                   ++ CMP.W DATA_04941A,Y                       ;;982F|9870+984F/9870\9870; \ If player greater than uppper bound
                      BCC +                                     ;;9832|9873+9852/9873\9873; | Set scroll to upper bound
                      LDA.W DATA_04941A,Y                       ;;9834|9875+9854/9875\9875; /
                    + STA.B !Layer1XPos,X                       ;;9837|9878+9857/9878\9878;
                      STA.B !Layer2XPos,X                       ;;9839|987A+9859/987A\987A;
                      DEY                                       ;;983B|987C+985B/987C\987C; \
                      DEY                                       ;;983C|987D+985C/987D\987D; | If we were on Y position, decrement
                      DEX                                       ;;983D|987E+985D/987E\987E; | And repeat process for X position
                      DEX                                       ;;983E|987F+985E/987F\987F; |
                      BPL CheckOWScrollBounds                   ;;983F|9880+985F/9880\9880; /
OWCancelMoveScroll:   SEP #$30                                  ;;9841|9882+9861/9882\9882; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;9843|9884+9863/9884\9884; Return 
                                                                ;;                        ;
OW_TilePos_Calc:      LDA.B !_0                                 ;;9844|9885+9864/9885\9885; Get overworld X pos/16 (X) ; Accum (16 bit) 
                      AND.W #$000F                              ;;9846|9887+9866/9887\9887; \ 
                      STA.B !_4                                 ;;9849|988A+9869/988A\988A;  | 
                      LDA.B !_0                                 ;;984B|988C+986B/988C\988C;  | 
                      AND.W #$0010                              ;;984D|988E+986D/988E\988E;  | 
                      ASL A                                     ;;9850|9891+9870/9891\9891;  |Set tile pos to ((X&0xF)+((X&0x10)<<4)) 
                      ASL A                                     ;;9851|9892+9871/9892\9892;  | 
                      ASL A                                     ;;9852|9893+9872/9893\9893;  | 
                      ASL A                                     ;;9853|9894+9873/9894\9894;  | 
                      ADC.B !_4                                 ;;9854|9895+9874/9895\9895;  | 
                      STA.B !_4                                 ;;9856|9897+9876/9897\9897; / 
                      LDA.B !_2                                 ;;9858|9899+9878/9899\9899; Get overworld Y pos/16 (Y) 
                      ASL A                                     ;;985A|989B+987A/989B\989B; \ 
                      ASL A                                     ;;985B|989C+987B/989C\989C;  | 
                      ASL A                                     ;;985C|989D+987C/989D\989D;  |Increase tile pos by ((Y<<4)&0xFF) 
                      ASL A                                     ;;985D|989E+987D/989E\989E;  | 
                      AND.W #$00FF                              ;;985E|989F+987E/989F\989F;  | 
                      ADC.B !_4                                 ;;9861|98A2+9881/98A2\98A2;  | 
                      STA.B !_4                                 ;;9863|98A4+9883/98A4\98A4; / 
                      LDA.B !_2                                 ;;9865|98A6+9885/98A6\98A6; \ 
                      AND.W #$0010                              ;;9867|98A8+9887/98A8\98A8;  | 
                      BEQ +                                     ;;986A|98AB+988A/98AB\98AB;  |If (Y&0x10) isn't 0, 
                      LDA.B !_4                                 ;;986C|98AD+988C/98AD\98AD;  |increase tile pos by x200 
                      CLC                                       ;;986E|98AF+988E/98AF\98AF;  | 
                      ADC.W #$0200                              ;;986F|98B0+988F/98B0\98B0;  | 
                      STA.B !_4                                 ;;9872|98B3+9892/98B3\98B3; / 
                    + LDA.W !OWPlayerSubmap,X                   ;;9874|98B5+9894/98B5\98B5; \ 
                      AND.W #$00FF                              ;;9877|98B8+9897/98B8\98B8;  | 
                      BEQ Return0498C5                          ;;987A|98BB+989A/98BB\98BB;  |If on submap, 
                      LDA.B !_4                                 ;;987C|98BD+989C/98BD\98BD;  |Increase tile pos by x400 
                      CLC                                       ;;987E|98BF+989E/98BF\98BF;  | 
                      ADC.W #$0400                              ;;987F|98C0+989F/98C0\98C0;  | 
                      STA.B !_4                                 ;;9882|98C3+98A2/98C3\98C3; / 
Return0498C5:         RTS                                       ;;9884|98C5+98A4/98C5\98C5; Return 
                                                                ;;                        ;
CODE_0498C6:          STZ.W !OWPlayerAnimation                  ;;9885|98C6+98A5/98C6\98C6; Accum (8 bit) 
                      LDA.B #$80                                ;;9888|98C9+98A8/98C9\98C9;
                      CLC                                       ;;988A|98CB+98AA/98CB\98CB;
                      ADC.W !IntroMarchYPosSpx                  ;;988B|98CC+98AB/98CC\98CC;
                      STA.W !IntroMarchYPosSpx                  ;;988E|98CF+98AE/98CF\98CF;
                      PHP                                       ;;9891|98D2+98B1/98D2\98D2;
                      LDA.B #$0F                                ;;9892|98D3+98B2/98D3\98D3;
                      CMP.B #$08                                ;;9894|98D5+98B4/98D5\98D5;
                      LDY.B #$00                                ;;9896|98D7+98B6/98D7\98D7;
                      BCC +                                     ;;9898|98D9+98B8/98D9\98D9;
                      ORA.B #$F0                                ;;989A|98DB+98BA/98DB\98DB;
                      DEY                                       ;;989C|98DD+98BC/98DD\98DD;
                    + PLP                                       ;;989D|98DE+98BD/98DE\98DE;
                      ADC.W !OWPlayerYPos                       ;;989E|98DF+98BE/98DF\98DF;
                      STA.W !OWPlayerYPos                       ;;98A1|98E2+98C1/98E2\98E2;
                      TYA                                       ;;98A4|98E5+98C4/98E5\98E5;
                      ADC.W !OWPlayerYPos+1                     ;;98A5|98E6+98C5/98E6\98E6;
                      STA.W !OWPlayerYPos+1                     ;;98A8|98E9+98C8/98E9\98E9;
                      LDA.W !OWPlayerYPos                       ;;98AB|98EC+98CB/98EC\98EC;
                      CMP.B #$78                                ;;98AE|98EF+98CE/98EF\98EF;
                      BNE +                                     ;;98B0|98F1+98D0/98F1\98F1;
                      STZ.W !OverworldProcess                   ;;98B2|98F3+98D2/98F3\98F3;
                      JSL CODE_009BC9                           ;;98B5|98F6+98D5/98F6\98F6;
                    + RTS                                       ;;98B9|98FA+98D9/98FA\98FA; Return 
                                                                ;;                        ;
                                                                ;;                        ;
                      db $08,$00,$04,$00,$02,$00,$01,$00        ;;98BA|98FB+98DA/98FB\98FB;
                                                                ;;                        ;
CODE_049903:          LDX.W !OWLevelExitMode                    ;;98C2|9903+98E2/9903\9903;
                      BEQ Return0498C5                          ;;98C5|9906+98E5/9906\9906;
                      BMI Return0498C5                          ;;98C7|9908+98E7/9908\9908;
                      DEX                                       ;;98C9|990A+98E9/990A\990A;
                      LDA.W DATA_049060,X                       ;;98CA|990B+98EA/990B\990B;
                      STA.B !_8                                 ;;98CD|990E+98ED/990E\990E;
                      STZ.B !_9                                 ;;98CF|9910+98EF/9910\9910;
                      REP #$20                                  ;;98D1|9912+98F1/9912\9912; Accum (16 bit) 
                      LDX.W !PlayerTurnOW                       ;;98D3|9914+98F3/9914\9914;
                      LDA.W !OWPlayerXPos,X                     ;;98D6|9917+98F6/9917\9917;
                      LSR A                                     ;;98D9|991A+98F9/991A\991A;
                      LSR A                                     ;;98DA|991B+98FA/991B\991B;
                      LSR A                                     ;;98DB|991C+98FB/991C\991C;
                      LSR A                                     ;;98DC|991D+98FC/991D\991D;
                      STA.B !_0                                 ;;98DD|991E+98FD/991E\991E;
                      STA.W !OWPlayerXPosPtr,X                  ;;98DF|9920+98FF/9920\9920;
                      LDA.W !OWPlayerYPos,X                     ;;98E2|9923+9902/9923\9923;
                      LSR A                                     ;;98E5|9926+9905/9926\9926;
                      LSR A                                     ;;98E6|9927+9906/9927\9927;
                      LSR A                                     ;;98E7|9928+9907/9928\9928;
                      LSR A                                     ;;98E8|9929+9908/9929\9929;
                      STA.B !_2                                 ;;98E9|992A+9909/992A\992A;
                      STA.W !OWPlayerYPosPtr,X                  ;;98EB|992C+990B/992C\992C;
                      TXA                                       ;;98EE|992F+990E/992F\992F;
                      LSR A                                     ;;98EF|9930+990F/9930\9930;
                      LSR A                                     ;;98F0|9931+9910/9931\9931;
                      TAX                                       ;;98F1|9932+9911/9932\9932;
                      JSR OW_TilePos_Calc                       ;;98F2|9933+9912/9933\9933;
                      REP #$10                                  ;;98F5|9936+9915/9936\9936; Index (16 bit) 
                      LDX.B !_4                                 ;;98F7|9938+9917/9938\9938;
                      LDA.L !OWLayer2Directions,X               ;;98F9|993A+9919/993A\993A;
                      AND.W #$00FF                              ;;98FD|993E+991D/993E\993E;
                      LDX.B !_8                                 ;;9900|9941+9920/9941\9941;
                      BEQ CODE_049949                           ;;9902|9943+9922/9943\9943;
                    - LSR A                                     ;;9904|9945+9924/9945\9945;
                      DEX                                       ;;9905|9946+9925/9946\9946;
                      BPL -                                     ;;9906|9947+9926/9947\9947;
CODE_049949:          AND.W #$0003                              ;;9908|9949+9928/9949\9949;
                      ASL A                                     ;;990B|994C+992B/994C\994C;
                      TAY                                       ;;990C|994D+992C/994D\994D;
                      LDX.B !_4                                 ;;990D|994E+992D/994E\994E;
                      LDA.L !OWLayer1Translevel,X               ;;990F|9950+992F/9950\9950;
                      AND.W #$00FF                              ;;9913|9954+9933/9954\9954;
                      TAX                                       ;;9916|9957+9936/9957\9957;
                      LDA.W DATA_04941E,Y                       ;;9917|9958+9937/9958\9958;
                      ORA.W !OWLevelTileSettings,X              ;;991A|995B+993A/995B\995B;
                      STA.W !OWLevelTileSettings,X              ;;991D|995E+993D/995E\995E;
                      SEP #$30                                  ;;9920|9961+9940/9961\9961; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;9922|9963+9942/9963\9963; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_049964:          db $40,$01                                ;;9923|9964+9943/9964\9964;
                                                                ;;                        ;
DATA_049966:          db $28,$00                                ;;9925|9966+9945/9966\9966;
                                                                ;;                        ;
DATA_049968:          db $00,$50,$01,$58,$00,$00,$10,$00        ;;9927|9968+9947/9968\9968;
                      db $48,$00,$01,$10,$00,$98,$00,$01        ;;992F|9970+994F/9970\9970;
                      db $A0,$00,$D8,$00,$00,$40,$01,$58        ;;9937|9978+9957/9978\9978;
                      db $00,$02,$90,$00,$E8,$01,$04,$60        ;;993F|9980+995F/9980\9980;
                      db $01,$E8,$00,$00,$A0,$00,$C8,$01        ;;9947|9988+9967/9988\9988;
                      db $00,$60,$01,$88,$00,$03,$08,$01        ;;994F|9990+996F/9990\9990;
                      db $90,$01,$00,$E8,$01,$10,$00,$03        ;;9957|9998+9977/9998\9998;
                      db $10,$01,$C8,$01,$00,$F0,$01,$88        ;;995F|99A0+997F/99A0\99A0;
                      db $00,$03                                ;;9967|99A8+9987/99A8\99A8;
                                                                ;;                        ;
DATA_0499AA:          db $00,$00                                ;;9969|99AA+9989/99AA\99AA;
                                                                ;;                        ;
DATA_0499AC:          db $48,$00                                ;;996B|99AC+998B/99AC\99AC;
                                                                ;;                        ;
DATA_0499AE:          db $01,$00,$00,$98,$00,$01,$50,$01        ;;996D|99AE+998D/99AE\99AE;
                      db $28,$00,$00,$60,$01,$58,$00,$00        ;;9975|99B6+9995/99B6\99B6;
                      db $50,$01,$58,$00,$02,$90,$00,$D8        ;;997D|99BE+999D/99BE\99BE;
                      db $00,$00,$50,$01,$E8,$00,$00,$A0        ;;9985|99C6+99A5/99C6\99C6;
                      db $00,$E8,$01,$04,$50,$01,$88,$00        ;;998D|99CE+99AD/99CE\99CE;
                      db $03,$B0,$00,$C8,$01,$00,$E8,$01        ;;9995|99D6+99B5/99D6\99D6;
                      db $00,$00,$03,$08,$01,$A0,$01,$00        ;;999D|99DE+99BD/99DE\99DE;
                      db $00,$02,$88,$00,$03,$00,$01,$C8        ;;99A5|99E6+99C5/99E6\99E6;
                      db $01,$00                                ;;99AD|99EE+99CD/99EE\99EE;
                                                                ;;                        ;
DATA_0499F0:          db $00                                    ;;99AF|99F0+99CF/99F0\99F0;
                                                                ;;                        ;
DATA_0499F1:          db $04,$00,$09,$14,$02,$15,$05,$14        ;;99B0|99F1+99D0/99F1\99F1;
                      db $05,$09,$0D,$15,$0E,$09,$1E,$15        ;;99B8|99F9+99D8/99F9\99F9;
                      db $08,$0A,$1C,$1E,$00,$10,$19,$1F        ;;99C0|9A01+99E0/9A01\9A01;
                      db $08,$10,$1C                            ;;99C8|9A09+99E8/9A09\9A09;
                                                                ;;                        ;
DATA_049A0C:          db $EF,$FF                                ;;99CB|9A0C+99EB/9A0C\9A0C;
                                                                ;;                        ;
DATA_049A0E:          db $D8,$FF,$EF,$FF,$80,$00,$EF,$FF        ;;99CD|9A0E+99ED/9A0E\9A0E;
                      db $28,$01,$F0,$00,$D8,$FF,$F0,$00        ;;99D5|9A16+99F5/9A16\9A16;
                      db $80,$00,$F0,$00,$28,$01                ;;99DD|9A1E+99FD/9A1E\9A1E;
                                                                ;;                        ;
CODE_049A24:          REP #$20                                  ;;99E3|9A24+9A03/9A24\9A24; Accum (16 bit) 
                      LDA.W !PlayerTurnOW                       ;;99E5|9A26+9A05/9A26\9A26;
                      LSR A                                     ;;99E8|9A29+9A08/9A29\9A29;
                      LSR A                                     ;;99E9|9A2A+9A09/9A2A\9A2A;
                      TAX                                       ;;99EA|9A2B+9A0A/9A2B\9A2B;
                      LDA.W !OWPlayerSubmap,X                   ;;99EB|9A2C+9A0B/9A2C\9A2C;
                      AND.W #$00FF                              ;;99EE|9A2F+9A0E/9A2F\9A2F;
                      STA.W !CurrentSubmap                      ;;99F1|9A32+9A11/9A32\9A32;
                      LDA.W #$001A                              ;;99F4|9A35+9A14/9A35\9A35;
                      STA.B !_2                                 ;;99F7|9A38+9A17/9A38\9A38;
                      LDY.B #$41                                ;;99F9|9A3A+9A19/9A3A\9A3A;
                      LDX.W !PlayerTurnOW                       ;;99FB|9A3C+9A1B/9A3C\9A3C;
CODE_049A3F:          LDA.W !OWPlayerYPos,X                     ;;99FE|9A3F+9A1E/9A3F\9A3F;
                      CMP.W DATA_049964,Y                       ;;9A01|9A42+9A21/9A42\9A42;
                      BNE CODE_049A85                           ;;9A04|9A45+9A24/9A45\9A45;
                      LDA.W !OWPlayerXPos,X                     ;;9A06|9A47+9A26/9A47\9A47;
                      CMP.W DATA_049966,Y                       ;;9A09|9A4A+9A29/9A4A\9A4A;
                      BNE CODE_049A85                           ;;9A0C|9A4D+9A2C/9A4D\9A4D;
                      LDA.W DATA_049968,Y                       ;;9A0E|9A4F+9A2E/9A4F\9A4F;
                      AND.W #$00FF                              ;;9A11|9A52+9A31/9A52\9A52;
                      CMP.W !CurrentSubmap                      ;;9A14|9A55+9A34/9A55\9A55;
                      BNE CODE_049A85                           ;;9A17|9A58+9A37/9A58\9A58;
                      LDA.W DATA_0499AA,Y                       ;;9A19|9A5A+9A39/9A5A\9A5A;
                      STA.W !OWPlayerYPos,X                     ;;9A1C|9A5D+9A3C/9A5D\9A5D;
                      LDA.W DATA_0499AC,Y                       ;;9A1F|9A60+9A3F/9A60\9A60;
                      STA.W !OWPlayerXPos,X                     ;;9A22|9A63+9A42/9A63\9A63;
                      LDA.W DATA_0499AE,Y                       ;;9A25|9A66+9A45/9A66\9A66;
                      AND.W #$00FF                              ;;9A28|9A69+9A48/9A69\9A69;
                      STA.W !CurrentSubmap                      ;;9A2B|9A6C+9A4B/9A6C\9A6C;
                      LDY.B !_2                                 ;;9A2E|9A6F+9A4E/9A6F\9A6F;
                      LDA.W DATA_0499F0,Y                       ;;9A30|9A71+9A50/9A71\9A71;
                      AND.W #$00FF                              ;;9A33|9A74+9A53/9A74\9A74;
                      STA.W !OWPlayerYPosPtr,X                  ;;9A36|9A77+9A56/9A77\9A77;
                      LDA.W DATA_0499F1,Y                       ;;9A39|9A7A+9A59/9A7A\9A7A;
                      AND.W #$00FF                              ;;9A3C|9A7D+9A5C/9A7D\9A7D;
                      STA.W !OWPlayerXPosPtr,X                  ;;9A3F|9A80+9A5F/9A80\9A80;
                      BRA CODE_049A90                           ;;9A42|9A83+9A62/9A83\9A83;
                                                                ;;                        ;
CODE_049A85:          DEC.B !_2                                 ;;9A44|9A85+9A64/9A85\9A85;
                      DEC.B !_2                                 ;;9A46|9A87+9A66/9A87\9A87;
                      DEY                                       ;;9A48|9A89+9A68/9A89\9A89;
                      DEY                                       ;;9A49|9A8A+9A69/9A8A\9A8A;
                      DEY                                       ;;9A4A|9A8B+9A6A/9A8B\9A8B;
                      DEY                                       ;;9A4B|9A8C+9A6B/9A8C\9A8C;
                      DEY                                       ;;9A4C|9A8D+9A6C/9A8D\9A8D;
                      BPL CODE_049A3F                           ;;9A4D|9A8E+9A6D/9A8E\9A8E;
CODE_049A90:          SEP #$20                                  ;;9A4F|9A90+9A6F/9A90\9A90; Accum (8 bit) 
                      RTS                                       ;;9A51|9A92+9A71/9A92\9A92; Return 
                                                                ;;                        ;
CODE_049A93:          LDA.W !PlayerTurnOW                       ;;9A52|9A93+9A72/9A93\9A93; Accum (16 bit) 
                      AND.W #$00FF                              ;;9A55|9A96+9A75/9A96\9A96;
                      LSR A                                     ;;9A58|9A99+9A78/9A99\9A99;
                      LSR A                                     ;;9A59|9A9A+9A79/9A9A\9A9A;
                      TAX                                       ;;9A5A|9A9B+9A7A/9A9B\9A9B;
                      LDA.W !OWPlayerSubmap,X                   ;;9A5B|9A9C+9A7B/9A9C\9A9C;
                      AND.W #$FF00                              ;;9A5E|9A9F+9A7E/9A9F\9A9F;
                      ORA.W !CurrentSubmap                      ;;9A61|9AA2+9A81/9AA2\9AA2;
                      STA.W !OWPlayerSubmap,X                   ;;9A64|9AA5+9A84/9AA5\9AA5;
                      AND.W #$00FF                              ;;9A67|9AA8+9A87/9AA8\9AA8;
                      BNE +                                     ;;9A6A|9AAB+9A8A/9AAB\9AAB;
                      JMP CODE_04983F                           ;;9A6C|9AAD+9A8C/9AAD\9AAD;
                                                                ;;                        ;
                    + DEC A                                     ;;9A6F|9AB0+9A8F/9AB0\9AB0;
                      ASL A                                     ;;9A70|9AB1+9A90/9AB1\9AB1;
                      ASL A                                     ;;9A71|9AB2+9A91/9AB2\9AB2;
                      TAY                                       ;;9A72|9AB3+9A92/9AB3\9AB3;
                      LDA.W DATA_049A0C,Y                       ;;9A73|9AB4+9A93/9AB4\9AB4;
                      STA.B !Layer1XPos                         ;;9A76|9AB7+9A96/9AB7\9AB7;
                      STA.B !Layer2XPos                         ;;9A78|9AB9+9A98/9AB9\9AB9;
                      LDA.W DATA_049A0E,Y                       ;;9A7A|9ABB+9A9A/9ABB\9ABB;
                      STA.B !Layer1YPos                         ;;9A7D|9ABE+9A9D/9ABE\9ABE;
                      STA.B !Layer2YPos                         ;;9A7F|9AC0+9A9F/9AC0\9AC0;
                      SEP #$30                                  ;;9A81|9AC2+9AA1/9AC2\9AC2; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;9A83|9AC4+9AA3/9AC4\9AC4; Return 
                                                                ;;                        ;
                                                                ;;                        ;
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
LevelNameStrings:     db $47,$5A,$4A,$4B,$5A,$11,$82,$64        ;;9A84                    ;
                      db $59,$5A,$46,$41,$18,$01,$9E,$61        ;;9A8C                    ;
                      db $59,$40,$63,$64,$59,$5A,$C3,$61        ;;9A94                    ;
                      db $59,$40,$63,$0D,$59,$01,$8E,$61        ;;9A9C                    ;
                      db $59,$4B,$5A,$69,$59,$60,$65,$6B        ;;9AA4                    ;
                      db $D9,$7B,$5A,$4A,$59,$69,$59,$60        ;;9AAC                    ;
                      db $65,$6B,$D9,$0B,$21,$18,$59,$01        ;;9AB4                    ;
                      db $1E,$99,$19,$1F,$01,$14,$1D,$D5        ;;9ABC                    ;
                      db $7B,$44,$6C,$4E,$5A,$11,$82,$63        ;;9AC4                    ;
                      db $43,$5E,$04,$01,$07,$82,$19,$50        ;;9ACC                    ;
                      db $02,$5F,$65,$61,$5B,$14,$0D,$92        ;;9AD4                    ;
                      db $5F,$65,$61,$5B,$14,$09,$5C,$01        ;;9ADC                    ;
                      db $55,$05,$59,$8E,$5F,$65,$61,$5B        ;;9AE4                    ;
                      db $14,$09,$5C,$02,$20,$05,$59,$8E        ;;9AEC                    ;
                      db $47,$65,$6B,$5A,$14,$01,$83,$4A        ;;9AF4                    ;
                      db $4B,$5A,$3E,$5A,$64,$D9,$42,$5A        ;;9AFC                    ;
                      db $4B,$59,$14,$1A,$0A,$59,$02,$9A        ;;9B04                    ;
                      db $5E,$48,$4F,$45,$69,$59,$4A,$4B        ;;9B0C                    ;
                      db $DA,$04,$7C,$15,$5B,$1E,$99,$00        ;;9B14                    ;
                      db $04,$4A,$48,$65,$FB,$00,$50,$4A        ;;9B1C                    ;
                      db $48,$65,$FB,$51,$01,$5C,$4A,$48        ;;9B24                    ;
                      db $65,$FB,$1A,$11,$59,$55,$4A,$48        ;;9B2C                    ;
                      db $65,$FB,$16,$1A,$8F,$0E,$21,$54        ;;9B34                    ;
                      db $59,$0F,$0B,$A1,$52,$0C,$D9,$53        ;;9B3C                    ;
                      db $06,$1A,$8E,$02,$20,$1A,$8E,$50        ;;9B44                    ;
                      db $0D,$14,$09,$9A,$67,$60,$6A,$4A        ;;9B4C                    ;
                      db $4B,$65,$69,$1D,$79,$59,$65,$5F        ;;9B54                    ;
                      db $E0,$4A,$18,$5B,$6B,$68,$60,$4A        ;;9B5C                    ;
                      db $64,$14,$0D,$9C,$7B,$68,$4C,$79        ;;9B64                    ;
                      db $5B,$6A,$4C,$6B,$65,$69,$DB,$6C        ;;9B6C                    ;
                      db $5A,$4A,$A3,$6C,$5A,$4A,$A4,$6C        ;;9B74                    ;
                      db $5A,$4A,$A5,$6C,$5A,$4A,$A6,$6C        ;;9B7C                    ;
                      db $5A,$4A,$A7,$11,$55,$10,$D9,$6A        ;;9B84                    ;
                      db $61,$59,$66,$1E,$09,$D1,$04,$05        ;;9B8C                    ;
                      db $57,$1E,$09,$D1,$09,$DC,$6C,$5A        ;;9B94                    ;
                      db $CA,$94,$DD                            ;;9B9C                    ;
                                                                ;;                        ;
DATA_049C91:          db $1A,$01,$00,$00,$07,$00,$0F,$00        ;;9B9F                    ;
                      db $17,$00,$1F,$00,$29,$00,$33,$00        ;;9BA7                    ;
                      db $3A,$00,$40,$00,$47,$00,$4E,$00        ;;9BAF                    ;
                      db $58,$00,$64,$00,$70,$00,$77,$00        ;;9BB7                    ;
                      db $7E,$00,$88,$00,$91,$00                ;;9BBF                    ;
                                                                ;;                        ;
DATA_049CCF:          db $1A,$01,$97,$00,$9D,$00,$A3,$00        ;;9BC5                    ;
                      db $AA,$00,$B2,$00,$B5,$00,$BC,$00        ;;9BCD                    ;
                      db $BF,$00,$C3,$00,$C7,$00,$CC,$00        ;;9BD5                    ;
                      db $D9,$00,$E4,$00                        ;;9BDD                    ;
                                                                ;;                        ;
JDATA_049BE1:         db $1A,$01,$EF,$00,$F3,$00,$F7,$00        ;;9BE1                    ;
                      db $FB,$00,$FF,$00,$03,$01,$07,$01        ;;9BE9                    ;
                      db $0E,$01,$14,$01,$16,$01                ;;9BF1                    ;
                                                                ;;                        ;
DATA_049CED:          db $19,$01,$1A,$01                        ;;9BF7                    ;
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0, & E1
LevelNameStrings:     db $18,$0E,$12,$07,$08,$5D,$12,$9F        ;;    |9AC5+9AA4/9AC5\9AC5;
                      db $12,$13,$00,$11,$9F,$5A,$64,$1F        ;;    |9ACD+9AAC/9ACD\9ACD;
                      db $08,$06,$06,$18,$5D,$12,$9F,$5A        ;;    |9AD5+9AB4/9AD5\9AD5;
                      db $65,$1F,$0C,$0E,$11,$13,$0E,$0D        ;;    |9ADD+9ABC/9ADD\9ADD;
                      db $5D,$12,$9F,$5A,$66,$1F,$0B,$04        ;;    |9AE5+9AC4/9AE5\9AE5;
                      db $0C,$0C,$18,$5D,$12,$9F,$5A,$67        ;;    |9AED+9ACC/9AED\9AED;
                      db $1F,$0B,$14,$03,$16,$08,$06,$5D        ;;    |9AF5+9AD4/9AF5\9AF5;
                      db $12,$9F,$5A,$68,$1F,$11,$0E,$18        ;;    |9AFD+9ADC/9AFD\9AFD;
                      db $5D,$12,$9F,$5A,$69,$1F,$16,$04        ;;    |9B05+9AE4/9B05\9B05;
                      db $0D,$03,$18,$5D,$12,$9F,$5A,$6A        ;;    |9B0D+9AEC/9B0D\9B0D;
                      db $1F,$0B,$00,$11,$11,$18,$5D,$12        ;;    |9B15+9AF4/9B15\9B15;
                      db $9F,$03,$0E,$0D,$14,$13,$9F,$06        ;;    |9B1D+9AFC/9B1D\9B1D;
                      db $11,$04,$04,$0D,$9F,$13,$0E,$0F        ;;    |9B25+9B04/9B25\9B25;
                      db $1F,$12,$04,$02,$11,$04,$13,$1F        ;;    |9B2D+9B0C/9B2D\9B2D;
                      db $00,$11,$04,$00,$9F,$15,$00,$0D        ;;    |9B35+9B14/9B35\9B35;
                      db $08,$0B,$0B,$00,$9F,$38,$39,$3A        ;;    |9B3D+9B1C/9B3D\9B3D;
                      db $3B,$3C,$9F,$11,$04,$03,$9F,$01        ;;    |9B45+9B24/9B45\9B45;
                      db $0B,$14,$04,$9F,$01,$14,$13,$13        ;;    |9B4D+9B2C/9B4D\9B4D;
                      db $04,$11,$1F,$01,$11,$08,$03,$06        ;;    |9B55+9B34/9B55\9B55;
                      db $04,$9F,$02,$07,$04,$04,$12,$04        ;;    |9B5D+9B3C/9B5D\9B5D;
                      db $1F,$01,$11,$08,$03,$06,$04,$9F        ;;    |9B65+9B44/9B65\9B65;
                      db $12,$0E,$03,$00,$1F,$0B,$00,$0A        ;;    |9B6D+9B4C/9B6D\9B6D;
                      db $04,$9F,$02,$0E,$0E,$0A,$08,$04        ;;    |9B75+9B54/9B75\9B75;
                      db $1F,$0C,$0E,$14,$0D,$13,$00,$08        ;;    |9B7D+9B5C/9B7D\9B7D;
                      db $0D,$9F,$05,$0E,$11,$04,$12,$13        ;;    |9B85+9B64/9B85\9B85;
                      db $9F,$02,$07,$0E,$02,$0E,$0B,$00        ;;    |9B8D+9B6C/9B8D\9B8D;
                      db $13,$04,$9F,$02,$07,$0E,$02,$0E        ;;    |9B95+9B74/9B95\9B95;
                      db $1C,$06,$07,$0E,$12,$13,$1F,$07        ;;    |9B9D+9B7C/9B9D\9B9D;
                      db $0E,$14,$12,$04,$9F,$12,$14,$0D        ;;    |9BA5+9B84/9BA5\9BA5;
                      db $0A,$04,$0D,$1F,$06,$07,$0E,$12        ;;    |9BAD+9B8C/9BAD\9BAD;
                      db $13,$1F,$12,$07,$08,$0F,$9F,$15        ;;    |9BB5+9B94/9BB5\9BB5;
                      db $00,$0B,$0B,$04,$18,$9F,$01,$00        ;;    |9BBD+9B9C/9BBD\9BBD;
                      db $02,$0A,$1F,$03,$0E,$0E,$11,$9F        ;;    |9BC5+9BA4/9BC5\9BC5;
                      db $05,$11,$0E,$0D,$13,$1F,$03,$0E        ;;    |9BCD+9BAC/9BCD\9BCD;
                      db $0E,$11,$9F,$06,$0D,$00,$11,$0B        ;;    |9BD5+9BB4/9BD5\9BD5;
                      db $18,$9F,$13,$14,$01,$14,$0B,$00        ;;    |9BDD+9BBC/9BDD\9BDD;
                      db $11,$9F,$16,$00,$18,$1F,$02,$0E        ;;    |9BE5+9BC4/9BE5\9BE5;
                      db $0E,$0B,$9F,$07,$0E,$14,$12,$04        ;;    |9BED+9BCC/9BED\9BED;
                      db $9F,$08,$12,$0B,$00,$0D,$03,$9F        ;;    |9BF5+9BD4/9BF5\9BF5;
                      db $12,$16,$08,$13,$02,$07,$1F,$0F        ;;    |9BFD+9BDC/9BFD\9BFD;
                      db $00,$0B,$00,$02,$04,$9F,$02,$00        ;;    |9C05+9BE4/9C05\9C05;
                      db $12,$13,$0B,$04,$9F,$0F,$0B,$00        ;;    |9C0D+9BEC/9C0D\9C0D;
                      db $08,$0D,$12,$9F,$06,$07,$0E,$12        ;;    |9C15+9BF4/9C15\9C15;
                      db $13,$1F,$07,$0E,$14,$12,$04,$9F        ;;    |9C1D+9BFC/9C1D\9C1D;
                      db $12,$04,$02,$11,$04,$13,$9F,$03        ;;    |9C25+9C04/9C25\9C25;
                      db $0E,$0C,$04,$9F,$05,$0E,$11,$13        ;;    |9C2D+9C0C/9C2D\9C2D;
                      db $11,$04,$12,$12,$9F,$0E,$05,$32        ;;    |9C35+9C14/9C35\9C35;
                      db $33,$34,$35,$36,$37,$0E,$0D,$9F        ;;    |9C3D+9C1C/9C3D\9C3D;
                      db $0E,$05,$1F,$01,$0E,$16,$12,$04        ;;    |9C45+9C24/9C45\9C45;
                      db $11,$9F,$11,$0E,$00,$03,$9F,$16        ;;    |9C4D+9C2C/9C4D\9C4D;
                      db $0E,$11,$0B,$03,$9F,$00,$16,$04        ;;    |9C55+9C34/9C55\9C55;
                      db $12,$0E,$0C,$04,$9F,$E4,$E5,$E6        ;;    |9C5D+9C3C/9C5D\9C5D;
                      db $E7,$E8,$0F,$00,$0B,$00,$02,$84        ;;    |9C65+9C44/9C65\9C65;
                      db $00,$11,$04,$80,$06,$11,$0E,$0E        ;;    |9C6D+9C4C/9C6D\9C6D;
                      db $15,$98,$0C,$0E,$0D,$03,$8E,$0E        ;;    |9C75+9C54/9C75\9C75;
                      db $14,$13,$11,$00,$06,$04,$0E,$14        ;;    |9C7D+9C5C/9C7D\9C7D;
                      db $92,$05,$14,$0D,$0A,$98,$07,$0E        ;;    |9C85+9C64/9C85\9C85;
                      db $14,$12,$84,$9F                        ;;    |9C8D+9C6C/9C8D\9C8D;
                                                                ;;                        ;
DATA_049C91:          db $CB,$01,$00,$00,$08,$00,$0D,$00        ;;    |9C91+9C70/9C91\9C91;
                      db $17,$00,$23,$00,$2E,$00,$3A,$00        ;;    |9C99+9C78/9C99\9C99;
                      db $43,$00,$4E,$00,$59,$00,$5F,$00        ;;    |9CA1+9C80/9CA1\9CA1;
                      db $65,$00,$75,$00,$7D,$00,$83,$00        ;;    |9CA9+9C88/9CA9\9CA9;
                      db $87,$00,$8C,$00,$9A,$00,$A8,$00        ;;    |9CB1+9C90/9CB1\9CB1;
                      db $B2,$00,$C2,$00,$C9,$00,$D3,$00        ;;    |9CB9+9C98/9CB9\9CB9;
                      db $E5,$00,$F7,$00,$FE,$00,$08,$01        ;;    |9CC1+9CA0/9CC1\9CC1;
                      db $13,$01,$1A,$01,$22,$01                ;;    |9CC9+9CA8/9CC9\9CC9;
                                                                ;;                        ;
DATA_049CCF:          db $CB,$01,$2B,$01,$31,$01,$38,$01        ;;    |9CCF+9CAE/9CCF\9CCF;
                      db $46,$01,$4D,$01,$54,$01,$60,$01        ;;    |9CD7+9CB6/9CD7\9CD7;
                      db $67,$01,$6C,$01,$75,$01,$80,$01        ;;    |9CDF+9CBE/9CDF\9CDF;
                      db $8A,$01,$8F,$01,$95,$01                ;;    |9CE7+9CC6/9CE7\9CE7;
                                                                ;;                        ;
DATA_049CED:          db $CB,$01,$9D,$01,$9E,$01,$9F,$01        ;;    |9CED+9CCC/9CED\9CED;
                      db $A0,$01,$A1,$01,$A2,$01,$A8,$01        ;;    |9CF5+9CD4/9CF5\9CF5;
                      db $AC,$01,$B2,$01,$B7,$01,$C1,$01        ;;    |9CFD+9CDC/9CFD\9CFD;
                      db $C6,$01                                ;;    |9D05+9CE4/9D05\9D05;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                                                                ;;                        ;
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
CODE_049D07:          LDA.L !DynStripeImgSize                   ;;9BFB                    ; Index (16 bit) Accum (16 bit) 
                      TAX                                       ;;9BFF                    ;
                      CLC                                       ;;9C00                    ;
                      ADC.W #$0020                              ;;9C01                    ;
                      STA.B !_2                                 ;;9C04                    ;
                      CLC                                       ;;9C06                    ;
                      ADC.W #$0024                              ;;9C07                    ;
                      STA.L !DynStripeImgSize                   ;;9C0A                    ;
                      LDA.W #$1F00                              ;;9C0E                    ;
                      STA.L !DynamicStripeImage+2,X             ;;9C11                    ;
                      STA.L !DynamicStripeImage+$26,X           ;;9C15                    ;
                      LDA.W #$8C50                              ;;9C19                    ;
                      STA.L !DynamicStripeImage,X               ;;9C1C                    ;
                      LDA.W #$6C50                              ;;9C20                    ;
                      STA.L !DynamicStripeImage+$24,X           ;;9C23                    ;
                      LDA.B !_1                                 ;;9C27                    ;
                      AND.W #$001F                              ;;9C29                    ;
                      ASL A                                     ;;9C2C                    ;
                      TAY                                       ;;9C2D                    ;
                      LDA.W DATA_049C91,Y                       ;;9C2E                    ;
                      TAY                                       ;;9C31                    ;
                      SEP #$20                                  ;;9C32                    ; Accum (8 bit) 
                      LDA.W LevelNameStrings,Y                  ;;9C34                    ;
                      BMI +                                     ;;9C37                    ;
                      JSR CODE_049D7F                           ;;9C39                    ;
                      LDA.B !_1                                 ;;9C3C                    ;
                      ASL A                                     ;;9C3E                    ;
                      ROL A                                     ;;9C3F                    ;
                      ROL A                                     ;;9C40                    ;
                      REP #$20                                  ;;9C41                    ;
                      AND.W #$0003                              ;;9C43                    ;
                      ASL A                                     ;;9C46                    ;
                      TAY                                       ;;9C47                    ;
                      LDA.W DATA_049CED,Y                       ;;9C48                    ;
                      TAY                                       ;;9C4B                    ;
                      SEP #$20                                  ;;9C4C                    ;
                      JSR CODE_049D7F                           ;;9C4E                    ;
                    + REP #$20                                  ;;9C51                    ; Accum (16 bit) 
                      LDA.B !_0                                 ;;9C53                    ;
                      AND.W #$00F0                              ;;9C55                    ;
                      LSR A                                     ;;9C58                    ;
                      LSR A                                     ;;9C59                    ;
                      LSR A                                     ;;9C5A                    ;
                      TAY                                       ;;9C5B                    ;
                      LDA.W DATA_049CCF,Y                       ;;9C5C                    ;
                      TAY                                       ;;9C5F                    ;
                      SEP #$20                                  ;;9C60                    ; Accum (8 bit) 
                      LDA.W LevelNameStrings,Y                  ;;9C62                    ;
                      CMP.B #$DD                                ;;9C65                    ;
                      BEQ +                                     ;;9C67                    ;
                      JSR CODE_049D7F                           ;;9C69                    ;
                      LDA.B !_1                                 ;;9C6C                    ;
                      AND.B #$20                                ;;9C6E                    ;
                      ASL A                                     ;;9C70                    ;
                      ASL A                                     ;;9C71                    ;
                      ASL A                                     ;;9C72                    ;
                      ROL A                                     ;;9C73                    ;
                      REP #$20                                  ;;9C74                    ;
                      AND.W #$0001                              ;;9C76                    ;
                      ASL A                                     ;;9C79                    ;
                      TAY                                       ;;9C7A                    ;
                      LDA.W DATA_049CED,Y                       ;;9C7B                    ;
                      TAY                                       ;;9C7E                    ;
                      SEP #$20                                  ;;9C7F                    ;
                      JSR CODE_049D7F                           ;;9C81                    ;
                    + REP #$20                                  ;;9C84                    ; Accum (16 bit) 
                      LDA.B !_0                                 ;;9C86                    ;
                      AND.W #$000F                              ;;9C88                    ;
                      ASL A                                     ;;9C8B                    ;
                      TAY                                       ;;9C8C                    ;
                      LDA.W JDATA_049BE1,Y                      ;;9C8D                    ;
                      TAY                                       ;;9C90                    ;
                      SEP #$20                                  ;;9C91                    ; Accum (8 bit) 
                      JSR CODE_049D7F                           ;;9C93                    ;
                    - CPX.B !_2                                 ;;9C96                    ;
                      BCS +                                     ;;9C98                    ;
                      LDY.W #$011A                              ;;9C9A                    ;
                      JSR CODE_049D7F                           ;;9C9D                    ;
                      BRA -                                     ;;9CA0                    ;
                    + LDA.B #$FF                                ;;9CA2                    ;
                      STA.L !DynamicStripeImage+$28,X           ;;9CA4                    ;
                      REP #$20                                  ;;9CA8                    ;
                      RTS                                       ;;9CAA                    ;
                                                                ;;                        ;
CODE_049D7F:          LDA.W LevelNameStrings,Y                  ;;9CAB                    ; Index (8 bit) Accum (8 bit) 
                      PHP                                       ;;9CAE                    ;
                      CPX.B !_2                                 ;;9CAF                    ;
                      BCS +++                                   ;;9CB1                    ;
                      AND.B #$7F                                ;;9CB3                    ;
                      CMP.B #$59                                ;;9CB5                    ;
                      BEQ +                                     ;;9CB7                    ;
                      CMP.B #$5B                                ;;9CB9                    ;
                      BNE ++                                    ;;9CBB                    ;
                    + STA.L !DynamicStripeImage+$26,X           ;;9CBD                    ;
                      BRA +++                                   ;;9CC1                    ;
                   ++ STA.L !DynamicStripeImage+4,X             ;;9CC3                    ;
                      LDA.B #$5D                                ;;9CC7                    ;
                      STA.L !DynamicStripeImage+$28,X           ;;9CC9                    ;
                      LDA.B #$39                                ;;9CCD                    ;
                      STA.L !DynamicStripeImage+5,X             ;;9CCF                    ;
                      STA.L !DynamicStripeImage+$29,X           ;;9CD3                    ;
                      INX                                       ;;9CD7                    ;
                      INX                                       ;;9CD8                    ;
                  +++ INY                                       ;;9CD9                    ;
                      PLP                                       ;;9CDA                    ;
                      BPL CODE_049D7F                           ;;9CDB                    ;
                      RTS                                       ;;9CDD                    ; Return 
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0 & E1
CODE_049D07:          LDA.L !DynStripeImgSize                   ;;    |9D07+9CE6/9D07\9D07; Index (16 bit) Accum (16 bit) 
                      TAX                                       ;;    |9D0B+9CEA/9D0B\9D0B;
                      CLC                                       ;;    |9D0C+9CEB/9D0C\9D0C;
                      ADC.W #$0026                              ;;    |9D0D+9CEC/9D0D\9D0D;
                      STA.B !_2                                 ;;    |9D10+9CEF/9D10\9D10;
                      CLC                                       ;;    |9D12+9CF1/9D12\9D12;
                      ADC.W #$0004                              ;;    |9D13+9CF2/9D13\9D13;
                      STA.L !DynStripeImgSize                   ;;    |9D16+9CF5/9D16\9D16;
                      LDA.W #$2500                              ;;    |9D1A+9CF9/9D1A\9D1A;
                      STA.L !DynamicStripeImage+2,X             ;;    |9D1D+9CFC/9D1D\9D1D;
                      LDA.W #$8B50                              ;;    |9D21+9D00/9D21\9D21;
                      STA.L !DynamicStripeImage,X               ;;    |9D24+9D03/9D24\9D24;
                      LDA.B !_1                                 ;;    |9D28+9D07/9D28\9D28;
                      AND.W #$007F                              ;;    |9D2A+9D09/9D2A\9D2A;
                      ASL A                                     ;;    |9D2D+9D0C/9D2D\9D2D;
                      TAY                                       ;;    |9D2E+9D0D/9D2E\9D2E;
                      LDA.W DATA_049C91,Y                       ;;    |9D2F+9D0E/9D2F\9D2F;
                      TAY                                       ;;    |9D32+9D11/9D32\9D32;
                      SEP #$20                                  ;;    |9D33+9D12/9D33\9D33; Accum (8 bit) 
                      LDA.W LevelNameStrings,Y                  ;;    |9D35+9D14/9D35\9D35;
                      BMI +                                     ;;    |9D38+9D17/9D38\9D38;
                      JSR CODE_049D7F                           ;;    |9D3A+9D19/9D3A\9D3A;
                    + REP #$20                                  ;;    |9D3D+9D1C/9D3D\9D3D; Accum (16 bit) 
                      LDA.B !_0                                 ;;    |9D3F+9D1E/9D3F\9D3F;
                      AND.W #$00F0                              ;;    |9D41+9D20/9D41\9D41;
                      LSR A                                     ;;    |9D44+9D23/9D44\9D44;
                      LSR A                                     ;;    |9D45+9D24/9D45\9D45;
                      LSR A                                     ;;    |9D46+9D25/9D46\9D46;
                      TAY                                       ;;    |9D47+9D26/9D47\9D47;
                      LDA.W DATA_049CCF,Y                       ;;    |9D48+9D27/9D48\9D48;
                      TAY                                       ;;    |9D4B+9D2A/9D4B\9D4B;
                      SEP #$20                                  ;;    |9D4C+9D2B/9D4C\9D4C; Accum (8 bit) 
                      LDA.W LevelNameStrings,Y                  ;;    |9D4E+9D2D/9D4E\9D4E;
                      CMP.B #$9F                                ;;    |9D51+9D30/9D51\9D51;
                      BEQ +                                     ;;    |9D53+9D32/9D53\9D53;
                      JSR CODE_049D7F                           ;;    |9D55+9D34/9D55\9D55;
                    + REP #$20                                  ;;    |9D58+9D37/9D58\9D58; Accum (16 bit) 
                      LDA.B !_0                                 ;;    |9D5A+9D39/9D5A\9D5A;
                      AND.W #$000F                              ;;    |9D5C+9D3B/9D5C\9D5C;
                      ASL A                                     ;;    |9D5F+9D3E/9D5F\9D5F;
                      TAY                                       ;;    |9D60+9D3F/9D60\9D60;
                      LDA.W DATA_049CED,Y                       ;;    |9D61+9D40/9D61\9D61;
                      TAY                                       ;;    |9D64+9D43/9D64\9D64;
                      SEP #$20                                  ;;    |9D65+9D44/9D65\9D65; Accum (8 bit) 
                      JSR CODE_049D7F                           ;;    |9D67+9D46/9D67\9D67;
CODE_049D6A:          CPX.B !_2                                 ;;    |9D6A+9D49/9D6A\9D6A;
                      BCS CODE_049D76                           ;;    |9D6C+9D4B/9D6C\9D6C;
                      LDY.W #$01CB                              ;;    |9D6E+9D4D/9D6E\9D6E;
                      JSR CODE_049D7F                           ;;    |9D71+9D50/9D71\9D71;
                      BRA CODE_049D6A                           ;;    |9D74+9D53/9D74\9D74;
                                                                ;;                        ;
CODE_049D76:          LDA.B #$FF                                ;;    |9D76+9D55/9D76\9D76;
                      STA.L !DynamicStripeImage+4,X             ;;    |9D78+9D57/9D78\9D78;
                      REP #$20                                  ;;    |9D7C+9D5B/9D7C\9D7C; Accum (16 bit) 
                      RTS                                       ;;    |9D7E+9D5D/9D7E\9D7E; Return 
                                                                ;;                        ;
CODE_049D7F:          LDA.W LevelNameStrings,Y                  ;;    |9D7F+9D5E/9D7F\9D7F; Index (8 bit) Accum (8 bit) 
                      PHP                                       ;;    |9D82+9D61/9D82\9D82;
                      CPX.B !_2                                 ;;    |9D83+9D62/9D83\9D83;
                      BCS +                                     ;;    |9D85+9D64/9D85\9D85;
                      AND.B #$7F                                ;;    |9D87+9D66/9D87\9D87;
                      STA.L !DynamicStripeImage+4,X             ;;    |9D89+9D68/9D89\9D89;
                      LDA.B #$39                                ;;    |9D8D+9D6C/9D8D\9D8D;
                      STA.L !DynamicStripeImage+5,X             ;;    |9D8F+9D6E/9D8F\9D8F;
                      INX                                       ;;    |9D93+9D72/9D93\9D93;
                      INX                                       ;;    |9D94+9D73/9D94\9D94;
                    + INY                                       ;;    |9D95+9D74/9D95\9D95;
                      PLP                                       ;;    |9D96+9D75/9D96\9D96;
                      BPL CODE_049D7F                           ;;    |9D97+9D76/9D97\9D97;
                      RTS                                       ;;    |9D99+9D78/9D99\9D99; Return 
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                                                                ;;                        ;
CODE_049D9A:          LDA.W !IsTwoPlayerGame                    ;;9CDE|9D9A+9D79/9D9A\9D9A;
                      BEQ CODE_049DAF                           ;;9CE1|9D9D+9D7C/9D9D\9D9D;
                      LDA.W !PlayerTurnLvl                      ;;9CE3|9D9F+9D7E/9D9F\9D9F;
                      EOR.B #$01                                ;;9CE6|9DA2+9D81/9DA2\9DA2;
                      TAX                                       ;;9CE8|9DA4+9D83/9DA4\9DA4;
                      LDA.W !SavedPlayerLives,X                 ;;9CE9|9DA5+9D84/9DA5\9DA5;
                      BMI CODE_049DAF                           ;;9CEC|9DA8+9D87/9DA8\9DA8;
                      LDA.W !OWLevelExitMode                    ;;9CEE|9DAA+9D89/9DAA\9DAA;
                      BNE +                                     ;;9CF1|9DAD+9D8C/9DAD\9DAD;
CODE_049DAF:          LDA.B #$03                                ;;9CF3|9DAF+9D8E/9DAF\9DAF;
                      STA.W !OverworldProcess                   ;;9CF5|9DB1+9D90/9DB1\9DB1;
                      STZ.W !OWLevelExitMode                    ;;9CF8|9DB4+9D93/9DB4\9DB4;
                      REP #$30                                  ;;9CFB|9DB7+9D96/9DB7\9DB7; Index (16 bit) Accum (16 bit) 
                      JMP OWMoveScroll                          ;;9CFD|9DB9+9D98/9DB9\9DB9;
                                                                ;;                        ;
                    + DEC.W !KeepModeActive                     ;;9D00|9DBC+9D9B/9DBC\9DBC; Index (8 bit) Accum (8 bit) 
                      BPL +                                     ;;9D03|9DBF+9D9E/9DBF\9DBF;
                      LDA.B #$02                                ;;9D05|9DC1+9DA0/9DC1\9DC1;
                      STA.W !KeepModeActive                     ;;9D07|9DC3+9DA2/9DC3\9DC3;
                      STZ.W !OWLevelExitMode                    ;;9D0A|9DC6+9DA5/9DC6\9DC6;
                      INC.W !OverworldProcess                   ;;9D0D|9DC9+9DA8/9DC9\9DC9;
                    + REP #$30                                  ;;9D10|9DCC+9DAB/9DCC\9DCC; Index (16 bit) Accum (16 bit) 
                      JMP OWMoveScroll                          ;;9D12|9DCE+9DAD/9DCE\9DCE;
                                                                ;;                        ;
CODE_049DD1:          LDA.W !PlayerTurnLvl                      ;;9D15|9DD1+9DB0/9DD1\9DD1; Index (8 bit) Accum (8 bit) 
                      EOR.B #$01                                ;;9D18|9DD4+9DB3/9DD4\9DD4;
                      STA.W !PlayerTurnLvl                      ;;9D1A|9DD6+9DB5/9DD6\9DD6;
                      TAX                                       ;;9D1D|9DD9+9DB8/9DD9\9DD9;
                      LDA.W !SavedPlayerCoins,X                 ;;9D1E|9DDA+9DB9/9DDA\9DDA;
                      STA.W !PlayerCoins                        ;;9D21|9DDD+9DBC/9DDD\9DDD;
                      LDA.W !SavedPlayerLives,X                 ;;9D24|9DE0+9DBF/9DE0\9DE0;
                      STA.W !PlayerLives                        ;;9D27|9DE3+9DC2/9DE3\9DE3;
                      LDA.W !SavedPlayerPowerup,X               ;;9D2A|9DE6+9DC5/9DE6\9DE6;
                      STA.B !Powerup                            ;;9D2D|9DE9+9DC8/9DE9\9DE9;
                      LDA.W !SavedPlayerYoshi,X                 ;;9D2F|9DEB+9DCA/9DEB\9DEB;
                      STA.W !CarryYoshiThruLvls                 ;;9D32|9DEE+9DCD/9DEE\9DEE;
                      STA.W !YoshiColor                         ;;9D35|9DF1+9DD0/9DF1\9DF1;
                      STA.W !PlayerRidingYoshi                  ;;9D38|9DF4+9DD3/9DF4\9DF4;
                      LDA.W !SavedPlayerItembox,X               ;;9D3B|9DF7+9DD6/9DF7\9DF7;
                      STA.W !PlayerItembox                      ;;9D3E|9DFA+9DD9/9DFA\9DFA;
                      JSL CODE_05DBF2                           ;;9D41|9DFD+9DDC/9DFD\9DFD;
                      REP #$20                                  ;;9D45|9E01+9DE0/9E01\9E01; Accum (16 bit) 
                      JSR CODE_048E55                           ;;9D47|9E03+9DE2/9E03\9E03;
                      SEP #$20                                  ;;9D4A|9E06+9DE5/9E06\9E06; Accum (8 bit) 
                      LDX.W !PlayerTurnLvl                      ;;9D4C|9E08+9DE7/9E08\9E08;
                      LDA.W !OWPlayerSubmap,X                   ;;9D4F|9E0B+9DEA/9E0B\9E0B;
                      STA.W !CurrentSubmap                      ;;9D52|9E0E+9DED/9E0E\9E0E;
                      STZ.W !CurrentSubmap+1                    ;;9D55|9E11+9DF0/9E11\9E11;
                      LDA.B #$02                                ;;9D58|9E14+9DF3/9E14\9E14;
                      STA.W !KeepModeActive                     ;;9D5A|9E16+9DF5/9E16\9E16;
                      LDA.B #$0A                                ;;9D5D|9E19+9DF8/9E19\9E19;
                      STA.W !OverworldProcess                   ;;9D5F|9E1B+9DFA/9E1B\9E1B;
                      INC.W !PlayerSwitching                    ;;9D62|9E1E+9DFD/9E1E\9E1E;
                      RTS                                       ;;9D65|9E21+9E00/9E21\9E21; Return 
                                                                ;;                        ;
CODE_049E22:          DEC.W !KeepModeActive                     ;;9D66|9E22+9E01/9E22\9E22;
                      BPL +                                     ;;9D69|9E25+9E04/9E25\9E25;
                      LDA.B #$02                                ;;9D6B|9E27+9E06/9E27\9E27;
                      STA.W !KeepModeActive                     ;;9D6D|9E29+9E08/9E29\9E29;
                      LDX.W !MosaicDirection                    ;;9D70|9E2C+9E0B/9E2C\9E2C;
                      LDA.W !Brightness                         ;;9D73|9E2F+9E0E/9E2F\9E2F;
                      CLC                                       ;;9D76|9E32+9E11/9E32\9E32;
                      ADC.L DATA_009F2F,X                       ;;9D77|9E33+9E12/9E33\9E33;
                      STA.W !Brightness                         ;;9D7B|9E37+9E16/9E37\9E37;
                      CMP.L DATA_009F33,X                       ;;9D7E|9E3A+9E19/9E3A\9E3A;
                      BNE +                                     ;;9D82|9E3E+9E1D/9E3E\9E3E;
                      INC.W !OverworldProcess                   ;;9D84|9E40+9E1F/9E40\9E40;
                      LDA.W !MosaicDirection                    ;;9D87|9E43+9E22/9E43\9E43;
                      EOR.B #$01                                ;;9D8A|9E46+9E25/9E46\9E46;
                      STA.W !MosaicDirection                    ;;9D8C|9E48+9E27/9E48\9E48;
                    + RTS                                       ;;9D8F|9E4B+9E2A/9E4B\9E4B; Return 
                                                                ;;                        ;
CODE_049E4C:          LDA.B #$03                                ;;9D90|9E4C+9E2B/9E4C\9E4C;
                      STA.W !OverworldProcess                   ;;9D92|9E4E+9E2D/9E4E\9E4E;
                      RTS                                       ;;9D95|9E51+9E30/9E51\9E51; Return 
                                                                ;;                        ;
CODE_049E52:          LDA.W !StarWarpLaunchSpeed                ;;9D96|9E52+9E31/9E52\9E52;
                      BNE CODE_049E63                           ;;9D99|9E55+9E34/9E55\9E55;
                      INC.W !StarWarpLaunchTimer                ;;9D9B|9E57+9E36/9E57\9E57;
                      LDA.W !StarWarpLaunchTimer                ;;9D9E|9E5A+9E39/9E5A\9E5A;
                      CMP.B #$31                                ;;9DA1|9E5D+9E3C/9E5D\9E5D;
                      BNE CODE_049E93                           ;;9DA3|9E5F+9E3E/9E5F\9E5F;
                      BRA CODE_049E69                           ;;9DA5|9E61+9E40/9E61\9E61;
                                                                ;;                        ;
CODE_049E63:          LDA.B !TrueFrame                          ;;9DA7|9E63+9E42/9E63\9E63;
                      AND.B #$07                                ;;9DA9|9E65+9E44/9E65\9E65;
                      BNE +                                     ;;9DAB|9E67+9E46/9E67\9E67;
CODE_049E69:          INC.W !StarWarpLaunchSpeed                ;;9DAD|9E69+9E48/9E69\9E69;
                      LDA.W !StarWarpLaunchSpeed                ;;9DB0|9E6C+9E4B/9E6C\9E6C;
                      CMP.B #$05                                ;;9DB3|9E6F+9E4E/9E6F\9E6F;
                      BNE +                                     ;;9DB5|9E71+9E50/9E71\9E71;
                      LDA.B #$04                                ;;9DB7|9E73+9E52/9E73\9E73;
                      STA.W !StarWarpLaunchSpeed                ;;9DB9|9E75+9E54/9E75\9E75;
                    + REP #$20                                  ;;9DBC|9E78+9E57/9E78\9E78; Accum (16 bit) 
                      LDA.W !StarWarpLaunchSpeed                ;;9DBE|9E7A+9E59/9E7A\9E7A;
                      AND.W #$00FF                              ;;9DC1|9E7D+9E5C/9E7D\9E7D;
                      STA.B !_0                                 ;;9DC4|9E80+9E5F/9E80\9E80;
                      LDX.W !PlayerTurnOW                       ;;9DC6|9E82+9E61/9E82\9E82;
                      LDA.W !OWPlayerYPos,X                     ;;9DC9|9E85+9E64/9E85\9E85;
                      SEC                                       ;;9DCC|9E88+9E67/9E88\9E88;
                      SBC.B !_0                                 ;;9DCD|9E89+9E68/9E89\9E89;
                      STA.W !OWPlayerYPos,X                     ;;9DCF|9E8B+9E6A/9E8B\9E8B;
                      SEC                                       ;;9DD2|9E8E+9E6D/9E8E\9E8E;
                      SBC.B !Layer1YPos                         ;;9DD3|9E8F+9E6E/9E8F\9E8F;
                      BMI +                                     ;;9DD5|9E91+9E70/9E91\9E91;
CODE_049E93:          SEP #$20                                  ;;9DD7|9E93+9E72/9E93\9E93; Accum (8 bit) 
                      RTS                                       ;;9DD9|9E95+9E74/9E95\9E95; Return 
                                                                ;;                        ;
                    + SEP #$20                                  ;;9DDA|9E96+9E75/9E96\9E96; Accum (8 bit) 
                      JMP CODE_04918D                           ;;9DDC|9E98+9E77/9E98\9E98;
                                                                ;;                        ;
                      LDY.B #$00                                ;;9DDF|9E9B+9E7A/9E9B\9E9B; \ Unreachable 
ADDR_049E9D:          CMP.B #$0A                                ;;9DE1|9E9D+9E7C/9E9D\9E9D;  | While A >= #$0A... 
                      BCC Return049EA6                          ;;9DE3|9E9F+9E7E/9E9F\9E9F;  | 
                      SBC.B #$0A                                ;;9DE5|9EA1+9E80/9EA1\9EA1;  | A -= #$0A 
                      INY                                       ;;9DE7|9EA3+9E82/9EA3\9EA3;  | Y++ 
                      BRA ADDR_049E9D                           ;;9DE8|9EA4+9E83/9EA4\9EA4; / 
                                                                ;;                        ;
Return049EA6:         RTS                                       ;;9DEA|9EA6+9E85/9EA6\9EA6; / Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_049EA7:          db $10,$F8,$10,$00,$10,$FC,$10,$00        ;;9DEB|9EA7+9E86/9EA7\9EA7;
                      db $10,$FC,$10,$00,$08,$FC,$0C,$F4        ;;9DF3|9EAF+9E8E/9EAF\9EAF;
                      db $FC,$04,$04,$FC,$F8,$10,$00,$10        ;;9DFB|9EB7+9E96/9EB7\9EB7;
                      db $FC,$08,$FC,$08,$FC,$10,$00,$10        ;;9E03|9EBF+9E9E/9EBF\9EBF;
                      db $F8,$04,$FC,$10,$00,$10,$10,$08        ;;9E0B|9EC7+9EA6/9EC7\9EC7;
                      db $10,$04,$10,$04,$08,$04,$0C,$0C        ;;9E13|9ECF+9EAE/9ECF\9ECF;
                      db $04,$04,$04,$04,$08,$10,$FC,$F8        ;;9E1B|9ED7+9EB6/9ED7\9ED7;
                      db $FC,$F8,$04,$10,$F8,$FC,$04,$10        ;;9E23|9EDF+9EBE/9EDF\9EDF;
                      db $F4,$F4,$0C,$F4,$10,$00,$00,$10        ;;9E2B|9EE7+9EC6/9EE7\9EE7;
                      db $00,$10,$10,$00,$10,$00,$FC,$08        ;;9E33|9EEF+9ECE/9EEF\9EEF;
                      db $FC,$08,$00,$10,$10,$FC,$10,$FC        ;;9E3B|9EF7+9ED6/9EF7\9EF7;
                      db $FC,$04,$04,$FC,$F8,$10,$00,$10        ;;9E43|9EFF+9EDE/9EFF\9EFF;
                      db $FC,$10,$10,$04,$10,$00,$04,$10        ;;9E4B|9F07+9EE6/9F07\9F07;
                      db $04,$04,$FC,$F8,$04,$04,$10,$08        ;;9E53|9F0F+9EEE/9F0F\9F0F;
                      db $0C,$F4,$00,$10,$FC,$10,$10,$00        ;;9E5B|9F17+9EF6/9F17\9F17;
                      db $04,$10,$10,$F8,$00,$10,$00,$10        ;;9E63|9F1F+9EFE/9F1F\9F1F;
                      db $FC,$10,$10,$00,$00,$10,$00,$10        ;;9E6B|9F27+9F06/9F27\9F27;
                      db $00,$10,$00,$10,$00,$10,$00,$10        ;;9E73|9F2F+9F0E/9F2F\9F2F;
                      db $04,$FC,$04,$04,$04,$04,$00,$10        ;;9E7B|9F37+9F16/9F37\9F37;
                      db $00,$10,$10,$00,$10,$00,$FC,$10        ;;9E83|9F3F+9F1E/9F3F\9F3F;
                      db $FC,$04                                ;;9E8B|9F47+9F26/9F47\9F47;
                                                                ;;                        ;
DATA_049F49:          db $01,$00,$01,$00,$01,$00,$01,$00        ;;9E8D|9F49+9F28/9F49\9F49;
                      db $01,$00,$01,$00,$00,$01,$00,$01        ;;9E95|9F51+9F30/9F51\9F51;
                      db $00,$01,$00,$01,$01,$00,$01,$00        ;;9E9D|9F59+9F38/9F59\9F59;
                      db $00,$01,$01,$00,$01,$00,$01,$00        ;;9EA5|9F61+9F40/9F61\9F61;
                      db $00,$01,$01,$00,$01,$00,$01,$00        ;;9EAD|9F69+9F48/9F69\9F69;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9EB5|9F71+9F50/9F71\9F71;
                      db $01,$00,$01,$00,$01,$00,$00,$01        ;;9EBD|9F79+9F58/9F79\9F79;
                      db $00,$01,$01,$00,$00,$01,$01,$00        ;;9EC5|9F81+9F60/9F81\9F81;
                      db $00,$01,$01,$00,$01,$00,$01,$00        ;;9ECD|9F89+9F68/9F89\9F89;
                      db $01,$00,$01,$00,$01,$00,$00,$01        ;;9ED5|9F91+9F70/9F91\9F91;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9EDD|9F99+9F78/9F99\9F99;
                      db $00,$01,$00,$01,$01,$00,$01,$00        ;;9EE5|9FA1+9F80/9FA1\9FA1;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9EED|9FA9+9F88/9FA9\9FA9;
                      db $01,$00,$00,$01,$01,$00,$01,$00        ;;9EF5|9FB1+9F90/9FB1\9FB1;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9EFD|9FB9+9F98/9FB9\9FB9;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9F05|9FC1+9FA0/9FC1\9FC1;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9F0D|9FC9+9FA8/9FC9\9FC9;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9F15|9FD1+9FB0/9FD1\9FD1;
                      db $00,$01,$01,$00,$01,$00,$01,$00        ;;9F1D|9FD9+9FB8/9FD9\9FD9;
                      db $01,$00,$01,$00,$01,$00,$01,$00        ;;9F25|9FE1+9FC0/9FE1\9FE1;
                      db $00,$01                                ;;9F2D|9FE9+9FC8/9FE9\9FE9;
                                                                ;;                        ;
DATA_049FEB:          db $04,$04,$04,$04,$04,$04,$04,$00        ;;9F2F|9FEB+9FCA/9FEB\9FEB;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;9F37|9FF3+9FD2/9FF3\9FF3;
                      db $04,$00,$00,$04,$04,$04,$04,$00        ;;9F3F|9FFB+9FDA/9FFB\9FFB;
                      db $00,$00,$00,$00,$00,$00,$04,$00        ;;9F47|A003+9FE2/A003\A003;
                      db $00,$00,$04,$00,$00,$04,$04,$08        ;;9F4F|A00B+9FEA/A00B\A00B;
                      db $08,$08,$0C,$0C,$08,$08,$08,$08        ;;9F57|A013+9FF2/A013\A013;
                      db $08,$0C,$0C,$08,$08,$08,$08,$0C        ;;9F5F|A01B+9FFA/A01B\A01B;
                      db $08,$08,$08,$0C,$08,$0C,$14,$14        ;;9F67|A023+A002/A023\A023;
                      db $14,$04,$00,$00,$00,$00,$00,$00        ;;9F6F|A02B+A00A/A02B\A02B;
                      db $00,$00,$00,$00,$00,$04,$04,$08        ;;9F77|A033+A012/A033\A033;
                      db $00                                    ;;9F7F|A03B+A01A/A03B\A03B;
                                                                ;;                        ;
DATA_04A03C:          db $07,$09,$0A,$0D,$0E,$11,$17,$19        ;;9F80|A03C+A01B/A03C\A03C;
                      db $1A,$1C,$1D,$1F,$28,$29,$2D,$2E        ;;9F88|A044+A023/A044\A044;
                      db $35,$36,$37,$49,$4A,$4B,$4D,$51        ;;9F90|A04C+A02B/A04C\A04C;
DATA_04A054:          db $08,$FC,$FC,$08,$FC,$08,$FC,$08        ;;9F98|A054+A033/A054\A054;
                      db $FC,$08,$04,$00,$08,$04,$04,$08        ;;9FA0|A05C+A03B/A05C\A05C;
                      db $04,$08,$04,$00,$04,$08,$04,$00        ;;9FA8|A064+A043/A064\A064;
                      db $FC,$08,$00,$00,$FC,$08,$FC,$08        ;;9FB0|A06C+A04B/A06C\A06C;
                      db $04,$00,$04,$00,$00,$00,$08,$FC        ;;9FB8|A074+A053/A074\A074;
                      db $08,$04,$08,$04,$FC,$08,$08,$FC        ;;9FC0|A07C+A05B/A07C\A07C;
DATA_04A084:          db $04,$00                                ;;9FC8|A084+A063/A084\A084;
                                                                ;;                        ;
DATA_04A086:          db $F8,$FF,$08,$00,$FC,$FF,$F8,$FF        ;;9FCA|A086+A065/A086\A086;
                      db $04,$00,$F8,$FF,$04,$00,$08,$00        ;;9FD2|A08E+A06D/A08E\A08E;
                      db $FC,$FF,$04,$00,$04,$00,$04,$00        ;;9FDA|A096+A075/A096\A096;
                      db $08,$00,$08,$00,$04,$00,$F8,$FF        ;;9FE2|A09E+A07D/A09E\A09E;
                      db $FC,$FF,$00,$00,$00,$00,$08,$00        ;;9FEA|A0A6+A085/A0A6\A0A6;
                      db $04,$00,$04,$00,$04,$00,$F8,$FF        ;;9FF2|A0AE+A08D/A0AE\A0AE;
                      db $04,$00,$04,$00,$04,$00,$08,$00        ;;9FFA|A0B6+A095/A0B6\A0B6;
                      db $FC,$FF,$F8,$FF,$04,$00,$04,$00        ;;A002|A0BE+A09D/A0BE\A0BE;
                      db $04,$00,$00,$00,$00,$00,$04,$00        ;;A00A|A0C6+A0A5/A0C6\A0C6;
                      db $04,$00,$04,$00,$F8,$FF,$04,$00        ;;A012|A0CE+A0AD/A0CE\A0CE;
                      db $08,$00,$FC,$FF,$F8,$FF,$F8,$FF        ;;A01A|A0D6+A0B5/A0D6\A0D6;
                      db $04,$00,$FC,$FF,$08,$00                ;;A022|A0DE+A0BD/A0DE\A0DE;
                                                                ;;                        ;
DATA_04A0E4:          db $02,$02,$02,$02,$02,$00,$02,$02        ;;A028|A0E4+A0C3/A0E4\A0E4;
                      db $02,$00,$02,$00,$02,$00,$02,$02        ;;A030|A0EC+A0CB/A0EC\A0EC;
                      db $00,$00,$00,$02,$02,$02,$02,$02        ;;A038|A0F4+A0D3/A0F4\A0F4;
                                                                ;;                        ;
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
LevelNames:           db $00,$00,$52,$44,$53,$44,$90,$22        ;;A040                    ;
                      db $07,$22,$03,$62,$04,$62,$09,$22        ;;A048                    ;
                      db $40,$62,$02,$62,$51,$42,$06,$24        ;;A050                    ;
                      db $01,$65,$02,$65,$09,$27,$01,$66        ;;A058                    ;
                      db $01,$67,$00,$70,$00,$6F,$08,$22        ;;A060                    ;
                      db $30,$72,$01,$62,$00,$6F,$00,$00        ;;A068                    ;
                      db $60,$2A,$00,$00,$09,$29,$06,$29        ;;A070                    ;
                      db $05,$69,$04,$69,$00,$6F,$06,$28        ;;A078                    ;
                      db $09,$28,$07,$29,$01,$69,$03,$69        ;;A080                    ;
                      db $02,$69,$09,$21,$04,$61,$03,$61        ;;A088                    ;
                      db $00,$6E,$01,$61,$02,$61,$07,$23        ;;A090                    ;
                      db $00,$6F,$51,$43,$03,$63,$52,$42        ;;A098                    ;
                      db $00,$6F,$00,$6C,$00,$6D,$04,$6B        ;;A0A0                    ;
                      db $09,$2B,$06,$2B,$00,$00,$03,$6B        ;;A0A8                    ;
                      db $07,$2B,$02,$6B,$01,$6B,$51,$49        ;;A0B0                    ;
                      db $02,$63,$04,$63,$01,$63,$10,$63        ;;A0B8                    ;
                      db $09,$23,$07,$28,$01,$68,$04,$68        ;;A0C0                    ;
                      db $02,$68,$20,$68,$51,$48,$03,$68        ;;A0C8                    ;
                      db $00,$6F,$DA,$00,$DA,$00,$CA,$40        ;;A0D0                    ;
                      db $CA,$40,$00,$6F,$AA,$60,$AA,$60        ;;A0D8                    ;
                      db $BA,$60,$BA,$60,$00,$6F,$00,$6F        ;;A0E0                    ;
                      db $02,$71,$00,$6F,$03,$71,$00,$6F        ;;A0E8                    ;
                      db $01,$71,$04,$71,$05,$71,$00,$6F        ;;A0F0                    ;
                      db $00,$6F                                ;;A0F8                    ;
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0, & E1
LevelNames:           db $00,$00,$72,$0D,$73,$0D,$00,$0C        ;;    |A0FC+A0DB/A0FC\A0FC;
                      db $60,$0A,$53,$0A,$54,$0A,$40,$04        ;;    |A104+A0E3/A104\A104;
                      db $30,$0B,$52,$0A,$71,$0A,$90,$0D        ;;    |A10C+A0EB/A10C\A10C;
                      db $01,$11,$02,$11,$40,$06,$07,$12        ;;    |A114+A0F3/A114\A114;
                      db $00,$14,$00,$13,$C0,$02,$7C,$0A        ;;    |A11C+A0FB/A11C\A11C;
                      db $33,$0E,$51,$0A,$C0,$02,$53,$04        ;;    |A124+A103/A124\A124;
                      db $00,$18,$53,$04,$40,$08,$90,$16        ;;    |A12C+A10B/A12C\A12C;
                      db $25,$16,$24,$16,$C0,$02,$90,$15        ;;    |A134+A113/A134\A134;
                      db $40,$07,$00,$17,$21,$16,$23,$16        ;;    |A13C+A11B/A13C\A13C;
                      db $22,$16,$40,$03,$24,$01,$23,$01        ;;    |A144+A123/A144\A144;
                      db $10,$01,$21,$01,$22,$01,$60,$0D        ;;    |A14C+A12B/A14C\A14C;
                      db $C0,$02,$71,$0D,$83,$0D,$72,$0A        ;;    |A154+A133/A154\A154;
                      db $C0,$02,$00,$1B,$00,$1A,$B4,$19        ;;    |A15C+A13B/A15C\A15C;
                      db $40,$09,$90,$19,$00,$00,$B3,$19        ;;    |A164+A143/A164\A164;
                      db $60,$19,$B2,$19,$B1,$19,$70,$16        ;;    |A16C+A14B/A16C\A16C;
                      db $82,$0D,$84,$0D,$81,$0D,$30,$0F        ;;    |A174+A153/A174\A174;
                      db $40,$05,$60,$15,$A1,$15,$A4,$15        ;;    |A17C+A15B/A17C\A17C;
                      db $A2,$15,$30,$10,$77,$15,$A3,$15        ;;    |A184+A163/A184\A184;
                      db $C0,$02,$0B,$00,$0A,$00,$09,$00        ;;    |A18C+A16B/A18C\A18C;
                      db $08,$00,$C0,$02,$00,$1C,$00,$1D        ;;    |A194+A173/A194\A194;
                      db $00,$1E,$E0,$00,$C0,$02,$C0,$02        ;;    |A19C+A17B/A19C\A19C;
                      db $D2,$02,$C0,$02,$D3,$02,$C0,$02        ;;    |A1A4+A183/A1A4\A1A4;
                      db $D1,$02,$D4,$02,$D5,$02,$C0,$02        ;;    |A1AC+A18B/A1AC\A1AC;
                      db $C0,$02                                ;;    |A1B4+A193/A1B4\A1B4;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                                                                ;;                        ;
                      %insert_empty($306,$24A,$26B,$24A,$24A)   ;;A0FA|A1B6+A195/A1B6\A1B6;
                                                                ;;                        ;
OWBorderStripe:       db $50,$00,$41,$3E,$FE,$38,$50,$A0        ;;A400|A400+A400/A400\A400;
                      db $C0,$28,$FE,$38,$50,$A1,$C0,$28        ;;A408|A408+A408/A408\A408;
                      db $FE,$38,$50,$BE,$C0,$28,$FE,$38        ;;A410|A410+A410/A410\A410;
                      db $50,$BF,$C0,$28,$FE,$38,$53,$40        ;;A418|A418+A418/A418\A418;
                      db $41,$7E,$FE,$38,$50,$A2,$00,$01        ;;A420|A420+A420/A420\A420;
                      db $92,$3C,$50,$A3,$40,$32,$93,$3C        ;;A428|A428+A428/A428\A428;
                      db $50,$BD,$00,$01,$92,$7C,$50,$C2        ;;A430|A430+A430/A430\A430;
                      db $C0,$24,$94,$7C,$50,$DD,$C0,$24        ;;A438|A438+A438/A438\A438;
                      db $94,$3C,$53,$22,$00,$01,$92,$BC        ;;A440|A440+A440/A440\A440;
                      db $53,$23,$40,$32,$93,$BC,$53,$3D        ;;A448|A448+A448/A448\A448;
                      db $00,$01,$92,$FC,$50,$FE,$C0,$24        ;;A450|A450+A450/A450\A450;
                      db $D6,$2C,$53,$44,$40,$32,$D5,$2C        ;;A458|A458+A458/A458\A458;
                      db $50,$DE,$00,$01,$D4,$2C,$53,$43        ;;A460|A460+A460/A460\A460;
                      db $00,$01,$D4,$EC,$53,$5E,$00,$01        ;;A468|A468+A468/A468\A468;
                      db $D4,$AC,$50,$02,$00,$01,$95,$38        ;;A470|A470+A470/A470\A470;
                      db $50,$09,$00,$01,$97,$38,$50,$0E        ;;A478|A478+A478/A478\A478;
                      db $00,$01,$96,$38,$50,$33,$00,$01        ;;A480|A480+A480/A480\A480;
                      db $97,$38,$50,$37,$00,$01,$95,$38        ;;A488|A488+A488/A488\A488;
                      db $50,$3B,$00,$01,$96,$38,$50,$42        ;;A490|A490+A490/A490\A490;
                      db $00,$01,$96,$38,$50,$50,$00,$01        ;;A498|A498+A498/A498\A498;
                      db $95,$38,$50,$55,$00,$01,$96,$38        ;;A4A0|A4A0+A4A0/A4A0\A4A0;
                      db $50,$5E,$00,$01,$95,$38,$51,$01        ;;A4A8|A4A8+A4A8/A4A8\A4A8;
                      db $00,$01,$97,$38,$51,$5F,$00,$01        ;;A4B0|A4B0+A4B0/A4B0\A4B0;
                      db $96,$38,$51,$81,$00,$01,$95,$38        ;;A4B8|A4B8+A4B8/A4B8\A4B8;
                      db $51,$C0,$00,$01,$96,$38,$51,$FF        ;;A4C0|A4C0+A4C0/A4C0\A4C0;
                      db $00,$01,$97,$38,$52,$60,$00,$01        ;;A4C8|A4C8+A4C8/A4C8\A4C8;
                      db $95,$38,$52,$7F,$00,$01,$95,$38        ;;A4D0|A4D0+A4D0/A4D0\A4D0;
                      db $53,$00,$00,$01,$97,$38,$53,$1F        ;;A4D8|A4D8+A4D8/A4D8\A4D8;
                      db $00,$01,$96,$38,$53,$61,$00,$01        ;;A4E0|A4E0+A4E0/A4E0\A4E0;
                      db $95,$38,$53,$6A,$00,$01,$95,$38        ;;A4E8|A4E8+A4E8/A4E8\A4E8;
                      db $53,$73,$00,$01,$96,$38,$53,$76        ;;A4F0|A4F0+A4F0/A4F0\A4F0;
                      db $00,$01,$95,$38,$53,$86,$00,$01        ;;A4F8|A4F8+A4F8/A4F8\A4F8;
                      db $96,$38,$53,$91,$00,$01,$95,$38        ;;A500|A500+A500/A500\A500;
                      db $53,$9A,$00,$01,$97,$38,$53,$9E        ;;A508|A508+A508/A508\A508;
                      db $00,$01,$95,$38,$50,$23,$C0,$06        ;;A510|A510+A510/A510\A510;
                      db $FC,$2C,$50,$24,$C0,$06,$FC,$2C        ;;A518|A518+A518/A518\A518;
                      db $50,$25,$C0,$06,$FC,$2C,$50,$26        ;;A520|A520+A520/A520\A520;
                      db $C0,$06,$FC,$2C,$50,$87,$00,$01        ;;A528|A528+A528/A528\A528;
                      db $8F,$38,$FF                            ;;A530|A530+A530/A530\A530;
                                                                ;;                        ;
OWTileNumbers:        db $9B,$75,$81,$20,$01                    ;;A533|A533+A533/A533\A533;
                      db $76,$20,$9B,$75,$81,$20,$01,$76        ;;A538|A538+A538/A538\A538;
                      db $20,$9A,$75,$00,$10,$81,$20,$01        ;;A540|A540+A540/A540\A540;
                      db $76,$20,$94,$75,$00,$01,$81,$02        ;;A548|A548+A548/A548\A548;
                      db $81,$01,$05,$02,$11,$50,$20,$7D        ;;A550|A550+A550/A550\A550;
                      db $20,$92,$75,$02,$10,$03,$11,$81        ;;A558|A558+A558/A558\A558;
                      db $71,$81,$11,$81,$71,$03,$11,$43        ;;A560|A560+A560/A560\A560;
                      db $10,$9C,$91,$75,$01,$10,$11,$89        ;;A568|A568+A568/A568\A568;
                      db $71,$01,$11,$10,$89,$75,$04,$01        ;;A570|A570+A570/A570\A570;
                      db $02,$03,$02,$01,$82,$75,$01,$3D        ;;A578|A578+A578/A578\A578;
                      db $71,$83,$AD,$81,$8A,$81,$AD,$81        ;;A580|A580+A580/A580\A580;
                      db $8A,$01,$11,$10,$89,$75,$00,$3D        ;;A588|A588+A588/A588\A588;
                      db $82,$71,$00,$3D,$82,$75,$01,$3D        ;;A590|A590+A590/A590\A590;
                      db $71,$83,$AD,$81,$8A,$81,$AD,$81        ;;A598|A598+A598/A598\A598;
                      db $8A,$01,$3D,$3F,$89,$75,$00,$00        ;;A5A0|A5A0+A5A0/A5A0\A5A0;
                      db $81,$43,$01,$42,$40,$81,$75,$01        ;;A5A8|A5A8+A5A8/A5A8\A5A8;
                      db $10,$00,$83,$43,$00,$11,$85,$71        ;;A5B0|A5B0+A5B0/A5B0\A5B0;
                      db $01,$11,$10,$88,$75,$01,$11,$20        ;;A5B8|A5B8+A5B8/A5B8\A5B8;
                      db $82,$69,$03,$20,$11,$75,$3D,$81        ;;A5C0|A5C0+A5C0/A5C0\A5C0;
                      db $20,$82,$69,$00,$00,$81,$43,$00        ;;A5C8|A5C8+A5C8/A5C8\A5C8;
                      db $11,$83,$71,$00,$3D,$88,$75,$01        ;;A5D0|A5D0+A5D0/A5D0\A5D0;
                      db $11,$50,$81,$69,$04,$41,$42,$11        ;;A5D8|A5D8+A5D8/A5D8\A5D8;
                      db $75,$3D,$81,$20,$81,$69,$01,$20        ;;A5E0|A5E0+A5E0/A5E0\A5E0;
                      db $69,$81,$20,$00,$50,$83,$43,$00        ;;A5E8|A5E8+A5E8/A5E8\A5E8;
                      db $10,$89,$75,$00,$11,$81,$43,$00        ;;A5F0|A5F0+A5F0/A5F0\A5F0;
                      db $11,$82,$75,$02,$3D,$50,$20,$82        ;;A5F8|A5F8+A5F8/A5F8\A5F8;
                      db $69,$81,$20,$01,$69,$20,$82,$69        ;;A600|A600+A600/A600\A600;
                      db $01,$20,$76,$86,$75,$01,$54,$55        ;;A608|A608+A608/A608\A608;
                      db $87,$75,$01,$00,$11,$83,$43,$00        ;;A610|A610+A610/A610\A610;
                      db $50,$81,$20,$83,$69,$01,$20,$76        ;;A618|A618+A618/A618\A618;
                      db $86,$75,$03,$9E,$9F,$06,$05,$85        ;;A620|A620+A620/A620\A620;
                      db $03,$01,$20,$50,$83,$43,$00,$11        ;;A628|A628+A628/A628\A628;
                      db $81,$43,$00,$50,$82,$69,$01,$20        ;;A630|A630+A630/A630\A630;
                      db $7D,$84,$75,$04,$01,$02,$9E,$9F        ;;A638|A638+A638/A638\A638;
                      db $58,$81,$71,$02,$BA,$BD,$BF,$81        ;;A640|A640+A640/A640\A640;
                      db $71,$81,$20,$83,$69,$03,$50,$11        ;;A648|A648+A648/A648\A648;
                      db $71,$11,$82,$43,$01,$9C,$10,$84        ;;A650|A650+A650/A650\A650;
                      db $75,$0E,$3D,$71,$9E,$9F,$71,$58        ;;A658|A658+A658/A658\A658;
                      db $71,$BD,$BF,$BA,$71,$11,$20,$69        ;;A660|A660+A660/A660\A660;
                      db $20,$83,$69,$00,$50,$83,$43,$02        ;;A668|A668+A668/A668\A668;
                      db $10,$9C,$43,$84,$75,$04,$3D,$58        ;;A670|A670+A670/A670\A670;
                      db $9E,$9F,$71,$81,$58,$06,$BF,$71        ;;A678|A678+A678/A678\A678;
                      db $BD,$71,$11,$50,$20,$84,$69,$00        ;;A680|A680+A680/A680\A680;
                      db $20,$82,$69,$03,$20,$76,$20,$69        ;;A688|A688+A688/A688\A688;
                      db $83,$75,$05,$10,$11,$58,$9E,$9F        ;;A690|A690+A690/A690\A690;
                      db $58,$81,$71,$07,$58,$BA,$BD,$BF        ;;A698|A698+A698/A698\A698;
                      db $71,$11,$50,$20,$84,$69,$00,$20        ;;A6A0|A6A0+A6A0/A6A0\A6A0;
                      db $81,$69,$03,$20,$76,$20,$69,$82        ;;A6A8|A6A8+A6A8/A6A8\A6A8;
                      db $75,$06,$10,$11,$56,$57,$9E,$9F        ;;A6B0|A6B0+A6B0/A6B0\A6B0;
                      db $58,$82,$71,$02,$BD,$71,$BA,$81        ;;A6B8|A6B8+A6B8/A6B8\A6B8;
                      db $71,$81,$58,$04,$43,$58,$43,$50        ;;A6C0|A6C0+A6C0/A6C0\A6C0;
                      db $20,$82,$69,$03,$20,$76,$20,$69        ;;A6C8|A6C8+A6C8/A6C8\A6C8;
                      db $82,$75,$05,$3D,$58,$9E,$9F,$64        ;;A6D0|A6D0+A6D0/A6D0\A6D0;
                      db $65,$84,$71,$81,$BD,$00,$BF,$83        ;;A6D8|A6D8+A6D8/A6D8\A6D8;
                      db $58,$04,$71,$58,$11,$50,$20,$81        ;;A6E0|A6E0+A6E0/A6E0\A6E0;
                      db $69,$03,$20,$76,$20,$69,$82,$75        ;;A6E8|A6E8+A6E8/A6E8\A6E8;
                      db $03,$3D,$71,$64,$65,$81,$71,$00        ;;A6F0|A6F0+A6F0/A6F0\A6F0;
                      db $6E,$81,$6B,$05,$6E,$BD,$BF,$BA        ;;A6F8|A6F8+A6F8/A6F8\A6F8;
                      db $BD,$58,$81,$8A,$01,$AD,$8E,$81        ;;A700|A700+A700/A700\A700;
                      db $58,$07,$11,$43,$BC,$3D,$20,$7D        ;;A708|A708+A708/A708\A708;
                      db $20,$69,$82,$75,$01,$00,$11,$81        ;;A710|A710+A710/A710\A710;
                      db $71,$01,$AE,$BC,$83,$68,$04,$BA        ;;A718|A718+A718/A718\A718;
                      db $BD,$11,$43,$11,$81,$8A,$09,$AD        ;;A720|A720+A720/A720\A720;
                      db $8A,$8F,$53,$52,$71,$BC,$3D,$43        ;;A728|A728+A728/A728\A728;
                      db $3F,$81,$43,$82,$75,$06,$20,$50        ;;A730|A730+A730/A730\A730;
                      db $11,$8F,$9B,$71,$6E,$81,$6B,$05        ;;A738|A738+A738/A738\A738;
                      db $6E,$11,$43,$00,$69,$00,$81,$43        ;;A740|A740+A740/A740\A740;
                      db $08,$58,$8F,$9B,$63,$62,$71,$BC        ;;A748|A748+A748/A748\A748;
                      db $71,$10,$82,$3F,$82,$75,$02,$20        ;;A750|A750+A750/A750\A750;
                      db $50,$11,$81,$AC,$01,$58,$11,$82        ;;A758|A758+A758/A758\A758;
                      db $43,$04,$00,$69,$50,$43,$50,$81        ;;A760|A760+A760/A760\A760;
                      db $20,$04,$50,$58,$9B,$8F,$6C,$81        ;;A768|A768+A768/A768\A768;
                      db $68,$01,$6C,$3D,$82,$3F,$82,$75        ;;A770|A770+A770/A770\A770;
                      db $02,$00,$11,$58,$81,$AC,$09,$11        ;;A778|A778+A778/A778\A778;
                      db $50,$20,$69,$20,$50,$43,$11,$3F        ;;A780|A780+A780/A780\A780;
                      db $11,$81,$43,$03,$50,$3D,$8A,$BC        ;;A788|A788+A788/A788\A788;
                      db $83,$68,$00,$6C,$82,$03,$81,$75        ;;A790|A790+A790/A790\A790;
                      db $03,$10,$11,$56,$57,$81,$AC,$01        ;;A798|A798+A798/A798\A798;
                      db $3D,$50,$82,$43,$00,$11,$85,$3F        ;;A7A0|A7A0+A7A0/A7A0\A7A0;
                      db $03,$10,$11,$8A,$BC,$84,$68,$81        ;;A7A8|A7A8+A7A8/A7A8\A7A8;
                      db $71,$00,$43,$81,$75,$03,$3D,$58        ;;A7B0|A7B0+A7B0/A7B0\A7B0;
                      db $64,$65,$81,$8A,$01,$11,$10,$87        ;;A7B8|A7B8+A7B8/A7B8\A7B8;
                      db $3F,$03,$10,$03,$52,$53,$81,$71        ;;A7C0|A7C0+A7C0/A7C0\A7C0;
                      db $00,$6C,$82,$68,$03,$6C,$11,$00        ;;A7C8|A7C8+A7C8/A7C8\A7C8;
                      db $69,$81,$75,$03,$3D,$71,$56,$57        ;;A7D0|A7D0+A7D0/A7D0\A7D0;
                      db $81,$8A,$01,$58,$3D,$86,$3F,$00        ;;A7D8|A7D8+A7D8/A7D8\A7D8;
                      db $10,$81,$8F,$0B,$62,$63,$52,$53        ;;A7E0|A7E0+A7E0/A7E0\A7E0;
                      db $71,$52,$53,$71,$11,$50,$69,$20        ;;A7E8|A7E8+A7E8/A7E8\A7E8;
                      db $81,$75,$03,$00,$11,$64,$65,$81        ;;A7F0|A7F0+A7F0/A7F0\A7F0;
                      db $AC,$02,$11,$00,$11,$84,$3F,$0F        ;;A7F8|A7F8+A7F8/A7F8\A7F8;
                      db $10,$52,$53,$71,$8E,$71,$62,$63        ;;A800|A800+A800/A800\A800;
                      db $52,$51,$63,$11,$50,$69,$20,$69        ;;A808|A808+A808/A808\A808;
                      db $81,$75,$03,$20,$3D,$71,$58,$81        ;;A810|A810+A810/A810\A810;
                      db $AC,$02,$3D,$50,$11,$84,$3F,$04        ;;A818|A818+A818/A818\A818;
                      db $3D,$62,$63,$71,$8E,$82,$71,$03        ;;A820|A820+A820/A820\A820;
                      db $62,$63,$42,$41,$82,$69,$00,$20        ;;A828|A828+A828/A828\A828;
                      db $81,$75,$03,$20,$3D,$58,$71,$81        ;;A830|A830+A830/A830\A830;
                      db $AC,$00,$3D,$83,$3F,$00,$10,$81        ;;A838|A838+A838/A838\A838;
                      db $03,$0A,$11,$52,$53,$52,$53,$71        ;;A840|A840+A840/A840\A840;
                      db $52,$53,$11,$50,$20,$82,$69,$07        ;;A848|A848+A848/A848\A848;
                      db $50,$43,$75,$11,$20,$00,$11,$71        ;;A850|A850+A850/A850\A850;
                      db $81,$AC,$01,$11,$10,$82,$3F,$00        ;;A858|A858+A858/A858\A858;
                      db $3D,$81,$71,$09,$52,$51,$63,$62        ;;A860|A860+A860/A860\A860;
                      db $63,$52,$51,$63,$3A,$20,$82,$69        ;;A868|A868+A868/A868\A868;
                      db $03,$50,$11,$75,$20,$9E,$75,$00        ;;A870|A870+A870/A870\A870;
                      db $20,$9E,$75,$01,$20,$10,$95,$75        ;;A878|A878+A878/A878\A878;
                      db $03,$E2,$E5,$F5,$F6,$83,$75,$02        ;;A880|A880+A880/A880\A880;
                      db $50,$11,$10,$90,$75,$07,$01,$02        ;;A888|A888+A888/A888\A888;
                      db $03,$05,$84,$32,$33,$C4,$83,$75        ;;A890|A890+A890/A890\A890;
                      db $03,$11,$71,$11,$10,$8D,$75,$02        ;;A898|A898+A898/A898\A898;
                      db $01,$02,$11,$82,$71,$04,$35,$36        ;;A8A0|A8A0+A8A0/A8A0\A8A0;
                      db $37,$38,$01,$82,$75,$01,$10,$03        ;;A8A8|A8A8+A8A8/A8A8\A8A8;
                      db $81,$11,$00,$10,$8B,$75,$01,$10        ;;A8B0|A8B0+A8B0/A8B0\A8B0;
                      db $11,$84,$71,$05,$49,$4A,$59,$5A        ;;A8B8|A8B8+A8B8/A8B8\A8B8;
                      db $11,$10,$81,$75,$81,$3F,$02,$10        ;;A8C0|A8C0+A8C0/A8C0\A8C0;
                      db $71,$3D,$8B,$75,$02,$3D,$AD,$5D        ;;A8C8|A8C8+A8C8/A8C8\A8C8;
                      db $84,$68,$00,$5D,$82,$71,$00,$3D        ;;A8D0|A8D0+A8D0/A8D0\A8D0;
                      db $81,$75,$82,$3F,$81,$3D,$8B,$75        ;;A8D8|A8D8+A8D8/A8D8\A8D8;
                      db $01,$3D,$AD,$86,$68,$81,$71,$01        ;;A8E0|A8E0+A8E0/A8E0\A8E0;
                      db $11,$00,$81,$75,$81,$3F,$02,$10        ;;A8E8|A8E8+A8E8/A8E8\A8E8;
                      db $11,$00,$87,$75,$01,$01,$02,$81        ;;A8F0|A8F0+A8F0/A8F0\A8F0;
                      db $03,$02,$00,$11,$5D,$84,$68,$04        ;;A8F8|A8F8+A8F8/A8F8\A8F8;
                      db $5D,$71,$11,$50,$20,$81,$75,$05        ;;A900|A900+A900/A900\A900;
                      db $3F,$10,$11,$50,$20,$10,$85,$75        ;;A908|A908+A908/A908\A908;
                      db $01,$10,$11,$82,$71,$04,$20,$50        ;;A910|A910+A910/A910\A910;
                      db $44,$43,$44,$81,$43,$05,$44,$43        ;;A918|A918+A918/A918\A918;
                      db $42,$40,$69,$20,$81,$75,$05,$9C        ;;A920|A920+A920/A920\A920;
                      db $43,$50,$69,$20,$3D,$85,$A4,$01        ;;A928|A928+A928/A928\A928;
                      db $3D,$AD,$81,$8A,$03,$11,$20,$69        ;;A930|A930+A930/A930\A930;
                      db $20,$87,$69,$81,$20,$81,$75,$81        ;;A938|A938+A938/A938\A938;
                      db $20,$81,$69,$01,$50,$3D,$81,$B4        ;;A940|A940+A940/A940\A940;
                      db $01,$B5,$A5,$81,$B4,$01,$3D,$AD        ;;A948|A948+A948/A948\A948;
                      db $81,$8A,$02,$11,$50,$20,$87,$69        ;;A950|A950+A950/A950\A950;
                      db $0A,$20,$69,$20,$10,$75,$20,$69        ;;A958|A958+A958/A958\A958;
                      db $20,$50,$11,$4D,$85,$75,$01,$4D        ;;A960|A960+A960/A960\A960;
                      db $71,$81,$AC,$03,$71,$11,$50,$20        ;;A968|A968+A968/A968\A968;
                      db $87,$69,$81,$20,$01,$11,$10,$81        ;;A970|A970+A970/A970\A970;
                      db $20,$00,$50,$81,$11,$01,$00,$02        ;;A978|A978+A978/A978\A978;
                      db $82,$03,$05,$02,$01,$3D,$71,$8F        ;;A980|A980+A980/A980\A980;
                      db $9B,$81,$71,$01,$11,$44,$81,$43        ;;A988|A988+A988/A988\A988;
                      db $00,$60,$83,$69,$04,$20,$69,$20        ;;A990|A990+A990/A990\A990;
                      db $71,$3D,$81,$43,$81,$11,$02,$50        ;;A998|A998+A998/A998\A998;
                      db $20,$11,$82,$43,$81,$11,$03,$00        ;;A9A0|A9A0+A9A0/A9A0\A9A0;
                      db $11,$71,$AE,$83,$BC,$02,$AE,$11        ;;A9A8|A9A8+A9A8/A9A8\A9A8;
                      db $00,$84,$69,$0A,$20,$50,$58,$4D        ;;A9B0|A9B0+A9B0/A9B0\A9B0;
                      db $43,$11,$71,$3D,$69,$20,$41,$82        ;;A9B8|A9B8+A9B8/A9B8\A9B8;
                      db $69,$07,$41,$42,$20,$41,$42,$44        ;;A9C0|A9C0+A9C0/A9C0\A9C0;
                      db $43,$44,$81,$43,$02,$44,$50,$20        ;;A9C8|A9C8+A9C8/A9C8\A9C8;
                      db $83,$69,$0B,$20,$50,$11,$71,$3D        ;;A9D0|A9D0+A9D0/A9D0\A9D0;
                      db $20,$50,$43,$00,$69,$20,$42,$82        ;;A9D8|A9D8+A9D8/A9D8\A9D8;
                      db $43,$02,$42,$41,$20,$81,$69,$00        ;;A9E0|A9E0+A9E0/A9E0\A9E0;
                      db $20,$84,$69,$81,$20,$82,$69,$0B        ;;A9E8|A9E8+A9E8/A9E8\A9E8;
                      db $41,$42,$11,$58,$71,$4D,$69,$20        ;;A9F0|A9F0+A9F0/A9F0\A9F0;
                      db $69,$20,$69,$20,$85,$73,$02,$20        ;;A9F8|A9F8+A9F8/A9F8\A9F8;
                      db $69,$20,$84,$69,$02,$20,$69,$20        ;;AA00|AA00+AA00/AA00\AA00;
                      db $82,$43,$00,$11,$81,$58,$03,$71        ;;AA08|AA08+AA08/AA08\AA08;
                      db $58,$3D,$20,$81,$69,$03,$20,$69        ;;AA10|AA10+AA10/AA10\AA10;
                      db $50,$11,$83,$3F,$01,$11,$20,$81        ;;AA18|AA18+AA18/AA18\AA18;
                      db $69,$00,$20,$84,$69,$02,$20,$50        ;;AA20|AA20+AA20/AA20\AA20;
                      db $58,$81,$AC,$81,$89,$81,$58,$07        ;;AA28|AA28+AA28/AA28\AA28;
                      db $11,$00,$69,$20,$69,$20,$50,$11        ;;AA30|AA30+AA30/AA30\AA30;
                      db $84,$3F,$03,$11,$50,$69,$20,$84        ;;AA38|AA38+AA38/AA38\AA38;
                      db $69,$01,$20,$50,$81,$89,$81,$AC        ;;AA40|AA40+AA40/AA40\AA40;
                      db $81,$99,$81,$89,$00,$3D,$81,$20        ;;AA48|AA48+AA48/AA48\AA48;
                      db $81,$69,$01,$20,$11,$86,$3F,$04        ;;AA50|AA50+AA50/AA50\AA50;
                      db $11,$42,$41,$20,$60,$83,$43,$00        ;;AA58|AA58+AA58/AA58\AA58;
                      db $11,$81,$99,$81,$AC,$81,$89,$81        ;;AA60|AA60+AA60/AA60\AA60;
                      db $99,$06,$3D,$20,$43,$50,$69,$50        ;;AA68|AA68+AA68/AA68\AA68;
                      db $11,$88,$3F,$03,$11,$43,$3D,$71        ;;AA70|AA70+AA70/AA70\AA70;
                      db $81,$89,$01,$71,$58,$81,$89,$81        ;;AA78|AA78+AA78/AA78\AA78;
                      db $8F,$09,$99,$98,$89,$71,$3D,$20        ;;AA80|AA80+AA80/AA80\AA80;
                      db $3F,$11,$43,$11,$8A,$3F,$02,$10        ;;AA88|AA88+AA88/AA88\AA88;
                      db $11,$58,$81,$99,$81,$89,$01,$99        ;;AA90|AA90+AA90/AA90\AA90;
                      db $98,$82,$89,$81,$99,$02,$58,$3D        ;;AA98|AA98+AA98/AA98\AA98;
                      db $50,$82,$3F,$81,$10,$83,$3F,$81        ;;AAA0|AAA0+AAA0/AAA0\AAA0;
                      db $10,$82,$3F,$01,$10,$11,$81,$89        ;;AAA8|AAA8+AAA8/AAA8\AAA8;
                      db $04,$58,$89,$98,$99,$89,$82,$98        ;;AAB0|AAB0+AAB0/AAB0\AAB0;
                      db $00,$99,$81,$89,$02,$58,$4D,$11        ;;AAB8|AAB8+AAB8/AAB8\AAB8;
                      db $82,$03,$02,$11,$00,$11,$81,$3F        ;;AAC0|AAC0+AAC0/AAC0\AAC0;
                      db $00,$10,$81,$11,$82,$03,$04,$11        ;;AAC8|AAC8+AAC8/AAC8\AAC8;
                      db $58,$99,$98,$89,$81,$99,$00,$89        ;;AAD0|AAD0+AAD0/AAD0\AAD0;
                      db $83,$98,$00,$89,$81,$99,$02,$71        ;;AAD8|AAD8+AAD8/AAD8\AAD8;
                      db $4D,$75,$82,$43,$81,$50,$02,$11        ;;AAE0|AAE0+AAE0/AAE0\AAE0;
                      db $3F,$9C,$82,$43,$02,$11,$71,$58        ;;AAE8|AAE8+AAE8/AAE8\AAE8;
                      db $82,$89,$01,$98,$99,$81,$89,$85        ;;AAF0|AAF0+AAF0/AAF0\AAF0;
                      db $99,$00,$58,$81,$89,$01,$11,$10        ;;AAF8|AAF8+AAF8/AAF8\AAF8;
                      db $81,$69,$81,$20,$82,$76,$00,$20        ;;AB00|AB00+AB00/AB00\AB00;
                      db $81,$69,$03,$20,$50,$11,$71,$82        ;;AB08|AB08+AB08/AB08\AB08;
                      db $99,$03,$98,$89,$99,$98,$86,$89        ;;AB10|AB10+AB10/AB10\AB10;
                      db $81,$99,$01,$58,$3D,$81,$69,$81        ;;AB18|AB18+AB18/AB18\AB18;
                      db $20,$82,$76,$00,$20,$82,$69,$03        ;;AB20|AB20+AB20/AB20\AB20;
                      db $20,$41,$42,$11,$81,$89,$81,$99        ;;AB28|AB28+AB28/AB28\AB28;
                      db $01,$89,$98,$81,$99,$81,$98,$82        ;;AB30|AB30+AB30/AB30\AB30;
                      db $99,$81,$89,$01,$58,$3D,$81,$69        ;;AB38|AB38+AB38/AB38\AB38;
                      db $81,$20,$82,$7D,$00,$20,$81,$69        ;;AB40|AB40+AB40/AB40\AB40;
                      db $00,$20,$82,$69,$00,$3D,$81,$99        ;;AB48|AB48+AB48/AB48\AB48;
                      db $81,$89,$01,$99,$98,$81,$89,$81        ;;AB50|AB50+AB50/AB50\AB50;
                      db $98,$06,$89,$3B,$89,$98,$99,$11        ;;AB58|AB58+AB58/AB58\AB58;
                      db $00,$81,$69,$05,$20,$50,$11,$3F        ;;AB60|AB60+AB60/AB60\AB60;
                      db $11,$20,$82,$69,$00,$20,$81,$69        ;;AB68|AB68+AB68/AB68\AB68;
                      db $06,$3D,$71,$58,$99,$98,$89,$99        ;;AB70|AB70+AB70/AB70\AB70;
                      db $83,$98,$01,$99,$89,$81,$98,$02        ;;AB78|AB78+AB78/AB78\AB78;
                      db $89,$3D,$20,$82,$43,$00,$11,$81        ;;AB80|AB80+AB80/AB80\AB80;
                      db $3F,$00,$11,$83,$43,$03,$50,$41        ;;AB88|AB88+AB88/AB88\AB88;
                      db $42,$11,$82,$89,$82,$98,$82,$99        ;;AB90|AB90+AB90/AB90\AB90;
                      db $01,$98,$89,$83,$99,$01,$3D,$20        ;;AB98|AB98+AB98/AB98\AB98;
                      db $87,$75,$04,$08,$07,$06,$05,$11        ;;ABA0|ABA0+ABA0/ABA0\ABA0;
                      db $81,$58,$84,$99,$00,$98,$82,$89        ;;ABA8|ABA8+ABA8/ABA8\ABA8;
                      db $81,$99,$81,$89,$09,$58,$71,$3D        ;;ABB0|ABB0+ABB0/ABB0\ABB0;
                      db $20,$75,$11,$50,$20,$3D,$71,$81        ;;ABB8|ABB8+ABB8/ABB8\ABB8;
                      db $AC,$01,$71,$11,$82,$03,$00,$11        ;;ABC0|ABC0+ABC0/ABC0\ABC0;
                      db $81,$71,$01,$62,$63,$82,$71,$08        ;;ABC8|ABC8+ABC8/ABC8\ABC8;
                      db $62,$63,$11,$2A,$69,$20,$69,$50        ;;ABD0|ABD0+ABD0/ABD0\ABD0;
                      db $11,$83,$75,$05,$11,$20,$00,$11        ;;ABD8|ABD8+ABD8/ABD8\ABD8;
                      db $8F,$9B,$84,$71,$00,$5D,$81,$68        ;;ABE0|ABE0+ABE0/ABE0\ABE0;
                      db $00,$5D,$82,$71,$03,$58,$71,$11        ;;ABE8|ABE8+ABE8/ABE8\ABE8;
                      db $50,$81,$20,$02,$41,$42,$11,$85        ;;ABF0|ABF0+ABF0/ABF0\ABF0;
                      db $75,$06,$00,$43,$23,$30,$AE,$AF        ;;ABF8|ABF8+ABF8/ABF8\ABF8;
                      db $AD,$81,$8A,$01,$71,$5D,$81,$68        ;;AC00|AC00+AC00/AC00\AC00;
                      db $00,$5D,$83,$71,$05,$11,$50,$20        ;;AC08|AC08+AC08/AC08\AC08;
                      db $69,$2A,$11,$86,$75,$01,$10,$11        ;;AC10|AC10+AC10/AC10\AC10;
                      db $81,$71,$03,$11,$30,$8E,$AD,$81        ;;AC18|AC18+AC18/AC18\AC18;
                      db $8A,$01,$52,$53,$81,$71,$81,$58        ;;AC20|AC20+AC20/AC20\AC20;
                      db $03,$71,$58,$11,$50,$81,$69,$01        ;;AC28|AC28+AC28/AC28\AC28;
                      db $20,$3A,$81,$75,$01,$A6,$A7,$83        ;;AC30|AC30+AC30/AC30\AC30;
                      db $75,$01,$00,$11,$81,$71,$03,$11        ;;AC38|AC38+AC38/AC38\AC38;
                      db $00,$52,$53,$81,$AC,$02,$62,$63        ;;AC40|AC40+AC40/AC40\AC40;
                      db $71,$81,$58,$03,$11,$43,$42,$41        ;;AC48|AC48+AC48/AC48\AC48;
                      db $81,$69,$08,$20,$50,$11,$A6,$A7        ;;AC50|AC50+AC50/AC50\AC50;
                      db $B6,$B7,$A6,$A7,$81,$75,$01,$20        ;;AC58|AC58+AC58/AC58\AC58;
                      db $50,$81,$43,$03,$50,$20,$62,$63        ;;AC60|AC60+AC60/AC60\AC60;
                      db $81,$AC,$00,$71,$81,$58,$03,$71        ;;AC68|AC68+AC68/AC68\AC68;
                      db $11,$50,$20,$83,$69,$04,$50,$11        ;;AC70|AC70+AC70/AC70\AC70;
                      db $75,$B6,$B7,$81,$3F,$01,$B6,$B7        ;;AC78|AC78+AC78/AC78\AC78;
                      db $81,$75,$01,$20,$69,$81,$3E,$0C        ;;AC80|AC80+AC80/AC80\AC80;
                      db $69,$20,$42,$44,$43,$44,$43,$44        ;;AC88|AC88+AC88/AC88\AC88;
                      db $43,$42,$41,$69,$20,$82,$69,$03        ;;AC90|AC90+AC90/AC90\AC90;
                      db $50,$11,$A6,$A7,$85,$3F,$81,$75        ;;AC98|AC98+AC98/AC98\AC98;
                      db $01,$20,$69,$81,$3E,$00,$69,$82        ;;ACA0|ACA0+ACA0/ACA0\ACA0;
                      db $20,$84,$69,$00,$20,$81,$69,$00        ;;ACA8|ACA8+ACA8/ACA8\ACA8;
                      db $20,$81,$69,$04,$50,$11,$75,$B6        ;;ACB0|ACB0+ACB0/ACB0\ACB0;
                      db $B7,$85,$3F,$81,$75,$01,$20,$69        ;;ACB8|ACB8+ACB8/ACB8\ACB8;
                      db $81,$3E,$03,$69,$20,$69,$20,$83        ;;ACC0|ACC0+ACC0/ACC0\ACC0;
                      db $69,$00,$20,$82,$69,$05,$20,$41        ;;ACC8|ACC8+ACC8/ACC8\ACC8;
                      db $42,$11,$A6,$A7,$87,$3F,$81,$75        ;;ACD0|ACD0+ACD0/ACD0\ACD0;
                      db $01,$20,$69,$81,$3E,$00,$69,$81        ;;ACD8|ACD8+ACD8/ACD8\ACD8;
                      db $20,$85,$69,$04,$20,$69,$50,$43        ;;ACE0|ACE0+ACE0/ACE0\ACE0;
                      db $11,$81,$75,$01,$B6,$B7,$87,$3F        ;;ACE8|ACE8+ACE8/ACE8\ACE8;
                      db $81,$75,$01,$20,$69,$81,$3E,$03        ;;ACF0|ACF0+ACF0/ACF0\ACF0;
                      db $69,$20,$41,$20,$83,$69,$03,$20        ;;ACF8|ACF8+ACF8/ACF8\ACF8;
                      db $41,$42,$11,$83,$75,$01,$A6,$A7        ;;AD00|AD00+AD00/AD00\AD00;
                      db $87,$3F,$81,$75,$01,$20,$69,$81        ;;AD08|AD08+AD08/AD08\AD08;
                      db $3E,$02,$69,$20,$11,$85,$43,$00        ;;AD10|AD10+AD10/AD10\AD10;
                      db $11,$85,$75,$01,$B6,$B7,$87,$3F        ;;AD18|AD18+AD18/AD18\AD18;
                      db $81,$75,$01,$20,$69,$81,$3E,$08        ;;AD20|AD20+AD20/AD20\AD20;
                      db $69,$20,$03,$04,$03,$04,$03,$02        ;;AD28|AD28+AD28/AD28\AD28;
                      db $01,$87,$75,$01,$A6,$A7,$86,$3F        ;;AD30|AD30+AD30/AD30\AD30;
                      db $03,$75,$10,$20,$C2,$81,$C3,$03        ;;AD38|AD38+AD38/AD38\AD38;
                      db $C2,$20,$56,$57,$82,$71,$02,$56        ;;AD40|AD40+AD40/AD40\AD40;
                      db $57,$10,$86,$75,$03,$B6,$B7,$A6        ;;AD48|AD48+AD48/AD48\AD48;
                      db $A7,$83,$3F,$04,$A6,$75,$4D,$50        ;;AD50|AD50+AD50/AD50\AD50;
                      db $D2,$81,$D3,$03,$D2,$50,$9E,$9F        ;;AD58|AD58+AD58/AD58\AD58;
                      db $82,$71,$02,$9E,$9F,$3D,$88,$75        ;;AD60|AD60+AD60/AD60\AD60;
                      db $0A,$B6,$B7,$3F,$A6,$A7,$3F,$B6        ;;AD68|AD68+AD68/AD68\AD68;
                      db $75,$3D,$11,$20,$81,$3E,$03,$20        ;;AD70|AD70+AD70/AD70\AD70;
                      db $11,$9E,$9F,$82,$71,$02,$64,$65        ;;AD78|AD78+AD78/AD78\AD78;
                      db $4D,$8B,$75,$01,$B6,$B7,$82,$75        ;;AD80|AD80+AD80/AD80\AD80;
                      db $02,$4D,$11,$50,$81,$3E,$05,$50        ;;AD88|AD88+AD88/AD88\AD88;
                      db $11,$9E,$9F,$56,$57,$81,$71,$01        ;;AD90|AD90+AD90/AD90\AD90;
                      db $58,$3D,$90,$75,$02,$3D,$58,$11        ;;AD98|AD98+AD98/AD98\AD98;
                      db $81,$43,$06,$11,$58,$64,$65,$9E        ;;ADA0|ADA0+ADA0/ADA0\ADA0;
                      db $9F,$71,$81,$58,$00,$3D,$83,$75        ;;ADA8|ADA8+ADA8/ADA8\ADA8;
                      db $81,$60,$8A,$75,$00,$00,$81,$43        ;;ADB0|ADB0+ADB0/ADB0\ADB0;
                      db $00,$11,$83,$71,$03,$58,$64,$65        ;;ADB8|ADB8+ADB8/ADB8\ADB8;
                      db $11,$81,$43,$00,$00,$83,$75,$02        ;;ADC0|ADC0+ADC0/ADC0\ADC0;
                      db $3D,$11,$60,$83,$75,$02,$60,$03        ;;ADC8|ADC8+ADC8/ADC8\ADC8;
                      db $60,$82,$75,$81,$20,$01,$69,$3D        ;;ADD0|ADD0+ADD0/ADD0\ADD0;
                      db $86,$71,$00,$3D,$81,$69,$00,$20        ;;ADD8|ADD8+ADD8/ADD8\ADD8;
                      db $83,$75,$00,$60,$81,$11,$00,$60        ;;ADE0|ADE0+ADE0/ADE0\ADE0;
                      db $81,$75,$03,$60,$11,$A6,$A7,$81        ;;ADE8|ADE8+ADE8/ADE8\ADE8;
                      db $03,$00,$75,$81,$20,$01,$69,$00        ;;ADF0|ADF0+ADF0/ADF0\ADF0;
                      db $81,$43,$05,$44,$43,$44,$43,$44        ;;ADF8|ADF8+ADF8/ADF8\ADF8;
                      db $00,$81,$69,$00,$20,$83,$75,$03        ;;AE00|AE00+AE00/AE00\AE00;
                      db $20,$3D,$A6,$A7,$81,$03,$06,$11        ;;AE08|AE08+AE08/AE08\AE08;
                      db $A6,$A9,$B7,$A6,$A7,$11,$81,$20        ;;AE10|AE10+AE10/AE10\AE10;
                      db $00,$69,$81,$20,$84,$69,$81,$20        ;;AE18|AE18+AE18/AE18\AE18;
                      db $81,$69,$01,$20,$11,$82,$75,$03        ;;AE20|AE20+AE20/AE20\AE20;
                      db $60,$11,$B6,$B7,$82,$71,$08,$B6        ;;AE28|AE28+AE28/AE28\AE28;
                      db $A8,$A7,$B6,$A8,$11,$50,$20,$69        ;;AE30|AE30+AE30/AE30\AE30;
                      db $81,$20,$84,$69,$81,$20,$81,$69        ;;AE38|AE38+AE38/AE38\AE38;
                      db $01,$50,$11,$81,$75,$01,$60,$11        ;;AE40|AE40+AE40/AE40\AE40;
                      db $84,$71,$07,$A6,$A7,$B6,$B7,$71        ;;AE48|AE48+AE48/AE48\AE48;
                      db $B6,$75,$11,$81,$43,$81,$20,$84        ;;AE50|AE50+AE50/AE50\AE50;
                      db $69,$81,$20,$81,$43,$00,$11,$82        ;;AE58|AE58+AE58/AE58\AE58;
                      db $75,$02,$60,$11,$58,$83,$71,$02        ;;AE60|AE60+AE60/AE60\AE60;
                      db $B6,$B7,$58,$82,$71,$82,$75,$02        ;;AE68|AE68+AE68/AE68\AE68;
                      db $11,$50,$20,$84,$69,$02,$20,$50        ;;AE70|AE70+AE70/AE70\AE70;
                      db $11,$84,$75,$0C,$20,$3D,$58,$A6        ;;AE78|AE78+AE78/AE78\AE78;
                      db $A7,$A6,$A7,$A6,$A7,$A6,$A7,$A6        ;;AE80|AE80+AE80/AE80\AE80;
                      db $A7,$83,$75,$00,$11,$86,$43,$00        ;;AE88|AE88+AE88/AE88\AE88;
                      db $11,$85,$75,$0C,$60,$11,$A6,$A9        ;;AE90|AE90+AE90/AE90\AE90;
                      db $B7,$B6,$B7,$B6,$B7,$B6,$B7,$B6        ;;AE98|AE98+AE98/AE98\AE98;
                      db $B7,$92,$75,$04,$60,$11,$B6,$A8        ;;AEA0|AEA0+AEA0/AEA0\AEA0;
                      db $A7,$81,$71,$05,$A6,$A7,$A6,$A7        ;;AEA8|AEA8+AEA8/AEA8\AEA8;
                      db $A6,$A7,$8D,$75,$11,$A6,$A7,$75        ;;AEB0|AEB0+AEB0/AEB0\AEB0;
                      db $A6,$A7,$20,$60,$11,$B6,$A8,$A7        ;;AEB8|AEB8+AEB8/AEB8\AEB8;
                      db $71,$B6,$B7,$B6,$B7,$B6,$B7,$8D        ;;AEC0|AEC0+AEC0/AEC0\AEC0;
                      db $75,$04,$B6,$B7,$A6,$A9,$B7,$81        ;;AEC8|AEC8+AEC8/AEC8\AEC8;
                      db $20,$05,$60,$11,$B6,$B7,$11,$43        ;;AED0|AED0+AED0/AED0\AED0;
                      db $81,$11,$81,$43,$00,$11,$8C,$75        ;;AED8|AED8+AED8/AED8\AED8;
                      db $05,$A6,$A7,$A6,$A9,$B7,$3F,$82        ;;AEE0|AEE0+AEE0/AEE0\AEE0;
                      db $20,$00,$60,$81,$43,$01,$60,$69        ;;AEE8|AEE8+AEE8/AEE8\AEE8;
                      db $81,$3D,$81,$69,$00,$3D,$89,$75        ;;AEF0|AEF0+AEF0/AEF0\AEF0;
                      db $08,$A6,$A7,$75,$B6,$B7,$B6,$B7        ;;AEF8|AEF8+AEF8/AEF8\AEF8;
                      db $A6,$A7,$83,$20,$81,$69,$01,$20        ;;AF00|AF00+AF00/AF00\AF00;
                      db $69,$81,$60,$81,$69,$00,$60,$89        ;;AF08|AF08+AF08/AF08\AF08;
                      db $75,$01,$B6,$B7,$84,$75,$02,$B6        ;;AF10|AF10+AF10/AF10\AF10;
                      db $B7,$43,$82,$20,$81,$69,$01,$20        ;;AF18|AF18+AF18/AF18\AF18;
                      db $69,$81,$20,$81,$69,$00,$20,$86        ;;AF20|AF20+AF20/AF20\AF20;
                      db $75,$04,$10,$11,$71,$58,$6E,$82        ;;AF28|AF28+AF28/AF28\AF28;
                      db $6B,$83,$AD,$01,$8E,$99,$81,$98        ;;AF30|AF30+AF30/AF30\AF30;
                      db $00,$99,$81,$8F,$05,$99,$98,$89        ;;AF38|AF38+AF38/AF38\AF38;
                      db $58,$3D,$50,$86,$75,$03,$3D,$71        ;;AF40|AF40+AF40/AF40\AF40;
                      db $58,$71,$83,$68,$83,$AD,$01,$8E        ;;AF48|AF48+AF48/AF48\AF48;
                      db $89,$81,$98,$00,$89,$81,$AC,$05        ;;AF50|AF50+AF50/AF50\AF50;
                      db $89,$98,$99,$11,$00,$11,$86,$75        ;;AF58|AF58+AF58/AF58\AF58;
                      db $04,$4D,$58,$71,$58,$5D,$81,$68        ;;AF60|AF60+AF60/AF60\AF60;
                      db $00,$5D,$84,$89,$82,$98,$00,$99        ;;AF68|AF68+AF68/AF68\AF68;
                      db $81,$AC,$81,$99,$02,$11,$50,$20        ;;AF70|AF70+AF70/AF70\AF70;
                      db $87,$75,$03,$3D,$71,$00,$50,$81        ;;AF78|AF78+AF78/AF78\AF78;
                      db $43,$81,$71,$87,$99,$02,$71,$9B        ;;AF80|AF80+AF80/AF80\AF80;
                      db $8F,$81,$89,$02,$3D,$69,$20,$87        ;;AF88|AF88+AF88/AF88\AF88;
                      db $75,$01,$4D,$3D,$81,$50,$81,$20        ;;AF90|AF90+AF90/AF90\AF90;
                      db $02,$50,$71,$6E,$82,$6B,$83,$AD        ;;AF98|AF98+AF98/AF98\AF98;
                      db $08,$AF,$AE,$89,$98,$99,$3D,$69        ;;AFA0|AFA0+AFA0/AFA0\AFA0;
                      db $20,$11,$86,$75,$03,$00,$11,$10        ;;AFA8|AFA8+AFA8/AFA8\AFA8;
                      db $11,$81,$43,$01,$50,$3D,$83,$68        ;;AFB0|AFB0+AFB0/AFB0\AFB0;
                      db $83,$AD,$0A,$8E,$89,$98,$99,$11        ;;AFB8|AFB8+AFB8/AFB8\AFB8;
                      db $00,$69,$50,$11,$A6,$A7,$84,$75        ;;AFC0|AFC0+AFC0/AFC0\AFC0;
                      db $03,$20,$50,$11,$10,$81,$3F,$02        ;;AFC8|AFC8+AFC8/AFC8\AFC8;
                      db $11,$3D,$5D,$81,$68,$01,$5D,$58        ;;AFD0|AFD0+AFD0/AFD0\AFD0;
                      db $82,$89,$00,$98,$81,$99,$07,$71        ;;AFD8|AFD8+AFD8/AFD8\AFD8;
                      db $3A,$20,$50,$11,$75,$B6,$B7,$84        ;;AFE0|AFE0+AFE0/AFE0\AFE0;
                      db $75,$04,$20,$69,$50,$11,$03,$81        ;;AFE8|AFE8+AFE8/AFE8\AFE8;
                      db $10,$01,$58,$71,$81,$AC,$01,$58        ;;AFF0|AFF0+AFF0/AFF0\AFF0;
                      db $89,$82,$98,$00,$99,$81,$71,$03        ;;AFF8|AFF8+AFF8/AFF8\AFF8;
                      db $11,$2A,$20,$11,$81,$75,$81,$3F        ;;B000|B000+B000/B000\B000;
                      db $01,$A6,$A7,$81,$75,$01,$11,$20        ;;B008|B008+B008/B008\B008;
                      db $81,$69,$00,$50,$82,$11,$01,$71        ;;B010|B010+B010/B010\B010;
                      db $58,$81,$AC,$00,$71,$83,$99,$03        ;;B018|B018+B018/B018\B018;
                      db $71,$11,$42,$41,$81,$20,$00,$11        ;;B020|B020+B020/B020\B020;
                      db $81,$75,$81,$3F,$01,$B6,$B7,$81        ;;B028|B028+B028/B028\B028;
                      db $75,$01,$11,$50,$82,$69,$01,$41        ;;B030|B030+B030/B030\B030;
                      db $42,$89,$43,$06,$42,$41,$69,$20        ;;B038|B038+B038/B038\B038;
                      db $69,$50,$11,$81,$75,$81,$3F,$01        ;;B040|B040+B040/B040\B040;
                      db $A6,$A7,$82,$75,$01,$11,$50,$83        ;;B048|B048+B048/B048\B048;
                      db $69,$00,$20,$87,$69,$00,$20,$82        ;;B050|B050+B050/B050\B050;
                      db $69,$02,$20,$2A,$11,$82,$75,$81        ;;B058|B058+B058/B058\B058;
                      db $3F,$01,$B6,$B7,$83,$75,$00,$60        ;;B060|B060+B060/B060\B060;
                      db $83,$43,$02,$50,$69,$50,$81,$43        ;;B068|B068+B068/B068\B068;
                      db $00,$50,$83,$69,$00,$20,$81,$69        ;;B070|B070+B070/B070\B070;
                      db $01,$20,$3A,$83,$75,$02,$3F,$A6        ;;B078|B078+B078/B078\B078;
                      db $A7,$84,$75,$00,$3D,$82,$71,$03        ;;B080|B080+B080/B080\B080;
                      db $AD,$DA,$69,$DA,$81,$8A,$00,$3D        ;;B088|B088+B088/B088\B088;
                      db $82,$69,$00,$20,$82,$69,$01,$50        ;;B090|B090+B090/B090\B090;
                      db $11,$83,$75,$02,$A7,$B6,$B7,$84        ;;B098|B098+B098/B098\B098;
                      db $75,$01,$3D,$58,$81,$71,$03,$AD        ;;B0A0|B0A0+B0A0/B0A0\B0A0;
                      db $DA,$69,$DA,$81,$8A,$00,$3D,$81        ;;B0A8|B0A8+B0A8/B0A8\B0A8;
                      db $69,$07,$50,$43,$50,$41,$42,$10        ;;B0B0|B0B0+B0B0/B0B0\B0B0;
                      db $03,$10,$82,$75,$00,$B7,$81,$75        ;;B0B8|B0B8+B0B8/B0B8\B0B8;
                      db $02,$60,$03,$60,$81,$75,$07,$60        ;;B0C0|B0C0+B0C0/B0C0\B0C0;
                      db $11,$A6,$A7,$58,$3D,$43,$00,$81        ;;B0C8|B0C8+B0C8/B0C8\B0C8;
                      db $43,$00,$00,$81,$43,$07,$00,$43        ;;B0D0|B0D0+B0D0/B0D0\B0D0;
                      db $00,$11,$75,$00,$43,$00,$85,$75        ;;B0D8|B0D8+B0D8/B0D8\B0D8;
                      db $0B,$3D,$71,$11,$03,$60,$20,$3D        ;;B0E0|B0E0+B0E0/B0E0\B0E0;
                      db $B6,$B7,$11,$60,$75,$83,$20,$81        ;;B0E8|B0E8+B0E8/B0E8\B0E8;
                      db $75,$82,$20,$81,$75,$02,$20,$69        ;;B0F0|B0F0+B0F0/B0F0\B0F0;
                      db $20,$85,$75,$0B,$3D,$A6,$A7,$A6        ;;B0F8|B0F8+B0F8/B0F8\B0F8;
                      db $A7,$43,$11,$A6,$A7,$3D,$20,$75        ;;B100|B100+B100/B100\B100;
                      db $83,$20,$81,$75,$82,$20,$81,$75        ;;B108|B108+B108/B108\B108;
                      db $02,$20,$69,$20,$82,$75,$00,$60        ;;B110|B110+B110/B110\B110;
                      db $81,$03,$0B,$A6,$A9,$A8,$A9,$B7        ;;B118|B118+B118/B118\B118;
                      db $71,$58,$B6,$B7,$3D,$20,$11,$83        ;;B120|B120+B120/B120\B120;
                      db $20,$01,$11,$75,$82,$20,$05,$75        ;;B128|B128+B128/B128\B128;
                      db $11,$20,$69,$20,$11,$81,$75,$0F        ;;B130|B130+B130/B130\B130;
                      db $3D,$A6,$A7,$B6,$B7,$B6,$A8,$A7        ;;B138|B138+B138/B138\B138;
                      db $A6,$A7,$A6,$A7,$3D,$20,$11,$50        ;;B140|B140+B140/B140\B140;
                      db $81,$20,$00,$50,$81,$11,$82,$20        ;;B148|B148+B148/B148\B148;
                      db $81,$11,$03,$50,$69,$50,$11,$81        ;;B150|B150+B150/B150\B150;
                      db $75,$0F,$11,$B6,$B7,$A6,$A7,$71        ;;B158|B158+B158/B158\B158;
                      db $B6,$A8,$A9,$B7,$B6,$B7,$11,$60        ;;B160|B160+B160/B160\B160;
                      db $75,$11,$81,$43,$0A,$11,$75,$11        ;;B168|B168+B168/B168\B168;
                      db $50,$20,$50,$11,$75,$11,$43,$11        ;;B170|B170+B170/B170\B170;
                      db $82,$75,$0D,$58,$A6,$A7,$B6,$A8        ;;B178|B178+B178/B178\B178;
                      db $A7,$A6,$A9,$A8,$A7,$A6,$A7,$71        ;;B180|B180+B180/B180\B180;
                      db $11,$81,$03,$00,$60,$83,$75,$02        ;;B188|B188+B188/B188\B188;
                      db $11,$43,$11,$87,$75,$11,$A7,$B6        ;;B190|B190+B190/B190\B190;
                      db $B7,$71,$B6,$B7,$B6,$B7,$B6,$A8        ;;B198|B198+B198/B198\B198;
                      db $A9,$A8,$A7,$71,$A6,$A7,$11,$60        ;;B1A0|B1A0+B1A0/B1A0\B1A0;
                      db $8D,$75,$13,$A8,$A7,$A6,$A7,$A6        ;;B1A8|B1A8+B1A8/B1A8\B1A8;
                      db $A7,$A6,$A7,$A6,$A9,$B7,$B6,$A8        ;;B1B0|B1B0+B1B0/B1B0\B1B0;
                      db $A7,$B6,$A8,$A7,$11,$03,$60,$8B        ;;B1B8|B1B8+B1B8/B1B8\B1B8;
                      db $75,$13,$B6,$B7,$B6,$B7,$B6,$B7        ;;B1C0|B1C0+B1C0/B1C0\B1C0;
                      db $B6,$B7,$B6,$B7,$A6,$A7,$B6,$B7        ;;B1C8|B1C8+B1C8/B1C8\B1C8;
                      db $71,$B6,$A8,$A7,$11,$60,$81,$75        ;;B1D0|B1D0+B1D0/B1D0\B1D0;
                      db $01,$A6,$A7,$87,$75,$17,$A6,$A7        ;;B1D8|B1D8+B1D8/B1D8\B1D8;
                      db $A6,$A7,$A6,$A7,$A6,$A7,$A6,$A7        ;;B1E0|B1E0+B1E0/B1E0\B1E0;
                      db $B6,$B7,$A6,$A7,$71,$A6,$A9,$B7        ;;B1E8|B1E8+B1E8/B1E8\B1E8;
                      db $3D,$20,$75,$A6,$A9,$B7,$87,$75        ;;B1F0|B1F0+B1F0/B1F0\B1F0;
                      db $16,$B6,$A8,$A9,$B7,$B6,$B7,$B6        ;;B1F8|B1F8+B1F8/B1F8\B1F8;
                      db $B7,$B6,$A8,$A7,$A6,$A9,$A8,$A7        ;;B200|B200+B200/B200\B200;
                      db $B6,$A8,$A7,$11,$60,$75,$B6,$B7        ;;B208|B208+B208/B208\B208;
                      db $88,$75,$13,$A6,$A9,$B7,$A6,$A7        ;;B210|B210+B210/B210\B210;
                      db $A6,$A7,$A6,$A7,$B6,$B7,$B6,$B7        ;;B218|B218+B218/B218\B218;
                      db $B6,$B7,$A6,$A9,$B7,$11,$60,$8B        ;;B220|B220+B220/B220\B220;
                      db $75,$09,$B6,$B7,$A6,$A9,$A8,$A9        ;;B228|B228+B228/B228\B228;
                      db $A8,$A9,$B7,$11,$83,$43,$07,$11        ;;B230|B230+B230/B230\B230;
                      db $B6,$B7,$11,$60,$20,$A6,$A7,$82        ;;B238|B238+B238/B238\B238;
                      db $75,$01,$A6,$A7,$84,$75,$09,$A6        ;;B240|B240+B240/B240\B240;
                      db $A7,$B6,$B7,$B6,$B7,$B6,$B7,$58        ;;B248|B248+B248/B248\B248;
                      db $3D,$83,$69,$00,$60,$81,$11,$00        ;;B250|B250+B250/B250\B250;
                      db $60,$81,$20,$06,$B6,$A8,$A7,$A6        ;;B258|B258+B258/B258\B258;
                      db $A7,$B6,$B7,$84,$75,$01,$B6,$B7        ;;B260|B260+B260/B260\B260;
                      db $81,$43,$81,$11,$03,$43,$11,$71        ;;B268|B268+B268/B268\B268;
                      db $3D,$83,$69,$00,$20,$81,$60,$82        ;;B270|B270+B270/B270\B270;
                      db $20,$04,$3F,$B6,$A8,$A9,$B7,$86        ;;B278|B278+B278/B278\B278;
                      db $75,$01,$43,$60,$81,$69,$81,$60        ;;B280|B280+B280/B280\B280;
                      db $03,$69,$3D,$58,$3D,$83,$69,$85        ;;B288|B288+B288/B288\B288;
                      db $20,$03,$A6,$A7,$B6,$B7,$87,$75        ;;B290|B290+B290/B290\B290;
                      db $01,$69,$20,$81,$69,$81,$20,$03        ;;B298|B298+B298/B298\B298;
                      db $69,$60,$43,$60,$83,$69,$84,$20        ;;B2A0|B2A0+B2A0/B2A0\B2A0;
                      db $02,$43,$B6,$B7,$89,$75,$83,$75        ;;B2A8|B2A8+B2A8/B2A8\B2A8;
                      db $03,$20,$69,$20,$B8,$81,$B9,$06        ;;B2B0|B2B0+B2B0/B2B0\B2B0;
                      db $B8,$20,$69,$20,$75,$54,$55,$8C        ;;B2B8|B2B8+B2B8/B2B8\B2B8;
                      db $75,$81,$4F,$83,$75,$03,$20,$69        ;;B2C0|B2C0+B2C0/B2C0\B2C0;
                      db $20,$B8,$81,$B9,$06,$B8,$20,$69        ;;B2C8|B2C8+B2C8/B2C8\B2C8;
                      db $20,$04,$9E,$9F,$82,$03,$04,$05        ;;B2D0|B2D0+B2D0/B2D0\B2D0;
                      db $06,$07,$54,$55,$84,$75,$81,$4F        ;;B2D8|B2D8+B2D8/B2D8\B2D8;
                      db $81,$75,$05,$54,$55,$20,$69,$20        ;;B2E0|B2E0+B2E0/B2E0\B2E0;
                      db $B8,$81,$B9,$07,$B8,$20,$69,$20        ;;B2E8|B2E8+B2E8/B2E8\B2E8;
                      db $71,$9E,$9F,$71,$81,$AC,$04,$71        ;;B2F0|B2F0+B2F0/B2F0\B2F0;
                      db $56,$57,$9E,$9F,$84,$75,$81,$4F        ;;B2F8|B2F8+B2F8/B2F8\B2F8;
                      db $81,$75,$05,$9E,$9F,$20,$C6,$C7        ;;B300|B300+B300/B300\B300;
                      db $C8,$81,$C9,$07,$C8,$C7,$C6,$20        ;;B308|B308+B308/B308\B308;
                      db $71,$9E,$9F,$71,$81,$AC,$04,$71        ;;B310|B310+B310/B310\B310;
                      db $64,$65,$9E,$9F,$84,$75,$81,$4F        ;;B318|B318+B318/B318\B318;
                      db $81,$75,$05,$9E,$9F,$20,$D6,$D7        ;;B320|B320+B320/B320\B320;
                      db $AA,$81,$AB,$07,$AA,$D7,$D6,$20        ;;B328|B328+B328/B328\B328;
                      db $11,$9E,$67,$57,$81,$AC,$82,$71        ;;B330|B330+B330/B330\B330;
                      db $02,$64,$67,$55,$83,$75,$81,$4F        ;;B338|B338+B338/B338\B338;
                      db $07,$75,$0A,$9E,$9F,$50,$E6,$E7        ;;B340|B340+B340/B340\B340;
                      db $AA,$81,$AB,$07,$AA,$E7,$E6,$50        ;;B348|B348+B348/B348\B348;
                      db $11,$64,$9E,$9F,$81,$71,$81,$BC        ;;B350|B350+B350/B350\B350;
                      db $04,$AE,$71,$64,$65,$0A,$82,$75        ;;B358|B358+B358/B358\B358;
                      db $81,$4F,$07,$75,$1A,$64,$65,$11        ;;B360|B360+B360/B360\B360;
                      db $50,$F7,$F8,$81,$F9,$10,$F8,$F7        ;;B368|B368+B368/B368\B368;
                      db $50,$11,$71,$56,$66,$9F,$71,$53        ;;B370|B370+B370/B370\B370;
                      db $52,$71,$9B,$8F,$52,$53,$1A,$82        ;;B378|B378+B378/B378\B378;
                      db $75,$81,$4F,$02,$75,$00,$11,$81        ;;B380|B380+B380/B380\B380;
                      db $71,$02,$11,$20,$B8,$81,$B9,$0B        ;;B388|B388+B388/B388\B388;
                      db $B8,$20,$11,$56,$57,$9E,$9F,$67        ;;B390|B390+B390/B390\B390;
                      db $57,$63,$51,$52,$81,$AC,$02,$62        ;;B398|B398+B398/B398\B398;
                      db $63,$3D,$82,$75,$81,$4F,$07,$75        ;;B3A0|B3A0+B3A0/B3A0\B3A0;
                      db $20,$3D,$56,$57,$11,$20,$B8,$81        ;;B3A8|B3A8+B3A8/B3A8\B3A8;
                      db $B9,$0B,$B8,$20,$11,$9E,$67,$66        ;;B3B0|B3B0+B3B0/B3B0\B3B0;
                      db $9F,$9E,$9F,$3C,$63,$62,$81,$8A        ;;B3B8|B3B8+B3B8/B3B8\B3B8;
                      db $02,$71,$11,$00,$82,$75,$81,$4F        ;;B3C0|B3C0+B3C0/B3C0\B3C0;
                      db $07,$75,$20,$3D,$64,$65,$11,$50        ;;B3C8|B3C8+B3C8/B3C8\B3C8;
                      db $B8,$81,$B9,$02,$B8,$50,$11,$81        ;;B3D0|B3D0+B3D0/B3D0\B3D0;
                      db $9E,$06,$9F,$67,$66,$9F,$58,$52        ;;B3D8|B3D8+B3D8/B3D8\B3D8;
                      db $53,$81,$8A,$02,$11,$50,$20,$82        ;;B3E0|B3E0+B3E0/B3E0\B3E0;
                      db $75,$81,$4F,$07,$11,$20,$3D,$71        ;;B3E8|B3E8+B3E8/B3E8\B3E8;
                      db $BF,$71,$11,$43,$81,$AC,$0B,$43        ;;B3F0|B3F0+B3F0/B3F0\B3F0;
                      db $56,$57,$64,$9E,$9F,$9E,$9F,$65        ;;B3F8|B3F8+B3F8/B3F8\B3F8;
                      db $58,$62,$63,$81,$AC,$02,$11,$50        ;;B400|B400+B400/B400\B400;
                      db $20,$82,$75,$81,$4F,$11,$11,$50        ;;B408|B408+B408/B408\B408;
                      db $3D,$BD,$BA,$BD,$BF,$71,$9B,$8F        ;;B410|B410+B410/B410\B410;
                      db $58,$64,$65,$71,$64,$65,$9E,$9F        ;;B418|B418+B418/B418\B418;
                      db $81,$58,$07,$3C,$58,$9B,$8F,$58        ;;B420|B420+B420/B420\B420;
                      db $3D,$20,$11,$81,$75,$81,$4F,$08        ;;B428|B428+B428/B428\B428;
                      db $75,$11,$3D,$BF,$BD,$BF,$71,$8F        ;;B430|B430+B430/B430\B430;
                      db $9B,$81,$58,$84,$2C,$01,$9E,$9F        ;;B438|B438+B438/B438\B438;
                      db $81,$8A,$07,$AD,$AF,$AE,$58,$3C        ;;B440|B440+B440/B440\B440;
                      db $3D,$50,$11,$81,$75,$81,$4F,$81        ;;B448|B448+B448/B448\B448;
                      db $75,$09,$4D,$BA,$BF,$BD,$71,$9B        ;;B450|B450+B450/B450\B450;
                      db $8F,$58,$71,$2C,$82,$71,$02,$2C        ;;B458|B458+B458/B458\B458;
                      db $9E,$9F,$81,$8A,$06,$AD,$8E,$58        ;;B460|B460+B460/B460\B460;
                      db $3C,$58,$4D,$11,$82,$75,$81,$43        ;;B468|B468+B468/B468\B468;
                      db $81,$75,$08,$40,$42,$43,$11,$8F        ;;B470|B470+B470/B470\B470;
                      db $9B,$56,$57,$2C,$83,$71,$02,$2C        ;;B478|B478+B478/B478\B478;
                      db $9E,$9F,$81,$AC,$81,$58,$03,$43        ;;B480|B480+B480/B480\B480;
                      db $44,$42,$40,$83,$75,$81,$69,$81        ;;B488|B488+B488/B488\B488;
                      db $75,$00,$20,$81,$69,$00,$3D,$81        ;;B490|B490+B490/B490\B490;
                      db $AC,$03,$64,$65,$6E,$5D,$81,$68        ;;B498|B498+B498/B498\B498;
                      db $03,$5D,$6E,$64,$65,$81,$AC,$01        ;;B4A0|B4A0+B4A0/B4A0\B4A0;
                      db $3C,$3D,$82,$69,$00,$20,$83,$75        ;;B4A8|B4A8+B4A8/B4A8\B4A8;
                      db $81,$69,$81,$75,$00,$20,$81,$69        ;;B4B0|B4B0+B4B0/B4B0\B4B0;
                      db $00,$3D,$81,$5D,$00,$6B,$81,$6D        ;;B4B8|B4B8+B4B8/B4B8\B4B8;
                      db $83,$6B,$81,$6D,$00,$6B,$81,$5D        ;;B4C0|B4C0+B4C0/B4C0\B4C0;
                      db $01,$58,$3D,$82,$69,$00,$20,$83        ;;B4C8|B4C8+B4C8/B4C8\B4C8;
                      db $75,$81,$69,$02,$75,$11,$20,$81        ;;B4D0|B4D0+B4D0/B4D0\B4D0;
                      db $69,$00,$3D,$81,$5D,$01,$6B,$6E        ;;B4D8|B4D8+B4D8/B4D8\B4D8;
                      db $84,$2C,$02,$71,$6E,$6B,$81,$5D        ;;B4E0|B4E0+B4E0/B4E0\B4E0;
                      db $01,$71,$3D,$82,$69,$01,$20,$11        ;;B4E8|B4E8+B4E8/B4E8\B4E8;
                      db $82,$75,$81,$69,$09,$75,$11,$42        ;;B4F0|B4F0+B4F0/B4F0\B4F0;
                      db $41,$69,$00,$43,$44,$43,$44,$81        ;;B4F8|B4F8+B4F8/B4F8\B4F8;
                      db $43,$81,$44,$81,$43,$05,$44,$43        ;;B500|B500+B500/B500\B500;
                      db $44,$43,$44,$00,$81,$69,$02,$41        ;;B508|B508+B508/B508\B508;
                      db $42,$11,$82,$75,$81,$69,$82,$75        ;;B510|B510+B510/B510\B510;
                      db $01,$11,$43,$81,$20,$8C,$69,$81        ;;B518|B518+B518/B518\B518;
                      db $20,$81,$43,$00,$11,$84,$75,$81        ;;B520|B520+B520/B520\B520;
                      db $69,$84,$75,$81,$20,$8C,$69,$81        ;;B528|B528+B528/B528\B528;
                      db $20,$87,$75,$82,$69,$81,$20,$00        ;;B530|B530+B530/B530\B530;
                      db $3D,$85,$71,$04,$3D,$69,$20,$69        ;;B538|B538+B538/B538\B538;
                      db $20,$84,$69,$02,$20,$69,$20,$81        ;;B540|B540+B540/B540\B540;
                      db $69,$81,$20,$82,$69,$81,$71,$81        ;;B548|B548+B548/B548\B548;
                      db $20,$01,$69,$3D,$85,$71,$02,$3D        ;;B550|B550+B550/B550\B550;
                      db $69,$20,$81,$69,$00,$00,$83,$43        ;;B558|B558+B558/B558\B558;
                      db $02,$46,$47,$48,$81,$20,$81,$69        ;;B560|B560+B560/B560\B560;
                      db $00,$20,$81,$69,$81,$71,$81,$20        ;;B568|B568+B568/B568\B568;
                      db $02,$2A,$00,$11,$83,$71,$06,$11        ;;B570|B570+B570/B570\B570;
                      db $00,$2A,$69,$20,$2A,$11,$85,$71        ;;B578|B578+B578/B578\B578;
                      db $02,$11,$42,$41,$81,$20,$82,$69        ;;B580|B580+B580/B580\B580;
                      db $81,$71,$81,$20,$03,$3A,$20,$40        ;;B588|B588+B588/B588\B588;
                      db $42,$81,$43,$07,$42,$40,$20,$3A        ;;B590|B590+B590/B590\B590;
                      db $20,$69,$3A,$71,$81,$8A,$83,$AD        ;;B598|B598+B598/B598\B598;
                      db $04,$8E,$71,$11,$50,$20,$82,$69        ;;B5A0|B5A0+B5A0/B5A0\B5A0;
                      db $81,$71,$02,$69,$00,$11,$82,$20        ;;B5A8|B5A8+B5A8/B5A8\B5A8;
                      db $81,$69,$82,$20,$04,$3D,$20,$69        ;;B5B0|B5B0+B5B0/B5B0\B5B0;
                      db $3D,$71,$81,$8A,$83,$AD,$81,$AF        ;;B5B8|B5B8+B5B8/B5B8\B5B8;
                      db $03,$8E,$11,$50,$20,$81,$69,$81        ;;B5C0|B5C0+B5C0/B5C0\B5C0;
                      db $71,$00,$43,$81,$11,$00,$50,$81        ;;B5C8|B5C8+B5C8/B5C8\B5C8;
                      db $20,$81,$69,$81,$20,$01,$50,$3D        ;;B5D0|B5D0+B5D0/B5D0\B5D0;
                      db $81,$43,$00,$3D,$87,$71,$04,$8E        ;;B5D8|B5D8+B5D8/B5D8\B5D8;
                      db $8A,$8F,$11,$0F,$81,$69,$81,$71        ;;B5E0|B5E0+B5E0/B5E0\B5E0;
                      db $05,$A6,$A7,$3C,$11,$42,$40,$81        ;;B5E8|B5E8+B5E8/B5E8\B5E8;
                      db $69,$03,$40,$42,$11,$00,$81,$71        ;;B5F0|B5F0+B5F0/B5F0\B5F0;
                      db $01,$40,$42,$83,$43,$00,$11,$82        ;;B5F8|B5F8+B5F8/B5F8\B5F8;
                      db $71,$81,$AC,$01,$71,$1F,$81,$69        ;;B600|B600+B600/B600\B600;
                      db $81,$71,$05,$B6,$B7,$A6,$A7,$3C        ;;B608|B608+B608/B608\B608;
                      db $11,$81,$43,$81,$11,$04,$00,$20        ;;B610|B610+B610/B610\B610;
                      db $71,$11,$20,$84,$69,$03,$40,$42        ;;B618|B618+B618/B618\B618;
                      db $11,$71,$81,$8A,$01,$71,$2F,$81        ;;B620|B620+B620/B620\B620;
                      db $69,$81,$71,$04,$A6,$A7,$B6,$B7        ;;B628|B628+B628/B628\B628;
                      db $11,$82,$43,$01,$42,$40,$81,$20        ;;B630|B630+B630/B630\B630;
                      db $02,$11,$50,$20,$83,$69,$04,$20        ;;B638|B638+B638/B638\B638;
                      db $69,$20,$50,$11,$81,$8A,$01,$71        ;;B640|B640+B640/B640\B640;
                      db $11,$83,$71,$04,$B6,$B7,$3C,$11        ;;B648|B648+B648/B648\B648;
                      db $00,$83,$69,$82,$20,$02,$3D,$50        ;;B650|B650+B650/B650\B650;
                      db $20,$84,$69,$03,$20,$69,$20,$3D        ;;B658|B658+B658/B658\B658;
                      db $81,$AC,$85,$71,$81,$3C,$02,$11        ;;B660|B660+B660/B660\B660;
                      db $50,$20,$84,$69,$05,$20,$00,$3D        ;;B668|B668+B668/B668\B668;
                      db $11,$42,$41,$82,$69,$04,$20,$69        ;;B670|B670+B670/B670\B670;
                      db $20,$69,$3D,$81,$AC,$85,$71,$03        ;;B678|B678+B678/B678\B678;
                      db $4F,$3C,$4F,$3C,$81,$4F,$00,$3D        ;;B680|B680+B680/B680\B680;
                      db $96,$3F,$81,$75,$83,$4F,$81,$3C        ;;B688|B688+B688/B688\B688;
                      db $01,$11,$0A,$95,$3F,$81,$75,$81        ;;B690|B690+B690/B690\B690;
                      db $8A,$81,$AD,$81,$4F,$01,$3C,$1A        ;;B698|B698+B698/B698\B698;
                      db $95,$3F,$81,$75,$81,$8A,$81,$AD        ;;B6A0|B6A0+B6A0/B6A0\B6A0;
                      db $03,$4F,$3C,$4F,$3D,$8E,$3F,$00        ;;B6A8|B6A8+B6A8/B6A8\B6A8;
                      db $0A,$81,$03,$01,$02,$01,$81,$3F        ;;B6B0|B6B0+B6B0/B6B0\B6B0;
                      db $81,$75,$81,$AC,$81,$4F,$03,$11        ;;B6B8|B6B8+B6B8/B6B8\B6B8;
                      db $43,$42,$40,$8E,$3F,$00,$1A,$81        ;;B6C0|B6C0+B6C0/B6C0\B6C0;
                      db $4F,$01,$3C,$11,$81,$23,$81,$75        ;;B6C8|B6C8+B6C8/B6C8\B6C8;
                      db $81,$AC,$81,$4F,$00,$3A,$82,$20        ;;B6D0|B6D0+B6D0/B6D0\B6D0;
                      db $8E,$43,$04,$3D,$4F,$3C,$4F,$3C        ;;B6D8|B6D8+B6D8/B6D8\B6D8;
                      db $81,$4F,$81,$75,$82,$4F,$01,$11        ;;B6E0|B6E0+B6E0/B6E0\B6E0;
                      db $2A,$82,$20,$00,$4F,$81,$3C,$01        ;;B6E8|B6E8+B6E8/B6E8\B6E8;
                      db $4F,$3C,$87,$4F,$81,$3C,$03,$00        ;;B6F0|B6F0+B6F0/B6F0\B6F0;
                      db $11,$4F,$3C,$82,$4F,$81,$75,$81        ;;B6F8|B6F8+B6F8/B6F8\B6F8;
                      db $4F,$01,$11,$50,$81,$20,$06,$69        ;;B700|B700+B700/B700\B700;
                      db $20,$3C,$4F,$3C,$4F,$3C,$88,$4F        ;;B708|B708+B708/B708\B708;
                      db $04,$3C,$20,$40,$42,$11,$82,$4F        ;;B710|B710+B710/B710\B710;
                      db $81,$75,$81,$4F,$01,$3D,$69,$81        ;;B718|B718+B718/B718\B718;
                      db $20,$05,$69,$20,$4F,$3C,$4F,$3C        ;;B720|B720+B720/B720\B720;
                      db $81,$4F,$81,$AC,$01,$4F,$3C,$81        ;;B728|B728+B728/B728\B728;
                      db $4F,$02,$3C,$11,$43,$81,$20,$01        ;;B730|B730+B730/B730\B730;
                      db $69,$50,$82,$43,$81,$75,$81,$4F        ;;B738|B738+B738/B738\B738;
                      db $01,$3D,$69,$81,$20,$03,$69,$20        ;;B740|B740+B740/B740\B740;
                      db $3C,$4F,$81,$3C,$01,$4F,$3C,$81        ;;B748|B748+B748/B748\B748;
                      db $AC,$00,$3C,$82,$4F,$02,$11,$50        ;;B750|B750+B750/B750\B750;
                      db $69,$81,$20,$84,$69,$81,$75,$03        ;;B758|B758+B758/B758\B758;
                      db $4F,$3C,$11,$50,$81,$20,$01,$69        ;;B760|B760+B760/B760\B760;
                      db $20,$81,$8A,$83,$AD,$81,$5D,$01        ;;B768|B768+B768/B768\B768;
                      db $4F,$3C,$81,$5D,$02,$3D,$50,$43        ;;B770|B770+B770/B770\B770;
                      db $81,$20,$84,$69,$81,$75,$03,$3C        ;;B778|B778+B778/B778\B778;
                      db $4F,$3C,$3D,$81,$20,$01,$69,$20        ;;B780|B780+B780/B780\B780;
                      db $81,$8A,$83,$AD,$81,$68,$01,$3C        ;;B788|B788+B788/B788\B788;
                      db $4F,$81,$68,$00,$3D,$81,$11,$01        ;;B790|B790+B790/B790\B790;
                      db $50,$20,$84,$69,$81,$75,$07,$4F        ;;B798|B798+B798/B798\B798;
                      db $3C,$11,$00,$69,$20,$40,$42,$81        ;;B7A0|B7A0+B7A0/B7A0\B7A0;
                      db $AC,$03,$3C,$4F,$3C,$4F,$81,$5D        ;;B7A8|B7A8+B7A8/B7A8\B7A8;
                      db $81,$3C,$81,$5D,$05,$11,$10,$3F        ;;B7B0|B7B0+B7B0/B7B0\B7B0;
                      db $10,$42,$41,$83,$69,$81,$75,$81        ;;B7B8|B7B8+B7B8/B7B8\B7B8;
                      db $43,$05,$50,$20,$2A,$43,$11,$3C        ;;B7C0|B7C0+B7C0/B7C0\B7C0;
                      db $81,$AC,$00,$4F,$84,$3C,$00,$4F        ;;B7C8|B7C8+B7C8/B7C8\B7C8;
                      db $83,$3C,$05,$11,$03,$11,$3C,$4F        ;;B7D0|B7D0+B7D0/B7D0\B7D0;
                      db $50,$82,$69,$81,$75,$81,$69,$81        ;;B7D8|B7D8+B7D8/B7D8\B7D8;
                      db $20,$00,$3A,$82,$3C,$81,$8A,$83        ;;B7E0|B7E0+B7E0/B7E0\B7E0;
                      db $AD,$81,$5D,$81,$AD,$81,$8A,$81        ;;B7E8|B7E8+B7E8/B7E8\B7E8;
                      db $AD,$81,$8A,$81,$AD,$00,$8E,$82        ;;B7F0|B7F0+B7F0/B7F0\B7F0;
                      db $43,$81,$75,$07,$69,$20,$69,$20        ;;B7F8|B7F8+B7F8/B7F8\B7F8;
                      db $43,$11,$3C,$4F,$81,$8A,$83,$AD        ;;B800|B800+B800/B800\B800;
                      db $81,$68,$81,$AD,$81,$8A,$81,$AD        ;;B808|B808+B808/B808\B808;
                      db $81,$8A,$81,$AD,$81,$AF,$01,$8E        ;;B810|B810+B810/B810\B810;
                      db $4F,$81,$75,$07,$69,$20,$69,$20        ;;B818|B818+B818/B818\B818;
                      db $69,$50,$11,$3C,$82,$4F,$00,$3C        ;;B820|B820+B820/B820\B820;
                      db $81,$4F,$81,$5D,$00,$3C,$83,$4F        ;;B828|B828+B828/B828\B828;
                      db $00,$3C,$81,$4F,$81,$3C,$03,$4F        ;;B830|B830+B830/B830\B830;
                      db $8E,$AF,$4F,$81,$75,$81,$69,$81        ;;B838|B838+B838/B838\B838;
                      db $20,$00,$43,$81,$50,$01,$43,$11        ;;B840|B840+B840/B840\B840;
                      db $81,$60,$82,$3C,$03,$4F,$3C,$4F        ;;B848|B848+B848/B848\B848;
                      db $3C,$81,$60,$81,$3C,$81,$60,$00        ;;B850|B850+B850/B850\B850;
                      db $3C,$81,$60,$82,$3C,$81,$75,$08        ;;B858|B858+B858/B858\B858;
                      db $69,$20,$69,$20,$3F,$11,$50,$69        ;;B860|B860+B860/B860\B860;
                      db $60,$81,$11,$00,$60,$81,$3C,$00        ;;B868|B868+B868/B868\B868;
                      db $60,$82,$23,$81,$11,$81,$23,$81        ;;B870|B870+B870/B870\B870;
                      db $11,$02,$23,$11,$3D,$82,$3C,$81        ;;B878|B878+B878/B878\B878;
                      db $75,$81,$69,$81,$20,$04,$11,$3F        ;;B880|B880+B880/B880\B880;
                      db $11,$60,$11,$81,$4F,$00,$11,$81        ;;B888|B888+B888/B888\B888;
                      db $23,$00,$11,$8A,$4F,$00,$11,$82        ;;B890|B890+B890/B890\B890;
                      db $23,$81,$75,$07,$69,$20,$69,$50        ;;B898|B898+B898/B898\B898;
                      db $11,$3F,$60,$11,$95,$4F,$81,$75        ;;B8A0|B8A0+B8A0/B8A0\B8A0;
                      db $9D,$71,$81,$69,$9D,$71,$81,$69        ;;B8A8|B8A8+B8A8/B8A8\B8A8;
                      db $9D,$71,$81,$69,$9D,$71,$81,$69        ;;B8B0|B8B0+B8B0/B8B0\B8B0;
                      db $9D,$71,$81,$69,$82,$71,$00,$7C        ;;B8B8|B8B8+B8B8/B8B8\B8B8;
                      db $81,$71,$81,$7C,$81,$71,$82,$7C        ;;B8C0|B8C0+B8C0/B8C0\B8C0;
                      db $81,$71,$00,$7C,$81,$71,$00,$7C        ;;B8C8|B8C8+B8C8/B8C8\B8C8;
                      db $81,$71,$00,$7C,$81,$71,$00,$7C        ;;B8D0|B8D0+B8D0/B8D0\B8D0;
                      db $84,$71,$81,$43,$81,$71,$08,$7C        ;;B8D8|B8D8+B8D8/B8D8\B8D8;
                      db $71,$7C,$71,$7C,$71,$7C,$71,$7C        ;;B8E0|B8E0+B8E0/B8E0\B8E0;
                      db $82,$71,$0A,$7C,$71,$7C,$71,$7C        ;;B8E8|B8E8+B8E8/B8E8\B8E8;
                      db $71,$7C,$71,$7C,$71,$7C,$88,$71        ;;B8F0|B8F0+B8F0/B8F0\B8F0;
                      db $00,$7C,$82,$71,$04,$7C,$71,$7C        ;;B8F8|B8F8+B8F8/B8F8\B8F8;
                      db $71,$7C,$82,$71,$00,$7C,$82,$71        ;;B900|B900+B900/B900\B900;
                      db $06,$7C,$71,$7C,$71,$7C,$71,$7C        ;;B908|B908+B908/B908\B908;
                      db $89,$71,$00,$7C,$81,$71,$03,$7C        ;;B910|B910+B910/B910\B910;
                      db $71,$7C,$71,$82,$7C,$01,$71,$7C        ;;B918|B918+B918/B918\B918;
                      db $82,$71,$01,$7C,$71,$82,$7C,$01        ;;B920|B920+B920/B920\B920;
                      db $71,$7C,$8A,$71,$01,$7C,$71,$81        ;;B928|B928+B928/B928\B928;
                      db $7C,$81,$71,$00,$7C,$82,$71,$00        ;;B930|B930+B930/B930\B930;
                      db $7C,$82,$71,$06,$7C,$71,$7C,$71        ;;B938|B938+B938/B938\B938;
                      db $7C,$71,$7C,$88,$71,$04,$7C,$71        ;;B940|B940+B940/B940\B940;
                      db $7C,$71,$7C,$82,$71,$00,$7C,$82        ;;B948|B948+B948/B948\B948;
                      db $71,$0A,$7C,$71,$7C,$71,$7C,$71        ;;B950|B950+B950/B950\B950;
                      db $7C,$71,$7C,$71,$7C,$86,$71,$81        ;;B958|B958+B958/B958\B958;
                      db $43,$02,$00,$69,$20,$83,$69,$06        ;;B960|B960+B960/B960\B960;
                      db $20,$50,$11,$71,$02,$01,$11,$83        ;;B968|B968+B968/B968\B968;
                      db $43,$03,$42,$41,$20,$3D,$81,$8A        ;;B970|B970+B970/B970\B970;
                      db $85,$71,$82,$69,$81,$20,$82,$69        ;;B978|B978+B978/B978\B978;
                      db $06,$41,$42,$A6,$A7,$A6,$A7,$3D        ;;B980|B980+B980/B980\B980;
                      db $85,$3F,$02,$11,$50,$3D,$81,$8A        ;;B988|B988+B988/B988\B988;
                      db $85,$71,$81,$43,$02,$60,$20,$50        ;;B990|B990+B990/B990\B990;
                      db $82,$43,$07,$11,$A6,$A9,$B7,$B6        ;;B998|B998+B998/B998\B998;
                      db $B7,$00,$11,$85,$3F,$01,$60,$11        ;;B9A0|B9A0+B9A0/B9A0\B9A0;
                      db $81,$AC,$87,$71,$04,$11,$60,$11        ;;B9A8|B9A8+B9A8/B9A8\B9A8;
                      db $A6,$A7,$81,$71,$01,$B6,$B7,$81        ;;B9B0|B9B0+B9B0/B9B0\B9B0;
                      db $71,$02,$3D,$50,$11,$85,$3F,$01        ;;B9B8|B9B8+B9B8/B9B8\B9B8;
                      db $3D,$71,$81,$AC,$88,$71,$06,$11        ;;B9C0|B9C0+B9C0/B9C0\B9C0;
                      db $60,$B6,$B7,$A6,$A7,$71,$81,$8A        ;;B9C8|B9C8+B9C8/B9C8\B9C8;
                      db $02,$AD,$3D,$11,$85,$3F,$02,$10        ;;B9D0|B9D0+B9D0/B9D0\B9D0;
                      db $3D,$71,$81,$AC,$89,$71,$05,$11        ;;B9D8|B9D8+B9D8/B9D8\B9D8;
                      db $60,$71,$B6,$B7,$71,$81,$8A,$01        ;;B9E0|B9E0+B9E0/B9E0\B9E0;
                      db $AD,$3D,$84,$3F,$04,$10,$03,$11        ;;B9E8|B9E8+B9E8/B9E8\B9E8;
                      db $3D,$5D,$81,$68,$00,$5D,$86,$71        ;;B9F0|B9F0+B9F0/B9F0\B9F0;
                      db $00,$3C,$81,$71,$01,$3D,$71,$81        ;;B9F8|B9F8+B9F8/B9F8\B9F8;
                      db $60,$00,$71,$81,$AC,$02,$71,$11        ;;BA00|BA00+BA00/BA00\BA00;
                      db $10,$83,$3F,$00,$3D,$81,$71,$01        ;;BA08|BA08+BA08/BA08\BA08;
                      db $3D,$5D,$81,$68,$00,$5D,$85,$71        ;;BA10|BA10+BA10/BA10\BA10;
                      db $05,$3C,$71,$3C,$71,$11,$43,$81        ;;BA18|BA18+BA18/BA18\BA18;
                      db $11,$00,$60,$81,$AC,$00,$71,$81        ;;BA20|BA20+BA20/BA20\BA20;
                      db $60,$00,$10,$81,$3F,$00,$60,$82        ;;BA28|BA28+BA28/BA28\BA28;
                      db $43,$03,$11,$71,$9B,$8F,$87,$71        ;;BA30|BA30+BA30/BA30\BA30;
                      db $00,$3C,$85,$71,$00,$11,$82,$43        ;;BA38|BA38+BA38/BA38\BA38;
                      db $81,$11,$00,$43,$81,$03,$00,$11        ;;BA40|BA40+BA40/BA40\BA40;
                      db $81,$71,$81,$AD,$01,$AF,$AE,$9B        ;;BA48|BA48+BA48/BA48\BA48;
                      db $71,$81,$AD,$00,$8E,$87,$71,$00        ;;BA50|BA50+BA50/BA50\BA50;
                      db $87,$81,$88,$00,$97,$81,$86,$81        ;;BA58|BA58+BA58/BA58\BA58;
                      db $85,$81,$86,$02,$85,$71,$85,$81        ;;BA60|BA60+BA60/BA60\BA60;
                      db $86,$00,$85,$81,$89,$00,$87,$81        ;;BA68|BA68+BA68/BA68\BA68;
                      db $88,$01,$87,$85,$81,$86,$00,$85        ;;BA70|BA70+BA70/BA70\BA70;
                      db $81,$89,$81,$71,$81,$BB,$03,$58        ;;BA78|BA78+BA78/BA78\BA78;
                      db $71,$58,$95,$81,$96,$81,$95,$81        ;;BA80|BA80+BA80/BA80\BA80;
                      db $96,$02,$95,$71,$95,$81,$96,$00        ;;BA88|BA88+BA88/BA88\BA88;
                      db $95,$81,$99,$00,$85,$81,$86,$01        ;;BA90|BA90+BA90/BA90\BA90;
                      db $85,$95,$81,$96,$00,$95,$81,$99        ;;BA98|BA98+BA98/BA98\BA98;
                      db $81,$71,$81,$BB,$00,$85,$81,$86        ;;BAA0|BAA0+BAA0/BAA0\BAA0;
                      db $00,$97,$81,$88,$81,$87,$81,$88        ;;BAA8|BAA8+BAA8/BAA8\BAA8;
                      db $02,$87,$58,$87,$81,$88,$00,$87        ;;BAB0|BAB0+BAB0/BAB0\BAB0;
                      db $81,$89,$00,$95,$81,$96,$01,$95        ;;BAB8|BAB8+BAB8/BAB8\BAB8;
                      db $87,$81,$88,$00,$97,$81,$86,$01        ;;BAC0|BAC0+BAC0/BAC0\BAC0;
                      db $85,$71,$81,$BB,$00,$95,$81,$96        ;;BAC8|BAC8+BAC8/BAC8\BAC8;
                      db $01,$95,$58,$81,$71,$00,$58,$81        ;;BAD0|BAD0+BAD0/BAD0\BAD0;
                      db $89,$85,$71,$81,$99,$00,$87,$81        ;;BAD8|BAD8+BAD8/BAD8\BAD8;
                      db $88,$04,$87,$71,$58,$71,$95,$81        ;;BAE0|BAE0+BAE0/BAE0\BAE0;
                      db $96,$01,$95,$71,$81,$BB,$00,$87        ;;BAE8|BAE8+BAE8/BAE8\BAE8;
                      db $81,$88,$01,$87,$85,$81,$86,$00        ;;BAF0|BAF0+BAF0/BAF0\BAF0;
                      db $85,$81,$99,$81,$71,$83,$89,$81        ;;BAF8|BAF8+BAF8/BAF8\BAF8;
                      db $5D,$81,$89,$81,$71,$00,$85,$81        ;;BB00|BB00+BB00/BB00\BB00;
                      db $86,$00,$97,$81,$88,$01,$97,$71        ;;BB08|BB08+BB08/BB08\BB08;
                      db $81,$BB,$00,$85,$81,$86,$01,$85        ;;BB10|BB10+BB10/BB10\BB10;
                      db $95,$81,$96,$00,$95,$83,$71,$83        ;;BB18|BB18+BB18/BB18\BB18;
                      db $99,$81,$5D,$81,$99,$81,$89,$00        ;;BB20|BB20+BB20/BB20\BB20;
                      db $95,$81,$96,$00,$95,$81,$58,$81        ;;BB28|BB28+BB28/BB28\BB28;
                      db $71,$81,$BB,$00,$95,$81,$96,$01        ;;BB30|BB30+BB30/BB30\BB30;
                      db $95,$87,$81,$88,$00,$87,$81,$71        ;;BB38|BB38+BB38/BB38\BB38;
                      db $83,$89,$02,$58,$71,$58,$82,$71        ;;BB40|BB40+BB40/BB40\BB40;
                      db $81,$99,$00,$87,$81,$88,$01,$87        ;;BB48|BB48+BB48/BB48\BB48;
                      db $85,$81,$86,$00,$71,$81,$BB,$00        ;;BB50|BB50+BB50/BB50\BB50;
                      db $87,$81,$88,$01,$87,$85,$81,$86        ;;BB58|BB58+BB58/BB58\BB58;
                      db $00,$85,$81,$71,$83,$99,$00,$85        ;;BB60|BB60+BB60/BB60\BB60;
                      db $81,$86,$00,$85,$83,$89,$00,$85        ;;BB68|BB68+BB68/BB68\BB68;
                      db $81,$86,$01,$85,$95,$81,$96,$00        ;;BB70|BB70+BB70/BB70\BB70;
                      db $71,$81,$BB,$00,$85,$81,$86,$01        ;;BB78|BB78+BB78/BB78\BB78;
                      db $85,$95,$81,$96,$00,$95,$81,$71        ;;BB80|BB80+BB80/BB80\BB80;
                      db $83,$89,$00,$95,$81,$96,$00,$95        ;;BB88|BB88+BB88/BB88\BB88;
                      db $83,$99,$00,$95,$81,$96,$01,$95        ;;BB90|BB90+BB90/BB90\BB90;
                      db $87,$81,$88,$00,$71,$81,$BB,$00        ;;BB98|BB98+BB98/BB98\BB98;
                      db $95,$81,$96,$01,$95,$87,$81,$88        ;;BBA0|BBA0+BBA0/BBA0\BBA0;
                      db $00,$87,$81,$71,$83,$99,$00,$87        ;;BBA8|BBA8+BBA8/BBA8\BBA8;
                      db $81,$88,$01,$87,$58,$82,$71,$00        ;;BBB0|BBB0+BBB0/BBB0\BBB0;
                      db $87,$81,$88,$00,$87,$83,$71,$81        ;;BBB8|BBB8+BBB8/BBB8\BBB8;
                      db $BB,$00,$87,$81,$88,$00,$97,$81        ;;BBC0|BBC0+BBC0/BBC0\BBC0;
                      db $86,$01,$85,$71,$81,$89,$81,$71        ;;BBC8|BBC8+BBC8/BBC8\BBC8;
                      db $83,$89,$00,$71,$81,$89,$00,$71        ;;BBD0|BBD0+BBD0/BBD0\BBD0;
                      db $81,$2B,$85,$89,$81,$71,$81,$BB        ;;BBD8|BBD8+BBD8/BBD8\BBD8;
                      db $00,$71,$81,$58,$00,$95,$81,$96        ;;BBE0|BBE0+BBE0/BBE0\BBE0;
                      db $01,$95,$71,$81,$99,$81,$71,$83        ;;BBE8|BBE8+BBE8/BBE8\BBE8;
                      db $99,$00,$58,$81,$99,$00,$58,$81        ;;BBF0|BBF0+BBF0/BBF0\BBF0;
                      db $2B,$85,$99,$81,$71,$81,$E8,$00        ;;BBF8|BBF8+BBF8/BBF8\BBF8;
                      db $85,$81,$86,$00,$97,$81,$88,$00        ;;BC00|BC00+BC00/BC00\BC00;
                      db $87,$82,$71,$81,$89,$82,$71,$81        ;;BC08|BC08+BC08/BC08\BC08;
                      db $89,$00,$71,$81,$89,$81,$71,$81        ;;BC10|BC10+BC10/BC10\BC10;
                      db $89,$00,$85,$81,$86,$00,$85,$81        ;;BC18|BC18+BC18/BC18\BC18;
                      db $71,$81,$3F,$00,$95,$81,$96,$00        ;;BC20|BC20+BC20/BC20\BC20;
                      db $95,$81,$89,$83,$71,$81,$99,$00        ;;BC28|BC28+BC28/BC28\BC28;
                      db $71,$81,$89,$81,$99,$00,$71,$81        ;;BC30|BC30+BC30/BC30\BC30;
                      db $99,$81,$71,$81,$99,$00,$95,$81        ;;BC38|BC38+BC38/BC38\BC38;
                      db $96,$00,$95,$81,$71,$81,$3F,$00        ;;BC40|BC40+BC40/BC40\BC40;
                      db $87,$81,$88,$00,$87,$81,$99,$83        ;;BC48|BC48+BC48/BC48\BC48;
                      db $89,$02,$58,$71,$58,$81,$99,$00        ;;BC50|BC50+BC50/BC50\BC50;
                      db $71,$81,$89,$00,$71,$81,$89,$00        ;;BC58|BC58+BC58/BC58\BC58;
                      db $85,$81,$86,$00,$97,$81,$88,$00        ;;BC60|BC60+BC60/BC60\BC60;
                      db $87,$81,$71,$81,$D8,$81,$89,$00        ;;BC68|BC68+BC68/BC68\BC68;
                      db $85,$81,$86,$00,$85,$83,$99,$00        ;;BC70|BC70+BC70/BC70\BC70;
                      db $85,$81,$86,$00,$85,$81,$71,$81        ;;BC78|BC78+BC78/BC78\BC78;
                      db $99,$00,$71,$81,$99,$00,$95,$81        ;;BC80|BC80+BC80/BC80\BC80;
                      db $96,$01,$95,$71,$81,$89,$81,$71        ;;BC88|BC88+BC88/BC88\BC88;
                      db $81,$3F,$81,$99,$00,$95,$81,$96        ;;BC90|BC90+BC90/BC90\BC90;
                      db $00,$95,$83,$89,$00,$95,$81,$96        ;;BC98|BC98+BC98/BC98\BC98;
                      db $00,$95,$83,$89,$00,$85,$81,$86        ;;BCA0|BCA0+BCA0/BCA0\BCA0;
                      db $00,$97,$81,$88,$01,$87,$58,$81        ;;BCA8|BCA8+BCA8/BCA8\BCA8;
                      db $99,$81,$71,$81,$3F,$81,$71,$00        ;;BCB0|BCB0+BCB0/BCB0\BCB0;
                      db $87,$81,$88,$00,$87,$83,$99,$00        ;;BCB8|BCB8+BCB8/BCB8\BCB8;
                      db $87,$81,$88,$00,$87,$83,$99,$00        ;;BCC0|BCC0+BCC0/BCC0\BCC0;
                      db $95,$81,$96,$00,$95,$81,$89,$00        ;;BCC8|BCC8+BCC8/BCC8\BCC8;
                      db $85,$81,$86,$00,$85,$81,$71,$81        ;;BCD0|BCD0+BCD0/BCD0\BCD0;
                      db $3F,$00,$71,$81,$89,$01,$71,$58        ;;BCD8|BCD8+BCD8/BCD8\BCD8;
                      db $83,$89,$00,$71,$81,$89,$00,$85        ;;BCE0|BCE0+BCE0/BCE0\BCE0;
                      db $81,$86,$00,$85,$81,$58,$00,$87        ;;BCE8|BCE8+BCE8/BCE8\BCE8;
                      db $81,$88,$00,$87,$81,$99,$00,$95        ;;BCF0|BCF0+BCF0/BCF0\BCF0;
                      db $81,$96,$00,$95,$81,$71,$81,$D9        ;;BCF8|BCF8+BCF8/BCF8\BCF8;
                      db $00,$71,$81,$99,$01,$58,$71,$83        ;;BD00|BD00+BD00/BD00\BD00;
                      db $99,$00,$58,$81,$99,$00,$95,$81        ;;BD08|BD08+BD08/BD08\BD08;
                      db $96,$00,$95,$81,$89,$00,$85,$81        ;;BD10|BD10+BD10/BD10\BD10;
                      db $86,$00,$85,$81,$89,$00,$87,$81        ;;BD18|BD18+BD18/BD18\BD18;
                      db $88,$00,$87,$81,$71,$81,$D8,$01        ;;BD20|BD20+BD20/BD20\BD20;
                      db $71,$85,$81,$86,$03,$85,$71,$58        ;;BD28|BD28+BD28/BD28\BD28;
                      db $85,$81,$86,$02,$85,$71,$87,$81        ;;BD30|BD30+BD30/BD30\BD30;
                      db $88,$00,$87,$81,$99,$00,$95,$81        ;;BD38|BD38+BD38/BD38\BD38;
                      db $96,$00,$95,$81,$99,$85,$71,$81        ;;BD40|BD40+BD40/BD40\BD40;
                      db $3F,$83,$75,$03,$20,$69,$20,$B8        ;;BD48|BD48+BD48/BD48\BD48;
                      db $81,$B9,$03,$B8,$20,$69,$20,$8F        ;;BD50|BD50+BD50/BD50\BD50;
                      db $75,$81,$4F,$82,$71,$00,$7C,$81        ;;BD58|BD58+BD58/BD58\BD58;
                      db $71,$00,$7C,$82,$71,$82,$7C,$81        ;;BD60|BD60+BD60/BD60\BD60;
                      db $71,$00,$7C,$81,$71,$05,$7C,$71        ;;BD68|BD68+BD68/BD68\BD68;
                      db $7C,$71,$7C,$71,$82,$7C,$82,$71        ;;BD70|BD70+BD70/BD70\BD70;
                      db $81,$43,$9D,$71,$81,$69,$85,$71        ;;BD78|BD78+BD78/BD78\BD78;
                      db $81,$7B,$83,$71,$81,$7B,$83,$71        ;;BD80|BD80+BD80/BD80\BD80;
                      db $81,$7B,$83,$71,$81,$7B,$83,$71        ;;BD88|BD88+BD88/BD88\BD88;
                      db $81,$43,$85,$71,$81,$7B,$83,$71        ;;BD90|BD90+BD90/BD90\BD90;
                      db $81,$7B,$83,$71,$81,$7B,$83,$71        ;;BD98|BD98+BD98/BD98\BD98;
                      db $81,$7B,$C7,$71,$81,$5D,$81,$6B        ;;BDA0|BDA0+BDA0/BDA0\BDA0;
                      db $81,$5D,$83,$71,$81,$7B,$83,$71        ;;BDA8|BDA8+BDA8/BDA8\BDA8;
                      db $81,$7B,$83,$71,$81,$7B,$87,$71        ;;BDB0|BDB0+BDB0/BDB0\BDB0;
                      db $81,$5D,$81,$6B,$81,$5D,$83,$71        ;;BDB8|BDB8+BDB8/BDB8\BDB8;
                      db $81,$7B,$83,$71,$81,$7B,$83,$71        ;;BDC0|BDC0+BDC0/BDC0\BDC0;
                      db $81,$7B,$C5,$71,$83,$BB,$00,$7C        ;;BDC8|BDC8+BDC8/BDC8\BDC8;
                      db $88,$BB,$81,$10,$81,$BB,$81,$7B        ;;BDD0|BDD0+BDD0/BDD0\BDD0;
                      db $89,$BB,$81,$71,$81,$BB,$01,$B0        ;;BDD8|BDD8+BDD8/BDD8\BDD8;
                      db $B1,$86,$BB,$02,$7C,$BB,$10,$81        ;;BDE0|BDE0+BDE0/BDE0\BDE0;
                      db $11,$01,$10,$BB,$81,$7B,$82,$BB        ;;BDE8|BDE8+BDE8/BDE8\BDE8;
                      db $00,$7C,$85,$BB,$81,$71,$03,$BB        ;;BDF0|BDF0+BDF0/BDF0\BDF0;
                      db $E0,$C0,$C1,$82,$BB,$81,$7B,$82        ;;BDF8|BDF8+BDF8/BDF8\BDF8;
                      db $BB,$01,$10,$11,$81,$5D,$01,$11        ;;BE00|BE00+BE00/BE00\BE00;
                      db $10,$8B,$BB,$81,$71,$03,$BB,$E1        ;;BE08|BE08+BE08/BE08\BE08;
                      db $D0,$D1,$82,$BB,$81,$7B,$82,$BB        ;;BE10|BE10+BE10/BE10\BE10;
                      db $08,$3D,$4F,$5D,$68,$4F,$11,$10        ;;BE18|BE18+BE18/BE18\BE18;
                      db $BB,$7C,$83,$BB,$81,$7B,$82,$BB        ;;BE20|BE20+BE20/BE20\BE20;
                      db $81,$71,$8A,$BB,$00,$10,$82,$4F        ;;BE28|BE28+BE28/BE28\BE28;
                      db $81,$6C,$01,$4F,$3D,$85,$BB,$81        ;;BE30|BE30+BE30/BE30\BE30;
                      db $7B,$82,$BB,$81,$71,$82,$BB,$00        ;;BE38|BE38+BE38/BE38\BE38;
                      db $10,$86,$03,$84,$4F,$81,$6C,$04        ;;BE40|BE40+BE40/BE40\BE40;
                      db $11,$03,$04,$03,$04,$82,$03,$00        ;;BE48|BE48+BE48/BE48\BE48;
                      db $10,$82,$BB,$81,$71,$81,$7B,$01        ;;BE50|BE50+BE50/BE50\BE50;
                      db $BB,$3D,$81,$5D,$83,$6B,$81,$5D        ;;BE58|BE58+BE58/BE58\BE58;
                      db $84,$4F,$02,$6C,$68,$5D,$83,$4F        ;;BE60|BE60+BE60/BE60\BE60;
                      db $81,$5D,$00,$3D,$82,$BB,$81,$71        ;;BE68|BE68+BE68/BE68\BE68;
                      db $81,$7B,$01,$BB,$3D,$81,$5D,$83        ;;BE70|BE70+BE70/BE70\BE70;
                      db $6B,$81,$5D,$05,$4F,$12,$13,$14        ;;BE78|BE78+BE78/BE78\BE78;
                      db $15,$4F,$81,$5D,$83,$4F,$02,$68        ;;BE80|BE80+BE80/BE80\BE80;
                      db $5D,$3D,$82,$BB,$81,$71,$82,$BB        ;;BE88|BE88+BE88/BE88\BE88;
                      db $00,$00,$87,$4F,$05,$58,$31,$32        ;;BE90|BE90+BE90/BE90\BE90;
                      db $33,$34,$58,$84,$4F,$81,$6C,$01        ;;BE98|BE98+BE98/BE98\BE98;
                      db $11,$00,$82,$BB,$81,$71,$04,$BB        ;;BEA0|BEA0+BEA0/BEA0\BEA0;
                      db $7C,$BB,$20,$50,$85,$4F,$07,$58        ;;BEA8|BEA8+BEA8/BEA8\BEA8;
                      db $4F,$35,$36,$37,$38,$4F,$58,$82        ;;BEB0|BEB0+BEB0/BEB0\BEB0;
                      db $4F,$81,$6C,$02,$11,$50,$20,$82        ;;BEB8|BEB8+BEB8/BEB8\BEB8;
                      db $BB,$81,$71,$82,$BB,$02,$20,$69        ;;BEC0|BEC0+BEC0/BEC0\BEC0;
                      db $00,$81,$4F,$81,$5D,$10,$4F,$58        ;;BEC8|BEC8+BEC8/BEC8\BEC8;
                      db $4F,$35,$36,$37,$38,$4F,$58,$4F        ;;BED0|BED0+BED0/BED0\BED0;
                      db $5D,$68,$6C,$11,$00,$69,$20,$82        ;;BED8|BED8+BED8/BED8\BED8;
                      db $BB,$81,$71,$02,$E8,$E9,$E8,$81        ;;BEE0|BEE0+BEE0/BEE0\BEE0;
                      db $20,$04,$69,$50,$4F,$68,$5D,$81        ;;BEE8|BEE8+BEE8/BEE8\BEE8;
                      db $4F,$05,$58,$49,$4A,$59,$5A,$58        ;;BEF0|BEF0+BEF0/BEF0\BEF0;
                      db $81,$4F,$81,$5D,$02,$4F,$3D,$69        ;;BEF8|BEF8+BEF8/BEF8\BEF8;
                      db $81,$20,$82,$E8,$81,$71,$82,$3F        ;;BF00|BF00+BF00/BF00\BF00;
                      db $05,$20,$69,$20,$50,$4F,$68,$84        ;;BF08|BF08+BF08/BF08\BF08;
                      db $4F,$81,$5D,$86,$4F,$03,$3D,$20        ;;BF10|BF10+BF10/BF10\BF10;
                      db $69,$20,$82,$D8,$81,$71,$81,$3F        ;;BF18|BF18+BF18/BF18\BF18;
                      db $04,$D8,$20,$69,$00,$11,$81,$6C        ;;BF20|BF20+BF20/BF20\BF20;
                      db $84,$4F,$03,$5D,$68,$6D,$6E,$84        ;;BF28|BF28+BF28/BF28\BF28;
                      db $4F,$03,$11,$00,$69,$20,$82,$3F        ;;BF30|BF30+BF30/BF30\BF30;
                      db $81,$71,$05,$D8,$D9,$3F,$20,$50        ;;BF38|BF38+BF38/BF38\BF38;
                      db $11,$81,$6C,$85,$4F,$81,$11,$00        ;;BF40|BF40+BF40/BF40\BF40;
                      db $6E,$81,$6D,$00,$6E,$83,$4F,$02        ;;BF48|BF48+BF48/BF48\BF48;
                      db $11,$50,$20,$82,$D9,$81,$71,$04        ;;BF50|BF50+BF50/BF50\BF50;
                      db $3F,$D8,$D9,$00,$11,$81,$6C,$85        ;;BF58|BF58+BF58/BF58\BF58;
                      db $4F,$05,$11,$00,$50,$43,$11,$6E        ;;BF60|BF60+BF60/BF60\BF60;
                      db $81,$6D,$00,$6E,$83,$4F,$00,$00        ;;BF68|BF68+BF68/BF68\BF68;
                      db $82,$3F,$81,$71,$81,$3F,$03,$10        ;;BF70|BF70+BF70/BF70\BF70;
                      db $11,$5D,$68,$84,$4F,$09,$11,$43        ;;BF78|BF78+BF78/BF78\BF78;
                      db $50,$69,$20,$69,$50,$11,$4F,$6E        ;;BF80|BF80+BF80/BF80\BF80;
                      db $81,$6D,$00,$6E,$81,$5D,$01,$4F        ;;BF88|BF88+BF88/BF88\BF88;
                      db $10,$81,$3F,$81,$71,$81,$3F,$01        ;;BF90|BF90+BF90/BF90\BF90;
                      db $3D,$4F,$81,$5D,$81,$4F,$00,$11        ;;BF98|BF98+BF98/BF98\BF98;
                      db $81,$43,$00,$00,$82,$69,$00,$20        ;;BFA0|BFA0+BFA0/BFA0\BFA0;
                      db $81,$69,$01,$00,$18,$81,$4F,$05        ;;BFA8|BFA8+BFA8/BFA8\BFA8;
                      db $6E,$6D,$68,$5D,$4F,$3D,$81,$3F        ;;BFB0|BFB0+BFB0/BFB0\BFB0;
                      db $81,$71,$02,$D9,$3F,$3D,$82,$4F        ;;BFB8|BFB8+BFB8/BFB8\BFB8;
                      db $02,$11,$43,$50,$82,$69,$00,$20        ;;BFC0|BFC0+BFC0/BFC0\BFC0;
                      db $81,$69,$08,$20,$69,$20,$69,$48        ;;BFC8|BFC8+BFC8/BFC8\BFC8;
                      db $47,$46,$45,$11,$82,$4F,$00,$00        ;;BFD0|BFD0+BFD0/BFD0\BFD0;
                      db $81,$3F,$81,$71,$03,$D8,$D9,$40        ;;BFD8|BFD8+BFD8/BFD8\BFD8;
                      db $42,$81,$43,$02,$50,$69,$20,$82        ;;BFE0|BFE0+BFE0/BFE0\BFE0;
                      db $69,$02,$20,$69,$20,$82,$69,$00        ;;BFE8|BFE8+BFE8/BFE8\BFE8;
                      db $20,$83,$69,$00,$00,$81,$43,$01        ;;BFF0|BFF0+BFF0/BFF0\BFF0;
                      db $50,$20,$81,$3F,$81,$71,$81,$3F        ;;BFF8|BFF8+BFF8/BFF8\BFF8;
                      db $02,$20,$69,$20,$81,$69,$00,$20        ;;C000|C000+C000/C000\C000;
                      db $83,$69,$00,$20,$81,$69,$02,$20        ;;C008|C008+C008/C008\C008;
                      db $69,$20,$84,$69,$04,$20,$69,$20        ;;C010|C010+C010/C010\C010;
                      db $69,$20,$81,$3F,$81,$71,$03,$4F        ;;C018|C018+C018/C018\C018;
                      db $3C,$4F,$3C,$81,$4F,$00,$3D,$96        ;;C020|C020+C020/C020\C020;
                      db $3F,$81,$75                            ;;C028|C028+C028/C028\C028;
                                                                ;;                        ;
OWTilemap:            db $9B,$1C,$03,$58,$18                    ;;C02B|C02B+C02B/C02B\C02B;
                      db $1C,$58,$9B,$1C,$03,$58,$18,$1C        ;;C030|C030+C030/C030\C030;
                      db $58,$9A,$1C,$04,$10,$58,$18,$1C        ;;C038|C038+C038/C038\C038;
                      db $58,$94,$1C,$81,$10,$81,$50,$82        ;;C040|C040+C040/C040\C040;
                      db $10,$03,$50,$18,$14,$58,$90,$1C        ;;C048|C048+C048/C048\C048;
                      db $81,$5C,$84,$10,$00,$50,$82,$10        ;;C050|C050+C050/C050\C050;
                      db $03,$50,$10,$50,$90,$90,$1C,$00        ;;C058|C058+C058/C058\C058;
                      db $5C,$81,$10,$8B,$50,$89,$1C,$82        ;;C060|C060+C060/C060\C060;
                      db $10,$81,$50,$81,$1C,$00,$5C,$86        ;;C068|C068+C068/C068\C068;
                      db $10,$00,$50,$82,$10,$00,$50,$81        ;;C070|C070+C070/C070\C070;
                      db $D0,$89,$1C,$83,$10,$00,$50,$81        ;;C078|C078+C078/C078\C078;
                      db $1C,$00,$5C,$81,$10,$84,$90,$00        ;;C080|C080+C080/C080\C080;
                      db $D0,$82,$90,$02,$D0,$50,$18,$89        ;;C088|C088+C088/C088\C088;
                      db $1C,$00,$50,$81,$90,$81,$D0,$81        ;;C090|C090+C090/C090\C090;
                      db $1C,$01,$18,$50,$84,$90,$85,$10        ;;C098|C098+C098/C098\C098;
                      db $81,$50,$88,$1C,$01,$D4,$58,$82        ;;C0A0|C0A0+C0A0/C0A0\C0A0;
                      db $1C,$03,$18,$94,$1C,$18,$81,$58        ;;C0A8|C0A8+C0A8/C0A8\C0A8;
                      db $82,$5C,$00,$50,$82,$90,$84,$50        ;;C0B0|C0B0+C0B0/C0B0\C0B0;
                      db $88,$1C,$81,$54,$81,$1C,$82,$14        ;;C0B8|C0B8+C0B8/C0B8\C0B8;
                      db $01,$1C,$18,$81,$58,$81,$5C,$03        ;;C0C0|C0C0+C0C0/C0C0\C0C0;
                      db $18,$5C,$58,$18,$84,$90,$00,$D0        ;;C0C8|C0C8+C0C8/C0C8\C0C8;
                      db $89,$1C,$00,$54,$82,$14,$82,$1C        ;;C0D0|C0D0+C0D0/C0D0\C0D0;
                      db $00,$18,$81,$58,$82,$5C,$81,$58        ;;C0D8|C0D8+C0D8/C0D8\C0D8;
                      db $01,$5C,$58,$82,$5C,$01,$18,$14        ;;C0E0|C0E0+C0E0/C0E0\C0E0;
                      db $86,$1C,$81,$10,$87,$1C,$01,$58        ;;C0E8|C0E8+C0E8/C0E8\C0E8;
                      db $98,$83,$18,$81,$58,$00,$18,$83        ;;C0F0|C0F0+C0F0/C0F0\C0F0;
                      db $5C,$01,$18,$14,$86,$1C,$81,$10        ;;C0F8|C0F8+C0F8/C0F8\C0F8;
                      db $81,$50,$85,$10,$00,$58,$85,$98        ;;C100|C100+C100/C100\C100;
                      db $81,$18,$00,$58,$82,$5C,$01,$18        ;;C108|C108+C108/C108\C108;
                      db $14,$84,$1C,$84,$10,$81,$50,$06        ;;C110|C110+C110/C110\C110;
                      db $10,$50,$10,$50,$10,$58,$18,$83        ;;C118|C118+C118/C118\C118;
                      db $5C,$81,$98,$01,$18,$58,$82,$18        ;;C120|C120+C120/C120\C120;
                      db $01,$D8,$18,$84,$1C,$01,$10,$50        ;;C128|C128+C128/C128\C128;
                      db $81,$10,$02,$50,$10,$50,$81,$10        ;;C130|C130+C130/C130\C130;
                      db $05,$D0,$50,$D0,$58,$5C,$58,$83        ;;C138|C138+C138/C138\C138;
                      db $5C,$84,$98,$02,$D8,$18,$98,$84        ;;C140|C140+C140/C140\C140;
                      db $1C,$83,$10,$00,$50,$82,$10,$84        ;;C148|C148+C148/C148\C148;
                      db $50,$00,$18,$84,$5C,$00,$18,$82        ;;C150|C150+C150/C150\C150;
                      db $5C,$03,$18,$14,$58,$5C,$83,$1C        ;;C158|C158+C158/C158\C158;
                      db $85,$10,$00,$50,$81,$10,$81,$50        ;;C160|C160+C160/C160\C160;
                      db $00,$90,$82,$50,$00,$58,$84,$5C        ;;C168|C168+C168/C168\C168;
                      db $00,$58,$81,$5C,$03,$18,$14,$58        ;;C170|C170+C170/C170\C170;
                      db $5C,$82,$1C,$8A,$10,$83,$50,$84        ;;C178|C178+C178/C178\C178;
                      db $10,$01,$50,$18,$82,$5C,$03,$18        ;;C180|C180+C180/C180\C180;
                      db $14,$58,$5C,$82,$1C,$89,$10,$81        ;;C188|C188+C188/C188\C188;
                      db $50,$81,$90,$85,$10,$81,$50,$00        ;;C190|C190+C190/C190\C190;
                      db $58,$81,$5C,$03,$18,$14,$58,$5C        ;;C198|C198+C198/C198\C198;
                      db $82,$1C,$85,$10,$00,$50,$84,$10        ;;C1A0|C1A0+C1A0/C1A0\C1A0;
                      db $01,$50,$D0,$81,$10,$00,$50,$83        ;;C1A8|C1A8+C1A8/C1A8\C1A8;
                      db $10,$00,$50,$81,$10,$04,$50,$18        ;;C1B0|C1B0+C1B0/C1B0\C1B0;
                      db $14,$58,$5C,$82,$1C,$01,$50,$90        ;;C1B8|C1B8+C1B8/C1B8\C1B8;
                      db $81,$10,$01,$50,$10,$83,$18,$02        ;;C1C0|C1C0+C1C0/C1C0\C1C0;
                      db $10,$50,$D0,$82,$90,$00,$D0,$81        ;;C1C8|C1C8+C1C8/C1C8\C1C8;
                      db $90,$00,$10,$81,$50,$81,$10,$02        ;;C1D0|C1D0+C1D0/C1D0\C1D0;
                      db $50,$14,$58,$81,$14,$82,$1C,$00        ;;C1D8|C1D8+C1D8/C1D8\C1D8;
                      db $58,$81,$90,$03,$50,$90,$10,$D0        ;;C1E0|C1E0+C1E0/C1E0\C1E0;
                      db $82,$90,$04,$D0,$90,$10,$5C,$50        ;;C1E8|C1E8+C1E8/C1E8\C1E8;
                      db $81,$90,$02,$10,$D0,$10,$81,$50        ;;C1F0|C1F0+C1F0/C1F0\C1F0;
                      db $82,$10,$00,$50,$82,$58,$82,$1C        ;;C1F8|C1F8+C1F8/C1F8\C1F8;
                      db $00,$58,$82,$10,$02,$50,$10,$D0        ;;C200|C200+C200/C200\C200;
                      db $82,$90,$01,$10,$5C,$81,$14,$07        ;;C208|C208+C208/C208\C208;
                      db $54,$58,$18,$90,$10,$D0,$10,$50        ;;C210|C210+C210/C210\C210;
                      db $81,$18,$01,$10,$50,$82,$58,$82        ;;C218|C218+C218/C218\C218;
                      db $1C,$00,$D0,$82,$10,$00,$50,$81        ;;C220|C220+C220/C220\C220;
                      db $D0,$02,$58,$5C,$18,$82,$14,$01        ;;C228|C228+C228/C228\C228;
                      db $58,$54,$81,$14,$00,$54,$82,$10        ;;C230|C230+C230/C230\C230;
                      db $83,$18,$00,$10,$82,$50,$81,$1C        ;;C238|C238+C238/C238\C238;
                      db $84,$10,$81,$50,$84,$14,$85,$58        ;;C240|C240+C240/C240\C240;
                      db $81,$10,$01,$90,$10,$84,$18,$81        ;;C248|C248+C248/C248\C248;
                      db $10,$00,$90,$81,$1C,$84,$10,$82        ;;C250|C250+C250/C250\C250;
                      db $50,$87,$58,$01,$10,$50,$83,$10        ;;C258|C258+C258/C258\C258;
                      db $00,$D0,$82,$18,$02,$90,$D0,$10        ;;C260|C260+C260/C260\C260;
                      db $82,$1C,$83,$10,$03,$90,$D0,$10        ;;C268|C268+C268/C268\C268;
                      db $50,$86,$58,$01,$10,$50,$88,$10        ;;C270|C270+C270/C270\C270;
                      db $81,$D0,$01,$1C,$58,$81,$1C,$01        ;;C278|C278+C278/C278\C278;
                      db $50,$90,$82,$10,$03,$50,$D0,$10        ;;C280|C280+C280/C280\C280;
                      db $94,$84,$58,$83,$10,$00,$50,$83        ;;C288|C288+C288/C288\C288;
                      db $10,$01,$18,$10,$81,$D0,$01,$1C        ;;C290|C290+C290/C290\C290;
                      db $18,$82,$1C,$00,$58,$83,$10,$81        ;;C298|C298+C298/C298\C298;
                      db $50,$81,$14,$84,$58,$83,$10,$00        ;;C2A0|C2A0+C2A0/C2A0\C2A0;
                      db $D0,$84,$10,$81,$D0,$82,$1C,$00        ;;C2A8|C2A8+C2A8/C2A8\C2A8;
                      db $58,$81,$1C,$00,$58,$83,$10,$81        ;;C2B0|C2B0+C2B0/C2B0\C2B0;
                      db $50,$83,$58,$00,$10,$81,$50,$87        ;;C2B8|C2B8+C2B8/C2B8\C2B8;
                      db $10,$81,$D0,$00,$58,$82,$1C,$81        ;;C2C0|C2C0+C2C0/C2C0\C2C0;
                      db $14,$04,$1C,$D4,$58,$50,$90,$81        ;;C2C8|C2C8+C2C8/C2C8\C2C8;
                      db $10,$82,$50,$82,$58,$83,$10,$00        ;;C2D0|C2D0+C2D0/C2D0\C2D0;
                      db $18,$83,$10,$03,$18,$10,$D0,$18        ;;C2D8|C2D8+C2D8/C2D8\C2D8;
                      db $82,$1C,$81,$14,$01,$1C,$18,$9E        ;;C2E0|C2E0+C2E0/C2E0\C2E0;
                      db $1C,$00,$18,$9E,$1C,$01,$18,$50        ;;C2E8|C2E8+C2E8/C2E8\C2E8;
                      db $95,$1C,$83,$10,$83,$1C,$00,$10        ;;C2F0|C2F0+C2F0/C2F0\C2F0;
                      db $81,$50,$90,$1C,$87,$10,$83,$1C        ;;C2F8|C2F8+C2F8/C2F8\C2F8;
                      db $01,$90,$10,$81,$50,$8D,$1C,$89        ;;C300|C300+C300/C300\C300;
                      db $10,$01,$50,$5C,$81,$1C,$82,$90        ;;C308|C308+C308/C308\C308;
                      db $81,$50,$8B,$1C,$81,$10,$84,$50        ;;C310|C310+C310/C310\C310;
                      db $83,$10,$81,$50,$81,$1C,$81,$58        ;;C318|C318+C318/C318\C318;
                      db $02,$90,$10,$50,$8B,$1C,$82,$10        ;;C320|C320+C320/C320\C320;
                      db $84,$18,$00,$50,$82,$10,$00,$50        ;;C328|C328+C328/C328\C328;
                      db $81,$1C,$82,$58,$01,$10,$50,$8B        ;;C330|C330+C330/C330\C330;
                      db $1C,$01,$10,$90,$85,$18,$00,$58        ;;C338|C338+C338/C338\C338;
                      db $81,$50,$01,$D0,$10,$81,$1C,$81        ;;C340|C340+C340/C340\C340;
                      db $58,$02,$10,$D0,$10,$87,$1C,$83        ;;C348|C348+C348/C348\C348;
                      db $18,$00,$50,$81,$90,$84,$18,$01        ;;C350|C350+C350/C350\C350;
                      db $D0,$10,$81,$D0,$00,$18,$81,$1C        ;;C358|C358+C358/C358\C358;
                      db $01,$58,$10,$81,$D0,$01,$18,$58        ;;C360|C360+C360/C360\C360;
                      db $85,$1C,$84,$18,$00,$58,$87,$90        ;;C368|C368+C368/C368\C368;
                      db $81,$D0,$01,$5C,$18,$81,$1C,$05        ;;C370|C370+C370/C370\C370;
                      db $10,$90,$D0,$5C,$18,$58,$88,$18        ;;C378|C378+C378/C378\C378;
                      db $04,$58,$D8,$58,$5C,$58,$81,$1C        ;;C380|C380+C380/C380\C380;
                      db $85,$5C,$01,$58,$18,$81,$1C,$01        ;;C388|C388+C388/C388\C388;
                      db $58,$18,$81,$5C,$01,$18,$58,$86        ;;C390|C390+C390/C390\C390;
                      db $18,$81,$98,$00,$D8,$81,$58,$01        ;;C398|C398+C398/C398\C398;
                      db $18,$5C,$81,$1C,$84,$5C,$07,$18        ;;C3A0|C3A0+C3A0/C3A0\C3A0;
                      db $5C,$18,$50,$1C,$58,$5C,$58,$81        ;;C3A8|C3A8+C3A8/C3A8\C3A8;
                      db $18,$00,$58,$85,$1C,$82,$18,$01        ;;C3B0|C3B0+C3B0/C3B0\C3B0;
                      db $58,$18,$82,$58,$81,$1C,$85,$5C        ;;C3B8|C3B8+C3B8/C3B8\C3B8;
                      db $01,$58,$18,$81,$50,$00,$58,$82        ;;C3C0|C3C0+C3C0/C3C0\C3C0;
                      db $18,$01,$D8,$18,$83,$10,$81,$50        ;;C3C8|C3C8+C3C8/C3C8\C3C8;
                      db $81,$18,$00,$D8,$82,$18,$00,$58        ;;C3D0|C3D0+C3D0/C3D0\C3D0;
                      db $82,$18,$00,$58,$83,$5C,$04,$18        ;;C3D8|C3D8+C3D8/C3D8\C3D8;
                      db $5C,$18,$10,$50,$82,$18,$81,$D8        ;;C3E0|C3E0+C3E0/C3E0\C3E0;
                      db $01,$18,$D0,$83,$90,$04,$50,$58        ;;C3E8|C3E8+C3E8/C3E8\C3E8;
                      db $98,$18,$D8,$83,$18,$02,$98,$D8        ;;C3F0|C3F0+C3F0/C3F0\C3F0;
                      db $18,$84,$5C,$00,$58,$81,$10,$00        ;;C3F8|C3F8+C3F8/C3F8\C3F8;
                      db $50,$81,$98,$04,$18,$58,$5C,$18        ;;C400|C400+C400/C400\C400;
                      db $D0,$82,$5C,$81,$90,$00,$58,$87        ;;C408|C408+C408/C408\C408;
                      db $98,$01,$D8,$18,$83,$5C,$00,$18        ;;C410|C410+C410/C410\C410;
                      db $82,$10,$01,$50,$18,$81,$98,$02        ;;C418|C418+C418/C418\C418;
                      db $18,$5C,$18,$83,$14,$81,$54,$00        ;;C420|C420+C420/C420\C420;
                      db $58,$81,$5C,$00,$58,$84,$5C,$01        ;;C428|C428+C428/C428\C428;
                      db $58,$18,$82,$5C,$83,$10,$81,$50        ;;C430|C430+C430/C430\C430;
                      db $05,$5C,$58,$5C,$18,$5C,$18,$85        ;;C438|C438+C438/C438\C438;
                      db $1C,$02,$58,$5C,$18,$84,$5C,$02        ;;C440|C440+C440/C440\C440;
                      db $18,$5C,$18,$87,$10,$01,$50,$18        ;;C448|C448+C448/C448\C448;
                      db $81,$5C,$01,$18,$5C,$81,$14,$83        ;;C450|C450+C450/C450\C450;
                      db $58,$01,$D4,$58,$81,$5C,$00,$58        ;;C458|C458+C458/C458\C458;
                      db $84,$5C,$00,$58,$82,$10,$02,$50        ;;C460|C460+C460/C460\C460;
                      db $10,$50,$81,$10,$05,$D0,$10,$5C        ;;C468|C468+C468/C468\C468;
                      db $58,$5C,$18,$81,$14,$00,$18,$83        ;;C470|C470+C470/C470\C470;
                      db $58,$81,$54,$01,$5C,$18,$84,$5C        ;;C478|C478+C478/C478\C478;
                      db $00,$18,$81,$10,$05,$50,$10,$50        ;;C480|C480+C480/C480\C480;
                      db $10,$50,$10,$81,$50,$81,$18,$81        ;;C488|C488+C488/C488\C488;
                      db $5C,$01,$18,$94,$86,$58,$82,$54        ;;C490|C490+C490/C490\C490;
                      db $00,$58,$86,$10,$05,$50,$10,$50        ;;C498|C498+C498/C498\C498;
                      db $10,$50,$10,$81,$50,$03,$18,$14        ;;C4A0|C4A0+C4A0/C4A0\C4A0;
                      db $54,$5C,$81,$14,$01,$58,$18,$85        ;;C4A8|C4A8+C4A8/C4A8\C4A8;
                      db $58,$02,$18,$54,$14,$82,$10,$00        ;;C4B0|C4B0+C4B0/C4B0\C4B0;
                      db $50,$82,$10,$02,$50,$D0,$90,$81        ;;C4B8|C4B8+C4B8/C4B8\C4B8;
                      db $10,$82,$50,$02,$18,$58,$54,$81        ;;C4C0|C4C0+C4C0/C4C0\C4C0;
                      db $14,$81,$58,$84,$18,$83,$58,$83        ;;C4C8|C4C8+C4C8/C4C8\C4C8;
                      db $10,$02,$50,$10,$50,$81,$10,$07        ;;C4D0|C4D0+C4D0/C4D0\C4D0;
                      db $50,$10,$50,$10,$50,$10,$50,$14        ;;C4D8|C4D8+C4D8/C4D8\C4D8;
                      db $82,$58,$02,$10,$50,$58,$82,$18        ;;C4E0|C4E0+C4E0/C4E0\C4E0;
                      db $01,$10,$50,$82,$58,$82,$10,$00        ;;C4E8|C4E8+C4E8/C4E8\C4E8;
                      db $50,$81,$10,$81,$50,$02,$10,$50        ;;C4F0|C4F0+C4F0/C4F0\C4F0;
                      db $10,$81,$50,$04,$10,$50,$10,$50        ;;C4F8|C4F8+C4F8/C4F8\C4F8;
                      db $14,$82,$50,$81,$10,$00,$94,$81        ;;C500|C500+C500/C500\C500;
                      db $18,$81,$10,$01,$50,$10,$81,$50        ;;C508|C508+C508/C508\C508;
                      db $83,$10,$0D,$50,$10,$50,$10,$50        ;;C510|C510+C510/C510\C510;
                      db $10,$50,$10,$50,$10,$50,$10,$50        ;;C518|C518+C518/C518\C518;
                      db $1C,$82,$90,$00,$D0,$81,$14,$01        ;;C520|C520+C520/C520\C520;
                      db $18,$10,$83,$90,$82,$10,$01,$50        ;;C528|C528+C528/C528\C528;
                      db $10,$81,$50,$07,$10,$50,$10,$50        ;;C530|C530+C530/C530\C530;
                      db $10,$50,$10,$50,$81,$10,$82,$50        ;;C538|C538+C538/C538\C538;
                      db $81,$1C,$81,$18,$82,$14,$00,$58        ;;C540|C540+C540/C540\C540;
                      db $81,$1C,$00,$18,$81,$90,$81,$10        ;;C548|C548+C548/C548\C548;
                      db $00,$50,$81,$10,$00,$50,$81,$10        ;;C550|C550+C550/C550\C550;
                      db $0A,$50,$10,$50,$10,$50,$10,$50        ;;C558|C558+C558/C558\C558;
                      db $10,$50,$10,$50,$81,$1C,$81,$18        ;;C560|C560+C560/C560\C560;
                      db $82,$14,$00,$58,$82,$1C,$00,$58        ;;C568|C568+C568/C568\C568;
                      db $82,$90,$04,$10,$50,$10,$50,$10        ;;C570|C570+C570/C570\C570;
                      db $81,$50,$81,$10,$81,$50,$05,$10        ;;C578|C578+C578/C578\C578;
                      db $50,$10,$50,$10,$50,$81,$1C,$81        ;;C580|C580+C580/C580\C580;
                      db $18,$82,$14,$00,$58,$81,$1C,$00        ;;C588|C588+C588/C588\C588;
                      db $18,$82,$1C,$81,$10,$02,$50,$10        ;;C590|C590+C590/C590\C590;
                      db $50,$81,$10,$06,$50,$10,$50,$10        ;;C598|C598+C598/C598\C598;
                      db $50,$14,$10,$81,$50,$01,$D0,$10        ;;C5A0|C5A0+C5A0/C5A0\C5A0;
                      db $82,$1C,$81,$14,$02,$18,$D4,$58        ;;C5A8|C5A8+C5A8/C5A8\C5A8;
                      db $82,$1C,$00,$58,$81,$1C,$84,$10        ;;C5B0|C5B0+C5B0/C5B0\C5B0;
                      db $00,$50,$81,$10,$01,$50,$10,$81        ;;C5B8|C5B8+C5B8/C5B8\C5B8;
                      db $50,$02,$10,$50,$10,$81,$50,$02        ;;C5C0|C5C0+C5C0/C5C0\C5C0;
                      db $18,$14,$54,$81,$14,$01,$18,$58        ;;C5C8|C5C8+C5C8/C5C8\C5C8;
                      db $85,$54,$83,$10,$06,$50,$10,$50        ;;C5D0|C5D0+C5D0/C5D0\C5D0;
                      db $10,$50,$10,$50,$81,$10,$03,$50        ;;C5D8|C5D8+C5D8/C5D8\C5D8;
                      db $10,$50,$10,$81,$50,$00,$18,$87        ;;C5E0|C5E0+C5E0/C5E0\C5E0;
                      db $1C,$83,$50,$83,$10,$02,$50,$10        ;;C5E8|C5E8+C5E8/C5E8\C5E8;
                      db $50,$81,$10,$06,$50,$10,$50,$10        ;;C5F0|C5F0+C5F0/C5F0\C5F0;
                      db $50,$10,$50,$81,$10,$02,$50,$18        ;;C5F8|C5F8+C5F8/C5F8\C5F8;
                      db $1C,$81,$54,$00,$58,$82,$10,$01        ;;C600|C600+C600/C600\C600;
                      db $50,$10,$83,$50,$89,$10,$81,$D0        ;;C608|C608+C608/C608\C608;
                      db $02,$1C,$58,$1C,$81,$14,$83,$1C        ;;C610|C610+C610/C610\C610;
                      db $04,$54,$58,$50,$90,$D0,$86,$10        ;;C618|C618+C618/C618\C618;
                      db $81,$18,$00,$50,$84,$10,$81,$D0        ;;C620|C620+C620/C620\C620;
                      db $01,$58,$18,$82,$14,$85,$1C,$00        ;;C628|C628+C628/C628\C628;
                      db $D0,$81,$10,$01,$50,$D0,$82,$10        ;;C630|C630+C630/C630\C630;
                      db $02,$50,$10,$90,$81,$18,$00,$D0        ;;C638|C638+C638/C638\C638;
                      db $83,$10,$81,$D0,$01,$18,$1C,$81        ;;C640|C640+C640/C640\C640;
                      db $14,$86,$1C,$83,$10,$81,$50,$00        ;;C648|C648+C648/C648\C648;
                      db $D0,$81,$90,$00,$D0,$87,$10,$81        ;;C650|C650+C650/C650\C650;
                      db $D0,$81,$1C,$01,$58,$14,$81,$1C        ;;C658|C658+C658/C658\C658;
                      db $81,$14,$83,$1C,$01,$50,$90,$81        ;;C660|C660+C660/C660\C660;
                      db $10,$00,$D0,$83,$10,$00,$50,$84        ;;C668|C668+C668/C668\C668;
                      db $10,$01,$D0,$90,$81,$D0,$81,$1C        ;;C670|C670+C670/C670\C670;
                      db $00,$18,$87,$14,$81,$1C,$00,$58        ;;C678|C678+C678/C678\C678;
                      db $82,$90,$01,$D0,$18,$82,$10,$00        ;;C680|C680+C680/C680\C680;
                      db $50,$83,$10,$81,$D0,$00,$58,$83        ;;C688|C688+C688/C688\C688;
                      db $1C,$81,$14,$00,$1C,$81,$14,$81        ;;C690|C690+C690/C690\C690;
                      db $58,$81,$14,$81,$1C,$05,$58,$1C        ;;C698|C698+C698/C698\C698;
                      db $18,$58,$1C,$18,$86,$90,$81,$D0        ;;C6A0|C6A0+C6A0/C6A0\C6A0;
                      db $02,$1C,$58,$5C,$81,$1C,$83,$14        ;;C6A8|C6A8+C6A8/C6A8\C6A8;
                      db $85,$58,$81,$1C,$04,$58,$1C,$18        ;;C6B0|C6B0+C6B0/C6B0\C6B0;
                      db $58,$1C,$81,$18,$00,$58,$84,$1C        ;;C6B8|C6B8+C6B8/C6B8\C6B8;
                      db $00,$58,$81,$1C,$00,$58,$81,$1C        ;;C6C0|C6C0+C6C0/C6C0\C6C0;
                      db $81,$14,$00,$1C,$81,$14,$85,$58        ;;C6C8|C6C8+C6C8/C6C8\C6C8;
                      db $81,$1C,$07,$58,$1C,$18,$58,$1C        ;;C6D0|C6D0+C6D0/C6D0\C6D0;
                      db $18,$1C,$58,$83,$1C,$01,$18,$5C        ;;C6D8|C6D8+C6D8/C6D8\C6D8;
                      db $81,$1C,$00,$58,$84,$14,$87,$58        ;;C6E0|C6E0+C6E0/C6E0\C6E0;
                      db $81,$1C,$04,$58,$1C,$18,$58,$1C        ;;C6E8|C6E8+C6E8/C6E8\C6E8;
                      db $81,$18,$01,$1C,$5C,$83,$1C,$01        ;;C6F0|C6F0+C6F0/C6F0\C6F0;
                      db $58,$1C,$82,$14,$81,$1C,$81,$14        ;;C6F8|C6F8+C6F8/C6F8\C6F8;
                      db $87,$58,$81,$1C,$07,$58,$1C,$18        ;;C700|C700+C700/C700\C700;
                      db $58,$1C,$18,$54,$58,$83,$1C,$00        ;;C708|C708+C708/C708\C708;
                      db $18,$82,$14,$83,$1C,$81,$14,$87        ;;C710|C710+C710/C710\C710;
                      db $58,$81,$1C,$06,$58,$1C,$18,$58        ;;C718|C718+C718/C718\C718;
                      db $1C,$18,$54,$86,$14,$85,$1C,$81        ;;C720|C720+C720/C720\C720;
                      db $14,$87,$58,$81,$1C,$05,$58,$1C        ;;C728|C728+C728/C728\C728;
                      db $18,$58,$1C,$18,$84,$10,$81,$50        ;;C730|C730+C730/C730\C730;
                      db $87,$1C,$81,$14,$86,$58,$02,$1C        ;;C738|C738+C738/C738\C738;
                      db $10,$58,$81,$10,$81,$50,$00,$18        ;;C740|C740+C740/C740\C740;
                      db $86,$10,$00,$50,$86,$1C,$83,$14        ;;C748|C748+C748/C748\C748;
                      db $83,$58,$03,$14,$1C,$10,$50,$81        ;;C750|C750+C750/C750\C750;
                      db $10,$81,$50,$87,$10,$00,$50,$88        ;;C758|C758+C758/C758\C758;
                      db $1C,$81,$14,$00,$58,$81,$14,$09        ;;C760|C760+C760/C760\C760;
                      db $58,$14,$1C,$10,$D0,$58,$18,$58        ;;C768|C768+C768/C768\C768;
                      db $18,$90,$86,$10,$00,$50,$8B,$1C        ;;C770|C770+C770/C770\C770;
                      db $81,$14,$82,$1C,$00,$10,$81,$50        ;;C778|C778+C778/C778\C778;
                      db $01,$18,$58,$88,$10,$00,$50,$90        ;;C780|C780+C780/C780\C780;
                      db $1C,$81,$10,$00,$50,$8A,$10,$00        ;;C788|C788+C788/C788\C788;
                      db $50,$83,$1C,$01,$18,$58,$8A,$1C        ;;C790|C790+C790/C790\C790;
                      db $00,$50,$82,$90,$86,$10,$00,$D0        ;;C798|C798+C798/C798\C798;
                      db $81,$90,$00,$10,$83,$1C,$00,$18        ;;C7A0|C7A0+C7A0/C7A0\C7A0;
                      db $81,$58,$83,$1C,$81,$18,$00,$58        ;;C7A8|C7A8+C7A8/C7A8\C7A8;
                      db $82,$1C,$81,$58,$00,$1C,$87,$10        ;;C7B0|C7B0+C7B0/C7B0\C7B0;
                      db $00,$50,$81,$1C,$00,$18,$83,$1C        ;;C7B8|C7B8+C7B8/C7B8\C7B8;
                      db $81,$98,$81,$58,$81,$1C,$85,$18        ;;C7C0|C7C0+C7C0/C7C0\C7C0;
                      db $00,$1C,$81,$58,$01,$1C,$50,$86        ;;C7C8|C7C8+C7C8/C7C8\C7C8;
                      db $90,$00,$10,$81,$1C,$00,$18,$83        ;;C7D0|C7D0+C7D0/C7D0\C7D0;
                      db $1C,$00,$58,$8A,$18,$00,$D4,$81        ;;C7D8|C7D8+C7D8/C7D8\C7D8;
                      db $58,$00,$1C,$81,$58,$84,$1C,$81        ;;C7E0|C7E0+C7E0/C7E0\C7E0;
                      db $18,$81,$1C,$01,$18,$94,$82,$1C        ;;C7E8|C7E8+C7E8/C7E8\C7E8;
                      db $8B,$18,$81,$54,$01,$58,$1C,$81        ;;C7F0|C7F0+C7F0/C7F0\C7F0;
                      db $58,$84,$1C,$81,$18,$81,$1C,$81        ;;C7F8|C7F8+C7F8/C7F8\C7F8;
                      db $14,$81,$1C,$8C,$18,$01,$1C,$54        ;;C800|C800+C800/C800\C800;
                      db $81,$14,$81,$58,$84,$1C,$81,$18        ;;C808|C808+C808/C808\C808;
                      db $82,$14,$82,$1C,$81,$98,$8A,$18        ;;C810|C810+C810/C810\C810;
                      db $82,$1C,$81,$54,$00,$58,$84,$1C        ;;C818|C818+C818/C818\C818;
                      db $00,$18,$81,$14,$84,$1C,$00,$58        ;;C820|C820+C820/C820\C820;
                      db $8B,$18,$83,$1C,$00,$54,$87,$14        ;;C828|C828+C828/C828\C828;
                      db $85,$1C,$8C,$18,$92,$1C,$81,$98        ;;C830|C830+C830/C830\C830;
                      db $8A,$18,$8D,$1C,$81,$14,$00,$1C        ;;C838|C838+C838/C838\C838;
                      db $81,$14,$00,$58,$81,$98,$89,$18        ;;C840|C840+C840/C840\C840;
                      db $8D,$1C,$84,$14,$81,$58,$81,$98        ;;C848|C848+C848/C848\C848;
                      db $81,$18,$00,$D8,$81,$98,$00,$D8        ;;C850|C850+C850/C850\C850;
                      db $82,$98,$8C,$1C,$84,$14,$83,$58        ;;C858|C858+C858/C858\C858;
                      db $82,$98,$03,$D8,$1C,$18,$58,$81        ;;C860|C860+C860/C860\C860;
                      db $1C,$00,$18,$89,$1C,$81,$14,$00        ;;C868|C868+C868/C868\C868;
                      db $1C,$85,$14,$83,$58,$81,$1C,$03        ;;C870|C870+C870/C870\C870;
                      db $18,$1C,$98,$D8,$81,$1C,$00,$98        ;;C878|C878+C878/C878\C878;
                      db $89,$1C,$81,$14,$84,$1C,$82,$14        ;;C880|C880+C880/C880\C880;
                      db $82,$58,$81,$1C,$03,$18,$1C,$58        ;;C888|C888+C888/C888\C888;
                      db $18,$81,$1C,$00,$58,$86,$1C,$83        ;;C890|C890+C890/C890\C890;
                      db $10,$83,$50,$86,$10,$82,$50,$82        ;;C898|C898+C898/C898\C898;
                      db $10,$03,$50,$10,$50,$14,$86,$1C        ;;C8A0|C8A0+C8A0/C8A0\C8A0;
                      db $83,$10,$83,$18,$84,$90,$06,$10        ;;C8A8|C8A8+C8A8/C8A8\C8A8;
                      db $50,$10,$50,$10,$50,$10,$81,$50        ;;C8B0|C8B0+C8B0/C8B0\C8B0;
                      db $02,$D0,$10,$14,$86,$1C,$83,$10        ;;C8B8|C8B8+C8B8/C8B8\C8B8;
                      db $00,$90,$81,$18,$07,$D0,$10,$50        ;;C8C0|C8C0+C8C0/C8C0\C8C0;
                      db $10,$50,$10,$50,$10,$81,$50,$03        ;;C8C8|C8C8+C8C8/C8C8\C8C8;
                      db $10,$50,$10,$50,$81,$D0,$00,$18        ;;C8D0|C8D0+C8D0/C8D0\C8D0;
                      db $87,$1C,$82,$10,$82,$90,$82,$10        ;;C8D8|C8D8+C8D8/C8D8\C8D8;
                      db $0A,$50,$10,$50,$10,$50,$10,$50        ;;C8E0|C8E0+C8E0/C8E0\C8E0;
                      db $10,$50,$90,$10,$81,$50,$01,$1C        ;;C8E8|C8E8+C8E8/C8E8\C8E8;
                      db $18,$87,$1C,$07,$10,$50,$14,$54        ;;C8F0|C8F0+C8F0/C8F0\C8F0;
                      db $58,$18,$90,$10,$83,$50,$83,$10        ;;C8F8|C8F8+C8F8/C8F8\C8F8;
                      db $02,$50,$90,$10,$82,$50,$02,$1C        ;;C900|C900+C900/C900\C900;
                      db $18,$94,$86,$1C,$03,$50,$90,$50        ;;C908|C908+C908/C908\C908;
                      db $54,$81,$14,$01,$54,$10,$83,$18        ;;C910|C910+C910/C910\C910;
                      db $84,$90,$00,$10,$81,$50,$02,$D0        ;;C918|C918+C918/C918\C918;
                      db $10,$1C,$83,$14,$84,$1C,$00,$58        ;;C920|C920+C920/C920\C920;
                      db $81,$90,$00,$50,$81,$58,$02,$54        ;;C928|C928+C928/C928\C928;
                      db $10,$90,$81,$18,$00,$D0,$81,$10        ;;C930|C930+C930/C930\C930;
                      db $07,$50,$10,$50,$10,$50,$10,$D0        ;;C938|C938+C938/C938\C938;
                      db $18,$81,$14,$00,$1C,$81,$14,$84        ;;C940|C940+C940/C940\C940;
                      db $1C,$01,$58,$1C,$81,$90,$81,$50        ;;C948|C948+C948/C948\C948;
                      db $83,$10,$00,$50,$81,$10,$01,$50        ;;C950|C950+C950/C950\C950;
                      db $10,$81,$50,$81,$10,$81,$D0,$01        ;;C958|C958+C958/C958\C958;
                      db $18,$14,$81,$1C,$81,$58,$81,$14        ;;C960|C960+C960/C960\C960;
                      db $81,$1C,$01,$D4,$58,$81,$1C,$81        ;;C968|C968+C968/C968\C968;
                      db $90,$00,$50,$83,$10,$00,$50,$81        ;;C970|C970+C970/C970\C970;
                      db $10,$03,$50,$10,$50,$10,$82,$D0        ;;C978|C978+C978/C978\C978;
                      db $02,$58,$18,$94,$81,$1C,$81,$58        ;;C980|C980+C980/C980\C980;
                      db $81,$14,$81,$1C,$81,$54,$82,$1C        ;;C988|C988+C988/C988\C988;
                      db $8B,$90,$81,$D0,$02,$1C,$18,$1C        ;;C990|C990+C990/C990\C990;
                      db $81,$14,$81,$1C,$81,$58,$81,$14        ;;C998|C998+C998/C998\C998;
                      db $82,$1C,$81,$54,$83,$1C,$00,$58        ;;C9A0|C9A0+C9A0/C9A0\C9A0;
                      db $87,$1C,$00,$18,$82,$1C,$00,$18        ;;C9A8|C9A8+C9A8/C9A8\C9A8;
                      db $81,$14,$82,$1C,$81,$58,$81,$14        ;;C9B0|C9B0+C9B0/C9B0\C9B0;
                      db $83,$1C,$84,$18,$01,$58,$1C,$82        ;;C9B8|C9B8+C9B8/C9B8\C9B8;
                      db $10,$00,$50,$83,$1C,$00,$58,$81        ;;C9C0|C9C0+C9C0/C9C0\C9C0;
                      db $1C,$01,$18,$14,$83,$1C,$00,$58        ;;C9C8|C9C8+C9C8/C9C8\C9C8;
                      db $81,$14,$84,$1C,$84,$18,$01,$58        ;;C9D0|C9D0+C9D0/C9D0\C9D0;
                      db $1C,$81,$10,$81,$50,$82,$1C,$00        ;;C9D8|C9D8+C9D8/C9D8\C9D8;
                      db $18,$82,$1C,$81,$14,$83,$1C,$82        ;;C9E0|C9E0+C9E0/C9E0\C9E0;
                      db $14,$84,$1C,$83,$18,$02,$98,$D8        ;;C9E8|C9E8+C9E8/C9E8\C9E8;
                      db $1C,$81,$90,$01,$D0,$50,$81,$1C        ;;C9F0|C9F0+C9F0/C9F0\C9F0;
                      db $81,$18,$00,$58,$81,$14,$81,$10        ;;C9F8|C9F8+C9F8/C9F8\C9F8;
                      db $00,$50,$82,$1C,$00,$14,$81,$1C        ;;CA00|CA00+CA00/CA00\CA00;
                      db $81,$18,$00,$58,$81,$1C,$81,$98        ;;CA08|CA08+CA08/CA08\CA08;
                      db $82,$18,$02,$58,$14,$50,$81,$90        ;;CA10|CA10+CA10/CA10\CA10;
                      db $00,$10,$81,$14,$07,$58,$98,$18        ;;CA18|CA18+CA18/CA18\CA18;
                      db $14,$1C,$50,$90,$10,$85,$1C,$81        ;;CA20|CA20+CA20/CA20\CA20;
                      db $18,$01,$58,$18,$81,$58,$82,$18        ;;CA28|CA28+CA28/CA28\CA28;
                      db $81,$D8,$00,$1C,$81,$58,$81,$18        ;;CA30|CA30+CA30/CA30\CA30;
                      db $81,$1C,$81,$58,$00,$18,$81,$1C        ;;CA38|CA38+CA38/CA38\CA38;
                      db $02,$58,$1C,$18,$85,$1C,$88,$18        ;;CA40|CA40+CA40/CA40\CA40;
                      db $02,$58,$18,$1C,$81,$58,$81,$18        ;;CA48|CA48+CA48/CA48\CA48;
                      db $81,$1C,$81,$58,$00,$18,$81,$1C        ;;CA50|CA50+CA50/CA50\CA50;
                      db $02,$58,$1C,$18,$82,$1C,$8B,$18        ;;CA58|CA58+CA58/CA58\CA58;
                      db $02,$58,$18,$D4,$81,$58,$81,$18        ;;CA60|CA60+CA60/CA60\CA60;
                      db $01,$94,$1C,$81,$58,$06,$18,$1C        ;;CA68|CA68+CA68/CA68\CA68;
                      db $D4,$58,$1C,$18,$94,$81,$1C,$8B        ;;CA70|CA70+CA70/CA70\CA70;
                      db $18,$01,$58,$18,$81,$54,$01,$58        ;;CA78|CA78+CA78/CA78\CA78;
                      db $18,$81,$14,$00,$D4,$81,$58,$01        ;;CA80|CA80+CA80/CA80\CA80;
                      db $18,$94,$81,$54,$00,$1C,$81,$14        ;;CA88|CA88+CA88/CA88\CA88;
                      db $81,$1C,$8B,$18,$81,$58,$01,$1C        ;;CA90|CA90+CA90/CA90\CA90;
                      db $54,$82,$14,$00,$1C,$81,$54,$00        ;;CA98|CA98+CA98/CA98\CA98;
                      db $58,$81,$14,$01,$1C,$54,$81,$14        ;;CAA0|CAA0+CAA0/CAA0\CAA0;
                      db $82,$1C,$8C,$18,$00,$58,$81,$18        ;;CAA8|CAA8+CAA8/CAA8\CAA8;
                      db $00,$58,$83,$1C,$00,$54,$81,$14        ;;CAB0|CAB0+CAB0/CAB0\CAB0;
                      db $87,$1C,$8F,$18,$81,$58,$8D,$1C        ;;CAB8|CAB8+CAB8/CAB8\CAB8;
                      db $90,$18,$02,$58,$18,$58,$8B,$1C        ;;CAC0|CAC0+CAC0/CAC0\CAC0;
                      db $91,$18,$81,$D8,$81,$1C,$81,$14        ;;CAC8|CAC8+CAC8/CAC8\CAC8;
                      db $87,$1C,$91,$18,$02,$58,$18,$1C        ;;CAD0|CAD0+CAD0/CAD0\CAD0;
                      db $82,$14,$87,$1C,$91,$18,$81,$58        ;;CAD8|CAD8+CAD8/CAD8\CAD8;
                      db $00,$1C,$81,$14,$88,$1C,$91,$18        ;;CAE0|CAE0+CAE0/CAE0\CAE0;
                      db $81,$D8,$8B,$1C,$88,$18,$00,$D8        ;;CAE8|CAE8+CAE8/CAE8\CAE8;
                      db $84,$98,$81,$18,$81,$D8,$00,$18        ;;CAF0|CAF0+CAF0/CAF0\CAF0;
                      db $81,$14,$82,$1C,$81,$14,$84,$1C        ;;CAF8|CAF8+CAF8/CAF8\CAF8;
                      db $88,$18,$00,$58,$83,$1C,$81,$98        ;;CB00|CB00+CB00/CB00\CB00;
                      db $81,$D8,$81,$18,$86,$14,$84,$1C        ;;CB08|CB08+CB08/CB08\CB08;
                      db $81,$18,$82,$98,$00,$D8,$81,$98        ;;CB10|CB10+CB10/CB10\CB10;
                      db $01,$18,$58,$83,$1C,$02,$58,$98        ;;CB18|CB18+CB18/CB18\CB18;
                      db $D8,$82,$18,$00,$58,$83,$14,$86        ;;CB20|CB20+CB20/CB20\CB20;
                      db $1C,$01,$98,$D8,$81,$1C,$02,$98        ;;CB28|CB28+CB28/CB28\CB28;
                      db $D8,$1C,$81,$18,$00,$58,$83,$1C        ;;CB30|CB30+CB30/CB30\CB30;
                      db $81,$58,$83,$18,$83,$14,$88,$1C        ;;CB38|CB38+CB38/CB38\CB38;
                      db $00,$18,$81,$1C,$02,$58,$18,$1C        ;;CB40|CB40+CB40/CB40\CB40;
                      db $81,$98,$00,$D8,$83,$1C,$81,$58        ;;CB48|CB48+CB48/CB48\CB48;
                      db $82,$18,$82,$14,$89,$1C,$83,$14        ;;CB50|CB50+CB50/CB50\CB50;
                      db $00,$50,$83,$10,$82,$50,$81,$10        ;;CB58|CB58+CB58/CB58\CB58;
                      db $00,$14,$81,$18,$8C,$14,$81,$10        ;;CB60|CB60+CB60/CB60\CB60;
                      db $83,$14,$00,$50,$83,$10,$82,$50        ;;CB68|CB68+CB68/CB68\CB68;
                      db $82,$10,$81,$18,$85,$10,$81,$18        ;;CB70|CB70+CB70/CB70\CB70;
                      db $84,$14,$81,$10,$81,$14,$81,$18        ;;CB78|CB78+CB78/CB78\CB78;
                      db $00,$50,$83,$10,$82,$50,$82,$10        ;;CB80|CB80+CB80/CB80\CB80;
                      db $81,$18,$81,$10,$01,$50,$10,$83        ;;CB88|CB88+CB88/CB88\CB88;
                      db $18,$84,$14,$81,$10,$81,$14,$81        ;;CB90|CB90+CB90/CB90\CB90;
                      db $18,$00,$50,$83,$10,$83,$50,$81        ;;CB98|CB98+CB98/CB98\CB98;
                      db $10,$81,$18,$81,$10,$01,$50,$10        ;;CBA0|CBA0+CBA0/CBA0\CBA0;
                      db $83,$18,$84,$14,$81,$10,$81,$14        ;;CBA8|CBA8+CBA8/CBA8\CBA8;
                      db $81,$18,$00,$50,$83,$10,$81,$50        ;;CBB0|CBB0+CBB0/CBB0\CBB0;
                      db $03,$10,$50,$10,$90,$82,$18,$01        ;;CBB8|CBB8+CBB8/CBB8\CBB8;
                      db $10,$50,$82,$10,$82,$18,$83,$14        ;;CBC0|CBC0+CBC0/CBC0\CBC0;
                      db $81,$10,$01,$14,$10,$81,$18,$00        ;;CBC8|CBC8+CBC8/CBC8\CBC8;
                      db $50,$81,$10,$81,$90,$81,$D0,$81        ;;CBD0|CBD0+CBD0/CBD0\CBD0;
                      db $50,$81,$10,$82,$18,$85,$10,$81        ;;CBD8|CBD8+CBD8/CBD8\CBD8;
                      db $18,$00,$50,$82,$14,$81,$10,$01        ;;CBE0|CBE0+CBE0/CBE0\CBE0;
                      db $14,$10,$81,$18,$81,$50,$82,$10        ;;CBE8|CBE8+CBE8/CBE8\CBE8;
                      db $82,$50,$82,$10,$82,$18,$00,$10        ;;CBF0|CBF0+CBF0/CBF0\CBF0;
                      db $81,$50,$01,$10,$D0,$82,$10,$00        ;;CBF8|CBF8+CBF8/CBF8\CBF8;
                      db $50,$82,$14,$81,$10,$02,$14,$50        ;;CC00|CC00+CC00/CC00\CC00;
                      db $90,$81,$10,$81,$50,$81,$10,$81        ;;CC08|CC08+CC08/CC08\CC08;
                      db $50,$81,$10,$85,$18,$82,$50,$01        ;;CC10|CC10+CC10/CC10\CC10;
                      db $10,$50,$81,$10,$00,$50,$82,$14        ;;CC18|CC18+CC18/CC18\CC18;
                      db $81,$10,$02,$14,$54,$10,$81,$18        ;;CC20|CC20+CC20/CC20\CC20;
                      db $01,$D0,$50,$81,$10,$81,$50,$01        ;;CC28|CC28+CC28/CC28\CC28;
                      db $10,$90,$86,$18,$81,$50,$04,$10        ;;CC30|CC30+CC30/CC30\CC30;
                      db $50,$10,$D0,$10,$82,$14,$81,$10        ;;CC38|CC38+CC38/CC38\CC38;
                      db $02,$14,$54,$10,$81,$18,$81,$50        ;;CC40|CC40+CC40/CC40\CC40;
                      db $81,$10,$81,$50,$81,$10,$85,$18        ;;CC48|CC48+CC48/CC48\CC48;
                      db $82,$10,$00,$90,$82,$D0,$83,$14        ;;CC50|CC50+CC50/CC50\CC50;
                      db $81,$10,$01,$D4,$54,$83,$10,$00        ;;CC58|CC58+CC58/CC58\CC58;
                      db $50,$81,$10,$01,$50,$10,$87,$18        ;;CC60|CC60+CC60/CC60\CC60;
                      db $83,$10,$82,$50,$83,$14,$81,$10        ;;CC68|CC68+CC68/CC68\CC68;
                      db $81,$54,$82,$10,$00,$50,$81,$10        ;;CC70|CC70+CC70/CC70\CC70;
                      db $02,$50,$90,$10,$81,$18,$00,$10        ;;CC78|CC78+CC78/CC78\CC78;
                      db $83,$18,$81,$10,$07,$18,$10,$50        ;;CC80|CC80+CC80/CC80\CC80;
                      db $90,$10,$50,$14,$94,$81,$14,$81        ;;CC88|CC88+CC88/CC88\CC88;
                      db $10,$08,$14,$54,$10,$50,$10,$90        ;;CC90|CC90+CC90/CC90\CC90;
                      db $10,$50,$90,$81,$10,$84,$50,$81        ;;CC98|CC98+CC98/CC98\CC98;
                      db $18,$07,$10,$50,$10,$50,$90,$10        ;;CCA0|CCA0+CCA0/CCA0\CCA0;
                      db $18,$50,$83,$14,$81,$10,$81,$14        ;;CCA8|CCA8+CCA8/CCA8\CCA8;
                      db $81,$10,$04,$90,$50,$10,$50,$90        ;;CCB0|CCB0+CCB0/CCB0\CCB0;
                      db $85,$10,$00,$50,$81,$18,$01,$90        ;;CCB8|CCB8+CCB8/CCB8\CCB8;
                      db $D0,$81,$90,$03,$10,$18,$10,$50        ;;CCC0|CCC0+CCC0/CCC0\CCC0;
                      db $83,$14,$81,$D0,$81,$14,$83,$90        ;;CCC8|CCC8+CCC8/CCC8\CCC8;
                      db $01,$50,$90,$81,$18,$00,$50,$84        ;;CCD0|CCD0+CCD0/CCD0\CCD0;
                      db $10,$81,$18,$01,$10,$50,$81,$10        ;;CCD8|CCD8+CCD8/CCD8\CCD8;
                      db $81,$90,$81,$D0,$83,$14,$81,$50        ;;CCE0|CCE0+CCE0/CCE0\CCE0;
                      db $81,$14,$00,$54,$81,$14,$81,$10        ;;CCE8|CCE8+CCE8/CCE8\CCE8;
                      db $00,$50,$81,$18,$00,$50,$82,$10        ;;CCF0|CCF0+CCF0/CCF0\CCF0;
                      db $01,$50,$10,$81,$18,$03,$10,$50        ;;CCF8|CCF8+CCF8/CCF8\CCF8;
                      db $18,$50,$87,$14,$81,$50,$81,$14        ;;CD00|CD00+CD00/CD00\CD00;
                      db $00,$54,$81,$14,$81,$10,$05,$50        ;;CD08|CD08+CD08/CD08\CD08;
                      db $10,$50,$90,$D0,$90,$82,$D0,$05        ;;CD10|CD10+CD10/CD10\CD10;
                      db $10,$50,$10,$50,$10,$50,$87,$14        ;;CD18|CD18+CD18/CD18\CD18;
                      db $81,$50,$02,$14,$D4,$54,$81,$14        ;;CD20|CD20+CD20/CD20\CD20;
                      db $02,$10,$90,$D0,$81,$90,$85,$10        ;;CD28|CD28+CD28/CD28\CD28;
                      db $81,$D0,$03,$90,$D0,$10,$50,$83        ;;CD30|CD30+CD30/CD30\CD30;
                      db $14,$00,$94,$82,$14,$81,$50,$00        ;;CD38|CD38+CD38/CD38\CD38;
                      db $14,$82,$54,$01,$14,$50,$8E,$90        ;;CD40|CD40+CD40/CD40\CD40;
                      db $00,$10,$87,$14,$81,$50,$82,$14        ;;CD48|CD48+CD48/CD48\CD48;
                      db $01,$54,$14,$81,$50,$8E,$10,$87        ;;CD50|CD50+CD50/CD50\CD50;
                      db $14,$81,$50,$84,$14,$81,$50,$8E        ;;CD58|CD58+CD58/CD58\CD58;
                      db $10,$87,$14,$81,$50,$00,$10,$81        ;;CD60|CD60+CD60/CD60\CD60;
                      db $50,$86,$10,$00,$50,$88,$10,$00        ;;CD68|CD68+CD68/CD68\CD68;
                      db $50,$83,$10,$00,$50,$81,$10,$81        ;;CD70|CD70+CD70/CD70\CD70;
                      db $50,$8B,$10,$00,$50,$83,$10,$00        ;;CD78|CD78+CD78/CD78\CD78;
                      db $D0,$86,$10,$00,$50,$82,$10,$82        ;;CD80|CD80+CD80/CD80\CD80;
                      db $50,$84,$10,$01,$50,$90,$83,$10        ;;CD88|CD88+CD88/CD88\CD88;
                      db $04,$D0,$10,$50,$10,$50,$87,$10        ;;CD90|CD90+CD90/CD90\CD90;
                      db $83,$50,$81,$10,$81,$50,$84,$10        ;;CD98|CD98+CD98/CD98\CD98;
                      db $00,$50,$83,$90,$81,$D0,$01,$10        ;;CDA0|CDA0+CDA0/CDA0\CDA0;
                      db $50,$84,$10,$00,$50,$85,$10,$81        ;;CDA8|CDA8+CDA8/CDA8\CDA8;
                      db $50,$81,$10,$81,$50,$82,$10,$01        ;;CDB0|CDB0+CDB0/CDB0\CDB0;
                      db $D0,$10,$81,$50,$82,$10,$00,$50        ;;CDB8|CDB8+CDB8/CDB8\CDB8;
                      db $81,$10,$00,$50,$83,$10,$01,$90        ;;CDC0|CDC0+CDC0/CDC0\CDC0;
                      db $D0,$83,$90,$00,$D0,$81,$10,$84        ;;CDC8|CDC8+CDC8/CDC8\CDC8;
                      db $50,$83,$10,$82,$50,$82,$10,$00        ;;CDD0|CDD0+CDD0/CDD0\CDD0;
                      db $50,$81,$10,$00,$50,$81,$18,$88        ;;CDD8|CDD8+CDD8/CDD8\CDD8;
                      db $10,$02,$D0,$90,$10,$83,$50,$84        ;;CDE0|CDE0+CDE0/CDE0\CDE0;
                      db $10,$82,$50,$85,$10,$81,$18,$86        ;;CDE8|CDE8+CDE8/CDE8\CDE8;
                      db $90,$83,$10,$01,$50,$10,$82,$50        ;;CDF0|CDF0+CDF0/CDF0\CDF0;
                      db $86,$10,$00,$50,$82,$10,$00,$D0        ;;CDF8|CDF8+CDF8/CDF8\CDF8;
                      db $81,$10,$02,$18,$D8,$50,$84,$10        ;;CE00|CE00+CE00/CE00\CE00;
                      db $82,$90,$81,$10,$01,$50,$10,$82        ;;CE08|CE08+CE08/CE08\CE08;
                      db $50,$85,$10,$00,$D0,$82,$90,$81        ;;CE10|CE10+CE10/CE10\CE10;
                      db $D0,$81,$10,$81,$D8,$00,$50,$86        ;;CE18|CE18+CE18/CE18\CE18;
                      db $10,$82,$90,$02,$D0,$10,$50,$86        ;;CE20|CE20+CE20/CE20\CE20;
                      db $10,$00,$D0,$87,$10,$02,$58,$14        ;;CE28|CE28+CE28/CE28\CE28;
                      db $50,$84,$10,$02,$50,$10,$50,$81        ;;CE30|CE30+CE30/CE30\CE30;
                      db $10,$00,$50,$87,$10,$81,$D0,$85        ;;CE38|CE38+CE38/CE38\CE38;
                      db $10,$03,$50,$D8,$58,$14,$81,$54        ;;CE40|CE40+CE40/CE40\CE40;
                      db $88,$10,$00,$50,$8B,$10,$00,$50        ;;CE48|CE48+CE48/CE48\CE48;
                      db $96,$10,$81,$14,$85,$10,$81,$50        ;;CE50|CE50+CE50/CE50\CE50;
                      db $95,$10,$81,$14,$01,$10,$50,$84        ;;CE58|CE58+CE58/CE58\CE58;
                      db $10,$00,$50,$95,$10,$81,$14,$01        ;;CE60|CE60+CE60/CE60\CE60;
                      db $90,$D0,$81,$90,$82,$10,$00,$50        ;;CE68|CE68+CE68/CE68\CE68;
                      db $91,$10,$81,$50,$81,$10,$81,$14        ;;CE70|CE70+CE70/CE70\CE70;
                      db $01,$10,$50,$81,$10,$83,$D0,$92        ;;CE78|CE78+CE78/CE78\CE78;
                      db $10,$00,$50,$81,$10,$81,$14,$01        ;;CE80|CE80+CE80/CE80\CE80;
                      db $10,$50,$81,$10,$00,$D0,$81,$50        ;;CE88|CE88+CE88/CE88\CE88;
                      db $00,$10,$8E,$18,$86,$10,$81,$14        ;;CE90|CE90+CE90/CE90\CE90;
                      db $82,$10,$81,$D0,$81,$50,$00,$10        ;;CE98|CE98+CE98/CE98\CE98;
                      db $8E,$18,$01,$50,$90,$84,$10,$81        ;;CEA0|CEA0+CEA0/CEA0\CEA0;
                      db $14,$81,$10,$81,$D0,$81,$10,$01        ;;CEA8|CEA8+CEA8/CEA8\CEA8;
                      db $50,$10,$8E,$18,$00,$50,$82,$90        ;;CEB0|CEB0+CEB0/CEB0\CEB0;
                      db $82,$10,$81,$14,$81,$10,$81,$50        ;;CEB8|CEB8+CEB8/CEB8\CEB8;
                      db $81,$10,$01,$50,$10,$86,$18,$00        ;;CEC0|CEC0+CEC0/CEC0\CEC0;
                      db $58,$84,$18,$01,$D8,$98,$82,$50        ;;CEC8|CEC8+CEC8/CEC8\CEC8;
                      db $00,$90,$82,$D0,$81,$14,$81,$10        ;;CED0|CED0+CED0/CED0\CED0;
                      db $81,$50,$81,$10,$01,$50,$10,$86        ;;CED8|CED8+CED8/CED8\CED8;
                      db $18,$00,$58,$83,$18,$81,$D8,$87        ;;CEE0|CEE0+CEE0/CEE0\CEE0;
                      db $50,$81,$14,$81,$10,$81,$50,$81        ;;CEE8|CEE8+CEE8/CEE8\CEE8;
                      db $10,$03,$50,$10,$18,$58,$84,$18        ;;CEF0|CEF0+CEF0/CEF0\CEF0;
                      db $00,$58,$82,$18,$81,$58,$81,$14        ;;CEF8|CEF8+CEF8/CEF8\CEF8;
                      db $86,$50,$81,$14,$82,$10,$00,$50        ;;CF00|CF00+CF00/CF00\CF00;
                      db $81,$10,$03,$50,$10,$98,$D8,$83        ;;CF08|CF08+CF08/CF08\CF08;
                      db $98,$85,$18,$01,$58,$14,$81,$54        ;;CF10|CF10+CF10/CF10\CF10;
                      db $85,$50,$81,$14,$81,$10,$01,$D0        ;;CF18|CF18+CF18/CF18\CF18;
                      db $10,$81,$50,$82,$18,$00,$58,$83        ;;CF20|CF20+CF20/CF20\CF20;
                      db $18,$01,$98,$D8,$81,$18,$01,$98        ;;CF28|CF28+CF28/CF28\CF28;
                      db $D8,$81,$58,$81,$18,$81,$58,$83        ;;CF30|CF30+CF30/CF30\CF30;
                      db $50,$81,$14,$82,$D0,$00,$10,$84        ;;CF38|CF38+CF38/CF38\CF38;
                      db $18,$00,$58,$8A,$18,$00,$58,$83        ;;CF40|CF40+CF40/CF40\CF40;
                      db $18,$00,$58,$82,$50,$81,$14,$82        ;;CF48|CF48+CF48/CF48\CF48;
                      db $50,$00,$10,$84,$18,$00,$58,$84        ;;CF50|CF50+CF50/CF50\CF50;
                      db $18,$00,$58,$82,$18,$00,$58,$82        ;;CF58|CF58+CF58/CF58\CF58;
                      db $18,$00,$58,$85,$18,$81,$14,$03        ;;CF60|CF60+CF60/CF60\CF60;
                      db $50,$10,$50,$10,$81,$98,$81,$18        ;;CF68|CF68+CF68/CF68\CF68;
                      db $01,$98,$D8,$83,$98,$81,$18,$82        ;;CF70|CF70+CF70/CF70\CF70;
                      db $98,$00,$D8,$82,$98,$00,$D8,$81        ;;CF78|CF78+CF78/CF78\CF78;
                      db $98,$00,$D8,$82,$18,$81,$14,$04        ;;CF80|CF80+CF80/CF80\CF80;
                      db $50,$10,$50,$10,$50,$81,$98,$86        ;;CF88|CF88+CF88/CF88\CF88;
                      db $18,$01,$98,$D8,$8A,$18,$81,$D8        ;;CF90|CF90+CF90/CF90\CF90;
                      db $00,$18,$81,$14,$82,$50,$02,$10        ;;CF98|CF98+CF98/CF98\CF98;
                      db $14,$54,$82,$98,$01,$10,$50,$86        ;;CFA0|CFA0+CFA0/CFA0\CFA0;
                      db $18,$01,$10,$50,$81,$18,$04,$10        ;;CFA8|CFA8+CFA8/CFA8\CFA8;
                      db $50,$18,$10,$50,$82,$18,$81,$14        ;;CFB0|CFB0+CFB0/CFB0\CFB0;
                      db $04,$50,$10,$50,$10,$18,$81,$54        ;;CFB8|CFB8+CFB8/CFB8\CFB8;
                      db $00,$50,$81,$10,$81,$50,$81,$18        ;;CFC0|CFC0+CFC0/CFC0\CFC0;
                      db $84,$10,$00,$50,$82,$10,$00,$50        ;;CFC8|CFC8+CFC8/CFC8\CFC8;
                      db $81,$10,$00,$50,$82,$18,$81,$14        ;;CFD0|CFD0+CFD0/CFD0\CFD0;
                      db $82,$50,$03,$10,$94,$18,$54,$83        ;;CFD8|CFD8+CFD8/CFD8\CFD8;
                      db $10,$00,$50,$8D,$10,$00,$50,$82        ;;CFE0|CFE0+CFE0/CFE0\CFE0;
                      db $10,$81,$14,$02,$50,$10,$50,$81        ;;CFE8|CFE8+CFE8/CFE8\CFE8;
                      db $14,$00,$18,$97,$10,$81,$14,$9D        ;;CFF0|CFF0+CFF0/CFF0\CFF0;
                      db $10,$81,$50,$9D,$10,$81,$50,$9D        ;;CFF8|CFF8+CFF8/CFF8\CFF8;
                      db $10,$81,$50,$9D,$10,$81,$50,$9D        ;;D000|D000+D000/D000\D000;
                      db $10,$81,$50,$82,$10,$00,$14,$81        ;;D008|D008+D008/D008\D008;
                      db $10,$81,$14,$81,$10,$82,$14,$81        ;;D010|D010+D010/D010\D010;
                      db $10,$00,$14,$81,$10,$00,$14,$81        ;;D018|D018+D018/D018\D018;
                      db $10,$00,$14,$81,$10,$00,$14,$88        ;;D020|D020+D020/D020\D020;
                      db $10,$08,$14,$10,$14,$10,$14,$10        ;;D028|D028+D028/D028\D028;
                      db $14,$10,$14,$82,$10,$0A,$14,$10        ;;D030|D030+D030/D030\D030;
                      db $14,$10,$14,$10,$14,$10,$14,$10        ;;D038|D038+D038/D038\D038;
                      db $14,$88,$10,$00,$14,$82,$10,$04        ;;D040|D040+D040/D040\D040;
                      db $14,$10,$14,$10,$14,$82,$10,$00        ;;D048|D048+D048/D048\D048;
                      db $14,$82,$10,$06,$14,$10,$14,$10        ;;D050|D050+D050/D050\D050;
                      db $14,$10,$14,$89,$10,$00,$14,$81        ;;D058|D058+D058/D058\D058;
                      db $10,$03,$14,$10,$14,$10,$82,$14        ;;D060|D060+D060/D060\D060;
                      db $01,$10,$14,$82,$10,$01,$14,$10        ;;D068|D068+D068/D068\D068;
                      db $82,$14,$01,$10,$14,$8A,$10,$01        ;;D070|D070+D070/D070\D070;
                      db $14,$10,$81,$14,$81,$10,$00,$14        ;;D078|D078+D078/D078\D078;
                      db $82,$10,$00,$14,$82,$10,$06,$14        ;;D080|D080+D080/D080\D080;
                      db $10,$14,$10,$14,$10,$14,$88,$10        ;;D088|D088+D088/D088\D088;
                      db $04,$14,$10,$14,$10,$14,$82,$10        ;;D090|D090+D090/D090\D090;
                      db $00,$14,$82,$10,$0A,$14,$10,$14        ;;D098|D098+D098/D098\D098;
                      db $10,$14,$10,$14,$10,$14,$10,$14        ;;D0A0|D0A0+D0A0/D0A0\D0A0;
                      db $86,$10,$81,$90,$87,$10,$82,$18        ;;D0A8|D0A8+D0A8/D0A8\D0A8;
                      db $81,$58,$00,$54,$83,$14,$81,$54        ;;D0B0|D0B0+D0B0/D0B0\D0B0;
                      db $00,$50,$81,$10,$00,$50,$88,$10        ;;D0B8|D0B8+D0B8/D0B8\D0B8;
                      db $00,$50,$83,$10,$85,$18,$00,$58        ;;D0C0|D0C0+D0C0/D0C0\D0C0;
                      db $85,$18,$81,$54,$02,$10,$90,$D0        ;;D0C8|D0C8+D0C8/D0C8\D0C8;
                      db $87,$10,$81,$50,$8A,$18,$00,$94        ;;D0D0|D0D0+D0D0/D0D0\D0D0;
                      db $85,$18,$82,$10,$00,$50,$87,$10        ;;D0D8|D0D8+D0D8/D0D8\D0D8;
                      db $81,$50,$88,$18,$00,$58,$81,$14        ;;D0E0|D0E0+D0E0/D0E0\D0E0;
                      db $85,$18,$82,$10,$00,$50,$88,$10        ;;D0E8|D0E8+D0E8/D0E8\D0E8;
                      db $81,$50,$85,$18,$03,$58,$18,$58        ;;D0F0|D0F0+D0F0/D0F0\D0F0;
                      db $14,$86,$18,$82,$10,$00,$50,$89        ;;D0F8|D0F8+D0F8/D0F8\D0F8;
                      db $10,$81,$50,$83,$18,$03,$98,$D8        ;;D100|D100+D100/D100\D100;
                      db $98,$58,$87,$18,$83,$10,$00,$50        ;;D108|D108+D108/D108\D108;
                      db $89,$10,$03,$50,$18,$10,$50,$81        ;;D110|D110+D110/D110\D110;
                      db $18,$01,$58,$18,$81,$58,$86,$18        ;;D118|D118+D118/D118\D118;
                      db $01,$10,$90,$81,$10,$00,$D0,$89        ;;D120|D120+D120/D120\D120;
                      db $10,$00,$50,$81,$10,$81,$50,$05        ;;D128|D128+D128/D128\D128;
                      db $18,$58,$18,$10,$50,$58,$81,$18        ;;D130|D130+D130/D130\D130;
                      db $85,$10,$01,$50,$90,$8E,$10,$00        ;;D138|D138+D138/D138\D138;
                      db $50,$83,$10,$00,$50,$87,$10,$01        ;;D140|D140+D140/D140\D140;
                      db $50,$90,$9B,$10,$82,$90,$87,$10        ;;D148|D148+D148/D148\D148;
                      db $81,$1C,$00,$5C,$81,$1C,$81,$5C        ;;D150|D150+D150/D150\D150;
                      db $81,$1C,$81,$5C,$00,$10,$81,$1C        ;;D158|D158+D158/D158\D158;
                      db $81,$5C,$01,$10,$50,$81,$1C,$81        ;;D160|D160+D160/D160\D160;
                      db $5C,$81,$1C,$81,$5C,$01,$10,$50        ;;D168|D168+D168/D168\D168;
                      db $81,$10,$81,$1C,$82,$10,$81,$1C        ;;D170|D170+D170/D170\D170;
                      db $81,$5C,$81,$1C,$81,$5C,$00,$10        ;;D178|D178+D178/D178\D178;
                      db $81,$1C,$81,$5C,$01,$10,$50,$81        ;;D180|D180+D180/D180\D180;
                      db $1C,$81,$5C,$81,$1C,$81,$5C,$01        ;;D188|D188+D188/D188\D188;
                      db $10,$50,$81,$10,$83,$1C,$81,$5C        ;;D190|D190+D190/D190\D190;
                      db $00,$1C,$81,$5C,$81,$1C,$81,$5C        ;;D198|D198+D198/D198\D198;
                      db $00,$10,$81,$1C,$81,$5C,$01,$10        ;;D1A0|D1A0+D1A0/D1A0\D1A0;
                      db $50,$81,$1C,$81,$5C,$81,$1C,$00        ;;D1A8|D1A8+D1A8/D1A8\D1A8;
                      db $5C,$81,$1C,$81,$5C,$00,$10,$83        ;;D1B0|D1B0+D1B0/D1B0\D1B0;
                      db $1C,$81,$5C,$84,$10,$00,$50,$86        ;;D1B8|D1B8+D1B8/D1B8\D1B8;
                      db $10,$00,$50,$81,$1C,$81,$5C,$82        ;;D1C0|D1C0+D1C0/D1C0\D1C0;
                      db $10,$81,$1C,$81,$5C,$00,$10,$83        ;;D1C8|D1C8+D1C8/D1C8\D1C8;
                      db $1C,$81,$5C,$81,$1C,$81,$5C,$01        ;;D1D0|D1D0+D1D0/D1D0\D1D0;
                      db $10,$50,$82,$10,$06,$50,$10,$50        ;;D1D8|D1D8+D1D8/D1D8\D1D8;
                      db $10,$50,$10,$50,$81,$10,$81,$1C        ;;D1E0|D1E0+D1E0/D1E0\D1E0;
                      db $81,$5C,$03,$1C,$5C,$1C,$10,$83        ;;D1E8|D1E8+D1E8/D1E8\D1E8;
                      db $1C,$81,$5C,$81,$1C,$81,$5C,$84        ;;D1F0|D1F0+D1F0/D1F0\D1F0;
                      db $10,$08,$50,$10,$50,$90,$D0,$10        ;;D1F8|D1F8+D1F8/D1F8\D1F8;
                      db $50,$10,$50,$81,$1C,$81,$5C,$83        ;;D200|D200+D200/D200\D200;
                      db $10,$83,$1C,$81,$5C,$81,$1C,$81        ;;D208|D208+D208/D208\D208;
                      db $5C,$82,$10,$02,$50,$10,$50,$86        ;;D210|D210+D210/D210\D210;
                      db $10,$00,$50,$81,$1C,$81,$5C,$81        ;;D218|D218+D218/D218\D218;
                      db $1C,$01,$5C,$10,$83,$1C,$81,$5C        ;;D220|D220+D220/D220\D220;
                      db $81,$1C,$81,$5C,$82,$10,$02,$50        ;;D228|D228+D228/D228\D228;
                      db $10,$50,$81,$1C,$81,$5C,$03,$10        ;;D230|D230+D230/D230\D230;
                      db $50,$10,$50,$81,$1C,$81,$5C,$81        ;;D238|D238+D238/D238\D238;
                      db $1C,$01,$5C,$10,$83,$1C,$81,$5C        ;;D240|D240+D240/D240\D240;
                      db $81,$1C,$81,$5C,$82,$10,$02,$50        ;;D248|D248+D248/D248\D248;
                      db $10,$50,$81,$1C,$81,$5C,$03,$10        ;;D250|D250+D250/D250\D250;
                      db $50,$10,$50,$81,$1C,$81,$5C,$81        ;;D258|D258+D258/D258\D258;
                      db $1C,$01,$5C,$10,$83,$1C,$81,$5C        ;;D260|D260+D260/D260\D260;
                      db $81,$1C,$81,$5C,$82,$10,$02,$50        ;;D268|D268+D268/D268\D268;
                      db $10,$50,$81,$1C,$81,$5C,$83,$10        ;;D270|D270+D270/D270\D270;
                      db $81,$1C,$81,$5C,$83,$10,$83,$1C        ;;D278|D278+D278/D278\D278;
                      db $00,$5C,$81,$1C,$81,$5C,$81,$10        ;;D280|D280+D280/D280\D280;
                      db $00,$50,$82,$10,$02,$50,$10,$50        ;;D288|D288+D288/D288\D288;
                      db $81,$10,$09,$50,$10,$14,$54,$10        ;;D290|D290+D290/D290\D290;
                      db $50,$10,$50,$10,$50,$81,$10,$81        ;;D298|D298+D298/D298\D298;
                      db $1C,$82,$10,$81,$1C,$81,$5C,$81        ;;D2A0|D2A0+D2A0/D2A0\D2A0;
                      db $10,$00,$50,$82,$10,$02,$50,$10        ;;D2A8|D2A8+D2A8/D2A8\D2A8;
                      db $50,$81,$10,$09,$50,$10,$94,$D4        ;;D2B0|D2B0+D2B0/D2B0\D2B0;
                      db $10,$50,$10,$50,$10,$50,$81,$10        ;;D2B8|D2B8+D2B8/D2B8\D2B8;
                      db $81,$18,$81,$1C,$81,$5C,$00,$1C        ;;D2C0|D2C0+D2C0/D2C0\D2C0;
                      db $81,$5C,$83,$10,$00,$50,$83,$10        ;;D2C8|D2C8+D2C8/D2C8\D2C8;
                      db $00,$50,$81,$10,$00,$50,$82,$10        ;;D2D0|D2D0+D2D0/D2D0\D2D0;
                      db $00,$50,$81,$1C,$81,$5C,$83,$10        ;;D2D8|D2D8+D2D8/D2D8\D2D8;
                      db $81,$1C,$81,$5C,$01,$10,$50,$84        ;;D2E0|D2E0+D2E0/D2E0\D2E0;
                      db $10,$00,$50,$81,$10,$02,$50,$10        ;;D2E8|D2E8+D2E8/D2E8\D2E8;
                      db $50,$81,$10,$00,$50,$82,$10,$00        ;;D2F0|D2F0+D2F0/D2F0\D2F0;
                      db $50,$81,$1C,$81,$5C,$83,$10,$81        ;;D2F8|D2F8+D2F8/D2F8\D2F8;
                      db $1C,$81,$5C,$05,$10,$50,$10,$50        ;;D300|D300+D300/D300\D300;
                      db $10,$50,$83,$10,$00,$50,$81,$10        ;;D308|D308+D308/D308\D308;
                      db $00,$50,$81,$10,$00,$50,$81,$1C        ;;D310|D310+D310/D310\D310;
                      db $81,$5C,$00,$1C,$81,$5C,$81,$10        ;;D318|D318+D318/D318\D318;
                      db $81,$18,$01,$10,$50,$81,$1C,$81        ;;D320|D320+D320/D320\D320;
                      db $5C,$03,$10,$50,$10,$50,$81,$1C        ;;D328|D328+D328/D328\D328;
                      db $81,$5C,$82,$10,$00,$50,$81,$10        ;;D330|D330+D330/D330\D330;
                      db $00,$50,$81,$1C,$81,$5C,$81,$10        ;;D338|D338+D338/D338\D338;
                      db $00,$50,$84,$10,$00,$50,$81,$1C        ;;D340|D340+D340/D340\D340;
                      db $81,$5C,$03,$10,$50,$10,$50,$81        ;;D348|D348+D348/D348\D348;
                      db $1C,$81,$5C,$03,$10,$50,$10,$50        ;;D350|D350+D350/D350\D350;
                      db $81,$1C,$81,$5C,$00,$1C,$81,$5C        ;;D358|D358+D358/D358\D358;
                      db $81,$10,$00,$50,$85,$10,$81,$1C        ;;D360|D360+D360/D360\D360;
                      db $81,$5C,$03,$10,$50,$10,$50,$81        ;;D368|D368+D368/D368\D368;
                      db $1C,$81,$5C,$03,$10,$50,$10,$50        ;;D370|D370+D370/D370\D370;
                      db $81,$1C,$81,$5C,$01,$10,$50,$81        ;;D378|D378+D378/D378\D378;
                      db $1C,$81,$5C,$85,$10,$00,$50,$82        ;;D380|D380+D380/D380\D380;
                      db $10,$02,$50,$10,$50,$81,$10,$00        ;;D388|D388+D388/D388\D388;
                      db $50,$81,$1C,$81,$5C,$81,$10,$81        ;;D390|D390+D390/D390\D390;
                      db $1C,$81,$5C,$01,$10,$50,$81,$1C        ;;D398|D398+D398/D398\D398;
                      db $81,$5C,$81,$10,$81,$18,$81,$10        ;;D3A0|D3A0+D3A0/D3A0\D3A0;
                      db $00,$50,$82,$10,$02,$50,$10,$50        ;;D3A8|D3A8+D3A8/D3A8\D3A8;
                      db $81,$10,$00,$50,$81,$1C,$81,$5C        ;;D3B0|D3B0+D3B0/D3B0\D3B0;
                      db $01,$10,$50,$81,$1C,$81,$5C,$01        ;;D3B8|D3B8+D3B8/D3B8\D3B8;
                      db $10,$50,$81,$1C,$81,$5C,$81,$10        ;;D3C0|D3C0+D3C0/D3C0\D3C0;
                      db $81,$18,$00,$10,$81,$1C,$81,$5C        ;;D3C8|D3C8+D3C8/D3C8\D3C8;
                      db $81,$10,$81,$1C,$81,$5C,$00,$10        ;;D3D0|D3D0+D3D0/D3D0\D3D0;
                      db $81,$1C,$81,$5C,$01,$10,$50,$81        ;;D3D8|D3D8+D3D8/D3D8\D3D8;
                      db $1C,$81,$5C,$01,$10,$50,$87,$10        ;;D3E0|D3E0+D3E0/D3E0\D3E0;
                      db $83,$14,$00,$50,$83,$10,$82,$50        ;;D3E8|D3E8+D3E8/D3E8\D3E8;
                      db $81,$10,$8F,$14,$84,$10,$00,$14        ;;D3F0|D3F0+D3F0/D3F0\D3F0;
                      db $81,$10,$00,$14,$82,$10,$82,$14        ;;D3F8|D3F8+D3F8/D3F8\D3F8;
                      db $81,$10,$00,$14,$81,$10,$05,$14        ;;D400|D400+D400/D400\D400;
                      db $10,$14,$10,$14,$10,$82,$14,$82        ;;D408|D408+D408/D408\D408;
                      db $10,$81,$90,$A5,$10,$01,$54,$14        ;;D410|D410+D410/D410\D410;
                      db $83,$10,$01,$54,$14,$83,$10,$01        ;;D418|D418+D418/D418\D418;
                      db $54,$14,$83,$10,$01,$54,$14,$8B        ;;D420|D420+D420/D420\D420;
                      db $10,$01,$D4,$94,$83,$10,$01,$D4        ;;D428|D428+D428/D428\D428;
                      db $94,$83,$10,$01,$D4,$94,$83,$10        ;;D430|D430+D430/D430\D430;
                      db $01,$D4,$94,$C8,$10,$82,$50,$01        ;;D438|D438+D438/D438\D438;
                      db $10,$50,$83,$10,$01,$54,$14,$83        ;;D440|D440+D440/D440\D440;
                      db $10,$01,$54,$14,$83,$10,$01,$54        ;;D448|D448+D448/D448\D448;
                      db $14,$87,$10,$00,$90,$82,$D0,$01        ;;D450|D450+D450/D450\D450;
                      db $90,$D0,$83,$10,$01,$D4,$94,$83        ;;D458|D458+D458/D458\D458;
                      db $10,$01,$D4,$94,$83,$10,$01,$D4        ;;D460|D460+D460/D460\D460;
                      db $94,$C5,$10,$83,$1C,$00,$14,$88        ;;D468|D468+D468/D468\D468;
                      db $1C,$01,$18,$58,$81,$1C,$01,$54        ;;D470|D470+D470/D470\D470;
                      db $14,$89,$1C,$81,$10,$81,$1C,$81        ;;D478|D478+D478/D478\D478;
                      db $14,$86,$1C,$08,$14,$1C,$18,$10        ;;D480|D480+D480/D480\D480;
                      db $50,$58,$1C,$D4,$94,$82,$1C,$00        ;;D488|D488+D488/D488\D488;
                      db $14,$85,$1C,$81,$10,$00,$1C,$82        ;;D490|D490+D490/D490\D490;
                      db $14,$82,$1C,$01,$54,$14,$82,$1C        ;;D498|D498+D498/D498\D498;
                      db $00,$18,$81,$10,$81,$50,$00,$58        ;;D4A0|D4A0+D4A0/D4A0\D4A0;
                      db $8B,$1C,$81,$10,$00,$1C,$82,$14        ;;D4A8|D4A8+D4A8/D4A8\D4A8;
                      db $82,$1C,$01,$D4,$94,$82,$1C,$81        ;;D4B0|D4B0+D4B0/D4B0\D4B0;
                      db $10,$00,$90,$81,$10,$03,$50,$58        ;;D4B8|D4B8+D4B8/D4B8\D4B8;
                      db $1C,$14,$83,$1C,$01,$54,$14,$82        ;;D4C0|D4C0+D4C0/D4C0\D4C0;
                      db $1C,$81,$10,$8A,$1C,$00,$18,$82        ;;D4C8|D4C8+D4C8/D4C8\D4C8;
                      db $10,$00,$D0,$81,$10,$00,$50,$85        ;;D4D0|D4D0+D4D0/D4D0\D4D0;
                      db $1C,$01,$D4,$94,$82,$1C,$81,$10        ;;D4D8|D4D8+D4D8/D4D8\D4D8;
                      db $82,$1C,$87,$18,$84,$10,$02,$D0        ;;D4E0|D4E0+D4E0/D4E0\D4E0;
                      db $10,$50,$86,$18,$00,$58,$82,$1C        ;;D4E8|D4E8+D4E8/D4E8\D4E8;
                      db $81,$10,$02,$54,$14,$1C,$81,$10        ;;D4F0|D4F0+D4F0/D4F0\D4F0;
                      db $00,$50,$84,$10,$00,$50,$84,$10        ;;D4F8|D4F8+D4F8/D4F8\D4F8;
                      db $02,$D0,$10,$50,$84,$10,$81,$50        ;;D500|D500+D500/D500\D500;
                      db $82,$1C,$81,$10,$05,$D4,$94,$1C        ;;D508|D508+D508/D508\D508;
                      db $10,$90,$D0,$84,$90,$00,$D0,$85        ;;D510|D510+D510/D510\D510;
                      db $10,$01,$90,$D0,$84,$10,$01,$D0        ;;D518|D518+D518/D518\D518;
                      db $50,$82,$1C,$81,$10,$82,$1C,$00        ;;D520|D520+D520/D520\D520;
                      db $50,$87,$10,$00,$18,$83,$10,$00        ;;D528|D528+D528/D528\D528;
                      db $18,$84,$10,$02,$50,$90,$D0,$83        ;;D530|D530+D530/D530\D530;
                      db $1C,$81,$10,$04,$1C,$14,$1C,$50        ;;D538|D538+D538/D538\D538;
                      db $90,$85,$10,$00,$18,$85,$10,$00        ;;D540|D540+D540/D540\D540;
                      db $18,$82,$10,$03,$50,$90,$D0,$DC        ;;D548|D548+D548/D548\D548;
                      db $83,$1C,$81,$10,$82,$1C,$02,$50        ;;D550|D550+D550/D550\D550;
                      db $10,$50,$82,$10,$02,$50,$10,$18        ;;D558|D558+D558/D558\D558;
                      db $85,$10,$00,$18,$82,$10,$01,$90        ;;D560|D560+D560/D560\D560;
                      db $D0,$85,$1C,$81,$10,$82,$18,$00        ;;D568|D568+D568/D568\D568;
                      db $50,$81,$10,$00,$90,$81,$10,$00        ;;D570|D570+D570/D570\D570;
                      db $D0,$81,$10,$00,$18,$83,$10,$00        ;;D578|D578+D578/D578\D578;
                      db $18,$81,$10,$06,$90,$D0,$10,$5C        ;;D580|D580+D580/D580\D580;
                      db $1C,$5C,$1C,$82,$18,$84,$10,$02        ;;D588|D588+D588/D588\D588;
                      db $50,$10,$50,$88,$10,$00,$50,$83        ;;D590|D590+D590/D590\D590;
                      db $10,$00,$50,$81,$10,$00,$5C,$82        ;;D598|D598+D598/D598\D598;
                      db $1C,$82,$18,$83,$10,$06,$18,$50        ;;D5A0|D5A0+D5A0/D5A0\D5A0;
                      db $10,$D0,$10,$50,$90,$84,$10,$00        ;;D5A8|D5A8+D5A8/D5A8\D5A8;
                      db $90,$84,$10,$00,$50,$81,$10,$01        ;;D5B0|D5B0+D5B0/D5B0\D5B0;
                      db $50,$9C,$81,$1C,$84,$10,$81,$18        ;;D5B8|D5B8+D5B8/D5B8\D5B8;
                      db $01,$10,$50,$81,$10,$01,$50,$90        ;;D5C0|D5C0+D5C0/D5C0\D5C0;
                      db $85,$10,$01,$D0,$90,$81,$D0,$85        ;;D5C8|D5C8+D5C8/D5C8\D5C8;
                      db $10,$02,$50,$5C,$1C,$82,$18,$82        ;;D5D0|D5D0+D5D0/D5D0\D5D0;
                      db $10,$81,$18,$03,$D0,$10,$50,$90        ;;D5D8|D5D8+D5D8/D5D8\D5D8;
                      db $85,$10,$01,$D0,$1C,$82,$90,$81        ;;D5E0|D5E0+D5E0/D5E0\D5E0;
                      db $D0,$85,$10,$00,$9C,$8F,$10,$05        ;;D5E8|D5E8+D5E8/D5E8\D5E8;
                      db $D0,$9C,$DC,$1C,$50,$10,$81,$90        ;;D5F0|D5F0+D5F0/D5F0\D5F0;
                      db $00,$10,$81,$D0,$82,$10,$02,$50        ;;D5F8|D5F8+D5F8/D5F8\D5F8;
                      db $10,$50,$87,$10,$01,$90,$D0,$81        ;;D600|D600+D600/D600\D600;
                      db $10,$00,$D0,$81,$9C,$83,$1C,$00        ;;D608|D608+D608/D608\D608;
                      db $50,$81,$10,$01,$50,$D0,$81,$10        ;;D610|D610+D610/D610\D610;
                      db $81,$D0,$03,$10,$D0,$10,$50,$83        ;;D618|D618+D618/D618\D618;
                      db $10,$00,$18,$84,$10,$02,$D0,$9C        ;;D620|D620+D620/D620\D620;
                      db $DC,$82,$1C,$00,$5C,$81,$1C,$00        ;;D628|D628+D628/D628\D628;
                      db $50,$82,$10,$83,$D0,$00,$90,$82        ;;D630|D630+D630/D630\D630;
                      db $10,$00,$1C,$83,$10,$81,$18,$81        ;;D638|D638+D638/D638\D638;
                      db $90,$81,$9C,$02,$DC,$1C,$5C,$82        ;;D640|D640+D640/D640\D640;
                      db $1C,$00,$5C,$81,$1C,$82,$10,$00        ;;D648|D648+D648/D648\D648;
                      db $50,$83,$10,$00,$50,$81,$90,$01        ;;D650|D650+D650/D650\D650;
                      db $DC,$1C,$85,$10,$02,$50,$10,$5C        ;;D658|D658+D658/D658\D658;
                      db $86,$1C,$00,$5C,$81,$1C,$00,$50        ;;D660|D660+D660/D660\D660;
                      db $86,$10,$00,$50,$81,$10,$81,$1C        ;;D668|D668+D668/D668\D668;
                      db $89,$10,$00,$50,$96,$10,$81,$14        ;;D670|D670+D670/D670\D670;
DATA_04D678:          db $00,$C0,$C0,$C0,$30,$C0,$C0,$00        ;;D678|D678+D678/D678\D678;
                      db $C0,$20,$30,$C0,$C0,$C0,$C0,$D0        ;;D680|D680+D680/D680\D680;
                      db $40,$40,$40,$D0,$40,$80,$80,$00        ;;D688|D688+D688/D688\D688;
                      db $00,$00,$00,$40,$00,$80,$20,$80        ;;D690|D690+D690/D690\D690;
                      db $40,$40,$80,$60,$90,$00,$00,$C0        ;;D698|D698+D698/D698\D698;
                      db $00,$00,$00,$C0,$40,$20,$40,$C0        ;;D6A0|D6A0+D6A0/D6A0\D6A0;
                      db $E0,$C0,$00,$C0,$00,$00,$C0,$20        ;;D6A8|D6A8+D6A8/D6A8\D6A8;
                      db $80,$80,$80,$80,$30,$40,$E0,$00        ;;D6B0|D6B0+D6B0/D6B0\D6B0;
                      db $40,$E0,$E0,$D0,$70,$FF,$40,$90        ;;D6B8|D6B8+D6B8/D6B8\D6B8;
                      db $55,$80,$80,$80,$80,$00,$C0,$C0        ;;D6C0|D6C0+D6C0/D6C0\D6C0;
                      db $C0,$C0,$40,$00,$80,$A0,$30,$AA        ;;D6C8|D6C8+D6C8/D6C8\D6C8;
                      db $60,$D0,$80,$00,$55,$55,$00,$00        ;;D6D0|D6D0+D6D0/D6D0\D6D0;
                      db $AA,$55,$FF,$FF,$00,$00,$00,$00        ;;D6D8|D6D8+D6D8/D6D8\D6D8;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;D6E0|D6E0+D6E0/D6E0\D6E0;
                      db $00                                    ;;D6E8|D6E8+D6E8/D6E8\D6E8;
                                                                ;;                        ;
CODE_04D6E9:          REP #$30                                  ;;D6E9|D6E9+D6E9/D6E9\D6E9; Index (16 bit) Accum (16 bit) 
                      STZ.B !Layer1YPos                         ;;D6EB|D6EB+D6EB/D6EB\D6EB;
                      LDA.W #$FFFF                              ;;D6ED|D6ED+D6ED/D6ED\D6ED;
                      STA.B !Layer1PrevTileUp                   ;;D6F0|D6F0+D6F0/D6F0\D6F0;
                      STA.B !Layer1PrevTileDown                 ;;D6F2|D6F2+D6F2/D6F2\D6F2;
                      LDA.W #$0202                              ;;D6F4|D6F4+D6F4/D6F4\D6F4;
                      STA.B !Layer1ScrollDir                    ;;D6F7|D6F7+D6F7/D6F7\D6F7;
                      LDA.W !PlayerTurnOW                       ;;D6F9|D6F9+D6F9/D6F9\D6F9;
                      LSR A                                     ;;D6FC|D6FC+D6FC/D6FC\D6FC;
                      LSR A                                     ;;D6FD|D6FD+D6FD/D6FD\D6FD;
                      AND.W #$00FF                              ;;D6FE|D6FE+D6FE/D6FE\D6FE;
                      TAX                                       ;;D701|D701+D701/D701\D701;
                      LDA.W !OWPlayerSubmap,X                   ;;D702|D702+D702/D702\D702;
                      AND.W #$000F                              ;;D705|D705+D705/D705\D705;
                      BEQ CODE_04D714                           ;;D708|D708+D708/D708\D708;
                      LDA.W #$0020                              ;;D70A|D70A+D70A/D70A\D70A;
                      STA.B !Layer1TileDown                     ;;D70D|D70D+D70D/D70D\D70D;
                      LDA.W #$0200                              ;;D70F|D70F+D70F/D70F\D70F;
                      STA.B !Layer1YPos                         ;;D712|D712+D712/D712\D712;
CODE_04D714:          JSL CODE_05881A                           ;;D714|D714+D714/D714\D714;
                      JSL CODE_0087AD                           ;;D718|D718+D718/D718\D718;
                      REP #$30                                  ;;D71C|D71C+D71C/D71C\D71C; Index (16 bit) Accum (16 bit) 
                      INC.B !Layer1TileDown                     ;;D71E|D71E+D71E/D71E\D71E;
                      LDA.B !Layer1YPos                         ;;D720|D720+D720/D720\D720;
                      CLC                                       ;;D722|D722+D722/D722\D722;
                      ADC.W #$0010                              ;;D723|D723+D723/D723\D723;
                      STA.B !Layer1YPos                         ;;D726|D726+D726/D726\D726;
                      AND.W #$01FF                              ;;D728|D728+D728/D728\D728;
                      BNE CODE_04D714                           ;;D72B|D72B+D72B/D72B\D72B;
                      LDA.B !Layer2YPos                         ;;D72D|D72D+D72D/D72D\D72D;
                      STA.B !Layer1YPos                         ;;D72F|D72F+D72F/D72F\D72F;
                      STZ.B !Layer1TileDown                     ;;D731|D731+D731/D731\D731;
                      STZ.W !LevelModeSetting                   ;;D733|D733+D733/D733\D733;
                      STZ.B !ScreenMode                         ;;D736|D736+D736/D736\D736;
                      LDA.W #$FFFF                              ;;D738|D738+D738/D738\D738;
                      STA.B !Layer1PrevTileUp                   ;;D73B|D73B+D73B/D73B\D73B;
                      STA.B !Layer1PrevTileDown                 ;;D73D|D73D+D73D/D73D\D73D;
                      SEP #$30                                  ;;D73F|D73F+D73F/D73F\D73F; Index (8 bit) Accum (8 bit) 
                      LDA.B #$80                                ;;D741|D741+D741/D741\D741;
                      STA.W !HW_VMAINC                          ;;D743|D743+D743/D743\D743; VRAM Address Increment Value
                      STZ.W !HW_VMADD                           ;;D746|D746+D746/D746\D746; Address for VRAM Read/Write (Low Byte)
                      LDA.B #$30                                ;;D749|D749+D749/D749\D749;
                      STA.W !HW_VMADD+1                         ;;D74B|D74B+D74B/D74B\D74B; Address for VRAM Read/Write (High Byte)
                      LDX.B #$06                                ;;D74E|D74E+D74E/D74E\D74E;
                    - LDA.L DATA_04DAB3,X                       ;;D750|D750+D750/D750\D750;
                      STA.W !HW_DMAPARAM+$10,X                  ;;D754|D754+D754/D754\D754;
                      DEX                                       ;;D757|D757+D757/D757\D757;
                      BPL -                                     ;;D758|D758+D758/D758\D758;
                      LDA.W !PlayerTurnOW                       ;;D75A|D75A+D75A/D75A\D75A;
                      LSR A                                     ;;D75D|D75D+D75D/D75D\D75D;
                      LSR A                                     ;;D75E|D75E+D75E/D75E\D75E;
                      TAX                                       ;;D75F|D75F+D75F/D75F\D75F;
                      LDA.W !OWPlayerSubmap,X                   ;;D760|D760+D760/D760\D760;
                      BEQ +                                     ;;D763|D763+D763/D763\D763;
                      LDA.B #$60                                ;;D765|D765+D765/D765\D765;
                      STA.W !HW_DMAADDR+$11                     ;;D767|D767+D767/D767\D767; A Address (High Byte)
                    + LDA.B #$02                                ;;D76A|D76A+D76A/D76A\D76A;
                      STA.W !HW_MDMAEN                          ;;D76C|D76C+D76C/D76C\D76C; Regular DMA Channel Enable
                      RTL                                       ;;D76F|D76F+D76F/D76F\D76F; Return 
                                                                ;;                        ;
CODE_04D770:          STA.L !Map16TilesHigh,X                   ;;D770|D770+D770/D770\D770;
                      STA.L !Map16TilesHigh+$1B0,X              ;;D774|D774+D774/D774\D774;
                      STA.L !Map16TilesHigh+$360,X              ;;D778|D778+D778/D778\D778;
                      STA.L !Map16TilesHigh+$510,X              ;;D77C|D77C+D77C/D77C\D77C;
                      STA.L !Map16TilesHigh+$6C0,X              ;;D780|D780+D780/D780\D780;
                      STA.L !Map16TilesHigh+$870,X              ;;D784|D784+D784/D784\D784;
                      STA.L !Map16TilesHigh+$A20,X              ;;D788|D788+D788/D788\D788;
                      STA.L !Map16TilesHigh+$BD0,X              ;;D78C|D78C+D78C/D78C\D78C;
                      STA.L !Map16TilesHigh+$D80,X              ;;D790|D790+D790/D790\D790;
                      STA.L !Map16TilesHigh+$F30,X              ;;D794|D794+D794/D794\D794;
                      STA.L !Map16TilesHigh+$10E0,X             ;;D798|D798+D798/D798\D798;
                      STA.L !Map16TilesHigh+$1290,X             ;;D79C|D79C+D79C/D79C\D79C;
                      STA.L !Map16TilesHigh+$1440,X             ;;D7A0|D7A0+D7A0/D7A0\D7A0;
                      STA.L !Map16TilesHigh+$15F0,X             ;;D7A4|D7A4+D7A4/D7A4\D7A4;
                      STA.L !Map16TilesHigh+$17A0,X             ;;D7A8|D7A8+D7A8/D7A8\D7A8;
                      STA.L !Map16TilesHigh+$1950,X             ;;D7AC|D7AC+D7AC/D7AC\D7AC;
                      STA.L !Map16TilesHigh+$1B00,X             ;;D7B0|D7B0+D7B0/D7B0\D7B0;
                      STA.L !Map16TilesHigh+$1CB0,X             ;;D7B4|D7B4+D7B4/D7B4\D7B4;
                      STA.L !Map16TilesHigh+$1E60,X             ;;D7B8|D7B8+D7B8/D7B8\D7B8;
                      STA.L !Map16TilesHigh+$2010,X             ;;D7BC|D7BC+D7BC/D7BC\D7BC;
                      STA.L !Map16TilesHigh+$21C0,X             ;;D7C0|D7C0+D7C0/D7C0\D7C0;
                      STA.L !Map16TilesHigh+$2370,X             ;;D7C4|D7C4+D7C4/D7C4\D7C4;
                      STA.L !Map16TilesHigh+$2520,X             ;;D7C8|D7C8+D7C8/D7C8\D7C8;
                      STA.L !Map16TilesHigh+$26D0,X             ;;D7CC|D7CC+D7CC/D7CC\D7CC;
                      STA.L !Map16TilesHigh+$2880,X             ;;D7D0|D7D0+D7D0/D7D0\D7D0;
                      STA.L !Map16TilesHigh+$2A30,X             ;;D7D4|D7D4+D7D4/D7D4\D7D4;
                      STA.L !Map16TilesHigh+$2BE0,X             ;;D7D8|D7D8+D7D8/D7D8\D7D8;
                      STA.L !Map16TilesHigh+$2D90,X             ;;D7DC|D7DC+D7DC/D7DC\D7DC;
                      STA.L !Map16TilesHigh+$2F40,X             ;;D7E0|D7E0+D7E0/D7E0\D7E0;
                      STA.L !Map16TilesHigh+$30F0,X             ;;D7E4|D7E4+D7E4/D7E4\D7E4;
                      STA.L !Map16TilesHigh+$32A0,X             ;;D7E8|D7E8+D7E8/D7E8\D7E8;
                      STA.L !Map16TilesHigh+$3450,X             ;;D7EC|D7EC+D7EC/D7EC\D7EC;
                      INX                                       ;;D7F0|D7F0+D7F0/D7F0\D7F0;
                      RTS                                       ;;D7F1|D7F1+D7F1/D7F1\D7F1; Return 
                                                                ;;                        ;
CODE_04D7F2:          REP #$30                                  ;;D7F2|D7F2+D7F2/D7F2\D7F2; Index (16 bit) Accum (16 bit) 
                      LDA.W #$0000                              ;;D7F4|D7F4+D7F4/D7F4\D7F4;
                      SEP #$20                                  ;;D7F7|D7F7+D7F7/D7F7\D7F7; Accum (8 bit) 
                      LDA.B #!OWLayer1Translevel                ;;D7F9|D7F9+D7F9/D7F9\D7F9;
                      STA.B !_D                                 ;;D7FB|D7FB+D7FB/D7FB\D7FB;
                      LDA.B #!OWLayer1Translevel>>8             ;;D7FD|D7FD+D7FD/D7FD\D7FD;
                      STA.B !_E                                 ;;D7FF|D7FF+D7FF/D7FF\D7FF;
                      LDA.B #!OWLayer1Translevel>>16            ;;D801|D801+D801/D801\D801;
                      STA.B !_F                                 ;;D803|D803+D803/D803\D803;
                      LDA.B #!OWLayer2Directions                ;;D805|D805+D805/D805\D805;
                      STA.B !_A                                 ;;D807|D807+D807/D807\D807;
                      LDA.B #!OWLayer2Directions>>8             ;;D809|D809+D809/D809\D809;
                      STA.B !_B                                 ;;D80B|D80B+D80B/D80B\D80B;
                      LDA.B #!OWLayer2Directions>>16            ;;D80D|D80D+D80D/D80D\D80D;
                      STA.B !_C                                 ;;D80F|D80F+D80F/D80F\D80F;
                      LDA.B #!Map16TilesLow                     ;;D811|D811+D811/D811\D811;
                      STA.B !_4                                 ;;D813|D813+D813/D813\D813;
                      LDA.B #!Map16TilesLow>>8                  ;;D815|D815+D815/D815\D815;
                      STA.B !_5                                 ;;D817|D817+D817/D817\D817;
                      LDA.B #!Map16TilesLow>>16                 ;;D819|D819+D819/D819\D819;
                      STA.B !_6                                 ;;D81B|D81B+D81B/D81B\D81B;
                      LDY.W #$0001                              ;;D81D|D81D+D81D/D81D\D81D;
                      STY.B !_0                                 ;;D820|D820+D820/D820\D820;
                      LDY.W #$07FF                              ;;D822|D822+D822/D822\D822;
                      LDA.B #$00                                ;;D825|D825+D825/D825\D825;
                    - STA.B [!_A],Y                             ;;D827|D827+D827/D827\D827;
                      STA.B [!_D],Y                             ;;D829|D829+D829/D829\D829;
                      DEY                                       ;;D82B|D82B+D82B/D82B\D82B;
                      BPL -                                     ;;D82C|D82C+D82C/D82C\D82C;
                      LDY.W #$0000                              ;;D82E|D82E+D82E/D82E\D82E;
                      TYX                                       ;;D831|D831+D831/D831\D831;
CODE_04D832:          LDA.B [!_4],Y                             ;;D832|D832+D832/D832\D832;
                      CMP.B #$56                                ;;D834|D834+D834/D834\D834;
                      BCC +                                     ;;D836|D836+D836/D836\D836;
                      CMP.B #$81                                ;;D838|D838+D838/D838\D838;
                      BCS +                                     ;;D83A|D83A+D83A/D83A\D83A;
                      LDA.B !_0                                 ;;D83C|D83C+D83C/D83C\D83C;
                      STA.B [!_D],Y                             ;;D83E|D83E+D83E/D83E\D83E;
                      TAX                                       ;;D840|D840+D840/D840\D840;
                      LDA.L DATA_04D678,X                       ;;D841|D841+D841/D841\D841;
                      STA.B [!_A],Y                             ;;D845|D845+D845/D845\D845;
                      INC.B !_0                                 ;;D847|D847+D847/D847\D847;
                    + INY                                       ;;D849|D849+D849/D849\D849;
                      CPY.W #$0800                              ;;D84A|D84A+D84A/D84A\D84A;
                      BNE CODE_04D832                           ;;D84D|D84D+D84D/D84D\D84D;
                      STZ.B !_F                                 ;;D84F|D84F+D84F/D84F\D84F;
                    - JSR CODE_04DA49                           ;;D851|D851+D851/D851\D851;
                      INC.B !_F                                 ;;D854|D854+D854/D854\D854;
                      LDA.B !_F                                 ;;D856|D856+D856/D856\D856;
                      CMP.B #$6F                                ;;D858|D858+D858/D858\D858;
                      BNE -                                     ;;D85A|D85A+D85A/D85A\D85A;
                      RTS                                       ;;D85C|D85C+D85C/D85C\D85C; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04D85D:          db $00,$00,$00,$00,$00,$00,$69,$04        ;;D85D|D85D+D85D/D85D\D85D;
                      db $4B,$04,$29,$04,$09,$04,$D3,$00        ;;D865|D865+D865/D865\D865;
                      db $E5,$00,$A5,$00,$D1,$00,$85,$00        ;;D86D|D86D+D86D/D86D\D86D;
                      db $A9,$00,$CB,$00,$BD,$00,$9D,$00        ;;D875|D875+D875/D875\D875;
                      db $A5,$00,$07,$02,$00,$00,$27,$02        ;;D87D|D87D+D87D/D87D\D87D;
                      db $12,$05,$08,$06,$E3,$04,$C8,$04        ;;D885|D885+D885/D885\D885;
                      db $2A,$06,$EC,$04,$0C,$06,$1C,$06        ;;D88D|D88D+D88D/D88D\D88D;
                      db $4A,$06,$00,$00,$E0,$04,$3E,$00        ;;D895|D895+D895/D895\D895;
                      db $30,$01,$34,$01,$36,$01,$3A,$01        ;;D89D|D89D+D89D/D89D\D89D;
                      db $00,$00,$57,$01,$84,$01,$3A,$01        ;;D8A5|D8A5+D8A5/D8A5\D8A5;
                      db $00,$00,$00,$00,$AA,$06,$76,$06        ;;D8AD|D8AD+D8AD/D8AD\D8AD;
                      db $C8,$06,$AC,$06,$76,$06,$00,$00        ;;D8B5|D8B5+D8B5/D8B5\D8B5;
                      db $00,$00,$A4,$06,$AA,$06,$C4,$06        ;;D8BD|D8BD+D8BD/D8BD\D8BD;
                      db $00,$00,$04,$03,$00,$00,$00,$00        ;;D8C5|D8C5+D8C5/D8C5\D8C5;
                      db $79,$05,$77,$05,$59,$05,$74,$05        ;;D8CD|D8CD+D8CD/D8CD\D8CD;
                      db $00,$00,$54,$05,$00,$00,$34,$05        ;;D8D5|D8D5+D8D5/D8D5\D8D5;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;D8DD|D8DD+D8DD/D8DD\D8DD;
                      db $00,$00,$00,$00,$B3,$03,$00,$00        ;;D8E5|D8E5+D8E5/D8E5\D8E5;
                      db $00,$00,$00,$00,$DF,$02,$DC,$02        ;;D8ED|D8ED+D8ED/D8ED\D8ED;
                      db $00,$00,$7E,$02,$00,$00,$00,$00        ;;D8F5|D8F5+D8F5/D8F5\D8F5;
                      db $00,$00,$E0,$04,$E0,$04,$00,$00        ;;D8FD|D8FD+D8FD/D8FD\D8FD;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;D905|D905+D905/D905\D905;
                      db $00,$00,$00,$00,$34,$05,$34,$05        ;;D90D|D90D+D90D/D90D\D90D;
                      db $00,$00,$00,$00,$87,$07,$00,$00        ;;D915|D915+D915/D915\D915;
                      db $F0,$01,$68,$03,$65,$03,$B5,$03        ;;D91D|D91D+D91D/D91D\D91D;
                      db $00,$00,$36,$07,$39,$07,$3C,$07        ;;D925|D925+D925/D925\D925;
                      db $1C,$07,$19,$07,$16,$07,$13,$07        ;;D92D|D92D+D92D/D92D\D92D;
                      db $11,$07,$00,$00,$00,$00,$00,$00        ;;D935|D935+D935/D935\D935;
DATA_04D93D:          db $00,$00,$00,$00,$00,$00,$21,$92        ;;D93D|D93D+D93D/D93D\D93D;
                      db $21,$16,$20,$92,$20,$12,$23,$46        ;;D945|D945+D945/D945\D945;
                      db $23,$8A,$22,$8A,$23,$42,$22,$0A        ;;D94D|D94D+D94D/D94D\D94D;
                      db $22,$92,$23,$16,$22,$DA,$22,$5A        ;;D955|D955+D955/D955\D955;
                      db $22,$8A,$28,$0E,$00,$00,$28,$8E        ;;D95D|D95D+D95D/D95D\D95D;
                      db $24,$04,$28,$10,$23,$86,$23,$10        ;;D965|D965+D965/D965\D965;
                      db $28,$94,$23,$98,$28,$18,$28,$58        ;;D96D|D96D+D96D/D96D\D96D;
                      db $29,$14,$00,$00,$23,$80,$20,$DC        ;;D975|D975+D975/D975\D975;
                      db $24,$C0,$24,$C8,$24,$CC,$24,$D4        ;;D97D|D97D+D97D/D97D\D97D;
                      db $00,$00,$25,$4E,$26,$08,$24,$D4        ;;D985|D985+D985/D985\D985;
                      db $00,$00,$00,$00,$2A,$94,$29,$CC        ;;D98D|D98D+D98D/D98D\D98D;
                      db $2B,$10,$2A,$98,$29,$CC,$00,$00        ;;D995|D995+D995/D995\D995;
                      db $00,$00,$2A,$88,$2A,$94,$2B,$08        ;;D99D|D99D+D99D/D99D\D99D;
                      db $00,$00,$2C,$08,$00,$00,$00,$00        ;;D9A5|D9A5+D9A5/D9A5\D9A5;
                      db $25,$D2,$25,$CE,$25,$52,$25,$C8        ;;D9AD|D9AD+D9AD/D9AD\D9AD;
                      db $00,$00,$25,$48,$00,$00,$24,$C8        ;;D9B5|D9B5+D9B5/D9B5\D9B5;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;D9BD|D9BD+D9BD/D9BD\D9BD;
                      db $00,$00,$00,$00,$2E,$C6,$00,$00        ;;D9C5|D9C5+D9C5/D9C5\D9C5;
                      db $00,$00,$00,$00,$2B,$5E,$2B,$58        ;;D9CD|D9CD+D9CD/D9CD\D9CD;
                      db $00,$00,$29,$DC,$00,$00,$00,$00        ;;D9D5|D9D5+D9D5/D9D5\D9D5;
                      db $00,$00,$23,$80,$23,$80,$00,$00        ;;D9DD|D9DD+D9DD/D9DD\D9DD;
                      db $00,$00,$00,$00,$00,$00,$00,$00        ;;D9E5|D9E5+D9E5/D9E5\D9E5;
                      db $00,$00,$00,$00,$24,$C8,$24,$C8        ;;D9ED|D9ED+D9ED/D9ED\D9ED;
                      db $00,$00,$00,$00,$2E,$0E,$00,$00        ;;D9F5|D9F5+D9F5/D9F5\D9F5;
                      db $27,$C0,$2D,$90,$2D,$8A,$2E,$CA        ;;D9FD|D9FD+D9FD/D9FD\D9FD;
                      db $00,$00,$2C,$CC,$2C,$D2,$2C,$D8        ;;DA05|DA05+DA05/DA05\DA05;
                      db $2C,$58,$2C,$52,$2C,$4C,$2C,$46        ;;DA0D|DA0D+DA0D/DA0D\DA0D;
                      db $2C,$42,$00,$00,$00,$00,$00,$00        ;;DA15|DA15+DA15/DA15\DA15;
DATA_04DA1D:          db $6E,$6F,$70,$71,$72,$73,$74,$75        ;;DA1D|DA1D+DA1D/DA1D\DA1D;
                      db $59,$53,$52,$83,$4D,$57,$5A,$76        ;;DA25|DA25+DA25/DA25\DA25;
                      db $78,$7A,$7B,$7D,$7F,$54                ;;DA2D|DA2D+DA2D/DA2D\DA2D;
                                                                ;;                        ;
DATA_04DA33:          db $66,$67,$68,$69,$6A,$6B,$6C,$6D        ;;DA33|DA33+DA33/DA33\DA33;
                      db $58,$43,$44,$45,$25,$5E,$5F,$77        ;;DA3B|DA3B+DA3B/DA3B\DA3B;
                      db $79,$63,$7C,$7E,$80,$23                ;;DA43|DA43+DA43/DA43\DA43;
                                                                ;;                        ;
CODE_04DA49:          REP #$30                                  ;;DA49|DA49+DA49/DA49\DA49; Index (16 bit) Accum (16 bit) 
                      LDA.B !_F                                 ;;DA4B|DA4B+DA4B/DA4B\DA4B;
                      AND.W #$00F8                              ;;DA4D|DA4D+DA4D/DA4D\DA4D;
                      LSR A                                     ;;DA50|DA50+DA50/DA50\DA50;
                      LSR A                                     ;;DA51|DA51+DA51/DA51\DA51;
                      LSR A                                     ;;DA52|DA52+DA52/DA52\DA52;
                      TAY                                       ;;DA53|DA53+DA53/DA53\DA53;
                      LDA.B !_F                                 ;;DA54|DA54+DA54/DA54\DA54;
                      AND.W #$0007                              ;;DA56|DA56+DA56/DA56\DA56;
                      TAX                                       ;;DA59|DA59+DA59/DA59\DA59;
                      SEP #$20                                  ;;DA5A|DA5A+DA5A/DA5A\DA5A; Accum (8 bit) 
                      LDA.W !OWEventsActivated,Y                ;;DA5C|DA5C+DA5C/DA5C\DA5C;
                      AND.L DATA_04E44B,X                       ;;DA5F|DA5F+DA5F/DA5F\DA5F;
                      BEQ Return04DAAC                          ;;DA63|DA63+DA63/DA63\DA63;
                      REP #$20                                  ;;DA65|DA65+DA65/DA65\DA65; Accum (16 bit) 
                      LDA.W #$C800                              ;;DA67|DA67+DA67/DA67\DA67;
                      STA.B !_4                                 ;;DA6A|DA6A+DA6A/DA6A\DA6A;
                      LDA.B !_F                                 ;;DA6C|DA6C+DA6C/DA6C\DA6C;
                      AND.W #$00FF                              ;;DA6E|DA6E+DA6E/DA6E\DA6E;
                      ASL A                                     ;;DA71|DA71+DA71/DA71\DA71;
                      TAX                                       ;;DA72|DA72+DA72/DA72\DA72;
                      LDA.L DATA_04D85D,X                       ;;DA73|DA73+DA73/DA73\DA73;
                      TAY                                       ;;DA77|DA77+DA77/DA77\DA77;
                      LDX.W #$0015                              ;;DA78|DA78+DA78/DA78\DA78;
                      SEP #$20                                  ;;DA7B|DA7B+DA7B/DA7B\DA7B; Accum (8 bit) 
                      LDA.B #$7E                                ;;DA7D|DA7D+DA7D/DA7D\DA7D;
                      STA.B !_6                                 ;;DA7F|DA7F+DA7F/DA7F\DA7F;
                      LDA.B [!_4],Y                             ;;DA81|DA81+DA81/DA81\DA81;
CODE_04DA83:          CMP.L DATA_04DA1D,X                       ;;DA83|DA83+DA83/DA83\DA83;
                      BEQ CODE_04DA8F                           ;;DA87|DA87+DA87/DA87\DA87;
                      DEX                                       ;;DA89|DA89+DA89/DA89\DA89;
                      BPL CODE_04DA83                           ;;DA8A|DA8A+DA8A/DA8A\DA8A;
                      JMP CODE_04DA9D                           ;;DA8C|DA8C+DA8C/DA8C\DA8C;
                                                                ;;                        ;
CODE_04DA8F:          LDA.L DATA_04DA33,X                       ;;DA8F|DA8F+DA8F/DA8F\DA8F;
                      STA.B [!_4],Y                             ;;DA93|DA93+DA93/DA93\DA93;
                      CPX.W #$0015                              ;;DA95|DA95+DA95/DA95\DA95;
                      BNE CODE_04DA9D                           ;;DA98|DA98+DA98/DA98\DA98;
                      INY                                       ;;DA9A|DA9A+DA9A/DA9A\DA9A;
                      STA.B [!_4],Y                             ;;DA9B|DA9B+DA9B/DA9B\DA9B;
CODE_04DA9D:          LDA.B !_F                                 ;;DA9D|DA9D+DA9D/DA9D\DA9D;
                      JSR CODE_04E677                           ;;DA9F|DA9F+DA9F/DA9F\DA9F;
                      SEP #$10                                  ;;DAA2|DAA2+DAA2/DAA2\DAA2; Index (8 bit) 
                      STZ.W !OverworldEventProcess              ;;DAA4|DAA4+DAA4/DAA4\DAA4;
                      LDA.B !_F                                 ;;DAA7|DAA7+DAA7/DAA7\DAA7;
                      JSR CODE_04E9F1                           ;;DAA9|DAA9+DAA9/DAA9\DAA9;
Return04DAAC:         RTS                                       ;;DAAC|DAAC+DAAC/DAAC\DAAC; Return 
                                                                ;;                        ;
CODE_04DAAD:          PHP                                       ;;DAAD|DAAD+DAAD/DAAD\DAAD;
                      JSR CODE_04DC6A                           ;;DAAE|DAAE+DAAE/DAAE\DAAE;
                      PLP                                       ;;DAB1|DAB1+DAB1/DAB1\DAB1;
                      RTL                                       ;;DAB2|DAB2+DAB2/DAB2\DAB2; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04DAB3:          db $01,$18                                ;;DAB3|DAB3+DAB3/DAB3\DAB3;
                      dl !OWLayer2Tilemap                       ;;DAB5|DAB5+DAB5/DAB5\DAB5;
                      dw $2000                                  ;;DAB8|DAB8+DAB8/DAB8\DAB8;
                                                                ;;                        ;
CODE_04DABA:          SEP #$20                                  ;;DABA|DABA+DABA/DABA\DABA; Accum (8 bit) 
                      REP #$10                                  ;;DABC|DABC+DABC/DABC\DABC; Index (16 bit) 
                      LDA.B [!_0],Y                             ;;DABE|DABE+DABE/DABE\DABE;
                      STA.B !_3                                 ;;DAC0|DAC0+DAC0/DAC0\DAC0;
                      AND.B #$80                                ;;DAC2|DAC2+DAC2/DAC2\DAC2;
                      BNE CODE_04DAD6                           ;;DAC4|DAC4+DAC4/DAC4\DAC4;
                    - INY                                       ;;DAC6|DAC6+DAC6/DAC6\DAC6;
                      LDA.B [!_0],Y                             ;;DAC7|DAC7+DAC7/DAC7\DAC7;
                      STA.L !OWLayer2Tilemap,X                  ;;DAC9|DAC9+DAC9/DAC9\DAC9;
                      INX                                       ;;DACD|DACD+DACD/DACD\DACD;
                      INX                                       ;;DACE|DACE+DACE/DACE\DACE;
                      DEC.B !_3                                 ;;DACF|DACF+DACF/DACF\DACF;
                      BPL -                                     ;;DAD1|DAD1+DAD1/DAD1\DAD1;
                      JMP CODE_04DAE9                           ;;DAD3|DAD3+DAD3/DAD3\DAD3;
                                                                ;;                        ;
CODE_04DAD6:          LDA.B !_3                                 ;;DAD6|DAD6+DAD6/DAD6\DAD6;
                      AND.B #$7F                                ;;DAD8|DAD8+DAD8/DAD8\DAD8;
                      STA.B !_3                                 ;;DADA|DADA+DADA/DADA\DADA;
                      INY                                       ;;DADC|DADC+DADC/DADC\DADC;
                      LDA.B [!_0],Y                             ;;DADD|DADD+DADD/DADD\DADD;
                    - STA.L !OWLayer2Tilemap,X                  ;;DADF|DADF+DADF/DADF\DADF;
                      INX                                       ;;DAE3|DAE3+DAE3/DAE3\DAE3;
                      INX                                       ;;DAE4|DAE4+DAE4/DAE4\DAE4;
                      DEC.B !_3                                 ;;DAE5|DAE5+DAE5/DAE5\DAE5;
                      BPL -                                     ;;DAE7|DAE7+DAE7/DAE7\DAE7;
CODE_04DAE9:          INY                                       ;;DAE9|DAE9+DAE9/DAE9\DAE9;
                      CPX.B !_E                                 ;;DAEA|DAEA+DAEA/DAEA\DAEA;
                      BCC CODE_04DABA                           ;;DAEC|DAEC+DAEC/DAEC\DAEC;
                      RTS                                       ;;DAEE|DAEE+DAEE/DAEE\DAEE; Return 
                                                                ;;                        ;
CODE_04DAEF:          SEP #$30                                  ;;DAEF|DAEF+DAEF/DAEF\DAEF; Index (8 bit) Accum (8 bit) 
                      LDA.W !OWSubmapSwapProcess                ;;DAF1|DAF1+DAF1/DAF1\DAF1;
                      JSL ExecutePtr                            ;;DAF4|DAF4+DAF4/DAF4\DAF4;
                                                                ;;                        ;
                      dw CODE_04DB18                            ;;DAF8|DAF8+DAF8/DAF8\DAF8;
                      dw CODE_04DCB6                            ;;DAFA|DAFA+DAFA/DAFA\DAFA;
                      dw CODE_04DCB6                            ;;DAFC|DAFC+DAFC/DAFC\DAFC;
                      dw CODE_04DCB6                            ;;DAFE|DAFE+DAFE/DAFE\DAFE;
                      dw CODE_04DCB6                            ;;DB00|DB00+DB00/DB00\DB00;
                      dw CODE_04DB9D                            ;;DB02|DB02+DB02/DB02\DB02;
                      dw CODE_04DB18                            ;;DB04|DB04+DB04/DB04\DB04;
                      dw CODE_04DBCF                            ;;DB06|DB06+DB06/DB06\DB06;
                                                                ;;                        ;
DATA_04DB08:          db $00,$F9,$00,$07                        ;;DB08|DB08+DB08/DB08\DB08;
                                                                ;;                        ;
DATA_04DB0C:          db $00,$00,$00,$70                        ;;DB0C|DB0C+DB0C/DB0C\DB0C;
                                                                ;;                        ;
DATA_04DB10:          db $C0,$FA,$40,$05                        ;;DB10|DB10+DB10/DB10\DB10;
                                                                ;;                        ;
DATA_04DB14:          db $00,$00,$00,$54                        ;;DB14|DB14+DB14/DB14\DB14;
                                                                ;;                        ;
CODE_04DB18:          REP #$20                                  ;;DB18|DB18+DB18/DB18\DB18; Accum (16 bit) 
                      LDX.W !OWTransitionFlag                   ;;DB1A|DB1A+DB1A/DB1A\DB1A;
                      LDA.W !OWTransitionXCalc                  ;;DB1D|DB1D+DB1D/DB1D\DB1D;
                      CLC                                       ;;DB20|DB20+DB20/DB20\DB20;
                      ADC.W DATA_04DB08,X                       ;;DB21|DB21+DB21/DB21\DB21;
                      STA.W !OWTransitionXCalc                  ;;DB24|DB24+DB24/DB24\DB24;
                      SEC                                       ;;DB27|DB27+DB27/DB27\DB27;
                      SBC.W DATA_04DB0C,X                       ;;DB28|DB28+DB28/DB28\DB28;
                      EOR.W DATA_04DB08,X                       ;;DB2B|DB2B+DB2B/DB2B\DB2B;
                      BPL CODE_04DB43                           ;;DB2E|DB2E+DB2E/DB2E\DB2E;
                      LDA.W !OWTransitionYCalc                  ;;DB30|DB30+DB30/DB30\DB30;
                      CLC                                       ;;DB33|DB33+DB33/DB33\DB33;
                      ADC.W DATA_04DB10,X                       ;;DB34|DB34+DB34/DB34\DB34;
                      STA.W !OWTransitionYCalc                  ;;DB37|DB37+DB37/DB37\DB37;
                      SEC                                       ;;DB3A|DB3A+DB3A/DB3A\DB3A;
                      SBC.W DATA_04DB14,X                       ;;DB3B|DB3B+DB3B/DB3B\DB3B;
                      EOR.W DATA_04DB10,X                       ;;DB3E|DB3E+DB3E/DB3E\DB3E;
                      BMI +                                     ;;DB41|DB41+DB41/DB41\DB41;
CODE_04DB43:          %LorW_X(LDA,DATA_04DB0C)                  ;;DB43|DB43+DB43/DB43\DB43;
                      STA.W !OWTransitionXCalc                  ;;DB47|DB46+DB46/DB46\DB46;
                      %LorW_X(LDA,DATA_04DB14)                  ;;DB4A|DB49+DB49/DB49\DB49;
                      STA.W !OWTransitionYCalc                  ;;DB4E|DB4C+DB4C/DB4C\DB4C;
                      INC.W !OWSubmapSwapProcess                ;;DB51|DB4F+DB4F/DB4F\DB4F;
                      TXA                                       ;;DB54|DB52+DB52/DB52\DB52;
                      EOR.W #$0002                              ;;DB55|DB53+DB53/DB53\DB53;
                      TAX                                       ;;DB58|DB56+DB56/DB56\DB56;
                      STX.W !OWTransitionFlag                   ;;DB59|DB57+DB57/DB57\DB57;
                      BEQ +                                     ;;DB5C|DB5A+DB5A/DB5A\DB5A;
                      JSR CODE_049A93                           ;;DB5E|DB5C+DB5C/DB5C\DB5C;
                    + SEP #$20                                  ;;DB61|DB5F+DB5F/DB5F\DB5F; Accum (8 bit) 
                      LDA.W !OWTransitionYCalc+1                ;;DB63|DB61+DB61/DB61\DB61;
                      ASL A                                     ;;DB66|DB64+DB64/DB64\DB64;
                      STA.B !_0                                 ;;DB67|DB65+DB65/DB65\DB65;
                      LDA.W !OWTransitionXCalc+1                ;;DB69|DB67+DB67/DB67\DB67;
                      CLC                                       ;;DB6C|DB6A+DB6A/DB6A\DB6A;
                      ADC.B #$80                                ;;DB6D|DB6B+DB6B/DB6B\DB6B;
                      XBA                                       ;;DB6F|DB6D+DB6D/DB6D\DB6D;
                      LDA.B #$80                                ;;DB70|DB6E+DB6E/DB6E\DB6E;
                      SEC                                       ;;DB72|DB70+DB70/DB70\DB70;
                      SBC.W !OWTransitionXCalc+1                ;;DB73|DB71+DB71/DB71\DB71;
                      REP #$20                                  ;;DB76|DB74+DB74/DB74\DB74; Accum (16 bit) 
                      LDX.B #$00                                ;;DB78|DB76+DB76/DB76\DB76;
                      LDY.B #$A8                                ;;DB7A|DB78+DB78/DB78\DB78;
CODE_04DB7A:          CPX.B !_0                                 ;;DB7C|DB7A+DB7A/DB7A\DB7A;
                      BCC +                                     ;;DB7E|DB7C+DB7C/DB7C\DB7C;
                      LDA.W #$00FF                              ;;DB80|DB7E+DB7E/DB7E\DB7E;
                    + STA.W !WindowTable+$4E,Y                  ;;DB83|DB81+DB81/DB81\DB81;
                      STA.W !WindowTable+$F8,X                  ;;DB86|DB84+DB84/DB84\DB84;
                      INX                                       ;;DB89|DB87+DB87/DB87\DB87;
                      INX                                       ;;DB8A|DB88+DB88/DB88\DB88;
                      DEY                                       ;;DB8B|DB89+DB89/DB89\DB89;
                      DEY                                       ;;DB8C|DB8A+DB8A/DB8A\DB8A;
                      BNE CODE_04DB7A                           ;;DB8D|DB8B+DB8B/DB8B\DB8B;
                      SEP #$20                                  ;;DB8F|DB8D+DB8D/DB8D\DB8D; Accum (8 bit) 
                      LDA.B #$33                                ;;DB91|DB8F+DB8F/DB8F\DB8F;
                      STA.B !Layer12Window                      ;;DB93|DB91+DB91/DB91\DB91;
                      LDA.B #$33                                ;;DB95|DB93+DB93/DB93\DB93;
CODE_04DB95:          STA.B !OBJCWWindow                        ;;DB97|DB95+DB95/DB95\DB95;
                      LDA.B #$80                                ;;DB99|DB97+DB97/DB97\DB97;
                      STA.W !HDMAEnable                         ;;DB9B|DB99+DB99/DB99\DB99;
                      RTS                                       ;;DB9E|DB9C+DB9C/DB9C\DB9C; Return 
                                                                ;;                        ;
CODE_04DB9D:          LDA.W !PlayerTurnOW                       ;;DB9F|DB9D+DB9D/DB9D\DB9D;
                      LSR A                                     ;;DBA2|DBA0+DBA0/DBA0\DBA0;
                      LSR A                                     ;;DBA3|DBA1+DBA1/DBA1\DBA1;
                      TAX                                       ;;DBA4|DBA2+DBA2/DBA2\DBA2;
                      LDA.W !OWPlayerSubmap,X                   ;;DBA5|DBA3+DBA3/DBA3\DBA3;
                      TAX                                       ;;DBA8|DBA6+DBA6/DBA6\DBA6;
                      LDA.L DATA_04DC02,X                       ;;DBA9|DBA7+DBA7/DBA7\DBA7;
                      STA.W !ObjectTileset                      ;;DBAD|DBAB+DBAB/DBAB\DBAB;
                      JSL CODE_00A594                           ;;DBB0|DBAE+DBAE/DBAE\DBAE;
                      LDA.B #$FE                                ;;DBB4|DBB2+DBB2/DBB2\DBB2;
                      STA.W !MainPalette                        ;;DBB6|DBB4+DBB4/DBB4\DBB4;
                      LDA.B #$01                                ;;DBB9|DBB7+DBB7/DBB7\DBB7;
                      STA.W !MainPalette+1                      ;;DBBB|DBB9+DBB9/DBB9\DBB9;
                      STZ.W !MainPalette+$100                   ;;DBBE|DBBC+DBBC/DBBC\DBBC;
                      LDA.B #$06                                ;;DBC1|DBBF+DBBF/DBBF\DBBF;
                      STA.W !PaletteIndexTable                  ;;DBC3|DBC1+DBC1/DBC1\DBC1;
                      INC.W !OWSubmapSwapProcess                ;;DBC6|DBC4+DBC4/DBC4\DBC4;
                      RTS                                       ;;DBC9|DBC7+DBC7/DBC7\DBC7; Return 
                                                                ;;                        ;
                                                                ;;                        ;
OverworldMusic2:      db !BGM_DONUTPLAINS                       ;;DBCA|DBC8+DBC8/DBC8\DBC8;
                      db !BGM_YOSHISISLAND                      ;;DBCB|DBC9+DBC9/DBC9\DBC9;
                      db !BGM_VANILLADOME                       ;;DBCC|DBCA+DBCA/DBCA\DBCA;
                      db !BGM_FORESTOFILLUSION                  ;;DBCD|DBCB+DBCB/DBCB\DBCB;
                      db !BGM_VALLEYOFBOWSER                    ;;DBCE|DBCC+DBCC/DBCC\DBCC;
                      db !BGM_SPECIALWORLD                      ;;DBCF|DBCD+DBCD/DBCD\DBCD;
                      db !BGM_STARWORLD                         ;;DBD0|DBCE+DBCE/DBCE\DBCE;
                                                                ;;                        ;
CODE_04DBCF:          STZ.W !OWSubmapSwapProcess                ;;DBD1|DBCF+DBCF/DBCF\DBCF;
                      LDA.B #$04                                ;;DBD4|DBD2+DBD2/DBD2\DBD2;
                      STA.W !OverworldProcess                   ;;DBD6|DBD4+DBD4/DBD4\DBD4;
                      LDA.W !PlayerTurnOW                       ;;DBD9|DBD7+DBD7/DBD7\DBD7;
                      LSR A                                     ;;DBDC|DBDA+DBDA/DBDA\DBDA;
                      LSR A                                     ;;DBDD|DBDB+DBDB/DBDB\DBDB;
                      TAY                                       ;;DBDE|DBDC+DBDC/DBDC\DBDC;
                      LDA.W !IsTwoPlayerGame                    ;;DBDF|DBDD+DBDD/DBDD\DBDD;
                      BEQ CODE_04DBF3                           ;;DBE2|DBE0+DBE0/DBE0\DBE0;
                      LDA.W !SwapOverworldMusic                 ;;DBE4|DBE2+DBE2/DBE2\DBE2;
                      BNE CODE_04DBF3                           ;;DBE7|DBE5+DBE5/DBE5\DBE5;
                      TYA                                       ;;DBE9|DBE7+DBE7/DBE7\DBE7;
                      EOR.B #$01                                ;;DBEA|DBE8+DBE8/DBE8\DBE8;
                      TAX                                       ;;DBEC|DBEA+DBEA/DBEA\DBEA;
                      LDA.W !OWPlayerSubmap,Y                   ;;DBED|DBEB+DBEB/DBEB\DBEB;
                      CMP.W !OWPlayerSubmap,X                   ;;DBF0|DBEE+DBEE/DBEE\DBEE;
                      BEQ +                                     ;;DBF3|DBF1+DBF1/DBF1\DBF1;
CODE_04DBF3:          LDA.W !OWPlayerSubmap,Y                   ;;DBF5|DBF3+DBF3/DBF3\DBF3;
                      TAX                                       ;;DBF8|DBF6+DBF6/DBF6\DBF6;
                      LDA.L OverworldMusic2,X                   ;;DBF9|DBF7+DBF7/DBF7\DBF7;
                      STA.W !SPCIO2                             ;;DBFD|DBFB+DBFB/DBFB\DBFB; / Change music 
                      STZ.W !SwapOverworldMusic                 ;;DC00|DBFE+DBFE/DBFE\DBFE;
                    + RTS                                       ;;DC03|DC01+DC01/DC01\DC01; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04DC02:          db $11,$12,$13,$14,$15,$16,$17            ;;DC04|DC02+DC02/DC02\DC02;
                                                                ;;                        ;
CODE_04DC09:          SEP #$30                                  ;;DC0B|DC09+DC09/DC09\DC09; Index (8 bit) Accum (8 bit) 
                      LDA.W !PlayerTurnOW                       ;;DC0D|DC0B+DC0B/DC0B\DC0B;
                      LSR A                                     ;;DC10|DC0E+DC0E/DC0E\DC0E;
                      LSR A                                     ;;DC11|DC0F+DC0F/DC0F\DC0F;
                      TAX                                       ;;DC12|DC10+DC10/DC10\DC10;
                      LDA.W !OWPlayerSubmap,X                   ;;DC13|DC11+DC11/DC11\DC11;
                      TAX                                       ;;DC16|DC14+DC14/DC14\DC14;
                      LDA.L DATA_04DC02,X                       ;;DC17|DC15+DC15/DC15\DC15;
                      STA.W !ObjectTileset                      ;;DC1B|DC19+DC19/DC19\DC19;
                      LDA.B #$11                                ;;DC1E|DC1C+DC1C/DC1C\DC1C;
                      STA.W !SpriteTileset                      ;;DC20|DC1E+DC1E/DC1E\DC1E;
                      LDA.B #$07                                ;;DC23|DC21+DC21/DC21\DC21;
                      STA.W !LevelModeSetting                   ;;DC25|DC23+DC23/DC23\DC23;
                      LDA.B #$03                                ;;DC28|DC26+DC26/DC26\DC26;
                      STA.B !ScreenMode                         ;;DC2A|DC28+DC28/DC28\DC28;
                      REP #$10                                  ;;DC2C|DC2A+DC2A/DC2A\DC2A; Index (16 bit) 
                      LDX.W #$0000                              ;;DC2E|DC2C+DC2C/DC2C\DC2C;
                      TXA                                       ;;DC31|DC2F+DC2F/DC2F\DC2F;
                    - JSR CODE_04D770                           ;;DC32|DC30+DC30/DC30\DC30;
                      CPX.W #$01B0                              ;;DC35|DC33+DC33/DC33\DC33;
                      BNE -                                     ;;DC38|DC36+DC36/DC36\DC36;
                      REP #$30                                  ;;DC3A|DC38+DC38/DC38\DC38; Index (16 bit) Accum (16 bit) 
                      LDA.W #OWL1CharData                       ;;DC3C|DC3A+DC3A/DC3A\DC3A;
                      STA.B !_0                                 ;;DC3F|DC3D+DC3D/DC3D\DC3D;
                      LDX.W #$0000                              ;;DC41|DC3F+DC3F/DC3F\DC3F;
                    - LDA.B !_0                                 ;;DC44|DC42+DC42/DC42\DC42;
                      STA.W !Map16Pointers,X                    ;;DC46|DC44+DC44/DC44\DC44;
                      LDA.B !_0                                 ;;DC49|DC47+DC47/DC47\DC47;
                      CLC                                       ;;DC4B|DC49+DC49/DC49\DC49;
                      ADC.W #$0008                              ;;DC4C|DC4A+DC4A/DC4A\DC4A;
                      STA.B !_0                                 ;;DC4F|DC4D+DC4D/DC4D\DC4D;
                      INX                                       ;;DC51|DC4F+DC4F/DC4F\DC4F;
                      INX                                       ;;DC52|DC50+DC50/DC50\DC50;
                      CPX.W #$0400                              ;;DC53|DC51+DC51/DC51\DC51;
                      BNE -                                     ;;DC56|DC54+DC54/DC54\DC54;
                      PHB                                       ;;DC58|DC56+DC56/DC56\DC56;
                      LDA.W #$07FF                              ;;DC59|DC57+DC57/DC57\DC57;
                      LDX.W #OWL1TileData                       ;;DC5C|DC5A+DC5A/DC5A\DC5A;
                      LDY.W #!Map16TilesLow                     ;;DC5F|DC5D+DC5D/DC5D\DC5D;
                      MVN $7E,$0C                               ;;DC62|DC60+DC60/DC60\DC60;
                      PLB                                       ;;DC65|DC63+DC63/DC63\DC63;
                      JSR CODE_04D7F2                           ;;DC66|DC64+DC64/DC64\DC64;
                      SEP #$30                                  ;;DC69|DC67+DC67/DC67\DC67; Index (8 bit) Accum (8 bit) 
                      RTL                                       ;;DC6B|DC69+DC69/DC69\DC69; Return 
                                                                ;;                        ;
CODE_04DC6A:          SEP #$30                                  ;;DC6C|DC6A+DC6A/DC6A\DC6A; Index (8 bit) Accum (8 bit) 
                      JSR CODE_04DD40                           ;;DC6E|DC6C+DC6C/DC6C\DC6C;
                      REP #$20                                  ;;DC71|DC6F+DC6F/DC6F\DC6F; Accum (16 bit) 
                      LDA.W #OWTileNumbers                      ;;DC73|DC71+DC71/DC71\DC71;
                      STA.B !_0                                 ;;DC76|DC74+DC74/DC74\DC74;
                      SEP #$30                                  ;;DC78|DC76+DC76/DC76\DC76; Index (8 bit) Accum (8 bit) 
                      LDA.B #OWTileNumbers>>16                  ;;DC7A|DC78+DC78/DC78\DC78;
                      STA.B !_2                                 ;;DC7C|DC7A+DC7A/DC7A\DC7A;
                      REP #$10                                  ;;DC7E|DC7C+DC7C/DC7C\DC7C; Index (16 bit) 
                      LDY.W #$4000                              ;;DC80|DC7E+DC7E/DC7E\DC7E;
                      STY.B !_E                                 ;;DC83|DC81+DC81/DC81\DC81;
                      LDY.W #$0000                              ;;DC85|DC83+DC83/DC83\DC83;
                      TYX                                       ;;DC88|DC86+DC86/DC86\DC86;
                      JSR CODE_04DABA                           ;;DC89|DC87+DC87/DC87\DC87;
                      REP #$20                                  ;;DC8C|DC8A+DC8A/DC8A\DC8A; Accum (16 bit) 
                      LDA.W #OWTilemap                          ;;DC8E|DC8C+DC8C/DC8C\DC8C;
                      STA.B !_0                                 ;;DC91|DC8F+DC8F/DC8F\DC8F;
                      SEP #$20                                  ;;DC93|DC91+DC91/DC91\DC91; Accum (8 bit) 
                      LDX.W #$0001                              ;;DC95|DC93+DC93/DC93\DC93;
                      LDY.W #$0000                              ;;DC98|DC96+DC96/DC96\DC96;
                      JSR CODE_04DABA                           ;;DC9B|DC99+DC99/DC99\DC99;
                      SEP #$30                                  ;;DC9E|DC9C+DC9C/DC9C\DC9C; Index (8 bit) Accum (8 bit) 
                      LDA.B #$00                                ;;DCA0|DC9E+DC9E/DC9E\DC9E;
                      STA.B !_F                                 ;;DCA2|DCA0+DCA0/DCA0\DCA0;
                    - JSR CODE_04E453                           ;;DCA4|DCA2+DCA2/DCA2\DCA2;
                      INC.B !_F                                 ;;DCA7|DCA5+DCA5/DCA5\DCA5;
                      LDA.B !_F                                 ;;DCA9|DCA7+DCA7/DCA7\DCA7;
                      CMP.B #$6F                                ;;DCAB|DCA9+DCA9/DCA9\DCA9;
                      BNE -                                     ;;DCAD|DCAB+DCAB/DCAB\DCAB;
                      RTS                                       ;;DCAF|DCAD+DCAD/DCAD\DCAD; Return 
                                                                ;;                        ;
                                                                ;;                        ;
                      db $80,$40,$20,$10,$08,$04,$02,$01        ;;DCB0|DCAE+DCAE/DCAE\DCAE;
                                                                ;;                        ;
CODE_04DCB6:          PHP                                       ;;DCB8|DCB6+DCB6/DCB6\DCB6;
                      REP #$10                                  ;;DCB9|DCB7+DCB7/DCB7\DCB7; Index (16 bit) 
                      SEP #$20                                  ;;DCBB|DCB9+DCB9/DCB9\DCB9; Accum (8 bit) 
                      LDX.W #OWL1CharData                       ;;DCBD|DCBB+DCBB/DCBB\DCBB;
                      STX.B !Layer1DataPtr                      ;;DCC0|DCBE+DCBE/DCBE\DCBE;
                      LDA.B #OWL1CharData>>16                   ;;DCC2|DCC0+DCC0/DCC0\DCC0;
                      STA.B !Layer1DataPtr+2                    ;;DCC4|DCC2+DCC2/DCC2\DCC2;
                      LDX.W #$0000                              ;;DCC6|DCC4+DCC4/DCC4\DCC4;
                      STX.B !_0                                 ;;DCC9|DCC7+DCC7/DCC7\DCC7;
                      LDA.W !OWSubmapSwapProcess                ;;DCCB|DCC9+DCC9/DCC9\DCC9;
                      DEC A                                     ;;DCCE|DCCC+DCCC/DCCC\DCCC;
                      STA.B !_1                                 ;;DCCF|DCCD+DCCD/DCCD\DCCD;
                      REP #$20                                  ;;DCD1|DCCF+DCCF/DCCF\DCCF; Accum (16 bit) 
                      LDA.W !PlayerTurnOW                       ;;DCD3|DCD1+DCD1/DCD1\DCD1;
                      LSR A                                     ;;DCD6|DCD4+DCD4/DCD4\DCD4;
                      LSR A                                     ;;DCD7|DCD5+DCD5/DCD5\DCD5;
                      AND.W #$00FF                              ;;DCD8|DCD6+DCD6/DCD6\DCD6;
                      TAX                                       ;;DCDB|DCD9+DCD9/DCD9\DCD9;
                      SEP #$20                                  ;;DCDC|DCDA+DCDA/DCDA\DCDA; Accum (8 bit) 
                      LDA.W !OWPlayerSubmap,X                   ;;DCDE|DCDC+DCDC/DCDC\DCDC;
                      BEQ CODE_04DCE8                           ;;DCE1|DCDF+DCDF/DCDF\DCDF;
                      LDA.B !_1                                 ;;DCE3|DCE1+DCE1/DCE1\DCE1;
                      CLC                                       ;;DCE5|DCE3+DCE3/DCE3\DCE3;
                      ADC.B #$04                                ;;DCE6|DCE4+DCE4/DCE4\DCE4;
                      STA.B !_1                                 ;;DCE8|DCE6+DCE6/DCE6\DCE6;
CODE_04DCE8:          LDX.B !_0                                 ;;DCEA|DCE8+DCE8/DCE8\DCE8;
                      LDA.L !Map16TilesLow,X                    ;;DCEC|DCEA+DCEA/DCEA\DCEA;
                      STA.B !_2                                 ;;DCF0|DCEE+DCEE/DCEE\DCEE;
                      REP #$20                                  ;;DCF2|DCF0+DCF0/DCF0\DCF0; Accum (16 bit) 
                      LDA.L !Map16TilesHigh,X                   ;;DCF4|DCF2+DCF2/DCF2\DCF2;
                      STA.B !_3                                 ;;DCF8|DCF6+DCF6/DCF6\DCF6;
                      LDA.B !_2                                 ;;DCFA|DCF8+DCF8/DCF8\DCF8;
                      ASL A                                     ;;DCFC|DCFA+DCFA/DCFA\DCFA;
                      ASL A                                     ;;DCFD|DCFB+DCFB/DCFB\DCFB;
                      ASL A                                     ;;DCFE|DCFC+DCFC/DCFC\DCFC;
                      TAY                                       ;;DCFF|DCFD+DCFD/DCFD\DCFD;
                      LDA.B !_0                                 ;;DD00|DCFE+DCFE/DCFE\DCFE;
                      AND.W #$00FF                              ;;DD02|DD00+DD00/DD00\DD00;
                      ASL A                                     ;;DD05|DD03+DD03/DD03\DD03;
                      ASL A                                     ;;DD06|DD04+DD04/DD04\DD04;
                      PHA                                       ;;DD07|DD05+DD05/DD05\DD05;
                      AND.W #$003F                              ;;DD08|DD06+DD06/DD06\DD06;
                      STA.B !_2                                 ;;DD0B|DD09+DD09/DD09\DD09;
                      PLA                                       ;;DD0D|DD0B+DD0B/DD0B\DD0B;
                      ASL A                                     ;;DD0E|DD0C+DD0C/DD0C\DD0C;
                      AND.W #$0F80                              ;;DD0F|DD0D+DD0D/DD0D\DD0D;
                      ORA.B !_2                                 ;;DD12|DD10+DD10/DD10\DD10;
                      TAX                                       ;;DD14|DD12+DD12/DD12\DD12;
                      LDA.B [!Layer1DataPtr],Y                  ;;DD15|DD13+DD13/DD13\DD13;
                      STA.L !OWLayer1VramBuffer,X               ;;DD17|DD15+DD15/DD15\DD15;
                      INY                                       ;;DD1B|DD19+DD19/DD19\DD19;
                      INY                                       ;;DD1C|DD1A+DD1A/DD1A\DD1A;
                      LDA.B [!Layer1DataPtr],Y                  ;;DD1D|DD1B+DD1B/DD1B\DD1B;
                      STA.L !OWLayer1VramBuffer+$40,X           ;;DD1F|DD1D+DD1D/DD1D\DD1D;
                      INY                                       ;;DD23|DD21+DD21/DD21\DD21;
                      INY                                       ;;DD24|DD22+DD22/DD22\DD22;
                      LDA.B [!Layer1DataPtr],Y                  ;;DD25|DD23+DD23/DD23\DD23;
                      STA.L !OWLayer1VramBuffer+2,X             ;;DD27|DD25+DD25/DD25\DD25;
                      INY                                       ;;DD2B|DD29+DD29/DD29\DD29;
                      INY                                       ;;DD2C|DD2A+DD2A/DD2A\DD2A;
                      LDA.B [!Layer1DataPtr],Y                  ;;DD2D|DD2B+DD2B/DD2B\DD2B;
                      STA.L !OWLayer1VramBuffer+$42,X           ;;DD2F|DD2D+DD2D/DD2D\DD2D;
                      SEP #$20                                  ;;DD33|DD31+DD31/DD31\DD31; Accum (8 bit) 
                      INC.B !_0                                 ;;DD35|DD33+DD33/DD33\DD33;
                      LDA.B !_0                                 ;;DD37|DD35+DD35/DD35\DD35;
                      AND.B #$FF                                ;;DD39|DD37+DD37/DD37\DD37;
                      BNE CODE_04DCE8                           ;;DD3B|DD39+DD39/DD39\DD39;
                      INC.W !OWSubmapSwapProcess                ;;DD3D|DD3B+DD3B/DD3B\DD3B;
                      PLP                                       ;;DD40|DD3E+DD3E/DD3E\DD3E;
                      RTS                                       ;;DD41|DD3F+DD3F/DD3F\DD3F; Return 
                                                                ;;                        ;
CODE_04DD40:          REP #$10                                  ;;DD42|DD40+DD40/DD40\DD40; Index (16 bit) 
                      SEP #$20                                  ;;DD44|DD42+DD42/DD42\DD42; Accum (8 bit) 
                      LDY.W #OWEventTileProp                    ;;DD46|DD44+DD44/DD44\DD44;
                      STY.B !_2                                 ;;DD49|DD47+DD47/DD47\DD47;
                      LDA.B #OWEventTileProp>>16                ;;DD4B|DD49+DD49/DD49\DD49;
                      STA.B !_4                                 ;;DD4D|DD4B+DD4B/DD4B\DD4B;
                      LDX.W #$0000                              ;;DD4F|DD4D+DD4D/DD4D\DD4D;
                      TXY                                       ;;DD52|DD50+DD50/DD50\DD50;
                      JSR CODE_04DD57                           ;;DD53|DD51+DD51/DD51\DD51;
                      SEP #$30                                  ;;DD56|DD54+DD54/DD54\DD54; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;DD58|DD56+DD56/DD56\DD56; Return 
                                                                ;;                        ;
CODE_04DD57:          SEP #$20                                  ;;DD59|DD57+DD57/DD57\DD57; Accum (8 bit) 
                      LDA.B [!_2],Y                             ;;DD5B|DD59+DD59/DD59\DD59;
                      INY                                       ;;DD5D|DD5B+DD5B/DD5B\DD5B;
                      STA.B !_5                                 ;;DD5E|DD5C+DD5C/DD5C\DD5C;
                      AND.B #$80                                ;;DD60|DD5E+DD5E/DD5E\DD5E;
                      BNE CODE_04DD71                           ;;DD62|DD60+DD60/DD60\DD60;
                    - LDA.B [!_2],Y                             ;;DD64|DD62+DD62/DD62\DD62;
                      STA.L !OWEventTilemap,X                   ;;DD66|DD64+DD64/DD64\DD64;
                      INY                                       ;;DD6A|DD68+DD68/DD68\DD68;
                      INX                                       ;;DD6B|DD69+DD69/DD69\DD69;
                      DEC.B !_5                                 ;;DD6C|DD6A+DD6A/DD6A\DD6A;
                      BPL -                                     ;;DD6E|DD6C+DD6C/DD6C\DD6C;
                      JMP CODE_04DD83                           ;;DD70|DD6E+DD6E/DD6E\DD6E;
                                                                ;;                        ;
CODE_04DD71:          LDA.B !_5                                 ;;DD73|DD71+DD71/DD71\DD71;
                      AND.B #$7F                                ;;DD75|DD73+DD73/DD73\DD73;
                      STA.B !_5                                 ;;DD77|DD75+DD75/DD75\DD75;
                      LDA.B [!_2],Y                             ;;DD79|DD77+DD77/DD77\DD77;
                    - STA.L !OWEventTilemap,X                   ;;DD7B|DD79+DD79/DD79\DD79;
                      INX                                       ;;DD7F|DD7D+DD7D/DD7D\DD7D;
                      DEC.B !_5                                 ;;DD80|DD7E+DD7E/DD7E\DD7E;
                      BPL -                                     ;;DD82|DD80+DD80/DD80\DD80;
                      INY                                       ;;DD84|DD82+DD82/DD82\DD82;
CODE_04DD83:          REP #$20                                  ;;DD85|DD83+DD83/DD83\DD83; Accum (16 bit) 
                      LDA.B [!_2],Y                             ;;DD87|DD85+DD85/DD85\DD85;
                      CMP.W #$FFFF                              ;;DD89|DD87+DD87/DD87\DD87;
                      BNE CODE_04DD57                           ;;DD8C|DD8A+DD8A/DD8A\DD8A;
                      RTS                                       ;;DD8E|DD8C+DD8C/DD8C\DD8C; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04DD8D:          db $00,$09                                ;;DD8F|DD8D+DD8D/DD8D\DD8D;
                                                                ;;                        ;
DATA_04DD8F:          db $CC,$23,$04,$09,$8C,$23,$08,$09        ;;DD91|DD8F+DD8F/DD8F\DD8F;
                      db $4E,$23,$0C,$09,$0E,$23,$10,$09        ;;DD99|DD97+DD97/DD97\DD97;
                      db $D0,$22,$14,$09,$90,$22,$8C,$01        ;;DDA1|DD9F+DD9F/DD9F\DD9F;
                      db $02,$22,$B0,$01,$02,$22,$D4,$01        ;;DDA9|DDA7+DDA7/DDA7\DDA7;
                      db $02,$22,$44,$0A,$C6,$21,$48,$0A        ;;DDB1|DDAF+DDAF/DDAF\DDAF;
                      db $44,$20,$4C,$0A,$86,$21,$48,$0A        ;;DDB9|DDB7+DDB7/DDB7\DDB7;
                      db $04,$20,$00,$09,$E4,$23,$38,$09        ;;DDC1|DDBF+DDBF/DDBF\DDBF;
                      db $A4,$23,$28,$09,$24,$23,$18,$09        ;;DDC9|DDC7+DDC7/DDC7\DDC7;
                      db $26,$23,$1C,$09,$28,$23,$20,$09        ;;DDD1|DDCF+DDCF/DDCF\DDCF;
                      db $EC,$22,$24,$09,$AC,$22,$0C,$0B        ;;DDD9|DDD7+DDD7/DDD7\DDD7;
                      db $2C,$22,$10,$0B,$EC,$21,$30,$09        ;;DDE1|DDDF+DDDF/DDDF\DDDF;
                      db $6C,$21,$34,$09,$68,$21,$38,$09        ;;DDE9|DDE7+DDE7/DDE7\DDE7;
                      db $E4,$20,$38,$09,$A4,$20,$3C,$09        ;;DDF1|DDEF+DDEF/DDEF\DDEF;
                      db $90,$10,$40,$09,$4C,$10,$44,$09        ;;DDF9|DDF7+DDF7/DDF7\DDF7;
                      db $0C,$10,$38,$09,$8C,$07,$38,$09        ;;DE01|DDFF+DDFF/DDFF\DDFF;
                      db $0C,$07,$28,$09,$8C,$06,$48,$09        ;;DE09|DE07+DE07/DE07\DE07;
                      db $14,$10,$4C,$09,$94,$07,$50,$09        ;;DE11|DE0F+DE0F/DE0F\DE0F;
                      db $54,$07,$38,$09,$0C,$06,$04,$09        ;;DE19|DE17+DE17/DE17\DE17;
                      db $8C,$05,$54,$09,$0E,$05,$E8,$09        ;;DE21|DE1F+DE1F/DE1F\DE1F;
                      db $48,$06,$E8,$09,$C8,$06,$98,$09        ;;DE29|DE27+DE27/DE27\DE27;
                      db $88,$06,$EC,$09,$12,$05,$F0,$09        ;;DE31|DE2F+DE2F/DE2F\DE2F;
                      db $D2,$04,$F4,$09,$92,$04,$00,$00        ;;DE39|DE37+DE37/DE37\DE37;
                      db $D8,$04,$24,$00,$98,$04,$48,$00        ;;DE41|DE3F+DE3F/DE3F\DE3F;
                      db $D8,$03,$6C,$00,$56,$03,$90,$00        ;;DE49|DE47+DE47/DE47\DE47;
                      db $56,$03,$B4,$00,$56,$03,$10,$05        ;;DE51|DE4F+DE4F/DE4F\DE4F;
                      db $18,$05,$28,$09,$24,$05,$38,$0B        ;;DE59|DE57+DE57/DE57\DE57;
                      db $14,$07,$60,$09,$28,$05,$64,$09        ;;DE61|DE5F+DE5F/DE5F\DE5F;
                      db $6A,$05,$68,$09,$AC,$05,$6C,$09        ;;DE69|DE67+DE67/DE67\DE67;
                      db $2C,$06,$70,$09,$30,$06,$74,$09        ;;DE71|DE6F+DE6F/DE6F\DE6F;
                      db $B2,$05,$78,$09,$32,$05,$68,$01        ;;DE79|DE77+DE77/DE77\DE77;
                      db $FC,$07,$50,$0A,$C0,$0F,$D8,$00        ;;DE81|DE7F+DE7F/DE7F\DE7F;
                      db $7C,$07,$FC,$00,$7C,$07,$20,$01        ;;DE89|DE87+DE87/DE87\DE87;
                      db $7C,$07,$44,$01,$7C,$07,$50,$09        ;;DE91|DE8F+DE8F/DE8F\DE8F;
                      db $D4,$06,$4C,$09,$94,$06,$7C,$09        ;;DE99|DE97+DE97/DE97\DE97;
                      db $14,$06,$80,$09,$94,$05,$84,$09        ;;DEA1|DE9F+DE9F/DE9F\DE9F;
                      db $18,$07,$88,$09,$1A,$07,$48,$09        ;;DEA9|DEA7+DEA7/DEA7\DEA7;
                      db $9C,$07,$8C,$09,$1C,$10,$90,$09        ;;DEB1|DEAF+DEAF/DEAF\DEAF;
                      db $60,$10,$94,$09,$64,$10,$38,$09        ;;DEB9|DEB7+DEB7/DEB7\DEB7;
                      db $DC,$10,$98,$09,$84,$28,$A4,$09        ;;DEC1|DEBF+DEBF/DEBF\DEBF;
                      db $18,$31,$84,$09,$1C,$31,$A8,$09        ;;DEC9|DEC7+DEC7/DEC7\DEC7;
                      db $E0,$30,$4C,$09,$60,$30,$A0,$09        ;;DED1|DECF+DECF/DECF\DECF;
                      db $CA,$30,$A0,$09,$0E,$31,$B0,$09        ;;DED9|DED7+DED7/DED7\DED7;
                      db $10,$31,$B4,$09,$CC,$30,$B8,$09        ;;DEE1|DEDF+DEDF/DEDF\DEDF;
                      db $8C,$30,$BC,$09,$0C,$30,$BC,$09        ;;DEE9|DEE7+DEE7/DEE7\DEE7;
                      db $8C,$27,$BC,$09,$A0,$27,$BC,$09        ;;DEF1|DEEF+DEEF/DEEF\DEEF;
                      db $20,$27,$AC,$09,$A0,$26,$28,$09        ;;DEF9|DEF7+DEF7/DEF7\DEF7;
                      db $20,$26,$00,$0A,$64,$30,$04,$0A        ;;DF01|DEFF+DEFF/DEFF\DEFF;
                      db $A8,$30,$08,$0A,$28,$31,$18,$09        ;;DF09|DF07+DF07/DF07\DF07;
                      db $22,$26,$98,$09,$26,$26,$C0,$09        ;;DF11|DF0F+DF0F/DF0F\DF0F;
                      db $2A,$26,$C4,$09,$6C,$26,$C8,$09        ;;DF19|DF17+DF17/DF17\DF17;
                      db $70,$26,$CC,$09,$B0,$26,$28,$09        ;;DF21|DF1F+DF1F/DF1F\DF1F;
                      db $30,$27,$D0,$09,$70,$27,$38,$09        ;;DF29|DF27+DF27/DF27\DF27;
                      db $B0,$27,$28,$09,$30,$30,$38,$09        ;;DF31|DF2F+DF2F/DF2F\DF2F;
                      db $B0,$30,$38,$09,$F0,$30,$D4,$09        ;;DF39|DF37+DF37/DF37\DF37;
                      db $B0,$31,$D8,$09,$2E,$32,$98,$09        ;;DF41|DF3F+DF3F/DF3F\DF3F;
                      db $2A,$32,$E0,$09,$CC,$26,$BC,$09        ;;DF49|DF47+DF47/DF47\DF47;
                      db $8C,$26,$E4,$09,$0C,$26,$DC,$09        ;;DF51|DF4F+DF4F/DF4F\DF4F;
                      db $04,$27,$DC,$09,$C0,$26,$DC,$09        ;;DF59|DF57+DF57/DF57\DF57;
                      db $40,$27,$98,$09,$B4,$01,$0C,$0B        ;;DF61|DF5F+DF5F/DF5F\DF5F;
                      db $B8,$01,$30,$0B,$88,$09,$34,$0B        ;;DF69|DF67+DF67/DF67\DF67;
                      db $A0,$09,$10,$0A,$8A,$09,$10,$0A        ;;DF71|DF6F+DF6F/DF6F\DF6F;
                      db $9E,$09,$0C,$0A,$8C,$09,$0C,$0A        ;;DF79|DF77+DF77/DF77\DF77;
                      db $9C,$09,$10,$0A,$8E,$09,$10,$0A        ;;DF81|DF7F+DF7F/DF7F\DF7F;
                      db $9A,$09,$0C,$0A,$90,$09,$0C,$0A        ;;DF89|DF87+DF87/DF87\DF87;
                      db $98,$09,$10,$0A,$92,$09,$10,$0A        ;;DF91|DF8F+DF8F/DF8F\DF8F;
                      db $96,$09,$14,$0A,$A4,$09,$A8,$03        ;;DF99|DF97+DF97/DF97\DF97;
                      db $30,$08,$18,$0A,$AC,$09,$1C,$0A        ;;DFA1|DF9F+DF9F/DF9F\DF9F;
                      db $F0,$09,$9C,$09,$70,$0A,$20,$0A        ;;DFA9|DFA7+DFA7/DFA7\DFA7;
                      db $F0,$0A,$20,$0A,$70,$0B,$20,$0A        ;;DFB1|DFAF+DFAF/DFAF\DFAF;
                      db $F0,$0B,$24,$0A,$70,$0C,$38,$09        ;;DFB9|DFB7+DFB7/DFB7\DFB7;
                      db $F0,$0C,$28,$0A,$30,$0D,$2C,$0A        ;;DFC1|DFBF+DFBF/DFBF\DFBF;
                      db $98,$0A,$30,$0A,$9C,$0A,$14,$0B        ;;DFC9|DFC7+DFC7/DFC7\DFC7;
                      db $10,$0B,$18,$0B,$90,$0B,$34,$0A        ;;DFD1|DFCF+DFCF/DFCF\DFCF;
                      db $1C,$0B,$38,$0A,$5E,$0B,$3C,$0A        ;;DFD9|DFD7+DFD7/DFD7\DFD7;
                      db $62,$0B,$40,$0A,$66,$0B,$20,$0A        ;;DFE1|DFDF+DFDF/DFDF\DFDF;
                      db $E8,$0A,$9C,$09,$68,$0A,$7C,$0A        ;;DFE9|DFE7+DFE7/DFE7\DFE7;
                      db $A4,$33,$7C,$0A,$E8,$33,$7C,$0A        ;;DFF1|DFEF+DFEF/DFEF\DFEF;
                      db $68,$34,$18,$09,$A2,$33,$C0,$09        ;;DFF9|DFF7+DFF7/DFF7\DFF7;
                      db $A4,$33,$30,$09,$E8,$33,$54,$0A        ;;E001|DFFF+DFFF/DFFF\DFFF;
                      db $28,$34,$38,$09,$A8,$34,$7C,$0A        ;;E009|E007+E007/E007\E007;
                      db $98,$33,$7C,$0A,$9C,$33,$58,$0A        ;;E011|E00F+E00F/E00F\E00F;
                      db $9E,$33,$98,$09,$9C,$33,$28,$09        ;;E019|E017+E017/E017\E017;
                      db $98,$33,$7C,$0A,$26,$36,$7C,$0A        ;;E021|E01F+E01F/E01F\E01F;
                      db $20,$36,$5C,$0A,$68,$35,$14,$09        ;;E029|E027+E027/E027\E027;
                      db $A8,$35,$D8,$09,$26,$36,$1C,$09        ;;E031|E02F+E02F/E02F\E02F;
                      db $24,$36,$28,$09,$20,$36,$7C,$0A        ;;E039|E037+E037/E037\E037;
                      db $2C,$35,$7C,$0A,$30,$35,$60,$0A        ;;E041|E03F+E03F/E03F\E03F;
                      db $2A,$35,$98,$09,$2C,$35,$98,$09        ;;E049|E047+E047/E047\E047;
                      db $2E,$35,$98,$09,$30,$35,$7C,$0A        ;;E051|E04F+E04F/E04F\E04F;
                      db $DA,$35,$7C,$0A,$98,$34,$7C,$0A        ;;E059|E057+E057/E057\E057;
                      db $18,$34,$58,$0A,$1E,$36,$3C,$09        ;;E061|E05F+E05F/E05F\E05F;
                      db $1C,$36,$64,$0A,$D8,$35,$44,$09        ;;E069|E067+E067/E067\E067;
                      db $98,$35,$28,$09,$18,$35,$38,$09        ;;E071|E06F+E06F/E06F\E06F;
                      db $98,$34,$38,$09,$18,$34,$28,$09        ;;E079|E077+E077/E077\E077;
                      db $98,$33,$7C,$0A,$A0,$36,$7C,$0A        ;;E081|E07F+E07F/E07F\E07F;
                      db $60,$37,$D0,$09,$60,$36,$38,$09        ;;E089|E087+E087/E087\E087;
                      db $E0,$36,$38,$09,$60,$37,$7C,$0A        ;;E091|E08F+E08F/E08F\E08F;
                      db $9C,$33,$18,$09,$9A,$33,$98,$09        ;;E099|E097+E097/E097\E097;
                      db $9C,$33,$7C,$0A,$10,$35,$58,$0A        ;;E0A1|E09F+E09F/E09F\E09F;
                      db $96,$33,$6C,$0A,$92,$33,$70,$0A        ;;E0A9|E0A7+E0A7/E0A7\E0A7;
                      db $D0,$33,$74,$0A,$10,$34,$38,$09        ;;E0B1|E0AF+E0AF/E0AF\E0AF;
                      db $90,$34,$28,$09,$10,$35,$7C,$0A        ;;E0B9|E0B7+E0B7/E0B7\E0B7;
                      db $1C,$35,$7C,$0A,$22,$35,$98,$09        ;;E0C1|E0BF+E0BF/E0BF\E0BF;
                      db $14,$35,$28,$09,$18,$35,$98,$09        ;;E0C9|E0C7+E0C7/E0C7\E0C7;
                      db $1C,$35,$98,$09,$20,$35,$98,$09        ;;E0D1|E0CF+E0CF/E0CF\E0CF;
                      db $24,$35,$7C,$0A,$10,$36,$D0,$09        ;;E0D9|E0D7+E0D7/E0D7\E0D7;
                      db $50,$35,$38,$09,$90,$35,$28,$09        ;;E0E1|E0DF+E0DF/E0DF\E0DF;
                      db $10,$36,$7C,$0A,$90,$36,$7C,$0A        ;;E0E9|E0E7+E0E7/E0E7\E0E7;
                      db $0E,$37,$7C,$0A,$0A,$37,$7C,$0A        ;;E0F1|E0EF+E0EF/E0EF\E0EF;
                      db $02,$37,$D0,$09,$50,$36,$78,$0A        ;;E0F9|E0F7+E0F7/E0F7\E0F7;
                      db $D0,$36,$1C,$09,$0C,$37,$98,$09        ;;E101|E0FF+E0FF/E0FF\E0FF;
                      db $08,$37,$98,$09,$04,$37,$98,$09        ;;E109|E107+E107/E107\E107;
                      db $00,$37,$90,$0A,$12,$18,$94,$0A        ;;E111|E10F+E10F/E10F\E10F;
                      db $AA,$2B,$98,$0A,$A8,$2B,$9C,$0A        ;;E119|E117+E117/E117\E117;
                      db $A4,$2B,$94,$0A,$A2,$2B,$98,$0A        ;;E121|E11F+E11F/E11F\E11F;
                      db $A0,$2B,$A0,$0A,$64,$2B,$A4,$0A        ;;E129|E127+E127/E127\E127;
                      db $9A,$2B,$98,$0A,$98,$2B,$98,$0A        ;;E131|E12F+E12F/E12F\E12F;
                      db $96,$2B,$98,$0A,$94,$2B,$9C,$0A        ;;E139|E137+E137/E137\E137;
                      db $90,$2B,$A0,$0A,$5C,$2B,$A0,$0A        ;;E141|E13F+E13F/E13F\E13F;
                      db $50,$2B,$A8,$0A,$10,$2B,$9C,$0A        ;;E149|E147+E147/E147\E147;
                      db $90,$2A,$AC,$0A,$92,$2A,$98,$0A        ;;E151|E14F+E14F/E14F\E14F;
                      db $94,$2A,$98,$0A,$96,$2A,$98,$0A        ;;E159|E157+E157/E157\E157;
                      db $98,$2A,$A0,$0A,$50,$2A,$A8,$0A        ;;E161|E15F+E15F/E15F\E15F;
                      db $10,$2A,$3C,$0B,$90,$29,$40,$0B        ;;E169|E167+E167/E167\E167;
                      db $94,$29,$40,$0B,$98,$29,$A0,$0A        ;;E171|E16F+E16F/E16F\E16F;
                      db $5C,$2A,$A8,$0A,$1C,$2A,$A8,$0A        ;;E179|E177+E177/E177\E177;
                      db $DC,$29,$A0,$0A,$64,$2A,$A8,$0A        ;;E181|E17F+E17F/E17F\E17F;
                      db $24,$2A,$A8,$0A,$E4,$29,$B0,$0A        ;;E189|E187+E187/E187\E187;
                      db $90,$1D,$A0,$09,$8C,$1D,$B0,$0A        ;;E191|E18F+E18F/E18F\E18F;
                      db $56,$1E,$B4,$0A,$5A,$1E,$B8,$0A        ;;E199|E197+E197/E197\E197;
                      db $5C,$1D,$A0,$09,$18,$1D,$BC,$0A        ;;E1A1|E19F+E19F/E19F\E19F;
                      db $90,$1C,$BC,$0A,$0C,$1C,$A0,$09        ;;E1A9|E1A7+E1A7/E1A7\E1A7;
                      db $0C,$1E,$C0,$0A,$8A,$1E,$C0,$0A        ;;E1B1|E1AF+E1AF/E1AF\E1AF;
                      db $86,$1E,$BC,$0A,$04,$1E,$A0,$09        ;;E1B9|E1B7+E1B7/E1B7\E1B7;
                      db $84,$1D,$B8,$0A,$C6,$1C,$B0,$0A        ;;E1C1|E1BF+E1BF/E1BF\E1BF;
                      db $0C,$1D,$A0,$09,$88,$1D,$A0,$09        ;;E1C9|E1C7+E1C7/E1C7\E1C7;
                      db $84,$1D,$B4,$0A,$80,$1D,$A0,$09        ;;E1D1|E1CF+E1CF/E1CF\E1CF;
                      db $3C,$16,$A0,$09,$BC,$16,$A0,$09        ;;E1D9|E1D7+E1D7/E1D7\E1D7;
                      db $B8,$16,$A0,$09,$B4,$16,$A0,$09        ;;E1E1|E1DF+E1DF/E1DF\E1DF;
                      db $30,$16,$A8,$0A,$70,$15,$C4,$0A        ;;E1E9|E1E7+E1E7/E1E7\E1E7;
                      db $30,$15,$D8,$0A,$B8,$13,$4C,$09        ;;E1F1|E1EF+E1EF/E1EF\E1EF;
                      db $B0,$14,$C8,$0A,$32,$14,$CC,$0A        ;;E1F9|E1F7+E1F7/E1F7\E1F7;
                      db $F4,$13,$D0,$0A,$B8,$13,$D4,$0A        ;;E201|E1FF+E1FF/E1FF\E1FF;
                      db $B8,$12,$F8,$01,$F4,$11,$1C,$02        ;;E209|E207+E207/E207\E207;
                      db $F4,$11,$40,$02,$F4,$11,$64,$02        ;;E211|E20F+E20F/E20F\E20F;
                      db $F4,$11,$88,$02,$F4,$11,$AC,$02        ;;E219|E217+E217/E217\E217;
                      db $F4,$11,$D0,$02,$F4,$11,$F4,$02        ;;E221|E21F+E21F/E21F\E21F;
                      db $F4,$11,$18,$03,$F4,$11,$3C,$03        ;;E229|E227+E227/E227\E227;
                      db $B4,$11,$60,$03,$B4,$11,$3C,$03        ;;E231|E22F+E22F/E22F\E22F;
                      db $B4,$11,$DC,$0A,$10,$3D,$E0,$0A        ;;E239|E237+E237/E237\E237;
                      db $CE,$3C,$E4,$0A,$8C,$3C,$E8,$0A        ;;E241|E23F+E23F/E23F\E23F;
                      db $48,$3C,$EC,$0A,$14,$3C,$F0,$0A        ;;E249|E247+E247/E247\E247;
                      db $D6,$3B,$F4,$0A,$98,$3B,$F8,$0A        ;;E251|E24F+E24F/E24F\E24F;
                      db $5A,$3B,$18,$09,$26,$3C,$98,$09        ;;E259|E257+E257/E257\E257;
                      db $28,$3C,$98,$09,$2A,$3C,$98,$09        ;;E261|E25F+E25F/E25F\E25F;
                      db $2C,$3C,$6C,$09,$28,$3D,$FC,$0A        ;;E269|E267+E267/E267\E267;
                      db $68,$3D,$00,$0B,$AA,$3D,$E4,$0A        ;;E271|E26F+E26F/E26F\E26F;
                      db $EC,$3D,$E4,$0A,$2E,$3E,$DC,$0A        ;;E279|E277+E277/E277\E277;
                      db $B0,$3E,$3C,$0B,$90,$29,$40,$0B        ;;E281|E27F+E27F/E27F\E27F;
                      db $94,$29,$40,$0B,$98,$29,$04,$0B        ;;E289|E287+E287/E287\E287;
                      db $9C,$3D,$08,$0B,$D8,$3D,$08,$0B        ;;E291|E28F+E28F/E28F\E28F;
                      db $14,$3E,$08,$0B,$50,$3E,$08,$0B        ;;E299|E297+E297/E297\E297;
                      db $8C,$3E,$6C,$09,$88,$3E,$44,$01        ;;E2A1|E29F+E29F/E29F\E29F;
                      db $7C,$07,$38,$09,$E0,$19,$1C,$0B        ;;E2A9|E2A7+E2A7/E2A7\E2A7;
                      db $20,$1A,$CC,$03,$DC,$1A,$F0,$03        ;;E2B1|E2AF+E2AF/E2AF\E2AF;
                      db $DC,$1A,$14,$04,$DC,$1A,$38,$04        ;;E2B9|E2B7+E2B7/E2B7\E2B7;
                      db $9C,$1B,$5C,$04,$9C,$1B,$80,$04        ;;E2C1|E2BF+E2BF/E2BF\E2BF;
                      db $5C,$1B,$A4,$04,$1C,$1B,$C8,$04        ;;E2C9|E2C7+E2C7/E2C7\E2C7;
                      db $DC,$1A,$EC,$04,$9C,$1A,$58,$0A        ;;E2D1|E2CF+E2CF/E2CF\E2CF;
                      db $1E,$1B,$20,$0B,$1C,$1B,$24,$0B        ;;E2D9|E2D7+E2D7/E2D7\E2D7;
                      db $1A,$1B,$28,$0B,$18,$1B,$A0,$09        ;;E2E1|E2DF+E2DF/E2DF\E2DF;
                      db $94,$1B,$A0,$09,$14,$1C,$A0,$09        ;;E2E9|E2E7+E2E7/E2E7\E2E7;
                      db $94,$1C,$C0,$0A,$14,$1D,$2C,$0B        ;;E2F1|E2EF+E2EF/E2EF\E2EF;
                      db $56,$1D,$A0,$09,$D4,$1D,$98,$09        ;;E2F9|E2F7+E2F7/E2F7\E2F7;
                      db $90,$39,$98,$09,$94,$39,$28,$09        ;;E301|E2FF+E2FF/E2FF\E2FF;
                      db $98,$39,$98,$09,$9C,$39,$98,$09        ;;E309|E307+E307/E307\E307;
                      db $A0,$39,$28,$09,$A4,$39,$98,$09        ;;E311|E30F+E30F/E30F\E30F;
                      db $A8,$39,$98,$09,$AC,$39,$28,$09        ;;E319|E317+E317/E317\E317;
                      db $B0,$39,$98,$09,$B4,$39,$98,$09        ;;E321|E31F+E31F/E31F\E31F;
                      db $B4,$38,$28,$09,$B0,$38,$98,$09        ;;E329|E327+E327/E327\E327;
                      db $AC,$38,$98,$09,$A8,$38,$28,$09        ;;E331|E32F+E32F/E32F\E32F;
                      db $A4,$38,$98,$09,$A0,$38,$98,$09        ;;E339|E337+E337/E337\E337;
                      db $9C,$38,$28,$09,$98,$38,$98,$09        ;;E341|E33F+E33F/E33F\E33F;
                      db $94,$38,$98,$09,$90,$38,$28,$09        ;;E349|E347+E347/E347\E347;
                      db $8C,$38,$98,$09,$88,$38,$28,$09        ;;E351|E34F+E34F/E34F\E34F;
                      db $84,$38                                ;;E359|E357+E357/E357\E357;
                                                                ;;                        ;
DATA_04E359:          db $00,$00                                ;;E35B|E359+E359/E359\E359;
                                                                ;;                        ;
DATA_04E35B:          db $00,$00,$0D,$00,$0D,$00,$10,$00        ;;E35D|E35B+E35B/E35B\E35B;
                      db $15,$00,$18,$00,$1A,$00,$20,$00        ;;E365|E363+E363/E363\E363;
                      db $23,$00,$26,$00,$29,$00,$2C,$00        ;;E36D|E36B+E36B/E36B\E36B;
                      db $35,$00,$39,$00,$3A,$00,$42,$00        ;;E375|E373+E373/E373\E373;
                      db $46,$00,$4A,$00,$4C,$00,$4D,$00        ;;E37D|E37B+E37B/E37B\E37B;
                      db $4E,$00,$52,$00,$59,$00,$5D,$00        ;;E385|E383+E383/E383\E383;
                      db $60,$00,$67,$00,$6A,$00,$6C,$00        ;;E38D|E38B+E38B/E38B\E38B;
                      db $6F,$00,$72,$00,$75,$00,$77,$00        ;;E395|E393+E393/E393\E393;
                      db $77,$00,$83,$00,$83,$00,$84,$00        ;;E39D|E39B+E39B/E39B\E39B;
                      db $8E,$00,$90,$00,$92,$00,$98,$00        ;;E3A5|E3A3+E3A3/E3A3\E3A3;
                      db $98,$00,$98,$00,$A0,$00,$A5,$00        ;;E3AD|E3AB+E3AB/E3AB\E3AB;
                      db $AC,$00,$B2,$00,$BD,$00,$C2,$00        ;;E3B5|E3B3+E3B3/E3B3\E3B3;
                      db $C5,$00,$CC,$00,$D3,$00,$D7,$00        ;;E3BD|E3BB+E3BB/E3BB\E3BB;
                      db $E1,$00,$E2,$00,$E2,$00,$E2,$00        ;;E3C5|E3C3+E3C3/E3C3\E3C3;
                      db $E5,$00,$E7,$00,$E8,$00,$ED,$00        ;;E3CD|E3CB+E3CB/E3CB\E3CB;
                      db $EE,$00,$F1,$00,$F5,$00,$FA,$00        ;;E3D5|E3D3+E3D3/E3D3\E3D3;
                      db $FD,$00,$00,$01,$00,$01,$00,$01        ;;E3DD|E3DB+E3DB/E3DB\E3DB;
                      db $00,$01,$00,$01,$02,$01,$08,$01        ;;E3E5|E3E3+E3E3/E3E3\E3E3;
                      db $0F,$01,$12,$01,$14,$01,$16,$01        ;;E3ED|E3EB+E3EB/E3EB\E3EB;
                      db $17,$01,$1E,$01,$2B,$01,$2B,$01        ;;E3F5|E3F3+E3F3/E3F3\E3F3;
                      db $2B,$01,$2B,$01,$2F,$01,$2F,$01        ;;E3FD|E3FB+E3FB/E3FB\E3FB;
                      db $2F,$01,$33,$01,$33,$01,$33,$01        ;;E405|E403+E403/E403\E403;
                      db $37,$01,$37,$01,$37,$01,$40,$01        ;;E40D|E40B+E40B/E40B\E40B;
                      db $40,$01,$46,$01,$46,$01,$46,$01        ;;E415|E413+E413/E413\E413;
                      db $47,$01,$52,$01,$56,$01,$5C,$01        ;;E41D|E41B+E41B/E41B\E41B;
                      db $5C,$01,$5F,$01,$62,$01,$65,$01        ;;E425|E423+E423/E423\E423;
                      db $68,$01,$6B,$01,$6E,$01,$71,$01        ;;E42D|E42B+E42B/E42B\E42B;
                      db $73,$01,$73,$01,$73,$01,$73,$01        ;;E435|E433+E433/E433\E433;
                      db $73,$01,$73,$01,$73,$01,$73,$01        ;;E43D|E43B+E43B/E43B\E43B;
                      db $73,$01,$73,$01,$73,$01,$73,$01        ;;E445|E443+E443/E443\E443;
DATA_04E44B:          db $80,$40,$20,$10,$08,$04,$02,$01        ;;E44D|E44B+E44B/E44B\E44B;
                                                                ;;                        ;
CODE_04E453:          SEP #$30                                  ;;E455|E453+E453/E453\E453; Index (8 bit) Accum (8 bit) 
                      LDA.B !_F                                 ;;E457|E455+E455/E455\E455;
                      AND.B #$07                                ;;E459|E457+E457/E457\E457;
                      TAX                                       ;;E45B|E459+E459/E459\E459;
                      LDA.B !_F                                 ;;E45C|E45A+E45A/E45A\E45A;
                      LSR A                                     ;;E45E|E45C+E45C/E45C\E45C;
                      LSR A                                     ;;E45F|E45D+E45D/E45D\E45D;
                      LSR A                                     ;;E460|E45E+E45E/E45E\E45E;
                      TAY                                       ;;E461|E45F+E45F/E45F\E45F;
                      LDA.W !OWEventsActivated,Y                ;;E462|E460+E460/E460\E460;
                      AND.L DATA_04E44B,X                       ;;E465|E463+E463/E463\E463;
                      BNE +                                     ;;E469|E467+E467/E467\E467;
                      RTS                                       ;;E46B|E469+E469/E469\E469; Return 
                                                                ;;                        ;
                    + LDA.B !_F                                 ;;E46C|E46A+E46A/E46A\E46A;
                      ASL A                                     ;;E46E|E46C+E46C/E46C\E46C;
                      TAX                                       ;;E46F|E46D+E46D/E46D\E46D;
                      REP #$20                                  ;;E470|E46E+E46E/E46E\E46E; Accum (16 bit) 
                      LDA.L DATA_04E359,X                       ;;E472|E470+E470/E470\E470;
                      STA.W !EventTileIndex                     ;;E476|E474+E474/E474\E474;
                      LDA.L DATA_04E35B,X                       ;;E479|E477+E477/E477\E477;
                      STA.W !EventLength                        ;;E47D|E47B+E47B/E47B\E47B;
                      CMP.W !EventTileIndex                     ;;E480|E47E+E47E/E47E\E47E;
                      BEQ CODE_04E493                           ;;E483|E481+E481/E481\E481;
                    - JSR CODE_04E496                           ;;E485|E483+E483/E483\E483;
                      REP #$20                                  ;;E488|E486+E486/E486\E486; Accum (16 bit) 
                      INC.W !EventTileIndex                     ;;E48A|E488+E488/E488\E488;
                      LDA.W !EventTileIndex                     ;;E48D|E48B+E48B/E48B\E48B;
                      CMP.W !EventLength                        ;;E490|E48E+E48E/E48E\E48E;
                      BNE -                                     ;;E493|E491+E491/E491\E491;
CODE_04E493:          SEP #$30                                  ;;E495|E493+E493/E493\E493; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;E497|E495+E495/E495\E495; Return 
                                                                ;;                        ;
CODE_04E496:          REP #$30                                  ;;E498|E496+E496/E496\E496; Index (16 bit) Accum (16 bit) 
                      LDA.W !EventTileIndex                     ;;E49A|E498+E498/E498\E498;
                      ASL A                                     ;;E49D|E49B+E49B/E49B\E49B;
                      ASL A                                     ;;E49E|E49C+E49C/E49C\E49C;
                      TAX                                       ;;E49F|E49D+E49D/E49D\E49D;
                      LDA.L DATA_04DD8D,X                       ;;E4A0|E49E+E49E/E49E\E49E;
                      TAY                                       ;;E4A4|E4A2+E4A2/E4A2\E4A2;
                      LDA.L DATA_04DD8F,X                       ;;E4A5|E4A3+E4A3/E4A3\E4A3;
                      STA.B !_4                                 ;;E4A9|E4A7+E4A7/E4A7\E4A7;
CODE_04E4A9:          SEP #$20                                  ;;E4AB|E4A9+E4A9/E4A9\E4A9; Accum (8 bit) 
                      LDA.B #$7F                                ;;E4AD|E4AB+E4AB/E4AB\E4AB;
                      STA.B !_8                                 ;;E4AF|E4AD+E4AD/E4AD\E4AD;
                      LDA.B #$0C                                ;;E4B1|E4AF+E4AF/E4AF\E4AF;
                      STA.B !_B                                 ;;E4B3|E4B1+E4B1/E4B1\E4B1;
                      REP #$20                                  ;;E4B5|E4B3+E4B3/E4B3\E4B3; Accum (16 bit) 
                      LDA.W #$0000                              ;;E4B7|E4B5+E4B5/E4B5\E4B5;
                      STA.B !_6                                 ;;E4BA|E4B8+E4B8/E4B8\E4B8;
                      LDA.W #$8000                              ;;E4BC|E4BA+E4BA/E4BA\E4BA;
                      STA.B !_9                                 ;;E4BF|E4BD+E4BD/E4BD\E4BD;
                      CPY.W #$0900                              ;;E4C1|E4BF+E4BF/E4BF\E4BF;
                      BCC +                                     ;;E4C4|E4C2+E4C2/E4C2\E4C2;
                      JSR CODE_04E4D0                           ;;E4C6|E4C4+E4C4/E4C4\E4C4;
                      JMP CODE_04E4CD                           ;;E4C9|E4C7+E4C7/E4C7\E4C7;
                                                                ;;                        ;
                    + JSR CODE_04E520                           ;;E4CC|E4CA+E4CA/E4CA\E4CA;
CODE_04E4CD:          SEP #$30                                  ;;E4CF|E4CD+E4CD/E4CD\E4CD; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;E4D1|E4CF+E4CF/E4CF\E4CF; Return 
                                                                ;;                        ;
CODE_04E4D0:          LDA.W #$0001                              ;;E4D2|E4D0+E4D0/E4D0\E4D0; Accum (16 bit) 
                      STA.B !_0                                 ;;E4D5|E4D3+E4D3/E4D3\E4D3;
CODE_04E4D5:          LDX.B !_4                                 ;;E4D7|E4D5+E4D5/E4D5\E4D5;
                      LDA.W #$0001                              ;;E4D9|E4D7+E4D7/E4D7\E4D7;
                      STA.B !_C                                 ;;E4DC|E4DA+E4DA/E4DA\E4DA;
CODE_04E4DC:          SEP #$20                                  ;;E4DE|E4DC+E4DC/E4DC\E4DC; Accum (8 bit) 
                      LDA.B [!_9],Y                             ;;E4E0|E4DE+E4DE/E4DE\E4DE;
                      STA.L !OWLayer2Tilemap,X                  ;;E4E2|E4E0+E4E0/E4E0\E4E0;
                      INX                                       ;;E4E6|E4E4+E4E4/E4E4\E4E4;
                      LDA.B [!_6],Y                             ;;E4E7|E4E5+E4E5/E4E5\E4E5;
                      STA.L !OWLayer2Tilemap,X                  ;;E4E9|E4E7+E4E7/E4E7\E4E7;
                      INY                                       ;;E4ED|E4EB+E4EB/E4EB\E4EB;
                      INX                                       ;;E4EE|E4EC+E4EC/E4EC\E4EC;
                      REP #$20                                  ;;E4EF|E4ED+E4ED/E4ED\E4ED; Accum (16 bit) 
                      TXA                                       ;;E4F1|E4EF+E4EF/E4EF\E4EF;
                      AND.W #$003F                              ;;E4F2|E4F0+E4F0/E4F0\E4F0;
                      BNE +                                     ;;E4F5|E4F3+E4F3/E4F3\E4F3;
                      DEX                                       ;;E4F7|E4F5+E4F5/E4F5\E4F5;
                      TXA                                       ;;E4F8|E4F6+E4F6/E4F6\E4F6;
                      AND.W #$FFC0                              ;;E4F9|E4F7+E4F7/E4F7\E4F7;
                      CLC                                       ;;E4FC|E4FA+E4FA/E4FA\E4FA;
                      ADC.W #$0800                              ;;E4FD|E4FB+E4FB/E4FB\E4FB;
                      TAX                                       ;;E500|E4FE+E4FE/E4FE\E4FE;
                    + DEC.B !_C                                 ;;E501|E4FF+E4FF/E4FF\E4FF;
                      BPL CODE_04E4DC                           ;;E503|E501+E501/E501\E501;
                      LDA.B !_4                                 ;;E505|E503+E503/E503\E503;
                      TAX                                       ;;E507|E505+E505/E505\E505;
                      CLC                                       ;;E508|E506+E506/E506\E506;
                      ADC.W #$0040                              ;;E509|E507+E507/E507\E507;
                      STA.B !_4                                 ;;E50C|E50A+E50A/E50A\E50A;
                      AND.W #$07C0                              ;;E50E|E50C+E50C/E50C\E50C;
                      BNE +                                     ;;E511|E50F+E50F/E50F\E50F;
                      TXA                                       ;;E513|E511+E511/E511\E511;
                      AND.W #$F83F                              ;;E514|E512+E512/E512\E512;
                      CLC                                       ;;E517|E515+E515/E515\E515;
                      ADC.W #$1000                              ;;E518|E516+E516/E516\E516;
                      STA.B !_4                                 ;;E51B|E519+E519/E519\E519;
                    + DEC.B !_0                                 ;;E51D|E51B+E51B/E51B\E51B;
                      BPL CODE_04E4D5                           ;;E51F|E51D+E51D/E51D\E51D;
                      RTS                                       ;;E521|E51F+E51F/E51F\E51F; Return 
                                                                ;;                        ;
CODE_04E520:          LDA.W #$0005                              ;;E522|E520+E520/E520\E520;
                      STA.B !_0                                 ;;E525|E523+E523/E523\E523;
CODE_04E525:          LDX.B !_4                                 ;;E527|E525+E525/E525\E525;
                      LDA.W #$0005                              ;;E529|E527+E527/E527\E527;
                      STA.B !_C                                 ;;E52C|E52A+E52A/E52A\E52A;
CODE_04E52C:          SEP #$20                                  ;;E52E|E52C+E52C/E52C\E52C; Accum (8 bit) 
                      LDA.B [!_9],Y                             ;;E530|E52E+E52E/E52E\E52E;
                      STA.L !OWLayer2Tilemap,X                  ;;E532|E530+E530/E530\E530;
                      INX                                       ;;E536|E534+E534/E534\E534;
                      LDA.B [!_6],Y                             ;;E537|E535+E535/E535\E535;
                      STA.L !OWLayer2Tilemap,X                  ;;E539|E537+E537/E537\E537;
                      INY                                       ;;E53D|E53B+E53B/E53B\E53B;
                      INX                                       ;;E53E|E53C+E53C/E53C\E53C;
                      REP #$20                                  ;;E53F|E53D+E53D/E53D\E53D; Accum (16 bit) 
                      TXA                                       ;;E541|E53F+E53F/E53F\E53F;
                      AND.W #$003F                              ;;E542|E540+E540/E540\E540;
                      BNE +                                     ;;E545|E543+E543/E543\E543;
                      DEX                                       ;;E547|E545+E545/E545\E545;
                      TXA                                       ;;E548|E546+E546/E546\E546;
                      AND.W #$FFC0                              ;;E549|E547+E547/E547\E547;
                      CLC                                       ;;E54C|E54A+E54A/E54A\E54A;
                      ADC.W #$0800                              ;;E54D|E54B+E54B/E54B\E54B;
                      TAX                                       ;;E550|E54E+E54E/E54E\E54E;
                    + DEC.B !_C                                 ;;E551|E54F+E54F/E54F\E54F;
                      BPL CODE_04E52C                           ;;E553|E551+E551/E551\E551;
                      LDA.B !_4                                 ;;E555|E553+E553/E553\E553;
                      TAX                                       ;;E557|E555+E555/E555\E555;
                      CLC                                       ;;E558|E556+E556/E556\E556;
                      ADC.W #$0040                              ;;E559|E557+E557/E557\E557;
                      STA.B !_4                                 ;;E55C|E55A+E55A/E55A\E55A;
                      AND.W #$07C0                              ;;E55E|E55C+E55C/E55C\E55C;
                      BNE +                                     ;;E561|E55F+E55F/E55F\E55F;
                      TXA                                       ;;E563|E561+E561/E561\E561;
                      AND.W #$F83F                              ;;E564|E562+E562/E562\E562;
                      CLC                                       ;;E567|E565+E565/E565\E565;
                      ADC.W #$1000                              ;;E568|E566+E566/E566\E566;
                      STA.B !_4                                 ;;E56B|E569+E569/E569\E569;
                    + DEC.B !_0                                 ;;E56D|E56B+E56B/E56B\E56B;
                      BPL CODE_04E525                           ;;E56F|E56D+E56D/E56D\E56D;
                      RTS                                       ;;E571|E56F+E56F/E56F\E56F; Return 
                                                                ;;                        ;
CODE_04E570:          LDA.W !OverworldEventProcess              ;;E572|E570+E570/E570\E570;
                      JSL ExecutePtr                            ;;E575|E573+E573/E573\E573;
                                                                ;;                        ;
                      dw CODE_04E5EE                            ;;E579|E577+E577/E577\E577;
                      dw CODE_04EBEB                            ;;E57B|E579+E579/E579\E579;
                      dw CODE_04E6D3                            ;;E57D|E57B+E57B/E57B\E57B;
                      dw CODE_04E6F9                            ;;E57F|E57D+E57D/E57D\E57D;
                      dw CODE_04EAA4                            ;;E581|E57F+E57F/E57F\E57F;
                      dw CODE_04EC78                            ;;E583|E581+E581/E581\E581;
                      dw CODE_04EBEB                            ;;E585|E583+E583/E583\E583;
                      dw CODE_04E9EC                            ;;E587|E585+E585/E585\E585;
                                                                ;;                        ;
DATA_04E587:          db $20,$52,$22,$DA,$28,$58,$24,$C0        ;;E589|E587+E587/E587\E587;
                      db $24,$94,$23,$42,$28,$94,$2A,$98        ;;E591|E58F+E58F/E58F\E58F;
                      db $25,$0E,$25,$52,$25,$C4,$2A,$DE        ;;E599|E597+E597/E597\E597;
                      db $2A,$98,$28,$44,$2C,$50,$2C,$0C        ;;E5A1|E59F+E59F/E59F\E59F;
DATA_04E5A7:          db $77,$79,$58,$4C,$A6                    ;;E5A9|E5A7+E5A7/E5A7\E5A7;
                                                                ;;                        ;
DATA_04E5AC:          db $85,$86,$00,$10,$00                    ;;E5AE|E5AC+E5AC/E5AC\E5AC;
                                                                ;;                        ;
DATA_04E5B1:          db $85,$86,$81,$81,$81                    ;;E5B3|E5B1+E5B1/E5B1\E5B1;
                                                                ;;                        ;
DATA_04E5B6:          db $19,$04,$BD,$00,$1C,$06,$30,$01        ;;E5B8|E5B6+E5B6/E5B6\E5B6;
                      db $2A,$01,$D1,$00,$2A,$06,$AC,$06        ;;E5C0|E5BE+E5BE/E5BE\E5BE;
                      db $47,$05,$59,$05,$72,$05,$BF,$02        ;;E5C8|E5C6+E5C6/E5C6\E5C6;
                      db $AC,$02,$12,$02,$18,$03,$06,$03        ;;E5D0|E5CE+E5CE/E5CE\E5CE;
DATA_04E5D6:          db $06,$0F,$1C,$21,$24,$28,$29,$37        ;;E5D8|E5D6+E5D6/E5D6\E5D6;
                      db $40,$41,$43,$4A,$4D,$02,$61,$35        ;;E5E0|E5DE+E5DE/E5DE\E5DE;
DATA_04E5E6:          db $58,$59,$5D,$63,$77,$79,$7E,$80        ;;E5E8|E5E6+E5E6/E5E6\E5E6;
                                                                ;;                        ;
CODE_04E5EE:          LDA.W !OWLevelExitMode                    ;;E5F0|E5EE+E5EE/E5EE\E5EE; Accum (8 bit) 
                      CMP.B #$02                                ;;E5F3|E5F1+E5F1/E5F1\E5F1;
                      BNE +                                     ;;E5F5|E5F3+E5F3/E5F3\E5F3;
                      INC.W !OverworldEvent                     ;;E5F7|E5F5+E5F5/E5F5\E5F5;
                    + LDA.W !CreditsScreenNumber                ;;E5FA|E5F8+E5F8/E5F8\E5F8;
                      BEQ CODE_04E61A                           ;;E5FD|E5FB+E5FB/E5FB\E5FB;
                      LDA.W !OverworldEvent                     ;;E5FF|E5FD+E5FD/E5FD\E5FD;
                      CMP.B #$FF                                ;;E602|E600+E600/E600\E600;
                      BEQ CODE_04E61A                           ;;E604|E602+E602/E602\E602;
                      LDA.W !OverworldEvent                     ;;E606|E604+E604/E604\E604;
                      AND.B #$07                                ;;E609|E607+E607/E607\E607;
                      TAX                                       ;;E60B|E609+E609/E609\E609;
                      LDA.W !OverworldEvent                     ;;E60C|E60A+E60A/E60A\E60A;
                      LSR A                                     ;;E60F|E60D+E60D/E60D\E60D;
                      LSR A                                     ;;E610|E60E+E60E/E60E\E60E;
                      LSR A                                     ;;E611|E60F+E60F/E60F\E60F;
                      TAY                                       ;;E612|E610+E610/E610\E610;
                      LDA.W !OWEventsActivated,Y                ;;E613|E611+E611/E611\E611;
                      AND.L DATA_04E44B,X                       ;;E616|E614+E614/E614\E614;
                      BEQ CODE_04E640                           ;;E61A|E618+E618/E618\E618;
CODE_04E61A:          LDX.B #$07                                ;;E61C|E61A+E61A/E61A\E61A;
CODE_04E61C:          LDA.W DATA_04E5E6,X                       ;;E61E|E61C+E61C/E61C\E61C;
                      CMP.W !OverworldLayer1Tile                ;;E621|E61F+E61F/E61F\E61F;
                      BNE +                                     ;;E624|E622+E622/E622\E622;
                      INC.W !OverworldProcess                   ;;E626|E624+E624/E624\E624;
                      LDA.B #$E0                                ;;E629|E627+E627/E627\E627;
                      STA.W !OWLevelExitMode                    ;;E62B|E629+E629/E629\E629;
                      LDA.B #$0F                                ;;E62E|E62C+E62C/E62C\E62C;
                      STA.W !KeepModeActive                     ;;E630|E62E+E62E/E62E\E62E;
                      RTS                                       ;;E633|E631+E631/E631\E631; Return 
                                                                ;;                        ;
                    + DEX                                       ;;E634|E632+E632/E632\E632;
                      BPL CODE_04E61C                           ;;E635|E633+E633/E633\E633;
                      LDA.B #$05                                ;;E637|E635+E635/E635\E635;
                      STA.W !OverworldProcess                   ;;E639|E637+E637/E637\E637;
                      LDA.B #$80                                ;;E63C|E63A+E63A/E63A\E63A;
                      STA.W !OWLevelExitMode                    ;;E63E|E63C+E63C/E63C\E63C;
                      RTS                                       ;;E641|E63F+E63F/E63F\E63F; Return 
                                                                ;;                        ;
CODE_04E640:          INC.W !OverworldEventProcess              ;;E642|E640+E640/E640\E640;
                      LDA.W !OverworldEvent                     ;;E645|E643+E643/E643\E643;
                      JSR CODE_04E677                           ;;E648|E646+E646/E646\E646;
                      TYA                                       ;;E64B|E649+E649/E649\E649;
                      ASL A                                     ;;E64C|E64A+E64A/E64A\E64A;
                      ASL A                                     ;;E64D|E64B+E64B/E64B\E64B;
                      ASL A                                     ;;E64E|E64C+E64C/E64C\E64C;
                      ASL A                                     ;;E64F|E64D+E64D/E64D\E64D;
                      STA.W !OverworldEventXPos                 ;;E650|E64E+E64E/E64E\E64E;
                      TYA                                       ;;E653|E651+E651/E651\E651;
                      AND.B #$F0                                ;;E654|E652+E652/E652\E652;
                      STA.W !OverworldEventYPos                 ;;E656|E654+E654/E654\E654;
                      LDA.B #$28                                ;;E659|E657+E657/E657\E657;
                      STA.W !OverworldEventSize                 ;;E65B|E659+E659/E659\E659;
                      LDA.W !TranslevelNo                       ;;E65E|E65C+E65C/E65C\E65C;
                      CMP.B #$18                                ;;E661|E65F+E65F/E65F\E65F;
                      BNE +                                     ;;E663|E661+E661/E661\E661;
                      LDA.B #$FF                                ;;E665|E663+E663/E663\E663;
                      STA.W !OverworldEarthquake                ;;E667|E665+E665/E665\E665;
                    + LDA.W !OverworldEventProcess              ;;E66A|E668+E668/E668\E668;
                      CMP.B #$02                                ;;E66D|E66B+E66B/E66B\E66B;
                      BEQ +                                     ;;E66F|E66D+E66D/E66D\E66D;
                      LDA.B #!SFX_CASTLECRUSH                   ;;E671|E66F+E66F/E66F\E66F;
                      STA.W !SPCIO3                             ;;E673|E671+E671/E671\E671; / Play sound effect 
                    + SEP #$30                                  ;;E676|E674+E674/E674\E674; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;E678|E676+E676/E676\E676; Return 
                                                                ;;                        ;
CODE_04E677:          SEP #$30                                  ;;E679|E677+E677/E677\E677; Index (8 bit) Accum (8 bit) 
                      LDX.B #$17                                ;;E67B|E679+E679/E679\E679;
CODE_04E67B:          CMP.L DATA_04E5D6,X                       ;;E67D|E67B+E67B/E67B\E67B;
                      BEQ CODE_04E68A                           ;;E681|E67F+E67F/E67F\E67F;
                      DEX                                       ;;E683|E681+E681/E681\E681;
                      BPL CODE_04E67B                           ;;E684|E682+E682/E682\E682;
CODE_04E684:          LDA.B #$02                                ;;E686|E684+E684/E684\E684;
                      STA.W !OverworldEventProcess              ;;E688|E686+E686/E686\E686;
                      RTS                                       ;;E68B|E689+E689/E689\E689; Return 
                                                                ;;                        ;
CODE_04E68A:          STX.W !StructureCrushIndex                ;;E68C|E68A+E68A/E68A\E68A;
                      TXA                                       ;;E68F|E68D+E68D/E68D\E68D;
                      ASL A                                     ;;E690|E68E+E68E/E68E\E68E;
                      TAX                                       ;;E691|E68F+E68F/E68F\E68F;
                      LDA.B #$7E                                ;;E692|E690+E690/E690\E690;
                      STA.B !_C                                 ;;E694|E692+E692/E692\E692;
                      REP #$30                                  ;;E696|E694+E694/E694\E694; Index (16 bit) Accum (16 bit) 
                      LDA.W #$C800                              ;;E698|E696+E696/E696\E696;
                      STA.B !_A                                 ;;E69B|E699+E699/E699\E699;
                      LDA.L DATA_04E5B6,X                       ;;E69D|E69B+E69B/E69B\E69B;
                      TAY                                       ;;E6A1|E69F+E69F/E69F\E69F;
                      SEP #$20                                  ;;E6A2|E6A0+E6A0/E6A0\E6A0; Accum (8 bit) 
                      LDX.W #$0004                              ;;E6A4|E6A2+E6A2/E6A2\E6A2;
                      LDA.B [!_A],Y                             ;;E6A7|E6A5+E6A5/E6A5\E6A5;
CODE_04E6A7:          CMP.L DATA_04E5A7,X                       ;;E6A9|E6A7+E6A7/E6A7\E6A7;
                      BEQ CODE_04E6B3                           ;;E6AD|E6AB+E6AB/E6AB\E6AB;
                      DEX                                       ;;E6AF|E6AD+E6AD/E6AD\E6AD;
                      BPL CODE_04E6A7                           ;;E6B0|E6AE+E6AE/E6AE\E6AE;
                      JMP CODE_04E684                           ;;E6B2|E6B0+E6B0/E6B0\E6B0;
                                                                ;;                        ;
CODE_04E6B3:          TXA                                       ;;E6B5|E6B3+E6B3/E6B3\E6B3;
                      STA.W !StructureCrushTile                 ;;E6B6|E6B4+E6B4/E6B4\E6B4;
                      CPX.W #$0003                              ;;E6B9|E6B7+E6B7/E6B7\E6B7;
                      BMI +                                     ;;E6BC|E6BA+E6BA/E6BA\E6BA;
                      LDA.L DATA_04E5AC,X                       ;;E6BE|E6BC+E6BC/E6BC\E6BC;
                      STA.B [!_A],Y                             ;;E6C2|E6C0+E6C0/E6C0\E6C0;
                      REP #$20                                  ;;E6C4|E6C2+E6C2/E6C2\E6C2; Accum (16 bit) 
                      TYA                                       ;;E6C6|E6C4+E6C4/E6C4\E6C4;
                      CLC                                       ;;E6C7|E6C5+E6C5/E6C5\E6C5;
                      ADC.W #$0010                              ;;E6C8|E6C6+E6C6/E6C6\E6C6;
                      TAY                                       ;;E6CB|E6C9+E6C9/E6C9\E6C9;
                    + SEP #$20                                  ;;E6CC|E6CA+E6CA/E6CA\E6CA; Accum (8 bit) 
                      LDA.L DATA_04E5B1,X                       ;;E6CE|E6CC+E6CC/E6CC\E6CC;
                      STA.B [!_A],Y                             ;;E6D2|E6D0+E6D0/E6D0\E6D0;
                      RTS                                       ;;E6D4|E6D2+E6D2/E6D2\E6D2; Return 
                                                                ;;                        ;
CODE_04E6D3:          INC.W !OverworldEventProcess              ;;E6D5|E6D3+E6D3/E6D3\E6D3;
                      LDA.W !OverworldEvent                     ;;E6D8|E6D6+E6D6/E6D6\E6D6;
                      ASL A                                     ;;E6DB|E6D9+E6D9/E6D9\E6D9;
                      TAX                                       ;;E6DC|E6DA+E6DA/E6DA\E6DA;
                      REP #$20                                  ;;E6DD|E6DB+E6DB/E6DB\E6DB; Accum (16 bit) 
                      LDA.L DATA_04E359,X                       ;;E6DF|E6DD+E6DD/E6DD\E6DD;
                      STA.W !EventTileIndex                     ;;E6E3|E6E1+E6E1/E6E1\E6E1;
                      LDA.L DATA_04E35B,X                       ;;E6E6|E6E4+E6E4/E6E4\E6E4;
                      STA.W !EventLength                        ;;E6EA|E6E8+E6E8/E6E8\E6E8;
                      CMP.W !EventTileIndex                     ;;E6ED|E6EB+E6EB/E6EB\E6EB;
                      SEP #$20                                  ;;E6F0|E6EE+E6EE/E6EE\E6EE; Accum (8 bit) 
                      BNE +                                     ;;E6F2|E6F0+E6F0/E6F0\E6F0;
                      INC.W !OverworldEventProcess              ;;E6F4|E6F2+E6F2/E6F2\E6F2;
                      INC.W !OverworldEventProcess              ;;E6F7|E6F5+E6F5/E6F5\E6F5;
                    + RTS                                       ;;E6FA|E6F8+E6F8/E6F8\E6F8; Return 
                                                                ;;                        ;
CODE_04E6F9:          JSR CODE_04EA62                           ;;E6FB|E6F9+E6F9/E6F9\E6F9;
                      LDA.B #$7F                                ;;E6FE|E6FC+E6FC/E6FC\E6FC;
                      STA.B !_E                                 ;;E700|E6FE+E6FE/E6FE\E6FE;
                      REP #$30                                  ;;E702|E700+E700/E700\E700; Index (16 bit) Accum (16 bit) 
                      LDA.W !EventTileIndex                     ;;E704|E702+E702/E702\E702;
                      ASL A                                     ;;E707|E705+E705/E705\E705;
                      ASL A                                     ;;E708|E706+E706/E706\E706;
                      TAX                                       ;;E709|E707+E707/E707\E707;
                      LDA.L DATA_04DD8D,X                       ;;E70A|E708+E708/E708\E708;
                      STA.W !OverworldEventSize                 ;;E70E|E70C+E70C/E70C\E70C;
                      LDA.L DATA_04DD8F,X                       ;;E711|E70F+E70F/E70F\E70F;
                      STA.B !_0                                 ;;E715|E713+E713/E713\E713;
                      AND.W #$1FFF                              ;;E717|E715+E715/E715\E715;
                      LSR A                                     ;;E71A|E718+E718/E718\E718;
                      CLC                                       ;;E71B|E719+E719/E719\E719;
                      ADC.W #$3000                              ;;E71C|E71A+E71A/E71A\E71A;
                      XBA                                       ;;E71F|E71D+E71D/E71D\E71D;
                      STA.B !_2                                 ;;E720|E71E+E71E/E71E\E71E;
                      LDA.B !_0                                 ;;E722|E720+E720/E720\E720;
                      LSR A                                     ;;E724|E722+E722/E722\E722;
                      LSR A                                     ;;E725|E723+E723/E723\E723;
                      LSR A                                     ;;E726|E724+E724/E724\E724;
                      SEP #$20                                  ;;E727|E725+E725/E725\E725; Accum (8 bit) 
                      AND.B #$F8                                ;;E729|E727+E727/E727\E727;
                      STA.W !OverworldEventYPos                 ;;E72B|E729+E729/E729\E729;
                      LDA.B !_0                                 ;;E72E|E72C+E72C/E72C\E72C;
                      AND.B #$3E                                ;;E730|E72E+E72E/E72E\E72E;
                      ASL A                                     ;;E732|E730+E730/E730\E730;
                      ASL A                                     ;;E733|E731+E731/E731\E731;
                      STA.W !OverworldEventXPos                 ;;E734|E732+E732/E732\E732;
                      REP #$20                                  ;;E737|E735+E735/E735\E735; Accum (16 bit) 
                      LDA.W #$4000                              ;;E739|E737+E737/E737\E737;
                      STA.B !_C                                 ;;E73C|E73A+E73A/E73A\E73A;
                      LDA.W #$EFFF                              ;;E73E|E73C+E73C/E73C\E73C;
                      STA.B !_A                                 ;;E741|E73F+E73F/E73F\E73F;
                      LDA.W !OverworldEventSize                 ;;E743|E741+E741/E741\E741;
                      CMP.W #$0900                              ;;E746|E744+E744/E744\E744;
                      BCC +                                     ;;E749|E747+E747/E747\E747;
                      JSR CODE_04E76C                           ;;E74B|E749+E749/E749\E749;
                      JMP CODE_04E752                           ;;E74E|E74C+E74C/E74C\E74C;
                                                                ;;                        ;
                    + JSR CODE_04E824                           ;;E751|E74F+E74F/E74F\E74F;
CODE_04E752:          LDA.W #$00FF                              ;;E754|E752+E752/E752\E752;
                      STA.L !DynamicStripeImage,X               ;;E757|E755+E755/E755\E755;
                      TXA                                       ;;E75B|E759+E759/E759\E759;
                      STA.L !DynStripeImgSize                   ;;E75C|E75A+E75A/E75A\E75A;
                      JSR CODE_04E496                           ;;E760|E75E+E75E/E75E\E75E;
                      SEP #$30                                  ;;E763|E761+E761/E761\E761; Index (8 bit) Accum (8 bit) 
                      LDA.B #!SFX_NEWLEVEL                      ;;E765|E763+E763/E763\E763;
                      STA.W !SPCIO3                             ;;E767|E765+E765/E765\E765; / Play sound effect 
                      INC.W !OverworldEventProcess              ;;E76A|E768+E768/E768\E768;
                      RTS                                       ;;E76D|E76B+E76B/E76B\E76B; Return 
                                                                ;;                        ;
CODE_04E76C:          LDA.W #$0001                              ;;E76E|E76C+E76C/E76C\E76C; Index (16 bit) Accum (16 bit) 
                      STA.B !_6                                 ;;E771|E76F+E76F/E76F\E76F;
                      LDA.L !DynStripeImgSize                   ;;E773|E771+E771/E771\E771;
                      TAX                                       ;;E777|E775+E775/E775\E775;
CODE_04E776:          LDA.B !_2                                 ;;E778|E776+E776/E776\E776;
                      STA.L !DynamicStripeImage,X               ;;E77A|E778+E778/E778\E778;
                      INX                                       ;;E77E|E77C+E77C/E77C\E77C;
                      INX                                       ;;E77F|E77D+E77D/E77D\E77D;
                      LDY.W #$0300                              ;;E780|E77E+E77E/E77E\E77E;
                      LDA.B !_3                                 ;;E783|E781+E781/E781\E781;
                      AND.W #$001F                              ;;E785|E783+E783/E783\E783;
                      STA.B !_8                                 ;;E788|E786+E786/E786\E786;
                      LDA.W #$0020                              ;;E78A|E788+E788/E788\E788;
                      SEC                                       ;;E78D|E78B+E78B/E78B\E78B;
                      SBC.B !_8                                 ;;E78E|E78C+E78C/E78C\E78C;
                      STA.B !_8                                 ;;E790|E78E+E78E/E78E\E78E;
                      CMP.W #$0001                              ;;E792|E790+E790/E790\E790;
                      BNE +                                     ;;E795|E793+E793/E793\E793;
                      LDA.B !_8                                 ;;E797|E795+E795/E795\E795;
                      ASL A                                     ;;E799|E797+E797/E797\E797;
                      DEC A                                     ;;E79A|E798+E798/E798\E798;
                      XBA                                       ;;E79B|E799+E799/E799\E799;
                      TAY                                       ;;E79C|E79A+E79A/E79A\E79A;
                    + TYA                                       ;;E79D|E79B+E79B/E79B\E79B;
                      STA.L !DynamicStripeImage,X               ;;E79E|E79C+E79C/E79C\E79C;
                      INX                                       ;;E7A2|E7A0+E7A0/E7A0\E7A0;
                      INX                                       ;;E7A3|E7A1+E7A1/E7A1\E7A1;
                      LDA.W #$0001                              ;;E7A4|E7A2+E7A2/E7A2\E7A2;
                      STA.B !_4                                 ;;E7A7|E7A5+E7A5/E7A5\E7A5;
                      LDY.B !_0                                 ;;E7A9|E7A7+E7A7/E7A7\E7A7;
CODE_04E7A9:          LDA.B [!_C],Y                             ;;E7AB|E7A9+E7A9/E7A9\E7A9;
                      AND.B !_A                                 ;;E7AD|E7AB+E7AB/E7AB\E7AB;
                      STA.L !DynamicStripeImage,X               ;;E7AF|E7AD+E7AD/E7AD\E7AD;
                      INX                                       ;;E7B3|E7B1+E7B1/E7B1\E7B1;
                      INX                                       ;;E7B4|E7B2+E7B2/E7B2\E7B2;
                      INY                                       ;;E7B5|E7B3+E7B3/E7B3\E7B3;
                      INY                                       ;;E7B6|E7B4+E7B4/E7B4\E7B4;
                      TYA                                       ;;E7B7|E7B5+E7B5/E7B5\E7B5;
                      AND.W #$003F                              ;;E7B8|E7B6+E7B6/E7B6\E7B6;
                      BNE +                                     ;;E7BB|E7B9+E7B9/E7B9\E7B9;
                      LDA.B !_4                                 ;;E7BD|E7BB+E7BB/E7BB\E7BB;
                      BEQ +                                     ;;E7BF|E7BD+E7BD/E7BD\E7BD;
                      DEY                                       ;;E7C1|E7BF+E7BF/E7BF\E7BF;
                      TYA                                       ;;E7C2|E7C0+E7C0/E7C0\E7C0;
                      AND.W #$FFC0                              ;;E7C3|E7C1+E7C1/E7C1\E7C1;
                      CLC                                       ;;E7C6|E7C4+E7C4/E7C4\E7C4;
                      ADC.W #$0800                              ;;E7C7|E7C5+E7C5/E7C5\E7C5;
                      TAY                                       ;;E7CA|E7C8+E7C8/E7C8\E7C8;
                      LDA.B !_2                                 ;;E7CB|E7C9+E7C9/E7C9\E7C9;
                      XBA                                       ;;E7CD|E7CB+E7CB/E7CB\E7CB;
                      AND.W #$3BE0                              ;;E7CE|E7CC+E7CC/E7CC\E7CC;
                      CLC                                       ;;E7D1|E7CF+E7CF/E7CF\E7CF;
                      ADC.W #$0400                              ;;E7D2|E7D0+E7D0/E7D0\E7D0;
                      XBA                                       ;;E7D5|E7D3+E7D3/E7D3\E7D3;
                      STA.L !DynamicStripeImage,X               ;;E7D6|E7D4+E7D4/E7D4\E7D4;
                      INX                                       ;;E7DA|E7D8+E7D8/E7D8\E7D8;
                      INX                                       ;;E7DB|E7D9+E7D9/E7D9\E7D9;
                      LDA.B !_8                                 ;;E7DC|E7DA+E7DA/E7DA\E7DA;
                      ASL A                                     ;;E7DE|E7DC+E7DC/E7DC\E7DC;
                      DEC A                                     ;;E7DF|E7DD+E7DD/E7DD\E7DD;
                      XBA                                       ;;E7E0|E7DE+E7DE/E7DE\E7DE;
                      STA.L !DynamicStripeImage,X               ;;E7E1|E7DF+E7DF/E7DF\E7DF;
                      INX                                       ;;E7E5|E7E3+E7E3/E7E3\E7E3;
                      INX                                       ;;E7E6|E7E4+E7E4/E7E4\E7E4;
                    + DEC.B !_4                                 ;;E7E7|E7E5+E7E5/E7E5\E7E5;
                      BPL CODE_04E7A9                           ;;E7E9|E7E7+E7E7/E7E7\E7E7;
                      LDA.B !_2                                 ;;E7EB|E7E9+E7E9/E7E9\E7E9;
                      XBA                                       ;;E7ED|E7EB+E7EB/E7EB\E7EB;
                      CLC                                       ;;E7EE|E7EC+E7EC/E7EC\E7EC;
                      ADC.W #$0020                              ;;E7EF|E7ED+E7ED/E7ED\E7ED;
                      XBA                                       ;;E7F2|E7F0+E7F0/E7F0\E7F0;
                      STA.B !_2                                 ;;E7F3|E7F1+E7F1/E7F1\E7F1;
                      LDA.B !_0                                 ;;E7F5|E7F3+E7F3/E7F3\E7F3;
                      TAY                                       ;;E7F7|E7F5+E7F5/E7F5\E7F5;
                      CLC                                       ;;E7F8|E7F6+E7F6/E7F6\E7F6;
                      ADC.W #$0040                              ;;E7F9|E7F7+E7F7/E7F7\E7F7;
                      STA.B !_0                                 ;;E7FC|E7FA+E7FA/E7FA\E7FA;
                      AND.W #$07C0                              ;;E7FE|E7FC+E7FC/E7FC\E7FC;
                      BNE +                                     ;;E801|E7FF+E7FF/E7FF\E7FF;
                      TYA                                       ;;E803|E801+E801/E801\E801;
                      AND.W #$F83F                              ;;E804|E802+E802/E802\E802;
                      CLC                                       ;;E807|E805+E805/E805\E805;
                      ADC.W #$1000                              ;;E808|E806+E806/E806\E806;
                      STA.B !_0                                 ;;E80B|E809+E809/E809\E809;
                      LDA.B !_2                                 ;;E80D|E80B+E80B/E80B\E80B;
                      XBA                                       ;;E80F|E80D+E80D/E80D\E80D;
                      SEC                                       ;;E810|E80E+E80E/E80E\E80E;
                      SBC.W #$0020                              ;;E811|E80F+E80F/E80F\E80F;
                      AND.W #$341F                              ;;E814|E812+E812/E812\E812;
                      CLC                                       ;;E817|E815+E815/E815\E815;
                      ADC.W #$0800                              ;;E818|E816+E816/E816\E816;
                      XBA                                       ;;E81B|E819+E819/E819\E819;
                      STA.B !_2                                 ;;E81C|E81A+E81A/E81A\E81A;
                    + DEC.B !_6                                 ;;E81E|E81C+E81C/E81C\E81C;
                      BMI +                                     ;;E820|E81E+E81E/E81E\E81E;
                      JMP CODE_04E776                           ;;E822|E820+E820/E820\E820;
                                                                ;;                        ;
                    + RTS                                       ;;E825|E823+E823/E823\E823; Return 
                                                                ;;                        ;
CODE_04E824:          LDA.W #$0005                              ;;E826|E824+E824/E824\E824;
                      STA.B !_6                                 ;;E829|E827+E827/E827\E827;
                      LDA.L !DynStripeImgSize                   ;;E82B|E829+E829/E829\E829;
                      TAX                                       ;;E82F|E82D+E82D/E82D\E82D;
CODE_04E82E:          LDA.B !_2                                 ;;E830|E82E+E82E/E82E\E82E;
                      STA.L !DynamicStripeImage,X               ;;E832|E830+E830/E830\E830;
                      INX                                       ;;E836|E834+E834/E834\E834;
                      INX                                       ;;E837|E835+E835/E835\E835;
                      LDY.W #$0B00                              ;;E838|E836+E836/E836\E836;
                      LDA.B !_3                                 ;;E83B|E839+E839/E839\E839;
                      AND.W #$001F                              ;;E83D|E83B+E83B/E83B\E83B;
                      STA.B !_8                                 ;;E840|E83E+E83E/E83E\E83E;
                      LDA.W #$0020                              ;;E842|E840+E840/E840\E840;
                      SEC                                       ;;E845|E843+E843/E843\E843;
                      SBC.B !_8                                 ;;E846|E844+E844/E844\E844;
                      STA.B !_8                                 ;;E848|E846+E846/E846\E846;
                      CMP.W #$0006                              ;;E84A|E848+E848/E848\E848;
                      BCS +                                     ;;E84D|E84B+E84B/E84B\E84B;
                      LDA.B !_8                                 ;;E84F|E84D+E84D/E84D\E84D;
                      ASL A                                     ;;E851|E84F+E84F/E84F\E84F;
                      DEC A                                     ;;E852|E850+E850/E850\E850;
                      XBA                                       ;;E853|E851+E851/E851\E851;
                      TAY                                       ;;E854|E852+E852/E852\E852;
                      LDA.W #$0006                              ;;E855|E853+E853/E853\E853;
                      SEC                                       ;;E858|E856+E856/E856\E856;
                      SBC.B !_8                                 ;;E859|E857+E857/E857\E857;
                      STA.B !_8                                 ;;E85B|E859+E859/E859\E859;
                    + TYA                                       ;;E85D|E85B+E85B/E85B\E85B;
                      STA.L !DynamicStripeImage,X               ;;E85E|E85C+E85C/E85C\E85C;
                      INX                                       ;;E862|E860+E860/E860\E860;
                      INX                                       ;;E863|E861+E861/E861\E861;
                      LDA.W #$0005                              ;;E864|E862+E862/E862\E862;
                      STA.B !_4                                 ;;E867|E865+E865/E865\E865;
                      LDY.B !_0                                 ;;E869|E867+E867/E867\E867;
CODE_04E869:          LDA.B [!_C],Y                             ;;E86B|E869+E869/E869\E869;
                      AND.B !_A                                 ;;E86D|E86B+E86B/E86B\E86B;
                      STA.L !DynamicStripeImage,X               ;;E86F|E86D+E86D/E86D\E86D;
                      INX                                       ;;E873|E871+E871/E871\E871;
                      INX                                       ;;E874|E872+E872/E872\E872;
                      INY                                       ;;E875|E873+E873/E873\E873;
                      INY                                       ;;E876|E874+E874/E874\E874;
                      TYA                                       ;;E877|E875+E875/E875\E875;
                      AND.W #$003F                              ;;E878|E876+E876/E876\E876;
                      BNE +                                     ;;E87B|E879+E879/E879\E879;
                      LDA.B !_4                                 ;;E87D|E87B+E87B/E87B\E87B;
                      BEQ +                                     ;;E87F|E87D+E87D/E87D\E87D;
                      DEY                                       ;;E881|E87F+E87F/E87F\E87F;
                      TYA                                       ;;E882|E880+E880/E880\E880;
                      AND.W #$FFC0                              ;;E883|E881+E881/E881\E881;
                      CLC                                       ;;E886|E884+E884/E884\E884;
                      ADC.W #$0800                              ;;E887|E885+E885/E885\E885;
                      TAY                                       ;;E88A|E888+E888/E888\E888;
                      LDA.B !_2                                 ;;E88B|E889+E889/E889\E889;
                      XBA                                       ;;E88D|E88B+E88B/E88B\E88B;
                      AND.W #$3BE0                              ;;E88E|E88C+E88C/E88C\E88C;
                      CLC                                       ;;E891|E88F+E88F/E88F\E88F;
                      ADC.W #$0400                              ;;E892|E890+E890/E890\E890;
                      XBA                                       ;;E895|E893+E893/E893\E893;
                      STA.L !DynamicStripeImage,X               ;;E896|E894+E894/E894\E894;
                      INX                                       ;;E89A|E898+E898/E898\E898;
                      INX                                       ;;E89B|E899+E899/E899\E899;
                      LDA.B !_8                                 ;;E89C|E89A+E89A/E89A\E89A;
                      ASL A                                     ;;E89E|E89C+E89C/E89C\E89C;
                      DEC A                                     ;;E89F|E89D+E89D/E89D\E89D;
                      XBA                                       ;;E8A0|E89E+E89E/E89E\E89E;
                      STA.L !DynamicStripeImage,X               ;;E8A1|E89F+E89F/E89F\E89F;
                      INX                                       ;;E8A5|E8A3+E8A3/E8A3\E8A3;
                      INX                                       ;;E8A6|E8A4+E8A4/E8A4\E8A4;
                    + DEC.B !_4                                 ;;E8A7|E8A5+E8A5/E8A5\E8A5;
                      BPL CODE_04E869                           ;;E8A9|E8A7+E8A7/E8A7\E8A7;
                      LDA.B !_2                                 ;;E8AB|E8A9+E8A9/E8A9\E8A9;
                      XBA                                       ;;E8AD|E8AB+E8AB/E8AB\E8AB;
                      CLC                                       ;;E8AE|E8AC+E8AC/E8AC\E8AC;
                      ADC.W #$0020                              ;;E8AF|E8AD+E8AD/E8AD\E8AD;
                      XBA                                       ;;E8B2|E8B0+E8B0/E8B0\E8B0;
                      STA.B !_2                                 ;;E8B3|E8B1+E8B1/E8B1\E8B1;
                      LDA.B !_0                                 ;;E8B5|E8B3+E8B3/E8B3\E8B3;
                      TAY                                       ;;E8B7|E8B5+E8B5/E8B5\E8B5;
                      CLC                                       ;;E8B8|E8B6+E8B6/E8B6\E8B6;
                      ADC.W #$0040                              ;;E8B9|E8B7+E8B7/E8B7\E8B7;
                      STA.B !_0                                 ;;E8BC|E8BA+E8BA/E8BA\E8BA;
                      AND.W #$07C0                              ;;E8BE|E8BC+E8BC/E8BC\E8BC;
                      BNE +                                     ;;E8C1|E8BF+E8BF/E8BF\E8BF;
                      TYA                                       ;;E8C3|E8C1+E8C1/E8C1\E8C1;
                      AND.W #$F83F                              ;;E8C4|E8C2+E8C2/E8C2\E8C2;
                      CLC                                       ;;E8C7|E8C5+E8C5/E8C5\E8C5;
                      ADC.W #$1000                              ;;E8C8|E8C6+E8C6/E8C6\E8C6;
                      STA.B !_0                                 ;;E8CB|E8C9+E8C9/E8C9\E8C9;
                      LDA.B !_2                                 ;;E8CD|E8CB+E8CB/E8CB\E8CB;
                      XBA                                       ;;E8CF|E8CD+E8CD/E8CD\E8CD;
                      SEC                                       ;;E8D0|E8CE+E8CE/E8CE\E8CE;
                      SBC.W #$0020                              ;;E8D1|E8CF+E8CF/E8CF\E8CF;
                      AND.W #$341F                              ;;E8D4|E8D2+E8D2/E8D2\E8D2;
                      CLC                                       ;;E8D7|E8D5+E8D5/E8D5\E8D5;
                      ADC.W #$0800                              ;;E8D8|E8D6+E8D6/E8D6\E8D6;
                      XBA                                       ;;E8DB|E8D9+E8D9/E8D9\E8D9;
                      STA.B !_2                                 ;;E8DC|E8DA+E8DA/E8DA\E8DA;
                    + DEC.B !_6                                 ;;E8DE|E8DC+E8DC/E8DC\E8DC;
                      BMI +                                     ;;E8E0|E8DE+E8DE/E8DE\E8DE;
                      JMP CODE_04E82E                           ;;E8E2|E8E0+E8E0/E8E0\E8E0;
                                                                ;;                        ;
                    + RTS                                       ;;E8E5|E8E3+E8E3/E8E3\E8E3; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04E8E4:          db $06,$06,$06,$06,$06,$06,$06,$06        ;;E8E6|E8E4+E8E4/E8E4\E8E4;
                      db $14,$14,$14,$14,$14,$1D,$1D,$1D        ;;E8EE|E8EC+E8EC/E8EC\E8EC;
                      db $1D,$12,$12,$12,$1C,$2F,$2F,$2F        ;;E8F6|E8F4+E8F4/E8F4\E8F4;
                      db $2F,$2F,$34,$34,$34,$47,$4E,$4E        ;;E8FE|E8FC+E8FC/E8FC\E8FC;
                      db $01,$0F,$24,$24,$6C,$0F,$0F,$54        ;;E906|E904+E904/E904\E904;
                      db $55,$57,$58,$5D                        ;;E90E|E90C+E90C/E90C\E90C;
                                                                ;;                        ;
DATA_04E910:          db $00,$00,$00,$00,$00,$00,$01,$01        ;;E912|E910+E910/E910\E910;
                      db $00,$01,$01,$01,$01,$01,$01,$01        ;;E91A|E918+E918/E918\E918;
                      db $00,$01,$01,$00,$00,$01,$01,$01        ;;E922|E920+E920/E920\E920;
                      db $01,$01,$01,$01,$01,$00,$01,$00        ;;E92A|E928+E928/E928\E928;
                      db $00,$01,$01,$01,$01,$01,$00,$00        ;;E932|E930+E930/E930\E930;
                      db $00,$00,$00,$00                        ;;E93A|E938+E938/E938\E938;
                                                                ;;                        ;
DATA_04E93C:          db $15,$02,$35,$02,$45,$02,$55,$02        ;;E93E|E93C+E93C/E93C\E93C;
                      db $65,$02,$75,$02,$14,$11,$94,$10        ;;E946|E944+E944/E944\E944;
                      db $A9,$00,$A4,$05,$24,$05,$28,$07        ;;E94E|E94C+E94C/E94C\E94C;
                      db $A4,$06,$A8,$01,$AC,$01,$B0,$01        ;;E956|E954+E954/E954\E954;
                      db $3C,$00,$00,$29,$80,$28,$10,$05        ;;E95E|E95C+E95C/E95C\E95C;
                      db $54,$01,$30,$18,$B0,$18,$2E,$19        ;;E966|E964+E964/E964\E964;
                      db $2A,$19,$26,$19,$24,$18,$20,$18        ;;E96E|E96C+E96C/E96C\E96C;
                      db $1C,$18,$97,$05,$EC,$2A,$7B,$05        ;;E976|E974+E974/E974\E974;
                      db $12,$02,$94,$31,$A0,$32,$20,$33        ;;E97E|E97C+E97C/E97C\E97C;
                      db $16,$1D,$14,$31,$25,$06,$F0,$01        ;;E986|E984+E984/E984\E984;
                      db $F0,$01,$04,$03,$04,$03,$27,$02        ;;E98E|E98C+E98C/E98C\E98C;
DATA_04E994:          db $68,$00,$24,$00,$24,$00,$25,$00        ;;E996|E994+E994/E994\E994;
                      db $00,$00,$81,$00,$38,$09,$28,$09        ;;E99E|E99C+E99C/E99C\E99C;
                      db $66,$00,$9C,$09,$28,$09,$F8,$09        ;;E9A6|E9A4+E9A4/E9A4\E9A4;
                      db $FC,$09,$98,$09,$98,$09,$28,$09        ;;E9AE|E9AC+E9AC/E9AC\E9AC;
                      db $66,$00,$38,$09,$28,$09,$66,$00        ;;E9B6|E9B4+E9B4/E9B4\E9B4;
                      db $68,$00,$80,$0A,$84,$0A,$88,$0A        ;;E9BE|E9BC+E9BC/E9BC\E9BC;
                      db $98,$09,$98,$09,$94,$09,$98,$09        ;;E9C6|E9C4+E9C4/E9C4\E9C4;
                      db $8C,$0A,$66,$00,$84,$03,$66,$00        ;;E9CE|E9CC+E9CC/E9CC\E9CC;
                      db $79,$00,$A8,$0A,$38,$09,$38,$09        ;;E9D6|E9D4+E9D4/E9D4\E9D4;
                      db $A0,$09,$30,$0A,$69,$00,$5F,$00        ;;E9DE|E9DC+E9DC/E9DC\E9DC;
                      db $5F,$00,$5F,$00,$5F,$00,$5F,$00        ;;E9E6|E9E4+E9E4/E9E4\E9E4;
                                                                ;;                        ;
CODE_04E9EC:          LDA.W !OverworldEvent                     ;;E9EE|E9EC+E9EC/E9EC\E9EC; Index (8 bit) Accum (8 bit) 
                      STA.B !_F                                 ;;E9F1|E9EF+E9EF/E9EF\E9EF;
CODE_04E9F1:          LDX.B #$2B                                ;;E9F3|E9F1+E9F1/E9F1\E9F1;
CODE_04E9F3:          CMP.L DATA_04E8E4,X                       ;;E9F5|E9F3+E9F3/E9F3\E9F3;
                      BEQ CODE_04EA25                           ;;E9F9|E9F7+E9F7/E9F7\E9F7;
CODE_04E9F9:          DEX                                       ;;E9FB|E9F9+E9F9/E9F9\E9F9;
                      BPL CODE_04E9F3                           ;;E9FC|E9FA+E9FA/E9FA\E9FA;
                      LDA.W !OverworldEventProcess              ;;E9FE|E9FC+E9FC/E9FC\E9FC;
                      BEQ +                                     ;;EA01|E9FF+E9FF/E9FF\E9FF;
                      STZ.W !OverworldEventProcess              ;;EA03|EA01+EA01/EA01\EA01;
                      INC.W !OverworldProcess                   ;;EA06|EA04+EA04/EA04\EA04;
                      LDA.W !OverworldEvent                     ;;EA09|EA07+EA07/EA07\EA07;
                      AND.B #$07                                ;;EA0C|EA0A+EA0A/EA0A\EA0A;
                      TAX                                       ;;EA0E|EA0C+EA0C/EA0C\EA0C;
                      LDA.W !OverworldEvent                     ;;EA0F|EA0D+EA0D/EA0D\EA0D;
                      LSR A                                     ;;EA12|EA10+EA10/EA10\EA10;
                      LSR A                                     ;;EA13|EA11+EA11/EA11\EA11;
                      LSR A                                     ;;EA14|EA12+EA12/EA12\EA12;
                      TAY                                       ;;EA15|EA13+EA13/EA13\EA13;
                      LDA.W !OWEventsActivated,Y                ;;EA16|EA14+EA14/EA14\EA14;
                      ORA.L DATA_04E44B,X                       ;;EA19|EA17+EA17/EA17\EA17;
                      STA.W !OWEventsActivated,Y                ;;EA1D|EA1B+EA1B/EA1B\EA1B;
                      INC.W !ExitsCompleted                     ;;EA20|EA1E+EA1E/EA1E\EA1E;
                      STZ.W !CreditsScreenNumber                ;;EA23|EA21+EA21/EA21\EA21;
                    + RTS                                       ;;EA26|EA24+EA24/EA24\EA24; Return 
                                                                ;;                        ;
CODE_04EA25:          PHX                                       ;;EA27|EA25+EA25/EA25\EA25;
                      LDA.L DATA_04E910,X                       ;;EA28|EA26+EA26/EA26\EA26;
                      STA.B !_2                                 ;;EA2C|EA2A+EA2A/EA2A\EA2A;
                      TXA                                       ;;EA2E|EA2C+EA2C/EA2C\EA2C;
                      ASL A                                     ;;EA2F|EA2D+EA2D/EA2D\EA2D;
                      TAX                                       ;;EA30|EA2E+EA2E/EA2E\EA2E;
                      REP #$20                                  ;;EA31|EA2F+EA2F/EA2F\EA2F; Accum (16 bit) 
                      LDA.L DATA_04E994,X                       ;;EA33|EA31+EA31/EA31\EA31;
                      STA.B !_0                                 ;;EA37|EA35+EA35/EA35\EA35;
                      LDA.L DATA_04E93C,X                       ;;EA39|EA37+EA37/EA37\EA37;
                      STA.B !_4                                 ;;EA3D|EA3B+EA3B/EA3B\EA3B;
                      LDA.B !_2                                 ;;EA3F|EA3D+EA3D/EA3D\EA3D;
                      AND.W #$0001                              ;;EA41|EA3F+EA3F/EA3F\EA3F;
                      BEQ +                                     ;;EA44|EA42+EA42/EA42\EA42;
                      REP #$10                                  ;;EA46|EA44+EA44/EA44\EA44; Index (16 bit) 
                      LDY.B !_0                                 ;;EA48|EA46+EA46/EA46\EA46;
                      JSR CODE_04E4A9                           ;;EA4A|EA48+EA48/EA48\EA48;
                      JMP CODE_04EA5A                           ;;EA4D|EA4B+EA4B/EA4B\EA4B;
                                                                ;;                        ;
                    + SEP #$20                                  ;;EA50|EA4E+EA4E/EA4E\EA4E; Accum (8 bit) 
                      REP #$10                                  ;;EA52|EA50+EA50/EA50\EA50; Index (16 bit) 
                      LDX.B !_4                                 ;;EA54|EA52+EA52/EA52\EA52;
                      LDA.B !_0                                 ;;EA56|EA54+EA54/EA54\EA54;
                      STA.L !Map16TilesLow,X                    ;;EA58|EA56+EA56/EA56\EA56;
CODE_04EA5A:          SEP #$30                                  ;;EA5C|EA5A+EA5A/EA5A\EA5A; Index (8 bit) Accum (8 bit) 
                      PLX                                       ;;EA5E|EA5C+EA5C/EA5C\EA5C;
                      LDA.B !_F                                 ;;EA5F|EA5D+EA5D/EA5D\EA5D;
                      JMP CODE_04E9F9                           ;;EA61|EA5F+EA5F/EA5F\EA5F;
                                                                ;;                        ;
CODE_04EA62:          STZ.W !ColorFadeTimer                     ;;EA64|EA62+EA62/EA62\EA62;
                      STZ.W !ColorFadeDir                       ;;EA67|EA65+EA65/EA65\EA65;
                      LDX.B #$6F                                ;;EA6A|EA68+EA68/EA68\EA68;
                    - LDA.W !MainPalette,X                      ;;EA6C|EA6A+EA6A/EA6A\EA6A;
                      STA.W !CopyPalette+2,X                    ;;EA6F|EA6D+EA6D/EA6D\EA6D;
                      STZ.W !CopyPalette+$74,X                  ;;EA72|EA70+EA70/EA70\EA70;
                      DEX                                       ;;EA75|EA73+EA73/EA73\EA73;
                      BPL -                                     ;;EA76|EA74+EA74/EA74\EA74;
                      LDX.B #$6F                                ;;EA78|EA76+EA76/EA76\EA76;
CODE_04EA78:          LDY.B #$10                                ;;EA7A|EA78+EA78/EA78\EA78;
                    - LDA.W !MainPalette+$80,X                  ;;EA7C|EA7A+EA7A/EA7A\EA7A;
                      STA.W !CopyPalette+2,X                    ;;EA7F|EA7D+EA7D/EA7D\EA7D;
                      DEX                                       ;;EA82|EA80+EA80/EA80\EA80;
                      DEY                                       ;;EA83|EA81+EA81/EA81\EA81;
                      BNE -                                     ;;EA84|EA82+EA82/EA82\EA82;
                      TXA                                       ;;EA86|EA84+EA84/EA84\EA84;
                      SEC                                       ;;EA87|EA85+EA85/EA85\EA85;
                      SBC.B #$10                                ;;EA88|EA86+EA86/EA86\EA86;
                      TAX                                       ;;EA8A|EA88+EA88/EA88\EA88;
                      BPL CODE_04EA78                           ;;EA8B|EA89+EA89/EA89\EA89;
CODE_04EA8B:          REP #$20                                  ;;EA8D|EA8B+EA8B/EA8B\EA8B; Accum (16 bit) 
                      LDA.W #$0070                              ;;EA8F|EA8D+EA8D/EA8D\EA8D;
                      STA.W !CopyPalette                        ;;EA92|EA90+EA90/EA90\EA90;
                      LDA.W #$C070                              ;;EA95|EA93+EA93/EA93\EA93;
                      STA.W !CopyPalette+$72                    ;;EA98|EA96+EA96/EA96\EA96;
                      SEP #$20                                  ;;EA9B|EA99+EA99/EA99\EA99; Accum (8 bit) 
                      STZ.W !CopyPalette+$E4                    ;;EA9D|EA9B+EA9B/EA9B\EA9B;
                      LDA.B #$03                                ;;EAA0|EA9E+EA9E/EA9E\EA9E;
                      STA.W !PaletteIndexTable                  ;;EAA2|EAA0+EAA0/EAA0\EAA0;
                      RTS                                       ;;EAA5|EAA3+EAA3/EAA3\EAA3; Return 
                                                                ;;                        ;
CODE_04EAA4:          LDA.W !ColorFadeTimer                     ;;EAA6|EAA4+EAA4/EAA4\EAA4;
                      CMP.B #$40                                ;;EAA9|EAA7+EAA7/EAA7\EAA7;
                      BCC CODE_04EAC9                           ;;EAAB|EAA9+EAA9/EAA9\EAA9;
                      INC.W !OverworldEventProcess              ;;EAAD|EAAB+EAAB/EAAB\EAAB;
                      JSR CODE_04EE30                           ;;EAB0|EAAE+EAAE/EAAE\EAAE;
                      JSR CODE_04E496                           ;;EAB3|EAB1+EAB1/EAB1\EAB1;
                      REP #$20                                  ;;EAB6|EAB4+EAB4/EAB4\EAB4; Accum (16 bit) 
                      INC.W !EventTileIndex                     ;;EAB8|EAB6+EAB6/EAB6\EAB6;
                      LDA.W !EventTileIndex                     ;;EABB|EAB9+EAB9/EAB9\EAB9;
                      CMP.W !EventLength                        ;;EABE|EABC+EABC/EABC\EABC;
                      SEP #$20                                  ;;EAC1|EABF+EABF/EABF\EABF; Accum (8 bit) 
                      BCS +                                     ;;EAC3|EAC1+EAC1/EAC1\EAC1;
                      LDA.B #$03                                ;;EAC5|EAC3+EAC3/EAC3\EAC3;
                      STA.W !OverworldEventProcess              ;;EAC7|EAC5+EAC5/EAC5\EAC5;
                    + RTS                                       ;;EACA|EAC8+EAC8/EAC8\EAC8; Return 
                                                                ;;                        ;
CODE_04EAC9:          JSR CODE_04EC67                           ;;EACB|EAC9+EAC9/EAC9\EAC9;
                      REP #$30                                  ;;EACE|EACC+EACC/EACC\EACC; Index (16 bit) Accum (16 bit) 
                      LDY.W #$008C                              ;;EAD0|EACE+EACE/EACE\EACE;
                      LDX.W #$0006                              ;;EAD3|EAD1+EAD1/EAD1\EAD1;
                      LDA.W !OverworldEventSize                 ;;EAD6|EAD4+EAD4/EAD4\EAD4;
                      CMP.W #$0900                              ;;EAD9|EAD7+EAD7/EAD7\EAD7;
                      BCC +                                     ;;EADC|EADA+EADA/EADA\EADA;
                      LDY.W #$000C                              ;;EADE|EADC+EADC/EADC\EADC;
                      LDX.W #$0002                              ;;EAE1|EADF+EADF/EADF\EADF;
                    + STX.B !_5                                 ;;EAE4|EAE2+EAE2/EAE2\EAE2;
                      TAX                                       ;;EAE6|EAE4+EAE4/EAE4\EAE4;
                      SEP #$20                                  ;;EAE7|EAE5+EAE5/EAE5\EAE5; Accum (8 bit) 
CODE_04EAE7:          LDA.B !_5                                 ;;EAE9|EAE7+EAE7/EAE7\EAE7;
                      STA.B !_3                                 ;;EAEB|EAE9+EAE9/EAE9\EAE9;
                      LDA.B !_0                                 ;;EAED|EAEB+EAEB/EAEB\EAEB;
                    - STA.B !_2                                 ;;EAEF|EAED+EAED/EAED\EAED;
                      LDA.B !_1                                 ;;EAF1|EAEF+EAEF/EAEF\EAEF;
                      STA.W !OAMTileYPos+$150,Y                 ;;EAF3|EAF1+EAF1/EAF1\EAF1;
                      LDA.L OWEventTileNum,X                    ;;EAF6|EAF4+EAF4/EAF4\EAF4;
                      STA.W !OAMTileNo+$150,Y                   ;;EAFA|EAF8+EAF8/EAF8\EAF8;
                      LDA.L !OWEventTilemap,X                   ;;EAFD|EAFB+EAFB/EAFB\EAFB;
                      AND.B #$C0                                ;;EB01|EAFF+EAFF/EAFF\EAFF;
                      STA.B !_4                                 ;;EB03|EB01+EB01/EB01\EB01;
                      LDA.L !OWEventTilemap,X                   ;;EB05|EB03+EB03/EB03\EB03;
                      AND.B #$1C                                ;;EB09|EB07+EB07/EB07\EB07;
                      LSR A                                     ;;EB0B|EB09+EB09/EB09\EB09;
                      ORA.B !_4                                 ;;EB0C|EB0A+EB0A/EB0A\EB0A;
                      ORA.B #$11                                ;;EB0E|EB0C+EB0C/EB0C\EB0C;
                      STA.W !OAMTileAttr+$150,Y                 ;;EB10|EB0E+EB0E/EB0E\EB0E;
                      LDA.B !_2                                 ;;EB13|EB11+EB11/EB11\EB11;
                      STA.W !OAMTileXPos+$150,Y                 ;;EB15|EB13+EB13/EB13\EB13;
                      CLC                                       ;;EB18|EB16+EB16/EB16\EB16;
                      ADC.B #$08                                ;;EB19|EB17+EB17/EB17\EB17;
                      INX                                       ;;EB1B|EB19+EB19/EB19\EB19;
                      DEY                                       ;;EB1C|EB1A+EB1A/EB1A\EB1A;
                      DEY                                       ;;EB1D|EB1B+EB1B/EB1B\EB1B;
                      DEY                                       ;;EB1E|EB1C+EB1C/EB1C\EB1C;
                      DEY                                       ;;EB1F|EB1D+EB1D/EB1D\EB1D;
                      DEC.B !_3                                 ;;EB20|EB1E+EB1E/EB1E\EB1E;
                      BNE -                                     ;;EB22|EB20+EB20/EB20\EB20;
                      LDA.B !_1                                 ;;EB24|EB22+EB22/EB22\EB22;
                      CLC                                       ;;EB26|EB24+EB24/EB24\EB24;
                      ADC.B #$08                                ;;EB27|EB25+EB25/EB25\EB25;
                      STA.B !_1                                 ;;EB29|EB27+EB27/EB27\EB27;
                      CPY.W #$FFFC                              ;;EB2B|EB29+EB29/EB29\EB29;
                      BNE CODE_04EAE7                           ;;EB2E|EB2C+EB2C/EB2C\EB2C;
                      SEP #$10                                  ;;EB30|EB2E+EB2E/EB2E\EB2E; Index (8 bit) 
                      LDX.B #$23                                ;;EB32|EB30+EB30/EB30\EB30;
                    - STZ.W !OAMTileSize+$54,X                  ;;EB34|EB32+EB32/EB32\EB32;
                      DEX                                       ;;EB37|EB35+EB35/EB35\EB35;
                      BPL -                                     ;;EB38|EB36+EB36/EB36\EB36;
                      LDY.B #$08                                ;;EB3A|EB38+EB38/EB38\EB38;
                      LDX.W !PlayerTurnLvl                      ;;EB3C|EB3A+EB3A/EB3A\EB3A;
                      LDA.W !OWPlayerSubmap,X                   ;;EB3F|EB3D+EB3D/EB3D\EB3D;
                      CMP.B #$03                                ;;EB42|EB40+EB40/EB40\EB40;
                      BNE +                                     ;;EB44|EB42+EB42/EB42\EB42;
                      LDY.B #$01                                ;;EB46|EB44+EB44/EB44\EB44;
                    + STY.B !GraphicsCompPtr                    ;;EB48|EB46+EB46/EB46\EB46;
                    - LDA.W !ColorFadeTimer                     ;;EB4A|EB48+EB48/EB48\EB48;
                      JSL CODE_00B006                           ;;EB4D|EB4B+EB4B/EB4B\EB4B;
                      DEC.B !GraphicsCompPtr                    ;;EB51|EB4F+EB4F/EB4F\EB4F;
                      BNE -                                     ;;EB53|EB51+EB51/EB51\EB51;
                      JMP CODE_04EA8B                           ;;EB55|EB53+EB53/EB53\EB53;
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04EB56:          db $F5,$11,$F2,$15,$F5,$11,$F3,$14        ;;EB58|EB56+EB56/EB56\EB56;
                      db $F5,$11,$F3,$14,$F6,$10,$F4,$13        ;;EB60|EB5E+EB5E/EB5E\EB5E;
                      db $F7,$0F,$F5,$12,$F8,$0E,$F7,$11        ;;EB68|EB66+EB66/EB66\EB66;
                      db $FA,$0D,$F9,$10,$FC,$0C,$FB,$0D        ;;EB70|EB6E+EB6E/EB6E\EB6E;
                      db $FF,$0A,$FE,$0B,$01,$07,$01,$07        ;;EB78|EB76+EB76/EB76\EB76;
                      db $00,$08,$00,$08                        ;;EB80|EB7E+EB7E/EB7E\EB7E;
                                                                ;;                        ;
DATA_04EB82:          db $F8,$F8,$11,$12,$F8,$F8,$10,$11        ;;EB84|EB82+EB82/EB82\EB82;
                      db $F8,$F8,$10,$11,$F9,$F9,$0F,$10        ;;EB8C|EB8A+EB8A/EB8A\EB8A;
                      db $FA,$FA,$0E,$0F,$FB,$FB,$0C,$0D        ;;EB94|EB92+EB92/EB92\EB92;
                      db $FC,$FC,$0B,$0B,$FE,$FE,$0A,$0A        ;;EB9C|EB9A+EB9A/EB9A\EB9A;
                      db $00,$00,$08,$08,$01,$01,$07,$07        ;;EBA4|EBA2+EBA2/EBA2\EBA2;
                      db $00,$00,$08,$08                        ;;EBAC|EBAA+EBAA/EBAA\EBAA;
                                                                ;;                        ;
DATA_04EBAE:          db $F6,$B6,$76,$36,$F6,$B6,$76,$36        ;;EBB0|EBAE+EBAE/EBAE\EBAE;
                      db $36,$76,$B6,$F6,$36,$76,$B6,$F6        ;;EBB8|EBB6+EBB6/EBB6\EBB6;
                      db $36,$36,$36,$36,$36,$36,$36,$36        ;;EBC0|EBBE+EBBE/EBBE\EBBE;
                      db $36,$36,$36,$36,$36,$36,$36,$36        ;;EBC8|EBC6+EBC6/EBC6\EBC6;
                      db $36,$36,$36,$36,$36,$36,$36,$36        ;;EBD0|EBCE+EBCE/EBCE\EBCE;
                      db $30,$70,$B0,$F0                        ;;EBD8|EBD6+EBD6/EBD6\EBD6;
                                                                ;;                        ;
DATA_04EBDA:          db $22,$23,$32,$33,$32,$23,$22            ;;EBDC|EBDA+EBDA/EBDA\EBDA;
                                                                ;;                        ;
DATA_04EBE1:          db $73,$73,$72,$72,$5F,$5F,$28,$28        ;;EBE3|EBE1+EBE1/EBE1\EBE1;
                      db $28,$28                                ;;EBEB|EBE9+EBE9/EBE9\EBE9;
                                                                ;;                        ;
CODE_04EBEB:          DEC.W !OverworldEventSize                 ;;EBED|EBEB+EBEB/EBEB\EBEB;
                      BPL +                                     ;;EBF0|EBEE+EBEE/EBEE\EBEE;
                      INC.W !OverworldEventProcess              ;;EBF2|EBF0+EBF0/EBF0\EBF0;
                      RTS                                       ;;EBF5|EBF3+EBF3/EBF3\EBF3; Return 
                                                                ;;                        ;
                    + LDA.W !OverworldEventSize                 ;;EBF6|EBF4+EBF4/EBF4\EBF4;
                      LDY.W !OverworldEventProcess              ;;EBF9|EBF7+EBF7/EBF7\EBF7;
                      CPY.B #$01                                ;;EBFC|EBFA+EBFA/EBFA\EBFA;
                      BEQ CODE_04EC17                           ;;EBFE|EBFC+EBFC/EBFC\EBFC;
                      CMP.B #$10                                ;;EC00|EBFE+EBFE/EBFE\EBFE;
                      BNE +                                     ;;EC02|EC00+EC00/EC00\EC00;
                      PHA                                       ;;EC04|EC02+EC02/EC02\EC02;
                      JSR CODE_04ED83                           ;;EC05|EC03+EC03/EC03\EC03;
                      PLA                                       ;;EC08|EC06+EC06/EC06\EC06;
                    + LSR A                                     ;;EC09|EC07+EC07/EC07\EC07;
                      LSR A                                     ;;EC0A|EC08+EC08/EC08\EC08;
                      TAX                                       ;;EC0B|EC09+EC09/EC09\EC09;
                      LDA.W DATA_04EBDA,X                       ;;EC0C|EC0A+EC0A/EC0A\EC0A;
                      STA.B !_2                                 ;;EC0F|EC0D+EC0D/EC0D\EC0D;
                      JSR CODE_04EC67                           ;;EC11|EC0F+EC0F/EC0F\EC0F;
                      LDX.B #$28                                ;;EC14|EC12+EC12/EC12\EC12;
                      JMP CODE_04EC2E                           ;;EC16|EC14+EC14/EC14\EC14;
                                                                ;;                        ;
CODE_04EC17:          CMP.B #$18                                ;;EC19|EC17+EC17/EC17\EC17;
                      BNE +                                     ;;EC1B|EC19+EC19/EC19\EC19;
                      PHA                                       ;;EC1D|EC1B+EC1B/EC1B\EC1B;
                      JSR CODE_04EEAA                           ;;EC1E|EC1C+EC1C/EC1C\EC1C;
                      PLA                                       ;;EC21|EC1F+EC1F/EC1F\EC1F;
                    + AND.B #$FC                                ;;EC22|EC20+EC20/EC20\EC20;
                      TAX                                       ;;EC24|EC22+EC22/EC22\EC22;
                      LSR A                                     ;;EC25|EC23+EC23/EC23\EC23;
                      LSR A                                     ;;EC26|EC24+EC24/EC24\EC24;
                      TAY                                       ;;EC27|EC25+EC25/EC25\EC25;
                      LDA.W DATA_04EBE1,Y                       ;;EC28|EC26+EC26/EC26\EC26;
                      STA.B !_2                                 ;;EC2B|EC29+EC29/EC29\EC29;
                      JSR CODE_04EC67                           ;;EC2D|EC2B+EC2B/EC2B\EC2B;
CODE_04EC2E:          LDA.B #$03                                ;;EC30|EC2E+EC2E/EC2E\EC2E;
                      STA.B !_3                                 ;;EC32|EC30+EC30/EC30\EC30;
                      LDY.B #$00                                ;;EC34|EC32+EC32/EC32\EC32;
                    - LDA.B !_0                                 ;;EC36|EC34+EC34/EC34\EC34;
                      CLC                                       ;;EC38|EC36+EC36/EC36\EC36;
                      ADC.W DATA_04EB56,X                       ;;EC39|EC37+EC37/EC37\EC37;
                      STA.W !OAMTileXPos+$80,Y                  ;;EC3C|EC3A+EC3A/EC3A\EC3A;
                      LDA.B !_1                                 ;;EC3F|EC3D+EC3D/EC3D\EC3D;
                      CLC                                       ;;EC41|EC3F+EC3F/EC3F\EC3F;
                      ADC.W DATA_04EB82,X                       ;;EC42|EC40+EC40/EC40\EC40;
                      STA.W !OAMTileYPos+$80,Y                  ;;EC45|EC43+EC43/EC43\EC43;
                      LDA.B !_2                                 ;;EC48|EC46+EC46/EC46\EC46;
                      STA.W !OAMTileNo+$80,Y                    ;;EC4A|EC48+EC48/EC48\EC48;
                      LDA.W DATA_04EBAE,X                       ;;EC4D|EC4B+EC4B/EC4B\EC4B;
                      STA.W !OAMTileAttr+$80,Y                  ;;EC50|EC4E+EC4E/EC4E\EC4E;
                      INY                                       ;;EC53|EC51+EC51/EC51\EC51;
                      INY                                       ;;EC54|EC52+EC52/EC52\EC52;
                      INY                                       ;;EC55|EC53+EC53/EC53\EC53;
                      INY                                       ;;EC56|EC54+EC54/EC54\EC54;
                      INX                                       ;;EC57|EC55+EC55/EC55\EC55;
                      DEC.B !_3                                 ;;EC58|EC56+EC56/EC56\EC56;
                      BPL -                                     ;;EC5A|EC58+EC58/EC58\EC58;
                      STZ.W !OAMTileSize+$20                    ;;EC5C|EC5A+EC5A/EC5A\EC5A;
                      STZ.W !OAMTileSize+$21                    ;;EC5F|EC5D+EC5D/EC5D\EC5D;
                      STZ.W !OAMTileSize+$22                    ;;EC62|EC60+EC60/EC60\EC60;
                      STZ.W !OAMTileSize+$23                    ;;EC65|EC63+EC63/EC63\EC63;
                      RTS                                       ;;EC68|EC66+EC66/EC66\EC66; Return 
                                                                ;;                        ;
CODE_04EC67:          LDA.W !OverworldEventXPos                 ;;EC69|EC67+EC67/EC67\EC67;
                      SEC                                       ;;EC6C|EC6A+EC6A/EC6A\EC6A;
                      SBC.B !Layer2XPos                         ;;EC6D|EC6B+EC6B/EC6B\EC6B;
                      STA.B !_0                                 ;;EC6F|EC6D+EC6D/EC6D\EC6D;
                      LDA.W !OverworldEventYPos                 ;;EC71|EC6F+EC6F/EC6F\EC6F;
                      CLC                                       ;;EC74|EC72+EC72/EC72\EC72;
                      SBC.B !Layer2YPos                         ;;EC75|EC73+EC73/EC73\EC73;
                      STA.B !_1                                 ;;EC77|EC75+EC75/EC75\EC75;
                      RTS                                       ;;EC79|EC77+EC77/EC77\EC77; Return 
                                                                ;;                        ;
CODE_04EC78:          LDA.B #$7E                                ;;EC7A|EC78+EC78/EC78\EC78;
                      STA.B !_F                                 ;;EC7C|EC7A+EC7A/EC7A\EC7A;
                      REP #$30                                  ;;EC7E|EC7C+EC7C/EC7C\EC7C; Index (16 bit) Accum (16 bit) 
                      LDA.W #$C800                              ;;EC80|EC7E+EC7E/EC7E\EC7E;
                      STA.B !_D                                 ;;EC83|EC81+EC81/EC81\EC81;
                      LDA.W !OverworldEvent                     ;;EC85|EC83+EC83/EC83\EC83;
                      AND.W #$00FF                              ;;EC88|EC86+EC86/EC86\EC86;
                      ASL A                                     ;;EC8B|EC89+EC89/EC89\EC89;
                      TAX                                       ;;EC8C|EC8A+EC8A/EC8A\EC8A;
                      LDA.L DATA_04D85D,X                       ;;EC8D|EC8B+EC8B/EC8B\EC8B;
                      TAY                                       ;;EC91|EC8F+EC8F/EC8F\EC8F;
                      LDX.W #$0015                              ;;EC92|EC90+EC90/EC90\EC90;
                      SEP #$20                                  ;;EC95|EC93+EC93/EC93\EC93; Accum (8 bit) 
                      LDA.B [!_D],Y                             ;;EC97|EC95+EC95/EC95\EC95;
CODE_04EC97:          CMP.L DATA_04DA1D,X                       ;;EC99|EC97+EC97/EC97\EC97;
                      BEQ CODE_04ECA8                           ;;EC9D|EC9B+EC9B/EC9B\EC9B;
                      DEX                                       ;;EC9F|EC9D+EC9D/EC9D\EC9D;
                      BPL CODE_04EC97                           ;;ECA0|EC9E+EC9E/EC9E\EC9E;
                      SEP #$10                                  ;;ECA2|ECA0+ECA0/ECA0\ECA0; Index (8 bit) 
                      LDA.B #$07                                ;;ECA4|ECA2+ECA2/ECA2\ECA2;
                      STA.W !OverworldEventProcess              ;;ECA6|ECA4+ECA4/ECA4\ECA4;
                      RTS                                       ;;ECA9|ECA7+ECA7/ECA7\ECA7; Return 
                                                                ;;                        ;
CODE_04ECA8:          SEP #$30                                  ;;ECAA|ECA8+ECA8/ECA8\ECA8; Index (8 bit) Accum (8 bit) 
                      LDA.B #!SFX_COIN                          ;;ECAC|ECAA+ECAA/ECAA\ECAA;
                      STA.W !SPCIO3                             ;;ECAE|ECAC+ECAC/ECAC\ECAC; / Play sound effect 
                      INC.W !OverworldEventProcess              ;;ECB1|ECAF+ECAF/ECAF\ECAF;
                      LDA.W !OverworldEvent                     ;;ECB4|ECB2+ECB2/ECB2\ECB2;
                      AND.B #$FF                                ;;ECB7|ECB5+ECB5/ECB5\ECB5;
                      ASL A                                     ;;ECB9|ECB7+ECB7/ECB7\ECB7;
                      TAX                                       ;;ECBA|ECB8+ECB8/ECB8\ECB8;
                      LDA.L DATA_04D85D,X                       ;;ECBB|ECB9+ECB9/ECB9\ECB9;
                      ASL A                                     ;;ECBF|ECBD+ECBD/ECBD\ECBD;
                      ASL A                                     ;;ECC0|ECBE+ECBE/ECBE\ECBE;
                      ASL A                                     ;;ECC1|ECBF+ECBF/ECBF\ECBF;
                      ASL A                                     ;;ECC2|ECC0+ECC0/ECC0\ECC0;
                      STA.W !OverworldEventXPos                 ;;ECC3|ECC1+ECC1/ECC1\ECC1;
                      LDA.L DATA_04D85D,X                       ;;ECC6|ECC4+ECC4/ECC4\ECC4;
                      AND.B #$F0                                ;;ECCA|ECC8+ECC8/ECC8\ECC8;
                      STA.W !OverworldEventYPos                 ;;ECCC|ECCA+ECCA/ECCA\ECCA;
                      LDA.B #$1C                                ;;ECCF|ECCD+ECCD/ECCD\ECCD;
                      STA.W !OverworldEventSize                 ;;ECD1|ECCF+ECCF/ECCF\ECCF;
                      RTS                                       ;;ECD4|ECD2+ECD2/ECD2\ECD2; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04ECD3:          db $86,$99,$86,$19,$86,$D9,$86,$59        ;;ECD5|ECD3+ECD3/ECD3\ECD3;
                      db $96,$99,$96,$19,$96,$D9,$96,$59        ;;ECDD|ECDB+ECDB/ECDB\ECDB;
                      db $86,$9D,$86,$1D,$86,$DD,$86,$5D        ;;ECE5|ECE3+ECE3/ECE3\ECE3;
                      db $96,$9D,$96,$1D,$96,$DD,$96,$5D        ;;ECED|ECEB+ECEB/ECEB\ECEB;
                      db $86,$99,$86,$19,$86,$D9,$86,$59        ;;ECF5|ECF3+ECF3/ECF3\ECF3;
                      db $96,$99,$96,$19,$96,$D9,$96,$59        ;;ECFD|ECFB+ECFB/ECFB\ECFB;
                      db $86,$9D,$86,$1D,$86,$DD,$86,$5D        ;;ED05|ED03+ED03/ED03\ED03;
                      db $96,$9D,$96,$1D,$96,$DD,$96,$5D        ;;ED0D|ED0B+ED0B/ED0B\ED0B;
                      db $88,$15,$98,$15,$89,$15,$99,$15        ;;ED15|ED13+ED13/ED13\ED13;
                      db $A4,$11,$B4,$11,$A5,$11,$B5,$11        ;;ED1D|ED1B+ED1B/ED1B\ED1B;
                      db $22,$11,$90,$11,$22,$11,$91,$11        ;;ED25|ED23+ED23/ED23\ED23;
                      db $C2,$11,$D2,$11,$C3,$11,$D3,$11        ;;ED2D|ED2B+ED2B/ED2B\ED2B;
                      db $A6,$11,$B6,$11,$A7,$11,$B7,$11        ;;ED35|ED33+ED33/ED33\ED33;
                      db $82,$19,$92,$19,$83,$19,$93,$19        ;;ED3D|ED3B+ED3B/ED3B\ED3B;
                      db $C8,$19,$F8,$19,$C9,$19,$F9,$19        ;;ED45|ED43+ED43/ED43\ED43;
                      db $80,$1C,$90,$1C,$81,$1C,$90,$5C        ;;ED4D|ED4B+ED4B/ED4B\ED4B;
                      db $80,$14,$90,$14,$81,$14,$90,$54        ;;ED55|ED53+ED53/ED53\ED53;
                      db $A2,$11,$B2,$11,$A3,$11,$B3,$11        ;;ED5D|ED5B+ED5B/ED5B\ED5B;
                      db $82,$1D,$92,$1D,$83,$1D,$93,$1D        ;;ED65|ED63+ED63/ED63\ED63;
                      db $86,$99,$86,$19,$86,$D9,$86,$59        ;;ED6D|ED6B+ED6B/ED6B\ED6B;
                      db $86,$99,$86,$19,$86,$D9,$86,$59        ;;ED75|ED73+ED73/ED73\ED73;
                      db $A8,$11,$B8,$11,$A9,$11,$B9,$11        ;;ED7D|ED7B+ED7B/ED7B\ED7B;
                                                                ;;                        ;
CODE_04ED83:          LDA.B #!Map16TilesLow>>16                 ;;ED85|ED83+ED83/ED83\ED83;
                      STA.B !_F                                 ;;ED87|ED85+ED85/ED85\ED85;
                      REP #$30                                  ;;ED89|ED87+ED87/ED87\ED87; Index (16 bit) Accum (16 bit) 
                      LDA.W #!Map16TilesLow                     ;;ED8B|ED89+ED89/ED89\ED89;
                      STA.B !_D                                 ;;ED8E|ED8C+ED8C/ED8C\ED8C;
                      LDA.W !OverworldEvent                     ;;ED90|ED8E+ED8E/ED8E\ED8E;
                      AND.W #$00FF                              ;;ED93|ED91+ED91/ED91\ED91;
                      ASL A                                     ;;ED96|ED94+ED94/ED94\ED94;
                      TAX                                       ;;ED97|ED95+ED95/ED95\ED95;
                      LDA.L DATA_04D85D,X                       ;;ED98|ED96+ED96/ED96\ED96;
                      TAY                                       ;;ED9C|ED9A+ED9A/ED9A\ED9A;
                      LDX.W #$0015                              ;;ED9D|ED9B+ED9B/ED9B\ED9B;
                      SEP #$20                                  ;;EDA0|ED9E+ED9E/ED9E\ED9E; Accum (8 bit) 
                      LDA.B [!_D],Y                             ;;EDA2|EDA0+EDA0/EDA0\EDA0;
CODE_04EDA2:          CMP.L DATA_04DA1D,X                       ;;EDA4|EDA2+EDA2/EDA2\EDA2;
                      BEQ CODE_04EDAB                           ;;EDA8|EDA6+EDA6/EDA6\EDA6;
                      DEX                                       ;;EDAA|EDA8+EDA8/EDA8\EDA8;
                      BNE CODE_04EDA2                           ;;EDAB|EDA9+EDA9/EDA9\EDA9;
CODE_04EDAB:          REP #$30                                  ;;EDAD|EDAB+EDAB/EDAB\EDAB; Index (16 bit) Accum (16 bit) 
                      STX.B !_E                                 ;;EDAF|EDAD+EDAD/EDAD\EDAD;
                      LDA.W !OverworldEvent                     ;;EDB1|EDAF+EDAF/EDAF\EDAF;
                      AND.W #$00FF                              ;;EDB4|EDB2+EDB2/EDB2\EDB2;
                      ASL A                                     ;;EDB7|EDB5+EDB5/EDB5\EDB5;
                      TAX                                       ;;EDB8|EDB6+EDB6/EDB6\EDB6;
                      LDA.L DATA_04D93D,X                       ;;EDB9|EDB7+EDB7/EDB7\EDB7;
                      STA.B !_0                                 ;;EDBD|EDBB+EDBB/EDBB\EDBB;
                      LDA.L DATA_04D85D,X                       ;;EDBF|EDBD+EDBD/EDBD\EDBD;
                      TAX                                       ;;EDC3|EDC1+EDC1/EDC1\EDC1;
                      PHX                                       ;;EDC4|EDC2+EDC2/EDC2\EDC2;
                      LDX.B !_E                                 ;;EDC5|EDC3+EDC3/EDC3\EDC3;
                      SEP #$20                                  ;;EDC7|EDC5+EDC5/EDC5\EDC5; Accum (8 bit) 
                      LDA.L DATA_04DA33,X                       ;;EDC9|EDC7+EDC7/EDC7\EDC7;
                      PLX                                       ;;EDCD|EDCB+EDCB/EDCB\EDCB;
                      STA.L !Map16TilesLow,X                    ;;EDCE|EDCC+EDCC/EDCC\EDCC;
                      LDA.B #DATA_04ECD3>>16                    ;;EDD2|EDD0+EDD0/EDD0\EDD0;
                      STA.B !_C                                 ;;EDD4|EDD2+EDD2/EDD2\EDD2;
                      REP #$20                                  ;;EDD6|EDD4+EDD4/EDD4\EDD4; Accum (16 bit) 
                      LDA.W #DATA_04ECD3                        ;;EDD8|EDD6+EDD6/EDD6\EDD6;
                      STA.B !_A                                 ;;EDDB|EDD9+EDD9/EDD9\EDD9;
                      LDA.B !_E                                 ;;EDDD|EDDB+EDDB/EDDB\EDDB;
                      ASL A                                     ;;EDDF|EDDD+EDDD/EDDD\EDDD;
                      ASL A                                     ;;EDE0|EDDE+EDDE/EDDE\EDDE;
                      ASL A                                     ;;EDE1|EDDF+EDDF/EDDF\EDDF;
                      TAY                                       ;;EDE2|EDE0+EDE0/EDE0\EDE0;
                      LDA.L !DynStripeImgSize                   ;;EDE3|EDE1+EDE1/EDE1\EDE1;
                      TAX                                       ;;EDE7|EDE5+EDE5/EDE5\EDE5;
CODE_04EDE6:          LDA.B !_0                                 ;;EDE8|EDE6+EDE6/EDE6\EDE6;
                      STA.L !DynamicStripeImage,X               ;;EDEA|EDE8+EDE8/EDE8\EDE8;
                      CLC                                       ;;EDEE|EDEC+EDEC/EDEC\EDEC;
                      ADC.W #$2000                              ;;EDEF|EDED+EDED/EDED\EDED;
                      STA.L !DynamicStripeImage+8,X             ;;EDF2|EDF0+EDF0/EDF0\EDF0;
                      LDA.W #$0300                              ;;EDF6|EDF4+EDF4/EDF4\EDF4;
                      STA.L !DynamicStripeImage+2,X             ;;EDF9|EDF7+EDF7/EDF7\EDF7;
                      STA.L !DynamicStripeImage+$0A,X           ;;EDFD|EDFB+EDFB/EDFB\EDFB;
                      LDA.B [!_A],Y                             ;;EE01|EDFF+EDFF/EDFF\EDFF;
                      STA.L !DynamicStripeImage+4,X             ;;EE03|EE01+EE01/EE01\EE01;
                      INY                                       ;;EE07|EE05+EE05/EE05\EE05;
                      INY                                       ;;EE08|EE06+EE06/EE06\EE06;
                      LDA.B [!_A],Y                             ;;EE09|EE07+EE07/EE07\EE07;
                      STA.L !DynamicStripeImage+$0C,X           ;;EE0B|EE09+EE09/EE09\EE09;
                      INY                                       ;;EE0F|EE0D+EE0D/EE0D\EE0D;
                      INY                                       ;;EE10|EE0E+EE0E/EE0E\EE0E;
                      LDA.B [!_A],Y                             ;;EE11|EE0F+EE0F/EE0F\EE0F;
                      STA.L !DynamicStripeImage+6,X             ;;EE13|EE11+EE11/EE11\EE11;
                      INY                                       ;;EE17|EE15+EE15/EE15\EE15;
                      INY                                       ;;EE18|EE16+EE16/EE16\EE16;
                      LDA.B [!_A],Y                             ;;EE19|EE17+EE17/EE17\EE17;
                      STA.L !DynamicStripeImage+$0E,X           ;;EE1B|EE19+EE19/EE19\EE19;
                      LDA.W #$00FF                              ;;EE1F|EE1D+EE1D/EE1D\EE1D;
                      STA.L !DynamicStripeImage+$10,X           ;;EE22|EE20+EE20/EE20\EE20;
                      TXA                                       ;;EE26|EE24+EE24/EE24\EE24;
                      CLC                                       ;;EE27|EE25+EE25/EE25\EE25;
                      ADC.W #$0010                              ;;EE28|EE26+EE26/EE26\EE26;
                      STA.L !DynStripeImgSize                   ;;EE2B|EE29+EE29/EE29\EE29;
                      SEP #$30                                  ;;EE2F|EE2D+EE2D/EE2D\EE2D; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;EE31|EE2F+EE2F/EE2F\EE2F; Return 
                                                                ;;                        ;
CODE_04EE30:          SEP #$20                                  ;;EE32|EE30+EE30/EE30\EE30; Accum (8 bit) 
                      LDA.B #$7F                                ;;EE34|EE32+EE32/EE32\EE32;
                      STA.B !_E                                 ;;EE36|EE34+EE34/EE34\EE34;
                      REP #$30                                  ;;EE38|EE36+EE36/EE36\EE36; Index (16 bit) Accum (16 bit) 
                      LDA.W !EventTileIndex                     ;;EE3A|EE38+EE38/EE38\EE38;
                      ASL A                                     ;;EE3D|EE3B+EE3B/EE3B\EE3B;
                      ASL A                                     ;;EE3E|EE3C+EE3C/EE3C\EE3C;
                      TAX                                       ;;EE3F|EE3D+EE3D/EE3D\EE3D;
                      LDA.L DATA_04DD8F,X                       ;;EE40|EE3E+EE3E/EE3E\EE3E;
                      STA.B !_0                                 ;;EE44|EE42+EE42/EE42\EE42;
                      AND.W #$1FFF                              ;;EE46|EE44+EE44/EE44\EE44;
                      LSR A                                     ;;EE49|EE47+EE47/EE47\EE47;
                      CLC                                       ;;EE4A|EE48+EE48/EE48\EE48;
                      ADC.W #$3000                              ;;EE4B|EE49+EE49/EE49\EE49;
                      XBA                                       ;;EE4E|EE4C+EE4C/EE4C\EE4C;
                      STA.B !_2                                 ;;EE4F|EE4D+EE4D/EE4D\EE4D;
                      LDA.W #$4000                              ;;EE51|EE4F+EE4F/EE4F\EE4F;
                      STA.B !_C                                 ;;EE54|EE52+EE52/EE52\EE52;
                      LDA.W #$FFFF                              ;;EE56|EE54+EE54/EE54\EE54;
                      STA.B !_A                                 ;;EE59|EE57+EE57/EE57\EE57;
                      LDA.L DATA_04DD8D,X                       ;;EE5B|EE59+EE59/EE59\EE59;
                      CMP.W #$0900                              ;;EE5F|EE5D+EE5D/EE5D\EE5D;
                      BCC +                                     ;;EE62|EE60+EE60/EE60\EE60;
                      JSR CODE_04E76C                           ;;EE64|EE62+EE62/EE62\EE62;
                      JMP CODE_04EE6B                           ;;EE67|EE65+EE65/EE65\EE65;
                                                                ;;                        ;
                    + JSR CODE_04E824                           ;;EE6A|EE68+EE68/EE68\EE68;
CODE_04EE6B:          LDA.W #$00FF                              ;;EE6D|EE6B+EE6B/EE6B\EE6B;
                      STA.L !DynamicStripeImage,X               ;;EE70|EE6E+EE6E/EE6E\EE6E;
                      TXA                                       ;;EE74|EE72+EE72/EE72\EE72;
                      STA.L !DynStripeImgSize                   ;;EE75|EE73+EE73/EE73\EE73;
                      SEP #$30                                  ;;EE79|EE77+EE77/EE77\EE77; Index (8 bit) Accum (8 bit) 
                      RTS                                       ;;EE7B|EE79+EE79/EE79\EE79; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04EE7A:          db $22,$01,$82,$1C,$22,$01,$83,$1C        ;;EE7C|EE7A+EE7A/EE7A\EE7A;
                      db $22,$01,$82,$14,$22,$01,$83,$14        ;;EE84|EE82+EE82/EE82\EE82;
                      db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1        ;;EE8C|EE8A+EE8A/EE8A\EE8A;
                      db $EA,$01,$EA,$01,$EA,$C1,$EA,$C1        ;;EE94|EE92+EE92/EE92\EE92;
                      db $22,$01,$22,$01,$22,$01,$22,$01        ;;EE9C|EE9A+EE9A/EE9A\EE9A;
                      db $8A,$15,$9A,$15,$8B,$15,$9B,$15        ;;EEA4|EEA2+EEA2/EEA2\EEA2;
                                                                ;;                        ;
CODE_04EEAA:          SEP #$30                                  ;;EEAC|EEAA+EEAA/EEAA\EEAA; Index (8 bit) Accum (8 bit) 
                      LDA.B #!Map16TilesLow>>16                 ;;EEAE|EEAC+EEAC/EEAC\EEAC;
                      STA.B !_F                                 ;;EEB0|EEAE+EEAE/EEAE\EEAE;
                      LDA.B #DATA_04EE7A>>16                    ;;EEB2|EEB0+EEB0/EEB0\EEB0;
                      STA.B !_C                                 ;;EEB4|EEB2+EEB2/EEB2\EEB2;
                      REP #$30                                  ;;EEB6|EEB4+EEB4/EEB4\EEB4; Index (16 bit) Accum (16 bit) 
                      LDA.W #!Map16TilesLow                     ;;EEB8|EEB6+EEB6/EEB6\EEB6;
                      STA.B !_D                                 ;;EEBB|EEB9+EEB9/EEB9\EEB9;
                      LDA.W #DATA_04EE7A                        ;;EEBD|EEBB+EEBB/EEBB\EEBB;
                      STA.B !_A                                 ;;EEC0|EEBE+EEBE/EEBE\EEBE;
                      LDA.W !StructureCrushIndex                ;;EEC2|EEC0+EEC0/EEC0\EEC0;
                      AND.W #$00FF                              ;;EEC5|EEC3+EEC3/EEC3\EEC3;
                      ASL A                                     ;;EEC8|EEC6+EEC6/EEC6\EEC6;
                      TAX                                       ;;EEC9|EEC7+EEC7/EEC7\EEC7;
                      LDA.L DATA_04E587,X                       ;;EECA|EEC8+EEC8/EEC8\EEC8;
                      STA.B !_0                                 ;;EECE|EECC+EECC/EECC\EECC;
                      LDA.L !DynStripeImgSize                   ;;EED0|EECE+EECE/EECE\EECE;
                      TAX                                       ;;EED4|EED2+EED2/EED2\EED2;
                      LDA.W !StructureCrushTile                 ;;EED5|EED3+EED3/EED3\EED3;
                      AND.W #$00FF                              ;;EED8|EED6+EED6/EED6\EED6;
                      CMP.W #$0003                              ;;EEDB|EED9+EED9/EED9\EED9;
                      BMI +                                     ;;EEDE|EEDC+EEDC/EEDC\EEDC;
                      ASL A                                     ;;EEE0|EEDE+EEDE/EEDE\EEDE;
                      ASL A                                     ;;EEE1|EEDF+EEDF/EEDF\EEDF;
                      ASL A                                     ;;EEE2|EEE0+EEE0/EEE0\EEE0;
                      TAY                                       ;;EEE3|EEE1+EEE1/EEE1\EEE1;
                      LDA.B !_0                                 ;;EEE4|EEE2+EEE2/EEE2\EEE2;
                      STA.L !DynamicStripeImage,X               ;;EEE6|EEE4+EEE4/EEE4\EEE4;
                      CLC                                       ;;EEEA|EEE8+EEE8/EEE8\EEE8;
                      ADC.W #$2000                              ;;EEEB|EEE9+EEE9/EEE9\EEE9;
                      STA.L !DynamicStripeImage+8,X             ;;EEEE|EEEC+EEEC/EEEC\EEEC;
                      XBA                                       ;;EEF2|EEF0+EEF0/EEF0\EEF0;
                      CLC                                       ;;EEF3|EEF1+EEF1/EEF1\EEF1;
                      ADC.W #$0020                              ;;EEF4|EEF2+EEF2/EEF2\EEF2;
                      XBA                                       ;;EEF7|EEF5+EEF5/EEF5\EEF5;
                      STA.B !_0                                 ;;EEF8|EEF6+EEF6/EEF6\EEF6;
                      LDA.W #$0300                              ;;EEFA|EEF8+EEF8/EEF8\EEF8;
                      STA.L !DynamicStripeImage+2,X             ;;EEFD|EEFB+EEFB/EEFB\EEFB;
                      STA.L !DynamicStripeImage+$0A,X           ;;EF01|EEFF+EEFF/EEFF\EEFF;
                      LDA.B [!_A],Y                             ;;EF05|EF03+EF03/EF03\EF03;
                      STA.L !DynamicStripeImage+4,X             ;;EF07|EF05+EF05/EF05\EF05;
                      INY                                       ;;EF0B|EF09+EF09/EF09\EF09;
                      INY                                       ;;EF0C|EF0A+EF0A/EF0A\EF0A;
                      LDA.B [!_A],Y                             ;;EF0D|EF0B+EF0B/EF0B\EF0B;
                      STA.L !DynamicStripeImage+$0C,X           ;;EF0F|EF0D+EF0D/EF0D\EF0D;
                      INY                                       ;;EF13|EF11+EF11/EF11\EF11;
                      INY                                       ;;EF14|EF12+EF12/EF12\EF12;
                      LDA.B [!_A],Y                             ;;EF15|EF13+EF13/EF13\EF13;
                      STA.L !DynamicStripeImage+6,X             ;;EF17|EF15+EF15/EF15\EF15;
                      INY                                       ;;EF1B|EF19+EF19/EF19\EF19;
                      INY                                       ;;EF1C|EF1A+EF1A/EF1A\EF1A;
                      LDA.B [!_A],Y                             ;;EF1D|EF1B+EF1B/EF1B\EF1B;
                      STA.L !DynamicStripeImage+$0E,X           ;;EF1F|EF1D+EF1D/EF1D\EF1D;
                      TXA                                       ;;EF23|EF21+EF21/EF21\EF21;
                      CLC                                       ;;EF24|EF22+EF22/EF22\EF22;
                      ADC.W #$0010                              ;;EF25|EF23+EF23/EF23\EF23;
                      TAX                                       ;;EF28|EF26+EF26/EF26\EF26;
                    + LDA.W !StructureCrushTile                 ;;EF29|EF27+EF27/EF27\EF27;
                      AND.W #$00FF                              ;;EF2C|EF2A+EF2A/EF2A\EF2A;
                      CMP.W #$0002                              ;;EF2F|EF2D+EF2D/EF2D\EF2D;
                      BPL CODE_04EF38                           ;;EF32|EF30+EF30/EF30\EF30;
                      ASL A                                     ;;EF34|EF32+EF32/EF32\EF32;
                      ASL A                                     ;;EF35|EF33+EF33/EF33\EF33;
                      ASL A                                     ;;EF36|EF34+EF34/EF34\EF34;
                      TAY                                       ;;EF37|EF35+EF35/EF35\EF35;
                      BRA +                                     ;;EF38|EF36+EF36/EF36\EF36;
                                                                ;;                        ;
CODE_04EF38:          LDY.W #$0028                              ;;EF3A|EF38+EF38/EF38\EF38;
                    + JMP CODE_04EDE6                           ;;EF3D|EF3B+EF3B/EF3B\EF3B;
                                                                ;;                        ;
                      %insert_empty($340,$342,$342,$342,$342)   ;;EF40|EF3E+EF3E/EF3E\EF3E;
                                                                ;;                        ;
DATA_04F280:          db $00,$D8,$28,$D0,$30,$D8,$28,$00        ;;F280|F280+F280/F280\F280;
DATA_04F288:          db $D0,$D8,$D8,$00,$00,$28,$28,$30        ;;F288|F288+F288/F288\F288;
                                                                ;;                        ;
CODE_04F290:          LDY.W !KeyholeYPos+1                      ;;F290|F290+F290/F290\F290; Index (8 bit) Accum (8 bit) 
                      CPY.B #$0C                                ;;F293|F293+F293/F293\F293;
                      BCC +                                     ;;F295|F295+F295/F295\F295;
                      STZ.W !SwitchPalaceColor                  ;;F297|F297+F297/F297\F297;
                      RTS                                       ;;F29A|F29A+F29A/F29A\F29A; Return 
                                                                ;;                        ;
                    + LDA.W !KeyholeXPos+1                      ;;F29B|F29B+F29B/F29B\F29B;
                      BNE CODE_04F314                           ;;F29E|F29E+F29E/F29E\F29E;
                      CPY.B #$08                                ;;F2A0|F2A0+F2A0/F2A0\F2A0;
                      BCS CODE_04F30C                           ;;F2A2|F2A2+F2A2/F2A2\F2A2;
                      LDA.B #!SFX_SWITCHBLOCK                   ;;F2A4|F2A4+F2A4/F2A4\F2A4;
                      STA.W !SPCIO3                             ;;F2A6|F2A6+F2A6/F2A6\F2A6; / Play sound effect 
                      LDA.B #$07                                ;;F2A9|F2A9+F2A9/F2A9\F2A9;
                      STA.B !_0                                 ;;F2AB|F2AB+F2AB/F2AB\F2AB;
                      LDX.W !KeyholeXPos                        ;;F2AD|F2AD+F2AD/F2AD\F2AD;
                    - LDY.W !PlayerTurnOW                       ;;F2B0|F2B0+F2B0/F2B0\F2B0;
                      LDA.W !OWPlayerXPos,Y                     ;;F2B3|F2B3+F2B3/F2B3\F2B3;
                      STA.L !SwitchEventTableC,X                ;;F2B6|F2B6+F2B6/F2B6\F2B6;
                      LDA.W !OWPlayerXPos+1,Y                   ;;F2BA|F2BA+F2BA/F2BA\F2BA;
                      STA.L !Layer2TilemapLow,X                 ;;F2BD|F2BD+F2BD/F2BD\F2BD;
                      LDA.W !OWPlayerYPos,Y                     ;;F2C1|F2C1+F2C1/F2C1\F2C1;
                      STA.L !SwitchEventTableD,X                ;;F2C4|F2C4+F2C4/F2C4\F2C4;
                      LDA.W !OWPlayerYPos+1,Y                   ;;F2C8|F2C8+F2C8/F2C8\F2C8;
                      STA.L !SwitchEventTableA,X                ;;F2CB|F2CB+F2CB/F2CB\F2CB;
                      LDA.B #$00                                ;;F2CF|F2CF+F2CF/F2CF\F2CF;
                      STA.L !SwitchEventTableE,X                ;;F2D1|F2D1+F2D1/F2D1\F2D1;
                      STA.L !SwitchEventTableB,X                ;;F2D5|F2D5+F2D5/F2D5\F2D5;
                      LDY.B !_0                                 ;;F2D9|F2D9+F2D9/F2D9\F2D9;
                      LDA.W DATA_04F280,Y                       ;;F2DB|F2DB+F2DB/F2DB\F2DB;
                      STA.L !SwitchEventTableF,X                ;;F2DE|F2DE+F2DE/F2DE\F2DE;
                      LDA.W DATA_04F288,Y                       ;;F2E2|F2E2+F2E2/F2E2\F2E2;
                      STA.L !SwitchEventTableG,X                ;;F2E5|F2E5+F2E5/F2E5\F2E5;
                      LDA.B #$D0                                ;;F2E9|F2E9+F2E9/F2E9\F2E9;
                      STA.L !SwitchEventTableH,X                ;;F2EB|F2EB+F2EB/F2EB\F2EB;
                      INX                                       ;;F2EF|F2EF+F2EF/F2EF\F2EF;
                      DEC.B !_0                                 ;;F2F0|F2F0+F2F0/F2F0\F2F0;
                      BPL -                                     ;;F2F2|F2F2+F2F2/F2F2\F2F2;
                      CPX.B #$28                                ;;F2F4|F2F4+F2F4/F2F4\F2F4;
                      BCC CODE_04F309                           ;;F2F6|F2F6+F2F6/F2F6\F2F6;
                      LDA.W !KeyholeYPos                        ;;F2F8|F2F8+F2F8/F2F8\F2F8;
                      CLC                                       ;;F2FB|F2FB+F2FB/F2FB\F2FB;
                      ADC.B #$20                                ;;F2FC|F2FC+F2FC/F2FC\F2FC;
                      CMP.B #$A0                                ;;F2FE|F2FE+F2FE/F2FE\F2FE;
                      BCC +                                     ;;F300|F300+F300/F300\F300;
                      LDA.B #$00                                ;;F302|F302+F302/F302\F302;
                    + STA.W !KeyholeYPos                        ;;F304|F304+F304/F304\F304;
                      LDX.B #$00                                ;;F307|F307+F307/F307\F307;
CODE_04F309:          STX.W !KeyholeXPos                        ;;F309|F309+F309/F309\F309;
CODE_04F30C:          LDA.B #$10                                ;;F30C|F30C+F30C/F30C\F30C;
                      STA.W !KeyholeXPos+1                      ;;F30E|F30E+F30E/F30E\F30E;
                      INC.W !KeyholeYPos+1                      ;;F311|F311+F311/F311\F311;
CODE_04F314:          DEC.W !KeyholeXPos+1                      ;;F314|F314+F314/F314\F314;
                      LDA.W !KeyholeYPos                        ;;F317|F317+F317/F317\F317;
                      STA.B !_F                                 ;;F31A|F31A+F31A/F31A\F31A;
                      LDX.B #$00                                ;;F31C|F31C+F31C/F31C\F31C;
CODE_04F31E:          PHX                                       ;;F31E|F31E+F31E/F31E\F31E;
                      LDY.B #$00                                ;;F31F|F31F+F31F/F31F\F31F;
                      JSR CODE_04F39C                           ;;F321|F321+F321/F321\F321;
                      JSR CODE_04F397                           ;;F324|F324+F324/F324\F324;
                      JSR CODE_04F397                           ;;F327|F327+F327/F327\F327;
                      PLX                                       ;;F32A|F32A+F32A/F32A\F32A;
                      LDA.L !SwitchEventTableH,X                ;;F32B|F32B+F32B/F32B\F32B;
                      CLC                                       ;;F32F|F32F+F32F/F32F\F32F;
                      ADC.B #$01                                ;;F330|F330+F330/F330\F330;
                      BMI +                                     ;;F332|F332+F332/F332\F332;
                      CMP.B #$40                                ;;F334|F334+F334/F334\F334;
                      BCC +                                     ;;F336|F336+F336/F336\F336;
                      LDA.B #$40                                ;;F338|F338+F338/F338\F338;
                    + STA.L !SwitchEventTableH,X                ;;F33A|F33A+F33A/F33A\F33A;
                      LDA.L !SwitchEventTableB,X                ;;F33E|F33E+F33E/F33E\F33E;
                      XBA                                       ;;F342|F342+F342/F342\F342;
                      LDA.L !SwitchEventTableE,X                ;;F343|F343+F343/F343\F343;
                      REP #$20                                  ;;F347|F347+F347/F347\F347; Accum (16 bit) 
                      CLC                                       ;;F349|F349+F349/F349\F349;
                      ADC.B !_2                                 ;;F34A|F34A+F34A/F34A\F34A;
                      STA.B !_2                                 ;;F34C|F34C+F34C/F34C\F34C;
                      SEP #$20                                  ;;F34E|F34E+F34E/F34E\F34E; Accum (8 bit) 
                      XBA                                       ;;F350|F350+F350/F350\F350;
                      ORA.B !_1                                 ;;F351|F351+F351/F351\F351;
                      BNE +                                     ;;F353|F353+F353/F353\F353;
                      LDY.B !_F                                 ;;F355|F355+F355/F355\F355;
                      XBA                                       ;;F357|F357+F357/F357\F357;
                      STA.W !OAMTileYPos+$140,Y                 ;;F358|F358+F358/F358\F358;
                      LDA.B !_0                                 ;;F35B|F35B+F35B/F35B\F35B;
                      STA.W !OAMTileXPos+$140,Y                 ;;F35D|F35D+F35D/F35D\F35D;
                      LDA.B #$E6                                ;;F360|F360+F360/F360\F360;
                      STA.W !OAMTileNo+$140,Y                   ;;F362|F362+F362/F362\F362;
                      LDA.W !SwitchPalaceColor                  ;;F365|F365+F365/F365\F365;
                      DEC A                                     ;;F368|F368+F368/F368\F368;
                      ASL A                                     ;;F369|F369+F369/F369\F369;
                      ORA.B #$30                                ;;F36A|F36A+F36A/F36A\F36A;
                      STA.W !OAMTileAttr+$140,Y                 ;;F36C|F36C+F36C/F36C\F36C;
                      TYA                                       ;;F36F|F36F+F36F/F36F\F36F;
                      LSR A                                     ;;F370|F370+F370/F370\F370;
                      LSR A                                     ;;F371|F371+F371/F371\F371;
                      TAY                                       ;;F372|F372+F372/F372\F372;
                      LDA.B #$02                                ;;F373|F373+F373/F373\F373;
                      STA.W !OAMTileSize+$50,Y                  ;;F375|F375+F375/F375\F375;
                    + LDA.B !_F                                 ;;F378|F378+F378/F378\F378;
                      CLC                                       ;;F37A|F37A+F37A/F37A\F37A;
                      ADC.B #$04                                ;;F37B|F37B+F37B/F37B\F37B;
                      CMP.B #$A0                                ;;F37D|F37D+F37D/F37D\F37D;
                      BCC +                                     ;;F37F|F37F+F37F/F37F\F37F;
                      LDA.B #$00                                ;;F381|F381+F381/F381\F381;
                    + STA.B !_F                                 ;;F383|F383+F383/F383\F383;
                      INX                                       ;;F385|F385+F385/F385\F385;
                      CPX.W !KeyholeXPos                        ;;F386|F386+F386/F386\F386;
                      BCC CODE_04F31E                           ;;F389|F389+F389/F389\F389;
                      LDA.W !KeyholeYPos+1                      ;;F38B|F38B+F38B/F38B\F38B;
                      CMP.B #$05                                ;;F38E|F38E+F38E/F38E\F38E;
                      BCC Return04F396                          ;;F390|F390+F390/F390\F390;
                      CPX.B #$28                                ;;F392|F392+F392/F392\F392;
                      BCC CODE_04F31E                           ;;F394|F394+F394/F394\F394;
Return04F396:         RTS                                       ;;F396|F396+F396/F396\F396; Return 
                                                                ;;                        ;
CODE_04F397:          TXA                                       ;;F397|F397+F397/F397\F397;
                      CLC                                       ;;F398|F398+F398/F398\F398;
                      ADC.B #$28                                ;;F399|F399+F399/F399\F399;
                      TAX                                       ;;F39B|F39B+F39B/F39B\F39B;
CODE_04F39C:          PHY                                       ;;F39C|F39C+F39C/F39C\F39C;
                      LDA.L !SwitchEventTableF,X                ;;F39D|F39D+F39D/F39D\F39D;
                      ASL A                                     ;;F3A1|F3A1+F3A1/F3A1\F3A1;
                      ASL A                                     ;;F3A2|F3A2+F3A2/F3A2\F3A2;
                      ASL A                                     ;;F3A3|F3A3+F3A3/F3A3\F3A3;
                      ASL A                                     ;;F3A4|F3A4+F3A4/F3A4\F3A4;
                      CLC                                       ;;F3A5|F3A5+F3A5/F3A5\F3A5;
                      ADC.L !SwitchEventTableI,X                ;;F3A6|F3A6+F3A6/F3A6\F3A6;
                      STA.L !SwitchEventTableI,X                ;;F3AA|F3AA+F3AA/F3AA\F3AA;
                      LDA.L !SwitchEventTableF,X                ;;F3AE|F3AE+F3AE/F3AE\F3AE;
                      PHP                                       ;;F3B2|F3B2+F3B2/F3B2\F3B2;
                      LSR A                                     ;;F3B3|F3B3+F3B3/F3B3\F3B3;
                      LSR A                                     ;;F3B4|F3B4+F3B4/F3B4\F3B4;
                      LSR A                                     ;;F3B5|F3B5+F3B5/F3B5\F3B5;
                      LSR A                                     ;;F3B6|F3B6+F3B6/F3B6\F3B6;
                      LDY.B #$00                                ;;F3B7|F3B7+F3B7/F3B7\F3B7;
                      PLP                                       ;;F3B9|F3B9+F3B9/F3B9\F3B9;
                      BPL +                                     ;;F3BA|F3BA+F3BA/F3BA\F3BA;
                      ORA.B #$F0                                ;;F3BC|F3BC+F3BC/F3BC\F3BC;
                      DEY                                       ;;F3BE|F3BE+F3BE/F3BE\F3BE;
                    + ADC.L !SwitchEventTableC,X                ;;F3BF|F3BF+F3BF/F3BF\F3BF;
                      STA.L !SwitchEventTableC,X                ;;F3C3|F3C3+F3C3/F3C3\F3C3;
                      XBA                                       ;;F3C7|F3C7+F3C7/F3C7\F3C7;
                      TYA                                       ;;F3C8|F3C8+F3C8/F3C8\F3C8;
                      ADC.L !Layer2TilemapLow,X                 ;;F3C9|F3C9+F3C9/F3C9\F3C9;
                      STA.L !Layer2TilemapLow,X                 ;;F3CD|F3CD+F3CD/F3CD\F3CD;
                      XBA                                       ;;F3D1|F3D1+F3D1/F3D1\F3D1;
                      PLY                                       ;;F3D2|F3D2+F3D2/F3D2\F3D2;
                      REP #$20                                  ;;F3D3|F3D3+F3D3/F3D3\F3D3; Accum (16 bit) 
                      SEC                                       ;;F3D5|F3D5+F3D5/F3D5\F3D5;
                      SBC.W !Layer1XPos,Y                       ;;F3D6|F3D6+F3D6/F3D6\F3D6;
                      SEC                                       ;;F3D9|F3D9+F3D9/F3D9\F3D9;
                      SBC.W #$0008                              ;;F3DA|F3DA+F3DA/F3DA\F3DA;
                      STA.W !_0,Y                               ;;F3DD|F3DD+F3DD/F3DD\F3DD;
                      SEP #$20                                  ;;F3E0|F3E0+F3E0/F3E0\F3E0; Accum (8 bit) 
                      INY                                       ;;F3E2|F3E2+F3E2/F3E2\F3E2;
                      INY                                       ;;F3E3|F3E3+F3E3/F3E3\F3E3;
                      RTS                                       ;;F3E4|F3E4+F3E4/F3E4\F3E4; Return 
                                                                ;;                        ;
CODE_04F3E5:          DEC A                                     ;;F3E5|F3E5+F3E5/F3E5\F3E5;
                      JSL ExecutePtr                            ;;F3E6|F3E6+F3E6/F3E6\F3E6;
                                                                ;;                        ;
                      dw CODE_04F3FF                            ;;F3EA|F3EA+F3EA/F3EA\F3EA;
                      dw CODE_04F415                            ;;F3EC|F3EC+F3EC/F3EC\F3EC;
                      dw CODE_04F513                            ;;F3EE|F3EE+F3EE/F3EE\F3EE;
                      dw CODE_04F415                            ;;F3F0|F3F0+F3F0/F3F0\F3F0;
                      dw CODE_04F3FF                            ;;F3F2|F3F2+F3F2/F3F2\F3F2;
                      dw CODE_04F415                            ;;F3F4|F3F4+F3F4/F3F4\F3F4;
                      dw CODE_04F3FA                            ;;F3F6|F3F6+F3F6/F3F6\F3F6;
                      dw CODE_04F415                            ;;F3F8|F3F8+F3F8/F3F8\F3F8;
                                                                ;;                        ;
CODE_04F3FA:          JSL CODE_009BA8                           ;;F3FA|F3FA+F3FA/F3FA\F3FA;
                      RTS                                       ;;F3FE|F3FE+F3FE/F3FE\F3FE; Return 
                                                                ;;                        ;
CODE_04F3FF:          LDA.B #!SFX_MESSAGE                       ;;F3FF|F3FF+F3FF/F3FF\F3FF;
                      STA.W !SPCIO3                             ;;F401|F401+F401/F401\F401; / Play sound effect 
                      INC.W !OverworldPromptProcess             ;;F404|F404+F404/F404\F404;
CODE_04F407:          STZ.B !Layer12Window                      ;;F407|F407+F407/F407\F407;
                      STZ.B !Layer34Window                      ;;F409|F409+F409/F409\F409;
                      STZ.B !OBJCWWindow                        ;;F40B|F40B+F40B/F40B\F40B;
                      STZ.W !HDMAEnable                         ;;F40D|F40D+F40D/F40D\F40D;
                      RTS                                       ;;F410|F410+F410/F410\F410; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04F411:          db $04,$FC                                ;;F411|F411+F411/F411\F411;
                                                                ;;                        ;
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
DATA_04F413:          db $48,$00                                ;;F413                    ;
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0, & E1
DATA_04F413:          db $68,$00                                ;;    |F413+F413/F413\F413;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                                                                ;;                        ;
CODE_04F415:          LDX.B #$00                                ;;F415|F415+F415/F415\F415;
                      LDA.W !SavedPlayerLives                   ;;F417|F417+F417/F417\F417;
                      CMP.W !SavedPlayerLives+1                 ;;F41A|F41A+F41A/F41A\F41A;
                      BPL +                                     ;;F41D|F41D+F41D/F41D\F41D;
                      INX                                       ;;F41F|F41F+F41F/F41F\F41F;
                    + STX.W !OWPromptArrowDir                   ;;F420|F420+F420/F420\F420;
                      LDX.W !MessageBoxExpand                   ;;F423|F423+F423/F423\F423;
                      LDA.W !MessageBoxTimer                    ;;F426|F426+F426/F426\F426;
                      CMP.L DATA_04F413,X                       ;;F429|F429+F429/F429\F429;
                      BNE CODE_04F44B                           ;;F42D|F42D+F42D/F42D\F42D;
                      INC.W !OverworldPromptProcess             ;;F42F|F42F+F42F/F42F\F42F;
                      LDA.W !OverworldPromptProcess             ;;F432|F432+F432/F432\F432;
                      CMP.B #$07                                ;;F435|F435+F435/F435\F435;
                      BNE +                                     ;;F437|F437+F437/F437\F437;
                      LDY.B #$1E                                ;;F439|F439+F439/F439\F439;
                      STY.B !StripeImage                        ;;F43B|F43B+F43B/F43B\F43B;
                    + DEC A                                     ;;F43D|F43D+F43D/F43D\F43D;
                      AND.B #$03                                ;;F43E|F43E+F43E/F43E\F43E;
                      BNE Return04F44A                          ;;F440|F440+F440/F440\F440;
                      STZ.W !OverworldPromptProcess             ;;F442|F442+F442/F442\F442;
                      STZ.W !MessageBoxExpand                   ;;F445|F445+F445/F445\F445;
                      BRA CODE_04F407                           ;;F448|F448+F448/F448\F448;
                                                                ;;                        ;
Return04F44A:         RTS                                       ;;F44A|F44A+F44A/F44A\F44A; Return 
                                                                ;;                        ;
CODE_04F44B:          CLC                                       ;;F44B|F44B+F44B/F44B\F44B;
                      ADC.L DATA_04F411,X                       ;;F44C|F44C+F44C/F44C\F44C;
                      STA.W !MessageBoxTimer                    ;;F450|F450+F450/F450\F450;
                      CLC                                       ;;F453|F453+F453/F453\F453;
                      ADC.B #$80                                ;;F454|F454+F454/F454\F454;
                      XBA                                       ;;F456|F456+F456/F456\F456;
                      REP #$10                                  ;;F457|F457+F457/F457\F457; Index (16 bit) 
                      LDX.W #con($016E,$016E,$016E,$016E,$018E) ;;F459|F459+F459/F459\F459;
                      LDA.B #$FF                                ;;F45C|F45C+F45C/F45C\F45C;
                    - STA.W !WindowTable+$50,X                  ;;F45E|F45E+F45E/F45E\F45E;
                      STZ.W !WindowTable+$51,X                  ;;F461|F461+F461/F461\F461;
                      DEX                                       ;;F464|F464+F464/F464\F464;
                      DEX                                       ;;F465|F465+F465/F465\F465;
                      BPL -                                     ;;F466|F466+F466/F466\F466;
                      SEP #$10                                  ;;F468|F468+F468/F468\F468; Index (8 bit) 
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
                      LDA.B #$80                                ;;F46A                    ; timing difference for size of overworld save box
                      SEC                                       ;;F46C                    ;
                      SBC.W !MessageBoxTimer                    ;;F46D                    ;
                      REP #$20                                  ;;F470                    ;
                      LDX.W !MessageBoxTimer                    ;;F472                    ;
                      LDY.B #$48                                ;;F475                    ;
                    - STA.W !WindowTable+$C8,Y                  ;;F477                    ;
                      STA.W !WindowTable+$110,X                 ;;F47A                    ;
                      DEY                                       ;;F47D                    ;
                      DEY                                       ;;F47E                    ;
                      DEX                                       ;;F47F                    ;
                      DEX                                       ;;F480                    ;
                      BPL -                                     ;;F481                    ;
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0, & E1
                      LDA.W !MessageBoxTimer                    ;;    |F46A+F46A/F46A\F46A;
                      LSR A                                     ;;    |F46D+F46D/F46D\F46D;
                      ADC.W !MessageBoxTimer                    ;;    |F46E+F46E/F46E\F46E;
                      LSR A                                     ;;    |F471+F471/F471\F471;
                      AND.B #$FE                                ;;    |F472+F472/F472\F472;
                      TAX                                       ;;    |F474+F474/F474\F474;
                      LDA.B #$80                                ;;    |F475+F475/F475\F475;
                      SEC                                       ;;    |F477+F477/F477\F477;
                      SBC.W !MessageBoxTimer                    ;;    |F478+F478/F478\F478;
                      REP #$20                                  ;;    |F47B+F47B/F47B\F47B; Accum (16 bit) 
                      LDY.B #$48                                ;;    |F47D+F47D/F47D\F47D;
                    - STA.W !WindowTable+$A8,Y                  ;;    |F47F+F47F/F47F\F47F;
                      STA.W !WindowTable+$F0,X                  ;;    |F482+F482/F482\F482;
                      DEY                                       ;;    |F485+F485/F485\F485;
                      DEY                                       ;;    |F486+F486/F486\F486;
                      DEX                                       ;;    |F487+F487/F487\F487;
                      DEX                                       ;;    |F488+F488/F488\F488;
                      BPL -                                     ;;    |F489+F489/F489\F489;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                      STZ.W !BackgroundColor                    ;;F483|F48B+F48B/F48B\F48B;
                      SEP #$20                                  ;;F486|F48E+F48E/F48E\F48E; Accum (8 bit) 
                      LDA.B #$22                                ;;F488|F490+F490/F490\F490;
                      STA.B !Layer12Window                      ;;F48A|F492+F492/F492\F492;
                      LDA.B #$20                                ;;F48C|F494+F494/F494\F494;
                      JMP CODE_04DB95                           ;;F48E|F496+F496/F496\F496;
                                                                ;;                        ;
                                                                ;;                        ;
                   if ver_is_japanese(!_VER)          ;\   IF   ;;++++++++++++++++++++++++; J
ClearOWBoxStripe:     db $51,$C9,$40,$14,$FC,$38,$52,$08        ;;F491                    ;
                      db $40,$1E,$FC,$38,$52,$2F,$40,$02        ;;F499                    ;
                      db $FC,$38,$52,$48,$40,$1C,$FC,$38        ;;F4A1                    ;
                      db $FF                                    ;;F4A9                    ;
                   else                               ;<  ELSE  ;;------------------------; U, SS, E0, & E1
ClearOWBoxStripe:     db $51,$C4,$40,$24,$FC,$38,$52,$04        ;;    |F499+F499/F499\F499;
                      db $40,$2C,$FC,$38,$52,$2F,$40,$02        ;;    |F4A1+F4A1/F4A1\F4A1;
                      db $FC,$38,$52,$48,$40,$1C,$FC,$38        ;;    |F4A9+F4A9/F4A9\F4A9;
                      db $FF                                    ;;    |F4B1+F4B1/F4B1\F4B1;
                   endif                              ;/ ENDIF  ;;++++++++++++++++++++++++;
                                                                ;;                        ;
DATA_04F4B2:          db $52,$49,$00,$09,$16,$28,$0A,$28        ;;F4AA|F4B2+F4B2/F4B2\F4B2;
                      db $1B,$28,$12,$28,$18,$28,$52,$52        ;;F4B2|F4BA+F4BA/F4BA\F4BA;
                      db $00,$09,$15,$28,$1E,$28,$12,$28        ;;F4BA|F4C2+F4C2/F4C2\F4C2;
                      db $10,$28,$12,$28,$52,$0B,$00,$05        ;;F4C2|F4CA+F4CA/F4CA\F4CA;
                      db $26,$28,$00,$28,$00,$28,$52,$14        ;;F4CA|F4D2+F4D2/F4D2\F4D2;
                      db $00,$05,$26,$28,$00,$28,$00,$28        ;;F4D2|F4DA+F4DA/F4DA\F4DA;
                      db $52,$0F,$00,$03,$FC,$38,$FC,$38        ;;F4DA|F4E2+F4E2/F4E2\F4E2;
                      db $52,$2F,$00,$03,$FC,$38,$FC,$38        ;;F4E2|F4EA+F4EA/F4EA\F4EA;
                      db $51,$C9,$00,$03,$85,$29,$85,$69        ;;F4EA|F4F2+F4F2/F4F2\F4F2;
                      db $51,$D2,$00,$03,$85,$29,$85,$69        ;;F4F2|F4FA+F4FA/F4FA\F4FA;
                      db $FF                                    ;;F4FA|F502+F502/F502\F502;
                                                                ;;                        ;
DATA_04F503:          db $7D,$38,$7E,$78                        ;;F4FB|F503+F503/F503\F503;
                                                                ;;                        ;
DATA_04F507:          db $7E,$38,$7D,$78                        ;;F4FF|F507+F507/F507\F507;
                                                                ;;                        ;
DATA_04F50B:          db $7D,$B8,$7E,$F8                        ;;F503|F50B+F50B/F50B\F50B;
                                                                ;;                        ;
DATA_04F50F:          db $7E,$B8,$7D,$F8                        ;;F507|F50F+F50F/F50F\F50F;
                                                                ;;                        ;
CODE_04F513:          LDA.W !byetudlrP1Frame                    ;;F50B|F513+F513/F513\F513;
                      ORA.W !byetudlrP2Frame                    ;;F50E|F516+F516/F516\F516;
                      AND.B #$10                                ;;F511|F519+F519/F519\F519;
                      BEQ +                                     ;;F513|F51B+F51B/F51B\F51B;
                      LDX.W !PlayerTurnLvl                      ;;F515|F51D+F51D/F51D\F51D;
                      LDA.W !SavedPlayerLives,X                 ;;F518|F520+F520/F520\F520;
                      STA.W !PlayerLives                        ;;F51B|F523+F523/F523\F523;
                      JSL CODE_009C13                           ;;F51E|F526+F526/F526\F526;
                      RTS                                       ;;F522|F52A+F52A/F52A\F52A; Return 
                                                                ;;                        ;
                    + LDA.W !byetudlrP1Frame                    ;;F523|F52B+F52B/F52B\F52B;
                      AND.B #$C0                                ;;F526|F52E+F52E/F52E\F52E;
                      BNE CODE_04F53B                           ;;F528|F530+F530/F530\F530;
                      LDA.W !byetudlrP2Frame                    ;;F52A|F532+F532/F532\F532;
                      AND.B #$C0                                ;;F52D|F535+F535/F535\F535;
                      BEQ CODE_04F56C                           ;;F52F|F537+F537/F537\F537;
                      EOR.B #$C0                                ;;F531|F539+F539/F539\F539;
CODE_04F53B:          LDX.B #$01                                ;;F533|F53B+F53B/F53B\F53B;
                      ASL A                                     ;;F535|F53D+F53D/F53D\F53D;
                      BCS +                                     ;;F536|F53E+F53E/F53E\F53E;
                      DEX                                       ;;F538|F540+F540/F540\F540;
                    + CPX.W !OWPromptArrowDir                   ;;F539|F541+F541/F541\F541;
                      BEQ +                                     ;;F53C|F544+F544/F544\F544;
                      LDA.B #$18                                ;;F53E|F546+F546/F546\F546;
                      STA.W !OWPromptArrowTimer                 ;;F540|F548+F548/F548\F548;
                    + STX.W !OWPromptArrowDir                   ;;F543|F54B+F54B/F54B\F54B;
                      TXA                                       ;;F546|F54E+F54E/F54E\F54E;
                      EOR.B #$01                                ;;F547|F54F+F54F/F54F\F54F;
                      TAY                                       ;;F549|F551+F551/F551\F551;
                      LDA.W !SavedPlayerLives,X                 ;;F54A|F552+F552/F552\F552;
                      BEQ CODE_04F56C                           ;;F54D|F555+F555/F555\F555;
                      BMI CODE_04F56C                           ;;F54F|F557+F557/F557\F557;
                      LDA.W !SavedPlayerLives,Y                 ;;F551|F559+F559/F559\F559;
                      CMP.B #$62                                ;;F554|F55C+F55C/F55C\F55C;
                      BPL CODE_04F56C                           ;;F556|F55E+F55E/F55E\F55E;
                      INC A                                     ;;F558|F560+F560/F560\F560;
                      STA.W !SavedPlayerLives,Y                 ;;F559|F561+F561/F561\F561;
                      DEC.W !SavedPlayerLives,X                 ;;F55C|F564+F564/F564\F564;
                      LDA.B #!SFX_BEEP                          ;;F55F|F567+F567/F567\F567;
                      STA.W !SPCIO3                             ;;F561|F569+F569/F569\F569; / Play sound effect 
CODE_04F56C:          REP #$20                                  ;;F564|F56C+F56C/F56C\F56C; Accum (16 bit) 
                      LDA.W #$7848                              ;;F566|F56E+F56E/F56E\F56E;
                      STA.W !OAMTileXPos+$9C                    ;;F569|F571+F571/F571\F571;
                      LDA.W #$7890                              ;;F56C|F574+F574/F574\F574;
                      STA.W !OAMTileXPos+$A0                    ;;F56F|F577+F577/F577\F577;
                      LDA.W #$340A                              ;;F572|F57A+F57A/F57A\F57A;
                      STA.W !OAMTileNo+$9C                      ;;F575|F57D+F57D/F57D\F57D;
                      LDA.W #$360A                              ;;F578|F580+F580/F580\F580;
                      STA.W !OAMTileNo+$A0                      ;;F57B|F583+F583/F583\F583;
                      SEP #$20                                  ;;F57E|F586+F586/F586\F586; Accum (8 bit) 
                      LDA.B #$02                                ;;F580|F588+F588/F588\F588;
                      STA.W !OAMTileSize+$27                    ;;F582|F58A+F58A/F58A\F58A;
                      STA.W !OAMTileSize+$28                    ;;F585|F58D+F58D/F58D\F58D;
                      JSL CODE_05DBF2                           ;;F588|F590+F590/F590\F590;
                      LDY.B #$50                                ;;F58C|F594+F594/F594\F594;
                      TYA                                       ;;F58E|F596+F596/F596\F596;
                      CLC                                       ;;F58F|F597+F597/F597\F597;
                      ADC.L !DynStripeImgSize                   ;;F590|F598+F598/F598\F598;
                      STA.L !DynStripeImgSize                   ;;F594|F59C+F59C/F59C\F59C;
                      TAX                                       ;;F598|F5A0+F5A0/F5A0\F5A0;
                    - LDA.W DATA_04F4B2,Y                       ;;F599|F5A1+F5A1/F5A1\F5A1;
                      STA.L !DynamicStripeImage,X               ;;F59C|F5A4+F5A4/F5A4\F5A4;
                      DEX                                       ;;F5A0|F5A8+F5A8/F5A8\F5A8;
                      DEY                                       ;;F5A1|F5A9+F5A9/F5A9\F5A9;
                      BPL -                                     ;;F5A2|F5AA+F5AA/F5AA\F5AA;
                      INX                                       ;;F5A4|F5AC+F5AC/F5AC\F5AC;
                      REP #$20                                  ;;F5A5|F5AD+F5AD/F5AD\F5AD; Accum (16 bit) 
                      LDY.W !SavedPlayerLives                   ;;F5A7|F5AF+F5AF/F5AF\F5AF;
                      BMI +                                     ;;F5AA|F5B2+F5B2/F5B2\F5B2;
                      LDA.W #$38FC                              ;;F5AC|F5B4+F5B4/F5B4\F5B4;
                      STA.L !DynamicStripeImage+$44,X           ;;F5AF|F5B7+F5B7/F5B7\F5B7;
                      STA.L !DynamicStripeImage+$46,X           ;;F5B3|F5BB+F5BB/F5BB\F5BB;
                    + LDY.W !SavedPlayerLives+1                 ;;F5B7|F5BF+F5BF/F5BF\F5BF;
                      BMI +                                     ;;F5BA|F5C2+F5C2/F5C2\F5C2;
                      LDA.W #$38FC                              ;;F5BC|F5C4+F5C4/F5C4\F5C4;
                      STA.L !DynamicStripeImage+$4C,X           ;;F5BF|F5C7+F5C7/F5C7\F5C7;
                      STA.L !DynamicStripeImage+$4E,X           ;;F5C3|F5CB+F5CB/F5CB\F5CB;
                    + SEP #$20                                  ;;F5C7|F5CF+F5CF/F5CF\F5CF; Accum (8 bit) 
                      INC.W !OWPromptArrowTimer                 ;;F5C9|F5D1+F5D1/F5D1\F5D1;
                      LDA.W !OWPromptArrowTimer                 ;;F5CC|F5D4+F5D4/F5D4\F5D4;
                      AND.B #$18                                ;;F5CF|F5D7+F5D7/F5D7\F5D7;
                      BEQ +                                     ;;F5D1|F5D9+F5D9/F5D9\F5D9;
                      LDA.W !OWPromptArrowDir                   ;;F5D3|F5DB+F5DB/F5DB\F5DB;
                      ASL A                                     ;;F5D6|F5DE+F5DE/F5DE\F5DE;
                      TAY                                       ;;F5D7|F5DF+F5DF/F5DF\F5DF;
                      REP #$20                                  ;;F5D8|F5E0+F5E0/F5E0\F5E0; Accum (16 bit) 
                      LDA.W DATA_04F503,Y                       ;;F5DA|F5E2+F5E2/F5E2\F5E2;
                      STA.L !DynamicStripeImage+$34,X           ;;F5DD|F5E5+F5E5/F5E5\F5E5;
                      LDA.W DATA_04F507,Y                       ;;F5E1|F5E9+F5E9/F5E9\F5E9;
                      STA.L !DynamicStripeImage+$36,X           ;;F5E4|F5EC+F5EC/F5EC\F5EC;
                      LDA.W DATA_04F50B,Y                       ;;F5E8|F5F0+F5F0/F5F0\F5F0;
                      STA.L !DynamicStripeImage+$3C,X           ;;F5EB|F5F3+F5F3/F5F3\F5F3;
                      LDA.W DATA_04F50F,Y                       ;;F5EF|F5F7+F5F7/F5F7\F5F7;
                      STA.L !DynamicStripeImage+$3E,X           ;;F5F2|F5FA+F5FA/F5FA\F5FA;
                      SEP #$20                                  ;;F5F6|F5FE+F5FE/F5FE\F5FE; Accum (8 bit) 
                    + LDA.W !SavedPlayerLives                   ;;F5F8|F600+F600/F600\F600;
                      JSR CODE_04F60E                           ;;F5FB|F603+F603/F603\F603;
                      TXA                                       ;;F5FE|F606+F606/F606\F606;
                      CLC                                       ;;F5FF|F607+F607/F607\F607;
                      ADC.B #$0A                                ;;F600|F608+F608/F608\F608;
                      TAX                                       ;;F602|F60A+F60A/F60A\F60A;
                      LDA.W !SavedPlayerLives+1                 ;;F603|F60B+F60B/F60B\F60B;
CODE_04F60E:          INC A                                     ;;F606|F60E+F60E/F60E\F60E;
                      PHX                                       ;;F607|F60F+F60F/F60F\F60F;
                      JSL CODE_00974C                           ;;F608|F610+F610/F610\F610;
                      TXY                                       ;;F60C|F614+F614/F614\F614;
                      BNE +                                     ;;F60D|F615+F615/F615\F615;
                      LDX.B #$FC                                ;;F60F|F617+F617/F617\F617;
                    + TXY                                       ;;F611|F619+F619/F619\F619;
                      PLX                                       ;;F612|F61A+F61A/F61A\F61A;
                      STA.L !DynamicStripeImage+$24,X           ;;F613|F61B+F61B/F61B\F61B;
                      TYA                                       ;;F617|F61F+F61F/F61F\F61F;
                      STA.L !DynamicStripeImage+$22,X           ;;F618|F620+F620/F620\F620;
                      RTS                                       ;;F61C|F624+F624/F624\F624; Return 
                                                                ;;                        ;
                                                                ;;                        ;
OverworldSprites:     db $00 : dw $0100,$00E0                   ;;F61D|F625+F625/F625\F625;
                      db $00 : dw $0100,$0060                   ;;F622|F62A+F62A/F62A\F62A;
                      db $06 : dw $0170,$0020                   ;;F627|F62F+F62F/F62F\F62F;
                      db $07 : dw $0038,$018A                   ;;F62C|F634+F634/F634\F634;
                      db $00 : dw $0058,$007A                   ;;F631|F639+F639/F639\F639;
                      db $08 : dw $0188,$0018                   ;;F636|F63E+F63E/F63E\F63E;
                      db $09 : dw $0148,$FFFC                   ;;F63B|F643+F643/F643\F643;
                      db $00 : dw $0080,$0100                   ;;F640|F648+F648/F648\F648;
                      db $00 : dw $0050,$0140                   ;;F645|F64D+F64D/F64D\F64D;
                      db $03 : dw $0000,$0000                   ;;F64A|F652+F652/F652\F652;
                      db $0A : dw $0040,$0098                   ;;F64F|F657+F657/F657\F657;
                      db $0A : dw $0060,$00F8                   ;;F654|F65C+F65C/F65C\F65C;
                      db $0A : dw $0140,$0158                   ;;F659|F661+F661/F661\F661;
                                                                ;;                        ;
ExtraOWGhostXPos:     dw $0030,$0100,$FF10                      ;;F65E|F666+F666/F666\F666;
ExtraOWGhostYPos:     dw $0020,$FF70,$0010                      ;;F664|F66C+F66C/F66C\F66C;
                                                                ;;                        ;
DATA_04F672:          db $01,$40,$80                            ;;F66A|F672+F672/F672\F672;
                                                                ;;                        ;
CODE_04F675:          PHB                                       ;;F66D|F675+F675/F675\F675;
                      PHK                                       ;;F66E|F676+F676/F676\F676;
                      PLB                                       ;;F66F|F677+F677/F677\F677;
                      LDX.B #$0C                                ;;F670|F678+F678/F678\F678;
                      LDY.B #$4B                                ;;F672|F67A+F67A/F67A\F67A;
CODE_04F67C:          LDA.W OverworldSprites-$0F,Y              ;;F674|F67C+F67C/F67C\F67C;
                      STA.W !OWSpriteNumber+3,X                 ;;F677|F67F+F67F/F67F\F67F;
                      CMP.B #$01                                ;;F67A|F682+F682/F682\F682;
                      BEQ ADDR_04F68A                           ;;F67C|F684+F684/F684\F684;
                      CMP.B #$02                                ;;F67E|F686+F686/F686\F686;
                      BNE +                                     ;;F680|F688+F688/F688\F688;
ADDR_04F68A:          LDA.B #$40                                ;;F682|F68A+F68A/F68A\F68A;
                      STA.W !OWSpriteZPosLow+3,X                ;;F684|F68C+F68C/F68C\F68C;
                    + LDA.W OverworldSprites-$0E,Y              ;;F687|F68F+F68F/F68F\F68F;
                      STA.W !OWSpriteXPosLow+3,X                ;;F68A|F692+F692/F692\F692;
                      LDA.W OverworldSprites-$0D,Y              ;;F68D|F695+F695/F695\F695;
                      STA.W !OWSpriteXPosHigh+3,X               ;;F690|F698+F698/F698\F698;
                      LDA.W OverworldSprites-$0C,Y              ;;F693|F69B+F69B/F69B\F69B;
                      STA.W !OWSpriteYPosLow+3,X                ;;F696|F69E+F69E/F69E\F69E;
                      LDA.W OverworldSprites-$0B,Y              ;;F699|F6A1+F6A1/F6A1\F6A1;
                      STA.W !OWSpriteYPosHigh+3,X               ;;F69C|F6A4+F6A4/F6A4\F6A4;
                      TYA                                       ;;F69F|F6A7+F6A7/F6A7\F6A7;
                      SEC                                       ;;F6A0|F6A8+F6A8/F6A8\F6A8;
                      SBC.B #$05                                ;;F6A1|F6A9+F6A9/F6A9\F6A9;
                      TAY                                       ;;F6A3|F6AB+F6AB/F6AB\F6AB;
                      DEX                                       ;;F6A4|F6AC+F6AC/F6AC\F6AC;
                      BPL CODE_04F67C                           ;;F6A5|F6AD+F6AD/F6AD\F6AD;
                      LDX.B #$0D                                ;;F6A7|F6AF+F6AF/F6AF\F6AF;
CODE_04F6B1:          STZ.W !OWSpriteMisc0E25,X                 ;;F6A9|F6B1+F6B1/F6B1\F6B1;
                      LDA.W DATA_04FD22                         ;;F6AC|F6B4+F6B4/F6B4\F6B4;
                      DEC A                                     ;;F6AF|F6B7+F6B7/F6B7\F6B7;
                      STA.W !OWSpriteZSpeed,X                   ;;F6B0|F6B8+F6B8/F6B8\F6B8;
                      LDA.W DATA_04F672-$0D,X                   ;;F6B3|F6BB+F6BB/F6BB\F6BB;
                    - PHA                                       ;;F6B6|F6BE+F6BE/F6BE\F6BE;
                      STX.W !SaveFileDelete                     ;;F6B7|F6BF+F6BF/F6BF\F6BF;
                      JSR CODE_04F853                           ;;F6BA|F6C2+F6C2/F6C2\F6C2;
                      PLA                                       ;;F6BD|F6C5+F6C5/F6C5\F6C5;
                      DEC A                                     ;;F6BE|F6C6+F6C6/F6C6\F6C6;
                      BNE -                                     ;;F6BF|F6C7+F6C7/F6C7\F6C7;
                      INX                                       ;;F6C1|F6C9+F6C9/F6C9\F6C9;
                      CPX.B #$10                                ;;F6C2|F6CA+F6CA/F6CA\F6CA;
                      BCC CODE_04F6B1                           ;;F6C4|F6CC+F6CC/F6CC\F6CC;
                      PLB                                       ;;F6C6|F6CE+F6CE/F6CE\F6CE;
                      RTL                                       ;;F6C7|F6CF+F6CF/F6CF\F6CF; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04F6D0:          db $70,$7F,$78,$7F,$70,$7F,$78,$7F        ;;F6C8|F6D0+F6D0/F6D0\F6D0;
DATA_04F6D8:          db $F0,$FF,$20,$00,$C0,$00,$F0,$FF        ;;F6D0|F6D8+F6D8/F6D8\F6D8;
                      db $F0,$FF,$80,$00,$F0,$FF,$00,$00        ;;F6D8|F6E0+F6E0/F6E0\F6E0;
DATA_04F6E8:          db $70,$00,$60,$01,$58,$01,$B0,$00        ;;F6E0|F6E8+F6E8/F6E8\F6E8;
                      db $60,$01,$60,$01,$70,$00,$60,$01        ;;F6E8|F6F0+F6F0/F6F0\F6F0;
DATA_04F6F8:          db $20,$58,$43,$CF,$18,$34,$A2,$5E        ;;F6F0|F6F8+F6F8/F6F8\F6F8;
DATA_04F700:          db $07,$05,$06,$07,$04,$06,$07,$05        ;;F6F8|F700+F700/F700\F700;
                                                                ;;                        ;
CODE_04F708:          LDA.B #$F7                                ;;F700|F708+F708/F708\F708;
                      JSR CODE_04F882                           ;;F702|F70A+F70A/F70A\F70A;
                      BNE CODE_04F76E                           ;;F705|F70D+F70D/F70D\F70D;
                      LDY.W !LightningFlashIndex                ;;F707|F70F+F70F/F70F\F70F;
                      BNE CODE_04F73B                           ;;F70A|F712+F712/F712\F712;
                      LDA.B !TrueFrame                          ;;F70C|F714+F714/F714\F714;
                      LSR A                                     ;;F70E|F716+F716/F716\F716;
                      BCC CODE_04F76E                           ;;F70F|F717+F717/F717\F717;
                      DEC.W !LightningWaitTimer                 ;;F711|F719+F719/F719\F719;
                      BNE CODE_04F76E                           ;;F714|F71C+F71C/F71C\F71C;
                      TAY                                       ;;F716|F71E+F71E/F71E\F71E;
                      LDA.W CODE_04F708,Y                       ;;F717|F71F+F71F/F71F\F71F;
                      AND.B #$07                                ;;F71A|F722+F722/F722\F722;
                      TAX                                       ;;F71C|F724+F724/F724\F724;
                      LDA.W DATA_04F6F8,X                       ;;F71D|F725+F725/F725\F725;
                      STA.W !LightningWaitTimer                 ;;F720|F728+F728/F728\F728;
                      LDY.W DATA_04F700,X                       ;;F723|F72B+F72B/F72B\F72B;
                      STY.W !LightningFlashIndex                ;;F726|F72E+F72E/F72E\F72E;
                      LDA.B #$08                                ;;F729|F731+F731/F731\F731;
                      STA.W !LightningTimer                     ;;F72B|F733+F733/F733\F733;
                      LDA.B #!SFX_THUNDER                       ;;F72E|F736+F736/F736\F736;
                      STA.W !SPCIO3                             ;;F730|F738+F738/F738\F738; / Play sound effect 
CODE_04F73B:          DEC.W !LightningTimer                     ;;F733|F73B+F73B/F73B\F73B;
                      BPL +                                     ;;F736|F73E+F73E/F73E\F73E;
                      DEC.W !LightningFlashIndex                ;;F738|F740+F740/F740\F740;
                      LDA.B #$04                                ;;F73B|F743+F743/F743\F743;
                      STA.W !LightningTimer                     ;;F73D|F745+F745/F745\F745;
                    + TYA                                       ;;F740|F748+F748/F748\F748;
                      ASL A                                     ;;F741|F749+F749/F749\F749;
                      TAY                                       ;;F742|F74A+F74A/F74A\F74A;
                      LDX.W !DynPaletteIndex                    ;;F743|F74B+F74B/F74B\F74B;
                      LDA.B #$02                                ;;F746|F74E+F74E/F74E\F74E;
                      STA.W !DynPaletteTable,X                  ;;F748|F750+F750/F750\F750;
                      LDA.B #$47                                ;;F74B|F753+F753/F753\F753;
                      STA.W !DynPaletteTable+1,X                ;;F74D|F755+F755/F755\F755;
                      LDA.W !MainPalette+$50,Y                  ;;F750|F758+F758/F758\F758;
                      STA.W !DynPaletteTable+2,X                ;;F753|F75B+F75B/F75B\F75B;
                      LDA.W !MainPalette+$51,Y                  ;;F756|F75E+F75E/F75E\F75E;
                      STA.W !DynPaletteTable+3,X                ;;F759|F761+F761/F761\F761;
                      STZ.W !DynPaletteTable+4,X                ;;F75C|F764+F764/F764\F764;
                      TXA                                       ;;F75F|F767+F767/F767\F767;
                      CLC                                       ;;F760|F768+F768/F768\F768;
                      ADC.B #$04                                ;;F761|F769+F769/F769\F769;
                      STA.W !DynPaletteIndex                    ;;F763|F76B+F76B/F76B\F76B;
CODE_04F76E:          LDX.B #$02                                ;;F766|F76E+F76E/F76E\F76E;
CODE_04F770:          LDA.W !OWSpriteNumber,X                   ;;F768|F770+F770/F770\F770;
                      BNE +                                     ;;F76B|F773+F773/F773\F773;
                      LDA.B #$05                                ;;F76D|F775+F775/F775\F775;
                      STA.W !OWSpriteNumber,X                   ;;F76F|F777+F777/F777\F777;
                      JSR CODE_04FE5B                           ;;F772|F77A+F77A/F77A\F77A;
                      AND.B #$07                                ;;F775|F77D+F77D/F77D\F77D;
                      TAY                                       ;;F777|F77F+F77F/F77F\F77F;
                      LDA.W DATA_04F6D0,Y                       ;;F778|F780+F780/F780\F780;
                      STA.W !OWSpriteZPosLow,X                  ;;F77B|F783+F783/F783\F783;
                      TYA                                       ;;F77E|F786+F786/F786\F786;
                      ASL A                                     ;;F77F|F787+F787/F787\F787;
                      TAY                                       ;;F780|F788+F788/F788\F788;
                      REP #$20                                  ;;F781|F789+F789/F789\F789; Accum (16 bit) 
                      LDA.B !Layer1XPos                         ;;F783|F78B+F78B/F78B\F78B;
                      CLC                                       ;;F785|F78D+F78D/F78D\F78D;
                      ADC.W DATA_04F6D8,Y                       ;;F786|F78E+F78E/F78E\F78E;
                      SEP #$20                                  ;;F789|F791+F791/F791\F791; Accum (8 bit) 
                      STA.W !OWSpriteXPosLow,X                  ;;F78B|F793+F793/F793\F793;
                      XBA                                       ;;F78E|F796+F796/F796\F796;
                      STA.W !OWSpriteXPosHigh,X                 ;;F78F|F797+F797/F797\F797;
                      REP #$20                                  ;;F792|F79A+F79A/F79A\F79A; Accum (16 bit) 
                      LDA.B !Layer1YPos                         ;;F794|F79C+F79C/F79C\F79C;
                      CLC                                       ;;F796|F79E+F79E/F79E\F79E;
                      ADC.W DATA_04F6E8,Y                       ;;F797|F79F+F79F/F79F\F79F;
                      SEP #$20                                  ;;F79A|F7A2+F7A2/F7A2\F7A2; Accum (8 bit) 
                      STA.W !OWSpriteYPosLow,X                  ;;F79C|F7A4+F7A4/F7A4\F7A4;
                      XBA                                       ;;F79F|F7A7+F7A7/F7A7\F7A7;
                      STA.W !OWSpriteYPosHigh,X                 ;;F7A0|F7A8+F7A8/F7A8\F7A8;
                    + DEX                                       ;;F7A3|F7AB+F7AB/F7AB\F7AB;
                      BPL CODE_04F770                           ;;F7A4|F7AC+F7AC/F7AC\F7AC;
                      LDX.B #$04                                ;;F7A6|F7AE+F7AE/F7AE\F7AE;
                    - TXA                                       ;;F7A8|F7B0+F7B0/F7B0\F7B0;
                      STA.W !OWCloudYSpeed,X                    ;;F7A9|F7B1+F7B1/F7B1\F7B1;
                      DEX                                       ;;F7AC|F7B4+F7B4/F7B4\F7B4;
                      BPL -                                     ;;F7AD|F7B5+F7B5/F7B5\F7B5;
                      LDX.B #$04                                ;;F7AF|F7B7+F7B7/F7B7\F7B7;
CODE_04F7B9:          STX.B !_0                                 ;;F7B1|F7B9+F7B9/F7B9\F7B9;
CODE_04F7BB:          STX.B !_1                                 ;;F7B3|F7BB+F7BB/F7BB\F7BB;
                      LDX.B !_0                                 ;;F7B5|F7BD+F7BD/F7BD\F7BD;
                      LDY.W !OWCloudYSpeed,X                    ;;F7B7|F7BF+F7BF/F7BF\F7BF;
                      LDA.W !OWSpriteYPosLow,Y                  ;;F7BA|F7C2+F7C2/F7C2\F7C2;
                      STA.B !_2                                 ;;F7BD|F7C5+F7C5/F7C5\F7C5;
                      LDA.W !OWSpriteYPosHigh,Y                 ;;F7BF|F7C7+F7C7/F7C7\F7C7;
                      STA.B !_3                                 ;;F7C2|F7CA+F7CA/F7CA\F7CA;
                      LDX.B !_1                                 ;;F7C4|F7CC+F7CC/F7CC\F7CC;
                      LDY.W !OWCloudOAMIndex,X                  ;;F7C6|F7CE+F7CE/F7CE\F7CE;
                      LDA.W !OWSpriteYPosHigh,Y                 ;;F7C9|F7D1+F7D1/F7D1\F7D1;
                      XBA                                       ;;F7CC|F7D4+F7D4/F7D4\F7D4;
                      LDA.W !OWSpriteYPosLow,Y                  ;;F7CD|F7D5+F7D5/F7D5\F7D5;
                      REP #$20                                  ;;F7D0|F7D8+F7D8/F7D8\F7D8; Accum (16 bit) 
                      CMP.B !_2                                 ;;F7D2|F7DA+F7DA/F7DA\F7DA;
                      SEP #$20                                  ;;F7D4|F7DC+F7DC/F7DC\F7DC; Accum (8 bit) 
                      BPL +                                     ;;F7D6|F7DE+F7DE/F7DE\F7DE;
                      PHY                                       ;;F7D8|F7E0+F7E0/F7E0\F7E0;
                      LDY.B !_0                                 ;;F7D9|F7E1+F7E1/F7E1\F7E1;
                      LDA.W !OWCloudYSpeed,Y                    ;;F7DB|F7E3+F7E3/F7E3\F7E3;
                      STA.W !OWCloudOAMIndex,X                  ;;F7DE|F7E6+F7E6/F7E6\F7E6;
                      PLA                                       ;;F7E1|F7E9+F7E9/F7E9\F7E9;
                      STA.W !OWCloudYSpeed,Y                    ;;F7E2|F7EA+F7EA/F7EA\F7EA;
                    + DEX                                       ;;F7E5|F7ED+F7ED/F7ED\F7ED;
                      BNE CODE_04F7BB                           ;;F7E6|F7EE+F7EE/F7EE\F7EE;
                      LDX.B !_0                                 ;;F7E8|F7F0+F7F0/F7F0\F7F0;
                      DEX                                       ;;F7EA|F7F2+F7F2/F7F2\F7F2;
                      BNE CODE_04F7B9                           ;;F7EB|F7F3+F7F3/F7F3\F7F3;
                      LDA.B #$30                                ;;F7ED|F7F5+F7F5/F7F5\F7F5;
                      STA.W !OWCloudOAMIndex                    ;;F7EF|F7F7+F7F7/F7F7\F7F7;
                      STZ.W !EnterLevelAuto                     ;;F7F2|F7FA+F7FA/F7FA\F7FA;
                      LDX.B #$0F                                ;;F7F5|F7FD+F7FD/F7FD\F7FD;
                      LDY.B #$2D                                ;;F7F7|F7FF+F7FF/F7FF\F7FF;
CODE_04F801:          CPX.B #$0D                                ;;F7F9|F801+F801/F801\F801;
                      BCS +                                     ;;F7FB|F803+F803/F803\F803;
                      LDA.W !OWSpriteMisc0E25,X                 ;;F7FD|F805+F805/F805\F805;
                      BEQ +                                     ;;F800|F808+F808/F808\F808;
                      DEC.W !OWSpriteMisc0E25,X                 ;;F802|F80A+F80A/F80A\F80A;
                    + CPX.B #$05                                ;;F805|F80D+F80D/F80D\F80D;
                      BCC CODE_04F819                           ;;F807|F80F+F80F/F80F\F80F;
                      STX.W !SaveFileDelete                     ;;F809|F811+F811/F811\F811;
                      JSR CODE_04F853                           ;;F80C|F814+F814/F814\F814;
                      BRA +                                     ;;F80F|F817+F817/F817\F817;
                                                                ;;                        ;
CODE_04F819:          PHX                                       ;;F811|F819+F819/F819\F819;
                      LDA.W !OWCloudYSpeed,X                    ;;F812|F81A+F81A/F81A\F81A;
                      TAX                                       ;;F815|F81D+F81D/F81D\F81D;
                      STX.W !SaveFileDelete                     ;;F816|F81E+F81E/F81E\F81E;
                      JSR CODE_04F853                           ;;F819|F821+F821/F821\F821;
                      PLX                                       ;;F81C|F824+F824/F824\F824;
                    + DEX                                       ;;F81D|F825+F825/F825\F825;
                      BPL CODE_04F801                           ;;F81E|F826+F826/F826\F826;
Return04F828:         RTS                                       ;;F820|F828+F828/F828\F828; Return 
                                                                ;;                        ;
                                                                ;;                        ;
                      db $7F,$21,$7F,$7F,$7F,$77,$3F,$F7        ;;F821|F829+F829/F829\F829;
                      db $F7,$00                                ;;F829|F831+F831/F831\F831;
                                                                ;;                        ;
DATA_04F833:          db $00,$52,$31,$19,$45,$2A,$03,$8B        ;;F82B|F833+F833/F833\F833;
                      db $94,$3C,$78,$0D,$36,$5E,$87,$1F        ;;F833|F83B+F83B/F83B\F83B;
DATA_04F843:          db $F4,$F4,$F4,$F4,$F4,$9C,$3C,$48        ;;F83B|F843+F843/F843\F843;
                      db $C8,$CC,$A0,$A4,$D8,$DC,$E0,$E4        ;;F843|F84B+F84B/F84B\F84B;
                                                                ;;                        ;
CODE_04F853:          JSR CODE_04F87C                           ;;F84B|F853+F853/F853\F853;
                      BNE Return04F828                          ;;F84E|F856+F856/F856\F856;
                      LDA.W !OWSpriteNumber,X                   ;;F850|F858+F858/F858\F858;
                      JSL ExecutePtr                            ;;F853|F85B+F85B/F85B\F85B;
                                                                ;;                        ;
                      dw Return04F828                           ;;F857|F85F+F85F/F85F\F85F;
                      dw ADDR_04F8CC                            ;;F859|F861+F861/F861\F861;
                      dw ADDR_04F9B8                            ;;F85B|F863+F863/F863\F863;
                      dw CODE_04FA3E                            ;;F85D|F865+F865/F865\F865;
                      dw ADDR_04FAF1                            ;;F85F|F867+F867/F867\F867;
                      dw CODE_04FB37                            ;;F861|F869+F869/F869\F869;
                      dw CODE_04FB98                            ;;F863|F86B+F86B/F86B\F86B;
                      dw CODE_04FC46                            ;;F865|F86D+F86D/F86D\F86D;
                      dw CODE_04FCE1                            ;;F867|F86F+F86F/F86F\F86F;
                      dw CODE_04FD24                            ;;F869|F871+F871/F871\F871;
                      dw CODE_04FD70                            ;;F86B|F873+F873/F873\F873;
                                                                ;;                        ;
DATA_04F875:          db $80,$40,$20,$10,$08,$04,$02            ;;F86D|F875+F875/F875\F875;
                                                                ;;                        ;
CODE_04F87C:          LDY.W !OWSpriteNumber,X                   ;;F874|F87C+F87C/F87C\F87C;
                      LDA.W Return04F828,Y                      ;;F877|F87F+F87F/F87F\F87F;
CODE_04F882:          STA.B !_0                                 ;;F87A|F882+F882/F882\F882;
                      LDY.W !OverworldProcess                   ;;F87C|F884+F884/F884\F884;
                      CPY.B #$0A                                ;;F87F|F887+F887/F887\F887;
                      BNE CODE_04F892                           ;;F881|F889+F889/F889\F889;
                      LDY.W !OWSubmapSwapProcess                ;;F883|F88B+F88B/F88B\F88B;
                      CPY.B #$01                                ;;F886|F88E+F88E/F88E\F88E;
                      BNE CODE_04F8A3                           ;;F888|F890+F890/F890\F890;
CODE_04F892:          LDA.W !PlayerTurnOW                       ;;F88A|F892+F892/F892\F892;
                      LSR A                                     ;;F88D|F895+F895/F895\F895;
                      LSR A                                     ;;F88E|F896+F896/F896\F896;
                      TAY                                       ;;F88F|F897+F897/F897\F897;
                      LDA.W !OWPlayerSubmap,Y                   ;;F890|F898+F898/F898\F898;
                      TAY                                       ;;F893|F89B+F89B/F89B\F89B;
                      LDA.W DATA_04F875,Y                       ;;F894|F89C+F89C/F89C\F89C;
                      AND.B !_0                                 ;;F897|F89F+F89F/F89F\F89F;
                      BEQ +                                     ;;F899|F8A1+F8A1/F8A1\F8A1;
CODE_04F8A3:          LDA.B #$01                                ;;F89B|F8A3+F8A3/F8A3\F8A3;
                    + RTS                                       ;;F89D|F8A5+F8A5/F8A5\F8A5; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04F8A6:          db $01,$01,$03,$01,$01,$01,$01,$02        ;;F89E|F8A6+F8A6/F8A6\F8A6;
DATA_04F8AE:          db $0C,$0C,$12,$12,$12,$12,$0C,$0C        ;;F8A6|F8AE+F8AE/F8AE\F8AE;
DATA_04F8B6:          db $10,$00,$08,$00,$20,$00,$20,$00        ;;F8AE|F8B6+F8B6/F8B6\F8B6;
DATA_04F8BE:          db $10,$00,$30,$00,$08,$00,$10,$00        ;;F8B6|F8BE+F8BE/F8BE\F8BE;
DATA_04F8C6:          db $01,$FF                                ;;F8BE|F8C6+F8C6/F8C6\F8C6;
                                                                ;;                        ;
DATA_04F8C8:          db $10,$F0                                ;;F8C0|F8C8+F8C8/F8C8\F8C8;
                                                                ;;                        ;
DATA_04F8CA:          db $10,$F0                                ;;F8C2|F8CA+F8CA/F8CA\F8CA;
                                                                ;;                        ;
ADDR_04F8CC:          JSR CODE_04FE90                           ;;F8C4|F8CC+F8CC/F8CC\F8CC;
                      CLC                                       ;;F8C7|F8CF+F8CF/F8CF\F8CF;
                      JSR ADDR_04FE00                           ;;F8C8|F8D0+F8D0/F8D0\F8D0;
                      JSR CODE_04FE62                           ;;F8CB|F8D3+F8D3/F8D3\F8D3;
                      REP #$20                                  ;;F8CE|F8D6+F8D6/F8D6\F8D6; Accum (16 bit) 
                      LDA.B !_2                                 ;;F8D0|F8D8+F8D8/F8D8\F8D8;
                      STA.B !_4                                 ;;F8D2|F8DA+F8DA/F8DA\F8DA;
                      SEP #$20                                  ;;F8D4|F8DC+F8DC/F8DC\F8DC; Accum (8 bit) 
                      JSR CODE_04FE5B                           ;;F8D6|F8DE+F8DE/F8DE\F8DE;
                      LDX.B #$06                                ;;F8D9|F8E1+F8E1/F8E1\F8E1;
                      AND.B #$10                                ;;F8DB|F8E3+F8E3/F8E3\F8E3;
                      BEQ ADDR_04F8E8                           ;;F8DD|F8E5+F8E5/F8E5\F8E5;
                      INX                                       ;;F8DF|F8E7+F8E7/F8E7\F8E7;
ADDR_04F8E8:          STX.B !_6                                 ;;F8E0|F8E8+F8E8/F8E8\F8E8;
                      LDA.B !_0                                 ;;F8E2|F8EA+F8EA/F8EA\F8EA;
                      CLC                                       ;;F8E4|F8EC+F8EC/F8EC\F8EC;
                      ADC.W DATA_04F8A6,X                       ;;F8E5|F8ED+F8ED/F8ED\F8ED;
                      STA.B !_0                                 ;;F8E8|F8F0+F8F0/F8F0\F8F0;
                      BCC +                                     ;;F8EA|F8F2+F8F2/F8F2\F8F2;
                      INC.B !_1                                 ;;F8EC|F8F4+F8F4/F8F4\F8F4;
                    + LDA.B !_4                                 ;;F8EE|F8F6+F8F6/F8F6\F8F6;
                      CLC                                       ;;F8F0|F8F8+F8F8/F8F8\F8F8;
                      ADC.W DATA_04F8AE,X                       ;;F8F1|F8F9+F8F9/F8F9\F8F9;
                      STA.B !_2                                 ;;F8F4|F8FC+F8FC/F8FC\F8FC;
                      LDA.B !_5                                 ;;F8F6|F8FE+F8FE/F8FE\F8FE;
                      ADC.B #$00                                ;;F8F8|F900+F900/F900\F900;
                      STA.B !_3                                 ;;F8FA|F902+F902/F902\F902;
                      LDA.B #$32                                ;;F8FC|F904+F904/F904\F904;
                      XBA                                       ;;F8FE|F906+F906/F906\F906;
                      LDA.B #$28                                ;;F8FF|F907+F907/F907\F907;
                      JSR CODE_04FB7B                           ;;F901|F909+F909/F909\F909;
                      LDX.B !_6                                 ;;F904|F90C+F90C/F90C\F90C;
                      DEX                                       ;;F906|F90E+F90E/F90E\F90E;
                      DEX                                       ;;F907|F90F+F90F/F90F\F90F;
                      BPL ADDR_04F8E8                           ;;F908|F910+F910/F910\F910;
                      LDX.W !SaveFileDelete                     ;;F90A|F912+F912/F912\F912;
                      JSR CODE_04FE62                           ;;F90D|F915+F915/F915\F915;
                      LDA.B #$32                                ;;F910|F918+F918/F918\F918;
                      XBA                                       ;;F912|F91A+F91A/F91A\F91A;
                      LDA.B #$26                                ;;F913|F91B+F91B/F91B\F91B;
                      JSR CODE_04FB7A                           ;;F915|F91D+F91D/F91D\F91D;
                      LDA.W !OWSpriteMisc0E15,X                 ;;F918|F920+F920/F920\F920;
                      BEQ +                                     ;;F91B|F923+F923/F923\F923;
                      JMP ADDR_04FF2E                           ;;F91D|F925+F925/F925\F925;
                                                                ;;                        ;
                    + LDA.W !OWSpriteMisc0E05,X                 ;;F920|F928+F928/F928\F928;
                      AND.B #$01                                ;;F923|F92B+F92B/F92B\F92B;
                      TAY                                       ;;F925|F92D+F92D/F92D\F92D;
                      LDA.W !OWSpriteZSpeed,X                   ;;F926|F92E+F92E/F92E\F92E;
                      CLC                                       ;;F929|F931+F931/F931\F931;
                      ADC.W DATA_04F8C6,Y                       ;;F92A|F932+F932/F932\F932;
                      STA.W !OWSpriteZSpeed,X                   ;;F92D|F935+F935/F935\F935;
                      CMP.W DATA_04F8CA,Y                       ;;F930|F938+F938/F938\F938;
                      BNE +                                     ;;F933|F93B+F93B/F93B\F93B;
                      LDA.W !OWSpriteMisc0E05,X                 ;;F935|F93D+F93D/F93D\F93D;
                      EOR.B #$01                                ;;F938|F940+F940/F940\F940;
                      STA.W !OWSpriteMisc0E05,X                 ;;F93A|F942+F942/F942\F942;
                    + JSR ADDR_04FEEF                           ;;F93D|F945+F945/F945\F945;
                      LDY.W !OWSpriteMisc0DF5,X                 ;;F940|F948+F948/F948\F948; Accum (16 bit) 
                      LDA.W !OWSpriteMisc0E05-1,X               ;;F943|F94B+F94B/F94B\F94B;
                      ASL A                                     ;;F946|F94E+F94E/F94E\F94E;
                      EOR.B !_0                                 ;;F947|F94F+F94F/F94F\F94F;
                      BPL ADDR_04F95D                           ;;F949|F951+F951/F951\F951;
                      LDA.B !_6                                 ;;F94B|F953+F953/F953\F953;
                      CMP.W DATA_04F8B6,Y                       ;;F94D|F955+F955/F955\F955;
                      LDA.W #$0040                              ;;F950|F958+F958/F958\F958;
                      BCS +                                     ;;F953|F95B+F95B/F95B\F95B;
ADDR_04F95D:          LDA.W !OWSpriteMisc0E05-1,X               ;;F955|F95D+F95D/F95D\F95D;
                      EOR.B !_2                                 ;;F958|F960+F960/F960\F960;
                      ASL A                                     ;;F95A|F962+F962/F962\F962;
                      BCC +                                     ;;F95B|F963+F963/F963\F963;
                      LDA.B !_8                                 ;;F95D|F965+F965/F965\F965;
                      CMP.W DATA_04F8BE,Y                       ;;F95F|F967+F967/F967\F967;
                      LDA.W #$0080                              ;;F962|F96A+F96A/F96A\F96A;
                    + SEP #$20                                  ;;F965|F96D+F96D/F96D\F96D; Accum (8 bit) 
                      BCC +                                     ;;F967|F96F+F96F/F96F\F96F;
                      EOR.W !OWSpriteMisc0E05,X                 ;;F969|F971+F971/F971\F971;
                      STA.W !OWSpriteMisc0E05,X                 ;;F96C|F974+F974/F974\F974;
                      JSR CODE_04FE5B                           ;;F96F|F977+F977/F977\F977;
                      AND.B #$06                                ;;F972|F97A+F97A/F97A\F97A;
                      STA.W !OWSpriteMisc0DF5,X                 ;;F974|F97C+F97C/F97C\F97C;
                    + TXA                                       ;;F977|F97F+F97F/F97F\F97F;
                      CLC                                       ;;F978|F980+F980/F980\F980;
                      ADC.B #$10                                ;;F979|F981+F981/F981\F981;
                      TAX                                       ;;F97B|F983+F983/F983\F983;
                      LDA.W !OWSpriteMisc0DF5,X                 ;;F97C|F984+F984/F984\F984;
                      ASL A                                     ;;F97F|F987+F987/F987\F987;
                      JSR ADDR_04F993                           ;;F980|F988+F988/F988\F988;
                      LDX.W !SaveFileDelete                     ;;F983|F98B+F98B/F98B\F98B;
                      LDA.W !OWSpriteMisc0E05,X                 ;;F986|F98E+F98E/F98E\F98E;
                      ASL A                                     ;;F989|F991+F991/F991\F991;
                      ASL A                                     ;;F98A|F992+F992/F992\F992;
ADDR_04F993:          LDY.B #$00                                ;;F98B|F993+F993/F993\F993;
                      BCS +                                     ;;F98D|F995+F995/F995\F995;
                      INY                                       ;;F98F|F997+F997/F997\F997;
                    + LDA.W !OWSpriteXSpeed,X                   ;;F990|F998+F998/F998\F998;
                      CLC                                       ;;F993|F99B+F99B/F99B\F99B;
                      ADC.W DATA_04F8C6,Y                       ;;F994|F99C+F99C/F99C\F99C;
                      CMP.W DATA_04F8C8,Y                       ;;F997|F99F+F99F/F99F\F99F;
                      BEQ +                                     ;;F99A|F9A2+F9A2/F9A2\F9A2;
                      STA.W !OWSpriteXSpeed,X                   ;;F99C|F9A4+F9A4/F9A4\F9A4;
                    + RTS                                       ;;F99F|F9A7+F9A7/F9A7\F9A7; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04F9A8:          db $4E,$4F,$5E,$4F                        ;;F9A0|F9A8+F9A8/F9A8\F9A8;
                                                                ;;                        ;
DATA_04F9AC:          db $08,$07,$04,$07                        ;;F9A4|F9AC+F9AC/F9AC\F9AC;
                                                                ;;                        ;
DATA_04F9B0:          db $00,$01,$04,$01                        ;;F9A8|F9B0+F9B0/F9B0\F9B0;
                                                                ;;                        ;
DATA_04F9B4:          db $01,$07,$09,$07                        ;;F9AC|F9B4+F9B4/F9B4\F9B4;
                                                                ;;                        ;
ADDR_04F9B8:          CLC                                       ;;F9B0|F9B8+F9B8/F9B8\F9B8;
                      JSR ADDR_04FE00                           ;;F9B1|F9B9+F9B9/F9B9\F9B9;
                      JSR ADDR_04FEEF                           ;;F9B4|F9BC+F9BC/F9BC\F9BC;
                      SEP #$20                                  ;;F9B7|F9BF+F9BF/F9BF\F9BF; Accum (8 bit) 
                      LDY.B #$00                                ;;F9B9|F9C1+F9C1/F9C1\F9C1;
                      LDA.B !_1                                 ;;F9BB|F9C3+F9C3/F9C3\F9C3;
                      BMI +                                     ;;F9BD|F9C5+F9C5/F9C5\F9C5;
                      INY                                       ;;F9BF|F9C7+F9C7/F9C7\F9C7;
                    + LDA.W !OWSpriteXSpeed,X                   ;;F9C0|F9C8+F9C8/F9C8\F9C8;
                      CLC                                       ;;F9C3|F9CB+F9CB/F9CB\F9CB;
                      ADC.W DATA_04F8C6,Y                       ;;F9C4|F9CC+F9CC/F9CC\F9CC;
                      CMP.W DATA_04F8C8,Y                       ;;F9C7|F9CF+F9CF/F9CF\F9CF;
                      BEQ +                                     ;;F9CA|F9D2+F9D2/F9D2\F9D2;
                      STA.W !OWSpriteXSpeed,X                   ;;F9CC|F9D4+F9D4/F9D4\F9D4;
                    + LDY.W !PlayerTurnOW                       ;;F9CF|F9D7+F9D7/F9D7\F9D7;
                      LDA.W !OWPlayerYPos,Y                     ;;F9D2|F9DA+F9DA/F9DA\F9DA;
                      STA.W !OWSpriteYPosLow,X                  ;;F9D5|F9DD+F9DD/F9DD\F9DD;
                      LDA.W !OWPlayerYPos+1,Y                   ;;F9D8|F9E0+F9E0/F9E0\F9E0;
                      STA.W !OWSpriteYPosHigh,X                 ;;F9DB|F9E3+F9E3/F9E3\F9E3;
                      JSR CODE_04FE90                           ;;F9DE|F9E6+F9E6/F9E6\F9E6;
                      JSR CODE_04FE62                           ;;F9E1|F9E9+F9E9/F9E9\F9E9;
                      LDA.B #$36                                ;;F9E4|F9EC+F9EC/F9EC\F9EC;
                      LDY.W !OWSpriteXSpeed,X                   ;;F9E6|F9EE+F9EE/F9EE\F9EE;
                      BMI +                                     ;;F9E9|F9F1+F9F1/F9F1\F9F1;
                      ORA.B #$40                                ;;F9EB|F9F3+F9F3/F9F3\F9F3;
                    + PHA                                       ;;F9ED|F9F5+F9F5/F9F5\F9F5;
                      XBA                                       ;;F9EE|F9F6+F9F6/F9F6\F9F6;
                      LDA.B #$4C                                ;;F9EF|F9F7+F9F7/F9F7\F9F7;
                      JSR CODE_04FB7A                           ;;F9F1|F9F9+F9F9/F9F9\F9F9;
                      PLA                                       ;;F9F4|F9FC+F9FC/F9FC\F9FC;
                      XBA                                       ;;F9F5|F9FD+F9FD/F9FD\F9FD;
                      JSR CODE_04FE5B                           ;;F9F6|F9FE+F9FE/F9FE\F9FE;
                      LSR A                                     ;;F9F9|FA01+FA01/FA01\FA01;
                      LSR A                                     ;;F9FA|FA02+FA02/FA02\FA02;
                      LSR A                                     ;;F9FB|FA03+FA03/FA03\FA03;
                      AND.B #$03                                ;;F9FC|FA04+FA04/FA04\FA04;
                      TAY                                       ;;F9FE|FA06+FA06/FA06\FA06;
                      LDA.W DATA_04F9AC,Y                       ;;F9FF|FA07+FA07/FA07\FA07;
                      BIT.W !OWSpriteXSpeed,X                   ;;FA02|FA0A+FA0A/FA0A\FA0A;
                      BMI +                                     ;;FA05|FA0D+FA0D/FA0D\FA0D;
                      LDA.W DATA_04F9B0,Y                       ;;FA07|FA0F+FA0F/FA0F\FA0F;
                    + CLC                                       ;;FA0A|FA12+FA12/FA12\FA12;
                      ADC.B !_0                                 ;;FA0B|FA13+FA13/FA13\FA13;
                      STA.B !_0                                 ;;FA0D|FA15+FA15/FA15\FA15;
                      BCC +                                     ;;FA0F|FA17+FA17/FA17\FA17;
                      INC.B !_1                                 ;;FA11|FA19+FA19/FA19\FA19;
                    + LDA.W DATA_04F9B4,Y                       ;;FA13|FA1B+FA1B/FA1B\FA1B;
                      CLC                                       ;;FA16|FA1E+FA1E/FA1E\FA1E;
                      ADC.B !_2                                 ;;FA17|FA1F+FA1F/FA1F\FA1F;
                      STA.B !_2                                 ;;FA19|FA21+FA21/FA21\FA21;
                      BCC +                                     ;;FA1B|FA23+FA23/FA23\FA23;
                      INC.B !_3                                 ;;FA1D|FA25+FA25/FA25\FA25;
                    + LDA.W DATA_04F9A8,Y                       ;;FA1F|FA27+FA27/FA27\FA27;
                      CLC                                       ;;FA22|FA2A+FA2A/FA2A\FA2A;
                      JMP CODE_04FB7B                           ;;FA23|FA2B+FA2B/FA2B\FA2B;
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04FA2E:          db $70,$50,$B0                            ;;FA26|FA2E+FA2E/FA2E\FA2E;
                                                                ;;                        ;
DATA_04FA31:          db $00,$01,$00                            ;;FA29|FA31+FA31/FA31\FA31;
                                                                ;;                        ;
DATA_04FA34:          db $CF,$8F,$7F                            ;;FA2C|FA34+FA34/FA34\FA34;
                                                                ;;                        ;
DATA_04FA37:          db $00,$00,$01                            ;;FA2F|FA37+FA37/FA37\FA37;
                                                                ;;                        ;
DATA_04FA3A:          db $73,$72,$63,$62                        ;;FA32|FA3A+FA3A/FA3A\FA3A;
                                                                ;;                        ;
CODE_04FA3E:          LDA.W !OWSpriteMisc0DF5,X                 ;;FA36|FA3E+FA3E/FA3E\FA3E;
                      BNE CODE_04FA83                           ;;FA39|FA41+FA41/FA41\FA41;
                      LDA.W !OverworldLayer1Tile                ;;FA3B|FA43+FA43/FA43\FA43;
                      SEC                                       ;;FA3E|FA46+FA46/FA46\FA46;
                      SBC.B #$4E                                ;;FA3F|FA47+FA47/FA47\FA47;
                      CMP.B #$03                                ;;FA41|FA49+FA49/FA49\FA49;
                      BCS Return04FA82                          ;;FA43|FA4B+FA4B/FA4B\FA4B;
                      TAY                                       ;;FA45|FA4D+FA4D/FA4D\FA4D;
                      LDA.W DATA_04FA2E,Y                       ;;FA46|FA4E+FA4E/FA4E\FA4E;
                      STA.W !OWSpriteXPosLow,X                  ;;FA49|FA51+FA51/FA51\FA51;
                      LDA.W DATA_04FA31,Y                       ;;FA4C|FA54+FA54/FA54\FA54;
                      STA.W !OWSpriteXPosHigh,X                 ;;FA4F|FA57+FA57/FA57\FA57;
                      LDA.W DATA_04FA34,Y                       ;;FA52|FA5A+FA5A/FA5A\FA5A;
                      STA.W !OWSpriteYPosLow,X                  ;;FA55|FA5D+FA5D/FA5D\FA5D;
                      LDA.W DATA_04FA37,Y                       ;;FA58|FA60+FA60/FA60\FA60;
                      STA.W !OWSpriteYPosHigh,X                 ;;FA5B|FA63+FA63/FA63\FA63;
                      JSR CODE_04FE5B                           ;;FA5E|FA66+FA66/FA66\FA66;
                      LSR A                                     ;;FA61|FA69+FA69/FA69\FA69;
                      ROR A                                     ;;FA62|FA6A+FA6A/FA6A\FA6A;
                      LSR A                                     ;;FA63|FA6B+FA6B/FA6B\FA6B;
                      AND.B #$40                                ;;FA64|FA6C+FA6C/FA6C\FA6C;
                      ORA.B #$12                                ;;FA66|FA6E+FA6E/FA6E\FA6E;
                      STA.W !OWSpriteMisc0DF5,X                 ;;FA68|FA70+FA70/FA70\FA70;
                      LDA.B #$24                                ;;FA6B|FA73+FA73/FA73\FA73;
                      STA.W !OWSpriteZSpeed,X                   ;;FA6D|FA75+FA75/FA75\FA75;
                      LDA.B #!SFX_SWIM                          ;;FA70|FA78+FA78/FA78\FA78;
                      STA.W !SPCIO0                             ;;FA72|FA7A+FA7A/FA7A\FA7A; / Play sound effect 
CODE_04FA7D:          LDA.B #$0F                                ;;FA75|FA7D+FA7D/FA7D\FA7D;
                      STA.W !OWSpriteMisc0E25,X                 ;;FA77|FA7F+FA7F/FA7F\FA7F;
Return04FA82:         RTS                                       ;;FA7A|FA82+FA82/FA82\FA82; Return 
                                                                ;;                        ;
CODE_04FA83:          DEC.W !OWSpriteZSpeed,X                   ;;FA7B|FA83+FA83/FA83\FA83;
                      LDA.W !OWSpriteZSpeed,X                   ;;FA7E|FA86+FA86/FA86\FA86;
                      CMP.B #$E4                                ;;FA81|FA89+FA89/FA89\FA89;
                      BNE +                                     ;;FA83|FA8B+FA8B/FA8B\FA8B;
                      JSR CODE_04FA7D                           ;;FA85|FA8D+FA8D/FA8D\FA8D;
                    + JSR CODE_04FE90                           ;;FA88|FA90+FA90/FA90\FA90;
                      LDA.W !OWSpriteZPosLow,X                  ;;FA8B|FA93+FA93/FA93\FA93;
                      ORA.W !OWSpriteMisc0E25,X                 ;;FA8E|FA96+FA96/FA96\FA96;
                      BNE +                                     ;;FA91|FA99+FA99/FA99\FA99;
                      STZ.W !OWSpriteMisc0DF5,X                 ;;FA93|FA9B+FA9B/FA9B\FA9B;
                    + JSR CODE_04FE62                           ;;FA96|FA9E+FA9E/FA9E\FA9E;
                      LDA.W !OWSpriteMisc0DF5,X                 ;;FA99|FAA1+FAA1/FAA1\FAA1;
                      LDY.B #$08                                ;;FA9C|FAA4+FAA4/FAA4\FAA4;
                      BIT.W !OWSpriteZSpeed,X                   ;;FA9E|FAA6+FAA6/FAA6\FAA6;
                      BPL +                                     ;;FAA1|FAA9+FAA9/FAA9\FAA9;
                      EOR.B #$C0                                ;;FAA3|FAAB+FAAB/FAAB\FAAB;
                      LDY.B #$10                                ;;FAA5|FAAD+FAAD/FAAD\FAAD;
                    + XBA                                       ;;FAA7|FAAF+FAAF/FAAF\FAAF;
                      TYA                                       ;;FAA8|FAB0+FAB0/FAB0\FAB0;
                      LDY.B #$4A                                ;;FAA9|FAB1+FAB1/FAB1\FAB1;
                      AND.B !TrueFrame                          ;;FAAB|FAB3+FAB3/FAB3\FAB3;
                      BEQ +                                     ;;FAAD|FAB5+FAB5/FAB5\FAB5;
                      LDY.B #$48                                ;;FAAF|FAB7+FAB7/FAB7\FAB7;
                    + TYA                                       ;;FAB1|FAB9+FAB9/FAB9\FAB9;
                      JSR CODE_04FB06                           ;;FAB2|FABA+FABA/FABA\FABA;
                      JSR CODE_04FE4E                           ;;FAB5|FABD+FABD/FABD\FABD;
                      SEC                                       ;;FAB8|FAC0+FAC0/FAC0\FAC0;
                      SBC.B #$08                                ;;FAB9|FAC1+FAC1/FAC1\FAC1;
                      STA.B !_2                                 ;;FABB|FAC3+FAC3/FAC3\FAC3;
                      BCS +                                     ;;FABD|FAC5+FAC5/FAC5\FAC5;
                      DEC.B !_3                                 ;;FABF|FAC7+FAC7/FAC7\FAC7;
                    + LDA.B #$36                                ;;FAC1|FAC9+FAC9/FAC9\FAC9;
                      XBA                                       ;;FAC3|FACB+FACB/FACB\FACB;
                      LDA.W !OWSpriteMisc0E25,X                 ;;FAC4|FACC+FACC/FACC\FACC;
                      BEQ Return04FA82                          ;;FAC7|FACF+FACF/FACF\FACF;
                      LSR A                                     ;;FAC9|FAD1+FAD1/FAD1\FAD1;
                      LSR A                                     ;;FACA|FAD2+FAD2/FAD2\FAD2;
                      PHY                                       ;;FACB|FAD3+FAD3/FAD3\FAD3;
                      TAY                                       ;;FACC|FAD4+FAD4/FAD4\FAD4;
                      LDA.W DATA_04FA3A,Y                       ;;FACD|FAD5+FAD5/FAD5\FAD5;
                      PLY                                       ;;FAD0|FAD8+FAD8/FAD8\FAD8;
                      PHA                                       ;;FAD1|FAD9+FAD9/FAD9\FAD9;
                      JSR CODE_04FAED                           ;;FAD2|FADA+FADA/FADA\FADA;
                      REP #$20                                  ;;FAD5|FADD+FADD/FADD\FADD; Accum (16 bit) 
                      LDA.B !_0                                 ;;FAD7|FADF+FADF/FADF\FADF;
                      CLC                                       ;;FAD9|FAE1+FAE1/FAE1\FAE1;
                      ADC.W #$0008                              ;;FADA|FAE2+FAE2/FAE2\FAE2;
                      STA.B !_0                                 ;;FADD|FAE5+FAE5/FAE5\FAE5;
                      SEP #$20                                  ;;FADF|FAE7+FAE7/FAE7\FAE7; Accum (8 bit) 
                      LDA.B #$76                                ;;FAE1|FAE9+FAE9/FAE9\FAE9;
                      XBA                                       ;;FAE3|FAEB+FAEB/FAEB\FAEB;
                      PLA                                       ;;FAE4|FAEC+FAEC/FAEC\FAEC;
CODE_04FAED:          CLC                                       ;;FAE5|FAED+FAED/FAED\FAED;
                      JMP CODE_04FB0A                           ;;FAE6|FAEE+FAEE/FAEE\FAEE;
                                                                ;;                        ;
ADDR_04FAF1:          JSR ADDR_04FED7                           ;;FAE9|FAF1+FAF1/FAF1\FAF1;
                      JSR CODE_04FE62                           ;;FAEC|FAF4+FAF4/FAF4\FAF4; NOP this and the sprite doesn't appear
                      JSR CODE_04FE5B                           ;;FAEF|FAF7+FAF7/FAF7\FAF7; NOP this and the sprite stops animating.
                      LDY.B #$2A                                ;;FAF2|FAFA+FAFA/FAFA\FAFA;Tile for pirahna plant, #1
                      AND.B #$08                                ;;FAF4|FAFC+FAFC/FAFC\FAFC;
                      BEQ +                                     ;;FAF6|FAFE+FAFE/FAFE\FAFE;
                      LDY.B #$2C                                ;;FAF8|FB00+FB00/FB00\FB00; Tile for pirahna plant, #2, stored in $0242
                    + LDA.B #$32                                ;;FAFA|FB02+FB02/FB02\FB02; YXPPCCCT - 00110010
                      XBA                                       ;;FAFC|FB04+FB04/FB04\FB04;
                      TYA                                       ;;FAFD|FB05+FB05/FB05\FB05;
CODE_04FB06:          SEC                                       ;;FAFE|FB06+FB06/FB06\FB06;
                      LDY.W DATA_04F843,X                       ;;FAFF|FB07+FB07/FB07\FB07;
CODE_04FB0A:          STA.W !OAMTileNo+$40,Y                    ;;FB02|FB0A+FB0A/FB0A\FB0A;Tilemap
                      XBA                                       ;;FB05|FB0D+FB0D/FB0D\FB0D;
                      STA.W !OAMTileAttr+$40,Y                  ;;FB06|FB0E+FB0E/FB0E\FB0E;Property
                      LDA.B !_1                                 ;;FB09|FB11+FB11/FB11\FB11;
                      BNE +                                     ;;FB0B|FB13+FB13/FB13\FB13;
                      LDA.B !_0                                 ;;FB0D|FB15+FB15/FB15\FB15;
                      STA.W !OAMTileXPos+$40,Y                  ;;FB0F|FB17+FB17/FB17\FB17;X Position
                      LDA.B !_3                                 ;;FB12|FB1A+FB1A/FB1A\FB1A;
                      BNE +                                     ;;FB14|FB1C+FB1C/FB1C\FB1C;
                      PHP                                       ;;FB16|FB1E+FB1E/FB1E\FB1E;
                      LDA.B !_2                                 ;;FB17|FB1F+FB1F/FB1F\FB1F;
                      STA.W !OAMTileYPos+$40,Y                  ;;FB19|FB21+FB21/FB21\FB21;Y Position
                      TYA                                       ;;FB1C|FB24+FB24/FB24\FB24;
                      LSR A                                     ;;FB1D|FB25+FB25/FB25\FB25;
                      LSR A                                     ;;FB1E|FB26+FB26/FB26\FB26;
                      PLP                                       ;;FB1F|FB27+FB27/FB27\FB27;
                      PHY                                       ;;FB20|FB28+FB28/FB28\FB28;
                      TAY                                       ;;FB21|FB29+FB29/FB29\FB29;
                      ROL A                                     ;;FB22|FB2A+FB2A/FB2A\FB2A;
                      ASL A                                     ;;FB23|FB2B+FB2B/FB2B\FB2B;
                      AND.B #$03                                ;;FB24|FB2C+FB2C/FB2C\FB2C;
                      STA.W !OAMTileSize+$10,Y                  ;;FB26|FB2E+FB2E/FB2E\FB2E;
                      PLY                                       ;;FB29|FB31+FB31/FB31\FB31;
                      DEY                                       ;;FB2A|FB32+FB32/FB32\FB32;
                      DEY                                       ;;FB2B|FB33+FB33/FB33\FB33;
                      DEY                                       ;;FB2C|FB34+FB34/FB34\FB34;
                      DEY                                       ;;FB2D|FB35+FB35/FB35\FB35;
                    + RTS                                       ;;FB2E|FB36+FB36/FB36\FB36; Return 
                                                                ;;                        ;
CODE_04FB37:          LDA.B #$02                                ;;FB2F|FB37+FB37/FB37\FB37;\Overworld Sprite X Speed
                      STA.W !OWSpriteXSpeed,X                   ;;FB31|FB39+FB39/FB39\FB39;/
                      LDA.B #$FF                                ;;FB34|FB3C+FB3C/FB3C\FB3C;\Overworld Sprite Y Speed
                      STA.W !OWSpriteYSpeed,X                   ;;FB36|FB3E+FB3E/FB3E\FB3E;/
                      JSR CODE_04FE90                           ;;FB39|FB41+FB41/FB41\FB41;Move the overworld cloud
                      JSR CODE_04FE62                           ;;FB3C|FB44+FB44/FB44\FB44;
                      REP #$20                                  ;;FB3F|FB47+FB47/FB47\FB47; Accum (16 bit) 
                      LDA.B !_0                                 ;;FB41|FB49+FB49/FB49\FB49;
                      CLC                                       ;;FB43|FB4B+FB4B/FB4B\FB4B;
                      ADC.W #$0020                              ;;FB44|FB4C+FB4C/FB4C\FB4C;
                      CMP.W #$0140                              ;;FB47|FB4F+FB4F/FB4F\FB4F;
                      BCS +                                     ;;FB4A|FB52+FB52/FB52\FB52;
                      LDA.B !_2                                 ;;FB4C|FB54+FB54/FB54\FB54;
                      CLC                                       ;;FB4E|FB56+FB56/FB56\FB56;
                      ADC.W #$0080                              ;;FB4F|FB57+FB57/FB57\FB57;
                      CMP.W #$01A0                              ;;FB52|FB5A+FB5A/FB5A\FB5A;
                    + SEP #$20                                  ;;FB55|FB5D+FB5D/FB5D\FB5D; Accum (8 bit) 
                      BCC +                                     ;;FB57|FB5F+FB5F/FB5F\FB5F;
                      STZ.W !OWSpriteNumber,X                   ;;FB59|FB61+FB61/FB61\FB61;
                    + LDA.B #$32                                ;;FB5C|FB64+FB64/FB64\FB64;
                      JSR CODE_04FB77                           ;;FB5E|FB66+FB66/FB66\FB66;
                      REP #$20                                  ;;FB61|FB69+FB69/FB69\FB69; Accum (16 bit) 
                      LDA.B !_0                                 ;;FB63|FB6B+FB6B/FB6B\FB6B;
                      CLC                                       ;;FB65|FB6D+FB6D/FB6D\FB6D;
                      ADC.W #$0010                              ;;FB66|FB6E+FB6E/FB6E\FB6E;
                      STA.B !_0                                 ;;FB69|FB71+FB71/FB71\FB71;
                      SEP #$20                                  ;;FB6B|FB73+FB73/FB73\FB73; Accum (8 bit) 
                      LDA.B #$72                                ;;FB6D|FB75+FB75/FB75\FB75;
CODE_04FB77:          XBA                                       ;;FB6F|FB77+FB77/FB77\FB77;
                      LDA.B #$44                                ;;FB70|FB78+FB78/FB78\FB78;
CODE_04FB7A:          SEC                                       ;;FB72|FB7A+FB7A/FB7A\FB7A;
CODE_04FB7B:          LDY.W !OWCloudOAMIndex                    ;;FB73|FB7B+FB7B/FB7B\FB7B;
                      JSR CODE_04FB0A                           ;;FB76|FB7E+FB7E/FB7E\FB7E;
                      STY.W !OWCloudOAMIndex                    ;;FB79|FB81+FB81/FB81\FB81;
Return04FB84:         RTS                                       ;;FB7C|FB84+FB84/FB84\FB84; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04FB85:          db $80,$40,$20                            ;;FB7D|FB85+FB85/FB85\FB85;
                                                                ;;                        ;
DATA_04FB88:          db $30,$10,$C0                            ;;FB80|FB88+FB88/FB88\FB88;
                                                                ;;                        ;
DATA_04FB8B:          db $01,$01,$01                            ;;FB83|FB8B+FB8B/FB8B\FB8B;
                                                                ;;                        ;
DATA_04FB8E:          db $7F,$7F,$8F                            ;;FB86|FB8E+FB8E/FB8E\FB8E;
                                                                ;;                        ;
DATA_04FB91:          db $01,$00                                ;;FB89|FB91+FB91/FB91\FB91;
                                                                ;;                        ;
DATA_04FB93:          db $01,$08                                ;;FB8B|FB93+FB93/FB93\FB93;
                                                                ;;                        ;
DATA_04FB95:          db $02,$0F,$00                            ;;FB8D|FB95+FB95/FB95\FB95;
                                                                ;;                        ;
CODE_04FB98:          LDA.W !OWSpriteMisc0DF5,X                 ;;FB90|FB98+FB98/FB98\FB98;
                      BNE ADDR_04FBD8                           ;;FB93|FB9B+FB9B/FB9B\FB9B;
                      LDA.W !OverworldLayer1Tile                ;;FB95|FB9D+FB9D/FB9D\FB9D;
                      SEC                                       ;;FB98|FBA0+FBA0/FBA0\FBA0;
                      SBC.B #$49                                ;;FB99|FBA1+FBA1/FBA1\FBA1;
                      CMP.B #$03                                ;;FB9B|FBA3+FBA3/FBA3\FBA3;
                      BCS Return04FB84                          ;;FB9D|FBA5+FBA5/FBA5\FBA5;
                      TAY                                       ;;FB9F|FBA7+FBA7/FBA7\FBA7;
                      STA.W !KoopaKidTile                       ;;FBA0|FBA8+FBA8/FBA8\FBA8;
                      LDA.W !KoopaKidActive                     ;;FBA3|FBAB+FBAB/FBAB\FBAB;
                      AND.W DATA_04FB85,Y                       ;;FBA6|FBAE+FBAE/FBAE\FBAE;
                      BNE Return04FB84                          ;;FBA9|FBB1+FBB1/FBB1\FBB1;
                      LDA.W DATA_04FB88,Y                       ;;FBAB|FBB3+FBB3/FBB3\FBB3;
                      STA.W !OWSpriteXPosLow,X                  ;;FBAE|FBB6+FBB6/FBB6\FBB6;
                      LDA.W DATA_04FB8B,Y                       ;;FBB1|FBB9+FBB9/FBB9\FBB9;
                      STA.W !OWSpriteXPosHigh,X                 ;;FBB4|FBBC+FBBC/FBBC\FBBC;
                      LDA.W DATA_04FB8E,Y                       ;;FBB7|FBBF+FBBF/FBBF\FBBF;
                      STA.W !OWSpriteYPosLow,X                  ;;FBBA|FBC2+FBC2/FBC2\FBC2;
                      LDA.W DATA_04FB91,Y                       ;;FBBD|FBC5+FBC5/FBC5\FBC5;
                      STA.W !OWSpriteYPosHigh,X                 ;;FBC0|FBC8+FBC8/FBC8\FBC8;
                      LDA.B #$02                                ;;FBC3|FBCB+FBCB/FBCB\FBCB;
                      STA.W !OWSpriteMisc0DF5,X                 ;;FBC5|FBCD+FBCD/FBCD\FBCD;
                      LDA.B #$F0                                ;;FBC8|FBD0+FBD0/FBD0\FBD0;
                      STA.W !OWSpriteXSpeed,X                   ;;FBCA|FBD2+FBD2/FBD2\FBD2;
                      STZ.W !OWSpriteMisc0E25,X                 ;;FBCD|FBD5+FBD5/FBD5\FBD5;
ADDR_04FBD8:          JSR CODE_04FE62                           ;;FBD0|FBD8+FBD8/FBD8\FBD8;
                      LDA.W !OWSpriteMisc0E25,X                 ;;FBD3|FBDB+FBDB/FBDB\FBDB;
                      BNE +                                     ;;FBD6|FBDE+FBDE/FBDE\FBDE;
                      INC.W !OWSpriteMisc0E05,X                 ;;FBD8|FBE0+FBE0/FBE0\FBE0;
                      JSR CODE_04FEAB                           ;;FBDB|FBE3+FBE3/FBE3\FBE3;
                      LDY.W !OWSpriteMisc0DF5,X                 ;;FBDE|FBE6+FBE6/FBE6\FBE6;
                      LDA.W !OWSpriteXPosLow,X                  ;;FBE1|FBE9+FBE9/FBE9\FBE9;
                      AND.B #$0F                                ;;FBE4|FBEC+FBEC/FBEC\FBEC;
                      CMP.W DATA_04FB95,Y                       ;;FBE6|FBEE+FBEE/FBEE\FBEE;
                      BNE +                                     ;;FBE9|FBF1+FBF1/FBF1\FBF1;
                      DEC.W !OWSpriteMisc0DF5,X                 ;;FBEB|FBF3+FBF3/FBF3\FBF3;
                      LDA.B #$04                                ;;FBEE|FBF6+FBF6/FBF6\FBF6;
                      STA.W !OWSpriteXSpeed,X                   ;;FBF0|FBF8+FBF8/FBF8\FBF8;
                      LDA.B #$60                                ;;FBF3|FBFB+FBFB/FBFB\FBFB;
                      STA.W !OWSpriteMisc0E25,X                 ;;FBF5|FBFD+FBFD/FBFD\FBFD;
                    + LDA.W DATA_04FB93,Y                       ;;FBF8|FC00+FC00/FC00\FC00;
                      LDY.B #$22                                ;;FBFB|FC03+FC03/FC03\FC03;
                      AND.W !OWSpriteMisc0E05,X                 ;;FBFD|FC05+FC05/FC05\FC05;
                      BNE +                                     ;;FC00|FC08+FC08/FC08\FC08;
                      LDY.B #$62                                ;;FC02|FC0A+FC0A/FC0A\FC0A;
                    + TYA                                       ;;FC04|FC0C+FC0C/FC0C\FC0C;
                      XBA                                       ;;FC05|FC0D+FC0D/FC0D\FC0D;
                      LDA.B #$6A                                ;;FC06|FC0E+FC0E/FC0E\FC0E;
                      JSR CODE_04FB06                           ;;FC08|FC10+FC10/FC10\FC10;
                      JSR ADDR_04FED7                           ;;FC0B|FC13+FC13/FC13\FC13;
                      BCS +                                     ;;FC0E|FC16+FC16/FC16\FC16;
                      ORA.B #$80                                ;;FC10|FC18+FC18/FC18\FC18;
                      STA.W !EnterLevelAuto                     ;;FC12|FC1A+FC1A/FC1A\FC1A;
                    + RTS                                       ;;FC15|FC1D+FC1D/FC1D\FC1D; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04FC1E:          db $38                                    ;;FC16|FC1E+FC1E/FC1E\FC1E;
                                                                ;;                        ;
DATA_04FC1F:          db $00,$68,$00                            ;;FC17|FC1F+FC1F/FC1F\FC1F;
                                                                ;;                        ;
DATA_04FC22:          db $8A                                    ;;FC1A|FC22+FC22/FC22\FC22;
                                                                ;;                        ;
DATA_04FC23:          db $01,$6A,$00                            ;;FC1B|FC23+FC23/FC23\FC23;
                                                                ;;                        ;
DATA_04FC26:          db $01,$02,$03,$04,$03,$02,$01,$00        ;;FC1E|FC26+FC26/FC26\FC26;
                      db $01,$02,$03,$04,$03,$02,$01,$00        ;;FC26|FC2E+FC2E/FC2E\FC2E;
DATA_04FC36:          db $FF,$FF,$FE,$FD,$FD,$FC,$FB,$FB        ;;FC2E|FC36+FC36/FC36\FC36;
                      db $FA,$F9,$F9,$F8,$F7,$F7,$F6,$F5        ;;FC36|FC3E+FC3E/FC3E\FC3E;
                                                                ;;                        ;
CODE_04FC46:          LDA.W !PlayerTurnOW                       ;;FC3E|FC46+FC46/FC46\FC46;
                      LSR A                                     ;;FC41|FC49+FC49/FC49\FC49;
                      LSR A                                     ;;FC42|FC4A+FC4A/FC4A\FC4A;
                      TAY                                       ;;FC43|FC4B+FC4B/FC4B\FC4B;
                      LDA.W !OWPlayerSubmap,Y                   ;;FC44|FC4C+FC4C/FC4C\FC4C;
                      ASL A                                     ;;FC47|FC4F+FC4F/FC4F\FC4F;
                      TAY                                       ;;FC48|FC50+FC50/FC50\FC50;
                      LDA.W DATA_04FC1E,Y                       ;;FC49|FC51+FC51/FC51\FC51;
                      STA.W !OWSpriteXPosLow,X                  ;;FC4C|FC54+FC54/FC54\FC54;
                      LDA.W DATA_04FC1F,Y                       ;;FC4F|FC57+FC57/FC57\FC57;
                      STA.W !OWSpriteXPosHigh,X                 ;;FC52|FC5A+FC5A/FC5A\FC5A;
                      LDA.W DATA_04FC22,Y                       ;;FC55|FC5D+FC5D/FC5D\FC5D;
                      STA.W !OWSpriteYPosLow,X                  ;;FC58|FC60+FC60/FC60\FC60;
                      LDA.W DATA_04FC23,Y                       ;;FC5B|FC63+FC63/FC63\FC63;
                      STA.W !OWSpriteYPosHigh,X                 ;;FC5E|FC66+FC66/FC66\FC66;
                      LDA.B !TrueFrame                          ;;FC61|FC69+FC69/FC69\FC69;
                      AND.B #$0F                                ;;FC63|FC6B+FC6B/FC6B\FC6B;
                      BNE CODE_04FC7C                           ;;FC65|FC6D+FC6D/FC6D\FC6D;
                      LDA.W !OWSpriteMisc0DF5,X                 ;;FC67|FC6F+FC6F/FC6F\FC6F;
                      INC A                                     ;;FC6A|FC72+FC72/FC72\FC72;
                      CMP.B #$0C                                ;;FC6B|FC73+FC73/FC73\FC73;
                      BCC +                                     ;;FC6D|FC75+FC75/FC75\FC75;
                      LDA.B #$00                                ;;FC6F|FC77+FC77/FC77\FC77;
                    + STA.W !OWSpriteMisc0DF5,X                 ;;FC71|FC79+FC79/FC79\FC79;
CODE_04FC7C:          LDA.B #$03                                ;;FC74|FC7C+FC7C/FC7C\FC7C;
                      STA.B !_4                                 ;;FC76|FC7E+FC7E/FC7E\FC7E;
                      LDA.B !TrueFrame                          ;;FC78|FC80+FC80/FC80\FC80;
                      STA.B !_6                                 ;;FC7A|FC82+FC82/FC82\FC82;
                      STZ.B !_7                                 ;;FC7C|FC84+FC84/FC84\FC84;
                      LDY.W DATA_04F843,X                       ;;FC7E|FC86+FC86/FC86\FC86;
                      LDA.W !OWSpriteMisc0DF5,X                 ;;FC81|FC89+FC89/FC89\FC89;
                      TAX                                       ;;FC84|FC8C+FC8C/FC8C\FC8C;
CODE_04FC8D:          PHY                                       ;;FC85|FC8D+FC8D/FC8D\FC8D;
                      PHX                                       ;;FC86|FC8E+FC8E/FC8E\FC8E;
                      LDX.W !SaveFileDelete                     ;;FC87|FC8F+FC8F/FC8F\FC8F;
                      JSR CODE_04FE62                           ;;FC8A|FC92+FC92/FC92\FC92;
                      PLX                                       ;;FC8D|FC95+FC95/FC95\FC95;
                      LDA.B !_7                                 ;;FC8E|FC96+FC96/FC96\FC96;
                      CLC                                       ;;FC90|FC98+FC98/FC98\FC98;
                      ADC.W DATA_04FC36,X                       ;;FC91|FC99+FC99/FC99\FC99;
                      CLC                                       ;;FC94|FC9C+FC9C/FC9C\FC9C;
                      ADC.B !_2                                 ;;FC95|FC9D+FC9D/FC9D\FC9D;
                      STA.B !_2                                 ;;FC97|FC9F+FC9F/FC9F\FC9F;
                      BCS +                                     ;;FC99|FCA1+FCA1/FCA1\FCA1;
                      DEC.B !_3                                 ;;FC9B|FCA3+FCA3/FCA3\FCA3;
                    + LDA.B !_0                                 ;;FC9D|FCA5+FCA5/FCA5\FCA5;
                      CLC                                       ;;FC9F|FCA7+FCA7/FCA7\FCA7;
                      ADC.W DATA_04FC26,X                       ;;FCA0|FCA8+FCA8/FCA8\FCA8;
                      STA.B !_0                                 ;;FCA3|FCAB+FCAB/FCAB\FCAB;
                      BCC +                                     ;;FCA5|FCAD+FCAD/FCAD\FCAD;
                      INC.B !_1                                 ;;FCA7|FCAF+FCAF/FCAF\FCAF;
                    + TXA                                       ;;FCA9|FCB1+FCB1/FCB1\FCB1;
                      CLC                                       ;;FCAA|FCB2+FCB2/FCB2\FCB2;
                      ADC.B #$0C                                ;;FCAB|FCB3+FCB3/FCB3\FCB3;
                      CMP.B #$10                                ;;FCAD|FCB5+FCB5/FCB5\FCB5;
                      AND.B #$0F                                ;;FCAF|FCB7+FCB7/FCB7\FCB7;
                      TAX                                       ;;FCB1|FCB9+FCB9/FCB9\FCB9;
                      BCC +                                     ;;FCB2|FCBA+FCBA/FCBA\FCBA;
                      LDA.B !_7                                 ;;FCB4|FCBC+FCBC/FCBC\FCBC;
                      SBC.B #$0C                                ;;FCB6|FCBE+FCBE/FCBE\FCBE;
                      STA.B !_7                                 ;;FCB8|FCC0+FCC0/FCC0\FCC0;
                    + LDA.B #$30                                ;;FCBA|FCC2+FCC2/FCC2\FCC2;
                      XBA                                       ;;FCBC|FCC4+FCC4/FCC4\FCC4;
                      LDY.B #$28                                ;;FCBD|FCC5+FCC5/FCC5\FCC5;
                      LDA.B !_6                                 ;;FCBF|FCC7+FCC7/FCC7\FCC7;
                      CLC                                       ;;FCC1|FCC9+FCC9/FCC9\FCC9;
                      ADC.B #$0A                                ;;FCC2|FCCA+FCCA/FCCA\FCCA;
                      STA.B !_6                                 ;;FCC4|FCCC+FCCC/FCCC\FCCC;
                      AND.B #$20                                ;;FCC6|FCCE+FCCE/FCCE\FCCE;
                      BEQ +                                     ;;FCC8|FCD0+FCD0/FCD0\FCD0;
                      LDY.B #$5F                                ;;FCCA|FCD2+FCD2/FCD2\FCD2;
                    + TYA                                       ;;FCCC|FCD4+FCD4/FCD4\FCD4;
                      PLY                                       ;;FCCD|FCD5+FCD5/FCD5\FCD5;
                      JSR CODE_04FAED                           ;;FCCE|FCD6+FCD6/FCD6\FCD6;
                      DEC.B !_4                                 ;;FCD1|FCD9+FCD9/FCD9\FCD9;
                      BNE CODE_04FC8D                           ;;FCD3|FCDB+FCDB/FCDB\FCDB;
                      LDX.W !SaveFileDelete                     ;;FCD5|FCDD+FCDD/FCDD\FCDD;
                      RTS                                       ;;FCD8|FCE0+FCE0/FCE0\FCE0; Return 
                                                                ;;                        ;
                                                                ;;                        ;
                                                                ;;                        ;Bowser's sign code starts here.
CODE_04FCE1:          JSR CODE_04FE62                           ;;FCD9|FCE1+FCE1/FCE1\FCE1;
                      LDA.B #$04                                ;;FCDC|FCE4+FCE4/FCE4\FCE4;\How many tiles to show up for Bowser's sign
                      STA.B !_4                                 ;;FCDE|FCE6+FCE6/FCE6\FCE6;/            
                      LDA.B #$6F                                ;;FCE0|FCE8+FCE8/FCE8\FCE8;
                      STA.B !_5                                 ;;FCE2|FCEA+FCEA/FCEA\FCEA; 
                      LDY.W DATA_04F843,X                       ;;FCE4|FCEC+FCEC/FCEC\FCEC;
                    - LDA.B !TrueFrame                          ;;FCE7|FCEF+FCEF/FCEF\FCEF;
                      LSR A                                     ;;FCE9|FCF1+FCF1/FCF1\FCF1;
                      AND.B #$06                                ;;FCEA|FCF2+FCF2/FCF2\FCF2;
                      ORA.B #$30                                ;;FCEC|FCF4+FCF4/FCF4\FCF4;
                      XBA                                       ;;FCEE|FCF6+FCF6/FCF6\FCF6;
                      LDA.B !_5                                 ;;FCEF|FCF7+FCF7/FCF7\FCF7;
                      JSR CODE_04FAED                           ;;FCF1|FCF9+FCF9/FCF9\FCF9;Jump to CLC, then the OAM part of the Pirahna Plant code.
                      LDA.B !_0                                 ;;FCF4|FCFC+FCFC/FCFC\FCFC;
                      SEC                                       ;;FCF6|FCFE+FCFE/FCFE\FCFE;
                      SBC.B #$08                                ;;FCF7|FCFF+FCFF/FCFF\FCFF;
                      STA.B !_0                                 ;;FCF9|FD01+FD01/FD01\FD01;
                      DEC.B !_5                                 ;;FCFB|FD03+FD03/FD03\FD03;
                      DEC.B !_4                                 ;;FCFD|FD05+FD05/FD05\FD05;
                      BNE -                                     ;;FCFF|FD07+FD07/FD07\FD07;
                      RTS                                       ;;FD01|FD09+FD09/FD09\FD09; Return 
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04FD0A:          db $07,$07,$03,$03,$5F,$5F                ;;FD02|FD0A+FD0A/FD0A\FD0A;
                                                                ;;                        ;
DATA_04FD10:          db $01,$FF,$01,$FF,$01,$FF,$01,$FF        ;;FD08|FD10+FD10/FD10\FD10;
                      db $01,$FF                                ;;FD10|FD18+FD18/FD18\FD18;
                                                                ;;                        ;
DATA_04FD1A:          db $18,$E8,$0A,$F6,$08,$F8,$03,$FD        ;;FD12|FD1A+FD1A/FD1A\FD1A;
DATA_04FD22:          db $01,$FF                                ;;FD1A|FD22+FD22/FD22\FD22;
                                                                ;;                        ;
CODE_04FD24:          JSR CODE_04FE90                           ;;FD1C|FD24+FD24/FD24\FD24;
                      JSR CODE_04FE62                           ;;FD1F|FD27+FD27/FD27\FD27;
                      JSR CODE_04FE62                           ;;FD22|FD2A+FD2A/FD2A\FD2A;
                      LDA.B #$00                                ;;FD25|FD2D+FD2D/FD2D\FD2D;
                      LDY.W !OWSpriteXSpeed,X                   ;;FD27|FD2F+FD2F/FD2F\FD2F;
                      BMI +                                     ;;FD2A|FD32+FD32/FD32\FD32;
                      LDA.B #$40                                ;;FD2C|FD34+FD34/FD34\FD34;
                    + XBA                                       ;;FD2E|FD36+FD36/FD36\FD36;
                      LDA.B #$68                                ;;FD2F|FD37+FD37/FD37\FD37;
                      JSR CODE_04FB06                           ;;FD31|FD39+FD39/FD39\FD39;
                      INC.W !OWSpriteMisc0E15,X                 ;;FD34|FD3C+FD3C/FD3C\FD3C;
                      LDA.W !OWSpriteMisc0E15,X                 ;;FD37|FD3F+FD3F/FD3F\FD3F;
                      LSR A                                     ;;FD3A|FD42+FD42/FD42\FD42;
                      BCS Return04FD6F                          ;;FD3B|FD43+FD43/FD43\FD43;
                      LDA.W !OWSpriteMisc0E05,X                 ;;FD3D|FD45+FD45/FD45\FD45;
                      ORA.B #$02                                ;;FD40|FD48+FD48/FD48\FD48;
                      TAY                                       ;;FD42|FD4A+FD4A/FD4A\FD4A;
                      TXA                                       ;;FD43|FD4B+FD4B/FD4B\FD4B;
                      ADC.B #$10                                ;;FD44|FD4C+FD4C/FD4C\FD4C;
                      TAX                                       ;;FD46|FD4E+FD4E/FD4E\FD4E;
                      JSR CODE_04FD55                           ;;FD47|FD4F+FD4F/FD4F\FD4F;
                      LDY.W !OWSpriteMisc0DF5,X                 ;;FD4A|FD52+FD52/FD52\FD52;
CODE_04FD55:          LDA.W !OWSpriteXSpeed,X                   ;;FD4D|FD55+FD55/FD55\FD55;
                      CLC                                       ;;FD50|FD58+FD58/FD58\FD58;
                      ADC.W DATA_04FD10,Y                       ;;FD51|FD59+FD59/FD59\FD59;
                      STA.W !OWSpriteXSpeed,X                   ;;FD54|FD5C+FD5C/FD5C\FD5C;
                      CMP.W DATA_04FD1A,Y                       ;;FD57|FD5F+FD5F/FD5F\FD5F;
                      BNE CODE_04FD68                           ;;FD5A|FD62+FD62/FD62\FD62;
                      TYA                                       ;;FD5C|FD64+FD64/FD64\FD64;
                      EOR.B #$01                                ;;FD5D|FD65+FD65/FD65\FD65;
                      TAY                                       ;;FD5F|FD67+FD67/FD67\FD67;
CODE_04FD68:          TYA                                       ;;FD60|FD68+FD68/FD68\FD68;
                      STA.W !OWSpriteMisc0DF5,X                 ;;FD61|FD69+FD69/FD69\FD69;
                      LDX.W !SaveFileDelete                     ;;FD64|FD6C+FD6C/FD6C\FD6C;
Return04FD6F:         RTS                                       ;;FD67|FD6F+FD6F/FD6F\FD6F; Return 
                                                                ;;                        ;
CODE_04FD70:          JSR CODE_04FE90                           ;;FD68|FD70+FD70/FD70\FD70;
                      JSR CODE_04FE62                           ;;FD6B|FD73+FD73/FD73\FD73;
                      JSR CODE_04FE62                           ;;FD6E|FD76+FD76/FD76\FD76;
                      LDY.W !PlayerTurnLvl                      ;;FD71|FD79+FD79/FD79\FD79;
                      LDA.W !OWPlayerSubmap,Y                   ;;FD74|FD7C+FD7C/FD7C\FD7C;
                      BEQ CODE_04FDA5                           ;;FD77|FD7F+FD7F/FD7F\FD7F;
                      CPX.B #$0F                                ;;FD79|FD81+FD81/FD81\FD81;
                      BNE +                                     ;;FD7B|FD83+FD83/FD83\FD83;
                      LDA.W !OWEventsActivated+5                ;;FD7D|FD85+FD85/FD85\FD85;
                      AND.B #$12                                ;;FD80|FD88+FD88/FD88\FD88;
                      BNE +                                     ;;FD82|FD8A+FD8A/FD8A\FD8A;
                      STX.B !_3                                 ;;FD84|FD8C+FD8C/FD8C\FD8C;
                    + TXA                                       ;;FD86|FD8E+FD8E/FD8E\FD8E;
                      ASL A                                     ;;FD87|FD8F+FD8F/FD8F\FD8F;
                      TAY                                       ;;FD88|FD90+FD90/FD90\FD90;
                      REP #$20                                  ;;FD89|FD91+FD91/FD91\FD91; Accum (16 bit) 
                      LDA.B !_0                                 ;;FD8B|FD93+FD93/FD93\FD93;
                      CLC                                       ;;FD8D|FD95+FD95/FD95\FD95;
                      ADC.W ExtraOWGhostXPos-$1A,Y              ;;FD8E|FD96+FD96/FD96\FD96;
                      STA.B !_0                                 ;;FD91|FD99+FD99/FD99\FD99;
                      LDA.B !_2                                 ;;FD93|FD9B+FD9B/FD9B\FD9B;
                      CLC                                       ;;FD95|FD9D+FD9D/FD9D\FD9D;
                      ADC.W ExtraOWGhostYPos-$1A,Y              ;;FD96|FD9E+FD9E/FD9E\FD9E;
                      STA.B !_2                                 ;;FD99|FDA1+FDA1/FDA1\FDA1;
                      SEP #$20                                  ;;FD9B|FDA3+FDA3/FDA3\FDA3; Accum (8 bit) 
CODE_04FDA5:          LDA.B #$34                                ;;FD9D|FDA5+FDA5/FDA5\FDA5;
                      LDY.W !OWSpriteXSpeed,X                   ;;FD9F|FDA7+FDA7/FDA7\FDA7;
                      BMI +                                     ;;FDA2|FDAA+FDAA/FDAA\FDAA;
                      LDA.B #$44                                ;;FDA4|FDAC+FDAC/FDAC\FDAC;
                    + XBA                                       ;;FDA6|FDAE+FDAE/FDAE\FDAE;
                      LDA.B #$60                                ;;FDA7|FDAF+FDAF/FDAF\FDAF;
                      JSR CODE_04FB06                           ;;FDA9|FDB1+FDB1/FDB1\FDB1;
                      LDA.W !OWSpriteMisc0E25,X                 ;;FDAC|FDB4+FDB4/FDB4\FDB4;
                      STA.B !_0                                 ;;FDAF|FDB7+FDB7/FDB7\FDB7;
                      INC.W !OWSpriteMisc0E25,X                 ;;FDB1|FDB9+FDB9/FDB9\FDB9;
                      TXA                                       ;;FDB4|FDBC+FDBC/FDBC\FDBC;
                      CLC                                       ;;FDB5|FDBD+FDBD/FDBD\FDBD;
                      ADC.B #$20                                ;;FDB6|FDBE+FDBE/FDBE\FDBE;
                      TAX                                       ;;FDB8|FDC0+FDC0/FDC0\FDC0;
                      LDA.B #$08                                ;;FDB9|FDC1+FDC1/FDC1\FDC1;
                      JSR CODE_04FDD2                           ;;FDBB|FDC3+FDC3/FDC3\FDC3;
                      TXA                                       ;;FDBE|FDC6+FDC6/FDC6\FDC6;
                      CLC                                       ;;FDBF|FDC7+FDC7/FDC7\FDC7;
                      ADC.B #$10                                ;;FDC0|FDC8+FDC8/FDC8\FDC8;
                      TAX                                       ;;FDC2|FDCA+FDCA/FDCA\FDCA;
                      LDA.B #$06                                ;;FDC3|FDCB+FDCB/FDCB\FDCB;
                      JSR CODE_04FDD2                           ;;FDC5|FDCD+FDCD/FDCD\FDCD;
                      LDA.B #$04                                ;;FDC8|FDD0+FDD0/FDD0\FDD0;
CODE_04FDD2:          ORA.W !OWSpriteMisc0DF5,X                 ;;FDCA|FDD2+FDD2/FDD2\FDD2;
                      TAY                                       ;;FDCD|FDD5+FDD5/FDD5\FDD5;
                      LDA.W DATA_04FD0A-4,Y                     ;;FDCE|FDD6+FDD6/FDD6\FDD6;
                      AND.B !_0                                 ;;FDD1|FDD9+FDD9/FDD9\FDD9;
                      BNE CODE_04FD68                           ;;FDD3|FDDB+FDDB/FDDB\FDDB;
                      JMP CODE_04FD55                           ;;FDD5|FDDD+FDDD/FDDD\FDDD;
                                                                ;;                        ;
                                                                ;;                        ;
DATA_04FDE0:          db $00,$00,$00,$00,$01,$02,$02,$02        ;;FDD8|FDE0+FDE0/FDE0\FDE0;
                      db $00,$00,$01,$01,$02,$02,$03,$03        ;;FDE0|FDE8+FDE8/FDE8\FDE8;
DATA_04FDF0:          db $08,$08,$08,$08,$07,$06,$05,$05        ;;FDE8|FDF0+FDF0/FDF0\FDF0;
                      db $00,$00,$0E,$0E,$0C,$0C,$0A,$0A        ;;FDF0|FDF8+FDF8/FDF8\FDF8;
                                                                ;;                        ;
ADDR_04FE00:          ROR.B !_4                                 ;;FDF8|FE00+FE00/FE00\FE00;
                      JSR CODE_04FE62                           ;;FDFA|FE02+FE02/FE02\FE02;
                      JSR CODE_04FE4E                           ;;FDFD|FE05+FE05/FE05\FE05;
                      LDA.W !OWSpriteZPosLow,X                  ;;FE00|FE08+FE08/FE08\FE08;
                      LSR A                                     ;;FE03|FE0B+FE0B/FE0B\FE0B;
                      LSR A                                     ;;FE04|FE0C+FE0C/FE0C\FE0C;
                      LSR A                                     ;;FE05|FE0D+FE0D/FE0D\FE0D;
                      LSR A                                     ;;FE06|FE0E+FE0E/FE0E\FE0E;
                      LDY.B #$29                                ;;FE07|FE0F+FE0F/FE0F\FE0F;
                      BIT.B !_4                                 ;;FE09|FE11+FE11/FE11\FE11;
                      BPL +                                     ;;FE0B|FE13+FE13/FE13\FE13;
                      LDY.B #$2E                                ;;FE0D|FE15+FE15/FE15\FE15;
                      CLC                                       ;;FE0F|FE17+FE17/FE17\FE17;
                      ADC.B #$08                                ;;FE10|FE18+FE18/FE18\FE18;
                    + STY.B !_5                                 ;;FE12|FE1A+FE1A/FE1A\FE1A;
                      TAY                                       ;;FE14|FE1C+FE1C/FE1C\FE1C;
                      STY.B !_6                                 ;;FE15|FE1D+FE1D/FE1D\FE1D;
                      LDA.B !_0                                 ;;FE17|FE1F+FE1F/FE1F\FE1F;
                      CLC                                       ;;FE19|FE21+FE21/FE21\FE21;
                      ADC.W DATA_04FDE0,Y                       ;;FE1A|FE22+FE22/FE22\FE22;
                      STA.B !_0                                 ;;FE1D|FE25+FE25/FE25\FE25;
                      BCC +                                     ;;FE1F|FE27+FE27/FE27\FE27;
                      INC.B !_1                                 ;;FE21|FE29+FE29/FE29\FE29;
                    + LDA.B #$32                                ;;FE23|FE2B+FE2B/FE2B\FE2B;
                      LDY.W DATA_04F843,X                       ;;FE25|FE2D+FE2D/FE2D\FE2D;
                      JSR ADDR_04FE45                           ;;FE28|FE30+FE30/FE30\FE30;
                      PHY                                       ;;FE2B|FE33+FE33/FE33\FE33;
                      LDY.B !_6                                 ;;FE2C|FE34+FE34/FE34\FE34;
                      LDA.B !_0                                 ;;FE2E|FE36+FE36/FE36\FE36;
                      CLC                                       ;;FE30|FE38+FE38/FE38\FE38;
                      ADC.W DATA_04FDF0,Y                       ;;FE31|FE39+FE39/FE39\FE39;
                      STA.B !_0                                 ;;FE34|FE3C+FE3C/FE3C\FE3C;
                      BCC +                                     ;;FE36|FE3E+FE3E/FE3E\FE3E;
                      INC.B !_1                                 ;;FE38|FE40+FE40/FE40\FE40;
                    + LDA.B #$72                                ;;FE3A|FE42+FE42/FE42\FE42;
                      PLY                                       ;;FE3C|FE44+FE44/FE44\FE44;
ADDR_04FE45:          XBA                                       ;;FE3D|FE45+FE45/FE45\FE45;
                      LDA.B !_4                                 ;;FE3E|FE46+FE46/FE46\FE46;
                      ASL A                                     ;;FE40|FE48+FE48/FE48\FE48;
                      LDA.B !_5                                 ;;FE41|FE49+FE49/FE49\FE49;
                      JMP CODE_04FB0A                           ;;FE43|FE4B+FE4B/FE4B\FE4B;
                                                                ;;                        ;
CODE_04FE4E:          LDA.B !_2                                 ;;FE46|FE4E+FE4E/FE4E\FE4E;
                      CLC                                       ;;FE48|FE50+FE50/FE50\FE50;
                      ADC.W !OWSpriteZPosLow,X                  ;;FE49|FE51+FE51/FE51\FE51;
                      STA.B !_2                                 ;;FE4C|FE54+FE54/FE54\FE54;
                      BCC +                                     ;;FE4E|FE56+FE56/FE56\FE56;
                      INC.B !_3                                 ;;FE50|FE58+FE58/FE58\FE58;
                    + RTS                                       ;;FE52|FE5A+FE5A/FE5A\FE5A; Return 
                                                                ;;                        ;
CODE_04FE5B:          LDA.B !TrueFrame                          ;;FE53|FE5B+FE5B/FE5B\FE5B;
                      CLC                                       ;;FE55|FE5D+FE5D/FE5D\FE5D;
                      ADC.W DATA_04F833,X                       ;;FE56|FE5E+FE5E/FE5E\FE5E;
                      RTS                                       ;;FE59|FE61+FE61/FE61\FE61; Return 
                                                                ;;                        ;
CODE_04FE62:          TXA                                       ;;FE5A|FE62+FE62/FE62\FE62;
                      CLC                                       ;;FE5B|FE63+FE63/FE63\FE63;
                      ADC.B #$10                                ;;FE5C|FE64+FE64/FE64\FE64;
                      TAX                                       ;;FE5E|FE66+FE66/FE66\FE66;
                      LDY.B #$02                                ;;FE5F|FE67+FE67/FE67\FE67;
                      JSR CODE_04FE7D                           ;;FE61|FE69+FE69/FE69\FE69;
                      LDX.W !SaveFileDelete                     ;;FE64|FE6C+FE6C/FE6C\FE6C;
                      LDA.B !_2                                 ;;FE67|FE6F+FE6F/FE6F\FE6F;
                      SEC                                       ;;FE69|FE71+FE71/FE71\FE71;
                      SBC.W !OWSpriteZPosLow,X                  ;;FE6A|FE72+FE72/FE72\FE72;
                      STA.B !_2                                 ;;FE6D|FE75+FE75/FE75\FE75;
                      BCS +                                     ;;FE6F|FE77+FE77/FE77\FE77;
                      DEC.B !_3                                 ;;FE71|FE79+FE79/FE79\FE79;
                    + LDY.B #$00                                ;;FE73|FE7B+FE7B/FE7B\FE7B;
CODE_04FE7D:          LDA.W !OWSpriteXPosHigh,X                 ;;FE75|FE7D+FE7D/FE7D\FE7D;
                      XBA                                       ;;FE78|FE80+FE80/FE80\FE80;
                      LDA.W !OWSpriteXPosLow,X                  ;;FE79|FE81+FE81/FE81\FE81;
                      REP #$20                                  ;;FE7C|FE84+FE84/FE84\FE84; Accum (16 bit) 
                      SEC                                       ;;FE7E|FE86+FE86/FE86\FE86;
                      SBC.W !Layer1XPos,Y                       ;;FE7F|FE87+FE87/FE87\FE87;
                      STA.W !_0,Y                               ;;FE82|FE8A+FE8A/FE8A\FE8A;
                      SEP #$20                                  ;;FE85|FE8D+FE8D/FE8D\FE8D; Accum (8 bit) 
                      RTS                                       ;;FE87|FE8F+FE8F/FE8F\FE8F; Return 
                                                                ;;                        ;
CODE_04FE90:          TXA                                       ;;FE88|FE90+FE90/FE90\FE90;Transfer X to A
                      CLC                                       ;;FE89|FE91+FE91/FE91\FE91;Clear Carry Flag
                      ADC.B #$20                                ;;FE8A|FE92+FE92/FE92\FE92;Add #$20 to A
                      TAX                                       ;;FE8C|FE94+FE94/FE94\FE94;Transfer A to X
                      JSR CODE_04FEAB                           ;;FE8D|FE95+FE95/FE95\FE95;
                      LDA.W !OWSpriteXPosLow,X                  ;;FE90|FE98+FE98/FE98\FE98;Load OW Sprite XPos Low
                      BPL +                                     ;;FE93|FE9B+FE9B/FE9B\FE9B;If it is => 80
                      STZ.W !OWSpriteXPosLow,X                  ;;FE95|FE9D+FE9D/FE9D\FE9D;Store 00 OW Sprite Xpos Low
                    + TXA                                       ;;FE98|FEA0+FEA0/FEA0\FEA0;Transfer X to A
                      SEC                                       ;;FE99|FEA1+FEA1/FEA1\FEA1;Set Carry Flag...
                      SBC.B #$10                                ;;FE9A|FEA2+FEA2/FEA2\FEA2;...for substraction
                      TAX                                       ;;FE9C|FEA4+FEA4/FEA4\FEA4;Transfer A to X
                      JSR CODE_04FEAB                           ;;FE9D|FEA5+FEA5/FEA5\FEA5;
                      LDX.W !SaveFileDelete                     ;;FEA0|FEA8+FEA8/FEA8\FEA8;
CODE_04FEAB:          LDA.W !OWSpriteXSpeed,X                   ;;FEA3|FEAB+FEAB/FEAB\FEAB;Load OW Sprite X Speed
                      ASL A                                     ;;FEA6|FEAE+FEAE/FEAE\FEAE;Multiply it by 2
                      ASL A                                     ;;FEA7|FEAF+FEAF/FEAF\FEAF;4...
                      ASL A                                     ;;FEA8|FEB0+FEB0/FEB0\FEB0;8...
                      ASL A                                     ;;FEA9|FEB1+FEB1/FEB1\FEB1;16...
                      CLC                                       ;;FEAA|FEB2+FEB2/FEB2\FEB2;Clear Carry Flag
                      ADC.W !OWSpriteXPosSpx,X                  ;;FEAB|FEB3+FEB3/FEB3\FEB3;
                      STA.W !OWSpriteXPosSpx,X                  ;;FEAE|FEB6+FEB6/FEB6\FEB6;And store it in
                      LDA.W !OWSpriteXSpeed,X                   ;;FEB1|FEB9+FEB9/FEB9\FEB9;Load OW Sprite X Speed
                      PHP                                       ;;FEB4|FEBC+FEBC/FEBC\FEBC;
                      LSR A                                     ;;FEB5|FEBD+FEBD/FEBD\FEBD;Divide by 2
                      LSR A                                     ;;FEB6|FEBE+FEBE/FEBE\FEBE;4
                      LSR A                                     ;;FEB7|FEBF+FEBF/FEBF\FEBF;8
                      LSR A                                     ;;FEB8|FEC0+FEC0/FEC0\FEC0;16
                      LDY.B #$00                                ;;FEB9|FEC1+FEC1/FEC1\FEC1;Load $00 in Y
                      PLP                                       ;;FEBB|FEC3+FEC3/FEC3\FEC3;
                      BPL +                                     ;;FEBC|FEC4+FEC4/FEC4\FEC4;
                      ORA.B #$F0                                ;;FEBE|FEC6+FEC6/FEC6\FEC6;
                      DEY                                       ;;FEC0|FEC8+FEC8/FEC8\FEC8;
                    + ADC.W !OWSpriteXPosLow,X                  ;;FEC1|FEC9+FEC9/FEC9\FEC9;
                      STA.W !OWSpriteXPosLow,X                  ;;FEC4|FECC+FECC/FECC\FECC;
                      TYA                                       ;;FEC7|FECF+FECF/FECF\FECF;
                      ADC.W !OWSpriteXPosHigh,X                 ;;FEC8|FED0+FED0/FED0\FED0;
                      STA.W !OWSpriteXPosHigh,X                 ;;FECB|FED3+FED3/FED3\FED3;
                      RTS                                       ;;FECE|FED6+FED6/FED6\FED6; Return 
                                                                ;;                        ;
ADDR_04FED7:          JSR ADDR_04FEEF                           ;;FECF|FED7+FED7/FED7\FED7; Accum (16 bit) 
                      LDA.B !_6                                 ;;FED2|FEDA+FEDA/FEDA\FEDA;
                      CMP.W #$0008                              ;;FED4|FEDC+FEDC/FEDC\FEDC;
                      BCS +                                     ;;FED7|FEDF+FEDF/FEDF\FEDF;
                      LDA.B !_8                                 ;;FED9|FEE1+FEE1/FEE1\FEE1;
                      CMP.W #$0008                              ;;FEDB|FEE3+FEE3/FEE3\FEE3;
                    + SEP #$20                                  ;;FEDE|FEE6+FEE6/FEE6\FEE6; Accum (8 bit) 
                      TXA                                       ;;FEE0|FEE8+FEE8/FEE8\FEE8;
                      BCS +                                     ;;FEE1|FEE9+FEE9/FEE9\FEE9;
                      STA.W !EnterLevelAuto                     ;;FEE3|FEEB+FEEB/FEEB\FEEB;
                    + RTS                                       ;;FEE6|FEEE+FEEE/FEEE\FEEE; Return 
                                                                ;;                        ;
ADDR_04FEEF:          LDA.W !OWSpriteXPosHigh,X                 ;;FEE7|FEEF+FEEF/FEEF\FEEF;
                      XBA                                       ;;FEEA|FEF2+FEF2/FEF2\FEF2;
                      LDA.W !OWSpriteXPosLow,X                  ;;FEEB|FEF3+FEF3/FEF3\FEF3;
                      REP #$20                                  ;;FEEE|FEF6+FEF6/FEF6\FEF6; Accum (16 bit) 
                      CLC                                       ;;FEF0|FEF8+FEF8/FEF8\FEF8;
                      ADC.W #$0008                              ;;FEF1|FEF9+FEF9/FEF9\FEF9;
                      LDY.W !PlayerTurnOW                       ;;FEF4|FEFC+FEFC/FEFC\FEFC;
                      SEC                                       ;;FEF7|FEFF+FEFF/FEFF\FEFF;
                      SBC.W !OWPlayerXPos,Y                     ;;FEF8|FF00+FF00/FF00\FF00;
                      STA.B !_0                                 ;;FEFB|FF03+FF03/FF03\FF03;
                      BPL +                                     ;;FEFD|FF05+FF05/FF05\FF05;
                      EOR.W #$FFFF                              ;;FEFF|FF07+FF07/FF07\FF07;
                      INC A                                     ;;FF02|FF0A+FF0A/FF0A\FF0A;
                    + STA.B !_6                                 ;;FF03|FF0B+FF0B/FF0B\FF0B;
                      SEP #$20                                  ;;FF05|FF0D+FF0D/FF0D\FF0D; Accum (8 bit) 
                      LDA.W !OWSpriteYPosHigh,X                 ;;FF07|FF0F+FF0F/FF0F\FF0F;
                      XBA                                       ;;FF0A|FF12+FF12/FF12\FF12;
                      LDA.W !OWSpriteYPosLow,X                  ;;FF0B|FF13+FF13/FF13\FF13;
                      REP #$20                                  ;;FF0E|FF16+FF16/FF16\FF16; Accum (16 bit) 
                      CLC                                       ;;FF10|FF18+FF18/FF18\FF18;
                      ADC.W #$0008                              ;;FF11|FF19+FF19/FF19\FF19;
                      LDY.W !PlayerTurnOW                       ;;FF14|FF1C+FF1C/FF1C\FF1C;
                      SEC                                       ;;FF17|FF1F+FF1F/FF1F\FF1F;
                      SBC.W !OWPlayerYPos,Y                     ;;FF18|FF20+FF20/FF20\FF20;
                      STA.B !_2                                 ;;FF1B|FF23+FF23/FF23\FF23;
                      BPL +                                     ;;FF1D|FF25+FF25/FF25\FF25;
                      EOR.W #$FFFF                              ;;FF1F|FF27+FF27/FF27\FF27;
                      INC A                                     ;;FF22|FF2A+FF2A/FF2A\FF2A;
                    + STA.B !_8                                 ;;FF23|FF2B+FF2B/FF2B\FF2B;
                      RTS                                       ;;FF25|FF2D+FF2D/FF2D\FF2D; Return 
                                                                ;;                        ;
ADDR_04FF2E:          JSR ADDR_04FEEF                           ;;FF26|FF2E+FF2E/FF2E\FF2E;
                      LSR.B !_6                                 ;;FF29|FF31+FF31/FF31\FF31;
                      LSR.B !_8                                 ;;FF2B|FF33+FF33/FF33\FF33;
                      SEP #$20                                  ;;FF2D|FF35+FF35/FF35\FF35; Accum (8 bit) 
                      LDA.W !OWSpriteZPosLow,X                  ;;FF2F|FF37+FF37/FF37\FF37;
                      LSR A                                     ;;FF32|FF3A+FF3A/FF3A\FF3A;
                      STA.B !_A                                 ;;FF33|FF3B+FF3B/FF3B\FF3B;
                      STZ.B !_5                                 ;;FF35|FF3D+FF3D/FF3D\FF3D;
                      LDY.B #$04                                ;;FF37|FF3F+FF3F/FF3F\FF3F;
                      CMP.B !_8                                 ;;FF39|FF41+FF41/FF41\FF41;
                      BCS +                                     ;;FF3B|FF43+FF43/FF43\FF43;
                      LDY.B #$02                                ;;FF3D|FF45+FF45/FF45\FF45;
                      LDA.B !_8                                 ;;FF3F|FF47+FF47/FF47\FF47;
                    + CMP.B !_6                                 ;;FF41|FF49+FF49/FF49\FF49;
                      BCS +                                     ;;FF43|FF4B+FF4B/FF4B\FF4B;
                      LDY.B #$00                                ;;FF45|FF4D+FF4D/FF4D\FF4D;
                      LDA.B !_6                                 ;;FF47|FF4F+FF4F/FF4F\FF4F;
                    + CMP.B #$01                                ;;FF49|FF51+FF51/FF51\FF51;
                      BCS +                                     ;;FF4B|FF53+FF53/FF53\FF53;
                      STZ.W !OWSpriteMisc0E15,X                 ;;FF4D|FF55+FF55/FF55\FF55;
                      STZ.W !OWSpriteXSpeed,X                   ;;FF50|FF58+FF58/FF58\FF58;
                      STZ.W !OWSpriteYSpeed,X                   ;;FF53|FF5B+FF5B/FF5B\FF5B;
                      STZ.W !OWSpriteZSpeed,X                   ;;FF56|FF5E+FF5E/FF5E\FF5E;
                      LDA.B #$40                                ;;FF59|FF61+FF61/FF61\FF61;
                      STA.W !OWSpriteZPosLow,X                  ;;FF5B|FF63+FF63/FF63\FF63;
                      RTS                                       ;;FF5E|FF66+FF66/FF66\FF66; Return 
                                                                ;;                        ;
                    + STY.B !_C                                 ;;FF5F|FF67+FF67/FF67\FF67;
                      LDX.B #$04                                ;;FF61|FF69+FF69/FF69\FF69;
ADDR_04FF6B:          CPX.B !_C                                 ;;FF63|FF6B+FF6B/FF6B\FF6B;
                      BNE ADDR_04FF73                           ;;FF65|FF6D+FF6D/FF6D\FF6D;
                      LDA.B #$20                                ;;FF67|FF6F+FF6F/FF6F\FF6F;
                      BRA +                                     ;;FF69|FF71+FF71/FF71\FF71;
                                                                ;;                        ;
ADDR_04FF73:          STZ.W !HW_WRDIV                           ;;FF6B|FF73+FF73/FF73\FF73; Dividend (Low Byte)
                      LDA.B !_6,X                               ;;FF6E|FF76+FF76/FF76\FF76;
                      STA.W !HW_WRDIV+1                         ;;FF70|FF78+FF78/FF78\FF78; Dividend (High-Byte)
                      LDA.W !_6,Y                               ;;FF73|FF7B+FF7B/FF7B\FF7B;
                      STA.W !HW_WRDIV+2                         ;;FF76|FF7E+FF7E/FF7E\FF7E; Divisor B
                      NOP                                       ;;FF79|FF81+FF81/FF81\FF81;
                      NOP                                       ;;FF7A|FF82+FF82/FF82\FF82;
                      NOP                                       ;;FF7B|FF83+FF83/FF83\FF83;
                      NOP                                       ;;FF7C|FF84+FF84/FF84\FF84;
                      NOP                                       ;;FF7D|FF85+FF85/FF85\FF85;
                      NOP                                       ;;FF7E|FF86+FF86/FF86\FF86;
                      REP #$20                                  ;;FF7F|FF87+FF87/FF87\FF87; Accum (16 bit) 
                      LDA.W !HW_RDDIV                           ;;FF81|FF89+FF89/FF89\FF89; Quotient of Divide Result (Low Byte)
                      LSR A                                     ;;FF84|FF8C+FF8C/FF8C\FF8C;
                      LSR A                                     ;;FF85|FF8D+FF8D/FF8D\FF8D;
                      LSR A                                     ;;FF86|FF8E+FF8E/FF8E\FF8E;
                      SEP #$20                                  ;;FF87|FF8F+FF8F/FF8F\FF8F; Accum (8 bit) 
                    + BIT.B !_1,X                               ;;FF89|FF91+FF91/FF91\FF91;
                      BMI +                                     ;;FF8B|FF93+FF93/FF93\FF93;
                      EOR.B #$FF                                ;;FF8D|FF95+FF95/FF95\FF95;
                      INC A                                     ;;FF8F|FF97+FF97/FF97\FF97;
                    + STA.B !_0,X                               ;;FF90|FF98+FF98/FF98\FF98;
                      DEX                                       ;;FF92|FF9A+FF9A/FF9A\FF9A;
                      DEX                                       ;;FF93|FF9B+FF9B/FF9B\FF9B;
                      BPL ADDR_04FF6B                           ;;FF94|FF9C+FF9C/FF9C\FF9C;
                      LDX.W !SaveFileDelete                     ;;FF96|FF9E+FF9E/FF9E\FF9E;
                      LDA.B !_0                                 ;;FF99|FFA1+FFA1/FFA1\FFA1;
                      STA.W !OWSpriteXSpeed,X                   ;;FF9B|FFA3+FFA3/FFA3\FFA3;
                      LDA.B !_2                                 ;;FF9E|FFA6+FFA6/FFA6\FFA6;
                      STA.W !OWSpriteYSpeed,X                   ;;FFA0|FFA8+FFA8/FFA8\FFA8;
                      LDA.B !_4                                 ;;FFA3|FFAB+FFAB/FFAB\FFAB;
                      STA.W !OWSpriteZSpeed,X                   ;;FFA5|FFAD+FFAD/FFAD\FFAD;
                      RTS                                       ;;FFA8|FFB0+FFB0/FFB0\FFB0; Return 
                                                                ;;                        ;
                      padbyte $FF : pad $058000                 ;;FFA9|FFB1+FFB1/FFB1\FFB1;