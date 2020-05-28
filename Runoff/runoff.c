#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max voters and candidates
#define MAX_VOTERS 100
#define MAX_CANDIDATES 9

// preferences[i][j] is jth preference for voter i
int preferences[MAX_VOTERS][MAX_CANDIDATES];

// Candidates have name, vote count, eliminated status
typedef struct
{
    string name;
    int votes;
    bool eliminated;
}
candidate;

// Array of candidates
candidate candidates[MAX_CANDIDATES];

// Numbers of voters and candidates
int voter_count;
int candidate_count;

// Function prototypes
bool vote(int voter, int rank, string name);
void tabulate(void);
bool print_winner(void);
int find_min(void);
bool is_tie(int min);
void eliminate(int min);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: ./runoff [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX_CANDIDATES)
    {
        printf("Maximum number of candidates is %i\n", MAX_CANDIDATES);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i].name = argv[i + 1];
        candidates[i].votes = 0;
        candidates[i].eliminated = false;
    }

    voter_count = get_int("Number of voters: ");
    if (voter_count > MAX_VOTERS)
    {
        printf("Maximum number of voters is %i\n", MAX_VOTERS);
        return 3;
    }

    // Keep querying for votes
    for (int i = 0; i < voter_count; i++)
    {

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            // Record vote, unless it's invalid
            if (!vote(i, j, name))
            {
                printf("Invalid vote.\n");
                return 4;
            }
        }

        printf("\n");
    }

    // Keep holding runoffs until winner exists
    while (true)
    {
        // Calculate votes given remaining candidates
        tabulate();

        // Check if election has been won
        bool won = print_winner();

        if (won)
        {
            break;
        }

        // Eliminate last-place candidates
        int min = find_min();

        bool tie = is_tie(min);

        // If tie, everyone wins
        if (tie)
        {
            for (int i = 0; i < candidate_count; i++)
            {
                if (!candidates[i].eliminated)
                {
                    printf("%s\n", candidates[i].name);
                }
            }
            break;
        }

        // Eliminate anyone with minimum number of votes
        eliminate(min);

        // Reset vote counts back to zero
        for (int i = 0; i < candidate_count; i++)
        {
            candidates[i].votes = 0;
        }
    }

    return 0;
}

// Record preference if vote is valid
bool vote(int voter, int rank, string name)
{
    // printf("---- in vote() ----\n");

    for (int i = 0; i < candidate_count; i++)
    {
        if (strcmp(name, candidates[i].name) == 0)
        {
            preferences[voter][rank] = i;
            // printf("preferences[%i][%i] = %i\n", voter, rank, preferences[voter][rank]);
            return true;
        }
    }

    return false;
}

// Tabulate votes for non-eliminated candidates
void tabulate(void)
{
    printf("---- in tabulate() ----\n");

    // iterates through all voters
    for (int i = 0; i < voter_count; i++)
    {
        printf("voter # : %i\n", i);

        int elim_count = 0;
        // locates votes preference
        while (true)
        {
            if (candidates[preferences[i][elim_count]].eliminated)
            {
                elim_count++;
            }
            else
            {
                candidates[preferences[i][elim_count]].votes++;
                printf("candidate %s's votes: %i\n", candidates[preferences[i][elim_count]].name, candidates[preferences[i][elim_count]].votes);
                break;
            }
        }
    }

    return;
}

// Print the winner of the election, if there is one
bool print_winner(void)
{

    printf("---- in print_winner() ----\n");

    for (int i = 0; i < candidate_count; i++)
    {
        printf("%s's total votes: %i\n", candidates[i].name, candidates[i].votes);
        if ((!candidates[i].eliminated) && (candidates[i].votes > voter_count / 2))
        {
            printf("%s\n", candidates[i].name);
            return true;
        }
    }

    return false;
}

// Return the minimum number of votes any remaining candidate has
int find_min(void)
{
    printf("---- in find_min()----\n");

    int min_votes = candidates[0].votes;

    for (int i = 1; i < candidate_count; i++)
    {
        if (!candidates[i].eliminated && candidates[i].votes < min_votes)
        {
            min_votes = candidates[i].votes;
        }
    }

    printf("min votes: %i\n", min_votes);
    return min_votes;
}

// Return true if the election is tied between all candidates, false otherwise
bool is_tie(int min)
{
    printf("---- in is_tie() ----\n");

    // get number of candidates still in the running
    int non_elim = 0;
    int num_min = 0;

    for (int i = 0; i < candidate_count; i++)
    {
        if (!candidates[i].eliminated)
        {
            non_elim++;

            if (candidates[i].votes == min)
            {
                num_min++;
            }
        }
    }
    printf("no. of candidates still in the running: %i\n", non_elim);
    printf("no. of candidates with min num: %i\n", num_min);

    if (num_min == non_elim)
    {
        return true;
    }

    return false;
}

// Eliminate the candidate (or candidiates) in last place
void eliminate(int min)
{
    printf("---- in eliminate() ----\n");

    for (int i = 0; i < candidate_count; i++)
    {
        if (candidates[i].votes == min)
        {
            candidates[i].eliminated = true;
            printf("%s's eliminated\n", candidates[i].name);
        }
    }

    return;
}
