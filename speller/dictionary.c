// Implements a dictionary's functionality
#include <strings.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "dictionary.h"

// Represents number of buckets in a hash table
#define N 26

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
}
node;

// Represents a hash table
node *hashtable[N];

// Represents number of words in the dictionary
int WORD_COUNT;

// Hashes word to a number between 0 and 25, inclusive, based on its first letter
unsigned int hash(const char *word)
{
    return tolower(word[0]) - 'a';
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Initialize hash table
    for (int i = 0; i < N; i++)
    {
        hashtable[i] = NULL;
    }

    // Open dictionary
    FILE *file = fopen(dictionary, "r");
    if (file == NULL)
    {
        unload();
        return false;
    }

    // Buffer for a word
    char word[LENGTH + 1];
    int pos = -1;

    // Insert words into hash table
    while (fscanf(file, "%s", word) != EOF)
    {
        //printf("word: %s\n", word);
        pos = hash(word);
        //printf("pos: %i\n", pos);

        // create new node and check memory is allocated
        node *new_node = malloc(sizeof(node));

        if (new_node == NULL)
        {
            printf("Node not created.\n");
            return 1;
        }

        // assign values to node
        strcpy(new_node->word, word);
        new_node->next = NULL;
        WORD_COUNT++;
        //printf("WORD_COUNT: %i\n", WORD_COUNT);

        // check whether linked list is empty
        if (hashtable[pos] != NULL)
        {
            // insert new node to the front
            for (node *temp = hashtable[pos]; temp != NULL; temp = temp->next)
            {
                //printf("temp->word: %s\n", temp->word);
                //printf("temp->next before: %p\n", temp->next);

                if (temp->next == NULL)
                {
                    temp->next = new_node;
                    //printf("temp->next after: %p\n", temp->next);
                    break;
                }
            }
        }
        else
        {
            // if linked list is empty
            hashtable[pos] = new_node;
            //printf("hashtable[pos]->word: %s\n", hashtable[pos]->word);
            //printf("hashtable[pos]->next: %p\n", hashtable[pos]->next);
        }

        //for (node *dic = hashtable[pos]; dic != NULL; dic = dic->next)
        //{
        //  printf("dic->word: %s\n", dic->word);
        //printf("dic->next: %p\n", dic->next);
        //}

    }

    // Close dictionary
    fclose(file);

    // Indicate success
    return true;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    if (WORD_COUNT > 0)
    {
        //printf("WORD_COUNT: %i\n", WORD_COUNT);
        return WORD_COUNT;
    }
    else
    {
        return 0;
    }
}

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    int pos = -1;

    // check length of word
    if (strlen(word) <= LENGTH + 1)
    {
        pos = hash(word);

        // compare word to linked list value
        for (node *temp = hashtable[pos]; temp != NULL; temp = temp->next)
        {
            if (strcasecmp(temp->word, word) == 0)
            {
                return true;
            }
        }

        return false;

    }
    else
    {
        return false;
    }

}


// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    //printf("...in unload()...\n");

    // iterate through all linked lists
    for (int i = 0; i < N; i++)
    {
        //printf("i: %i\n", i);

        if (hashtable[i] != NULL)
        {
            node *cursor =  hashtable[i];

            while (cursor != NULL)
            {
                node *temp = cursor;
                //printf("cursor: %p\n", cursor);
                //printf("cursor->next: %p\n", cursor->next);
                cursor = cursor->next;
                free(temp);
            }
        }
    }

    return true;
}
