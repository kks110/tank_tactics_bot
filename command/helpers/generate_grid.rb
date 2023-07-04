
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

        grid
      end
    end
  end
end
