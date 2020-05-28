# CS50x Project
## Python: DNA

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/psets/6/dna/)
1. The program should require as its first command-line argument the name of a CSV file containing the STR counts for a list of individuals and should require as its second command-line argument the name of a text file containing the DNA sequence to identify. 
   * If the program is executed with the incorrect number of command-line arguments, the program should print an error message of your choice (with ```print```). If the correct number of arguments are provided, you may assume that the first argument is indeed the filename of a valid CSV file, and that the second argument is the filename of a valid text file.
   
2. The program should open the CSV file and read its contents into memory. 
   * Assume that the first row of the CSV file will be the column names. The first column will be the word ```name``` and the remaining columns will be the STR sequences themselves.
   
3. The program should open the DNA sequence and read its contents into memory.

4. For each of the STRs (from the first line of the CSV file), your program should compute the longest run of consecutive repeats of the STR in the DNA sequence to identify.

5. If the STR counts match exactly with any of the individuals in the CSV file, your program should print out the name of the matching individual. 
   * Assume that the STR counts will not match more than one individual.
   * If the STR counts do not match exactly with any of the individuals in the CSV file, your program should print ```No match```.

---
