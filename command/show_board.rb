require_relative './base'
require_relative './helpers/generate_grid_message'
require_relative '../image_generation/grid'

module Command
  class ShowBoard < Command::Base
    def name
      :show_board
    end

    def description
      "Show the game board"
    end

    def execute(event:)
      players = Player.all
      game = Game.find_by(server_id: event.server_id)

      event.respond(content: "Generating the grid...", ephemeral: true)

      heart_cords = game.heart_x ? { x: game.heart_x, y: game.heart_y } : nil

      ImageGeneration::Grid.new.generate(
        grid_x: game.max_x,
        grid_y: game.max_y,
        players: players,
        heart_cords: heart_cords
      )

      image_location = ENV.fetch('TT_IMAGE_LOCATION', '.')
      event.channel.send_file File.new(image_location + '/grid.png')
      event.delete_response

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
