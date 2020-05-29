#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

// global variables
int KEY = 0;
int UPPER = 65;
int LOWER = 97;
int NUM_ALPHA = 26;

// prototypes for functions
bool check_int(string input_key);
void cipher(string input);


int main(int argc, string argv[])
{
    string input_key = argv[1];

    // check command line
    if (argc == 2 && check_int(input_key))
    {
        string input_text = get_string("plaintext: ");
        cipher(input_text);
    }
    else
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
}


// encrypt and print cipher text
void cipher(string input)
{
    // printf("---- in cipher() ----\n");

    string plain_text = input;
    string cipher_text = input;
    int len = strlen(input);

    printf("ciphertext: ");

    for (int i = 0; i < len; i++)
    {
        if (isalpha(plain_text[i]))
        {
            if (isupper(plain_text[i]))
            {
                cipher_text[i] = ((plain_text[i] + KEY - UPPER) % NUM_ALPHA) + UPPER;
            }
            else
            {
                cipher_text[i] = ((plain_text[i] + KEY - LOWER) % NUM_ALPHA) + LOWER;
            }
        }

        printf("%c", cipher_text[i]);
    }

    printf("\n");
}


bool check_int(string input_key)
{
    // printf("---- in check_int() ----\n");

    int len = strlen(input_key);
    string key = input_key;

    for (int i = 0; i < len; i++)
    {
        if (!isdigit(key[i]))
        {
            return false;
        }
    }

    KEY = atoi(key);
    // printf("KEY: %i\n", KEY);

    return true;
}