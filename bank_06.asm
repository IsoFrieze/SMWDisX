    ORG $068000

TestLevel:
    incbin "lvl/obj/testlevel.bin"
CloudsBetaLevel:
    incbin "lvl/obj/betaclouds.bin"
MushroomBetaLevel:
    incbin "lvl/obj/betamushrooms.bin"
BossTestBetaLevel:
    incbin "lvl/obj/betabosstest.bin"
BowserCopyLevel:
    incbin "lvl/obj/1C7_bowser.bin"
Mode7BossCopyLevel:
    incbin "lvl/obj/mode7boss2.bin"
LarryIggyCopyLevel:
    incbin "lvl/obj/iggylarryroom.bin"
LavaCaveBetaLvlL2:
    incbin "lvl/obj/betalavacave_l2.bin"
LavaCaveBetaLevel:
    incbin "lvl/obj/betalavacave.bin"
TwinBlockBetaLevel:
    incbin "lvl/obj/betatwinblocks.bin"
WendyBetaLevel:
    incbin "lvl/obj/betaC6room1.bin"
WendyBetaLvlL2:
    incbin "lvl/obj/betaC6room1_l2.bin"
GroundBetaLevel:
    incbin "lvl/obj/betajustground.bin"
LemmyCopyLevel:
    incbin "lvl/obj/1F2_C3room4.bin"
WendyCopyLevel:
    incbin "lvl/obj/0D3_C6room3.bin"
TitleScrLevel0C7:
    incbin "lvl/obj/0C7_titlescreen.bin"
IntroLevel0C5:
    incbin "lvl/obj/0C5_introcutscene.bin"
GhostHouseExitLvlL2:
    incbin "lvl/obj/ghosthouseexit_l2.bin"
GhostHouseExitLevel:
    incbin "lvl/obj/ghosthouseexit.bin"
Mode7BossLayer1:
    incbin "lvl/obj/mode7boss1.bin"
DP2Sub2Level0FF:
    incbin "lvl/obj/0FF_DP2end.bin"
BonusGameLevel:
    incbin "lvl/obj/bonusgame.bin"
UnusedGHExitLevel:
    incbin "lvl/obj/unusedghexit1.bin"
LarryIggyLevel:
    incbin "lvl/obj/iggylarryroom.bin"
YSPLevel014:
    incbin "lvl/obj/014_YSProom1.bin"
RSPLevel11B:
    incbin "lvl/obj/11B_RSProom1.bin"
BSPLevel121:
    incbin "lvl/obj/121_BSProom1.bin"
GSPLevel008:
    incbin "lvl/obj/008_GSProom1.bin"
YSPSub1Level0CA:
    incbin "lvl/obj/0CA_YSProom2.bin"
RSPSub1Level1D8:
    incbin "lvl/obj/1D8_RSProom2.bin"
BSPSub1Level1D7:
    incbin "lvl/obj/1D7_BSProom2.bin"
GSPSub1Level0C9:
    incbin "lvl/obj/0C9_GSProom2.bin"
TSALevel003:
    incbin "lvl/obj/003_TSA.bin"
YI1Level105:
    incbin "lvl/obj/105_YI1main.bin"
YI1Sub1Level1CB:
    incbin "lvl/obj/1CB_YI1sub.bin"
YI2Level106:
    incbin "lvl/obj/106_YI2main.bin"
YI2Sub1Level1CA:
    incbin "lvl/obj/1CA_YI2sub.bin"
YI3Level103:
    incbin "lvl/obj/103_YI3main.bin"
YI3Sub1Level1FD:
    incbin "lvl/obj/1FD_YI3sub.bin"
YI4Level102:
    incbin "lvl/obj/102_YI4main.bin"
YI4Sub2Level1FF:
    incbin "lvl/obj/1FF_YI4end.bin"
YI4Sub1Level1BE:
    incbin "lvl/obj/1BE_YI4sub.bin"
C1Level101:
    incbin "lvl/obj/101_C1room1.bin"
C1Sub1Level1FC:
    incbin "lvl/obj/1FC_C1room2.bin"
DP1Level015:
    incbin "lvl/obj/015_DP1main.bin"
DP1Sub1Level0FD:
    incbin "lvl/obj/0FD_DP1bonus.bin"
DP1Sub2Level0E3:
    incbin "lvl/obj/0E3_DP1sub.bin"
DP2LvlL2009:
    incbin "lvl/obj/009_DP2main_l2.bin"
DP2Level009:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incbin "lvl/obj/009_DP2main_J.bin"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incbin "lvl/obj/009_DP2main_U.bin"        ;!
endif                                         ;/===============================================
DP2Sub1Level0E9:
    incbin "lvl/obj/0E9_DP2sub.bin"
DGHLevel004:
    incbin "lvl/obj/004_DGHroom1.bin"
DGHSub3Level0FA:
    incbin "lvl/obj/0FA_DGHroom4.bin"
DGHSub1Level0F9:
    incbin "lvl/obj/0F9_DGHroom2.bin"
DGHSub2Level0FE:
    incbin "lvl/obj/0FE_DGHroom3.bin"
DGHSub4Level0C4:
    incbin "lvl/obj/0C4_DGHexit.bin"
DP3Level005:
    incbin "lvl/obj/005_DP3main.bin"
DP3Sub1Level0F4:
    incbin "lvl/obj/0F4_DP3bonus.bin"
DP4Level006:
    incbin "lvl/obj/006_DP4main.bin"
DP4Sub1Level0D2:
    incbin "lvl/obj/0D2_DP4sub2.bin"
DP4Sub1Level0C3:
    incbin "lvl/obj/0C3_DP4sub1.bin"
C2Level007:
    incbin "lvl/obj/007_C2room1.bin"
C2Sub2Level0E8:
    incbin "lvl/obj/0E8_C2room2.bin"
C2Sub3LvlL20E7:
    incbin "lvl/obj/0E7_C2room3_l2.bin"
C2Sub3Level0E7:
    incbin "lvl/obj/0E7_C2room3.bin"
C2Sub1Level0E6:
    incbin "lvl/obj/0E6_C2bonus.bin"
DS1Level00A:
    incbin "lvl/obj/00A_DS1main.bin"
DS1Sub1Level0C2:
    incbin "lvl/obj/0C2_DS1sub.bin"
if ver_is_japanese(!_VER)                     ;\======================= J =====================
DSHLevel013:                                  ;!
    incbin "lvl/obj/013_DSHroom1_J.bin"       ;!
DSHSub1Level0ED:                              ;!
    incbin "lvl/obj/0ED_DSHroom2_J.bin"       ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
DSHLevel013:                                  ;!
    incbin "lvl/obj/013_DSHroom1_U.bin"       ;!
DSHSub1Level0ED:                              ;!
    incbin "lvl/obj/0ED_DSHroom2_U.bin"       ;!
endif                                         ;/===============================================
DSHSub2Level0F1:
    incbin "lvl/obj/0F1_DSHroom3.bin"
DSHSub4Level0E4:
    incbin "lvl/obj/0E4_DSHroom4.bin"
DS2Level10B:
    incbin "lvl/obj/10B_DS2main.bin"
DS2Sub1Level1C6:
    incbin "lvl/obj/1C6_DS2sub.bin"

    %insert_empty($4A,$47,$47,$47,$47)

VD1Level11A:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incbin "lvl/obj/11A_VD1main_J.bin"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incbin "lvl/obj/11A_VD1main_U.bin"        ;!
endif                                         ;/===============================================
VD1Sub1Level1EF:
    incbin "lvl/obj/1EF_VD1sub.bin"
VD1Sub1LvlL21EF:
    incbin "lvl/obj/1EF_VD1sub_l2.bin"
VD2Level118:
    incbin "lvl/obj/118_VD2main.bin"
VD2Sub1Level1C3:
    incbin "lvl/obj/1C3_VD2sub.bin"
VGHLevel107:
    incbin "lvl/obj/107_VGHroom1.bin"
VGHSub1Level1EA:
    incbin "lvl/obj/1EA_VGHroom2.bin"
VD3Level10A:
    incbin "lvl/obj/10A_VD3main.bin"
VD3Sub2Level1C2:
    incbin "lvl/obj/1C2_VD3sub.bin"
VD3Sub1Level1F7:
    incbin "lvl/obj/1F7_VD3bonus.bin"
VD4Level119:
    incbin "lvl/obj/119_VD4main.bin"
VD4Sub1Level1F5:
    incbin "lvl/obj/1F5_VD4sub.bin"
C3Level11C:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incbin "lvl/obj/11C_C3room1_J.bin"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incbin "lvl/obj/11C_C3room1_U.bin"        ;!
endif                                         ;/===============================================
C3Sub1Level1F4:
    incbin "lvl/obj/1F4_C3room2.bin"
C3Sub2Level1F3:
    incbin "lvl/obj/1F3_C3room3.bin"
C3Sub2LvlL21F3:
    incbin "lvl/obj/1F3_C3room3_l2.bin"
C3Sub3Level1F2:
    incbin "lvl/obj/1F2_C3room4.bin"
VS1Level109:
    incbin "lvl/obj/109_VS1main.bin"
VS1Sub1Level1F1:
    incbin "lvl/obj/1F1_VS1end1.bin"
VS1Sub2Level1F0:
    incbin "lvl/obj/1F0_VS1end2.bin"
VS2Level001:
    incbin "lvl/obj/001_VS2main.bin"
VS2Sub1Level0D8:
    incbin "lvl/obj/0D8_VS2sub.bin"
VS3Level002:
    incbin "lvl/obj/002_VS3main.bin"
VS3Sub1Level0CB:
    incbin "lvl/obj/0CB_VS3end.bin"
VFLevel00B:
    incbin "lvl/obj/00B_VFroom1.bin"
VFSub1Level0E0:
    incbin "lvl/obj/0E0_VFroom2.bin"
CBALevel00F:
    incbin "lvl/obj/00F_CBAmain.bin"
CBASub1Level0BF:
    incbin "lvl/obj/0BF_CBAsub.bin"
CMLevel010:
    incbin "lvl/obj/010_CMmain.bin"
CMSub1Level0C1:
    incbin "lvl/obj/0C1_CMsub.bin"
C4Level00E:
    incbin "lvl/obj/00E_C4room1.bin"
C4LvlL200E:
    incbin "lvl/obj/00E_C4room1_l2.bin"
C4Sub2Level0DC:
    incbin "lvl/obj/0DC_C4room2.bin"
C4Sub2LvlL20DC:
    incbin "lvl/obj/0DC_C4room2_l2.bin"
C4Sub3Level0DB:
    incbin "lvl/obj/0DB_C4room3.bin"
C4Sub1Level0DA:
    incbin "lvl/obj/0DA_C4bonus.bin"
SLLevel011:
    incbin "lvl/obj/011_SLmain.bin"
SLSub1Level0C6:
    incbin "lvl/obj/0C6_SLend.bin"

    %insert_empty($69F,$69C,$69C,$69C,$69C)

BB1Level00C:
    incbin "lvl/obj/00C_BB1main.bin"
BB1Sub1Level0F3:
    incbin "lvl/obj/0F3_BB1end.bin"
BB2Level00D:
    incbin "lvl/obj/00D_BB2main.bin"
BB2Sub1Level0DD:
    incbin "lvl/obj/0DD_BB2sub.bin"
FoI1Level11E:
    incbin "lvl/obj/11E_FoI1.bin"
FoI2Level120:
    incbin "lvl/obj/120_FoI2.bin"
FoI3Level123:
    incbin "lvl/obj/123_FoI3main.bin"
FoI3Sub2Level1F8:
    incbin "lvl/obj/1F8_FoI3sub.bin"
FoI3Sub1Level1BC:
    incbin "lvl/obj/1BC_FoI3bonus.bin"
C5Level020:
    incbin "lvl/obj/020_C5room1.bin"
FGHLevel11D:
    incbin "lvl/obj/11D_FGHroom1.bin"
FGHLvlL211D:
    incbin "lvl/obj/11D_FGHroom1_l2.bin"
FGHSub1Level1FA:
    incbin "lvl/obj/1FA_FGHroom2.bin"
FGHSub2Level1E6:
    incbin "lvl/obj/1E6_FGHend.bin"
FoI4Level11F:
    incbin "lvl/obj/11F_FoI4main.bin"
FoI4Sub2Level1DF:
    incbin "lvl/obj/1DF_FoI4sub2.bin"
FoI4Sub1Level1C1:
    incbin "lvl/obj/1C1_FoI4sub1.bin"
FSALevel122:
    incbin "lvl/obj/122_FSA.bin"
FFLevel01F:
    incbin "lvl/obj/01F_FFroom1.bin"
FFSub1Level0D6:
    incbin "lvl/obj/0D6_FFroom2.bin"
CI1Level022:
    incbin "lvl/obj/022_CI1main1.bin"
CI1Sub1Level0F5:
    incbin "lvl/obj/0F5_CI1main2.bin"
CI1Sub2Level0BE:
    incbin "lvl/obj/0BE_CI1sub.bin"
CGHLevel021:
    incbin "lvl/obj/021_CGHroom1.bin"
CGHSub1Level0FC:
    incbin "lvl/obj/0FC_CGHroom2.bin"
CI2Level024:
    incbin "lvl/obj/024_CI2room1.bin"
CI2Sub3Level0CF:
    incbin "lvl/obj/0CF_CI2room2c.bin"
CI2Sub2Level6E9FB:
    incbin "lvl/obj/0CF_CI2room2b.bin"
CI2Sub1Level6EAB0:
    incbin "lvl/obj/0CF_CI2room2a.bin"
CI2Sub4Level0CE:
    incbin "lvl/obj/0CE_CI2room3c.bin"
CI2Sub5Level6EB72:
    incbin "lvl/obj/0CE_CI2room3b.bin"
CI2Sub6Level6EBBE:
    incbin "lvl/obj/0CE_CI2room3a.bin"
CI2Sub8Level0CD:
    incbin "lvl/obj/0CD_CI2room4b.bin"
CI2Sub7Level6EC7E:
    incbin "lvl/obj/0CD_CI2room4a.bin"
CI3Level023:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incbin "lvl/obj/023_CI3main_J.bin"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incbin "lvl/obj/023_CI3main_U.bin"        ;!
endif                                         ;/===============================================
CI3Sub1Level0D7:
    incbin "lvl/obj/0D7_CI3sub.bin"
CFLevel01B:
    incbin "lvl/obj/01B_CFroom1.bin"
CFSub1Level0EF:
    incbin "lvl/obj/0EF_CFroom2.bin"
CSLevel117:
    incbin "lvl/obj/117_CSroom1.bin"
CSSub2Level1ED:
    incbin "lvl/obj/1ED_CSroom2.bin"
CSSub3Level1EC:
    incbin "lvl/obj/1EC_CSroom3.bin"
CSSub3LvlL21EC:
    incbin "lvl/obj/1EC_CSroom3_l2.bin"
CSSub4Level1EE:
    incbin "lvl/obj/1EE_CSend.bin"
CSSub1Level1C0:
    incbin "lvl/obj/1C0_CSsub.bin"

    %insert_empty($ACD,$AC7,$AC7,$AC7,$AC7)