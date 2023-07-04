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
        if player.y_position == 0
          event.respond(content: "You can't move up, you are on the edge of the board!")
          return
        end

        unless grid[player.y_position - 1][player.x_position].nil?
          event.respond(content: "You can't move up, there is a player in the way!")
          return
        end

        player.update(y_position: player.y_position - 1, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: player.x_position,
          old_y: player.y_position + 1,
          new_x: player.x_position,
          new_y: player.y_position,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")

      when 'down'
        if player.y_position == game.max_y
          event.respond(content: "You can't move down, you are on the edge of the board!")
          return
        end

        unless grid[player.y_position + 1][player.x_position].nil?
          event.respond(content: "You can't move down, there is a player in the way!")
          return
        end

        player.update(y_position: player.y_position + 1, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: player.x_position,
          old_y: player.y_position - 1,
          new_x: player.x_position,
          new_y: player.y_position,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")
      when 'left'
        if player.x_position == 0
          event.respond(content: "You can't move left, you are on the edge of the board!")
          return
        end

        unless grid[player.y_position][player.x_position - 1].nil?
          event.respond(content: "You can't move left, there is a player in the way!")
          return
        end

        player.update(x_position: player.x_position - 1, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: player.x_position + 1,
          old_y: player.y_position,
          new_x: player.x_position,
          new_y: player.y_position,
          server_id: event.server_id
        )
        event.respond(content: "Moved!")
      when 'right'
        if player.x_position == game.max_x
          event.respond(content: "You can't move right, you are on the edge of the board!")
          return
        end

        unless grid[player.y_position][player.x_position + 1].nil?
          event.respond(content: "You can't move right, there is a player in the way!")
          return
        end

        player.update(x_position: player.x_position + 1, energy: player.energy - 1)
        log(
          username: player.username,
          old_x: player.x_position - 1,
          old_y: player.y_position,
          new_x: player.x_position,
          new_y: player.y_position,
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