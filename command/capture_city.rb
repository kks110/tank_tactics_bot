require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './options'

module Command
  class CaptureCity < Command::Base
    def name
      :capture_city
    end

    def description
      "Capture a city!"
    end

    def execute(event:, game_data:, bot:)
      game = Game.find_by(server_id: event.server_id)

      ephemeral = game.fog_of_war

      unless game.cities
        event.respond(content: "Cities are not enabled!", ephemeral: ephemeral)
        return
      end

      x = event.options['x']
      y = event.options['y']

      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.energy >= game_data.capture_city_cost
        event.respond(content: "Not enough energy!", ephemeral: ephemeral)
        return
      end

      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        player_x: player.x_position,
        player_y: player.y_position,
        player_range: 1,
        max_x: game.max_x,
        max_y: game.max_y
      )

      unless range_list.include?([y,x])
        event.respond(content: "Not in range! You must be next to the city", ephemeral: ephemeral)
        return
      end

      unless grid[y][x].class == City
        event.respond(content:"No city at that location!", ephemeral: ephemeral)
        return
      end

      target = grid[y][x]

      if grid[y][x].player_id == player.id
        event.respond(content:"You already own this city!", ephemeral: ephemeral)
        return
      end

      player.update(energy: player.energy - game_data.capture_city_cost, city_captures: player.city_captures + 1)

      target.update(player_id: player.id)

      BattleLog.logger.info("#{player.username} captures a city. City X:#{target.x_position} Y:#{target.y_position}")

      event.respond(content: "<@#{player.discord_id}> has captured a city at X:#{target.x_position} Y:#{target.y_position}", ephemeral: ephemeral)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def options
      [
        Command::Options.new(
          type: 'integer',
          name: 'x',
          description: 'The X coordinate',
          required: true,
        ),
        Command::Options.new(
          type: 'integer',
          name: 'y',
          description: 'The Y coordinate',
          required: true,
        )
      ]
    end
  end
end