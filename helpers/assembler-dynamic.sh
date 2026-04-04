#!/bin/bash

fileName="${1%%.*}" # remove .s extension

nasm -f elf64 ${fileName}".s" && ld ${fileName}".o" -o ${fileName} -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2 && ./${fileName}
