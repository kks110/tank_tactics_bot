require_relative './base'
require_relative './helpers/generate_grid_message'

module Command
  class ResetGame < Command::Base
    def name
      :reset_game
    end

    def description
      "Resets the game"
    end

    def execute(event:, game_data:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      unless Game.first
        event.respond(content: "There is no game running!")
        return
      end

      most_kills = Player.order({'kills' => :desc}).first
      most_deaths = Player.order({'deaths' => :desc}).first

      event.respond(content: "The game has ended!\n Most Kills: #{most_kills.username}: #{most_kills.kills}\n Most Deaths: #{most_deaths.username}: #{most_deaths.deaths}")

      players = Player.all
      players.each do |player|
        if player.admin
          player.update(
            x_position: nil,
            y_position: nil,
            energy: 0,
            hp: 3,
            range: 2,
            kills: 0,
            deaths: 0,
          )
        else
          player.destroy
        end
      end

      Game.first.destroy

      Heart.first.destroy if Heart.first
      EnergyCell.first.destroy if EnergyCell.first

      BattleLog.logger.info("The game has ended!\n")
    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
