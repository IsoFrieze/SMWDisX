# SMWDisX
(Yet another) disassembly of Super Mario World.
This disassembly will focus on code readability and the ability to assemble any of the four console releases of the original game (J, U, E 1.0, & E 1.1). It also assembles the Super System arcade version of the game.

# How to Assemble
You'll need the assembler, Asar v1.61 (you can find it [here](https://www.smwcentral.net/?p=section&s=tools)).
1. Click the big green "Clone or download" button and select zip file.
2. Unzip that somewhere, and stick asar.exe in the folder with PATCH.bat.
3. Open smw.asm and change the variable !_VER to correspond to the version of the game you want to assemble.
4. Run the bat file. The assembled ROM will be called "smw.smc."
5. If you provide a ROM of each version of the game and call them "comparison_J.smc", etc., the batch file will also check the assembled ROM to see if it matches any exactly.

# Status
All 5 versions assemble and play exactly like they should. The only difference at the moment is the PAL & SS versions' empty space patterns, since they don't just use a $FF fill. Either I have bad dumps of these two versions, or there is no pattern to which bits are flipped in these areas. It *looks* like it alternates between $FF and $00 every $20 bytes but there is some other weirdness going on. I won't include these in the disassembly until I can find a clean way of doing it. I was hoping to write a macro that pulled the empty space pattern from a separate file, but Asar won't allow variable input to the `incbin` command.

# Contribution
Anyone can contribute as long as they follow the format rules below. This isn't like a personal project or anything. Just make sure every commit that the ROM will properly assemble.

# Format
I'm focusing on readability so its important that everything is nice and consistent.
1. 22 characters for label, 42 characters for instruction, then the PCs, then comment.
2. The PC goes in the order of J, U, SS, E0, the E1. The separator symbols are unique to each so you can prefix a bank address with one to look for that version specifically.
3. Address mode hints (.B .W .L) should be used by the following instructions if they are not accumulator addressed: TSB TRB BIT LDA LDX LDY STA STX STY STZ CMP CPX CPY ORA AND EOR ADC SBC ASL ROL LSR ROR DEC INC. Some address modes (e.g. LDA $addr,Y) are unambiguous but should be kept for consistency.
4. Everything should be relative, using labels. This is kind of assumed, but it is very important with multiple version support since stuff shifts around a lot.
5. Any operand that refers to an address should use a variable. This includes immediates.
6. Large datablocks should be placed in bin files and incbin'd in the disassembly, to reduce text file size.
7. Version differences should be clearly marked with special comments. See label `GameMode17` in bank_00.asm.
   - Exceptions are single instructions with either different addressing modes (use the applicable macro) or different constant operands (use the `con` function).
8. Spaces not tabs.
9. Probably more things that I'll add as I think of them.
10. I'm using the semicolon to the left of the program counter as a marker of whether I have cleaned up that area of code yet. If there are two semicolons, that line still needs work.
11. Don't allow variable names to be a prefix of another variable's name. This way you can Ctrl+F a variable name and you won't get similarly named variables. (This is why scratch RAM starts with an underscore.) Generally this means short names are bad.

# Bugs
The assembler Asar is an open source project still under development. Some bugs exist which require the disassembly to go against formatting protocol in order to assembly correctly. Here is a list of things I've run into to remind myself to go back and fix if the bugs are ever fixed:
1. Turning `check bankcross off` will cause the pc to always act as FastROM. This causes labels to have $80 added to their bank.
   - `padbyte pad` requires the FastROM address. See bank_08-0B.asm.
     - Temp fix: set the high byte of the bank in the `pad` command.
   - All references to labels in a non-bankcross-checked area will have the high bit set. See `GFXFilesBank` label in bank_00.asm.
     - Temp fix: Mask away the high bit of the bank by using `&$7F`.
