#!/bin/bash
nasm -f elf32 calculadora.asm -o calculadora.o
ld -m elf_i386 -s -o calculadora calculadora.o
./calculadora
