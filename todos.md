-------------------------
- Automate energy distribution
- Line of sight block terrain?
- Alliances? Win by alliance. Create alliance, gives code that allows people to join. Cost double to attach alliance?
- Mines? can be placed? can be swept for? can be destroyed?
- Add game settings command
- Come up with some kind of standard notation, and write something that can play out the the game a step at a time
- Tests?
- Add profile cards?
- Use config for energy costs (or make optional at game start?)
- Use config for board sizes (or make optional at game start?)
- Run rubocop

-------------------------
New updates:
- Fog of War!
  - What lurks beyond the clouds? All commands are silent and all maps get sent in a DM.
  - You can only see as far as your range
- Cities! At game start they can be enabled.
  - There is a capture city command. It costs 10 energy and you have to be next to the city.
  - For every city held at energy distribution, you will be gain 5 extra energy.
- Add a vote_for_peace command
  - If less than 50% of players are left you can start a vote for peace
  - Over 60% of players must vote for peace within 24 hours for the game to end.
- Add game settings command. This shows info about the game including costs and rewards
- Energy per day increased to 10
- Moving costs 5 energy
- Shooting costs 10 energy
- Increase HP costs 30 energy
- Increasing range costs 30 energy
- Give energy will give 10 by default
- HP pickup now gives 3 HP when collected
- There is now an energy pickup. It gives 30 energy when collected
- Leaderboard has changes. Now shows either Kills or city captures

Bug fixes:
- Could shoot hearts and energy cells
- If range was more than the board size, the draw range command broke

Backend / admin stuff
- Add a reset game command to easily reset
- Daily energy, upgrade costs and rewards are now driven by a config file
- World size now comes from config
