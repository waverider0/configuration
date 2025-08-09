@echo off

call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

doskey fp="C:\Users\allen\Desktop\FPilot.exe"
doskey vi="C:\Program Files\Neovim\bin\nvim.exe" $*
