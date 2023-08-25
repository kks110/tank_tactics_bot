require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

module Command
  class GiveEnergy < Command::Base
    def name
      :give_energy
    end

    def requires_game?
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

      x = event.options['x']
      y = event.options['y']
      amount_to_give = event.options['amount']
      amount_to_give = 5 if amount_to_give.nil?

      if [player.y_position, player.x_position] == [y,x]
        event.respond(content: "You can't give yourself energy!", ephemeral: true)
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

      if player.energy < amount_to_give
        event.respond(content: "You can't give more than you have!", ephemeral: true)
        return
      end

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      if grid[y][x].nil? || grid[y][x] == 'heart' || grid[y][x] == 'energy_cell'
        event.respond(content:"No tank at that location!", ephemeral: true)
        return
      end

      target = grid[y][x]

      unless target.alive
        event.respond(content:"You can't give energy to a dead player!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - amount_to_give)
      player.stats.update(energy_given: player.stats.energy_given + amount_to_give)

      target.update(energy: target.energy + amount_to_give)
      target.stats.update(energy_received: target.stats.energy_received + amount_to_give)

      if target.energy > target.stats.highest_energy
        target.stats.update(highest_energy: target.energy)
      end

      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were given #{amount_to_give} energy by #{player.username}")

      BattleLog.logger.info("#{player.username} gave #{amount_to_give} energy to #{target.username}")
      event.respond(content: "#{target.username} was given energy by #{player.username}!", ephemeral: true)

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
          description: 'How much energy do you want to give (default is 5)',
        )
      ]
    end
  end
end
