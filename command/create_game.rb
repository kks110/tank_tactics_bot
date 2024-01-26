require_relative './base'

module Command
  class CreateGame < Command::Base
    def name
      :create_game
    end

    def requires_game?
      false
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Create a game!"
    end

    def execute(context:)
      event = context.event
      game_data = context.game_data

      if context.game
        event.respond(content: "A game is already created for this server!", ephemeral: true)
        return
      end

      user = event.user
      player = Player.create!(
        discord_id: user.id,
        username: user.username,
        hp: game_data.starting_hp,
        range: game_data.starting_range,
        energy: game_data.starting_energy,
        admin: true
      )

      Stats.create!(player_id: player.id, highest_hp: player.hp, highest_range: player.range)

      if GlobalStats.find_by(player_discord_id: user.id).nil?
        GlobalStats.create!(player_discord_id: user.id, username: user.username, highest_hp: player.hp, highest_range: player.range)
      end

      Game.create!(
        server_id: event.server_id,
        max_x: 0,
        max_y: 0
      )

      interested_players = InterestedPlayer.all

      response = "A game has been created and you have been registered. Everybody else, Register up! "

      interested_players.each do |interested_player|
        response << "<@#{interested_player.discord_id}> "
      end

      event.respond(content: response)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
