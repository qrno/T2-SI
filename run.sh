#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"
output="${filename%.*}"

echo "Remember to remove io.mac later!!!!!"
nasm -f elf32 "$filename" -o "${output}.o"
if [ $? -ne 0 ]; then
    echo "Error assembling '$filename'"
    exit 1
fi

echo "Remember to remove io.o later!!!!!"
ld -m elf_i386 -s -o "$output" "${output}.o" io.o
if [ $? -ne 0 ]; then
    echo "Error linking '${output}.o'"
    exit 1
fi

echo "Executable '$output' created."

