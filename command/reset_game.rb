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

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      unless game
        event.respond(content: "There is no game running!")
        return
      end

      Command::Helpers::CleanUp.run(event: event)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
