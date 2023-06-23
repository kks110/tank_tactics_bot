
module Commands
  module Helpers
    class DrawGrid
      def self.send(event:)
        gb = GameBoard.first
        players = Player.all

        top_row = ""

        counter = 0
        gb.max_x.times do
          top_row << "   #{counter}   "
          counter += 1
        end
        top_row << "\n"

        top_border = ""
        counter = 0
        gb.max_x.times do
          if counter == 0
            top_border << "╭──────"
          elsif counter == gb.max_x - 1
            top_border << "┬──────╮\n"
          else
            top_border << "┬──────"
          end
          counter += 1
        end


        grid = Array.new(players.count + 2) { Array.new(players.count + 2) }
        players.each do |player|
          grid[player.x_position][player.y_position] = player
        end

        row = ""
        x_counter = 0
        y_counter = 0
        row_counter = 1
        counter = 0
        gb.max_y.times do
          gb.max_x.times do
            if row_counter == 1
              row << "│"
              if grid[x_counter-1][y_counter-1]
                row << "#{grid[x_counter-1][y_counter-1].hp} HP"
              else
                row << "      "
              end
            elsif row_counter == 2
              row << "│"
              if grid[x_counter-1][y_counter-1]
                row << "#{grid[x_counter-1][y_counter-1].range} RNG"
              else
                row << "      "
              end
            elsif row_counter == 3
              row << "│"
              if grid[x_counter-1][y_counter-1]
                row << "#{grid[x_counter-1][y_counter-1].username}"
              else
                row << "      "
              end
            end
            if x_counter == gb.max_x
              row_counter += 1
              row << "│\n"
            end
            x_counter += 1
          end


          if y_counter == gb.max_y
            if counter == 1
              top_border << "   ╰──────"
            elsif counter == gb.max_x
              top_border << "┴─────╯\n"
            else
              top_border << "┴──────"
            end
            counter += 1
          else
            if counter == 1
              top_border << "   ├──────"
            elsif counter == gb.max_x
              top_border << "┼──────┤\n"
            else
              top_border << "┼──────"
            end
            counter += 1
          end

          y_counter += 1
          x_counter = 1
          row_counter = 1
        end

        board = "```#{top_row}#{top_border}#{row}```"

        event.respond(content: board)
      end
    end
  end
end