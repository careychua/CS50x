# get command line arguments from system library
from sys import argv
# get method get_string from module cs50
from cs50 import get_string


def main():
    # get key from command line input
    key = get_argv()
    # get text from user
    plain_text = get_string("plaintext: ")

    print_cipher(plain_text, key)


def print_cipher(text, key):
    print("ciphertext: ", end="")
    for c in text:
        if c.isalpha():
            # get ascii value of char
            temp = ord(c)
            temp += key

            # cipher uppercase char
            if c.isupper():
                while True:
                    if temp >= 65 and temp <= 90:
                        break
                    else:
                        temp = (temp % 90) + 64
                print(chr(temp), end="")

            # cipher lowercase char
            if c.islower():
                while True:
                    if temp >= 97 and temp <= 122:
                        break
                    else:
                        temp = (temp % 122) + 96

                print(chr(temp), end="")
        else:
            print(c, end="")

    print()


def get_argv():
    if len(argv) == 2:
        i = int(argv[1])
        if i >= 0:
            return i
    print("Usage: python caesar.py key")
    exit(1)


if __name__ == "__main__":
    main()