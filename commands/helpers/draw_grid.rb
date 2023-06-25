
module Commands
  module Helpers
    class DrawGrid
      def send(event:)
        players = Player.all

        board_max_x = players.count + 2
        board_max_y = players.count + 2

        grid = Array.new(board_max_x) { Array.new(board_max_y) }
        players.each do |player|
          grid[player.y_position][player.x_position] = player
        end

        row = ""
        grid.each_with_index do |i, i_index|
          i.each_with_index do |j, j_index|
            if j_index == 0
              row << "   "
            end
            row << "|"
            if j
              row << "#{j.hp}   HP"
            else
              row << "      "
            end
            if i.length - 1 == j_index
              row << "|\n"
            end
          end

          i.each_with_index do |j, j_index|
            if j_index == 0
              row << " #{i_index} "
            end
            row << "|"
            if j
              row << "#{j.range}  RNG"
            else
              row << "      "
            end
            if i.length - 1 == j_index
              row << "|\n"
            end
          end

          i.each_with_index do |j, j_index|
            if j_index == 0
              row << "   "
            end
            row << "|"
            if j
              display_name = ""
              if j.username.length < 6
                display_name << j.username
                (6 - j.username.length).times do
                  display_name << " "
                end
              else
                display_name = j.username[0...6]
              end
              row << display_name
            else
              row << "      "
            end
            if i.length - 1 == j_index
              row << "|\n"
            end
          end
          unless grid.length - 1 == i_index
            row << middle_line(max_x: board_max_x)
          end
        end

        board = "```#{top_row(max_x: board_max_x)}#{top_border(max_x: board_max_x)}#{row}#{bottom_border(max_x: board_max_x)}```"

        puts board

        event.respond(content: board)
      end

      def top_row(max_x:)
        top_row = "   "
        counter = 0
        max_x.times do
          top_row << "   #{counter}   "
          counter += 1
        end
        top_row << "\n"
        top_row
      end

      def top_border(max_x:)
        top_border = "   "
        counter = 0
        max_x.times do
          if counter == 0
            top_border << "╭──────"
          elsif counter == max_x - 1
            top_border << "┬──────╮\n"
          else
            top_border << "┬──────"
          end
          counter += 1
        end
        top_border
      end

      def middle_line(max_x:)
        mid_line = ""
        counter = 0
        max_x.times do
          if counter == 0
            mid_line << "   ├──────"
          elsif counter == max_x - 1
            mid_line << "┼──────┤\n"
          else
            mid_line << "┼──────"
          end
          counter += 1
        end
        mid_line
      end

      def bottom_border(max_x:)
        bottom_border = ""
        counter = 0
        max_x.times do
          if counter == 0
            bottom_border << "   ╰──────"
          elsif counter == max_x - 1
            bottom_border << "┴──────╯\n"
          else
            bottom_border << "┴──────"
          end
          counter += 1
        end
        bottom_border
      end
    end
  end
end