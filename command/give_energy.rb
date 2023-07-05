require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

module Command
  class GiveEnergy < Command::Base
    def name
      :give_energy
    end

    def description
      "Give energy to someone"
    end

    def execute(event:)
      x = event.options['x']
      y = event.options['y']
      amount_to_give = event.options['amount']
      amount_to_give = 1 if amount_to_give.nil?

      user = event.user
      player = Player.find_by(discord_id: user.id)
      game = Game.find_by(server_id: event.server_id)
      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        player_x: player.x_position,
        player_y: player.y_position,
        player_range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      if grid[y][x].nil?
        event.respond(content:"No tank at that location!", ephemeral: true)
        return
      end

      target = grid[y][x]

      unless target.alive
        event.respond(content:"You can't give energy to a dead player!", ephemeral: true)
        return
      end

      if player.energy < amount_to_give
        event.respond(content: "You can't give more than you have!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - amount_to_give)
      target.update(energy: target.energy + amount_to_give)

      BattleLog.logger.info("#{player.username} gave #{amount_to_give} energy to #{target.username}")
      event.respond(content: "#{target.username} was given energy by #{player.username}!", ephemeral: true)

    rescue => e
      event.respond(content: "An error has occurred: #{e}", ephemeral: true)
    end

    def options
      [
        Command::Options.new(
          type: 'integer',
          name: 'x',
          description: 'The X coordinate',
          required: true,
        ),
        Command::Options.new(
          type: 'integer',
          name: 'y',
          description: 'The Y coordinate',
          required: true,
        ),
        Command::Options.new(
          type: 'integer',
          name: 'amount',
          description: 'How much energy do you want to give (default is 1)',
        )
      ]
    end
  end
end
