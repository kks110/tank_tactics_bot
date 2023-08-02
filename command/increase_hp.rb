require_relative './base'

module Command
  class IncreaseHp < Command::Base
    def name
      :increase_hp
    end

    def requires_game?
      true
    end

    def description
      'Increase HP by 1 for 30 energy'
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data

      unless player.energy >= game_data.increase_hp_cost
        event.respond(content: 'Not enough energy!', ephemeral: true)
        return
      end

      player.update(energy: player.energy - game_data.increase_hp_cost, hp: player.hp + 1)

      if player.hp > player.stats.highest_hp
        player.stats.update(highest_hp: player.hp)
      end

      BattleLog.logger.info("#{player.username} Increased their HP to #{player.hp}")

      if game.fog_of_war
        event.channel.send_message 'Someone increased their HP!'
        event.respond(content: "Health increased, you now have #{player.hp}HP", ephemeral: true)
      else
        event.respond(content: "Health increased, you now have #{player.hp}HP")
      end

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end