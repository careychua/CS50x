# get argv from system library
from sys import argv
# get crypt method from crypt module
import crypt


DICT = []
ALPHA_NUM = 26
PWD_LEN = 1
PWD_HASH = ""
SALT = ""


def main():
    check_argv()
    load_dict()
    # get salt from 1st 2 chars of argv by splicing
    global PWD_HASH
    PWD_HASH = argv[1]
    global SALT
    SALT = PWD_HASH[0:2]
    #print("salt:", salt)
    #print(crypt.crypt("LOL", "50"))
    crack(PWD_HASH)


def crack(pwd_hash):
    #print("in crack")
    #print("pwd_hash:", pwd_hash)
    #print("SALT:", SALT)
    pwd = ""

    if char_1(pwd)[0]:
        print(char_1(pwd)[1])
    else:
        if char_2(pwd)[0]:
            print(char_2(pwd)[1])
        else:
            if char_3(pwd)[0]:
                print(char_3(pwd)[1])
            else:
                if char_4(pwd)[0]:
                    print(char_4(pwd)[1])
                else:
                    if char_5(pwd)[0]:
                        print(char_5(pwd)[1])
                    else:
                        print(char_3(pwd)[1])


# iterate through 5 char str
def char_5(pwd):
    for i in range(len(DICT)):
        temp = pwd + DICT[i]
        if char_4(temp)[0]:
            return (True, char_4(temp)[1])

    return(False,)


# iterate through 4 char str
def char_4(pwd):
    for i in range(len(DICT)):
        temp = pwd + DICT[i]
        if char_3(temp)[0]:
            return (True, char_3(temp)[1])

    return(False,)


# iterate through 3 char str
def char_3(pwd):
    for i in range(len(DICT)):
        temp = pwd + DICT[i]
        if char_2(temp)[0]:
            return (True, char_2(temp)[1])

    return(False,)


# iterate through 2 char str
def char_2(pwd):
    for i in range(len(DICT)):
        temp = pwd + DICT[i]
        if char_1(temp)[0]:
            return (True, char_1(temp)[1])

    return (False,)


# iterate through 1 char str
def char_1(pwd):
    for i in range(len(DICT)):
            temp = pwd + DICT[i]
            # print(temp)
            if PWD_HASH == crypt.crypt(temp, SALT):
                return (True, temp)

    return (False,)

def load_dict():

    global DICT
    dict_upper = []
    dict_lower = []
    start_upper = 65
    start_lower = 97

    # load uppercase dictionary
    for i in range(ALPHA_NUM):
        dict_upper.append(chr(i + start_upper))

    # load lowercase dictionary
    for j in range(ALPHA_NUM):
        dict_lower.append(chr(j + start_lower))

    DICT = dict_upper + dict_lower
    #print("len(DICT):", len(DICT))


# check command line argument
def check_argv():
    if not len(argv) == 2:
        print("Usage: python crack.py hash")
        exit(1)


if __name__ == "__main__":
    main()