# CS50x Project
## Python: Bleep
Implement a program that censors messages that contain words that appear on a list of supplied "banned words."

---

## [Project Requirements](https://docs.cs50.net/2019/x/psets/6/bleep/bleep.html)
1. Accepts as its sole command-line argument the name (or path) of a dictionary of banned words.

2. Opens and reads from that file the list of words stored, one per line, and stores each in a Python data structure for later access.

3. If no command line argument is provided, the program will exit with a status code of 1.

4. Assume that any text files will have one word per line (each line terminated with a \n), and any alphabetic characters in those words will be lowercase.

5. Prompts the user to provide a message.

6. Tokenizes that message into its individual component words, using the ```split``` method on the provided string, and then iterates over the ```list``` of "tokens" (words) that is returned by calling split, checking to see whether any of the tokens match, case-insensitively, any of the words in the banned words list.

7. Prints back the message that the user provided, except if the message contained any banned words, each of its characters is replaced by a ```*```.

8. Should not censor words that merely contain a banned word as a substring.

9.  Do not need to support input strings that contain punctuation marks. Assume input is only separated by whitespace.

---