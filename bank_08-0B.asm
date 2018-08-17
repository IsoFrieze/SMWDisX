                      check bankcross off                 ;;                   ;
                                                          ;;                   ;
                      ORG $088000                         ;;                   ;
                                                          ;;                   ;
                   if !_VER == 0                ;\   IF   ;;+++++++++++++++++++; J
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/j/GFX32_comp.bin"       ;;8000               ; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/j/GFX33_comp.bin"       ;;BFC0               ; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/j/GFX00_comp.bin"       ;;D9FC               ; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/j/GFX01_comp.bin"       ;;E234               ; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/j/GFX02_comp.bin"       ;;ECBF               ; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/j/GFX03_comp.bin"       ;;F559               ; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/j/GFX04_comp.bin"       ;;FF8D               ; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/j/GFX05_comp.bin"       ;;8976               ; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/j/GFX06_comp.bin"       ;;9386               ; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/j/GFX07_comp.bin"       ;;9D28               ; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/j/GFX08_comp.bin"       ;;A672               ; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/j/GFX09_comp.bin"       ;;AFB6               ; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/j/GFX0A_comp.bin"       ;;BA2A               ; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/j/GFX0B_comp.bin"       ;;C3B0               ; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/j/GFX0C_comp.bin"       ;;CD77               ; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/j/GFX0D_comp.bin"       ;;D5E8               ; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/j/GFX0E_comp.bin"       ;;DDAB               ; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/j/GFX0F_comp.bin"       ;;E6C7               ; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/j/GFX10_comp.bin"       ;;EF08               ; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/j/GFX11_comp.bin"       ;;F79C               ; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/j/GFX12_comp.bin"       ;;FFAA               ; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/j/GFX13_comp.bin"       ;;88FE               ; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/j/GFX14_comp.bin"       ;;9339               ; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/j/GFX15_comp.bin"       ;;9ADF               ; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/j/GFX16_comp.bin"       ;;A36B               ; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/j/GFX17_comp.bin"       ;;A9B6               ; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/j/GFX18_comp.bin"       ;;B2B4               ; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/j/GFX19_comp.bin"       ;;BBEB               ; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/j/GFX1A_comp.bin"       ;;C393               ; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/j/GFX1B_comp.bin"       ;;CC79               ; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/j/GFX1C_comp.bin"       ;;D491               ; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/j/GFX1D_comp.bin"       ;;DC9B               ; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/j/GFX1E_comp.bin"       ;;E691               ; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/j/GFX1F_comp.bin"       ;;EE55               ; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/j/GFX20_comp.bin"       ;;F6BF               ; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/j/GFX21_comp.bin"       ;;FF89               ; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/j/GFX22_comp.bin"       ;;88F3               ; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/j/GFX23_comp.bin"       ;;91F1               ; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/j/GFX24_comp.bin"       ;;9B0E               ; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/j/GFX25_comp.bin"       ;;A3DE               ; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/j/GFX26_comp.bin"       ;;AE4A               ; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/j/GFX27_comp.bin"       ;;B770               ; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/j/GFX28_comp.bin"       ;;C09D               ; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/j/GFX29_comp.bin"       ;;C6E4               ; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/j/GFX2A_comp.bin"       ;;CC2E               ; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/j/GFX2B_comp.bin"       ;;D27F               ; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/j/GFX2C_comp.bin"       ;;D92A               ; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/j/GFX2D_comp.bin"       ;;E17B               ; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/j/GFX2E_comp.bin"       ;;EAAB               ; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/j/GFX2F_comp.bin"       ;;F2FA               ; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/j/GFX30_comp.bin"       ;;F530               ; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/j/GFX31_comp.bin"       ;;F975               ; Special Beaten Enemies
                   elseif !_VER != 3            ;< ELSEIF ;;-------------------; U & E0
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/u/GFX32_comp.bin"       ;;    |8000/8000     ; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/u/GFX33_comp.bin"       ;;    |BFC0/BFC0     ; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/u/GFX00_comp.bin"       ;;    |D9F9/D9F9     ; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/u/GFX01_comp.bin"       ;;    |E231/E231     ; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/u/GFX02_comp.bin"       ;;    |ECBB/ECBB     ; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/u/GFX03_comp.bin"       ;;    |F552/F552     ; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/u/GFX04_comp.bin"       ;;    |FF7D/FF7D     ; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/u/GFX05_comp.bin"       ;;    |8963/8963     ; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/u/GFX06_comp.bin"       ;;    |936C/936C     ; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/u/GFX07_comp.bin"       ;;    |9D10/9D10     ; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/u/GFX08_comp.bin"       ;;    |A657/A657     ; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/u/GFX09_comp.bin"       ;;    |AFA1/AFA1     ; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/u/GFX0A_comp.bin"       ;;    |BA15/BA15     ; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/u/GFX0B_comp.bin"       ;;    |C39C/C39C     ; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/u/GFX0C_comp.bin"       ;;    |CD63/CD63     ; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/u/GFX0D_comp.bin"       ;;    |D5D2/D5D2     ; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/u/GFX0E_comp.bin"       ;;    |DDCB/DDCB     ; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/u/GFX0F_comp.bin"       ;;    |E6E5/E6E5     ; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/u/GFX10_comp.bin"       ;;    |EF1E/EF1E     ; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/u/GFX11_comp.bin"       ;;    |F7AF/F7AF     ; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/u/GFX12_comp.bin"       ;;    |FFBD/FFBD     ; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/u/GFX13_comp.bin"       ;;    |8910/8910     ; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/u/GFX14_comp.bin"       ;;    |9348/9348     ; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/u/GFX15_comp.bin"       ;;    |9AE8/9AE8     ; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/u/GFX16_comp.bin"       ;;    |A374/A374     ; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/u/GFX17_comp.bin"       ;;    |A9B4/A9B4     ; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/u/GFX18_comp.bin"       ;;    |B2AD/B2AD     ; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/u/GFX19_comp.bin"       ;;    |BBE4/BBE4     ; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/u/GFX1A_comp.bin"       ;;    |C380/C380     ; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/u/GFX1B_comp.bin"       ;;    |CC66/CC66     ; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/u/GFX1C_comp.bin"       ;;    |D47E/D47E     ; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/u/GFX1D_comp.bin"       ;;    |DC88/DC88     ; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/u/GFX1E_comp.bin"       ;;    |E67F/E67F     ; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/u/GFX1F_comp.bin"       ;;    |EE43/EE43     ; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/u/GFX20_comp.bin"       ;;    |F6A1/F6A1     ; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/u/GFX21_comp.bin"       ;;    |FF65/FF65     ; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/u/GFX22_comp.bin"       ;;    |88CD/88CD     ; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/u/GFX23_comp.bin"       ;;    |91CA/91CA     ; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/u/GFX24_comp.bin"       ;;    |9AE5/9AE5     ; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/u/GFX25_comp.bin"       ;;    |A3B5/A3B5     ; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/u/GFX26_comp.bin"       ;;    |AE21/AE21     ; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/u/GFX27_comp.bin"       ;;    |B744/B744     ; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/u/GFX28_comp.bin"       ;;    |C06C/C06C     ; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/u/GFX29_comp.bin"       ;;    |C6A3/C6A3     ; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/u/GFX2A_comp.bin"       ;;    |CB7B/CB7B     ; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/u/GFX2B_comp.bin"       ;;    |D0F0/D0F0     ; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/u/GFX2C_comp.bin"       ;;    |D7B9/D7B9     ; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/u/GFX2D_comp.bin"       ;;    |E006/E006     ; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/u/GFX2E_comp.bin"       ;;    |E936/E936     ; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/u/GFX2F_comp.bin"       ;;    |F185/F185     ; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/u/GFX30_comp.bin"       ;;    |F3BB/F3BB     ; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/u/GFX31_comp.bin"       ;;    |F800/F800     ; Special Beaten Enemies
                   else                         ;<  ELSE  ;;-------------------; E1
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/e/GFX32_comp.bin"       ;;              \8000; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/e/GFX33_comp.bin"       ;;              \BFC0; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/e/GFX00_comp.bin"       ;;              \D9FC; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/e/GFX01_comp.bin"       ;;              \E234; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/e/GFX02_comp.bin"       ;;              \ECBF; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/e/GFX03_comp.bin"       ;;              \F559; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/e/GFX04_comp.bin"       ;;              \FF8D; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/e/GFX05_comp.bin"       ;;              \8976; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/e/GFX06_comp.bin"       ;;              \9386; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/e/GFX07_comp.bin"       ;;              \9D28; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/e/GFX08_comp.bin"       ;;              \A672; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/e/GFX09_comp.bin"       ;;              \AFBF; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/e/GFX0A_comp.bin"       ;;              \BA33; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/e/GFX0B_comp.bin"       ;;              \C3B9; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/e/GFX0C_comp.bin"       ;;              \CD80; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/e/GFX0D_comp.bin"       ;;              \D5F1; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/e/GFX0E_comp.bin"       ;;              \DDE9; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/e/GFX0F_comp.bin"       ;;              \E705; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/e/GFX10_comp.bin"       ;;              \EF46; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/e/GFX11_comp.bin"       ;;              \F7D7; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/e/GFX12_comp.bin"       ;;              \FFE5; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/e/GFX13_comp.bin"       ;;              \8939; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/e/GFX14_comp.bin"       ;;              \9374; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/e/GFX15_comp.bin"       ;;              \9B1A; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/e/GFX16_comp.bin"       ;;              \A3A6; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/e/GFX17_comp.bin"       ;;              \A9F1; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/e/GFX18_comp.bin"       ;;              \B2EF; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/e/GFX19_comp.bin"       ;;              \BC26; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/e/GFX1A_comp.bin"       ;;              \C3CE; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/e/GFX1B_comp.bin"       ;;              \CCB4; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/e/GFX1C_comp.bin"       ;;              \D4CC; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/e/GFX1D_comp.bin"       ;;              \DCD6; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/e/GFX1E_comp.bin"       ;;              \E6CC; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/e/GFX1F_comp.bin"       ;;              \EE90; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/e/GFX20_comp.bin"       ;;              \F6FA; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/e/GFX21_comp.bin"       ;;              \FFC4; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/e/GFX22_comp.bin"       ;;              \892E; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/e/GFX23_comp.bin"       ;;              \922C; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/e/GFX24_comp.bin"       ;;              \9B49; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/e/GFX25_comp.bin"       ;;              \A419; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/e/GFX26_comp.bin"       ;;              \AE85; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/e/GFX27_comp.bin"       ;;              \B7AB; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/e/GFX28_comp.bin"       ;;              \C0DD; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/e/GFX29_comp.bin"       ;;              \C714; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/e/GFX2A_comp.bin"       ;;              \CBEA; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/e/GFX2B_comp.bin"       ;;              \D16E; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/e/GFX2C_comp.bin"       ;;              \D843; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/e/GFX2D_comp.bin"       ;;              \E094; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/e/GFX2E_comp.bin"       ;;              \E9C4; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/e/GFX2F_comp.bin"       ;;              \F213; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/e/GFX30_comp.bin"       ;;              \F449; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/e/GFX31_comp.bin"       ;;              \F88E; Special Beaten Enemies
                   endif                        ;/ ENDIF  ;;+++++++++++++++++++;
                                                          ;;                   ;
                      padbyte $FF : pad $8C8000           ;;FE82|FD0D/FD0D\FD9B; asar bug thinks its FastROM when bankcross check is disabled
                                                          ;;                   ;
                      check bankcross on                  ;;                   ;