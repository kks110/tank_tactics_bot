require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'

module Commands
  class GiveHeart < Commands::Base
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

      user = event.interaction.user
      player = Player.find_by(discord_id: user.id)
      grid = Commands::Helpers::GenerateGrid.new.run

      range_list = Commands::Helpers::DetermineRange.new.build_range_list(player_x: player.x_position, player_y: player.y_position, player_range: player.range)

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

      event.respond(content: "#{target.username} was healed for #{amount_to_give}HP!")

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end

    # TODO: Change options to be an options object rather than a hash
    def options
      [
        {
          type: 'integer',
          name: 'x',
          explanation: 'The X coordinate',
          required: true
        },
        {
          type: 'integer',
          name: 'y',
          explanation: 'The Y coordinate',
          required: true
        },
        {
          type: 'integer',
          name: 'amount',
          explanation: 'How many hearts you want to give (default is 1)'
        }
      ]
    end
  end
end