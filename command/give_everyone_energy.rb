require_relative './base'

module Command
  class GiveEveryoneEnergy < Command::Base
    def name
      :give_everyone_energy
    end

    def description
      "Distribute daily energy"
    end

    def execute(event:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      unless player.admin
        event.respond(content: "Sorry! Only admins can do this!")
        return
      end

      game = Game.find_by(server_id: event.server_id)

      mentions = ""
      players = Player.all
      players.each do |player|
        player.update(energy: player.energy + 10) if player.alive
        mentions << "<@#{player.discord_id}> "
      end


      if game.heart_x.nil?
        available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: event.server_id)
        spawn_location = available_spawn_point.sample
        game.update(heart_x: spawn_location[:x], heart_y: spawn_location[:y])
        BattleLog.logger.info("Everyone got their daily energy. A heart spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}")
        event.respond(content: "Energy successfully distributed! #{mentions} A heart spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}")
      else
        BattleLog.logger.info("Everyone got their daily energy")
        event.respond(content: "Energy successfully distributed! #{mentions}")
      end

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end