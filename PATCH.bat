@echo off
echo Assembling...
echo. 2>smw.smc
asar -wno1009 -wno1018 --fix-checksum=off --symbols=nocash --define _VER=!__VER_J smw.asm SMW_J.smc
asar -wno1009 -wno1018 --fix-checksum=off --symbols=nocash --define _VER=!__VER_U smw.asm SMW_U.smc
asar -wno1009 -wno1018 --fix-checksum=off --symbols=nocash --define _VER=!__VER_SS smw.asm SMW_SS.smc
asar -wno1009 -wno1018 --fix-checksum=off --symbols=nocash --define _VER=!__VER_E0 smw.asm SMW_E0.smc
asar -wno1009 -wno1018 --fix-checksum=off --symbols=nocash --define _VER=!__VER_E1 smw.asm SMW_E1.smc
echo Assembly complete!

:checkj
fc comparison_J.smc SMW_J.smc > nul
if errorlevel 1 goto jmiss
:jmatch
echo J version match!
goto checku
:jmiss
echo J version MISMATCH!

:checku
fc comparison_U.smc SMW_U.smc > nul
if errorlevel 1 goto umiss
:umatch
echo U version match!
goto checkss
:umiss
echo U version MISMATCH!

:checkss
fc comparison_SS.smc SMW_SS.smc > nul
if errorlevel 1 goto ssmiss
:ssmatch
echo SS version match!
goto checke0
:ssmiss
echo SS version MISMATCH!

:checke0
fc comparison_E0.smc SMW_E0.smc > nul
if errorlevel 1 goto e0miss
:e0match
echo E0 version match!
goto checke1
:e0miss
echo E0 version MISMATCH!

:checke1
fc comparison_E1.smc SMW_E1.smc > nul
if errorlevel 1 goto e1miss
:e1match
echo E1 version match!
goto done
:e1miss
echo E1 version MISMATCH!

:done
pause