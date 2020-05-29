#include <cs50.h>
#include <stdio.h>

int height;

int user_input(void);
void create_steps(int steps_number);
void put_spaces(int i);
void put_steps(int i);

int main(void)
{
    height = user_input();
    create_steps(height);
}

// checks user input & returns proper value
int user_input(void)
{
    int input;

    do
    {
        input = get_int("Height: ");
    }
    while (input < 1 || input > 8);

    return input;
}


// create pyramid
void create_steps(int steps_number)
{
    // by line from top
    for (int i = 0; i < steps_number; i++)
    {
        put_spaces(i);
        put_steps(i);
        printf("\n");
    }
}

//plotting the spaces in the line
void put_spaces(int i)
{
    int num_spaces = height - i - 1;

    for (int j = 0; j < num_spaces; j++)
    {
        printf(" ");
    }
}

//plotting the bricks in the line
void put_steps(int i)
{
    i++;

    for (int j = 0; j < i; j++)
    {
        printf("#");
    }
}