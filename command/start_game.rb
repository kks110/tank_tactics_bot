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
      x_options = (0..players.count+1).to_a.shuffle!
      y_options = (0..players.count+1).to_a.shuffle!

      players.each do |player|
        player.update(x_position: x_options.pop, y_position: y_options.pop)
      end

      grid = Command::Helpers::GenerateGridMessage.new.standard_grid
      BattleLog.logger.info("The game has begun!\n #{grid}")
      event.respond(content: grid)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
