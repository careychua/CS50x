# get method get_int() from module cs50
from cs50 import get_int


def main():
    pyramid(get_input())


# check input is between 1 and 8
def get_input():
    while True:
        i = get_int("Height: ")
        if i > 0 and i < 9:
            return i


def pyramid(n):
    # iterate row
    for i in range(1, n+1):
        # print space
        for j in range(n-i):
            print(" ", end="")
        # print #s
        for k in range(i):
            print("#", end="")
        print()


if __name__ == "__main__":
    main()