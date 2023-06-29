require_relative './base'
require_relative './helpers/generate_grid_message'

module Command
  class ShowBoard < Command::Base
    def name
      :show_board
    end

    def description
      "Show the game board"
    end

    def execute(event:)
      grid = Command::Helpers::GenerateGridMessage.new.send
      event.respond(content: grid)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end