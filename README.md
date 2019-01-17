# Minsweeper
Written in Ruby. A remake of the classic game found on all Windows computers of yesteryear. Games can be saved and reloaded. However, loaded games aren't eligible for the leaderboard.

## Goal of Game
Reveal all of the numbered and empty spaces without hitting any mines.

## Gameplay
Input a coordinate (e.g. 0,0) and an action (flag or reveal). Once complete the relevant space will be revealed or flagged on the board. If the space contains a mine, game over. Otherwise, a number or empty space with cascade will be revealed.

## First Click
It's not possible to hit a mine on the first click. The board is generated after the first click to ensure safety.

## Leaderboard
The leaderboard displays the top 10 players for each difficulty rating / level. Scores are saved in leaderboard.yml. If the file is not found on the hard drive, a .yml file is created.
