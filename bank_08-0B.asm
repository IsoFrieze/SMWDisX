    check bankcross off

    ORG $088000

 if ver_is_japanese(!_VER)                    ;\======================== J ====================
GFX32:                                        ;!
    incbin "gfx/j/GFX32_comp.bin"             ;! Mario Graphics
GFX33:                                        ;!
    incbin "gfx/j/GFX33_comp.bin"             ;! Animated Tile Graphics
GFX00:                                        ;!
    incbin "gfx/j/GFX00_comp.bin"             ;! Nintendo Presents, Powerups
GFX01:                                        ;!
    incbin "gfx/j/GFX01_comp.bin"             ;! Koopa, Goomba
GFX02:                                        ;!
    incbin "gfx/j/GFX02_comp.bin"             ;! Spiny, Lakitu
GFX03:                                        ;!
    incbin "gfx/j/GFX03_comp.bin"             ;! Thwomp, Magikoopa
GFX04:                                        ;!
    incbin "gfx/j/GFX04_comp.bin"             ;! Buzzy Beetle, Blargg
GFX05:                                        ;!
    incbin "gfx/j/GFX05_comp.bin"             ;! Chainsaw, Diggin Chuck
GFX06:                                        ;!
    incbin "gfx/j/GFX06_comp.bin"             ;! Urchin, Dolphin
GFX07:                                        ;!
    incbin "gfx/j/GFX07_comp.bin"             ;! Ghost House Tiles
GFX08:                                        ;!
    incbin "gfx/j/GFX08_comp.bin"             ;! Yoshi's House Tiles
GFX09:                                        ;!
    incbin "gfx/j/GFX09_comp.bin"             ;! Sumo Bro, Pokey
GFX0A:                                        ;!
    incbin "gfx/j/GFX0A_comp.bin"             ;! Wendy, Lemmy
GFX0B:                                        ;!
    incbin "gfx/j/GFX0B_comp.bin"             ;! Roy, Morton, Ludwig
GFX0C:                                        ;!
    incbin "gfx/j/GFX0C_comp.bin"             ;! Cave, Ghost House Background
GFX0D:                                        ;!
    incbin "gfx/j/GFX0D_comp.bin"             ;! Peach, Water Background
GFX0E:                                        ;!
    incbin "gfx/j/GFX0E_comp.bin"             ;! Ninji, Disco Ball
GFX0F:                                        ;!
    incbin "gfx/j/GFX0F_comp.bin"             ;! Mario Start, Credits
GFX10:                                        ;!
    incbin "gfx/j/GFX10_comp.bin"             ;! Overworld Mario
GFX11:                                        ;!
    incbin "gfx/j/GFX11_comp.bin"             ;! Big Boo, Eerie
GFX12:                                        ;!
    incbin "gfx/j/GFX12_comp.bin"             ;! Dry Bones, Grinder
GFX13:                                        ;!
    incbin "gfx/j/GFX13_comp.bin"             ;! Hammer Bro, Chargin Chuck
GFX14:                                        ;!
    incbin "gfx/j/GFX14_comp.bin"             ;! Pipe Tiles, Overworld Animation
GFX15:                                        ;!
    incbin "gfx/j/GFX15_comp.bin"             ;! Grassy Tiles
GFX16:                                        ;!
    incbin "gfx/j/GFX16_comp.bin"             ;! Rope Tiles
GFX17:                                        ;!
    incbin "gfx/j/GFX17_comp.bin"             ;! Bush, Diagonal Pipe Tiles
GFX18:                                        ;!
    incbin "gfx/j/GFX18_comp.bin"             ;! Castle Tiles
GFX19:                                        ;!
    incbin "gfx/j/GFX19_comp.bin"             ;! Forest, Hills Background
GFX1A:                                        ;!
    incbin "gfx/j/GFX1A_comp.bin"             ;! Cave Tiles
GFX1B:                                        ;!
    incbin "gfx/j/GFX1B_comp.bin"             ;! Blue Pillars, Castle Background
GFX1C:                                        ;!
    incbin "gfx/j/GFX1C_comp.bin"             ;! Overworld Tiles
GFX1D:                                        ;!
    incbin "gfx/j/GFX1D_comp.bin"             ;! Overworld Tiles
GFX1E:                                        ;!
    incbin "gfx/j/GFX1E_comp.bin"             ;! Overworld Level Icons
GFX1F:                                        ;!
    incbin "gfx/j/GFX1F_comp.bin"             ;! Cloud, Forest Tiles
GFX20:                                        ;!
    incbin "gfx/j/GFX20_comp.bin"             ;! Rex, Mega Mole
GFX21:                                        ;!
    incbin "gfx/j/GFX21_comp.bin"             ;! Bowser
GFX22:                                        ;!
    incbin "gfx/j/GFX22_comp.bin"             ;! Peach, Ludwig Background
GFX23:                                        ;!
    incbin "gfx/j/GFX23_comp.bin"             ;! Dino Torch, Dino Rhino
GFX24:                                        ;!
    incbin "gfx/j/GFX24_comp.bin"             ;! Mechakoopa, Bowser Fire
GFX25:                                        ;!
    incbin "gfx/j/GFX25_comp.bin"             ;! Iggy, Larry, Reznor
GFX26:                                        ;!
    incbin "gfx/j/GFX26_comp.bin"             ;! Credits Yoshi
GFX27:                                        ;!
    incbin "gfx/j/GFX27_comp.bin"             ;! Iggy Platform, Reznor Background
GFX28:                                        ;!
    incbin "gfx/j/GFX28_comp.bin"             ;! HUD Letters
GFX29:                                        ;!
    incbin "gfx/j/GFX29_comp.bin"             ;! Title Screen
GFX2A:                                        ;!
    incbin "gfx/j/GFX2A_comp.bin"             ;! Message Box Letters
GFX2B:                                        ;!
    incbin "gfx/j/GFX2B_comp.bin"             ;! Castle Crusher
GFX2C:                                        ;!
    incbin "gfx/j/GFX2C_comp.bin"             ;! Castle Cutscene Tiles
GFX2D:                                        ;!
    incbin "gfx/j/GFX2D_comp.bin"             ;! Castle Cutscene Objects
GFX2E:                                        ;!
    incbin "gfx/j/GFX2E_comp.bin"             ;! Credits Thank You
GFX2F:                                        ;!
    incbin "gfx/j/GFX2F_comp.bin"             ;! Credits Letters
GFX30:                                        ;!
    incbin "gfx/j/GFX30_comp.bin"             ;! Mario & Luigi The End
GFX31:                                        ;!
    incbin "gfx/j/GFX31_comp.bin"             ;! Special Beaten Enemies
elseif ver_is_hires(!_VER)                    ;<======================== E1 ===================
GFX32:                                        ;!
    incbin "gfx/e/GFX32_comp.bin"             ;! Mario Graphics
GFX33:                                        ;!
    incbin "gfx/e/GFX33_comp.bin"             ;! Animated Tile Graphics
GFX00:                                        ;!
    incbin "gfx/e/GFX00_comp.bin"             ;! Nintendo Presents, Powerups
GFX01:                                        ;!
    incbin "gfx/e/GFX01_comp.bin"             ;! Koopa, Goomba
GFX02:                                        ;!
    incbin "gfx/e/GFX02_comp.bin"             ;! Spiny, Lakitu
GFX03:                                        ;!
    incbin "gfx/e/GFX03_comp.bin"             ;! Thwomp, Magikoopa
GFX04:                                        ;!
    incbin "gfx/e/GFX04_comp.bin"             ;! Buzzy Beetle, Blargg
GFX05:                                        ;!
    incbin "gfx/e/GFX05_comp.bin"             ;! Chainsaw, Diggin Chuck
GFX06:                                        ;!
    incbin "gfx/e/GFX06_comp.bin"             ;! Urchin, Dolphin
GFX07:                                        ;!
    incbin "gfx/e/GFX07_comp.bin"             ;! Ghost House Tiles
GFX08:                                        ;!
    incbin "gfx/e/GFX08_comp.bin"             ;! Yoshi's House Tiles
GFX09:                                        ;!
    incbin "gfx/e/GFX09_comp.bin"             ;! Sumo Bro, Pokey
GFX0A:                                        ;!
    incbin "gfx/e/GFX0A_comp.bin"             ;! Wendy, Lemmy
GFX0B:                                        ;!
    incbin "gfx/e/GFX0B_comp.bin"             ;! Roy, Morton, Ludwig
GFX0C:                                        ;!
    incbin "gfx/e/GFX0C_comp.bin"             ;! Cave, Ghost House Background
GFX0D:                                        ;!
    incbin "gfx/e/GFX0D_comp.bin"             ;! Peach, Water Background
GFX0E:                                        ;!
    incbin "gfx/e/GFX0E_comp.bin"             ;! Ninji, Disco Ball
GFX0F:                                        ;!
    incbin "gfx/e/GFX0F_comp.bin"             ;! Mario Start, Credits
GFX10:                                        ;!
    incbin "gfx/e/GFX10_comp.bin"             ;! Overworld Mario
GFX11:                                        ;!
    incbin "gfx/e/GFX11_comp.bin"             ;! Big Boo, Eerie
GFX12:                                        ;!
    incbin "gfx/e/GFX12_comp.bin"             ;! Dry Bones, Grinder
GFX13:                                        ;!
    incbin "gfx/e/GFX13_comp.bin"             ;! Hammer Bro, Chargin Chuck
GFX14:                                        ;!
    incbin "gfx/e/GFX14_comp.bin"             ;! Pipe Tiles, Overworld Animation
GFX15:                                        ;!
    incbin "gfx/e/GFX15_comp.bin"             ;! Grassy Tiles
GFX16:                                        ;!
    incbin "gfx/e/GFX16_comp.bin"             ;! Rope Tiles
GFX17:                                        ;!
    incbin "gfx/e/GFX17_comp.bin"             ;! Bush, Diagonal Pipe Tiles
GFX18:                                        ;!
    incbin "gfx/e/GFX18_comp.bin"             ;! Castle Tiles
GFX19:                                        ;!
    incbin "gfx/e/GFX19_comp.bin"             ;! Forest, Hills Background
GFX1A:                                        ;!
    incbin "gfx/e/GFX1A_comp.bin"             ;! Cave Tiles
GFX1B:                                        ;!
    incbin "gfx/e/GFX1B_comp.bin"             ;! Blue Pillars, Castle Background
GFX1C:                                        ;!
    incbin "gfx/e/GFX1C_comp.bin"             ;! Overworld Tiles
GFX1D:                                        ;!
    incbin "gfx/e/GFX1D_comp.bin"             ;! Overworld Tiles
GFX1E:                                        ;!
    incbin "gfx/e/GFX1E_comp.bin"             ;! Overworld Level Icons
GFX1F:                                        ;!
    incbin "gfx/e/GFX1F_comp.bin"             ;! Cloud, Forest Tiles
GFX20:                                        ;!
    incbin "gfx/e/GFX20_comp.bin"             ;! Rex, Mega Mole
GFX21:                                        ;!
    incbin "gfx/e/GFX21_comp.bin"             ;! Bowser
GFX22:                                        ;!
    incbin "gfx/e/GFX22_comp.bin"             ;! Peach, Ludwig Background
GFX23:                                        ;!
    incbin "gfx/e/GFX23_comp.bin"             ;! Dino Torch, Dino Rhino
GFX24:                                        ;!
    incbin "gfx/e/GFX24_comp.bin"             ;! Mechakoopa, Bowser Fire
GFX25:                                        ;!
    incbin "gfx/e/GFX25_comp.bin"             ;! Iggy, Larry, Reznor
GFX26:                                        ;!
    incbin "gfx/e/GFX26_comp.bin"             ;! Credits Yoshi
GFX27:                                        ;!
    incbin "gfx/e/GFX27_comp.bin"             ;! Iggy Platform, Reznor Background
GFX28:                                        ;!
    incbin "gfx/e/GFX28_comp.bin"             ;! HUD Letters
GFX29:                                        ;!
    incbin "gfx/e/GFX29_comp.bin"             ;! Title Screen
GFX2A:                                        ;!
    incbin "gfx/e/GFX2A_comp.bin"             ;! Message Box Letters
GFX2B:                                        ;!
    incbin "gfx/e/GFX2B_comp.bin"             ;! Castle Crusher
GFX2C:                                        ;!
    incbin "gfx/e/GFX2C_comp.bin"             ;! Castle Cutscene Tiles
GFX2D:                                        ;!
    incbin "gfx/e/GFX2D_comp.bin"             ;! Castle Cutscene Objects
GFX2E:                                        ;!
    incbin "gfx/e/GFX2E_comp.bin"             ;! Credits Thank You
GFX2F:                                        ;!
    incbin "gfx/e/GFX2F_comp.bin"             ;! Credits Letters
GFX30:                                        ;!
    incbin "gfx/e/GFX30_comp.bin"             ;! Mario & Luigi The End
GFX31:                                        ;!
    incbin "gfx/e/GFX31_comp.bin"             ;! Special Beaten Enemies
else                                          ;<================== U, SS, & E0 ================
GFX32:                                        ;!
    incbin "gfx/u/GFX32_comp.bin"             ;! Mario Graphics
GFX33:                                        ;!
    incbin "gfx/u/GFX33_comp.bin"             ;! Animated Tile Graphics
GFX00:                                        ;!
    incbin "gfx/u/GFX00_comp.bin"             ;! Nintendo Presents, Powerups
GFX01:                                        ;!
    incbin "gfx/u/GFX01_comp.bin"             ;! Koopa, Goomba
GFX02:                                        ;!
    incbin "gfx/u/GFX02_comp.bin"             ;! Spiny, Lakitu
GFX03:                                        ;!
    incbin "gfx/u/GFX03_comp.bin"             ;! Thwomp, Magikoopa
GFX04:                                        ;!
    incbin "gfx/u/GFX04_comp.bin"             ;! Buzzy Beetle, Blargg
GFX05:                                        ;!
    incbin "gfx/u/GFX05_comp.bin"             ;! Chainsaw, Diggin Chuck
GFX06:                                        ;!
    incbin "gfx/u/GFX06_comp.bin"             ;! Urchin, Dolphin
GFX07:                                        ;!
    incbin "gfx/u/GFX07_comp.bin"             ;! Ghost House Tiles
GFX08:                                        ;!
    incbin "gfx/u/GFX08_comp.bin"             ;! Yoshi's House Tiles
GFX09:                                        ;!
    incbin "gfx/u/GFX09_comp.bin"             ;! Sumo Bro, Pokey
GFX0A:                                        ;!
    incbin "gfx/u/GFX0A_comp.bin"             ;! Wendy, Lemmy
GFX0B:                                        ;!
    incbin "gfx/u/GFX0B_comp.bin"             ;! Roy, Morton, Ludwig
GFX0C:                                        ;!
    incbin "gfx/u/GFX0C_comp.bin"             ;! Cave, Ghost House Background
GFX0D:                                        ;!
    incbin "gfx/u/GFX0D_comp.bin"             ;! Peach, Water Background
GFX0E:                                        ;!
    incbin "gfx/u/GFX0E_comp.bin"             ;! Ninji, Disco Ball
GFX0F:                                        ;!
    incbin "gfx/u/GFX0F_comp.bin"             ;! Mario Start, Credits
GFX10:                                        ;!
    incbin "gfx/u/GFX10_comp.bin"             ;! Overworld Mario
GFX11:                                        ;!
    incbin "gfx/u/GFX11_comp.bin"             ;! Big Boo, Eerie
GFX12:                                        ;!
    incbin "gfx/u/GFX12_comp.bin"             ;! Dry Bones, Grinder
GFX13:                                        ;!
    incbin "gfx/u/GFX13_comp.bin"             ;! Hammer Bro, Chargin Chuck
GFX14:                                        ;!
    incbin "gfx/u/GFX14_comp.bin"             ;! Pipe Tiles, Overworld Animation
GFX15:                                        ;!
    incbin "gfx/u/GFX15_comp.bin"             ;! Grassy Tiles
GFX16:                                        ;!
    incbin "gfx/u/GFX16_comp.bin"             ;! Rope Tiles
GFX17:                                        ;!
    incbin "gfx/u/GFX17_comp.bin"             ;! Bush, Diagonal Pipe Tiles
GFX18:                                        ;!
    incbin "gfx/u/GFX18_comp.bin"             ;! Castle Tiles
GFX19:                                        ;!
    incbin "gfx/u/GFX19_comp.bin"             ;! Forest, Hills Background
GFX1A:                                        ;!
    incbin "gfx/u/GFX1A_comp.bin"             ;! Cave Tiles
GFX1B:                                        ;!
    incbin "gfx/u/GFX1B_comp.bin"             ;! Blue Pillars, Castle Background
GFX1C:                                        ;!
    incbin "gfx/u/GFX1C_comp.bin"             ;! Overworld Tiles
GFX1D:                                        ;!
    incbin "gfx/u/GFX1D_comp.bin"             ;! Overworld Tiles
GFX1E:                                        ;!
    incbin "gfx/u/GFX1E_comp.bin"             ;! Overworld Level Icons
GFX1F:                                        ;!
    incbin "gfx/u/GFX1F_comp.bin"             ;! Cloud, Forest Tiles
GFX20:                                        ;!
    incbin "gfx/u/GFX20_comp.bin"             ;! Rex, Mega Mole
GFX21:                                        ;!
    incbin "gfx/u/GFX21_comp.bin"             ;! Bowser
GFX22:                                        ;!
    incbin "gfx/u/GFX22_comp.bin"             ;! Peach, Ludwig Background
GFX23:                                        ;!
    incbin "gfx/u/GFX23_comp.bin"             ;! Dino Torch, Dino Rhino
GFX24:                                        ;!
    incbin "gfx/u/GFX24_comp.bin"             ;! Mechakoopa, Bowser Fire
GFX25:                                        ;!
    incbin "gfx/u/GFX25_comp.bin"             ;! Iggy, Larry, Reznor
GFX26:                                        ;!
    incbin "gfx/u/GFX26_comp.bin"             ;! Credits Yoshi
GFX27:                                        ;!
    incbin "gfx/u/GFX27_comp.bin"             ;! Iggy Platform, Reznor Background
GFX28:                                        ;!
    incbin "gfx/u/GFX28_comp.bin"             ;! HUD Letters
GFX29:                                        ;!
    incbin "gfx/u/GFX29_comp.bin"             ;! Title Screen
GFX2A:                                        ;!
    incbin "gfx/u/GFX2A_comp.bin"             ;! Message Box Letters
GFX2B:                                        ;!
    incbin "gfx/u/GFX2B_comp.bin"             ;! Castle Crusher
GFX2C:                                        ;!
    incbin "gfx/u/GFX2C_comp.bin"             ;! Castle Cutscene Tiles
GFX2D:                                        ;!
    incbin "gfx/u/GFX2D_comp.bin"             ;! Castle Cutscene Objects
GFX2E:                                        ;!
    incbin "gfx/u/GFX2E_comp.bin"             ;! Credits Thank You
GFX2F:                                        ;!
    incbin "gfx/u/GFX2F_comp.bin"             ;! Credits Letters
GFX30:                                        ;!
    incbin "gfx/u/GFX30_comp.bin"             ;! Mario & Luigi The End
GFX31:                                        ;!
    incbin "gfx/u/GFX31_comp.bin"             ;! Special Beaten Enemies
endif                                         ;/===============================================

    %insert_empty($17E,$2F3,$2F3,$2F3,$265)

    check bankcross on