require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './models/options'

module Command
  class Shoot < Command::Base
    def name
      :shoot
    end

    def description
      "Shoot someone"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data
      bot = context.bot

      x = event.options['x']
      y = event.options['y']

      unless player.energy >= game_data.shoot_cost
        event.respond(content: "Not enough energy!", ephemeral: true)
        return
      end

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

      if grid[y][x].nil? || grid[y][x] == 'heart' || grid[y][x] == 'energy_cell'
        event.respond(content:"No tank at that location!", ephemeral: true)
        return
      end

      target = grid[y][x]

      unless target.alive
        event.respond(content:"Tank is already dead!", ephemeral: true)
        return
      end

      player.update(energy: player.energy - game_data.shoot_cost)

      target.update(hp: target.hp - 1)

      if game.fog_of_war
        target_for_dm = bot.user(target.discord_id)
        target_for_dm.pm("You were shot by #{player.username}")
      end

      if target.hp <= 0
        player.update(kills: player.kills + 1)
        target.update(alive: false, hp: 0, deaths: target.deaths + 1)
        target_for_dm.pm("You are dead!") if game.fog_of_war

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == target.id
        end
      end

      BattleLog.logger.info("#{player.username} shot #{target.username}! #{target.username}: HP: #{target.hp}")

      if game.fog_of_war
        event.channel.send_message "Someone was shot! #{target.alive ? '' : 'They are dead!'}"
        event.respond(content: "You shot #{target.username}! #{target.alive ? '' : 'They are dead!'}", ephemeral: true)
      else
        event.respond(content: "<@#{target.discord_id}> was shot by #{player.username}! #{target.alive ? '' : 'They are dead!'}")
      end

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
        )
      ]
    end
  end
end