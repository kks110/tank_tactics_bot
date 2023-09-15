require_relative './base'

module Command
  class GameState < Command::Base
    def name
      :game_state
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def description
      "Show the current state of the game"
    end

    def execute(context:)
      event = context.event
      heart = Heart.find_by(collected: false)
      energy_cell = EnergyCell.find_by(collected: false)

      response = ''
      response << "Heart location: X:#{heart.coords[:x]} Y:#{heart.coords[:y]}\n" if heart
      response << "Energy Cell location: X:#{energy_cell.coords[:x]} Y:#{energy_cell.coords[:y]}\n" if energy_cell

      response << "Player Count: #{Player.all.count}\n"
      response << "Players Alive: #{Player.all.select { |player| player.alive == true }.count}\n"

      response << "City Count: #{City.all.count}\n"
      response << "Captures Cities: #{City.all.select { |city| city.player_id != nil }.count}"

      event.respond(content: response, ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
