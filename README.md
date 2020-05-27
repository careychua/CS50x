# CS50x Project
## SQL: Houses


## Project Requirements
In ```import.py```, write a program that imports data from a CSV spreadsheet.
1. The program should accept the name of a CSV file as a command-line argument. 

2. If the incorrect number of command-line arguments are provided, your program should print an error and exit.

3. Assume that the CSV file will exist, and will have columns ```name```, ```house```, and ```birth```.

4. For each student in the CSV file, insert the student into the ```students``` table in the ```students.db``` database.

5. While the CSV file provided to you has just a ```name``` column, the database has separate columns for ```first```, ```middle```, and ```last``` names.

6. Assume that each person’s name field will contain either two space-separated names (a first and last name) or three space-separated names (a first, middle, and last name). 

7. For students without a middle name, you should leave their ```middle``` name field as ```NULL``` in the table.

---

In ```roster.py```, write a program that prints a list of students for a given house in alphabetical order.
1. The program should accept the name of a house as a command-line argument. 

2. If the incorrect number of command-line arguments are provided, your program should print an error and exit.

3. The program should query the ```students``` table in the ```students.db``` database for all of the students in the specified house.

4. The program should print out each student’s full name and birth year (formatted as, e.g., ```Harry James Potter, born 1980``` or ```Luna Lovegood, born 1981```). 

5. Each student should be printed on their own line.

6. Students should be ordered by last name. For students with the same last name, they should be ordered by first name.

---