require_relative './base'

module Command
  class RegisterInterest < Command::Base
    def name
      :register_interest
    end

    def requires_game?
      false
    end

    def description
      "Register interest in playing!"
    end

    def execute(context:)
      event = context.event
      user = event.user
      interested_player = InterestedPlayer.new(discord_id: user.id)

      if interested_player.validate
        interested_player.save
        event.respond(content: "#{user.username}, registered your interest!", ephemeral: true)
      else
        event.respond(content: "An error occurred, likely you are already registered", ephemeral: true)
      end

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
