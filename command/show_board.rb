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
      player = context.player
      game_data = context.game_data

      players = Player.all
      show_everyone = event.options['show_everyone'].nil? ? false : event.options['show_everyone']

      show_everyone = false if game.fog_of_war

      if game.fog_of_war
        ImageGeneration::Grid.new.generate_fog_of_war_board(
          grid_x: game.max_x,
          grid_y: game.max_y,
          player: player,
          server_id: event.server_id,
          game_data: game_data
        )
      else
        ImageGeneration::Grid.new.generate_game_board(
          grid_x: game.max_x,
          grid_y: game.max_y,
          players: players,
          game_data: game_data
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
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
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
