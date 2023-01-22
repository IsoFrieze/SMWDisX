;--------------------;
; HARDWARE REGISTERS ;
;--------------------;

ORG $002100

HW_INIDISP: skip 1
HW_OBJSEL: skip 1
HW_OAMADD: skip 2
HW_OAMDATA: skip 1
HW_BGMODE: skip 1
HW_MOSAIC: skip 1
HW_BG1SC: skip 1
HW_BG2SC: skip 1
HW_BG3SC: skip 1
HW_BG4SC: skip 1
HW_BG12NBA: skip 1
HW_BG34NBA: skip 1
HW_BG1HOFS: skip 1
HW_BG1VOFS: skip 1
HW_BG2HOFS: skip 1
HW_BG2VOFS: skip 1
HW_BG3HOFS: skip 1
HW_BG3VOFS: skip 1
HW_BG4HOFS: skip 1
HW_BG4VOFS: skip 1
HW_VMAINC: skip 1
HW_VMADD: skip 2
HW_VMDATA: skip 2
HW_M7SEL: skip 1
HW_M7A: skip 1
HW_M7B: skip 1
HW_M7C: skip 1
HW_M7D: skip 1
HW_M7X: skip 1
HW_M7Y: skip 1
HW_CGADD: skip 1
HW_CGDATA: skip 1
HW_W12SEL: skip 1
HW_W34SEL: skip 1
HW_WOBJSEL: skip 1
HW_WH0: skip 1
HW_WH1: skip 1
HW_WH2: skip 1
HW_WH3: skip 1
HW_WBGLOG: skip 1
HW_WOBJLOG: skip 1
HW_TM: skip 1
HW_TS: skip 1
HW_TMW: skip 1
HW_TSW: skip 1
HW_CGSWSEL: skip 1
HW_CGADSUB: skip 1
HW_COLDATA: skip 1
HW_SETINI: skip 1
HW_MPY: skip 3
HW_SLHV: skip 1
HW_ROAMDATA: skip 1
HW_RVMDATA: skip 2
HW_RCGDATA: skip 1
HW_OPHCT: skip 1
HW_OPVCT: skip 1
HW_STAT77: skip 1
HW_STAT78: skip 1
HW_APUIO0: skip 1
HW_APUIO1: skip 1
HW_APUIO2: skip 1
HW_APUIO3: skip 1

ORG $002180

HW_WMDATA: skip 1
HW_WMADD: skip 3

ORG $004016

HW_JOY1: skip 1
HW_JOY2: skip 1

ORG $004200

HW_NMITIMEN: skip 1
HW_WRIO: skip 1
HW_WRMPYA: skip 1
HW_WRMPYB: skip 1
HW_WRDIV: skip 2
HW_WRDIVB: skip 1
HW_HTIME: skip 2
HW_VTIME: skip 2
HW_MDMAEN: skip 1
HW_HDMAEN: skip 1
HW_MEMSEL: skip 1

ORG $004210

HW_RDNMI: skip 1
HW_TIMEUP: skip 1
HW_HVBJOY: skip 1
HW_RDIO: skip 1
HW_RDDIV: skip 2
HW_RDMPY: skip 2
HW_CNTRL1: skip 2
HW_CNTRL2: skip 2
HW_CNTRL3: skip 2
HW_CNTRL4: skip 2

ORG $004300

HW_DMAPARAM: skip 1
HW_DMAREG: skip 1
HW_DMAADDR: skip 3
HW_DMACNT: skip 2
HW_HDMABANK: skip 1
HW_DMAIDX: skip 2
HW_HDMALINES: skip 1


; DSP REGISTERS

ORG $000000

DSP_VoVOLL: skip 1
DSP_VoVOLR: skip 1
DSP_VoPITCH: skip 2
DSP_VoSRCN: skip 1
DSP_VoADSR: skip 2
DSP_VoGAIN: skip 1
DSP_VoENVX: skip 1
DSP_VoOUTX: skip 1
skip 2
DSP_MVOLL: skip 1
DSP_EFB: skip 1
skip 1
DSP_FFC: skip 1
skip 12
DSP_MVOLR: skip 1
skip 15
DSP_EVOLL: skip 1
DSP_PMON: skip 1
skip 14
DSP_EVOLR: skip 1
DSP_NON: skip 1
skip 14
DSP_KON: skip 1
DSP_EON: skip 1
skip 14
DSP_KOFF: skip 1
DSP_DIR: skip 1
skip 14
DSP_FLG: skip 1
DSP_ESA: skip 1
skip 14
DSP_ENDX: skip 1
DSP_EDL: skip 1
