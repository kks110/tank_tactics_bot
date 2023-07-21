require_relative './register'
require_relative './give_everyone_energy'
require_relative './start_game'
require_relative './show_board'
require_relative './move'
require_relative './increase_hp'
require_relative './show_energy'
require_relative './shoot'
require_relative './increase_range'
require_relative './give_heart'
require_relative './give_energy'
require_relative './help'
require_relative './instructions'
require_relative './leaderboard'
require_relative './show_range'
require_relative './reset_game'
require_relative './vote_for_peace'
require_relative './capture_city'
require_relative './game_settings'
require_relative './game_state'


module Command
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
    ShowRange.new,
    Shoot.new,
    IncreaseRange.new,
    GiveHeart.new,
    GiveEnergy.new,
    Leaderboard.new,
    ResetGame.new,
    VoteForPeace.new,
    CaptureCity.new,
    GameSettings.new,
    GameState.new
  ]
end
