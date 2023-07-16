require_relative './base'
require_relative './helpers/generate_grid_message'
require_relative './helpers/clean_up'

module Command
  class ResetGame < Command::Base
    def name
      :reset_game
    end

    def description
      "Resets the game"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      unless Game.first
        event.respond(content: "There is no game running!")
        return
      end

      Command::Helpers::CleanUp.run(event: event)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
