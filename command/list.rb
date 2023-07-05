require_relative './register'
require_relative './give_everyone_energy'
require_relative './start_game'
require_relative './show_board'
require_relative './move'
require_relative './increase_hp'
require_relative './show_energy'
require_relative './shoot'
require_relative './upgrade_range'
require_relative './give_heart'
require_relative './give_energy'
require_relative './help'
require_relative './instructions'
require_relative './leaderboard'
require_relative './show_range'

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
    UpgradeRange.new,
    GiveHeart.new,
    GiveEnergy.new,
    Leaderboard.new
  ]
end
