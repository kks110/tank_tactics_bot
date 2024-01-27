require_relative './base'

module Command
  class StartGame < Command::Base
    def name
      :start_game
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Let the game begin!"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data
      game = context.game

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!", ephemeral: true)
        return
      end

      players = Player.all

      unless players.count > 5
        event.respond(content: "You need at least 6 players to start the game!", ephemeral: true)
        return
      end

      world_max = players.count + game_data.world_size_max

      city_count = players.count / 2

      game.update!(
        max_x: world_max,
        max_y: world_max,
        started: true
      )

      city_count.times do
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id, spawning_cities: true)
        spawn_location = available_spawn_point.sample
        City.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])
      end

      mentions = ''
      players.each do |player|
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample
        player.update(x_position: spawn_location[:x], y_position: spawn_location[:y])
        mentions << "<@#{player.discord_id}> "
      end

      event.respond(content: "The game has begun, what lurks beyond the clouds... #{mentions}")

      ImageGeneration::Grid.new.generate_game_start_board(grid_x: game.max_x, grid_y: game.max_y, game_data: game_data, server_id: game.server_id)
      Logging::BattleLog.reset_log
      Logging::BattleLog.logger.info("The game has begun!")
      players = Player.all
      cities = City.all

      players.each do |player|
        Logging::BattleLog.logger.info("#{player.username} X: #{player.x_position} Y: #{player.y_position}")
      end

      cities.each do |city|
        Logging::BattleLog.logger.info("City X: #{city.x_position} Y: #{city.y_position}")
      end

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
