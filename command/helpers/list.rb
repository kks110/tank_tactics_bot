require_relative '../register'
require_relative '../give_everyone_energy'
require_relative '../start_game'
require_relative '../show_board'
require_relative '../move'
require_relative '../increase_hp'
require_relative '../show_energy'
require_relative '../shoot'
require_relative '../increase_range'
require_relative '../give_heart'
require_relative '../give_energy'
require_relative '../help'
require_relative '../instructions'
require_relative '../vote_for_peace'
require_relative '../capture_city'
require_relative '../game_settings'
require_relative '../game_state'
require_relative '../register_interest'
require_relative '../show_pickup_history'
require_relative '../show_my_stats'
require_relative '../show_spectator_board'
require_relative '../show_shot_timer'
require_relative '../ramming_speed'
require_relative '../create_game'
require_relative '../deregister_interest'
require_relative '../show_all_time_stats'
require_relative '../show_rank'

module Command
  module Helpers
    LIST = [
      Help.new,
      Instructions.new,
      Register.new,
      GiveEveryoneEnergy.new,
      StartGame.new,
      ShowBoard.new,
      Move.new,
      IncreaseHp.new,
      ShowEnergy.new,
      Shoot.new,
      IncreaseRange.new,
      GiveHeart.new,
      GiveEnergy.new,
      VoteForPeace.new,
      CaptureCity.new,
      GameSettings.new,
      GameState.new,
      RegisterInterest.new,
      ShowPickupHistory.new,
      ShowMyStats.new,
      ShowSpectatorBoard.new,
      ShowShotTimer.new,
      RammingSpeed.new,
      CreateGame.new,
      DeregisterInterest.new,
      ShowAllTimeStats.new,
      ShowRank.new
    ]
  end
end
