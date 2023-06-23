require_relative './register'
require_relative './give_energy'

module Commands
  LIST = [
    Register.new,
    GiveEnergy.new
  ]
end