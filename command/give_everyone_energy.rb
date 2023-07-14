require_relative './base'

module Command
  class GiveEveryoneEnergy < Command::Base
    def name
      :give_everyone_energy
    end

    def description
      "Distribute daily energy"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      mentions = ""
      players = Player.all
      players.each do |player|
        player.update(energy: player.energy + game_data.daily_energy_amount) if player.alive
        mentions << "<@#{player.discord_id}> "
      end

      response = "Energy successfully distributed! #{mentions}"

      if Heart.count == 0
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample

        Heart.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])

        BattleLog.logger.info("A heart spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}")
        response << " A heart spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}."
      end

      if EnergyCell.count == 0
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample

        EnergyCell.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])

        BattleLog.logger.info("An energy cell spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}")
        response << " An energy cell spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}."
      end

      event.respond(content: response)
    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end