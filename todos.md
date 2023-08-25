-------------------------
- Come up with some kind of standard notation, and write something that can play out the the game a step at a time
- Fog of war -> try just blocking out the cells completely
- Automate energy distribution
- Line of sight block terrain?
- Alliances? Win by alliance. Create alliance, gives code that allows people to join. Cost double to attach alliance?
- Mines? can be placed? can be swept for? can be destroyed?
- Tests?
- Run rubocop

-------------------------

Nerfs:
- Energy cells now gives 20 energy.
- Range increase now costs 30 + 10 per addition level eg:
  - 2 > 3 costs 30
  - 3 > 4 costs 40
  - 4 > 5 costs 50

Changes:
- Shot cost increase per shot per 24 hours. This resets at 24 hours after the first shot NOT at energy distribution.
  - The first shot cost 10, and will then increase by 5 for each additional shot resetting back to 10 after 24 hours.

New Commands:
- `/show_spectator_board` - Spectator Mode! Will send a spectator a DM with the bord. Pls dont cheat.

Backend:
- Energy distribution is now automated (hopefully). It will give energy at 19:30 every day.
- Starting range, hp and energy is now configurable via config file.
- Base range and shot costs and incremental costs now configurable via file.
- Created the shots table to keep track of when people shoot.
