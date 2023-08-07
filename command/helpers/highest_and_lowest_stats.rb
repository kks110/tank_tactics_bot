
module Command
  module Helpers
    class HighestAndLowestStats
      def self.generate
        highest_and_lowest = {}

        Stats.column_names.each do |column|
          min = Stats.minimum(column.to_sym)
          max = Stats.maximum(column.to_sym)

          highest_and_lowest[column][:low] = min
          highest_and_lowest[column][:high] = max
        end

        highest_and_lowest
      end
    end
  end
end
