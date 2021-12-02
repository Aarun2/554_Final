#!/usr/bin/env python3
import random

#############################################
# This functions takes in a filepath and    #
# adds numbers for memory initialization.   #
# The numbers are added in hex so user can  #
# read this with a readmemh command.        #
#############################################

def randGen (filepath, entries, num_bytes):
    fh = open(filepath, "w");
    for line in range(entries):
        print_str = ""
        for bytes in range(num_bytes):
            print_str += hex(random.randrange(0, 16))[2:]
        fh.write(print_str + "\n")
    fh.close()

if __name__ == '__main__':
    randGen("./instr_mem.txt", 10, 8)
