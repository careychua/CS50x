#include <stdio.h>
#include <cs50.h>
#include <ctype.h>
#include <string.h>


// global variables
int NUM_ALPHA = 26;
int UPPER = 65;
int LOWER = 97;
int NUM_KEY[26];


// prototypes for functions
bool check_key(string input_key);
bool convert_key(string input_key);
void cipher(string input_text);


int main(int argc, string argv[])
{
    string input_key = argv[1];

    if (argc == 2 && check_key(input_key) && convert_key(input_key))
    {
        string input_text = get_string("plaintext: ");

        cipher(input_text);
    }
    else
    {
        // error handling
        printf("Usage: ./substitution key\n");
        return 1;
    }
}


// encrypt and print plain text
void cipher(string input_text)
{
    // printf("---- cipher() ----\n");

    string plain_text =  input_text;
    string cipher_text = plain_text;
    int len = strlen(plain_text);

    printf("ciphertext: ");

    for (int i = 0; i < len; i++)
    {
        if (isupper(plain_text[i]))
        {
            cipher_text[i] = NUM_KEY[plain_text[i] - UPPER] + UPPER;
        }
        else if (islower(plain_text[i]))
        {
            cipher_text[i] = NUM_KEY[plain_text[i] - LOWER] + LOWER;
        }
        else
        {
            cipher_text[i] = plain_text[i];
        }

        printf("%c", cipher_text[i]);
    }

    printf("\n");
}


bool convert_key(string input_key)
{
    // printf("---- check_key() ----\n");

    string key = input_key;
    bool dup_key[NUM_ALPHA];

    for (int j = 0; j < NUM_ALPHA; j++)
    {
        dup_key[j] = false;
    }

    for (int i = 0; i < NUM_ALPHA; i++)
    {
        if (isupper(key[i]))
        {
            NUM_KEY[i] = key[i] - UPPER;
        }
        else
        {
            NUM_KEY[i] = key[i] - LOWER;
        }

        // check for duplicate alphabets
        if (dup_key[NUM_KEY[i]])
        {
            return false;
        }
        else
        {
            dup_key[NUM_KEY[i]] = true;
        }

        // printf("key[%c]: %i\n", i, key[i]);
        // printf("NUM_KEY[%i]: %i\n", i, NUM_KEY[i]);
    }

    return true;
}


// check command line argument
bool check_key(string input_key)
{
    // printf("---- check_key() ----\n");

    string key = input_key;
    int len = strlen(key);

    if (len == NUM_ALPHA)
    {
        for (int i = 0; i < len; i++)
        {
            if (!isalpha(key[i]))
            {
                return false;
            }
        }

        return true;
    }

    return false;
}