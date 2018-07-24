echo f | xcopy /y "base.smc" "patched.smc"
asar patch.asm patched.smc
pause