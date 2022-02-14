@echo off
echo Assembling...
echo. 2>smw.smc
asar smw.asm smw.smc
echo Assembly complete!

:checkj
fc comparison_J.smc smw.smc > nul
if errorlevel 2 goto checku
if errorlevel 1 goto checku
echo J version match!
goto done
:checku
fc comparison_U.smc smw.smc > nul
if errorlevel 2 goto checke0
if errorlevel 1 goto checke0
echo U version match!
goto done
:checke0
fc comparison_E0.smc smw.smc > nul
if errorlevel 2 goto checke1
if errorlevel 1 goto checke1
echo E0 version match!
goto done
:checke1
fc comparison_E1.smc smw.smc > nul
if errorlevel 2 goto checkss
if errorlevel 1 goto checkss
echo E1 version match!
goto done
:checkss
fc comparison_SS.smc smw.smc > nul
if errorlevel 2 goto checkssf
if errorlevel 1 goto checkssf
echo SS version match!
goto done
:checkssf
fc comparison_SS_f.smc smw.smc > nul
if errorlevel 2 goto error
if errorlevel 1 goto error
echo SS version temporary match!
goto done
:error
echo The assembled ROM does not match any version!
:done
pause