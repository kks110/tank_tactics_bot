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

    def requires_player_not_disabled?
      false
    end

    def description
      "Show shot cool down and energy cost"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data

      if player.shot.nil?
        message = "Your next shot will cost #{game_data.shoot_base_cost}. You have no timer"
      elsif player.shot.created_at + 1.day < Time.now
        player.shot.destroy
        message = "Your next shot will cost #{game_data.shoot_base_cost}. You have no timer"
      else
        cost_to_shoot = game_data.shoot_base_cost + (game_data.shoot_increment_cost * (player.shot.count))
        seconds_until_reset = (player.shot.created_at + 1.day) - Time.now
        message = "Your next shot will cost #{cost_to_shoot}. It will reset in #{Command::Helpers::Time.seconds_to_hms(seconds_until_reset)}"
      end

      event.respond(content: message, ephemeral: true)

    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
