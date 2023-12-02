require "rmagick"
require "ostruct"

module ImageGeneration
  class RankCard
    include Magick

    def generate_rank_card(game_data:, stats:, high_and_low:)

      games_won = stats.games_won
      kills = stats.kills
      deaths = stats.deaths
      damage_done = stats.damage_done
      damage_received = stats.damage_received
      first_blood = stats.first_blood
      first_death = stats.first_death
      
      games_won_adjusted = games_won - 1  # Adjusting for 0-based indexing
      template_type = case games_won_adjusted / 3
                      when 0 then "bronze"
                      when 1 then "gold"
                      when 2 then "emerald"
                      when 3 then "sapphire"
                      else "ruby"
                      end

      template_number = (games_won_adjusted % 3) + 1
      card_template_image = "#{template_type}_template.png"
      card_shield_image = "#{template_type}_#{template_number}.png"

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

      image_location = "#{game_data.image_location}/output.png"
      # Save the modified image
      card_template.write(image_location)
      image_location
    end

  end
end
