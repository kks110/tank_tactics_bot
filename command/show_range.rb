require_relative './base'
require_relative './helpers/generate_grid_message'
require_relative '../image_generation/grid'

module Command
  class ShowRange < Command::Base
    def name
      :show_range
    end

    def description
      "Show your tanks range"
    end

    def execute(event:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      game = Game.find_by(server_id: event.server_id)

      event.respond(content: "Generating the grid...", ephemeral: true)

      ImageGeneration::Grid.new.generate_range(grid_x: game.max_x, grid_y: game.max_y, player: player, server_id: event.server_id)

      image_location = ENV.fetch('TT_IMAGE_LOCATION', '.')
      event.channel.send_file File.new(image_location + '/range_grid.png')
      event.delete_response

    # rescue => e
    #   event.respond(content: "An error has occurred: #{e}")
    end
  end
end
