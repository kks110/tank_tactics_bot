
module Logging
  class BattleReportBuilder
    def self.build(command_name:, player_name:, target_name: nil, amount: nil)
      time = DateTime.now

      game = Game.all.first
      cities = City.all
      energy_cell = EnergyCell.find_by(collected: false)
      peace_votes = PeaceVote.all
      players = Player.all

      {
        timestamp: time,
        command_run: command_name,
        player_name: player_name,
        target_name: target_name,
        amount: amount,
        game: game.to_hash,
        energy_cell: energy_cell.nil? ? [] : energy_cell.to_hash,
        cities: cities.map { |city| city.to_hash },
        peace_votes: peace_votes.nil? ? [] : peace_votes.map { |vote| vote.to_hash },
        players: players.map { |player| player.to_hash }
      }.to_json
    end
  end
end
