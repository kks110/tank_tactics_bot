
module Command
  module Helpers
    class HighestAndLowestStats
      def self.generate_for_game_stats
        highest_and_lowest = {}

        Stats.column_names.each do |column|
          min = Stats.minimum(column.to_sym)
          max = Stats.maximum(column.to_sym)

          highest_and_lowest[column] = {}
          highest_and_lowest[column][:low] = min
          highest_and_lowest[column][:high] = max
        end

        highest_and_lowest
      end

      def self.generate_for_global_stats
        highest_and_lowest = {}

        GlobalStats.column_names.each do |column|
          min = GlobalStats.minimum(column.to_sym)
          max = GlobalStats.maximum(column.to_sym)

          highest_and_lowest[column] = {}
          highest_and_lowest[column][:low] = min
          highest_and_lowest[column][:high] = max
        end

        key_to_move = "games_won"
        value_to_move = highest_and_lowest.delete(key_to_move)
        highest_and_lowest = { key_to_move => value_to_move }.merge(highest_and_lowest)

        highest_and_lowest
      end
    end
  end
end
