require_relative './base'
require_relative './list'

module Command
  class GameState < Command::Base
    def name
      :game_state
    end

    def description
      "Show the current state of the game"
    end

    def execute(event:, game_data:, bot:)
      game = Game.find_by(server_id: event.server_id)

      response = ''
      response << "Heart location: X:#{Heart.first.coords[:x]} Y:#{Heart.first.coords[:y]}\n" if Heart.first
      response << "Energy Cell location: X:#{EnergyCell.first.coords[:x]} Y:#{EnergyCell.first.coords[:y]}\n" if EnergyCell.first

      response << "Player Count: #{Player.all.count}\n"
      response << "Players Alive: #{Player.all.select { |player| player.alive == true }.count}\n"

      if game.cities
        response << "City Count: #{City.all.count}\n" if game.cities

        response << "Captures Cities: #{City.all.select { |city| city.player_id != nil }.count}"
      end

      event.respond(content: response, ephemeral: true)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
