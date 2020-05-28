# CS50x Project
## C Language: Speller
Implement a program that spell-checks a file, a la the below, using a hash table.

## Project Requirements
1. Implementation of ```check``` must be case-insensitive.

2. Implementation of check should only return true for words actually in dictionary.

3. Assume that any ```dictionary``` passed to your program will be structured as such, alphabetically sorted from top to bottom with one word per line, each of which ends with ```\n```.

4. Assume that dictionary will contain at least one word, that no word will be longer than ```LENGTH``` (a constant defined in ```dictionary.h```) characters, that no word will appear more than once, that each word will contain only lowercase alphabetical characters and possibly apostrophes, and that no word will start with an apostrophe.

5. Assume that ```check``` will only be passed words that contain (uppercase or lowercase) alphabetical characters and possibly apostrophes.

6. The program may only take ```text``` and, optionally, ```dictionary``` as input.

7. The program must not leak any memory.

---