# SteinerOS
This is a simple bootloader/OS project, with the goal of hopefully becoming a basic operating system.

## Contents
- [Building and running](#building-and-running)
- [Why do this?](#why-do-this)
- [The current goal of this project](#the-current-goal-of-this-project)
- [Resources and references](#resources-and-references)
- [Next steps](#next-steps)
- [Final words](#final-words)

## Building and running
This project is built using the GNU assembler and binutils system, therefore you should hopefully only need a copy of the default installation of the GNU C compiler and QEMU for emulating the project.

To build the project simply run `make` in the root of the project folder, and `make run` to start running it.

**Note:** At this moment I'm only using pure assembly, so there's no need to setup a cross compiler to try out the project (in its current state), all you need is GCC and the GNU Assembler.

## Why do this?
Good question! Well in short I have two reasons:
1. I'm bored of building CRUD mobile and web apps in university at the moment and want to do something more low level for a while, and
2. OSDev is really fun and interesting!

I've never done any form of operating system development before, so this'll be a difficult challange, and I'm hoping to track the progression of this project through this repository as it progresses over time (which could either be weeks, months, or years!)

## The current goal of this project (Pong - Completed)
Just as the OSDev wiki mentions, it's always good to have an end goal with such a large project, but to be honest I don't have an actual end goal (as of yet). The *current goal* however is to get the following working:

- [x] Interrupt handler for keyboard input,
- [x] Graphics driver for supporting VGA 8-color graphics with a resolution of 80x25,
- [x] A basic game running, like Pong (in progress at the moment)

The last section of the goal is to get a simple game working, which will require the previous two tasks to work. Pong is a nice and simple game, and it can definitely fit into a bootsector (512 bytes).

Why a game though and not start with an actual kernel? As stated before making an OS takes time, and since I know very little (at the moment) about how to go around it I'll be using mini, ridiculous side projects to help make it easier to grasp. In this case Pong felt like a good introduction for 8086 assembly and how real mode works by incorporating interrupts for the keyboard, conditional logic for collision detection, and other stuff.

## Resources and references
One of the most important parts about OS Dev is finding the right resources and sites to start out. Obviously there is the [OSDev Wiki](https://wiki.osdev.org) which has a surplus of documentation and tutorials to follow. I've created a list of some of the links I'll be using for this project in case anyone is curious:

- [Babysteps Guide](https://wiki.osdev.org/Babystep1) - this is the starting point for the project, it contains a step by step guide for understanding the basics of a bootloader and building one.
- [IBM's VGA Documentation](https://ardent-tool.com/docs/pdf/ibm_vgaxga_trm2.pdf) - to help understand VGA graphics a bit better while devloping the graphics driver.
- [Intel 8086 ISA](https://www.eng.auburn.edu/~sylee/ee2220/8086_instruction_set.html) - Full instruction set for the Intel 8086 assembly language.
- [BIOS Interrupts and Functions](https://ostad.nit.ac.ir/payaidea/ospic/file1615.pdf) - a useful PDF listing several BIOS interrupts and functions that can be used in real mode for setup.

## Next steps  
With a good understanding of assembly and real mode, the next steps for this project are:

- Setup a second-stage bootloader
- Jump to 32-bit protected mode
- Create a simple file system (something like FAT12 or 32)
- Load a kernel written in C from the file system
- Setup some basic utilities like memory allocators, serial output for debugging, and VGA display driver

## Final words
As you can probably tell, this is very casual side project, and it'll probably change a lot as I learn more and get more ideas. Thanks for reading, I hope you stick around for the journey that lies ahead!

El Psy Kongroo
