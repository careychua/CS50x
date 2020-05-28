# CS50x Project
## C Language: Tideman
Implement a program that runs a Tideman election.

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/psets/3/tideman/)
1. Complete the implementation such that it simulates a Tideman election.

2. Complete the ```vote``` function. 
   * The function takes arguments ```rank```, ```name```, and ```ranks```. If ```name``` is a match for the name of a valid candidate, then you should update the ```ranks``` array to indicate that the voter has the candidate as their ```rank``` preference.

    * ```ranks[i]``` here represents the user’s ```i```th preference.

    * The function should return ```true``` if the rank was successfully recorded, and ```false``` otherwise.

    * Assume that no two candidates will have the same name.

3. Complete the ```record_preferences``` function. 
   * The function is called once for each voter, and takes as argument the ```ranks``` array.

   * The function should update the global ```preferences``` array to add the current voter’s preferences.

   * Assume that every voter will rank each of the candidates.

4. Complete the ```add_pairs``` function. 
   * The function should add all pairs of candidates where one candidate is preferred to the ```pairs``` array. A pair of candidates who are tied should not be added to the array.

   * The function should update the global variable ```pair_count``` to be the number of pairs of candidates. (The pairs should thus all be stored between ```pairs[0]``` and ```pairs[pair_count - 1]```).

5. Complete the ```sort_pairs``` function. 
   * The function should sort the ```pairs``` array in decreasing order of strength of victory, where strength of victory is defined to be the number of voters who prefer the preferred candidate. If multiple pairs have the same strength of victory, assume that the order does not matter.

6. Complete the ```lock_pairs``` function. 
   * The function should create the ```locked``` graph, adding all edges in decreasing order of victory strength so long as the edge would not create a cycle.

7. Complete the ```print_winner``` function. 
   
   * The function should print out the name of the candidate who is the source of the graph. Assume there will not be more than one source.

---