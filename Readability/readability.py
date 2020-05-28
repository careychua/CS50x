from cs50 import get_string
from sys import exit

user_ip = get_string("Text: ")
ip_len = len(user_ip)


def main():

    if ip_len == 0:
        exit(1)

    num_lets = let_count()
    num_words = word_count()
    num_sents = sent_count()
    average = 1.0 / num_words * 100

    print_grade(num_lets, num_sents, average)

    # COMPLETE!!!
    exit(0)


# print compute average and print results
def print_grade(num_lets, num_sents, average):
    avg_lets = num_lets * average
    avg_sents = num_sents * average

    index = round(0.0588 * avg_lets - 0.296 * avg_sents - 15.8)

    if index < 1:
        print("Before Grade 1")
    elif index >= 16:
        print("Grade 16+")
    else:
        print("Grade", index)


# count number of sentences
def sent_count():
    count = 0

    for c in user_ip:
        if c == "." or c == "!" or c == "?":
            count += 1

    return count


# count number of words
def word_count():
    # +1 for word at end of sentence that has no space
    count = 1
    for c in user_ip:
        if c.isspace():
            count += 1

    return count


# count total number of letters
def let_count():
    count = 0

    for c in user_ip:
        if c.isalpha():
            count += 1

    return count


# call main() even though order of functions are not right
if __name__ == "__main__":
    main()