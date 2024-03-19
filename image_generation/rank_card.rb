require "rmagick"
require "ostruct"

module ImageGeneration
  class RankCard
    include Magick

    KILLS_PER_MEDAL = 5
    DAMAGE_PER_MEDAL = 10

    def generate_rank_card(game_data:, stats:, high_and_low:)

      username = stats.username
      games_won = stats.games_won
      games_played = stats.games_played
      kills = stats.kills
      deaths = stats.deaths
      damage_done = stats.damage_done
      damage_received = stats.damage_received
      first_blood = stats.first_blood
      first_death = stats.first_death

      rank_mappings = {
        0 => { template: 'bronze', rank: 1 },
        1 => { template: 'bronze', rank: 2 },
        2 => { template: 'bronze', rank: 3 },
        3 => { template: 'gold', rank: 1 },
        4 => { template: 'gold', rank: 2 },
        5 => { template: 'gold', rank: 3 },
        6 => { template: 'emerald', rank: 1 },
        7 => { template: 'emerald', rank: 2 },
        8 => { template: 'emerald', rank: 3 },
        9 => { template: 'sapphire', rank: 1 },
        10 => { template: 'sapphire', rank: 2 },
        11 => { template: 'sapphire', rank: 3 },
        12 => { template: 'ruby', rank: 1 },
        13 => { template: 'ruby', rank: 2 },
        14 => { template: 'ruby', rank: 3 }
      }
      rank_mappings.default = {
        template: 'ruby',
        rank: 3
      }

      card_template_image = "#{rank_mappings[games_won][:template]}_template.png"
      card_shield_image = "#{rank_mappings[games_won][:template]}_#{rank_mappings[games_won][:rank]}.png"

      # Add logic for which card template
      card_template = Image.read("#{game_data.image_location}/image_templates/rank_cards/#{card_template_image}").first

      shield = Image.read("#{game_data.image_location}/image_templates/rank_shields/#{card_shield_image}").first
      card_template = card_template.composite(shield, ((card_template.columns / 2) - (shield.columns / 2)), 49 + 20, OverCompositeOp)

      if first_death == high_and_low["first_death"][:high]
        peacock_image = Image.read("#{game_data.image_location}/image_templates/icons/peacock.png").first
        card_template = card_template.composite(peacock_image, ((card_template.columns / 2) - (shield.columns / 2)), 382, OverCompositeOp)
        peacock_image = peacock_image.flop
        card_template = card_template.composite(peacock_image, 432, 382, OverCompositeOp)
      end

      if games_won == high_and_low["games_won"][:high]
        most_wins_image = Image.read("#{game_data.image_location}/image_templates/icons/most_wins.png").first
        card_template = card_template.composite(most_wins_image, ((card_template.columns / 2) - (most_wins_image.columns / 2)), 495 - 40, OverCompositeOp)
      end

      if damage_done == high_and_low["damage_done"][:high]
        most_damage_image = Image.read("#{game_data.image_location}/image_templates/icons/most_damage.png").first
        card_template = card_template.composite(most_damage_image, card_template.columns - 346, 495 - 20, OverCompositeOp)
      end

      if kills == high_and_low["kills"][:high]
        most_kills_image = Image.read("#{game_data.image_location}/image_templates/icons/most_kills.png").first
        card_template = card_template.composite(most_kills_image, 290, 495 - 20, OverCompositeOp)
      end

      kill_medals = add_kill_medals(card_template: card_template, kills: kills, game_data: game_data)
      card_template = kill_medals if kill_medals

      damage_medals = add_damage_medals(card_template: card_template, damage_done: damage_done, game_data: game_data)
      card_template = damage_medals if damage_medals

      draw = Magick::Draw.new
      image_font = game_data.image_font
      draw.font = image_font + '/font.ttf'
      draw.pointsize = 48
      draw.fill = 'black'

      win_percentage = (games_won.to_f / games_played.to_f) * 100
      win_percentage = win_percentage.nan? || win_percentage.infinite? ? 0 : win_percentage

      draw.pointsize = 33
      draw.annotate(card_template, 0, 0, 22, 615, '╭──────────────────────────────────────────╮')
      draw.annotate(card_template, 0, 0, 22, 648, table_title_value_builder(username: username, rank: "#{rank_mappings[games_won][:template].capitalize} #{rank_mappings[games_won][:rank]}"))
      draw.annotate(card_template, 0, 0, 22, 681, "├──────────────────────────────────────────┤")
      draw.annotate(card_template, 0, 0, 22, 714, "│ Games Won:          #{table_value_builder(value: "#{games_won} (#{win_percentage}%)")}│")
      draw.annotate(card_template, 0, 0, 22, 747, "│ Games Played:       #{table_value_builder(value: games_played)}│")
      draw.annotate(card_template, 0, 0, 22, 780, "│ Kills:              #{table_value_builder(value: kills)}│")
      draw.annotate(card_template, 0, 0, 22, 813, "│ Deaths:             #{table_value_builder(value: deaths)}│")
      draw.annotate(card_template, 0, 0, 22, 846, "│ Damage Done:        #{table_value_builder(value: damage_done)}│")
      draw.annotate(card_template, 0, 0, 22, 879, "│ Damage Received:    #{table_value_builder(value: damage_received)}│")
      draw.annotate(card_template, 0, 0, 22, 912, "│ First Bloods:       #{table_value_builder(value: first_blood)}│")
      draw.annotate(card_template, 0, 0, 22, 945, "│ First deaths:       #{table_value_builder(value: first_death)}│")
      draw.annotate(card_template, 0, 0, 22, 978, '╰──────────────────────────────────────────╯')

      image_location = "#{game_data.image_location}/output.png"
      # Save the modified image
      card_template.write(image_location)
      image_location
    end

    def table_title_value_builder(username:, rank:)
      text = "│ #{username} (#{rank})"
      (38 - username.length - rank.length).times{ text << ' ' }
      text << '│'
    end
    def table_value_builder(value:)
      text = " #{value.to_s}"
      (20 - value.to_s.length).times{ text << ' ' }
      text
    end

    def add_kill_medals(card_template:, kills:, game_data:)
      left_margin = 74
      top_margin = 65
      down_spacing = 143
      right_spacing = 97

      kill_medal_position = [
        [left_margin, top_margin],
        [left_margin, top_margin + down_spacing],
        [left_margin, top_margin + 2 * down_spacing],
        [left_margin + right_spacing, top_margin],
        [left_margin + right_spacing, top_margin + down_spacing],
        [left_margin + right_spacing, top_margin + 2 * down_spacing],
      ]

      medals_to_display = kills / KILLS_PER_MEDAL
      medals_to_display = 6 if medals_to_display > 6

      return if medals_to_display < 1

      kill_medal = Image.read("#{game_data.image_location}/image_templates/icons/kill_medal.png").first

      (1..medals_to_display).to_a.each do |pos|
        card_template = card_template.composite(kill_medal, kill_medal_position[pos - 1][0], kill_medal_position[pos - 1][1], OverCompositeOp)
      end

      card_template
    end

    def add_damage_medals(card_template:, damage_done:, game_data:)
      left_margin = 74
      top_margin = 65
      down_spacing = 143
      right_spacing = 97
      shield_spacing = 289

      damage_medal_positions = [
        [left_margin + 2 * right_spacing + shield_spacing, top_margin],
        [left_margin + 2 * right_spacing + shield_spacing, top_margin + down_spacing],
        [left_margin + 2 * right_spacing + shield_spacing, top_margin + 2 * down_spacing],
        [left_margin + 3 * right_spacing + shield_spacing, top_margin],
        [left_margin + 3 * right_spacing + shield_spacing, top_margin + down_spacing],
        [left_margin + 3 * right_spacing + shield_spacing, top_margin + 2 * down_spacing],
      ]

      medals_to_display = damage_done / DAMAGE_PER_MEDAL
      medals_to_display = 6 if medals_to_display > 6

      return if medals_to_display < 1

      damage_medal = Image.read("#{game_data.image_location}/image_templates/icons/damage_medal.png").first

      (1..medals_to_display).to_a.each do |pos|
        card_template = card_template.composite(damage_medal, damage_medal_positions[pos - 1][0], damage_medal_positions[pos - 1][1], OverCompositeOp)
      end

      card_template
    end
  end
end
