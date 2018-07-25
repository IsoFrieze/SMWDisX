@echo off
echo Assembling...
echo. 2>smw.smc
asar smw.asm smw.smc
echo Assembly complete!

:checkj
fc comparison_J.smc smw.smc > nul
if errorlevel 2 goto noroms
if errorlevel 1 goto checku
echo J version match!
goto done
:checku
fc comparison_U.smc smw.smc > nul
if errorlevel 2 goto noroms
if errorlevel 1 goto checke0
echo U version match!
goto done
:checke0
fc comparison_E0.smc smw.smc > nul
if errorlevel 2 goto noroms
if errorlevel 1 goto checke1
echo E0 version match!
goto done
:checke1
fc comparison_E1.smc smw.smc > nul
if errorlevel 2 goto noroms
if errorlevel 1 goto error
echo E1 version match!
goto done
:error
echo The assembled ROM does not match any version!
goto done
:noroms
echo If you provide ROMs of the 4 versions of SMW, I can check the accuracy of the assembly.
:done
pause