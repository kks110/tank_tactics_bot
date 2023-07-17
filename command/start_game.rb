require_relative './base'

module Command
  class StartGame < Command::Base
    def name
      :start_game
    end

    def description
      "Let the game begin!"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      players = Player.all
      world_max = players.count + game_data.world_size_max
      cities = event.options['cities'] ? event.options['cities'] : false
      city_count = players.count / 2

      game = Game.create!(
        server_id: event.server_id,
        max_x: world_max,
        max_y: world_max,
        cities: cities
      )

      if cities
        city_count.times do
          available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
          spawn_location = available_spawn_point.sample
          City.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])
        end
      end


      players.each do |player|
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample
        player.update(x_position: spawn_location[:x], y_position: spawn_location[:y])
      end

      event.respond(content: "Generating the grid...", ephemeral: true)

      ImageGeneration::Grid.new.generate_game_board(
        grid_x: game.max_x,
        grid_y: game.max_y,
        players: players
      )

      image_location = ENV.fetch('TT_IMAGE_LOCATION', '.')
      event.channel.send_file File.new(image_location + '/grid.png')
      event.delete_response


    # rescue => e
    #   event.respond(content: "An error has occurred: #{e}")
    end

    def options
      [
        Command::Options.new(
          type: 'boolean',
          name: 'cities',
          description: 'Do you want to add cities? (default: false)'
        )
      ]
    end
  end
end
