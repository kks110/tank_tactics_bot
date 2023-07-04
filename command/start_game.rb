require_relative './base'
require_relative './helpers/generate_grid_message'

module Command
  class StartGame < Command::Base
    def name
      :start_game
    end

    def description
      "Let the game begin!"
    end

    def execute(event:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      players = Player.all
      game = Game.create!(server_id: event.server_id, max_x: players.count + 2, max_y: players.count + 2)

      x_options = (0..game.max_x).to_a.shuffle!
      y_options = (0..game.max_y).to_a.shuffle!

      players.each do |player|
        player.update(x_position: x_options.pop, y_position: y_options.pop)
      end

      grid = Command::Helpers::GenerateGridMessage.new.standard_grid(server_id: event.server_id)
      BattleLog.logger.info("The game has begun!\n #{grid}")

      event.respond(content: "Generating the grid...", ephemeral: true)

      ImageGeneration::Grid.new.generate(
        grid_x: game.max_x,
        grid_y: game.max_y,
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
