require_relative './base'
require_relative './helpers/draw_grid'

module Commands
  class StartGame < Commands::Base
    def name
      :start_game
    end

    def description
      "Last the game begin!"
    end

    def execute(event:)
      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      players = Player.all
      x_options = (0..players.count+1).to_a.shuffle!
      y_options = (0..players.count+1).to_a.shuffle!

      players.each do |player|
        player.update(x_position: x_options.pop, y_position: y_options.pop)
      end

      GameBoard.create!(max_x: players.count+1, max_y: players.count+1)

      Commands::Helpers::DrawGrid.send(event: event)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end