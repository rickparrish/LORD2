#!/bin/bash

#requires fp-units-fcl

cd /mnt/Z/Programming/LORD2/source
# fpc -MObjFPC -Scghi -O1 -g -gl -vewnhi -Fi../obj/i386-linux -Fu../../RMDoor -Fu. -FU../obj/i386-linux/ -l -FE../bin/i386-linux/ LORD2.lpr
fpc -B LORD2.lpr -MObjFPC -Scghi -O1 -g -gl -vewnhi -Fi../obj/i386-linux -Fu../../RMDoor -Fu. -FU../obj/i386-linux/ -l -FE../bin/i386-linux/