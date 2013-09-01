LORD2
=====

An open source version of Legend Of the Red Dragon II.  Just compile and drop LORD2.EXE in the same directory as your LORD2 installation and enjoy!  (That's the plan anyway -- will be awhile before that's a reality)

Compiled and tested with:

- Windows Server 2012 (64bit)<br />
 - Lazarus 1.0.10 (32bit) (FreePascal 2.6.2)<br />
 - Just open LORD2.lpr and build<br />
 - Tested with GameSrv<br />

- Windows 7 (32bit)
 - FreePascal 2.6.2 (GO32V2)
 - fpc -B -Furmdoor -FEbin\i386-go32v2 LORD2.lpr
 - Tested with GameSrv

- Ubuntu Server 13.04 (64bit):
 - FreePascal 2.6.0 (64bit)
 - sudo apt-get install fp-compiler-2.6.0 fp-units-fcl-2.6.0
 - fpc -B -Furmdoor -FEbin/x86_64-linux LORD2.lpr
 - Tested with Synchronet

- FreeBSD 9.1 (32bit):
 - FreePascal 2.6.0 (32bit)
 - cd /usr/ports/lang/fpc && make install && make clean
 - fpc -B -Furmdoor -FEbin/i386-freebsd LORD2.lpr
 - Tested with Synchronet

Legend Of the Red Dragon II is owned by Metropolis GamePort, which I have no affiliation with.

The code in this repository has been written from scratch -- no LORD2 source code (neither original Pascal source, nor decompiled Assembly source) has been referenced in its implementation.
(Except for the data file structures, which are included in the LORD II release archive.)
