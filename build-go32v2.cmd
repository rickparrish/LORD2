@echo off
z:
cd \programming\LORD2\source
rem fpc -MObjFPC -Scghi -O1 -g -gl -vewnhi -Fi..\obj\i386-go32v2 -Fu..\..\RMDoor -Fu. -FU..\obj\i386-go32v2\ -l -FE..\bin\i386-go32v2\ LORD2.lpr
fpc -Scghi -O1 -g -Fi..\obj\i386-go32v2 -Fu..\..\RMDoor -Fu. -FU..\obj\i386-go32v2\ -FE..\bin\i386-go32v2\ LORD2.lpr
cd ..
move bin\i386-go32v2\lord2.exe bin\i386-go32v2\LORD2.exe
pause