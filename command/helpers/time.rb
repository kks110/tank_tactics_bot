module Command
  module Helpers
    class Time
      def self.seconds_to_hms(sec)
        "#{(sec / 3600).to_i} hours, #{(sec / 60 % 60).to_i} mins and #{(sec % 60).to_i} seconds"
      end
    end
  end
end
