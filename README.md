# CS50x Project
## C Language: Runoff
Implement a program that runs a runoff election.

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/psets/3/runoff/)
1. Complete the implementation such that it simulates a runoff election.

2. Complete the ```vote``` function.
   * The function takes arguments ```voter```, ```rank```, and ```name```. If ```name``` is a match for the name of a valid candidate, then you should update the global preferences array to indicate that the voter ```voter``` has that candidate as their ```rank``` preference.

   * If the preference is successfully recorded, the function should return ```true```; the function should return ```false``` otherwise.

   * Assume that no two candidates will have the same name.

3. Complete the ```tabulate``` function.
   * The function should update the number of ```votes``` each candidate has at this stage in the runoff.

   * At each stage in the runoff, every voter effectively votes for their top-preferred candidate who has not already been eliminated.

4. Complete the ```print_winner``` function.
   * If any candidate has more than half of the vote, their name should be printed to ```stdout``` and the function should return ```true```.

   * If nobody has won the election yet, the function should return ```false```.

5. Complete the ```find_min``` function.
   * The function should return the minimum vote total for any candidate who is still in the election.

6. Complete the ```is_tie``` function.
   * The function takes an argument ```min```, which will be the minimum number of votes that anyone in the election currently has.

   * The function should return ```true``` if every candidate remaining in the election has the same number of votes, and should return ```false``` otherwise.

7. Complete the ```eliminate``` function.
   * The function takes an argument ```min```, which will be the minimum number of votes that anyone in the election currently has.
   * The function should eliminate the candidate (or candidates) who have ```min``` number of votes.

---
