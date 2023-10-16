require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

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

      x = event.options['x']
      y = event.options['y']
      amount_to_give = event.options['amount']
      amount_to_give = 1 if amount_to_give.nil?

      if [player.y_position, player.x_position] == [y,x]
        event.respond(content: "You can't give yourself HP!", ephemeral: true)
        return
      end

      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      if grid[y][x].nil? || grid[y][x] == 'heart' || grid[y][x] == 'energy_cell'
        event.respond(content:"No tank at that location!", ephemeral: true)
        return
      end

      target = grid[y][x]

      if player.hp <= amount_to_give
        event.respond(content: "You can't do that, it will kill you!", ephemeral: true)
        return
      end

      player.update(hp: player.hp - amount_to_give)
      player.stats.update(hp_given: player.stats.hp_given + amount_to_give)

      target.update(hp: target.hp + amount_to_give)
      target.stats.update(hp_received: target.stats.hp_received + amount_to_give)

      if target.hp > target.stats.highest_hp
        target.stats.update(highest_hp: target.hp)
      end

      target_was_dead = !target.alive
      unless target.alive
        target.update(alive: true)
      end


      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were given #{amount_to_give}HP by #{player.username}")

      BattleLog.logger.info("#{player.username} gave #{amount_to_give} HP to #{target.username}")

      event.channel.send_message target_was_dead ? 'Someone has been revived!' : 'Someone was healed!'
      event.respond(content: "#{target.username} was healed for #{amount_to_give}HP!", ephemeral: true)

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'integer',
          name: 'x',
          description: 'The X coordinate',
          required: true,
          ),
        Command::Models::Options.new(
          type: 'integer',
          name: 'y',
          description: 'The Y coordinate',
          required: true,
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
