require_relative './base'
require_relative './helpers/generate_grid'

module Commands
  class Move < Commands::Base
    def name
      :move
    end

    def description
      "Move your tank"
    end

    def execute(event:)
      direction = event.options['direction']

      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)
      grid = Commands::Helpers::GenerateGrid.new.run

      raise 'Not enough energy' unless player.energy > 0

      case direction
      when 'up'
        raise 'Cant move up' if player.y_position == 0
        raise 'Player in the way' unless grid[player.y_position - 1][player.x_position].nil?

        player.update(y_position: player.y_position - 1, energy: player.energy - 1)
        event.respond(content: "Moved!")
      when 'down'
        raise 'Cant move down' if player.y_position == grid.length - 1
        raise 'Player in the way' unless grid[player.y_position + 1][player.x_position].nil?

        player.update(y_position: player.y_position + 1, energy: player.energy - 1)
        event.respond(content: "Moved!")
      when 'left'
        raise 'Cant move left' if player.x_position == 0
        raise 'Player in the way' unless grid[player.y_position][player.x_position - 1].nil?

        player.update(x_position: player.x_position - 1, energy: player.energy - 1)
        event.respond(content: "Moved!")
      when 'right'
        raise 'Cant move right' if player.x_position == grid[0].length - 1
        raise 'Player in the way' unless grid[player.y_position][player.x_position + 1].nil?

        player.update(x_position: player.x_position + 1, energy: player.energy - 1)
        event.respond(content: "Moved!")
      end

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def options
      {
        string: {
          name: 'direction',
          explanation: 'Pick your direction, Up, Down, Left or Right',
          required: true,
          choices: { up: 'up', down: 'down', left: 'left', right: 'right' }
        }
      }
    end
  end
end