#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename="$1"
output="${filename%.*}"

nasm -f elf32 "$filename" -o "${output}.o"
if [ $? -ne 0 ]; then
    echo "Error assembling '$filename'"
    exit 1
fi

ld -m elf_i386 -s -o "$output" "${output}.o"
if [ $? -ne 0 ]; then
    echo "Error linking '${output}.o'"
    exit 1
fi

echo "Executable '$output' created."

