require_relative './base'

module Command
  class IncreaseHp < Command::Base
    def name
      :increase_hp
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      false
    end

    def requires_player_not_disabled?
      true
    end

    def description
      'Increase HP by 1 for 20 energy'
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

      was_dead = !player.alive?

      player.update(energy: player.energy - game_data.increase_hp_cost, hp: player.hp + 1)
      player.stats.update(energy_spent: player.stats.energy_spent + game_data.increase_hp_cost)

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
      player_global_stats.update(energy_spent: player_global_stats.energy_spent + game_data.increase_hp_cost)

      if player.hp > player.stats.highest_hp
        player.stats.update(highest_hp: player.hp)
      end

      if player.hp > player_global_stats.highest_hp
        player_global_stats.update(highest_hp: player.hp)
      end

      Logging::BattleLog.logger.info("#{player.username} Increased their HP to #{player.hp}")

      event.channel.send_message "#{was_dead ? 'Someone has revived themselves!' : 'Someone increased their HP!'}"
      event.respond(content: "Health increased, you now have #{player.hp}HP", ephemeral: true)

      Logging::BattleReport.logger.info(
        Logging::BattleReportBuilder.build(
          command_name: name,
          player_name: player.username
        )
      )
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
