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

    def description
      "Show where Hearts and Energy cells have spawned"
    end

    def execute(context:)
      game = context.game
      event = context.event
      game_data = context.game_data

      image_location = ImageGeneration::Grid.new.generate_pickup_board(grid_x: game.max_x, grid_y: game.max_y, game_data: game_data)

      event.respond(content: "Generating the grid...")
      event.channel.send_file File.new(image_location)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end