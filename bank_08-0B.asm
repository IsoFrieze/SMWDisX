                      check bankcross off                 ;;                   ;
                                                          ;;                   ;
					  ORG $088000                         ;;                   ;
                                                          ;;                   ;
GFX32:                                                    ;;                   ; (due to asar bug, labels must be on separate lines here...)
                      incbin "gfx/GFX32_compressed.bin"   ;;8000|----/----\----; Mario Graphics
GFX33:                                                    ;;                   ;
                      incbin "gfx/GFX33_compressed.bin"   ;;BFC0|----/----\----; Animated Tile Graphics
GFX00:                                                    ;;                   ;
                      incbin "gfx/GFX00_compressed.bin"   ;;D9F9|----/----\----; Nintendo Presents, Powerups
GFX01:                                                    ;;                   ;
                      incbin "gfx/GFX01_compressed.bin"   ;;E231|----/----\----; Koopa, Goomba
GFX02:                                                    ;;                   ;
                      incbin "gfx/GFX02_compressed.bin"   ;;ECBB|----/----\----; Spiny, Lakitu
GFX03:                                                    ;;                   ;
                      incbin "gfx/GFX03_compressed.bin"   ;;F552|----/----\----; Thwomp, Magikoopa
GFX04:                                                    ;;                   ;
                      incbin "gfx/GFX04_compressed.bin"   ;;FF7D|----/----\----; Buzzy Beetle, Blargg
GFX05:                                                    ;;                   ;
                      incbin "gfx/GFX05_compressed.bin"   ;;8963|----/----\----; Chainsaw, Diggin Chuck
GFX06:                                                    ;;                   ;
                      incbin "gfx/GFX06_compressed.bin"   ;;936C|----/----\----; Urchin, Dolphin
GFX07:                                                    ;;                   ;
                      incbin "gfx/GFX07_compressed.bin"   ;;9D10|----/----\----; Ghost House Tiles
GFX08:                                                    ;;                   ;
                      incbin "gfx/GFX08_compressed.bin"   ;;A657|----/----\----; Yoshi's House Tiles
GFX09:                                                    ;;                   ;
                      incbin "gfx/GFX09_compressed.bin"   ;;AFA1|----/----\----; Sumo Bro, Pokey
GFX0A:                                                    ;;                   ;
                      incbin "gfx/GFX0A_compressed.bin"   ;;BA15|----/----\----; Wendy, Lemmy
GFX0B:                                                    ;;                   ;
                      incbin "gfx/GFX0B_compressed.bin"   ;;C39C|----/----\----; Roy, Morton, Ludwig
GFX0C:                                                    ;;                   ;
                      incbin "gfx/GFX0C_compressed.bin"   ;;CD63|----/----\----; Cave, Ghost House Background
GFX0D:                                                    ;;                   ;
                      incbin "gfx/GFX0D_compressed.bin"   ;;D5D2|----/----\----; Peach, Water Background
GFX0E:                                                    ;;                   ;
                      incbin "gfx/GFX0E_compressed.bin"   ;;DDCB|----/----\----; Ninji, Disco Ball
GFX0F:                                                    ;;                   ;
                      incbin "gfx/GFX0F_compressed.bin"   ;;E6E5|----/----\----; Mario Start, Credits
GFX10:                                                    ;;                   ;
                      incbin "gfx/GFX10_compressed.bin"   ;;EF1E|----/----\----; Overworld Mario
GFX11:                                                    ;;                   ;
                      incbin "gfx/GFX11_compressed.bin"   ;;F7AF|----/----\----; Big Boo, Eerie
GFX12:                                                    ;;                   ;
                      incbin "gfx/GFX12_compressed.bin"   ;;FFBD|----/----\----; Dry Bones, Grinder
GFX13:                                                    ;;                   ;
                      incbin "gfx/GFX13_compressed.bin"   ;;8910|----/----\----; Hammer Bro, Chargin Chuck
GFX14:                                                    ;;                   ;
                      incbin "gfx/GFX14_compressed.bin"   ;;9348|----/----\----; Pipe Tiles, Overworld Animation
GFX15:                                                    ;;                   ;
                      incbin "gfx/GFX15_compressed.bin"   ;;9AE8|----/----\----; Grassy Tiles
GFX16:                                                    ;;                   ;
                      incbin "gfx/GFX16_compressed.bin"   ;;A374|----/----\----; Rope Tiles
GFX17:                                                    ;;                   ;
                      incbin "gfx/GFX17_compressed.bin"   ;;A9B4|----/----\----; Bush, Diagonal Pipe Tiles
GFX18:                                                    ;;                   ;
                      incbin "gfx/GFX18_compressed.bin"   ;;B2AD|----/----\----; Castle Tiles
GFX19:                                                    ;;                   ;
                      incbin "gfx/GFX19_compressed.bin"   ;;BBE4|----/----\----; Forest, Hills Background
GFX1A:                                                    ;;                   ;
                      incbin "gfx/GFX1A_compressed.bin"   ;;C380|----/----\----; Cave Tiles
GFX1B:                                                    ;;                   ;
                      incbin "gfx/GFX1B_compressed.bin"   ;;CC66|----/----\----; Blue Pillars, Castle Background
GFX1C:                                                    ;;                   ;
                      incbin "gfx/GFX1C_compressed.bin"   ;;D47E|----/----\----; Overworld Tiles
GFX1D:                                                    ;;                   ;
                      incbin "gfx/GFX1D_compressed.bin"   ;;DC88|----/----\----; Overworld Tiles
GFX1E:                                                    ;;                   ;
                      incbin "gfx/GFX1E_compressed.bin"   ;;E67F|----/----\----; Overworld Level Icons
GFX1F:                                                    ;;                   ;
                      incbin "gfx/GFX1F_compressed.bin"   ;;EE43|----/----\----; Cloud, Forest Tiles
GFX20:                                                    ;;                   ;
                      incbin "gfx/GFX20_compressed.bin"   ;;F6A1|----/----\----; Rex, Mega Mole
GFX21:                                                    ;;                   ;
                      incbin "gfx/GFX21_compressed.bin"   ;;FF65|----/----\----; Bowser
GFX22:                                                    ;;                   ;
                      incbin "gfx/GFX22_compressed.bin"   ;;88CD|----/----\----; Peach, Ludwig Background
GFX23:                                                    ;;                   ;
                      incbin "gfx/GFX23_compressed.bin"   ;;91CA|----/----\----; Dino Torch, Dino Rhino
GFX24:                                                    ;;                   ;
                      incbin "gfx/GFX24_compressed.bin"   ;;9AE5|----/----\----; Mechakoopa, Bowser Fire
GFX25:                                                    ;;                   ;
                      incbin "gfx/GFX25_compressed.bin"   ;;A3B5|----/----\----; Iggy, Larry, Reznor
GFX26:                                                    ;;                   ;
                      incbin "gfx/GFX26_compressed.bin"   ;;AE21|----/----\----; Credits Yoshi
GFX27:                                                    ;;                   ;
                      incbin "gfx/GFX27_compressed.bin"   ;;B744|----/----\----; Iggy Platform, Reznor Background
GFX28:                                                    ;;                   ;
                      incbin "gfx/GFX28_compressed.bin"   ;;C06C|----/----\----; HUD Letters
GFX29:                                                    ;;                   ;
                      incbin "gfx/GFX29_compressed.bin"   ;;C6A3|----/----\----; Title Screen
GFX2A:                                                    ;;                   ;
                      incbin "gfx/GFX2A_compressed.bin"   ;;CB7B|----/----\----; Message Box Letters
GFX2B:                                                    ;;                   ;
                      incbin "gfx/GFX2B_compressed.bin"   ;;D0F0|----/----\----; Castle Crusher
GFX2C:                                                    ;;                   ;
                      incbin "gfx/GFX2C_compressed.bin"   ;;D7B9|----/----\----; Castle Cutscene Tiles
GFX2D:                                                    ;;                   ;
                      incbin "gfx/GFX2D_compressed.bin"   ;;E006|----/----\----; Castle Cutscene Objects
GFX2E:                                                    ;;                   ;
                      incbin "gfx/GFX2E_compressed.bin"   ;;E936|----/----\----; Credits Thank You
GFX2F:                                                    ;;                   ;
                      incbin "gfx/GFX2F_compressed.bin"   ;;F185|----/----\----; Credits Letters
GFX30:                                                    ;;                   ;
                      incbin "gfx/GFX30_compressed.bin"   ;;F3BB|----/----\----; Mario & Luigi The End
GFX31:                                                    ;;                   ;
                      incbin "gfx/GFX31_compressed.bin"   ;;F800|----/----\----; Special Beaten Enemies
                                                          ;;                   ;
                      padbyte $FF : pad $8C8000           ;;FD0D|----/----\----; asar bug thinks its FastROM when bankcross check is disabled
                                                          ;;                   ;
                      check bankcross on                  ;;                   ;