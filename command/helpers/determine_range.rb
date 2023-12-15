module Command
  module Helpers
    class DetermineRange
      def build_range_list(x_position:, y_position:, range:, max_x:, max_y:)
        list = []

        if (range + range + 1) >= max_x + 1
          (0..max_y).to_a.each do |y_option|
            (0..max_x).to_a.each do |x_option|
              list << [y_option, x_option]
            end
          end

          return list
        end

        range_right_x = (x_position + range) > max_x ? (x_position + range) - max_x - 1 : (x_position + range)
        range_left_x = (x_position - range).negative? ? (x_position - range) + max_x + 1 : (x_position - range)

        range_down_y = (y_position + range) > max_y ? (y_position + range) - max_y - 1 : (y_position + range)
        range_up_y = (y_position - range).negative? ? (y_position - range) + max_y + 1 : (y_position - range)

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
