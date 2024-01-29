require_relative './base'

module Command
  class Register < Command::Base
    def name
      :register
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
      "Register to play!"
    end

    def execute(context:)
      event = context.event
      game_data = context.game_data

      if context.game.nil?
        event.respond(content: "You can't register when there is no game!", ephemeral: true)
        return
      end

      if context.game.started
        event.respond(content: "You can't register when a game is running!", ephemeral: true)
        return
      end

      user = event.user
      player = Player.create!(
        discord_id: user.id,
        username: user.username,
        hp: game_data.starting_hp,
        range: game_data.starting_range,
        energy: game_data.starting_energy
      )

      Stats.create!(player_id: player.id, highest_hp: player.hp, highest_range: player.range)

      Shot.create!(player_id: player.id)

      if GlobalStats.find_by(player_discord_id: user.id).nil?
        GlobalStats.create!(player_discord_id: user.id, username: user.username, highest_hp: player.hp, highest_range: player.range)
      end

      event.respond(content: "You registered successfully! Welcome to the game! You can use `/help` for a list of commands, or `/instructions` for some more info about the game.", ephemeral: true)
      event.channel.send_message "#{user.username} has registered!"
      
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
