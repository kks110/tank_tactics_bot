
require 'discordrb'
require 'active_record'
require 'yaml'
require 'pry'
require_relative './initialise'
require_relative './models/game'
require_relative './models/player'
require_relative './models/city'
require_relative './models/stats'
require_relative './models/global_stats'
require_relative './models/energy_cell'
require_relative './models/peace_vote'
require_relative './logging/battle_report_builder'
require_relative './logging/battle_report'
require_relative './command/helpers/generate_grid'
require_relative './config/game_data'


game = Game.first
game_data = Config::GameData.new

unless game
  puts 'No game running!'
  return
end

unless game.started
  puts 'Game has not started!'
  return
end

City.all.each do |city|
  if city.player
    city.player.update(energy: city.player.energy + game_data.captured_city_reward) if city.player.alive?
    city.player.stats.update(daily_energy_received: city.player.stats.daily_energy_received + game_data.captured_city_reward) if city.player.alive?
    global_player_stats = GlobalStats.find_by(player_discord_id: city.player.discord_id)
    global_player_stats.update(daily_energy_received: global_player_stats.daily_energy_received + game_data.captured_city_reward) if city.player.alive?
  end
end

players = Player.all

mentions = ""
players.each do |player|
  player.update(energy: player.energy + game_data.daily_energy_amount) if player.alive?
  player.stats.update(daily_energy_received: player.stats.daily_energy_received + game_data.daily_energy_amount) if player.alive?
  global_player_stats = GlobalStats.find_by(player_discord_id: player.discord_id)
  global_player_stats.update(daily_energy_received: global_player_stats.daily_energy_received + game_data.daily_energy_amount) if player.alive?
  mentions << "<@#{player.discord_id}> " if player.alive?
end

response = "Energy successfully distributed! #{mentions}"

unless EnergyCell.find_by(collected: false)
  available_spawn_point = Command::Helpers::GenerateGrid.new.available_spawn_location(server_id: game.server_id)
  spawn_location = available_spawn_point.sample

  EnergyCell.create!(x_position: spawn_location[:x], y_position: spawn_location[:y])

  response << " An energy cell spawned at X:#{spawn_location[:x]}, Y:#{spawn_location[:y]}."
end

Player.all.each do |player|
  global_player_stats = GlobalStats.find_by(player_discord_id: player.discord_id)

  if player.energy > player.stats.highest_energy
    player.stats.update(highest_energy: player.energy)
  end

  if player.energy > global_player_stats.highest_energy
    global_player_stats.update(highest_energy: player.energy)
  end
end

bot = Discordrb::Bot.new(token: ENV.fetch('SLASH_COMMAND_BOT_TOKEN', nil), intents: [:server_messages])

bot.send_message(ENV.fetch('BOT_CHANNEL', nil), response)

Logging::BattleReport.logger.info(
  Logging::BattleReportBuilder.build(
    command_name: :give_everyone_energy,
    player_name: 'Bot'
  )
)
