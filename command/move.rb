require_relative './base'
require_relative './helpers/generate_grid'
require_relative './options'

module Command
  class Move < Command::Base
    def name
      :move
    end

    def description
      "Move your tank"
    end

    def execute(event:)
      direction = event.options['direction']

      user = event.user
      player = Player.find_by(discord_id: user.id)
      game = Game.find_by(server_id: event.server_id)
      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      unless player.energy > 0
        event.respond(content: "Not enough energy!")
        return
      end

      case direction
      when 'up'
        old_y = player.y_position
        new_y = player.y_position - 1
        x = player.x_position

        if player.y_position == 0
          new_y = game.max_y
        end

        unless grid[new_y][x].nil?
          event.respond(content: "You can't move up, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")

      when 'down'
        old_y = player.y_position
        new_y = player.y_position + 1
        x = player.x_position

        if player.y_position == game.max_y
          new_y = 0
        end

        unless grid[new_y][x].nil?
          event.respond(content: "You can't move down, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")
      when 'left'
        old_x = player.x_position
        new_x = player.x_position - 1
        y = player.y_position

        if player.x_position == 0
          new_x = game.max_x
        end

        unless grid[y][new_x].nil?
          event.respond(content: "You can't move left, there is a player in the way!")
          return
        end

        player.update(x_position: new_x, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")
      when 'right'
        old_x = player.x_position
        new_x = player.x_position + 1
        y = player.y_position

        if player.x_position == game.max_x
          new_x = 0
        end

        unless grid[y][new_x].nil?
          event.respond(content: "You can't move right, there is a player in the way!")
          return
        end

        player.update(x_position: new_x, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")
      end

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def log(username:, old_x:, old_y:, new_x:, new_y:, server_id:)
      BattleLog.logger.info("#{username} moved. X:#{old_x} Y:#{old_y} -> X:#{new_x} Y:#{new_y}")
      grid = Command::Helpers::GenerateGridMessage.new.standard_grid(server_id: server_id)
      BattleLog.logger.info("\n#{grid}")
    end

    def options
      [
        Command::Options.new(
          type: 'string',
          name: 'direction',
          description: 'Pick your direction, Up, Down, Left or Right',
          required: true,
          choices: { up: 'up', down: 'down', left: 'left', right: 'right' }
        )
      ]
    end
  end
end