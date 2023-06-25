require_relative './base'
require_relative './helpers/generate_grid'

module Commands
  class ShowBoard < Commands::Base
    def name
      :show_board
    end

    def description
      "Show the game board"
    end

    def execute(event:)
      grid = Commands::Helpers::GenerateGrid.new.send(event: event)
      event.respond(content: grid)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end