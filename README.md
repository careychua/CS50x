# CS50x Project
## Python: Caesar
Implement a program that encrypts messages using Caesar’s cipher.

---

## [Project Requirements](https://docs.cs50.net/2019/x/psets/6/sentimental/caesar/caesar.html)
1. Design and implement a program that encrypts messages using Caesar’s cipher.

2. The program must accept a single command-line argument, a non-negative integer, ```k```.

3. If the program is executed without any command-line arguments or with more than one command-line argument, your program should print an error message and exit immediately with a status code of 1.

4. Assume that, if a user does provide a command-line argument, it will be a non-negative integer.

5. Do not assume that ```k``` will be less than or equal to 26. The program should work for all non-negative integral values of ```k``` less than 2<sup>31</sup> - 26. The alphabetical characters in your program’s input should remain alphabetical characters in your program’s output.

6. The program must output ```plaintext:``` (without a newline) and then prompt the user for a ```string``` of plaintext.

7. The program must output ```ciphertext:``` (without a newline) followed by the plaintext’s corresponding ciphertext, with each alphabetical character in the plaintext "rotated" by k positions; non-alphabetical characters should be outputted unchanged.

8. The program must preserve case: capitalized letters, though rotated, must remain capitalized letters; lowercase letters, though rotated, must remain lowercase letters.

9.  After outputting ciphertext, it should print a newline.

---
