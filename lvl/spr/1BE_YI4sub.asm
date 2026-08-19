%S_Header(0, 0, 0, "horizontal")
%S_Pokey($013, $012)
if ver_is_console(!_VER)                      ;\================ J, U, E0, & E1 ===============
    %S_MessageBlock($01D, $015, 2)
endif                                         ;/===============================================
%S_Pokey($022, $013)
%S_Pokey($032, $010)
%S_End()
