from sys import argv, exit
import csv
import cs50


# ----get csv file as commandline arguments
# check length of command line argument
if len(argv) != 2:
    print("Usage: python import.py filename.csv")
    exit(1)

# get csv filename
filename = argv[1]
# connect to sql database
db = cs50.SQL("sqlite:///students.db")

# open csv file
with open(filename, 'r') as students:
    reader = csv.DictReader(students, delimiter=',')

    # iterate over every row in file
    for row in reader:

        # split name and assign
        name = row["name"].split()
        first = name[0]

        if len(name) == 2:
            middle = None
            last = name[1]

        if len(name) == 3:
            middle = name[1]
            last = name[2]

        house = row["house"]
        birth = row["birth"]

        # insert student into database
        db.execute("INSERT INTO students (first, middle, last, house, birth) VALUES(?, ?, ?, ?, ?)", first, middle, last, house, birth)

exit(0)