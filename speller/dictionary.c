// Implements a dictionary's functionality

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "dictionary.h"

#include <string.h>
#include <ctype.h>

// Represents number of children for each node in a trie, alphabets & '
#define N 27

// Represents a node in a trie
typedef struct node
{
    bool is_word;
    struct node *children[N];
}
node;

bool create_node(void);
bool trie(char *s);
unsigned int hash(char c);
void free_node(node *n);

int WORD_COUNT = 0;
node *NEW;

// Represents a trie
node *root;

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Initialize trie
    root = malloc(sizeof(node));
    // check that memory is allocated
    if (root == NULL)
    {
        return false;
    }
    //printf("ROOT load(): %p\n", root);

    root->is_word = false;
    // set all children of node in root to NULL
    for (int i = 0; i < N; i++)
    {
        root->children[i] = NULL;
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

    // Insert words into trie
    while (fscanf(file, "%s", word) != EOF)
    {
        //printf("word: %s\n", word);
        if (!trie(word))
        {
            return false;
        }

        WORD_COUNT++;
    }

    // Close dictionary
    fclose(file);

    // Indicate success
    return true;
}

// create new node
bool create_node(void)
{
    //printf("------------------------\n");
    //printf("... in create_node() ...\n");
    //printf("------------------------\n");

    // initialise node to place new char
    NEW = malloc(sizeof(node));

    // check if memory is allocated to the node
    if (NEW == NULL)
    {
        return false;
    }

    // assign bool value for is_word
    NEW->is_word = false;

    // set all children of new node to NULL
    for (int i = 0; i < N; i++)
    {
        NEW->children[i] = NULL;
    }

    return true;
}

// inputs word into root
bool trie(char *s)
{
    //printf("-------------------\n");
    //printf("...in trie()... s: %s\n", s);
    //printf("-------------------\n");

    int pos = -1;
    int s_len = strlen(s);
    node *cursor = root;

    // iterate through characters of string
    for (int i = 0; i < s_len; i++)
    {
        // get position in array
        //printf("s[%i]: %c\n", i, s[i]);
        pos = hash(s[i]);
        //printf("pos: %i\n", pos);

        if (cursor->children[pos] == NULL)
        {
            // ensure node creation is successful
            if (!create_node())
            {
                return 1;
            }

            if (i == s_len - 1)
            {
                NEW->is_word = true;
            }

            cursor->children[pos] = NEW;
        }

        //printf("... moving to next child...\n");
        node *temp = cursor;
        cursor = temp->children[pos];

        //printf("cursor AFTER move: %p\n", cursor);
        //printf("cursor->is_word: %d\n", cursor->is_word);
        //printf("cursor->children[%i]: %p\n", i, cursor->children[pos]);
    }

    return true;
}


// returns int for the char
unsigned int hash(char c)
{
    //printf("... in  hash ... c: %c\n", c);
    int i = tolower(c) - 'a';
    //printf("... in  hash ... i: %i\n", i);
    return i;
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
    //printf("-------------------\n");
    //printf("...in check()... s: %s\n", word);
    //printf("-------------------\n");

    int pos = -1;
    int word_len = strlen(word);
    node *cursor = root;

    // iterate through characters of string
    for (int i = 0; i < word_len; i++)
    {
        // get position in array
        //printf("word[%i]: %c\n", i, word[i]);
        pos = hash(word[i]);
        //printf("pos: %i\n", pos);

        //printf("cursor BEFORE: %p\n", cursor);
        //printf("cursor->is_word: %d\n", cursor->is_word);
        //printf("cursor->children[%i]: %p\n", i, cursor->children[pos]);

        if (cursor->children[pos] != NULL)
        {
            //printf("... moving to next child...\n");
            node *temp = cursor;
            cursor = temp->children[pos];
            //printf("cursor AFTER move: %p\n", cursor);
            //printf("cursor->is_word: %d\n", cursor->is_word);
            //printf("cursor->children[%i]: %p\n", i, cursor->children[pos]);

            if ((i == word_len - 1) && cursor->is_word)
            {
                return true;
            }
        }
        else
        {
            return false;
        }
    }

    return false;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    free_node(root);
    return true;
}

void free_node(node *n)
{
    node *cursor = n;

    if (cursor != NULL)
    {
        for (int i = 0; i < N; i++)
        {
            //printf("i: %i\n", i);
            //printf("cursor BEFORE: %p\n", cursor);
            //printf("cursor->children[%i] BEFORE: %p\n", i, cursor->children[i]);
            if (cursor->children[i] != NULL)
            {
                // recursion of function
                free_node(cursor->children[i]);
            }
        }

        //printf("... FREE CURSOR ... %p\n", cursor);
        free(cursor);
    }
    //printf("... END ....\n");
}
