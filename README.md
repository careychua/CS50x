# CS50x Project
## C Language: Resize(More)
Implement a program that resizes BMPs.

---

## Project Requirements
1. Implement a program that resizes 24-bit uncompressed BMPs by a factor of ```f```.

2. The program should accept exactly three command-line arguments, where

   * the first (```f```) must be a floating-point value in the range (0.0, 100.0] (ie., a positive value less than or equal to 100.0),

   * the second must be the name of a BMP to be resized, and

   * the third must be the name of the resized version to be written.

3. If the program is not executed with such arguments, it should remind the user of correct usage, and ```main``` should return ```1```.

4. The program, if it uses ```malloc```, must not leak any memory.

---