from sys import argv, exit
import csv

if len(argv) != 3:
    print("Usage: python dna.py data.csv seq.txt")
    exit(1)

csv_filename = argv[1]
txt_filename = argv[2]
# print(csv_filename)
# print(txt_filename)


def main():

    # read csv file into memory
    data_list = get_data_headers(csv_filename)
    output = data_list[0]
    dna = data_list.copy()
    dna.pop(0)
    db = populate_entries(data_list, csv_filename)

    # read txt file into memory
    seq = get_seq(txt_filename)
    seq_vals = get_seq_values(dna, seq)

    # check for match
    match(seq_vals, db, output)
    exit(0)


# compare sequence values with database
def match(seq_vals, db, output):

    # iterate through entries of database
    for i in range(len(db)):
        count = 0

        # iterate through value
        for key, value in db[i].items():
            if key in seq_vals.keys():
                if int(value) != int(seq_vals[key]):
                    break
                else:
                    count += 1

        if count == len(seq_vals):
            print(db[i][output])
            break

    if count != len(seq_vals):
        print("No match")


# get values for the sequence
def get_seq_values(dna, seq):
    seq_vals = {}

    for i in range(len(dna)):
        seq_vals[dna[i]] = compute_seq_val(seq, dna[i])

    return seq_vals


# calculate sequence number
def compute_seq_val(seq, dna):

    seq_val = 0
    count = 0
    len_dna = len(dna)
    str_end = len(seq) - len_dna

    # iterate through every character of the sequence
    for i in range(str_end):
        last = i + len_dna
        if seq[i: last] == dna:
            count += 1
            end = last
            while True:
                start = end
                end += len_dna
                if seq[start: end] == dna:
                    count += 1
                else:
                    break
        else:
            count = 0

        if count > seq_val:
            seq_val = count

    return seq_val


# get sequence
def get_seq(txt_filename):

    with open(txt_filename) as txt_file:
        read = txt_file.read()

    return read


# populate data entries
def populate_entries(data_list, csv_filename):

    db = []
    db_entry = {}

    with open(csv_filename, newline='') as csv_file:
        reader = csv.DictReader(csv_file)

        # iterate every entry
        for row in reader:
            # populate entry
            for i in range(len(data_list)):
                db_entry[data_list[i]] = row[data_list[i]]
            # put into database
            db.append(db_entry.copy())
            db_entry.clear()

    return db


# populate data headers list
def get_data_headers(csv_filename):

    data_list = []

    with open(csv_filename, newline='') as csv_file:
        reader = csv.reader(csv_file, delimiter=',')

        for row in reader:
            for i in range(len(row)):
                data_list.append(row[i])
            break

    return data_list


if __name__ == "__main__":
    main()