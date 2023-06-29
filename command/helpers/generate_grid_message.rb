require_relative './generate_grid'

module Command
  module Helpers
    class GenerateGridMessage
      def standard_grid
        grid = GenerateGrid.new.run

        board_max_x = grid[0].length

        row = ""
        grid.each_with_index do |i, i_index|
          i.each_with_index do |j, j_index|
            if j_index == 0
              row << "   "
            end
            row << "|"
            if j
              j.alive ? row << "#{j.hp}   HP" : row << " DEAD "
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

        "```#{top_row(max_x: board_max_x)}#{row}```"
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

      # Only 2000 lines allowed so need to remove some

      # def top_border(max_x:)
      #   top_border = "   "
      #   counter = 0
      #   max_x.times do
      #     if counter == 0
      #       top_border << "╭──────"
      #     elsif counter == max_x - 1
      #       top_border << "┬──────╮\n"
      #     else
      #       top_border << "┬──────"
      #     end
      #     counter += 1
      #   end
      #   top_border
      # end

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

      # Only 2000 lines allowed so need to remove some
      # def bottom_border(max_x:)
      #   bottom_border = ""
      #   counter = 0
      #   max_x.times do
      #     if counter == 0
      #       bottom_border << "   ╰──────"
      #     elsif counter == max_x - 1
      #       bottom_border << "┴──────╯\n"
      #     else
      #       bottom_border << "┴──────"
      #     end
      #     counter += 1
      #   end
      #   bottom_border
      # end
    end
  end
end