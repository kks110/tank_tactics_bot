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

      players = Player.all

      event.respond(content: "Sending you a dm", ephemeral: true)

      image = BoardImage.find_by(discord_id: player.discord_id)

      if image.nil?
        image_location = ImageGeneration::Grid.new.generate_player_board(
          player: player,
          players: players,
          game: game,
          server_id: event.server_id,
          game_data: game_data
        )

        image = BoardImage.create!(discord_id: player.discord_id, image_file_path: image_location)
      elsif image.created_at < game.last_change
        image_location = ImageGeneration::Grid.new.generate_player_board(
          player: player,
          players: players,
          game: game,
          server_id: event.server_id,
          game_data: game_data
        )

        image.update!(image_file_path: image_location, created_at: Time.now)
      end

      event.user.send_file File.new(image.image_file_path)

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
