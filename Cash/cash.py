# get method get_float() from module cs50
from cs50 import get_float


def main():
    cents = round(get_input()*100)
    coins = [25, 10, 5, 1]
    change = 0

    # iterate through list of coin values
    for coin in coins:
        if cents > 0:
            change += (min_coins(cents, coin))[0]
            cents = (min_coins(cents, coin))[1]
    print(change)


# get number of coins for a coin value
def min_coins(cents, coin_value):
    # get number of <coin_value>cent coins
    coin_num = cents // coin_value
    cents_left = cents % coin_value
    return (coin_num, cents_left)


# check input in non-negative float
def get_input():
    while True:
        f = get_float("Change owed: ")
        if f >= 0:
            return f


if __name__ == "__main__":
    main()