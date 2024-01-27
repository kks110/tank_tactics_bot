require_relative './base'
require_relative './helpers/generate_grid'
require_relative './helpers/determine_range'
require_relative './models/options'

module Command
  class Shoot < Command::Base
    def name
      :shoot
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
      "Shoot someone"
    end

    def execute(context:)
      game = context.game
      event = context.event
      player = context.player
      game_data = context.game_data
      bot = context.bot

      target_id = event.options['target'].to_i
      target = Player.find_by(discord_id: target_id)

      unless target
        event.respond(content: "<@#{target_id}> isn't in this game. Valid players are:\n #{PlayerList.build}", allowed_mentions: { parse: [] }, ephemeral: true)
        return
      end

      if player.discord_id == target_id
        event.respond(content: "You can't shoot yourself!", ephemeral: true)
        return
      end

      yesterday = DateTime.now - 1

      if player.shot
        player.shot.update(created_at: Time.now, count: 0) if player.shot.created_at < yesterday
      else
        Shot.create!(player_id: player.id)
      end

      cost_to_shoot = game_data.shoot_base_cost + (game_data.shoot_increment_cost * (player.shot.count))

      unless player.energy >= cost_to_shoot
        event.respond(content: "Not enough energy! You need #{cost_to_shoot} for your next shot", ephemeral: true)
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

      player.update(energy: player.energy - cost_to_shoot)
      player.shot.update(count: player.shot.count + 1)
      target.update(hp: target.hp - 1)

      event.respond(content: "You shot #{target.username}! #{target.alive? ? '' : 'They are dead!'}, it cost #{cost_to_shoot}", ephemeral: true)
      target_for_dm = bot.user(target.discord_id)
      target_for_dm.pm("You were shot by #{player.username}")

      event.channel.send_message "Someone was shot! #{target.alive? ? '' : 'They are dead!'}"

      player_global_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

      player.stats.update(
        damage_done: player.stats.damage_done + 1,
        energy_spent: player.stats.energy_spent + cost_to_shoot
      )

      player_global_stats.update(
        damage_done: player_global_stats.damage_done + 1,
        energy_spent: player_global_stats.energy_spent + cost_to_shoot
      )

      target_global_stats = GlobalStats.find_by(player_discord_id: target.discord_id)

      target.stats.update(damage_received: target.stats.damage_received + 1)
      target_global_stats.update(damage_received: target_global_stats.damage_received + 1)

      if target.hp <= 0
        unless game.first_blood
          player.stats.update(first_blood: player.stats.first_blood + 1)
          target.stats.update(first_death: target.stats.first_death + 1)

          player_global_stats.update(first_blood: player_global_stats.first_blood + 1)
          target_global_stats.update(first_death: target_global_stats.first_death + 1)

          game.update(first_blood: true)
        end

        player.stats.update(kills: player.stats.kills + 1)
        player_global_stats.update(kills: player_global_stats.kills + 1)

        target.update(hp: 0)
        target.stats.update(deaths: target.stats.deaths + 1)
        target_global_stats.update(deaths: target_global_stats.deaths + 1)

        target_for_dm.pm("You are dead!")

        City.all.each do |city|
          city.update(player_id: nil) if city.player_id == target.id
        end
      end

      Logging::BattleLog.logger.info("#{player.username} shot #{target.username}! It cost #{cost_to_shoot} energy. #{target.username}: HP: #{target.hp}")

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
        )
      ]
    end
  end
end