# CS50x Project
## C Language: Substitution
Implement a program that implements a substitution cipher.

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/psets/2/substitution/)
1. Design and implement a program that encrypts messages using a substitution cipher.

2. The program must accept a single command-line argument, the key to use for the substitution. The key itself should be case-insensitive, so whether any character in the key is uppercase or lowercase should not affect the behavior of your program.

3. If the program is executed without any command-line arguments or with more than one command-line argument, the program should print an error message and return from ```main``` a value of ```1```  immediately.

4. If the key is invalid (as by not containing 26 characters, containing any character that is not an alphabetic character, or not containing each letter exactly once), the program should print an error message and return from ```main``` a value of ```1``` immediately.

5. The program must output ```plaintext:``` (without a newline) and prompt the user for a ```string``` of plaintext.

6. The program must output ```ciphertext:``` (without a newline) followed by the plaintext’s corresponding ciphertext, with each alphabetical character in the plaintext substituted for the corresponding character in the ciphertext; non-alphabetical characters should be outputted unchanged.

7. The program must preserve case: capitalized letters must remain capitalized letters; lowercase letters must remain lowercase letters.

8. After outputting ciphertext, you should print a newline. The program should then exit by returning ```0``` from ```main```.

---