require "rmagick"
require "ostruct"

module ImageGeneration
  class Leaderboard
    include Magick

    def generate_leaderboard(game_data:, stats:, column_headings:, column_names:, high_and_low:)

      x = column_headings.count - 1
      y = stats.count

      # The size of each cell on the grid
      x_cell_size = 200
      y_cell_size = 160

      # The height and width of the image
      image_x = (x * x_cell_size) + x_cell_size
      image_y = (y * y_cell_size) + y_cell_size

      image = Image.new(image_x, image_y) { |options| options.background_color = "white" }

      draw = Magick::Draw.new
      draw.stroke('black')
      draw.stroke_width(1)

      # Draw the grid lines
      (x + 1).times do |col|
        next if col.zero?

        draw.line(col * x_cell_size, 0, col * x_cell_size, image_y)
      end

      (y + 1).times do |row|
        next if row.zero?

        draw.line(0, row * y_cell_size, image_x, row * y_cell_size)
      end

      draw.draw(image)

      image_font = game_data.image_font
      draw.font = image_font + '/font.ttf'
      draw.pointsize = 40
      draw.fill = 'black'

      column_headings.each_with_index do |header, index|
        split = header.split(' ')

        split.each_with_index do |word, word_index|
          draw.annotate(
            image,
            (index * x_cell_size) + 10,
            (y_cell_size / 3) * word_index + 30,
            (index * x_cell_size) + 10,
            (y_cell_size / 3) * word_index + 30,
            word
          )
        end
      end

      draw.pointsize = 60

      stats.each_with_index do |players_stats, index|
        column_names.each_with_index do |name, column_index|
          next if name == 'id'

          if name == 'player_id'
            draw.annotate(
              image,
              ((column_index - 1) * x_cell_size) + 10,
              ((index + 1) * y_cell_size) + (y_cell_size/2) + 15,
              ((column_index - 1) * x_cell_size) + 10,
              ((index + 1) * y_cell_size) + (y_cell_size/2) + 15,
              players_stats.player.username[0...6]
            )
          else
            draw.fill = 'black'
            text = players_stats.send(name.to_sym).to_s
            draw.fill = 'red' if high_and_low[name][:low].to_s == text
            draw.fill = 'green' if high_and_low[name][:high].to_s == text

            draw.annotate(
              image,
              ((column_index - 1) * x_cell_size) +  (x_cell_size/(text.length + 1)),
              ((index + 1) * y_cell_size) + (y_cell_size/2) + 15,
              ((column_index - 1) * x_cell_size) +  (x_cell_size/(text.length + 1)),
              ((index + 1) * y_cell_size) + (y_cell_size/2) + 15,
              text
            )
          end
        end
      end

      image_location = "#{game_data.image_location}/leaderboard.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end

  end
end
