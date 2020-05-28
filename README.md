# CS50x Project
## Games (Lua): Mario

![CS50x Mario](README/CS50x-Mario.gif)


For further information on how to run the game, [please click here](https://love2d.org/wiki/Getting_Started)

---

## Game Controls
* Left and right arrows : Movement
* Spacebar : Jump
* Esc : Quit Application

---

## [Project Requirements](https://cs50.harvard.edu/x/2020/tracks/games/mario/)
1. Add a pyramid of blocks to the generated level. Taking into consideration the column-based generation we discussed in the track, find a way to generate a Mario-style pyramid like the below, placed directly atop the ground (ASCII flag to the right shown as well):
```
          #      ~
         ##      |
        ###      |
       ####      |
    ###############
```

2. Add a flag at the end of the level that either loads a new level or simply displays a victory message to the screen. Also tied to generation, this time take the flag and flagpole sprites included in the distro’s sprite sheet and create a flagpole at the end of the level that, upon Mario’s collision, triggers either a victory message or a reloading of a brand new procedurally generated level.

---
