require_relative './base'
require_relative './helpers/draw_grid'

module Commands
  class ShowBoard < Commands::Base
    def name
      :show_board
    end

    def description
      "Show the game board"
    end

    def execute(event:)
      Commands::Helpers::DrawGrid.new.send(event: event)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end