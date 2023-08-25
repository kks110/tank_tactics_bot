require_relative './base'
require_relative '../image_generation/grid'

module Command
  class ShowSpectatorBoard < Command::Base
    def name
      :show_spectator_board
    end

    def requires_game?
      true
    end

    def description
      "Show the game board for spectators"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      if player
        event.respond(content: "You cant 'spectate' if you are playing!")
        return
      end

      player = OpenStruct.new(username: event.user.username)

      players = Player.all

      image_location = ImageGeneration::Grid.new.generate_game_board(
        grid_x: game.max_x,
        grid_y: game.max_y,
        player: player,
        players: players,
        game_data: game_data
      )

      event.respond(content: "Sending you a dm", ephemeral: true)
      event.user.send_file File.new(image_location)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
