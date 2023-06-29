require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

module Command
  class GiveHeart < Command::Base
    def name
      :give_heart
    end

    def description
      "Give a heart to someone"
    end

    def execute(event:)
      x = event.options['x']
      y = event.options['y']
      amount_to_give = event.options['amount']
      amount_to_give = 1 if amount_to_give.nil?

      user = event.user
      player = Player.find_by(discord_id: user.id)
      grid = Command::Helpers::GenerateGrid.new.run

      range_list = Command::Helpers::DetermineRange.new.build_range_list(player_x: player.x_position, player_y: player.y_position, player_range: player.range)

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!")
        return
      end

      if grid[y][x].nil?
        event.respond(content:"No tank at that location!")
        return
      end

      target = grid[y][x]

      if player.hp <= amount_to_give
        event.respond(content: "You can't do that, it will kill you!")
        return
      end

      player.update(hp: player.hp - amount_to_give)
      target.update(hp: target.hp + amount_to_give)

      unless target.alive
        target.update(alive: true)
      end

      event.respond(content: "#{target.username} was healed for #{amount_to_give}HP!")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
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
          description: 'How many hearts do you want to give (default is 1)',
        )
      ]
    end
  end
end
