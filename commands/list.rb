require_relative './register'
require_relative './give_energy'
require_relative './start_game'
require_relative './show_board'

module Commands
  LIST = [
    Register.new,
    GiveEnergy.new,
    StartGame.new,
    ShowBoard.new
  ]
end