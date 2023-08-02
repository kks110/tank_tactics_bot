require_relative './base'

module Command
  class GiveEveryoneEnergy < Command::Base
    def name
      :give_everyone_energy
    end

    def requires_game?
      true
    end

    def description
      "Distribute daily energy"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      players = Player.all

      BattleLog.logger.info("Daily energy:")
      players.each do |player|
        BattleLog.logger.info("#{player.username} X: #{player.x_position} Y: #{player.y_position} Energy: #{player.energy}")
      end

      if game.cities
        City.all.each do |city|
          if city.player
            city.player.update(energy: city.player.energy + game_data.captured_city_reward) if city.player.alive
            city.player.stats.update(daily_energy_given: city.player.stats.daily_energy_given + game_data.captured_city_reward) if city.player.alive
            BattleLog.logger.info("#{city.player.username} has a city. Giving energy. New energy: #{city.player.energy}")
          end
        end
      end

      players = Player.all

      mentions = ""
      players.each do |player|
        player.update(energy: player.energy + game_data.daily_energy_amount) if player.alive
        player.stats.update(daily_energy_given: player.stats.daily_energy_given + game_data.daily_energy_amount) if player.alive
        BattleLog.logger.info("Giving energy to #{player.username}. New energy: #{player.energy}")
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

      Player.all.each do |player|
        if player.energy > player.stats.highest_energy
          player.stats.update(highest_energy: player.energy)
        end
      end

      event.respond(content: response)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end