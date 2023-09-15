require_relative './base'

module Command
  class SendMessageToInterested < Command::Base
    def name
      :send_message_to_interested
    end

    def requires_game?
      false
    end

    def requires_player_alive?
      false
    end

    def description
      "Send a message to interested parties"
    end

    def execute(context:)
      event = context.event
      player = context.player

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      interested_players = InterestedPlayer.all

      response = ""

      interested_players.each do |interested_player|
        response << "<@#{interested_player.discord_id}> "
      end

      response << event.options['message']

      event.respond(content: response)
    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'string',
          name: 'message',
          description: 'The message you want to send',
          required: true,
        )
      ]
    end
  end
end