#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// Candidates have name and vote count
typedef struct
{
    string name;
    int votes;
}
candidate;

// Array of candidates
candidate candidates[MAX];

// Number of candidates
int candidate_count;

// Function prototypes
bool vote(string name);
void print_winner(void);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: ./plurality [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
        // printf("Candidate %i: %s\n", i, candidates[i].name);
    }

    int voter_count = get_int("Number of voters: ");

    // Loop over all voters
    for (int i = 0; i < voter_count; i++)
    {
        string name = get_string("Vote: ");

        // Check for invalid vote
        if (!vote(name))
        {
            printf("Invalid vote.\n");
        }
    }

    // Display winner of election
    print_winner();
}

// Update vote totals given a new vote
bool vote(string name)
{
    //printf("---- in vote() ----\n");
    //printf("name: %s\n", name);
    for (int i = 0; i < candidate_count; i++)
    {
        // printf("candidate's name %i : %s\n", i, candidates[i].name);
        // printf("candidate's votes %i : %i\n", i, candidates[i].votes);
        if (strcmp(name, candidates[i].name) == 0)
        {
            candidates[i].votes++;
            // printf("candidate's votes increased to %i\n", candidates[i].votes);
            return true;
        }
    }

    return false;
}

// Print the winner (or winners) of the election
void print_winner(void)
{
    // printf("---- in print_winner() ----\n");

    candidate winner[candidate_count];
    int num_winner = 0;
    winner[num_winner] = candidates[num_winner];

    for (int i = 1; i < candidate_count; i++)
    {
        if (candidates[i].votes > winner[num_winner].votes)
        {
            winner[num_winner] = candidates[i];
        }
        else
        {
            if (candidates[i].votes == winner[num_winner].votes)
            {
                num_winner++;
                winner[num_winner] = candidates[i];
            }
        }
    }

    // printf("num_winner : %i\n", num_winner);

    for (int j = 0; j <= num_winner; j++)
    {
        printf("%s\n", winner[j].name);
    }

    return;
}

