require_relative './base'
require_relative './helpers/determine_range'
require_relative './helpers/player_list'

module Command
  class GiveHeart < Command::Base
    def name
      :give_heart
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
      "Give a heart to someone (default is 1)"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      bot = context.bot

      target_id = event.options['target'].to_i

      amount_to_give = event.options['amount']
      amount_to_give = 1 if amount_to_give.nil?

      target = Player.find_by(discord_id: target_id)

      unless target
        event.respond(content: "<@#{target_id}> isn't in this game. Valid players are:\n #{PlayerList.build}", allowed_mentions: { parse: [] }, ephemeral: true)
        return
      end

      if player.discord_id == target_id
        event.respond(content: "You can't give yourself HP!", ephemeral: true)
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

      unless range_list.include?([y, x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      if player.hp <= amount_to_give
        event.respond(content: "You can't do that, it will kill you!", ephemeral: true)
        return
      end

      player.update(hp: player.hp - amount_to_give)
      player.stats.update(hp_given: player.stats.hp_given + amount_to_give)

      target_was_dead = !target.alive?
      target.update(hp: target.hp + amount_to_give)
      target.stats.update(hp_received: target.stats.hp_received + amount_to_give)

      event.respond(content: "#{target.username} was healed for #{amount_to_give}HP!", ephemeral: true)
      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were given #{amount_to_give}HP by #{player.username}")
      event.channel.send_message target_was_dead ? 'Someone has been revived!' : 'Someone was healed!'

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
      player_global_stats.update(hp_given: player_global_stats.hp_given + amount_to_give)
      target_global_stats = GlobalStats.find_by(player_discord_id: target.discord_id)
      target_global_stats.update(hp_received: target_global_stats.hp_received + amount_to_give)

      if target.hp > target.stats.highest_hp
        target.stats.update(highest_hp: target.hp)
      end
      if target.hp > target_global_stats.highest_hp
        target_global_stats.update(highest_hp: target.hp)
      end

      Logging::BattleReport.logger.info(
        Logging::BattleReportBuilder.build(
          command_name: name,
          player_name: player.username,
          target_name: target.username,
          amount: amount_to_give
        )
      )
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
          description: 'How many hearts do you want to give (default is 1)',
        )
      ]
    end
  end
end
