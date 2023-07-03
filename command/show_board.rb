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

      event.respond(content: "Generating the grid...", ephemeral: true)

      ImageGeneration::Grid.new.generate(
        grid_x: players.count + 2,
        grid_y: players.count + 2,
        players: players
      )

      image_location = ENV.fetch('TT_IMAGE_LOCATION', '.')
      event.channel.send_file File.new(image_location + '/grid.png')
      event.delete_response

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
