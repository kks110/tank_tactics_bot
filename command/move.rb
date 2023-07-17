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

    def execute(event:, game_data:)
      direction = event.options['direction']

      user = event.user
      player = Player.find_by(discord_id: user.id)
      game = Game.find_by(server_id: event.server_id)
      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      unless player.energy >= game_data.move_cost
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

        if grid[new_y][x] != 'heart' && !grid[new_y][x].nil? && grid[new_y][x] != 'energy_cell'
          event.respond(content: "You can't move up, there is a player in the way!")
          return
        end


        player.update(y_position: new_y, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y,
          server_id: event.server_id
        )

      when 'up_left'
        old_y = player.y_position
        old_x = player.x_position
        new_y = player.y_position - 1
        new_x = player.x_position - 1

        if player.y_position == 0
          new_y = game.max_y
        end

        if player.x_position == 0
          new_x = game.max_x
        end

        if grid[new_y][new_x] != 'heart' && !grid[new_y][new_x].nil? && grid[new_y][new_x] != 'energy_cell'
          event.respond(content: "You can't move up to the left, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y,
          server_id: event.server_id
        )

      when 'up_right'
        old_y = player.y_position
        old_x = player.x_position
        new_y = player.y_position - 1
        new_x = player.x_position + 1

        if player.y_position == 0
          new_y = game.max_y
        end

        if player.x_position == game.max_x
          new_x = 0
        end

        if grid[new_y][new_x] != 'heart' && !grid[new_y][new_x].nil? && grid[new_y][new_x] != 'energy_cell'
          event.respond(content: "You can't move up and to the right, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y,
          server_id: event.server_id
        )

      when 'down_right'
        old_y = player.y_position
        old_x = player.x_position
        new_y = player.y_position + 1
        new_x = player.x_position + 1

        if player.y_position == game.max_y
          new_y = 0
        end

        if player.x_position == game.max_x
          new_x = 0
        end

        if grid[new_y][new_x] != 'heart' && !grid[new_y][new_x].nil? && grid[new_y][new_x] != 'energy_cell'
          event.respond(content: "You can't move down and to the right, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y,
          server_id: event.server_id
        )

      when 'down_left'
        old_y = player.y_position
        old_x = player.x_position
        new_y = player.y_position + 1
        new_x = player.x_position - 1

        if player.y_position == game.max_y
          new_y = 0
        end

        if player.x_position == 0
          new_x = game.max_x
        end

        if grid[new_y][new_x] != 'heart' && !grid[new_y][new_x].nil? && grid[new_y][new_x] != 'energy_cell'
          event.respond(content: "You can't move down and to the left, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y,
          server_id: event.server_id
        )
      when 'down'
        old_y = player.y_position
        new_y = player.y_position + 1
        x = player.x_position

        if player.y_position == game.max_y
          new_y = 0
        end

        if grid[new_y][x] != 'heart' && !grid[new_y][x].nil? && grid[new_y][x] != 'energy_cell'
          event.respond(content: "You can't move down, there is a player in the way!")
          return
        end

        player.update(y_position: new_y, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y,
          server_id: event.server_id
        )

      when 'left'
        old_x = player.x_position
        new_x = player.x_position - 1
        y = player.y_position

        if player.x_position == 0
          new_x = game.max_x
        end

        if grid[y][new_x] != 'heart' && !grid[y][new_x].nil? && grid[y][new_x] != 'energy_cell'
          event.respond(content: "You can't move left, there is a player in the way!")
          return
        end

        player.update(x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y,
          server_id: event.server_id
        )

      when 'right'
        old_x = player.x_position
        new_x = player.x_position + 1
        y = player.y_position

        if player.x_position == game.max_x
          new_x = 0
        end

        if grid[y][new_x] != 'heart' && !grid[y][new_x].nil? && grid[y][new_x] != 'energy_cell'
          event.respond(content: "You can't move right, there is a player in the way!")
          return
        end

        player.update(x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y,
          server_id: event.server_id
        )
      end

      response = "Moved!"

      if game.cities
        City.all.each do |city|
          if player.x_position == city.x_position && player.y_position == city.y_position
            city.update(player_id: player.id)
            response << " You have captured a city! You will gain an extra 5 energy each day"

            BattleLog.logger.info("City captured: #{player.username}: City X:#{city.x_position} Y:#{city.y_position}")
          end
        end
      end

      if Heart.first
        heart = Heart.first
        if player.x_position == heart.x_position && player.y_position == heart.y_position
          player.update(hp: player.hp + game_data.heart_reward)
          heart.destroy
          response << " You picked up the heart! You now have #{player.hp}HP"

          BattleLog.logger.info("The heart was collected: #{player.username}: HP#{player.hp}")
        end
      end

      if EnergyCell.first
        energy_call = EnergyCell.first
        if player.x_position == energy_call.x_position && player.y_position == energy_call.y_position
          player.update(energy: player.energy + game_data.energy_cell_reward)
          energy_call.destroy
          response << " You picked up the energy cell!"

          BattleLog.logger.info("The energy cell was collected: #{player.username}: #{player.energy} energy")
        end
      end

      event.respond(content: response)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def log(username:, old_x:, old_y:, new_x:, new_y:, server_id:)
      BattleLog.logger.info("#{username} moved. X:#{old_x} Y:#{old_y} -> X:#{new_x} Y:#{new_y}")
    end

    def options
      [
        Command::Options.new(
          type: 'string',
          name: 'direction',
          description: 'Pick your direction, Up, Down, Left or Right',
          required: true,
          choices: {
            up_left: 'up_left',
            up: 'up',
            up_right: 'up_right',
            left: 'left',
            right: 'right',
            down_left: 'down_left',
            down: 'down',
            down_right: 'down_right'
          }
        )
      ]
    end
  end
end
