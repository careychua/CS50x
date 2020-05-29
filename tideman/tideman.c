#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j (graph)
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;
int base_num;

// Function prototypes
int check_name(string name);
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
bool no_cycles(int x);
bool no_edges(int x);
void print_winner(void);
bool check_winner(int x);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: ./tideman [candidate ...]\n");
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
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs & initialise preferences[][]
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
            // preferences[i][j] = 0;
            // printf("preferences[%i][%i]: %i\n", i, j, preferences[i][j]);
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes, iterate for every voter
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
            // printf("ranks[%i]: %i\n", j, ranks[j]);
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
}


// check name of user input to be in candidate list, returns candidate number
int check_name(string name)
{
    for (int i = 0; i < candidate_count; i++)
    {
        if (strcmp(name, candidates[i]) == 0)
        {
            return i;
        }
    }

    return -1;
}


// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{
    string candidate_name = name;
    int candidate_number = check_name(candidate_name);

    if (candidate_number >= 0)
    {
        ranks[rank] = candidate_number;
        return true;
    }

    return false;
}

// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    // printf("---- in record_preferences() ----\n");
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            if (i < j)
            {
                preferences[ranks[i]][ranks[j]]++;
            }
            // printf("preferences[ranks[%i]][ranks[%i]]: %i\n", i, j, preferences[ranks[i]][ranks[j]]);
        }
    }
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            // printf("preferences[%i][%i]: %i\n", i, j, preferences[i][j]);

            if (i != j && preferences[i][j] != preferences[j][i])
            {
                if (preferences[i][j] > preferences [j][i])
                {
                    pairs[pair_count].winner = i;
                    pairs[pair_count].loser = j;
                    pair_count++;
                }
            }
        }
    }
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    // printf("---- in sort_pairs() -----\n");
    // printf("pair_count: %i\n", pair_count);

    if (pair_count > 1)
    {
        int swap_count = -1;

        while (swap_count != 0)
        {
            swap_count = 0;

            for (int j = 0; j < pair_count; j++)
            {
                // printf("preferences[pairs[%i].winner][pairs[%i].loser]: %i\n", j, j, preferences[pairs[j].winner][pairs[j].loser]);
                // printf("preferences[pairs[%i].winner][pairs[%i].loser]: %i\n", j + 1, j + 1, preferences[pairs[j + 1].winner][pairs[j + 1].loser]);
                if (preferences[pairs[j].winner][pairs[j].loser] < preferences[pairs[j + 1].winner][pairs[j + 1].loser])
                {
                    pair temp = pairs[j + 1];
                    pairs[j + 1] = pairs[j];
                    pairs[j] = temp;
                    swap_count++;
                }
            }

            if (swap_count == 0)
            {
                return;
            }
        }
    }
}

// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    for (int i = 0; i < pair_count; i++)
    {
        // printf("pairs[%i].winner: %i\n", i, pairs[i].winner);
        // printf("pairs[%i].loser: %i\n", i, pairs[i].loser);

        if (pair_count == 1)
        {
            locked[pairs[i].winner][pairs[i].loser] = true;
            // printf("locked[%i][pairs[%i].loser] = true\n", pairs[i].winner, pairs[i].loser);
            return;
        }
        else if (!locked[pairs[i].winner][pairs[i].loser] && !locked[pairs[i].loser][pairs[i].winner])
        {
            locked[pairs[i].winner][pairs[i].loser] = true;
            // printf("locked[%i][%i] = true\n", pairs[i].winner, pairs[i].loser);

            base_num = pairs[i].winner;

            if (!no_cycles(pairs[i].loser))
            {
                locked[pairs[i].winner][pairs[i].loser] = false;
                // printf("locked[%i][%i] = false\n", pairs[i].winner, pairs[i].loser);
            }
        }
    }
}

// check for cycles
bool no_cycles(int loser)
{
    // printf("---- in no_cycles() ----\n");

    int n = loser;
    // printf("n: %i\n", n);

    if (n == base_num)
    {
        // printf("cycles exist 1\n");
        return false;
    }

    if (!no_edges(n))
    {

        for (int i = 0; i < candidate_count; i++)
        {
            if (locked[n][i])
            {
                if (!no_cycles(i))
                {
                    // printf("cycles exist 2\n");
                    return false;
                }
            }
        }
    }

    // printf("no cycles\n");
    return true;
}

// check for edges
bool no_edges(int x)
{
    int n = x;

    for (int i = 0; i < candidate_count; i++)
    {
        if (locked[n][i])
        {
            // printf("there is an edge\n");
            return false;
        }
    }

    // printf("there are no edges\n");
    return true;
}


// Print the winner of the election
void print_winner(void)
{
    for (int i = 0; i < candidate_count; i++)
    {
        if (check_winner(i))
        {
            printf("%s\n", candidates[i]);
        }
    }
}

// check for winner
bool check_winner(int x)
{
    int n = x;

    for (int i = 0; i < candidate_count; i++)
    {
        if (locked[i][n])
        {
            return false;
        }
    }

    return true;
}