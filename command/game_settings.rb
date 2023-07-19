require_relative './base'
require_relative './list'

module Command
  class GameSettings < Command::Base
    def name
      :game_settings
    end

    def description
      "Show the current games settings"
    end

    def execute(event:, game_data:)
      response = "Game Settings:\n"

      game = Game.find_by(server_id: event.server_id)

      game.cities ? response << "- Cities: Enabled\n" : response << "- Cities: Disabled\n"
      game.fog_of_war ? response << "- Fog of War: Enabled\n" : response << "- Fog of War: Disabled\n"
      response << "- Daily Energy: #{game_data.daily_energy_amount}e\n"
      response << "\n"
      response << "Costs:\n"
      response << "- Increase HP: #{game_data.increase_hp_cost} energy\n"
      response << "- Increase Range: #{game_data.increase_range_cost} energy\n"
      response << "- Shoot: #{game_data.shoot_cost} energy\n"
      response << "- Move: #{game_data.move_cost} energy\n"
      response << "- Capture City: #{game_data.capture_city_cost} energy\n" if game.cities
      response << "\n"
      response << "Rewards:\n"
      response << "- Heart Pickup: #{game_data.heart_reward}HP\n"
      response << "- Energy Pickup: #{game_data.energy_cell_reward} energy\n"
      response << "- Captured City: #{game_data.captured_city_reward} energy per city per day\n"  if game.cities

      event.respond(content: response, ephemeral: true)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
