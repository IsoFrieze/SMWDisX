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

On Linux, steps are the same but use asar instead of asar.exe and PATCH.sh instead of PATCH.bat.

# Status
All 5 versions assemble and play exactly like they should. The only difference at the moment is the SS version's checksum is inverted. Every ROM has a spot for a 16-bit checksum and the checksum's complement. The SS version has the main checksum and the complement switched, so I don't know how to deal with that since Asar deals with the checksum on its own.

# Contribution
Anyone can contribute as long as they follow the format rules below. This isn't like a personal project or anything. Just make sure every commit that the ROM will properly assemble.

# Credits
- mikeyk for the original disassembly this one was based off of from 2013.
- @loveemu for the origianl disassembly of the SPC700 sound engine code.
- @kaizoman666 for most of the comments.
- @IsoFrieze for
    - reformatting the original disassembly into an assemblable project via Asar.
    - creating labels and descriptions for RAM addresses.
    - documentation on all verions other than the U version, and including their differences in the project.
    - pulling data like graphics, palettes, and level data out of the text files and into binary files.
    - extracting constants and magic numbers from code and turning them into assembler variables.
- All contributors, which can be found on the GitHub page for this repo.

# Format
I'm focusing on readability so its important that everything is nice and consistent. This has, can, and will change in the future.
1. Labels on their own lines. 4 spaces per indentation in code. Inline comments on column 46.
2. Address mode hints (.B .W .L) should be used by the following instructions if they are not accumulator addressed: TSB TRB BIT LDA LDX LDY STA STX STY STZ CMP CPX CPY ORA AND EOR ADC SBC ASL ROL LSR ROR DEC INC. Some address modes (e.g. LDA $addr,Y) are unambiguous but should be kept for consistency.
3. Everything should be relative, using labels. This is kind of assumed, but it is very important with multiple version support since stuff shifts around a lot.
4. Any operand that refers to an address should use a variable. This includes immediates.
5. Large datablocks should be placed in bin files and incbin'd in the disassembly, to reduce text file size.
   - Data of certain formats should be separated in a commonly editable format (e.g. palettes as \*.pal files instead of SNES 15-bit data).
6. Version differences should be clearly marked with special comments. See label `GameMode17` in bank_00.asm.
   - Exceptions are single instructions with either different addressing modes (use the applicable macro) or different constant operands (use the `con` function).
7. Spaces not tabs.
8. Constants and magic numbers should be pulled out into an assembler define.
9. If a constant is used as a bitmask, it should be written in binary.
10. Don't allow variable names to be a prefix of another variable's name. This way you can Ctrl+F a variable name and you won't get similarly named variables. (This is why scratch RAM starts with an underscore.) Generally this means short names are bad.
11. Probably more things that I'll add as I think of them.

# Bugs
The assembler Asar is an open source project still under development. Some bugs exist which require the disassembly to go against formatting protocol in order to assembly correctly. Here is a list of things I've run into to remind myself to go back and fix if the bugs are ever fixed:
1. Turning `check bankcross off` will cause the pc to always act as FastROM. This causes labels to have $80 added to their bank.
   - All references to labels in a non-bankcross-checked area will have the high bit set. See `GFXFilesBank` label in bank_00.asm.
     - Temp fix: Mask away the high bit of the bank by using `&$7F`.
