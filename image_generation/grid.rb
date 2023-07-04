require "rmagick"
require "ostruct"

module ImageGeneration
  class Grid
    include Magick

    def generate(grid_x:, grid_y:, players:, heart_cords:)

      grid_x = grid_x + 1
      grid_y = grid_y + 1
      # The size of each cell on the grid
      cell_size = 100

      # The height and width of the image
      image_x = (grid_x * cell_size) + cell_size
      image_y = (grid_y * cell_size) + cell_size

      image = Image.new(image_x, image_y) { |options| options.background_color = "white" }

      draw = Magick::Draw.new
      draw.stroke('black')
      draw.stroke_width(1)

      # Draw the grid lines
      (grid_x + 2).times do |row|
        next if row.zero?

        draw.line(0, row * cell_size, image_y, row * cell_size)
      end

      (grid_y + 2).times do |col|
        next if col.zero?
    
        draw.line(col * cell_size, 0, col * cell_size, image_x)
      end

      draw.draw(image)

      image_font = ENV.fetch('TT_IMAGE_FONT', '.')
      draw.font = image_font + '/font.ttf'
      draw.pointsize = 30
      draw.fill = 'black'

      # Add column and row headers
      (grid_x + 1).times do |x_header|
        next if x_header.zero?

        draw.annotate(image, (x_header * cell_size) + cell_size/2, cell_size / 2, (x_header * cell_size) + cell_size/2, cell_size / 2, (x_header-1).to_s)
      end

      (grid_y + 1).times do |y_header|
        next if y_header.zero?

        draw.annotate(image, cell_size / 2, (y_header * cell_size) + cell_size/2, cell_size / 2, (y_header * cell_size) + cell_size/2, (y_header-1).to_s)
      end

      # Draw column and row labels
      draw.annotate(
        image,
        cell_size - 60,
        25,
        cell_size - 60,
        25,
        "X "
      )

      draw.annotate(
        image,
        10,
        cell_size - 45,
        10,
        cell_size - 35,
        "Y"
      )

      draw.annotate(
        image,
        5,
        cell_size - 5,
        5,
        cell_size - 5,
        ""
      )

      draw.pointsize = 22

      # Draw the players on the board
      players.each do |player|
        draw.fill = player.alive ? 'black' : 'red'
        draw.annotate(
          image,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 27,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 27,
          player.username[0...7]
        )

        hp_text = player.alive ? "  #{player.hp}" : "Dead!󰯈"
        draw.annotate(
          image,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 50,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 50,
          hp_text
        )

        draw.annotate(
          image,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 71,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 71,
          "󰆤  #{player.range}"
        )

        draw.annotate(
          image,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 93,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 93,
          "X:#{player.x_position} Y:#{player.y_position}"
        )
      end

      if heart_cords
        draw.pointsize = 80
        draw.fill = 'green'

        draw.annotate(
          image,
          (heart_cords[:x] * cell_size) + cell_size + 10,
          (heart_cords[:y] * cell_size) + cell_size + 80,
          (heart_cords[:x] * cell_size) + cell_size + 10,
          (heart_cords[:y] * cell_size) + cell_size + 80,
          ""
        )
      end

      image_location = ENV.fetch('TT_IMAGE_LOCATION', '.')
      # Save the modified image
      image.write(image_location + '/grid.png')
    end
  end
end
