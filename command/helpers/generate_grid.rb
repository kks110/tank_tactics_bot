
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

        grid[Heart.first.y_position][Heart.first.x_position] = Heart.first if Heart.first

        grid[EnergyCell.first.y_position][EnergyCell.first.x_position] = EnergyCell.first if EnergyCell.first

        if game.cities
          City.all.each do |city|
            grid[city.y_position][city.x_position] = city
          end
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

          list = modify_list(x, y, list, game)
        end

        list = modify_list(Heart.first.x_position, Heart.first.y_position, list, game) if Heart.first

        list = modify_list(EnergyCell.first.x_position, EnergyCell.first.y_position, list, game) if EnergyCell.first

        City.all.each do |city|
          modify_list(city.x_position, city.y_position, list, game)
        end

        list
      end

      def modify_list(x, y, list, game)
        y_minus_1 = y == 0 ? game.max_y : y - 1
        y_plus_1 = y == game.max_y ? 0 : y + 1

        x_minus_1 = x == 0 ? game.max_x : x - 1
        x_plus_1 = x == game.max_x ? 0 : x + 1

        list.delete({ x: x, y: y })
        list.delete({ x: x_plus_1, y: y_minus_1 })
        list.delete({ x: x_plus_1, y: y })
        list.delete({ x: x_plus_1, y: y_plus_1 })
        list.delete({ x: x, y: y_minus_1 })
        list.delete({ x: x, y: y_plus_1 })
        list.delete({ x: x_minus_1, y: y_minus_1 })
        list.delete({ x: x_minus_1, y: y })
        list.delete({ x: x_minus_1, y: y_plus_1 })
        list
      end
    end
  end
end
