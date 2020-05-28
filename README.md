# CS50x Project
## Python: Vigenere
Implement a program that encrypts messages using Vigenère’s cipher.

---

## [Project Requirements](https://docs.cs50.net/2019/x/psets/6/sentimental/vigenere/vigenere.html)
1. Design and implement a program that encrypts messages using Vigenère’s cipher.

2. The program must accept a single command-line argument: a keyword, ```k```, composed entirely of alphabetical characters.

3. If the program is executed without any command-line arguments, with more than one command-line argument, or with one command-line argument that contains any non-alphabetical character, the program should print an error and exit immediately with a status code of 1.

4. The program proceed to prompt the user for a string of plaintext, ```p```, (as by a prompt for ```plaintext:```) which it must then encrypt according to Vigenère’s cipher with ```k```, print the result (prepended with ```ciphertext:``` and ending with a newline) and exiting.

5. With respect to the characters in ```k```, you must treat ```A``` and ```a``` as 0, ```B``` and ```b``` as 1, …​ , and ```Z``` and ```z``` as 25.

6. The program must only apply Vigenère’s cipher to a character in ```p``` if that character is a letter. All other characters must be outputted unchanged. If your code is about to apply the *j*th character of ```k``` to the *i*th character of ```p```, but the latter proves to be a non-alphabetical character, you must wait to apply that *j*th character of ```k``` to the next alphabetical character in ```p```; you must not yet advance to the next character in ```k```.

7. The program must preserve the case of each letter in ```p```.

---