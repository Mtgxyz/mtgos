#!/usr/bin/env bash
gmake clean
gmake loader.bin
gmake -C kernel
gmake -C kernel clean
mv kernel/mtgos.elf .
objcopy -O binary mtgos.elf mtgos.bin
gmake -C kernel subvar=11
objcopy -O binary kernel/mtgos.elf kernel/mtgos.bin
firmlink -O 08000000  -O 1FF80000 -E $(nm mtgos.elf | egrep ' _start$' | awk '{print $1}') -e $(nm kernel/mtgos.elf | egrep ' _start$' | awk '{print $1}') -o mtgos.firm mtgos.bin kernel/mtgos.bin
rm mtgos.bin kernel/mtgos.*
sudo mount_msdosfs /dev/da3s1 mount
sudo rm mount/{arm9loaderhax.bin,mtgos.firm}
sudo mv loader.bin mount/arm9loaderhax.bin
sudo mv mtgos.firm mount/mtgos.firm
sudo umount mount
echo "Remove SD card!"
