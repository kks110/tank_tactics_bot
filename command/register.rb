require_relative './base'

module Command
  class Register < Command::Base
    def name
      :register
    end

    def requires_game?
      false
    end

    def description
      "Register to play!"
    end

    def execute(context:)
      event = context.event
      game_data = context.game_data

      if context.game
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
      event.respond(content: "#{user.username} registered successfully!")

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end