
module Command
  module Helpers
    class GenerateGrid
      def run
        players = Player.all

        board_max_x = players.count + 2
        board_max_y = players.count + 2

        grid = Array.new(board_max_x) { Array.new(board_max_y) }
        players.each do |player|
          grid[player.y_position][player.x_position] = player
        end

        grid
      end
    end
  end
end