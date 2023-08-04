-------------------------
- Add a way to view stats + end game stats
- Come up with some kind of standard notation, and write something that can play out the the game a step at a time
- Fog of war -> try just blocking out the cells completely
- Automate energy distribution
- Line of sight block terrain?
- Alliances? Win by alliance. Create alliance, gives code that allows people to join. Cost double to attach alliance?
- Mines? can be placed? can be swept for? can be destroyed?
- Tests?
- Run rubocop

-------------------------
New updates:
- Fix vote for peace bugs
  - You now can't vote if you are dead
  - Will only send 'vote has started' message if there are no peace votes
- Add breaks so some commands can't run if game is running
- Add battle log reset and more logging at game start
- Fix heart being the wrong font size on the draw full board used for the final grid
- Add ability for players to register interest
- There is a pickup history command which will show where heart and energy cells has spawned
- Hearts and energy cells wont spawn within 2 of where they spawned previously

Bug Fixes:
- Fixed an bug with images where you could be sent someone else's view
