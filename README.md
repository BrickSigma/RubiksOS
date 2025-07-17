# ChippyOS
This is a simple bootloader/OS project, with the goal of hopefully running a few simple games as a baremetal operating system.

## Contents
- [Building and running](#building-and-running)
- [Why do this?](#why-do-this)
- [The current goal of this project](#the-current-goal-of-this-project)
- [Resources and references](#resources-and-references)
- [Further ideas](#further-ideas)
- [Final words](#final-words)

## Building and running
This project is built using the GNU assembler and binutils system, therefore you should hopefully only need a copy of the GNU C compiler and QEMU for emulating the project.

To build the project simply run `make` in the root of the project folder, and `make run` to start running it.

## Why do this?
Good question! Well in short I have two reasons:
1. I'm bored of building CRUD mobile and web apps in university at the moment and want to do something more low level for a while, and
2. OSDev is really fun and interesting!

I've never done any form of operating system development before, so this'll be a difficult challange, and I'm hoping to track the progression of this project through this repository as it progresses.

## The current goal of this project
Like the OSDev wiki mentions, it's always good to have an end goal with such a large project, but to be honest I don't have an actual end goal (as of yet). The *current goal* however is to get the following working:

- [x] Interrupt handler for keyboard input,
- [ ] Graphics driver for supporting VGA 16-color graphics with a resolution of ~~320x200~~ 80x25,
- [ ] A basic game running, like Pong. 

The last section of the goal is to get a simple game working, which will require the previous two tasks to work. Pong is a nice and simple game, and it can definitely fit into a bootsector (512 bytes).

I'm probably forgetting about a lot of other stuff, and as I read and learn more about OS dev this list will slowly grow as well.

## Resources and references
One of the most important parts about OS Dev is finding the right resources and sites to start out. Obviously there is the [OSDev Wiki](https://wiki.osdev.org) which has a surplus of documentation and tutorials to follow. I've created a list of some of the links I'll be using for this project in case anyone is curious:

- [Babysteps Guide](https://wiki.osdev.org/Babystep1) - this is the starting point for the project, it contains a step by step guide for understanding the basics of a bootloader and building one.
- [IBM's VGA Documentation](https://ardent-tool.com/docs/pdf/ibm_vgaxga_trm2.pdf) - to help understand VGA graphics a bit better while devloping the graphics driver.
- [Intel 8086 ISA](https://www.eng.auburn.edu/~sylee/ee2220/8086_instruction_set.html) - Full instruction set for the Intel 8086 assembly language.
- [BIOS Interrupts and Functions](https://ostad.nit.ac.ir/payaidea/ospic/file1615.pdf) - a useful PDF listing several BIOS interrupts and functions that can be used in real mode for setup.

## Further ideas
It's never a bad idea to dream ahead and think bigger, so while working on my current goal of a simple bootloader game, here are some other ideas I might look into trying:

- Moving from pure assembly to C,
- Properly creating an architecture for this project so it can go beyond a bootloader and maybe become a simple kernel,
- Building a simple shell environment and file system,
- Accessing external disks to load programs, or even game ROMs.

## Final words
As you can probably tell, this is very casual side project, and it'll probably change a lot as I learn more and get more ideas. Thanks for reading, I hope you stick around for the journey that lies ahead!