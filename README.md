# SMWDisX
(Yet another) disassembly of Super Mario World.
This disassembly will focus on code readability and the ability to assemble any of the four releases of the original game (J, U, E 1.0, & E 1.1).

# How to Assemble
You'll need the assembler, Asar v1.60 (you can find it [here](https://www.smwcentral.net/?p=section&s=tools)).
1. Click the big green "Clone or download" button and select zip file.
2. Unzip that somewhere, and stick asar.exe in the folder with PATCH.bat.
3. Open smw.asm and change the variable !V to correspond to the version of the game you want to assemble.
4. Run the bat file. The assembled ROM will be called "smw.smc."
5. If you provide a ROM of each version of the game and call them "comparison_J.smc", etc., the batch file will also check the assembled ROM to see if it matches any exactly.

# Status
U version assembles perfectly since it was created from an old disassembly of the U version.
J, E0, E1 versions only have the ROM header correct at the moment.

# Contribution
Anyone can contribute as long as they follow the format rules below. This isn't like a personal project or anything. Just make sure every commit that the ROM will properly assemble.

# Format
I'm focusing on readability so its important that everything is nice and consistent.
1. 22 characters for label, 36 characters for instruction, then the pc, raw bytes, then comment. Raw bytes don't need to be displayed for data blocks or binary inclusions.
2. Address mode hints (.B .W .L) should be used by the following instructions if they are not accumulator addressed: TSB TRB BIT LDA LDX LDY STA STX STY STZ CMP CPX CPY ORA AND EOR ADC SBC ASL ROL LSR ROR DEC INC. Some address modes (e.g. LDA $addr,Y) are unambiguous but should be kept for consistency.
3. Everything should be relative, using labels. This is kind of assumed, but it is very important with multiple version support since stuff shifts around a lot.
4. Any operand that refers to an address should use a variable. This includes immediates.
5. Large datablocks should be placed in bin files and incbin'd in the disassembly, to reduce text file size.
6. Version differences should be clearly marked with special comments like shown in smw.asm.
7. Spaces not tabs.
8. Probably more things that I'll add as I think of them.
9. I'm using the semicolon to the left of the program counter as a marker of whether I have cleaned up that area of code yet. If there are two semicolons, that line still needs work.
10. Don't allow variable names to be a prefix of another variable's name. This way you can Ctrl+F a variable name and you won't get similarly named variables. (This is why scratch RAM starts with an underscore.) Generally this means short names are bad.