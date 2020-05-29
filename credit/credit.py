# get method get_int from module cs50
from cs50 import get_int


def main():
    card_input = get_input()
    card_num = card_input[0]
    card_type = card_input[1]

    if not card_type == "INVALID":
        # put card numbers into int list
        card = [int(c) for c in card_num]
        card_type = check_start(card, card_type)

        if not card_type == "INVALID":
            if not check_sum(card):
                card_type = "INVALID"

    print(card_type)


# apply algorithm on card numbers
def check_sum(card):
    tot_sum = 0

    # get every other digit from last 2nd, each multiply by 2
    for i in range(len(card)-2, -1, -2):
        # print("------")
        #print("i: ", i)
        tot_sum += ((card[i]*2) // 10) + ((card[i]*2) % 10)
        #print("tot_sum: ", tot_sum)

    # get the rest of the digits and add together
    for j in range(len(card)-1, -1, -2):
        # print("------")
        #print("j: ", j)
        #print("card[j]: ", card[j])
        tot_sum += card[j]

    #print("tot_sum: ", tot_sum)
    # check last digit is 0
    while True:
        tot_sum %= 10
        if tot_sum < 10 and tot_sum == 0:
            return True
        else:
            return False


# check the starting numbers of the card
def check_start(card, card_type):
    #print("card[0]: ", card[0])
    #print("card[1]: ", card[1])
    #print("card_type: ", card_type)
    #print("len(card_type): ", len(card_type))

    # check AMEX
    if card[0] == 3:
        if card[1] == 4 or card[1] == 7:
            if card_type == "AMEX":
                return "AMEX"

    # check MASTERCARD
    if card[0] == 5:
        if card[1] >= 1 or card[1] <= 5:
            if card_type == "MASTERCARD" or card_type == "Master/Visa":
                return "MASTERCARD"

    # check VISA
    if card[0] == 4:
        if card_type == "VISA" or card_type == "Master/Visa":
            return "VISA"

    return "INVALID"


# check input and return num
def get_input():
    card_type = ""
    while True:
        card_num_int = get_int("Number: ")
        card_num = str(card_num_int)

        if card_num_int > 0:
            #print("card num > 0")
            if len(card_num) == 15:
                #print("card length == 15")
                card_type = "AMEX"
            elif len(card_num) == 13:
                #print("card length == 13")
                card_type = "VISA"
            elif len(card_num) == 16:
                #print("card length == 16")
                card_type = "Master/Visa"
            else:
                #print("card length == not valid")
                card_type = "INVALID"

        if card_type:
            #print ("cardtype not null")
            break

    #print("card type: ", card_type)
    #print("card num: ", card_num)
    return (card_num, card_type)


if __name__ == "__main__":
    main()