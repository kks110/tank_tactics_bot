require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './models/options'
require_relative './helpers/player_list'


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

    def requires_player_not_disabled?
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

      target_id = event.options['target'].to_i

      cost_to_ram = game_data.ramming_speed_cost

      target = Player.find_by(discord_id: target_id)

      unless target
        event.respond(content: "<@#{target_id}> isn't in this game. Valid players are:\n #{PlayerList.build}", allowed_mentions: { parse: [] }, ephemeral: true)
        return
      end

      if player.discord_id == target_id
        event.respond(content: "You can't ram yourself energy!", ephemeral: true)
        return
      end

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

      y = target.y_position
      x = target.x_position

      unless range_list.include?([y,x])
        event.respond(content: "Not in range!", ephemeral: true)
        return
      end

      if grid[y][x].nil? || grid[y][x] == 'energy_cell'
        event.respond(content:"No tank at that location!", ephemeral: true)
        return
      end

      unless target.alive?
        event.respond(content:"Tank is already dead!", ephemeral: true)
        return
      end

      player.update(
        energy: player.energy - cost_to_ram,
        disabled_until: DateTime.now + 1,
        hp: player.hp - 1
      )
      target.update(hp: target.hp - 2)

      event.respond(content: "You rammed #{target.username}! You are disabled for 24 hours. #{target.alive? ? '' : 'They are dead!'} #{player.alive? ? '' : 'You are dead!'}", ephemeral: true)

      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were rammed by #{player.username}")

      global_player_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

      if player.hp <= 0
        player.update(hp: 0)
        player.stats.update(deaths: player.stats.deaths + 1)
        global_player_stats.update(deaths: global_player_stats.deaths + 1)

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == player.id
        end
      end

      player.stats.update(
        damage_done: player.stats.damage_done + 2,
        energy_spent: player.stats.energy_spent + cost_to_ram
      )

      global_player_stats.update(
        damage_done: global_player_stats.damage_done + 2,
        energy_spent: global_player_stats.energy_spent + cost_to_ram
      )

      global_target_stats = GlobalStats.find_by(player_discord_id: target.discord_id)

      target.stats.update(damage_received: target.stats.damage_received + 2)
      global_target_stats.update(damage_received: global_target_stats.damage_received + 2)

      if target.hp <= 0
        unless game.first_blood
          player.stats.update(first_blood: player.stats.first_blood + 1)
          target.stats.update(first_death: target.stats.first_death + 1)

          global_player_stats.update(first_blood: global_player_stats.first_blood + 1)
          global_target_stats.update(first_death: global_target_stats.first_death + 1)

          game.update(first_blood: true)
        end

        player.stats.update(kills: player.stats.kills + 1)
        global_player_stats.update(kills: global_player_stats.kills + 1)

        target.update(hp: 0)
        target.stats.update(deaths: target.stats.deaths + 1)
        global_target_stats.update(deaths: global_target_stats.deaths + 1)

        target_for_dm.pm("You are dead!")

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == target.id
        end
      end

      BattleLog.logger.info("#{player.username} rammed #{target.username}! #{player.username} has #{player.hp} HP. #{target.username}: HP: #{target.hp}")

      event.channel.send_message "Someone was rammed! #{target.alive? ? '' : 'The target is dead!'} #{player.alive? ? '' : 'The aggressor is dead!'}"

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end

    def options
      [
        Command::Models::Options.new(
          type: 'user',
          name: 'target',
          description: 'The user you want to give a heart to',
          required: true
        )
      ]
    end
  end
end
