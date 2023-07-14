
module Command
  module Helpers
    class DetermineRange
      def build_range_list(player_x:, player_y:, player_range:, max_x:, max_y:)
        list = []

        if (player_range + player_range + 1) >= max_x + 1
          (0..max_y).to_a.each do |y_option|
            (0..max_x).to_a.each do |x_option|
              list << [y_option, x_option]
            end
          end

          return list
        end

        range_right_x = (player_x + player_range) > max_x ? (player_x + player_range) - max_x - 1 : (player_x + player_range)
        range_left_x = (player_x - player_range) < 0 ? (player_x - player_range) + max_x + 1 : (player_x - player_range)

        range_down_y = (player_y + player_range) > max_y ? (player_y + player_range) - max_y - 1 : (player_y + player_range)
        range_up_y = (player_y - player_range) < 0 ? (player_y - player_range) + max_y + 1 : (player_y - player_range)

        x_options = []
        if range_right_x < range_left_x
          (range_left_x..max_x).to_a.each do |option|
            x_options << option
          end
          (0..range_right_x).to_a.each do |option|
            x_options << option
          end
        else
          (range_left_x..range_right_x).to_a.each do |option|
            x_options << option
          end
        end

        y_options = []
        if range_down_y < range_up_y
          (range_up_y..max_y).to_a.each do |option|
            y_options << option
          end
          (0..range_down_y).to_a.each do |option|
            y_options << option
          end
        else
          (range_up_y..range_down_y).to_a.each do |option|
            y_options << option
          end
        end

        y_options.each do |y_opt|
          x_options.each do |x_opt|
            list << [y_opt, x_opt]
          end
        end
        list.uniq
      end
    end
  end
end
