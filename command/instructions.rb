require_relative './base'

module Command
  class Instructions < Command::Base
    def name
      :instructions
    end

    def requires_game?
      false
    end

    def description
      "Instruction overview"
    end

    def execute(context:)
      event = context.event
      game_data = context.game_data

      instructions = "You are a tank and you have 3 HP, 2 range and 0 energy to start.\n" +
        "Everyone gets randomly placed on a grid. #{game_data.daily_energy_amount} energy a day gets distributed to everyone.\n" +
        "When energy is distributed, a heart will spawn on the grid that can be picked up to increase your HP\n" +
        "You can use that energy to:\n" +
        "- shoot (#{game_data.shoot_cost} energy)\n" +
        "- move in any direction (#{game_data.move_cost} energy) The world is 'round' so going off the edge will put you the other side\n" +
        "- upgrade your range (#{game_data.increase_range_base_cost} energy + #{game_data.increase_range_per_level_cost})\n" +
        "- gain a HP (#{game_data.increase_hp_cost} energy)\n\n" +
        "You can also give energy and HP to other players within your range.\n" +
        "Just because you are dead, does not mean you are out. Someone can give you HP to revive you. You will return with however much HP was given to you\n" +
        "And the energy you died with.\n" +
        "When energy is distributed daily, if none exist, a heart and an energy call will spawn.\n" +
        "The heart will give #{game_data.heart_reward}HP on pick up and the energy cell gives #{game_data.energy_cell_reward} energy.\n" +
        "If cities are enables, you can capture them. You need to be in 1 range and it costs #{game_data.capture_city_cost}.\n" +
        "Capturing a city will give you #{game_data.captured_city_reward} energy per day per city that you own.\n"

      event.respond(content: instructions, ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
