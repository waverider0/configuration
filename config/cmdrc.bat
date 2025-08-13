@echo off

doskey fp="C:\Users\allen\Desktop\FPilot.exe"
doskey tags="C:\Users\allen\scoop\apps\universal-ctags\current\ctags.exe" -R .
doskey vcvars="C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
doskey vi="C:\Program Files\Neovim\bin\nvim.exe" $*
