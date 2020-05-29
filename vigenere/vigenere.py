# get arguments from system library
from sys import argv

# get get_string from cs50
from cs50 import get_string


ALPHA_NUM = 26
KEY_COUNT = 0
DICT = {}


def main():
    # get key from commmand line
    input_key = get_input()
    load_dictionary()
    # get plain text from user input
    plain_text = get_string("plaintext: ")
    print_cipher(input_key, plain_text)


def print_cipher(input_key, text):

    print("ciphertext: ", end="")
    for c in text:
        #print("c:", c)
        if c.isalpha():
            temp = ord(c) + get_key(input_key)
            if c.isupper():
                if temp > 90:
                    temp = (temp % 90) + 64
                print(chr(temp), end="")
            else:
                if c.islower:
                    if temp > 122:
                        temp = (temp % 122) + 96
                    print(chr(temp), end="")
        else:
            print(c, end="")
    print()


def get_key(input_key):
    global KEY_COUNT
    #print("KEY_COUNT: ", KEY_COUNT)
    KEY_COUNT %= len(input_key)

    key = [c for c in input_key]
    #print("key[KEY_COUNT]: ", key[KEY_COUNT])
    #print("DICT[key[KEY_COUNT]]: ",DICT[key[KEY_COUNT]])
    value = DICT[key[KEY_COUNT]]

    KEY_COUNT += 1

    #print("value: ", value)
    return value


# load dictionary with key(alphabet) and value(key)
def load_dictionary():

    lower = 65
    upper = 97

    for i in range(ALPHA_NUM):
        # print("----- ")
        #print("i: ", i)
        DICT[chr(lower + i)] = i
        DICT[chr(upper + i)] = i
        #print("lower: ", chr(lower + i), lower+i)
        #print("upper: ", chr(upper + i),  upper+i)


def get_input():
    if len(argv) == 2:
        if argv[1].isalpha():
            return argv[1]

    print("Usage: python vigenere.py key")
    exit(1)


if __name__ == "__main__":
    main()