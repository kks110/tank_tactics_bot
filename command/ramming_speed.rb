require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './models/options'

module Command
  class RammingSpeed < Command::Base
    def name
      :ramming_speed
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      true
    end

    def description
      "Drives in to someone. Does 2 damage to them, 1 damage to you. Disables you for 24 hours"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data
      bot = context.bot

      x = event.options['x']
      y = event.options['y']

      if player.disabled?
        seconds_until_reset = player.disabled_until - Time.now
        event.respond(content: "You are disabled and will able to move in #{Command::Helpers::Time.seconds_to_hms(seconds_until_reset)}", ephemeral: true)
        return
      end

      cost_to_ram = game_data.ramming_speed_cost

      unless player.energy >= cost_to_ram
        event.respond(content: "Not enough energy! You need #{cost_to_ram} energy", ephemeral: true)
        return
      end

      grid = Command::Helpers::GenerateGrid.new.run(server_id: event.server_id)

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: 1,
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

      player.update(
        energy: player.energy - cost_to_ram,
        disabled_until: DateTime.now + 1,
        hp: target.hp - 1
      )

      if player.hp <= 0
        target.update(alive: false, hp: 0)
        target.stats.update(deaths: target.stats.deaths + 1)

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == target.id
        end
      end

      player.stats.update(
        damage_done: player.stats.damage_done + 2,
        energy_spent: player.stats.energy_spent + cost_to_ram
      )

      target.update(hp: target.hp - 2)
      target.stats.update(damage_received: target.stats.damage_received + 2)

      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were rammed by #{player.username}")

      if target.hp <= 0
        player.stats.update(kills: player.stats.kills + 1)
        target.update(alive: false, hp: 0)
        target.stats.update(deaths: target.stats.deaths + 1)
        target_for_dm.pm("You are dead!")

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == target.id
        end
      end

      BattleLog.logger.info("#{player.username} rammed #{target.username}! #{player.username} has #{player.hp} HP. #{target.username}: HP: #{target.hp}")

      event.respond(content: "You rammed #{target.username}! You are disabled for 24 hours. #{target.alive ? '' : 'They are dead!'} #{player.alive ? '' : 'You are dead!'}", ephemeral: true)
      event.channel.send_message "Someone was rammed! #{target.alive ? '' : 'The target is dead!'} #{player.alive ? '' : 'The aggressor is dead!'}"

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
