require_relative './base'

module Command
  class DeregisterInterest < Command::Base
    def name
      :deregister_interest
    end

    def requires_game?
      false
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Deregister your interest in playing!"
    end

    def execute(context:)
      event = context.event
      user = event.user

      interested_player = InterestedPlayer.find_by(discord_id: user.id)
      interested_player.try(:destroy)

      event.respond(content: "You are no longer registered", ephemeral: true)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
