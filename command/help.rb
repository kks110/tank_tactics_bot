require_relative './base'
require_relative './list'

module Command
  class Help < Command::Base
    def name
      :help
    end

    def description
      "Show a list of commands"
    end

    def execute(event:)
      response = "Here is a list of commands:\n"

      Command::LIST.each do |command|
        response << "- `/#{command.name}`: #{command.description}\n"
      end

      event.respond(content: response, ephemeral: true)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
