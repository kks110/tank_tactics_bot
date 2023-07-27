require_relative './base'
require_relative './helpers/clean_up'

module Command
  class ResetGame < Command::Base
    def name
      :reset_game
    end

    def description
      "Resets the game"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game = context.game
      game_data = context.game_data

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      unless game
        event.respond(content: "There is no game running!")
        return
      end

      Command::Helpers::CleanUp.run(event: event, game_data: game_data)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
