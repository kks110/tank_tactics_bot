require_relative './base'

module Command
  class GiveEveryoneEnergy < Command::Base
    def name
      :give_everyone_energy
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Distribute daily energy"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      unless game.started
        puts 'Game has not started!'
        return
      end

      unless player.username == 'kks110'
        event.respond(content: "Sorry! Only kks110 can do this!")
        return
      end

      players = Player.all

      Logging::BattleLog.logger.info("Daily energy:")
      players.each do |player|
        Logging::BattleLog.logger.info("#{player.username} X: #{player.x_position} Y: #{player.y_position} Energy: #{player.energy}")
      end

      City.all.each do |city|
        if city.player
          city.player.update(energy: city.player.energy + game_data.captured_city_reward) if city.player.alive?
          city.player.stats.update(daily_energy_received: city.player.stats.daily_energy_received + game_data.captured_city_reward) if city.player.alive?
          player_global_stats = GlobalStats.find_by(player_discord_id: city.player.discord_id)
          player_global_stats.update(daily_energy_received: player_global_stats.daily_energy_received + game_data.captured_city_reward) if city.player.alive?

          Logging::BattleLog.logger.info("#{city.player.username} has a city. Giving energy. New energy: #{city.player.energy}")
        end
      end

      players = Player.all

      mentions = ""
      players.each do |player|
        player.update(energy: player.energy + game_data.daily_energy_amount) if player.alive?
        player.stats.update(daily_energy_received: player.stats.daily_energy_received + game_data.daily_energy_amount) if player.alive?
        player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
        player_global_stats.update(daily_energy_received: player_global_stats.daily_energy_received + game_data.daily_energy_amount) if player.alive?
        Logging::BattleLog.logger.info("Giving energy to #{player.username}. New energy: #{player.energy}")
        mentions << "<@#{player.discord_id}> " if player.alive?
      end

      response = "Energy successfully distributed! #{mentions}"

      unless EnergyCell.find_by(collected: false)
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample

        EnergyCell.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])

        Logging::BattleLog.logger.info("An energy cell spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}")
        response << " An energy cell spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}."
      end

      Player.all.each do |player|
        player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

        if player.energy > player.stats.highest_energy
          player.stats.update(highest_energy: player.energy)
        end

        if player.energy > player_global_stats.highest_energy
          player_global_stats.update(highest_energy: player.energy)
        end
      end

      event.respond(content: response)

      Logging::BattleReport.logger.info(
        Logging::BattleReportBuilder.build(
          command_name: name,
          player_name: player.username
        )
      )
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
