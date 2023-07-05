- Move diagonally
- Show tank range
- Check after each command to see if there is a winner
- Run rubocop
- Stop energy transfer on kill
-------------------------
- Reset game
- Automate energy distribution
- Come up with some kind of standard notation, and write something that can play out the the game a step at a time
- Tests?
- Add profile cards?
- Use config for energy costs (or make optional at game start?)
- Use config for board sizes (or make optional at game start?)

  In latest patch:
- At the start of the game, great a game object which hold, max_x, max_y ect instead of counting players
- Make grid players + 3 rater than + 2
- Board is now 'round'
- A heart will spawn when daily energy is given if none exists on the board
- Players and hearts will not spawn within 1 range of each other
