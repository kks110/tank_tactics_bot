
module Commands
  module Helpers
    class DetermineRange
      def build_range_list(player_x:, player_y:, player_range:)
        list = []

        options = (0..player_range).to_a
        options.each do |i|
          options.each do |j|
            list << [player_y - i, player_x - j]
            list << [player_y - i, player_x + j]
            list << [player_y + i, player_x - j]
            list << [player_y + i, player_x + j]
          end
        end
        list.uniq
      end
    end
  end
end