-------------------------
- Make round map optional? Flag at start up, math get based of that
- Automate energy distribution
- Fog of war?
- Line of sight block terrain?
- Cities? if you capture them, you get more energy per turn
- Alliances? Win by alliance. Create alliance, gives code that allows people to join.
- Mines? can be placed? can be swept for? can be destroyed?
- Come up with some kind of standard notation, and write something that can play out the the game a step at a time
- Tests?
- Add profile cards?
- Use config for energy costs (or make optional at game start?)
- Use config for board sizes (or make optional at game start?)
- Run rubocop

-------------------------
New updates:
- Energy per day increased to 10
- Moving costs 5 energy
- Shooting costs 10 energy
- Increase HP costs 30 energy
- Increasing range costs 30 energy
- Give energy will give 10 by default
- HP pickup now gives 3 HP when collected
- There is now an energy pickup. It gives 30 energy when collected

Bug fixes:
- Could shoot hearts and energy cells
- If range was more than the board size, the draw range command broke

Backend / admin stuff
- Add a reset game command to easily reset
- Daily energy, upgrade costs and rewards are now driven by a config file
