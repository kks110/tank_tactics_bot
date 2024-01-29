require_relative './base'
require_relative './helpers/list'

module Command
  class Help < Command::Base
    def name
      :help
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
      "Show a list of commands"
    end

    def execute(context:)
      event = context.event

      response = "Here is a list of commands:\n"

      Command::Helpers::LIST.each do |command|
        response << "- `/#{command.name}`: #{command.description}\n"
      end

      event.respond(content: response, ephemeral: true)

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
