# LearnixOS dist kernel

This is the kernel for the LearnixOS distribution. This repo will contain the patches and the .config file for the kernel (aptly named 'config-lxos').
The patches will depend on the kernel version, so the patches will be saved in a folder named after the kenrel version, so long as LXOS is using that version.
So unfortunately, for my fellow stable release vs. rolling release fans during this initial release, this will be a bit of a pain to maintain. But I will try to keep it as up-to-date as possible.

## Patches
The patches were taken from the following sources:
- [Linux-tkg](https://github.com/Frogging-Family/linux-tkg)
- [Linux-zen](https://github.com/zen-kernel/zen-kernel)
- [Linux-xanmod](https://gitlab.com/xanmod/linux-patches)

Truly, without these projects, creating this kernel to be as performant as possible would be a pain in the ass.

## Using the kernel
To use the kernel, you can either:
- Download from the github releases, which I manually compiled for all architectures
- Manually patch and compile it yourself

To use the github release kernel, once you extract the sources, you will find everything you will need. **IT IS REQUIRED TO HAVE AN INITRAMFS TO USE THE KERNEL AS MOST OF EVERYTHING IS A MODULE FOR HARDWARE COMPATABILITY**. Here is what you will find:
- source tarball (that I compiled) - will be hella messy
- modules-lxos-dist.tar.xz - the modules (you will find lib/modules/ inside, you can literally just move what ever is inside to the /lib/modules)
- vmlinuz, bzImage (both are kernel images, one is uncompressed the other is)
- System.map - this is just important for LIVEISOs primarily so you don't need to worry

For those who are brave and are willing to compile, you can proceed.
## Building the kernel
In the repo, I recommend pulling the linux kernel source directory in the repo to utilize the useful apply-patches script. To find the latest kernel release tarballs you can just head over to the [kernel.org](https://kernel.org/) website and pick out any tarball.
Currently as of writting this guide, the kernel version that the patches support are for 6.13.x, but I recommend getting the 6.13.2 since I got it working for that version, you can find all the tarballs of the linux source code [here](https://www.kernel.org/pub/linux/kernel/v6.x/).
Alternatively, if you are too lazy, here is the direct link to download the 6.13.2 tarball: [6.13.2](https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.13.2.tar.xz).

### Prerequisites
Before you can compile the kernel, you need to install the following packages:
- clang (or gcc, clang is recommended as I used it to compile the kernel and get ThinLTO)
- make
- patch
- zstd (for the kernel to be compressed)
- libelf
These packages are the bare minimum, if you are using LearnixOS, these are included by default.
I might have missed some packages, so if you encounter any errors, please let me know.

### Applying the patches
To apply the patches, you can use the apply-patches script in the root of the repo. The script will apply the patches in the patches directory to the kernel source code. To use the script, you can run the following command:
```bash
# in the root of the linux kernel source code
../apply-patches.sh -p ../patches/6.13/
```
The script will apply the patches in the 6.13 directory to the kernel source code. If you are using a different kernel version, you can change the directory to the appropriate version (once we get more versions of course). Then we have some custom patches I wrote myself since there were some compile errors that I had to fix (they are located in the patches/custom-patches directory of the repo). You will have to manually apply these patches, but they are very simple to apply, move the patches to the root of the kernel source code and run the following command:
```bash
# in the root of the linux kernel source code
patch -Np1 -i fix-page_alloc-compile-time-error.patch
patch -Np1 -i syscalls-compile-fix.patch
```
**YOU WILL BE ASKED FILE TO PATCH**, just type int the exact directory of the file to patch (you will see --- mm/page_alloc.c or something like that, just type in mm/page_alloc.c). If you encounter any errors, please let me know.
These patches are separated from the other patches mostly because they are not part of the main patch sets for performance, but rather to fix compile errors that I encountered.

### Configuring the kernel
There is no configuring of the kernel, but for the custom folks you can just run `make LLVM=1 menuconfig` or just `make menuconfig` if you prefer gcc. The config file is already provided in the repo, so you can just use that. Just copy the file to the root of the kernel source code and build as so:
```bash
# in the root of the linux kernel source code
cp ../kernel-config .config
make LLVM=1 -j$(nproc) # or make -j$(nproc) if you prefer gcc
```
The kernel will be compiled and you will have the kernel image in the arch/x86/boot directory.

# Enjoy the kernel!
If you are not familiar on how to use the kernel image and getting it to boot for you, I don't know why you are reading this README, but I will provide a guide on how to use the kernel image in the future. For now, you can just use the github release kernel image and initramfs to boot the kernel via duckduckgoing the answer. Or instead, how about you just wait to switch to LearnixOS for these optimizations? It's going to be a great distro, I promise.
