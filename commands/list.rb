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

module Commands
  LIST = [
    Register.new,
    GiveEveryoneEnergy.new,
    StartGame.new,
    ShowBoard.new,
    Move.new,
    IncreaseHp.new,
    ShowEnergy.new,
    Shoot.new,
    UpgradeRange.new,
    GiveHeart.new
  ]
end