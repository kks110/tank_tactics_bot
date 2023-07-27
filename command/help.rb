require_relative './base'
require_relative './helpers/list'

module Command
  class Help < Command::Base
    def name
      :help
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
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
