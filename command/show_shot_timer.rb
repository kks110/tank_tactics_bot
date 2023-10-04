require_relative './base'

module Command
  class ShowShotTimer < Command::Base
    def name
      :show_shot_timer
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def description
      "Show shot cool down and energy cost"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data

      if player.shot.created_at + 1.day < Time.now
        player.shot.destroy
        Shot.create!(player_id: player.id)
        message = "Your next shot will cost #{game_data.shoot_base_cost}. You have no timer"
      else
        cost_to_shoot = game_data.shoot_base_cost + (game_data.shoot_increment_cost * (player.shot.count))
        seconds_until_reset = (player.shot.created_at + 1.day) - Time.now
        message = "Your next shot will cost #{cost_to_shoot}. It will reset in #{seconds_to_hms(seconds_until_reset)}"
      end

      event.respond(content: message, ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def seconds_to_hms(sec)
      "#{(sec / 3600).to_i} hours, #{(sec / 60 % 60).to_i} mins and #{(sec % 60).to_i} seconds"
    end
  end
end
