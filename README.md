Legend Of the Red Dragon II
===========================

An open source version of Legend Of the Red Dragon II.  Binaries are in the bin/[platform] directories, just drop one in the same directory as your LORD2 installation and enjoy!

NOTE: This is not 100% complete yet -- there are still some RTReader commands that have not been implemented yet (unhandled commands are displayed at the bottom of the screen when
they are encountered), and no doubt there are a lot of bugs to squish in the commands that have been implemented, so if you want to test this best to run it as a second instance
of LORD2, and not to replace your existing instance.

I've personally compiled and tested the following configurations.  The build scripts are all based off my paths, so you'll probably
need to tweak them before you get it compiling for yourself.  And the doorkit code has recently been moved out of the LORD2 repository, so you'll need
<a href="https://github.com/rickparrish/RMDoor" target="_blank">RMDoor</a> as well to get things compiling.

- Windows Server 2012 (64bit)<br />
 - Lazarus 1.0.14 (32bit) (FreePascal 2.6.2)<br />
 - Just open LORD2.lpi and build<br />
 - Tested with GameSrv<br />

- Windows 7 (32bit)
 - FreePascal 2.6.4 (GO32V2)
 - build-go32v2.cmd
 - Tested with GameSrv

- Ubuntu Server 13.10 (32bit):
 - FreePascal 2.6.2 (32bit) (also needs fp-units-fcl)
 - build-linux.sh
 - Tested with Synchronet

- FreeBSD 9.1 (32bit):
 - FreePascal 2.6.0 (32bit)
 - cd /usr/ports/lang/fpc && make install && make clean
 - fpc -B -Furmdoor -FEbin/i386-freebsd LORD2.lpr
 - Tested with Synchronet
 - NOTE: These instructions are now out of date.  You should probably just create a new script based off the build-linux.sh script and use that to compile.

Legend Of the Red Dragon II is owned by Metropolis GamePort, which I have no affiliation with.

The code in this repository has been written from scratch -- no LORD2 source code (neither original Pascal source, nor decompiled Assembly source) has been referenced in its implementation.
(Except for the data file structures, which are included in the LORD II release archive.)
