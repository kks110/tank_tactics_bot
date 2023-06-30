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
      show_everyone = event.options['show_everyone']
      show_everyone = false if show_everyone.nil?

      grid = Command::Helpers::GenerateGridMessage.new.standard_grid
      event.respond(content: grid, ephemeral: !show_everyone)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def options
      [
        Command::Options.new(
          type: 'boolean',
          name: 'show_everyone',
          description: 'Default will just show you, use this to show the board to everyone'
        )
      ]
    end
  end
end
