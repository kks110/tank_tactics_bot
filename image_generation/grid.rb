require "rmagick"
require "ostruct"

module ImageGeneration
  class Grid
    include Magick

    def generate_game_board(grid_x:, grid_y:, player:, players:, game_data:)

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

      image_font = game_data.image_font
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

        draw.fill = if !player.alive?
          'red'
        elsif player.disabled? && player.alive?
          'brown'
        else
          'black'
        end

        draw.annotate(
          image,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 27,
          (player.x_position * cell_size) + cell_size + 11,
          (player.y_position * cell_size) + cell_size + 27,
          player.username[0...7]
        )

        hp_text = player.alive ? "  #{player.hp}" : "Dead!󰯈"
        hp_text << " 󰂭" if player.disabled?
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

      draw.pointsize = 80

      cities = City.all
      cities.each do |city|
        message = ''
        if city.player_id
          draw.fill = 'silver'
          player = Player.find_by(id: city.player_id)
          message << player.username[0...7]
        else
          draw.fill = 'goldenrod'
          message << 'Unowned'
        end

        draw.pointsize = 80
        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 15,
          (city.y_position * cell_size) + cell_size + 70,
          (city.x_position * cell_size) + cell_size + 15,
          (city.y_position * cell_size) + cell_size + 70,
          "󰄚"
        )

        draw.fill = 'black'
        draw.pointsize = 22
        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 20,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 20,
          "X: #{city.x_position}"
        )

        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 40,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 40,
          "Y: #{city.y_position}"
        )

        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 95,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 95,
          message
        )
      end

      draw.pointsize = 80
      energy_cell = EnergyCell.find_by(collected: false)
      if energy_cell
        draw.fill = 'blue'
        energy_cell_coords = energy_cell.coords

        draw.annotate(
          image,
          (energy_cell_coords[:x] * cell_size) + cell_size + 30,
          (energy_cell_coords[:y] * cell_size) + cell_size + 80,
          (energy_cell_coords[:x] * cell_size) + cell_size + 30,
          (energy_cell_coords[:y] * cell_size) + cell_size + 80,
          "󰂄"
        )
      end

      image_location = "#{game_data.image_location}/#{player.username}_grid.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end

    def generate_pickup_board(grid_x:, grid_y:, game_data:)

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

      image_font = game_data.image_font
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

      draw.pointsize = 80


      EnergyCell.all.each do |energy_cell|
        draw.fill = energy_cell.collected ? 'gray' : 'blue'
        energy_cell_coords = energy_cell.coords

        draw.annotate(
          image,
          (energy_cell_coords[:x] * cell_size) + cell_size + 30,
          (energy_cell_coords[:y] * cell_size) + cell_size + 80,
          (energy_cell_coords[:x] * cell_size) + cell_size + 30,
          (energy_cell_coords[:y] * cell_size) + cell_size + 80,
          "󰂄"
        )
      end

      image_location = "#{game_data.image_location}/pickup_grid.png"
      # Save the modified image
      image.write(image_location)
      image_location
    end

    def generate_fog_of_war_board(grid_x:, grid_y:, player:, server_id:, game_data:, for_range: false)
      game = Game.find_by(server_id: server_id)
      players = Player.all

      players_positions = []
      players.each do |player_from_list|
        players_positions << [player_from_list.y_position, player_from_list.x_position]
      end

      range_list = Command::Helpers::DetermineRange.new.build_range_list(
        x_position: player.x_position,
        y_position: player.y_position,
        range: player.range,
        max_x: game.max_x,
        max_y: game.max_y
      )

      all_cells = []
      (0..game.max_y).to_a.each do |y|
        (0..game.max_x).to_a.each do |x|
          all_cells << [y,x]
        end
      end

      range_list.each do |range_item|
        all_cells.delete(range_item)
      end

      cities = City.all
      cities.each do |city|
        if player.id == city.player_id
          city_view = Command::Helpers::DetermineRange.new.build_range_list(
            x_position: city.x_position,
            y_position: city.y_position,
            range: 1,
            max_x: game.max_x,
            max_y: game.max_y
          )
          city_view.each do |view|
            all_cells.delete(view)
            range_list << view
          end
        end
      end


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

      image_font = game_data.image_font
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
        draw.fill = if !player.alive?
          'red'
        elsif player.disabled? && player.alive?
          'brown'
        else
          'black'
        end

        if range_list.include?([player.y_position, player.x_position])
          draw.annotate(
            image,
            (player.x_position * cell_size) + cell_size + 11,
            (player.y_position * cell_size) + cell_size + 27,
            (player.x_position * cell_size) + cell_size + 11,
            (player.y_position * cell_size) + cell_size + 27,
            player.username[0...7]
          )

          hp_text = player.alive ? "  #{player.hp}" : "Dead!󰯈"
          hp_text << " 󰂭" if player.disabled?
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
      end

      draw.pointsize = 80
    
      draw.fill = 'black'

      energy_cell = EnergyCell.find_by(collected: false)
      if energy_cell
        draw.fill = 'blue'
        energy_cell_coords = energy_cell.coords

        if range_list.include?([energy_cell_coords[:y], energy_cell_coords[:x]])
          draw.annotate(
            image,
            (energy_cell_coords[:x] * cell_size) + cell_size + 30,
            (energy_cell_coords[:y] * cell_size) + cell_size + 80,
            (energy_cell_coords[:x] * cell_size) + cell_size + 30,
            (energy_cell_coords[:y] * cell_size) + cell_size + 80,
            "󰂄"
          )
        end
      end
      draw.fill = 'black'

      cities.each do |city|
        next if all_cells.include?([city.y_position, city.x_position])

        message = ''
        if city.player_id
          draw.fill = 'silver'
          player = Player.find_by(id: city.player_id)
          message << player.username[0...7]
        else
          draw.fill = 'goldenrod'
          message << 'Unowned'
        end

        draw.pointsize = 80
        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 15,
          (city.y_position * cell_size) + cell_size + 70,
          (city.x_position * cell_size) + cell_size + 15,
          (city.y_position * cell_size) + cell_size + 70,
          "󰄚"
        )

        draw.fill = 'black'
        draw.pointsize = 22
        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 20,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 20,
          "X: #{city.x_position}"
        )

        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 40,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 40,
          "Y: #{city.y_position}"
        )

        draw.annotate(
          image,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 95,
          (city.x_position * cell_size) + cell_size + 11,
          (city.y_position * cell_size) + cell_size + 95,
          message
        )
      end

      all_cells.each do |fog_cell|
        draw.pointsize = 80
        draw.fill = 'black'
        draw.annotate(
          image,
          (fog_cell[1] * cell_size) + cell_size + 15,
          (fog_cell[0] * cell_size) + cell_size + 70,
          (fog_cell[1] * cell_size) + cell_size + 15,
          (fog_cell[0] * cell_size) + cell_size + 70,
          ""
        )
      end

      image_location = "#{game_data.image_location}/#{player.username}_#{for_range ? 'range_grid.png' : 'grid.png'}"
      # Save the modified image
      image.write(image_location)
      image_location
    end
  end
end
