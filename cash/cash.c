#include <stdio.h>
#include <cs50.h>
#include <math.h>

int num_coins;
int rem_coins;

float get_input(void);
int convert_cents(float dollars);
void greedy(int cents);
void coin_reduction(int coin_value);

int main(void)
{
    float dollars = get_input();
    // printf("dollars: %f\n", dollars);

    int cents = convert_cents(dollars);
    // printf("dollars: %i\n", cents);
    greedy(cents);
}

//checks input not negative & returns value
float get_input(void)
{
    float input;

    do
    {
        input = get_float("Change owed: ");
    }
    while (input < 0);

    return input;
}

//converts float to integer
int convert_cents(float dollars)
{
    int cents = round(dollars * 100);

    return cents;
}

//apply greedy algorithm to return least number of coins
void greedy(int cents)
{
    num_coins = 0;
    rem_coins = cents;

    int coin_value;
    int counter = 0;

    while (rem_coins > 0)
    {
        if (rem_coins >= 25)
        {
            coin_reduction(25);
        }
        else if (rem_coins >= 10)
        {
            coin_reduction(10);
        }
        else if (rem_coins >= 5)
        {
            coin_reduction(5);
        }
        else if (rem_coins >= 1)
        {
            coin_reduction(1);
        }
    }

    printf("%i\n", num_coins);
}

void coin_reduction(int coin_value)
{
    num_coins += rem_coins / coin_value;
    rem_coins %= coin_value;
}
