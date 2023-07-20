require_relative './base'

module Command
  class Register < Command::Base
    def name
      :register
    end

    def description
      "Register to play!"
    end

    def execute(event:, game_data:, bot:)
      user = event.user
      Player.create!(discord_id: user.id, username: user.username)
      event.respond(content: "#{user.username} registered successfully!")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end