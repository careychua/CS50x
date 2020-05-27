from sys import argv, exit
import sqlite3


# checklength of command line arguments
if len(argv) != 2:
    print("Usage: python roster.py house")
    exit(1)

# get house
house = argv[1]
db_file = "students.db"

# connect to sql database
connection = sqlite3.connect(db_file)
# initialise cursor
cursor = connection.cursor()

# query database
cursor.execute("SELECT first, middle, last, birth FROM students WHERE house = ? ORDER BY last, first", [house])
# get results
results = cursor.fetchall()

# print results
for row in results:
    first = row[0]
    middle = row[1]
    last = row[2]
    birth = row[3]

    if middle is None:
        print("{} {}, born {}".format(first, last, birth))
    else:
        print("{} {} {}, born {}".format(first, middle, last, birth))

exit(0)