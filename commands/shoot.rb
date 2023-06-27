require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

module Commands
  class Shoot < Commands::Base
    def name
      :shoot
    end

    def description
      "Shoot someone"
    end

    def execute(event:)
      x = event.options['x']
      y = event.options['y']

      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)
      grid = Commands::Helpers::GenerateGrid.new.run

      range_list = Commands::Helpers::DetermineRange.new.build_range_list(player_x: player.x_position, player_y: player.y_position, player_range: player.range)

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
        player.update(energy: player.energy + target.energy)
        target.update(energy: 0, alive: false, hp: 0)
      end

      event.respond(content: "#{target.username} was shot! #{target.alive ? '' : 'They are dead!'}")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def options
      [
        {
          type: 'integer',
          name: 'x',
          explanation: 'The X coordinate',
          required: true,
        },
        {
          type: 'integer',
          name: 'y',
          explanation: 'The Y coordinate',
          required: true,
        }
      ]
    end
  end
end