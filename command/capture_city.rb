require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './models/options'

module Command
  class CaptureCity < Command::Base
    def name
      :capture_city
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      true
    end

    def requires_player_not_disabled?
      true
    end

    def description
      "Capture a city within 1 range!"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data
      bot = context.bot

      x = event.options['x']
      y = event.options['y']

      unless player.energy >= game_data.capture_city_cost
        event.respond(content: "Not enough energy!", ephemeral: true)
        return
      end

      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: 1,
        max_x: game.max_x,
        max_y: game.max_y
      )

      unless range_list.include?([y,x])
        event.respond(content: "Not in range! You must be next to the city", ephemeral: true)
        return
      end

      unless grid[y][x].class == City
        event.respond(content:"No city at that location!", ephemeral: true)
        return
      end

      target = grid[y][x]

      if grid[y][x].player_id == player.id
        event.respond(content:"You already own this city!", ephemeral: true)
        return
      end

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

      player.update(energy: player.energy - game_data.capture_city_cost)
      player.stats.update(
        cities_captured: player.stats.cities_captured + 1,
        energy_spent: player.stats.energy_spent + game_data.capture_city_cost
      )

      player_global_stats.update(
        cities_captured: player_global_stats.cities_captured + 1,
        energy_spent: player_global_stats.energy_spent + game_data.capture_city_cost
      )

      previous_owner = target.player

      if previous_owner
        previous_owner.stats.update(cities_lost: previous_owner.stats.cities_lost + 1)
        previous_owner_global_stats = GlobalStats.find_by(player_discord_id: previous_owner.discord_id)
        previous_owner_global_stats.update(cities_lost: previous_owner_global_stats.cities_lost + 1)
      end

      target.update(player_id: player.id)

      Logging::BattleLog.logger.info("#{player.username} captures a city. City X:#{target.x_position} Y:#{target.y_position}")

      if previous_owner
        target_for_dm = bot.user(previous_owner.discord_id)
        target_for_dm.pm("#{player.username} has captured your city at X:#{target.x_position} Y:#{target.y_position}")
      end

      event.channel.send_message 'Someone captured a city!'
      event.respond(content: "You have captured a city at X:#{target.x_position} Y:#{target.y_position}", ephemeral: true)


      cities_owned_count = player.city.count
      if cities_owned_count > player.stats.most_cities_held
        player.stats.update(most_cities_held: cities_owned_count)
      end

      if cities_owned_count > player_global_stats.most_cities_held
        player_global_stats.update(most_cities_held: cities_owned_count)
      end

      Logging::BattleReport.logger.info(Logging::BattleReportBuilder.build(command_name: name, player_name: player.username))
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'integer',
          name: 'x',
          description: 'The X coordinate',
          required: true,
        ),
        Command::Models::Options.new(
          type: 'integer',
          name: 'y',
          description: 'The Y coordinate',
          required: true,
        )
      ]
    end
  end
end