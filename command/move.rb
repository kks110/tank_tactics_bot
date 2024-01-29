require_relative './base'
require_relative './helpers/generate_grid'
require_relative './models/options'

module Command
  class Move < Command::Base
    def name
      :move
    end

    def requires_game?
      true
    end

    def description
      "Move your tank"
    end

    def requires_player_alive?
      true
    end

    def requires_player_not_disabled?
      true
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      direction = event.options['direction']

      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      unless player.energy >= game_data.move_cost
        event.respond(content: "Not enough energy!", ephemeral: true)
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

        if !grid[new_y][x].nil? && grid[new_y][x].class != EnergyCell || grid[new_y][x].class == City
          event.respond(content: "You can't move up, there is something in the way!", ephemeral: true)
          return
        end


        player.update(y_position: new_y, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y
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

        if !grid[new_y][new_x].nil? && grid[new_y][new_x].class != EnergyCell || grid[new_y][new_x].class == City
          event.respond(content: "You can't move up to the left, there is something in the way!", ephemeral: true)
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y
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

        if !grid[new_y][new_x].nil? && grid[new_y][new_x].class != EnergyCell || grid[new_y][new_x].class == City
          event.respond(content: "You can't move up and to the right, there is something in the way!", ephemeral: true)
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y
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

        if !grid[new_y][new_x].nil? && grid[new_y][new_x].class != EnergyCell || grid[new_y][new_x].class == City
          event.respond(content: "You can't move down and to the right, there is something in the way!", ephemeral: true)
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y
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

        if !grid[new_y][new_x].nil? && grid[new_y][new_x].class != EnergyCell || grid[new_y][new_x].class == City
          event.respond(content: "You can't move down and to the left, there is something in the way!", ephemeral: true)
          return
        end

        player.update(y_position: new_y, x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: old_y,
          new_x: new_x,
          new_y: new_y
        )
      when 'down'
        old_y = player.y_position
        new_y = player.y_position + 1
        x = player.x_position

        if player.y_position == game.max_y
          new_y = 0
        end

        if !grid[new_y][x].nil? && grid[new_y][x].class != EnergyCell || grid[new_y][x].class == City
          event.respond(content: "You can't move down, there is something in the way!", ephemeral: true)
          return
        end

        player.update(y_position: new_y, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: x,
          old_y: old_y,
          new_x: x,
          new_y: new_y
        )

      when 'left'
        old_x = player.x_position
        new_x = player.x_position - 1
        y = player.y_position

        if player.x_position == 0
          new_x = game.max_x
        end

        if !grid[y][new_x].nil? && grid[y][new_x].class != EnergyCell || grid[y][new_x].class == City
          event.respond(content: "You can't move left, there is something in the way!", ephemeral: true)
          return
        end

        player.update(x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y
        )

      when 'right'
        old_x = player.x_position
        new_x = player.x_position + 1
        y = player.y_position

        if player.x_position == game.max_x
          new_x = 0
        end

        if !grid[y][new_x].nil? && grid[y][new_x].class != EnergyCell || grid[y][new_x].class == City
          event.respond(content: "You can't move right, there is something in the way!", ephemeral: true)
          return
        end

        player.update(x_position: new_x, energy: player.energy - game_data.move_cost)
        log(
          username: player.username,
          old_x: old_x,
          old_y: y,
          new_x: new_x,
          new_y: y
        )
      end

      global_player_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

      player.stats.update(energy_spent: player.stats.energy_spent + game_data.move_cost)
      global_player_stats.update(energy_spent: global_player_stats.energy_spent + game_data.move_cost)
      response = "Moved! Sending you an updated map."

      energy_cell = EnergyCell.find_by(collected: false)
      if energy_cell
        if player.x_position == energy_cell.x_position && player.y_position == energy_cell.y_position
          player.update(energy: player.energy + game_data.energy_cell_reward)
          player.stats.update(energy_cells_collected: player.stats.energy_cells_collected + 1)
          global_player_stats.update(energy_cells_collected: global_player_stats.energy_cells_collected + 1)

          if player.energy > player.stats.highest_energy
            player.stats.update(highest_energy: player.energy)
          end

          if player.energy > global_player_stats.highest_energy
            global_player_stats.update(highest_energy: player.energy)
          end
          
          energy_cell.update(collected: true)
          response << " You picked up the energy cell!"

          event.channel.send_message 'Someone picked up the energy cell!'

          Logging::BattleLog.logger.info("The energy cell was collected: #{player.username}: #{player.energy} energy")
        end
      end

      player.stats.update(times_moved: player.stats.times_moved + 1)
      global_player_stats.update(times_moved: global_player_stats.times_moved + 1)
      event.respond(content: response, ephemeral: true)

      players = Player.all

      image_location = ImageGeneration::Grid.new.generate_player_board(
        player: player,
        players: players,
        game: game,
        server_id: event.server_id,
        game_data: game_data
      )

      event.user.send_file File.new(image_location)

      Logging::BattleReport.logger.info(Logging::BattleReportBuilder.build(command_name: name, player_name: player.username))
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def log(username:, old_x:, old_y:, new_x:, new_y:)
      Logging::BattleLog.logger.info("#{username} moved. X:#{old_x} Y:#{old_y} -> X:#{new_x} Y:#{new_y}")
    end

    def options
      [
        Command::Models::Options.new(
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
