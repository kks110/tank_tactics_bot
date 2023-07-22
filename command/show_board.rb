require_relative './base'
require_relative '../image_generation/grid'

module Command
  class ShowBoard < Command::Base
    def name
      :show_board
    end

    def description
      "Show the game board"
    end

    def execute(context:)
      game = context.game
      event = context.event
      game_data = context.game_data

      players = Player.all
      show_everyone = event.options['show_everyone'].nil? ? false : event.options['show_everyone']

      show_everyone = false if game.fog_of_war

      if game.fog_of_war
        user = event.user
        player = Player.find_by(discord_id: user.id)

        ImageGeneration::Grid.new.generate_fog_of_war_board(
          grid_x: game.max_x,
          grid_y: game.max_y,
          player: player,
          server_id: event.server_id
        )
      else
        ImageGeneration::Grid.new.generate_game_board(
          grid_x: game.max_x,
          grid_y: game.max_y,
          players: players
        )
      end

      image_location = game_data.image_location

      if show_everyone
        event.respond(content: "Generating the grid...", ephemeral: true)
        event.channel.send_file File.new(image_location + '/grid.png')
        event.delete_response
      else
        event.respond(content: "Sending you a dm", ephemeral: true)
        event.user.send_file File.new(image_location + '/grid.png')
      end

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'boolean',
          name: 'show_everyone',
          description: 'This will show the map to everyone'
        )
      ]
    end
  end
end
