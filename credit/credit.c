#include <stdio.h>
#include <cs50.h>

int card_length;
int first_digit;
int first_two_digits;
int digits_from_back[16];
bool checksum;

long get_input(void);
void card_validity(long card_num);
string get_type(long card_num);
void get_details(long card_num);
bool check_sum(void);


int main(void)
{
    long card_num = get_input();

    card_validity(card_num);
}

// get credit card number from user
long get_input(void)
{
    long input;

    do
    {
        input = get_long("Number: ");
    }
    while (input < 0);

    //printf("Input: %ld\n", input);
    return input;
}

// start checks on validity
void card_validity(long card_num)
{
    //printf("in card_validity...\n");

    string card_type = get_type(card_num);

    printf("%s\n", card_type);
}

// get card type
string get_type(long card_num)
{
    //printf("in get_type...\n");

    string card_type;

    get_details(card_num);
    checksum = check_sum();

    if (card_length == 15 && (first_two_digits == 34 || first_two_digits == 37) && checksum)
    {
        card_type = "AMEX";
    }
    else if (card_length == 16 && (first_two_digits >= 51 && first_two_digits <= 55) && checksum)
    {
        card_type = "MASTERCARD";
    }
    else if ((card_length == 13 || card_length == 16) && first_digit == 4 && checksum)
    {
        card_type = "VISA";
    }
    else
    {
        card_type = "INVALID";
    }

    //printf("card_type: %s\n", card_type);
    return card_type;
}

bool check_sum(void)
{
    //printf("in check_sum...\n");

    int odd = 0;
    int even = 0;
    int total = 0;

    for (int i = 0; i < card_length; i += 2)
    {
        odd += digits_from_back[i];
    }

    for (int i = 1; i < card_length; i += 2)
    {
        int temp = digits_from_back[i];
        temp *= 2;
        even += temp / 10 + temp % 10;
    }

    total = odd + even;

    if (total % 10 == 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

// get length and digit details
void get_details(long card_num)
{
    //printf("in get_details...\n");

    long remain_length = card_num;

    card_length = 0;

    while (remain_length > 0)
    {
        digits_from_back[card_length] = remain_length % 10;

        if (remain_length < 10)
        {
            first_digit = remain_length;
        }
        else if (remain_length < 100)
        {
            first_two_digits = remain_length;
        }

        remain_length /= 10;

        card_length++;
        //printf("card_length: %i\n", card_length);
    }
}