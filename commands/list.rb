require_relative './register'
require_relative './give_energy'
require_relative './start_game'

module Commands
  LIST = [
    Register.new,
    GiveEnergy.new,
    StartGame.new
  ]
end