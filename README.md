#Repository code to support paper Universal hashing based on field multiplication and (near-)MDS matrices accepted to 14th International Conference on Cryptology, AfricaCrypt 2023.

Authors: Koustabh Ghosh, Jonathan Fuchs, Parisa Amiri Eliasi, Joan Daemen.

The code is written for ARMv7A architecture, and is tested on the Raspberry Pi 2. Multi265.s file is our main implementation for multi265.
You can run the program either by 

1- Simply run make output '' to compile all the source files, create the object files, link them and generate the final executable named output. Then.\output'' will run the executable file. 

2- Compiling and linking the source files by following commands, 
    1- gcc -g *.c -c
    2- gcc -mfpu=neon -c Nh-mine.s -o Nh-mine.o
    3- gcc -g -o output *.o
    4- ./ouput

Note: Please make sure you have gcc installed on your Raspberry Pi 2. 

BranchNo6Matrix.sage is the sage code used to find suitable 6 x 6 matrices with good diffusion properties.

Multi-265.py is the python code for the multi-265 key-then-hash function.

