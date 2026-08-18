    ORG $068000

TestLevel:
    incsrc "lvl/obj/testlevel.asm"
CloudsBetaLevel:
    incsrc "lvl/obj/betaclouds.asm"
MushroomBetaLevel:
    incsrc "lvl/obj/betamushrooms.asm"
BossTestBetaLevel:
    incsrc "lvl/obj/betabosstest.asm"
BowserCopyLevel:
    incsrc "lvl/obj/1C7_bowser.asm"
Mode7BossCopyLevel:
    incsrc "lvl/obj/mode7boss2.asm"
LarryIggyCopyLevel:
    incsrc "lvl/obj/iggylarryroom.asm"
LavaCaveBetaLvlL2:
    incsrc "lvl/obj/betalavacave_l2.asm"
LavaCaveBetaLevel:
    incsrc "lvl/obj/betalavacave.asm"
TwinBlockBetaLevel:
    incsrc "lvl/obj/betatwinblocks.asm"
WendyBetaLevel:
    incsrc "lvl/obj/betaC6room1.asm"
WendyBetaLvlL2:
    incsrc "lvl/obj/betaC6room1_l2.asm"
GroundBetaLevel:
    incsrc "lvl/obj/betajustground.asm"
LemmyCopyLevel:
    incsrc "lvl/obj/1F2_C3room4.asm"
WendyCopyLevel:
    incsrc "lvl/obj/0D3_C6room3.asm"
TitleScrLevel0C7:
    incsrc "lvl/obj/0C7_titlescreen.asm"
IntroLevel0C5:
    incsrc "lvl/obj/0C5_introcutscene.asm"
GhostHouseExitLvlL2:
    incsrc "lvl/obj/ghosthouseexit_l2.asm"
GhostHouseExitLevel:
    incsrc "lvl/obj/ghosthouseexit.asm"
Mode7BossLayer1:
    incsrc "lvl/obj/mode7boss1.asm"
DP2Sub2Level0FF:
    incsrc "lvl/obj/0FF_DP2end.asm"
BonusGameLevel:
    incsrc "lvl/obj/bonusgame.asm"
UnusedGHExitLevel:
    incsrc "lvl/obj/unusedghexit1.asm"
LarryIggyLevel:
    incsrc "lvl/obj/iggylarryroom.asm"
YSPLevel014:
    incsrc "lvl/obj/014_YSProom1.asm"
RSPLevel11B:
    incsrc "lvl/obj/11B_RSProom1.asm"
BSPLevel121:
    incsrc "lvl/obj/121_BSProom1.asm"
GSPLevel008:
    incsrc "lvl/obj/008_GSProom1.asm"
YSPSub1Level0CA:
    incsrc "lvl/obj/0CA_YSProom2.asm"
RSPSub1Level1D8:
    incsrc "lvl/obj/1D8_RSProom2.asm"
BSPSub1Level1D7:
    incsrc "lvl/obj/1D7_BSProom2.asm"
GSPSub1Level0C9:
    incsrc "lvl/obj/0C9_GSProom2.asm"
TSALevel003:
    incsrc "lvl/obj/003_TSA.asm"
YI1Level105:
    incsrc "lvl/obj/105_YI1main.asm"
YI1Sub1Level1CB:
    incsrc "lvl/obj/1CB_YI1sub.asm"
YI2Level106:
    incsrc "lvl/obj/106_YI2main.asm"
YI2Sub1Level1CA:
    incsrc "lvl/obj/1CA_YI2sub.asm"
YI3Level103:
    incsrc "lvl/obj/103_YI3main.asm"
YI3Sub1Level1FD:
    incsrc "lvl/obj/1FD_YI3sub.asm"
YI4Level102:
    incsrc "lvl/obj/102_YI4main.asm"
YI4Sub2Level1FF:
    incsrc "lvl/obj/1FF_YI4end.asm"
YI4Sub1Level1BE:
    incsrc "lvl/obj/1BE_YI4sub.asm"
C1Level101:
    incsrc "lvl/obj/101_C1room1.asm"
C1Sub1Level1FC:
    incsrc "lvl/obj/1FC_C1room2.asm"
DP1Level015:
    incsrc "lvl/obj/015_DP1main.asm"
DP1Sub1Level0FD:
    incsrc "lvl/obj/0FD_DP1bonus.asm"
DP1Sub2Level0E3:
    incsrc "lvl/obj/0E3_DP1sub.asm"
DP2LvlL2009:
    incsrc "lvl/obj/009_DP2main_l2.asm"
DP2Level009:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incsrc "lvl/obj/009_DP2main_J.asm"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incsrc "lvl/obj/009_DP2main_U.asm"        ;!
endif                                         ;/===============================================
DP2Sub1Level0E9:
    incsrc "lvl/obj/0E9_DP2sub.asm"
DGHLevel004:
    incsrc "lvl/obj/004_DGHroom1.asm"
DGHSub3Level0FA:
    incsrc "lvl/obj/0FA_DGHroom4.asm"
DGHSub1Level0F9:
    incsrc "lvl/obj/0F9_DGHroom2.asm"
DGHSub2Level0FE:
    incsrc "lvl/obj/0FE_DGHroom3.asm"
DGHSub4Level0C4:
    incsrc "lvl/obj/0C4_DGHexit.asm"
DP3Level005:
    incsrc "lvl/obj/005_DP3main.asm"
DP3Sub1Level0F4:
    incsrc "lvl/obj/0F4_DP3bonus.asm"
DP4Level006:
    incsrc "lvl/obj/006_DP4main.asm"
DP4Sub1Level0D2:
    incsrc "lvl/obj/0D2_DP4sub2.asm"
DP4Sub1Level0C3:
    incsrc "lvl/obj/0C3_DP4sub1.asm"
C2Level007:
    incsrc "lvl/obj/007_C2room1.asm"
C2Sub2Level0E8:
    incsrc "lvl/obj/0E8_C2room2.asm"
C2Sub3LvlL20E7:
    incsrc "lvl/obj/0E7_C2room3_l2.asm"
C2Sub3Level0E7:
    incsrc "lvl/obj/0E7_C2room3.asm"
C2Sub1Level0E6:
    incsrc "lvl/obj/0E6_C2bonus.asm"
DS1Level00A:
    incsrc "lvl/obj/00A_DS1main.asm"
DS1Sub1Level0C2:
    incsrc "lvl/obj/0C2_DS1sub.asm"
if ver_is_japanese(!_VER)                     ;\======================= J =====================
DSHLevel013:                                  ;!
    incsrc "lvl/obj/013_DSHroom1_J.asm"       ;!
DSHSub1Level0ED:                              ;!
    incsrc "lvl/obj/0ED_DSHroom2_J.asm"       ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
DSHLevel013:                                  ;!
    incsrc "lvl/obj/013_DSHroom1_U.asm"       ;!
DSHSub1Level0ED:                              ;!
    incsrc "lvl/obj/0ED_DSHroom2_U.asm"       ;!
endif                                         ;/===============================================
DSHSub2Level0F1:
    incsrc "lvl/obj/0F1_DSHroom3.asm"
DSHSub4Level0E4:
    incsrc "lvl/obj/0E4_DSHroom4.asm"
DS2Level10B:
    incsrc "lvl/obj/10B_DS2main.asm"
DS2Sub1Level1C6:
    incsrc "lvl/obj/1C6_DS2sub.asm"

    %insert_empty($4A,$47,$47,$47,$47)

VD1Level11A:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incsrc "lvl/obj/11A_VD1main_J.asm"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incsrc "lvl/obj/11A_VD1main_U.asm"        ;!
endif                                         ;/===============================================
VD1Sub1Level1EF:
    incsrc "lvl/obj/1EF_VD1sub.asm"
VD1Sub1LvlL21EF:
    incsrc "lvl/obj/1EF_VD1sub_l2.asm"
VD2Level118:
    incsrc "lvl/obj/118_VD2main.asm"
VD2Sub1Level1C3:
    incsrc "lvl/obj/1C3_VD2sub.asm"
VGHLevel107:
    incsrc "lvl/obj/107_VGHroom1.asm"
VGHSub1Level1EA:
    incsrc "lvl/obj/1EA_VGHroom2.asm"
VD3Level10A:
    incsrc "lvl/obj/10A_VD3main.asm"
VD3Sub2Level1C2:
    incsrc "lvl/obj/1C2_VD3sub.asm"
VD3Sub1Level1F7:
    incsrc "lvl/obj/1F7_VD3bonus.asm"
VD4Level119:
    incsrc "lvl/obj/119_VD4main.asm"
VD4Sub1Level1F5:
    incsrc "lvl/obj/1F5_VD4sub.asm"
C3Level11C:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incsrc "lvl/obj/11C_C3room1_J.asm"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incsrc "lvl/obj/11C_C3room1_U.asm"        ;!
endif                                         ;/===============================================
C3Sub1Level1F4:
    incsrc "lvl/obj/1F4_C3room2.asm"
C3Sub2Level1F3:
    incsrc "lvl/obj/1F3_C3room3.asm"
C3Sub2LvlL21F3:
    incsrc "lvl/obj/1F3_C3room3_l2.asm"
C3Sub3Level1F2:
    incsrc "lvl/obj/1F2_C3room4.asm"
VS1Level109:
    incsrc "lvl/obj/109_VS1main.asm"
VS1Sub1Level1F1:
    incsrc "lvl/obj/1F1_VS1end1.asm"
VS1Sub2Level1F0:
    incsrc "lvl/obj/1F0_VS1end2.asm"
VS2Level001:
    incsrc "lvl/obj/001_VS2main.asm"
VS2Sub1Level0D8:
    incsrc "lvl/obj/0D8_VS2sub.asm"
VS3Level002:
    incsrc "lvl/obj/002_VS3main.asm"
VS3Sub1Level0CB:
    incsrc "lvl/obj/0CB_VS3end.asm"
VFLevel00B:
    incsrc "lvl/obj/00B_VFroom1.asm"
VFSub1Level0E0:
    incsrc "lvl/obj/0E0_VFroom2.asm"
CBALevel00F:
    incsrc "lvl/obj/00F_CBAmain.asm"
CBASub1Level0BF:
    incsrc "lvl/obj/0BF_CBAsub.asm"
CMLevel010:
    incsrc "lvl/obj/010_CMmain.asm"
CMSub1Level0C1:
    incsrc "lvl/obj/0C1_CMsub.asm"
C4Level00E:
    incsrc "lvl/obj/00E_C4room1.asm"
C4LvlL200E:
    incsrc "lvl/obj/00E_C4room1_l2.asm"
C4Sub2Level0DC:
    incsrc "lvl/obj/0DC_C4room2.asm"
C4Sub2LvlL20DC:
    incsrc "lvl/obj/0DC_C4room2_l2.asm"
C4Sub3Level0DB:
    incsrc "lvl/obj/0DB_C4room3.asm"
C4Sub1Level0DA:
    incsrc "lvl/obj/0DA_C4bonus.asm"
SLLevel011:
    incsrc "lvl/obj/011_SLmain.asm"
SLSub1Level0C6:
    incsrc "lvl/obj/0C6_SLend.asm"

    %insert_empty($69F,$69C,$69C,$69C,$69C)

BB1Level00C:
    incsrc "lvl/obj/00C_BB1main.asm"
BB1Sub1Level0F3:
    incsrc "lvl/obj/0F3_BB1end.asm"
BB2Level00D:
    incsrc "lvl/obj/00D_BB2main.asm"
BB2Sub1Level0DD:
    incsrc "lvl/obj/0DD_BB2sub.asm"
FoI1Level11E:
    incsrc "lvl/obj/11E_FoI1.asm"
FoI2Level120:
    incsrc "lvl/obj/120_FoI2.asm"
FoI3Level123:
    incsrc "lvl/obj/123_FoI3main.asm"
FoI3Sub2Level1F8:
    incsrc "lvl/obj/1F8_FoI3sub.asm"
FoI3Sub1Level1BC:
    incsrc "lvl/obj/1BC_FoI3bonus.asm"
C5Level020:
    incsrc "lvl/obj/020_C5room1.asm"
FGHLevel11D:
    incsrc "lvl/obj/11D_FGHroom1.asm"
FGHLvlL211D:
    incsrc "lvl/obj/11D_FGHroom1_l2.asm"
FGHSub1Level1FA:
    incsrc "lvl/obj/1FA_FGHroom2.asm"
FGHSub2Level1E6:
    incsrc "lvl/obj/1E6_FGHend.asm"
FoI4Level11F:
    incsrc "lvl/obj/11F_FoI4main.asm"
FoI4Sub2Level1DF:
    incsrc "lvl/obj/1DF_FoI4sub2.asm"
FoI4Sub1Level1C1:
    incsrc "lvl/obj/1C1_FoI4sub1.asm"
FSALevel122:
    incsrc "lvl/obj/122_FSA.asm"
FFLevel01F:
    incsrc "lvl/obj/01F_FFroom1.asm"
FFSub1Level0D6:
    incsrc "lvl/obj/0D6_FFroom2.asm"
CI1Level022:
    incsrc "lvl/obj/022_CI1main1.asm"
CI1Sub1Level0F5:
    incsrc "lvl/obj/0F5_CI1main2.asm"
CI1Sub2Level0BE:
    incsrc "lvl/obj/0BE_CI1sub.asm"
CGHLevel021:
    incsrc "lvl/obj/021_CGHroom1.asm"
CGHSub1Level0FC:
    incsrc "lvl/obj/0FC_CGHroom2.asm"
CI2Level024:
    incsrc "lvl/obj/024_CI2room1.asm"
CI2Sub3Level0CF:
    incsrc "lvl/obj/0CF_CI2room2c.asm"
CI2Sub2Level6E9FB:
    incsrc "lvl/obj/0CF_CI2room2b.asm"
CI2Sub1Level6EAB0:
    incsrc "lvl/obj/0CF_CI2room2a.asm"
CI2Sub4Level0CE:
    incsrc "lvl/obj/0CE_CI2room3c.asm"
CI2Sub5Level6EB72:
    incsrc "lvl/obj/0CE_CI2room3b.asm"
CI2Sub6Level6EBBE:
    incsrc "lvl/obj/0CE_CI2room3a.asm"
CI2Sub8Level0CD:
    incsrc "lvl/obj/0CD_CI2room4b.asm"
CI2Sub7Level6EC7E:
    incsrc "lvl/obj/0CD_CI2room4a.asm"
CI3Level023:
if ver_is_japanese(!_VER)                     ;\======================= J =====================
    incsrc "lvl/obj/023_CI3main_J.asm"        ;!
else                                          ;<=============== U, SS, E0, & E1 ===============
    incsrc "lvl/obj/023_CI3main_U.asm"        ;!
endif                                         ;/===============================================
CI3Sub1Level0D7:
    incsrc "lvl/obj/0D7_CI3sub.asm"
CFLevel01B:
    incsrc "lvl/obj/01B_CFroom1.asm"
CFSub1Level0EF:
    incsrc "lvl/obj/0EF_CFroom2.asm"
CSLevel117:
    incsrc "lvl/obj/117_CSroom1.asm"
CSSub2Level1ED:
    incsrc "lvl/obj/1ED_CSroom2.asm"
CSSub3Level1EC:
    incsrc "lvl/obj/1EC_CSroom3.asm"
CSSub3LvlL21EC:
    incsrc "lvl/obj/1EC_CSroom3_l2.asm"
CSSub4Level1EE:
    incsrc "lvl/obj/1EE_CSend.asm"
CSSub1Level1C0:
    incsrc "lvl/obj/1C0_CSsub.asm"

    %insert_empty($ACD,$AC7,$AC7,$AC7,$AC7)