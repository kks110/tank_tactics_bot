require_relative './base'

module Commands
  class Register < Commands::Base
    def name
      :register
    end

    def description
      "Register to play!"
    end

    def execute(event:)
      user = event.user
      Player.create!(discord_id: user.id, username: user.username)
      event.respond(content: "#{user.username} registered successfully!")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end