# CS50x Project
## C Language: Caesar
Implement a program that encrypts messages using Caesar’s cipher.

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/psets/2/caesar/)
1. Design and implement a program that encrypts messages using Caesar’s cipher.

2. The program must accept a single command-line argument, a non-negative integer, ```k```.

3. If the program is executed without any command-line arguments or with more than one command-line argument, the program should print an error message and return from ```main``` a value of ```1``` immediately.

4. If any of the characters of the command-line argument is not a decimal digit, the program should print the message ```Usage: ./caesar key``` and return from ```main``` a value of ```1```.

5. Do not assume that ```k``` will be less than or equal to 26. The program should work for all non-negative integral values of k less than 2<sup>31</sup> - 26. If ```k``` is greater than 26, alphabetical characters in your program’s input should remain alphabetical characters in your program’s output.

6. The program must output ```plaintext:``` (without a newline) and prompt the user for a ```string``` of plaintext.

7. The program must output ```ciphertext:``` (without a newline) followed by the plaintext’s corresponding ciphertext, with each alphabetical character in the plaintext “rotated” by ```k``` positions; non-alphabetical characters should be outputted unchanged.

8. The program must preserve case: capitalized letters, though rotated, must remain capitalized letters; lowercase letters, though rotated, must remain lowercase letters.

9. After outputting ciphertext, it should print a newline. The program should then exit by returning ```0``` from ```main```.

---
