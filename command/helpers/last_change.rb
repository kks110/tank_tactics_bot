
module Command
  module Helpers
    class LastChange
      REQUIRES_CHANGE_UPDATE = [
        :capture_city,
        :give_heart,
        :increase_hp,
        :increase_range,
        :move,
        :ramming_speed,
        :shoot,
        :swap_hp_for_energy
      ]

      def self.update(game:, command_name:)
        if game && REQUIRES_CHANGE_UPDATE.include?(command_name)
          game.last_change = ::Time.now
          game.save
        end
      end
    end
  end
end
