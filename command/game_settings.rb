require_relative './base'

module Command
  class GameSettings < Command::Base
    def name
      :game_settings
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Show the current games settings"
    end

    def execute(context:)
      game = context.game
      event = context.event
      game_data = context.game_data

      response = "Game Settings:\n"
      response << "- Daily Energy: #{game_data.daily_energy_amount} energy\n"
      response << "\n"
      response << "Costs:\n"
      response << "- Increase HP: #{game_data.increase_hp_cost} energy\n"
      response << "- Increase Range: #{game_data.increase_range_base_cost} energy + #{game_data.increase_range_per_level_cost} per level\n"
      response << "- Shoot: #{game_data.shoot_base_cost} energy + #{game_data.shoot_increment_cost} per shot per 24 hours\n"
      response << "- Move: #{game_data.move_cost} energy\n"
      response << "- Capture City: #{game_data.capture_city_cost} energy\n"
      response << "\n"
      response << "Rewards:\n"
      response << "- Energy Pickup: #{game_data.energy_cell_reward} energy\n"
      response << "- Captured City: #{game_data.captured_city_reward} energy per city per day\n"

      event.respond(content: response, ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
