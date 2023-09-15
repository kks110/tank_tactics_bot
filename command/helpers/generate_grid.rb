require_relative './determine_range'

module Command
  module Helpers
    class GenerateGrid
      def run(server_id:)
        players = Player.all
        game = Game.find_by(server_id: server_id)

        board_max_x = game.max_x + 1
        board_max_y = game.max_y + 1

        grid = Array.new(board_max_x) { Array.new(board_max_y) }
        players.each do |player|
          grid[player.y_position][player.x_position] = player
        end

        heart = Heart.find_by(collected: false)
        grid[heart.y_position][heart.x_position] = heart if heart

        energy_cell = EnergyCell.find_by(collected: false)
        grid[energy_cell.y_position][energy_cell.x_position] = energy_cell if energy_cell

        City.all.each do |city|
          grid[city.y_position][city.x_position] = city
        end

        grid
      end

      def available_spawn_location(server_id:)
        players = Player.all
        game = Game.find_by(server_id: server_id)

        list = []
        (0..game.max_x).to_a.each do |i|
          (0..game.max_y).to_a.each do |j|
            list << { x: i, y: j }
          end
        end

        players.each do |player|
          next if player.x_position.nil?

          x = player.x_position
          y = player.y_position

          range_list = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: x,
            y_position: y,
            range: 1,
            max_x: game.max_x,
            max_y: game.max_y
          )
          modify_list(list, range_list)
        end

        heart = Heart.order('created_at' => :desc).first
        if heart
          range_list = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: heart.x_position,
            y_position: heart.y_position,
            range: 2,
            max_x: game.max_x,
            max_y: game.max_y
          )
          modify_list(list, range_list)
        end

        energy_cell = EnergyCell.order('created_at' => :desc).first
        if energy_cell
          range_list = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: energy_cell.x_position,
            y_position: energy_cell.y_position,
            range: 2,
            max_x: game.max_x,
            max_y: game.max_y
          )
          modify_list(list, range_list)
        end

        City.all.each do |city|
          range_list = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: city.x_position,
            y_position: city.y_position,
            range: 1,
            max_x: game.max_x,
            max_y: game.max_y
          )
          modify_list(list, range_list)
        end

        list.shuffle!
      end

      def modify_list(list, range_list)
        range_list.each do |item|
          list.delete({ x: item[1], y: item[0] })
        end
      end
    end
  end
end
