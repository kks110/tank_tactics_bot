require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './options'

module Command
  class Shoot < Command::Base
    def name
      :shoot
    end

    def description
      "Shoot someone"
    end

    def execute(event:)
      x = event.options['x']
      y = event.options['y']

      user = event.user
      player = Player.find_by(discord_id: user.id)
      game = Game.find_by(server_id: event.server_id)
      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        player_x: player.x_position,
        player_y: player.y_position,
        player_range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!")
        return
      end

      unless player.energy > 0
        event.respond(content: "Not enough energy!")
        return
      end

      if grid[y][x].nil?
        event.respond(content:"No tank at that location!")
        return
      end

      target = grid[y][x]

      unless target.alive
        event.respond(content:"Tank is already dead!")
        return
      end

      player.update(energy: player.energy - 1)

      target.update(hp: target.hp - 1)

      if target.hp <= 0
        player.update(kills: player.kills + 1)
        target.update(alive: false, hp: 0, deaths: target.deaths + 1)
      end

      BattleLog.logger.info("#{player.username} shot #{target.username}! #{target.username}: HP: #{target.hp}")

      event.respond(content: "<@#{target.discord_id}> was shot by #{player.username}! #{target.alive ? '' : 'They are dead!'}")

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