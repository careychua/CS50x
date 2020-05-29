from cs50 import get_string
from sys import argv, exit

error_msg = "Usage: python bleep.py dictionary"
input_msg = "What message would you like to censor?\n"

# ensure correct number of arguments
if len(argv) != 2:
    print(error_msg)
    exit(1)

dictionary = set()
txt_filename = argv[1]


def main():
    # read txt file into memory
    dictionary = get_banned_text(txt_filename)
    user_input = get_string(input_msg)
    input_list = user_input.split()
    censored_list = check_words(input_list)
    print_output(censored_list)


def print_output(censored_list):
    censored = ""
    for i in range(len(censored_list)):
        censored += censored_list[i] + " "
    print(censored)


def check_words(input_list):
    for i in range(len(input_list)):
        word = input_list[i].lower()
        if word in dictionary:
            censored_word = replace_word(len(word))
            input_list[i] = censored_word
    return input_list


def replace_word(word_length):
    word = ""
    for i in range(word_length):
        word += "*"
    return word


def get_banned_text(txt_filename):
    dictionary.clear()
    with open(txt_filename) as txt_file:
        for row in txt_file:
            text = row.replace('\n', '')
            dictionary.add(text)
    return dictionary


if __name__ == "__main__":
    main()
