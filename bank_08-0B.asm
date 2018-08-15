                      check bankcross off                 ;;                   ;
                                                          ;;                   ;
                      ORG $088000                         ;;                   ;
                                                          ;;                   ;
                   if !_VER == 0                ;\   IF   ;;+++++++++++++++++++; J
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/j/GFX32_comp.bin"       ;;8000|----/----\----; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/j/GFX33_comp.bin"       ;;BFC0|----/----\----; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/j/GFX00_comp.bin"       ;;D9F9|----/----\----; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/j/GFX01_comp.bin"       ;;E231|----/----\----; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/j/GFX02_comp.bin"       ;;ECBB|----/----\----; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/j/GFX03_comp.bin"       ;;F552|----/----\----; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/j/GFX04_comp.bin"       ;;FF7D|----/----\----; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/j/GFX05_comp.bin"       ;;8963|----/----\----; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/j/GFX06_comp.bin"       ;;936C|----/----\----; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/j/GFX07_comp.bin"       ;;9D10|----/----\----; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/j/GFX08_comp.bin"       ;;A657|----/----\----; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/j/GFX09_comp.bin"       ;;AFA1|----/----\----; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/j/GFX0A_comp.bin"       ;;BA15|----/----\----; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/j/GFX0B_comp.bin"       ;;C39C|----/----\----; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/j/GFX0C_comp.bin"       ;;CD63|----/----\----; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/j/GFX0D_comp.bin"       ;;D5D2|----/----\----; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/j/GFX0E_comp.bin"       ;;DDCB|----/----\----; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/j/GFX0F_comp.bin"       ;;E6E5|----/----\----; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/j/GFX10_comp.bin"       ;;EF1E|----/----\----; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/j/GFX11_comp.bin"       ;;F7AF|----/----\----; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/j/GFX12_comp.bin"       ;;FFBD|----/----\----; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/j/GFX13_comp.bin"       ;;8910|----/----\----; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/j/GFX14_comp.bin"       ;;9348|----/----\----; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/j/GFX15_comp.bin"       ;;9AE8|----/----\----; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/j/GFX16_comp.bin"       ;;A374|----/----\----; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/j/GFX17_comp.bin"       ;;A9B4|----/----\----; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/j/GFX18_comp.bin"       ;;B2AD|----/----\----; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/j/GFX19_comp.bin"       ;;BBE4|----/----\----; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/j/GFX1A_comp.bin"       ;;C380|----/----\----; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/j/GFX1B_comp.bin"       ;;CC66|----/----\----; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/j/GFX1C_comp.bin"       ;;D47E|----/----\----; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/j/GFX1D_comp.bin"       ;;DC88|----/----\----; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/j/GFX1E_comp.bin"       ;;E67F|----/----\----; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/j/GFX1F_comp.bin"       ;;EE43|----/----\----; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/j/GFX20_comp.bin"       ;;F6A1|----/----\----; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/j/GFX21_comp.bin"       ;;FF65|----/----\----; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/j/GFX22_comp.bin"       ;;88CD|----/----\----; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/j/GFX23_comp.bin"       ;;91CA|----/----\----; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/j/GFX24_comp.bin"       ;;9AE5|----/----\----; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/j/GFX25_comp.bin"       ;;A3B5|----/----\----; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/j/GFX26_comp.bin"       ;;AE21|----/----\----; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/j/GFX27_comp.bin"       ;;B744|----/----\----; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/j/GFX28_comp.bin"       ;;C06C|----/----\----; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/j/GFX29_comp.bin"       ;;C6A3|----/----\----; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/j/GFX2A_comp.bin"       ;;CB7B|----/----\----; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/j/GFX2B_comp.bin"       ;;D0F0|----/----\----; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/j/GFX2C_comp.bin"       ;;D7B9|----/----\----; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/j/GFX2D_comp.bin"       ;;E006|----/----\----; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/j/GFX2E_comp.bin"       ;;E936|----/----\----; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/j/GFX2F_comp.bin"       ;;F185|----/----\----; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/j/GFX30_comp.bin"       ;;F3BB|----/----\----; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/j/GFX31_comp.bin"       ;;F800|----/----\----; Special Beaten Enemies
                   else                         ;<  ELSE  ;;-------------------; U, E0, & E1
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/u/GFX32_comp.bin"       ;;8000     /----\----; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/u/GFX33_comp.bin"       ;;BFC0     /----\----; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/u/GFX00_comp.bin"       ;;D9F9     /----\----; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/u/GFX01_comp.bin"       ;;E231     /----\----; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/u/GFX02_comp.bin"       ;;ECBB     /----\----; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/u/GFX03_comp.bin"       ;;F552     /----\----; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/u/GFX04_comp.bin"       ;;FF7D     /----\----; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/u/GFX05_comp.bin"       ;;8963     /----\----; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/u/GFX06_comp.bin"       ;;936C     /----\----; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/u/GFX07_comp.bin"       ;;9D10     /----\----; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/u/GFX08_comp.bin"       ;;A657     /----\----; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/u/GFX09_comp.bin"       ;;AFA1     /----\----; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/u/GFX0A_comp.bin"       ;;BA15     /----\----; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/u/GFX0B_comp.bin"       ;;C39C     /----\----; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/u/GFX0C_comp.bin"       ;;CD63     /----\----; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/u/GFX0D_comp.bin"       ;;D5D2     /----\----; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/u/GFX0E_comp.bin"       ;;DDCB     /----\----; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/u/GFX0F_comp.bin"       ;;E6E5     /----\----; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/u/GFX10_comp.bin"       ;;EF1E     /----\----; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/u/GFX11_comp.bin"       ;;F7AF     /----\----; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/u/GFX12_comp.bin"       ;;FFBD     /----\----; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/u/GFX13_comp.bin"       ;;8910     /----\----; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/u/GFX14_comp.bin"       ;;9348     /----\----; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/u/GFX15_comp.bin"       ;;9AE8     /----\----; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/u/GFX16_comp.bin"       ;;A374     /----\----; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/u/GFX17_comp.bin"       ;;A9B4     /----\----; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/u/GFX18_comp.bin"       ;;B2AD     /----\----; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/u/GFX19_comp.bin"       ;;BBE4     /----\----; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/u/GFX1A_comp.bin"       ;;C380     /----\----; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/u/GFX1B_comp.bin"       ;;CC66     /----\----; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/u/GFX1C_comp.bin"       ;;D47E     /----\----; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/u/GFX1D_comp.bin"       ;;DC88     /----\----; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/u/GFX1E_comp.bin"       ;;E67F     /----\----; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/u/GFX1F_comp.bin"       ;;EE43     /----\----; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/u/GFX20_comp.bin"       ;;F6A1     /----\----; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/u/GFX21_comp.bin"       ;;FF65     /----\----; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/u/GFX22_comp.bin"       ;;88CD     /----\----; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/u/GFX23_comp.bin"       ;;91CA     /----\----; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/u/GFX24_comp.bin"       ;;9AE5     /----\----; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/u/GFX25_comp.bin"       ;;A3B5     /----\----; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/u/GFX26_comp.bin"       ;;AE21     /----\----; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/u/GFX27_comp.bin"       ;;B744     /----\----; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/u/GFX28_comp.bin"       ;;C06C     /----\----; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/u/GFX29_comp.bin"       ;;C6A3     /----\----; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/u/GFX2A_comp.bin"       ;;CB7B     /----\----; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/u/GFX2B_comp.bin"       ;;D0F0     /----\----; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/u/GFX2C_comp.bin"       ;;D7B9     /----\----; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/u/GFX2D_comp.bin"       ;;E006     /----\----; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/u/GFX2E_comp.bin"       ;;E936     /----\----; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/u/GFX2F_comp.bin"       ;;F185     /----\----; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/u/GFX30_comp.bin"       ;;F3BB     /----\----; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/u/GFX31_comp.bin"       ;;F800     /----\----; Special Beaten Enemies
                   endif                        ;/ ENDIF  ;;+++++++++++++++++++;
                                                          ;;                   ;
                      padbyte $FF : pad $8C8000           ;;FD0D|----/----\----; asar bug thinks its FastROM when bankcross check is disabled
                                                          ;;                   ;
                      check bankcross on                  ;;                   ;