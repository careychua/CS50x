#include <stdio.h>
#include <cs50.h>

int main(void)
{
    // Get input name from user
    string name = get_string("What is your name?\n");

    // Print sentence with user input on screen
    printf("hello, %s\n", name);
}