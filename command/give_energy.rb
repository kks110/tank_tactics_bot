require_relative './base'
require_relative './helpers/determine_range'
require_relative './helpers/player_list'

module Command
  class GiveEnergy < Command::Base
    def name
      :give_energy
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      true
    end

    def requires_player_not_disabled?
      true
    end

    def description
      "Give energy to someone (default is 5)"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      bot = context.bot

      target_id = event.options['target'].to_i

      amount_to_give = event.options['amount']
      amount_to_give = 5 if amount_to_give.nil?

      target = Player.find_by(discord_id: target_id)

      unless target
        event.respond(content: "<@#{target_id}> isn't in this game. Valid players are:\n #{PlayerList.build}", allowed_mentions: { parse: [] }, ephemeral: true)
        return
      end

      if player.discord_id == target_id
        event.respond(content: "You can't give yourself energy!", ephemeral: true)
        return
      end

      y = target.y_position
      x = target.x_position

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      if player.energy < amount_to_give
        event.respond(content: "You can't give more than you have!", ephemeral: true)
        return
      end

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      unless target.alive?
        event.respond(content:"You can't give energy to a dead player!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - amount_to_give)
      player.stats.update(energy_given: player.stats.energy_given + amount_to_give)

      target.update(energy: target.energy + amount_to_give)
      target.stats.update(energy_received: target.stats.energy_received + amount_to_give)

      event.respond(content: "#{target.username} was given #{amount_to_give} energy by #{player.username}!", ephemeral: true)
      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were given #{amount_to_give} energy by #{player.username}")

      Logging::BattleLog.logger.info("#{player.username} gave #{amount_to_give} energy to #{target.username}")

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
      player_global_stats.update(energy_given: player_global_stats.energy_given + amount_to_give)

      target_global_stats = GlobalStats.find_by(player_discord_id: target.discord_id)
      target_global_stats.update(energy_given: target_global_stats.energy_given + amount_to_give)

      if target.energy > target.stats.highest_energy
        target.stats.update(highest_energy: target.energy)
      end

      if target.energy > target_global_stats.highest_energy
        target_global_stats.update(highest_energy: target.energy)
      end

      Logging::BattleReport.logger.info(Logging::BattleReportBuilder.build(command_name: name, player_name: player.username))
    rescue => e
      Logging::ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'user',
          name: 'target',
          description: 'The user you want to give a heart to',
          required: true
        ),
        Command::Models::Options.new(
          type: 'integer',
          name: 'amount',
          description: 'How much energy do you want to give (default is 5)',
        )
      ]
    end
  end
end
