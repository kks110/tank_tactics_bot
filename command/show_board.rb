require_relative './base'
require_relative '../image_generation/grid'

module Command
  class ShowBoard < Command::Base
    def name
      :show_board
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
      "Show the game board"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      image_location = ImageGeneration::Grid.new.generate_fog_of_war_board(
        grid_x: game.max_x,
        grid_y: game.max_y,
        player: player,
        server_id: event.server_id,
        game_data: game_data
      )

      event.respond(content: "Sending you a dm", ephemeral: true)
      event.user.send_file File.new(image_location)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
