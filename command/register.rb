require_relative './base'

module Command
  class Register < Command::Base
    def name
      :register
    end

    def description
      "Register to play!"
    end

    def execute(context:)
      event = context.event

      user = event.user
      Player.create!(discord_id: user.id, username: user.username)
      event.respond(content: "#{user.username} registered successfully!")

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end