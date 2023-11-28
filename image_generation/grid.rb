require "rmagick"
require "ostruct"

module ImageGeneration
  class Grid
    include Magick

    # The size of each cell on the grid
    CELL_SIZE = 100

    def generate_game_start_board(grid_x:, grid_y:, game_data:, server_id:)
      grid_x = grid_x + 1
      grid_y = grid_y + 1

      # The height and width of the image
      image_x = (grid_x * CELL_SIZE) + CELL_SIZE
      image_y = (grid_y * CELL_SIZE) + CELL_SIZE

      image = Image.new(image_x, image_y) { |options| options.background_color = "#EEEEEE" }

      draw = Magick::Draw.new

      draw.stroke('black')
      draw.stroke_width(1)

      # Draw the grid lines
      (grid_x + 2).times do |row|
        next if row.zero?

        draw.line(0, row * CELL_SIZE, image_y, row * CELL_SIZE)
      end

      (grid_y + 2).times do |col|
        next if col.zero?

        draw.line(col * CELL_SIZE, 0, col * CELL_SIZE, image_x)
      end

      draw.draw(image)

      draw.font = game_data.image_font + '/font.ttf'
      draw.pointsize = 30
      draw.fill = 'black'

      # Add column and row headers
      (grid_x + 1).times do |x_header|
        next if x_header.zero?

        draw.annotate(image, 0, 0, (x_header * CELL_SIZE) + CELL_SIZE/2, CELL_SIZE / 2, (x_header-1).to_s)
      end

      (grid_y + 1).times do |y_header|
        next if y_header.zero?

        draw.annotate(image, 0, 0, CELL_SIZE / 2, (y_header * CELL_SIZE) + CELL_SIZE/2, (y_header-1).to_s)
      end

      # Draw column and row labels
      draw.annotate(image, 0, 0, CELL_SIZE - 60, 25, "X ")
      draw.annotate(image, 0, 0, 10, CELL_SIZE - 35, "Y")
      draw.annotate(image, 0, 0, 5, CELL_SIZE - 5, "")

      draw.pointsize = 60
      draw.annotate(image, 0, 0, 40, 85, "")

      image_location = "#{game_data.image_location}/#{server_id}_grid.png"
      # Save the modified image
      image.write(image_location)
    end

    # Used for spectators and the final board
    def generate_spectator_game_board(players:, game_data:, server_id:)

      image = Image.read("#{game_data.image_location}/#{server_id}_grid.png").first

      draw = Magick::Draw.new
      draw.font = game_data.image_font + '/font.ttf'

      # Draw the players on the board
      players.each do |player|
        draw.pointsize = 22
        draw.fill = if player.disabled? && player.alive?
          'brown'
        elsif player.alive?
          'black'
        else
          'red'
        end

        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 27,
          player.username[0...7]
        )

        hp_text = player.alive? ? "  #{player.hp}" : "󰯈"
        hp_text << " 󰂭" if player.disabled?
        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 50,
          hp_text
        )

        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 71,
          "󰆤  #{player.range}"
        )

        draw.pointsize = 18
        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 93,
          "X:#{player.x_position} Y:#{player.y_position}"
        )
      end

      cities = City.all
      cities.each do |city|
        message = 'Unowned'

        # Should be able to do city.player, rather than a DB call
        if city.player
          draw.fill = 'silver'
          message = city.player.username[0...7]
        else
          draw.fill = 'goldenrod'
        end

        draw.pointsize = 60
        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 35,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 70,
          "󰄚"
        )

        draw.fill = 'black'
        draw.pointsize = 22
        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 25,
          "X: #{city.x_position}"
        )

        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 45,
          "Y: #{city.y_position}"
        )

        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 95,
          message
        )
      end

      draw.pointsize = 80
      energy_cell = EnergyCell.find_by(collected: false)
      if energy_cell
        draw.fill = 'blue'
        energy_cell_coords = energy_cell.coords

        draw.annotate(image, 0, 0,
          (energy_cell_coords[:x] * CELL_SIZE) + CELL_SIZE + 30,
          (energy_cell_coords[:y] * CELL_SIZE) + CELL_SIZE + 80,
          "󰂄"
        )
      end

      image_location = "#{game_data.image_location}/#{server_id}_spectator_grid.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end

    # Just shows the pickups
    def generate_pickup_board(game_data:, server_id:)
      text = Magick::Draw.new

      image = Image.read("#{game_data.image_location}/#{server_id}_grid.png").first

      text.font = game_data.image_font + '/font.ttf'
      text.pointsize = 80

      EnergyCell.all.each do |energy_cell|
        text.fill = energy_cell.collected ? 'gray' : 'blue'
        energy_cell_coords = energy_cell.coords

        text.annotate(image, 0, 0, (energy_cell_coords[:x] * CELL_SIZE) + CELL_SIZE + 30, (energy_cell_coords[:y] * CELL_SIZE) + CELL_SIZE + 80, "󰂄")
      end

      image_location = "#{game_data.image_location}/#{server_id}_pickup_grid.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end

    # Used to show the board to players during games
    def generate_player_board(player:, players:, game:, server_id:, game_data:)
      image = Image.read("#{game_data.image_location}/#{server_id}_grid.png").first

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      cities = City.all
      cities.each do |city|
        if city.player == player
          city_view = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: city.x_position,
            y_position: city.y_position,
            range: 1,
            max_x: game.max_x,
            max_y: game.max_y
          )
          city_view.each do |view|
            range_list << view
          end
        end
      end

      draw = Magick::Draw.new
      image_font = game_data.image_font
      draw.font = image_font + '/font.ttf'

      # Draw the players on the board
      players.each do |player|
        draw.pointsize = 22
        draw.fill = if player.disabled? && player.alive?
          'brown'
        elsif player.alive?
          'black'
        else
          'red'
        end

        next unless range_list.include?([player.y_position, player.x_position])

        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 27,
          player.username[0...7]
        )

        hp_text = player.alive? ? "  #{player.hp}" : "󰯈"
        hp_text << " 󰂭" if player.disabled?
        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 50,
          hp_text
        )

        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 71,
          "󰆤  #{player.range}"
        )

        draw.pointsize = 18
        draw.annotate(image, 0, 0,
          (player.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (player.y_position * CELL_SIZE) + CELL_SIZE + 93,
          "X:#{player.x_position} Y:#{player.y_position}"
        )
      end

      cities.each do |city|
        next unless range_list.include?([city.y_position, city.x_position])

        message = 'Unowned'

        # Should be able to do city.player, rather than a DB call
        if city.player
          draw.fill = 'silver'
          message = city.player.username[0...7]
        else
          draw.fill = 'goldenrod'
        end

        draw.pointsize = 60
        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 35,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 70,
          "󰄚"
        )

        draw.fill = 'black'
        draw.pointsize = 22
        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 25,
          "X: #{city.x_position}"
        )

        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 45,
          "Y: #{city.y_position}"
        )

        draw.annotate(image, 0, 0,
          (city.x_position * CELL_SIZE) + CELL_SIZE + 11,
          (city.y_position * CELL_SIZE) + CELL_SIZE + 95,
          message
        )
      end

      draw.pointsize = 80
      energy_cell = EnergyCell.find_by(collected: false)
      if energy_cell && range_list.include?([energy_cell.coords[:y], energy_cell.coords[:x]])
        draw.fill = 'blue'
        energy_cell_coords = energy_cell.coords

        draw.annotate(image, 0, 0,
          (energy_cell_coords[:x] * CELL_SIZE) + CELL_SIZE + 30,
          (energy_cell_coords[:y] * CELL_SIZE) + CELL_SIZE + 80,
          "󰂄"
        )
      end

      all_cells = []
      (0..game.max_y).to_a.each do |y|
        (0..game.max_x).to_a.each do |x|
          all_cells << [y,x]
        end
      end
      range_list.each do |range_item|
        all_cells.delete(range_item)
      end

      draw.fill = 'black'
      draw.pointsize = 90
      all_cells.each do |fog_cell|
        draw.annotate(image, 0, 0,
          (fog_cell[1] * CELL_SIZE) + CELL_SIZE + 8,
          (fog_cell[0] * CELL_SIZE) + CELL_SIZE + 80,
          ""
        )
      end

      image_location = "#{game_data.image_location}/#{server_id}_#{player.username}_grid.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end
  end
end
