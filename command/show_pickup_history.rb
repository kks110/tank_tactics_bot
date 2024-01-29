require_relative './base'

module Command
  class ShowPickupHistory < Command::Base
    def name
      :show_pickup_history
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
      "Show where Energy cells have spawned"
    end

    def execute(context:)
      game = context.game
      event = context.event
      game_data = context.game_data

      image_location = ImageGeneration::Grid.new.generate_pickup_board(game_data: game_data, server_id: game.server_id)

      event.respond(content: "Generating the grid...")
      event.channel.send_file File.new(image_location)

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
