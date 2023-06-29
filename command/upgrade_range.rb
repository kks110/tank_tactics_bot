require_relative './base'

module Command
  class UpgradeRange < Command::Base
    def name
      :upgrade_range
    end

    def description
      "Increase range by 1 for 3 energy"
    end

    def execute(event:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.energy > 2
        event.respond(content: "Not enough energy!")
        return
      end

      player.update(energy: player.energy - 3, range: player.range + 1)

      BattleLog.logger.info("#{player.username} increased their range to #{player.range}")
      event.respond(content: "Range increased, you now have #{player.range} range")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end