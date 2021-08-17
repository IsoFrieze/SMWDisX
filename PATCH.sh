#!/bin/bash
echo Assembling...
rm -f smw.smc
asar smw.asm smw.smc || exit
echo Assembly complete!

cmp --silent comparison_J.smc smw.smc && echo "J version match!"
cmp --silent comparison_U.smc smw.smc && echo "U version match!"
cmp --silent comparison_E0.smc smw.smc && echo "E0 version match!"
cmp --silent comparison_E1.smc smw.smc && echo "E1 version match!"
cmp --silent comparison_E0_f.smc smw.smc && echo "E0 version temporary match!"
cmp --silent comparison_E1_f.smc smw.smc && echo "E1 version temporary match!"

exit 0 # reset exit code from last cmp
