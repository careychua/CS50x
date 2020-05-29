#include <stdio.h>
#include <cs50.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

//prototypes of functions
int letter_count(string user_input, int input_len);
int word_count(string user_input, int input_len);
int sentence_count(string user_input, int input_len);
void print_grade(int num_letters, int num_sentences);

float AVG = 0;

int main(void)
{
    string user_input = get_string("Text: ");
    int input_len = strlen(user_input);
    //  printf("input_len = %i\n", input_len);

    if (input_len == 0)
    {
        return 1;
    }

    int num_letters = letter_count(user_input, input_len);
    int num_words = word_count(user_input, input_len);
    int num_sentences = sentence_count(user_input, input_len);

    AVG = 1.0 / num_words * 100;
    //  printf("avg = %f\n", avg);

    print_grade(num_letters, num_sentences);
}


void print_grade(int num_letters, int num_sentences)
{
    // printf("----- in index() -----\n");

    float avg_letters = num_letters * AVG;
    // printf("avg_letters = %f\n", avg_letters);
    float avg_sentences = num_sentences * AVG;
    // printf("avg_sentences = %f\n", avg_sentences);

    int index = round(0.0588 * avg_letters - 0.296 * avg_sentences - 15.8);
    // printf("index = %i\n", index);

    if (index < 1)
    {
        printf("Before Grade 1\n");
    }
    else if (index >= 16)
    {
        printf("Grade 16+\n");

    }
    else
    {
        printf("Grade %i\n", index);
    }
}


int sentence_count(string user_input, int input_len)
{
    // printf("----- in sentence_count() -----\n");

    int counter = 0;
    int len = input_len;
    string input = user_input;

    for (int i = 0; i < len; i++)
    {
        if (input[i] == 33 || input[i] == 46 || input[i] == 63)
        {
            counter++;
        }
    }

    // printf("counter: %i\n", counter);
    return counter;
}


int word_count(string user_input, int input_len)
{
    // printf("----- in word_count() -----\n");

    // +1 for word at the end of the sentence that has no space
    int counter = 1;
    int len = input_len;
    string input = user_input;

    for (int i = 0; i < len; i++)
    {
        if (isspace(input[i]))
        {
            counter++;
        }
    }

    // printf("counter: %i\n", counter);
    return counter;
}


int letter_count(string user_input, int input_len)
{
    // printf("----- in letter_count() -----\n");

    int counter = 0;
    int len = input_len;
    string input = user_input;

    for (int i = 0; i < len; i++)
    {
        if (isalpha(input[i]))
        {
            counter++;
        }
    }

    // printf("counter: %i\n", counter);
    return counter;
}