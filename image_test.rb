require "rmagick"
require "ostruct"
include Magick


grid_x_width = 8
grid_y_height = 8
cell_size = 100

kelvin = OpenStruct.new(username: 'kks110', hp: 1, range: 2, alive: true, x_position: 1, y_position: 1)
adam = OpenStruct.new(username: 'adam1333', hp: 3, range: 3, alive: true, x_position: 7, y_position: 0)
matt = OpenStruct.new(username: 't3hl0rd0f', hp: 2, range: 2, alive: true, x_position: 2, y_position: 2)
kiall = OpenStruct.new(username: 'kotakii', hp: 1, range: 2, alive: true, x_position: 3, y_position: 2)
tobias = OpenStruct.new(username: 'r3almicro', hp: 0, range: 2, alive: false, x_position: 5, y_position: 4)
ash = OpenStruct.new(username: 'scaredof', hp: 3, range: 2, alive: true, x_position: 5, y_position: 6)
players = [kelvin, adam, matt, kiall, tobias, ash]

image_x = (grid_x_width * cell_size) + cell_size
image_y = (grid_y_height * cell_size) + cell_size

# Create a 100x100 red image.
image = Image.new(image_x, image_y) { |options| options.background_color = "white" }



# Create a new Draw object
draw = Magick::Draw.new

draw.stroke('black')
draw.stroke_width(1)

(grid_x_width+2).times do |row|
  next if row == 0
  draw.line(0, row * cell_size, image_y, row * cell_size)
end

(grid_y_height+2).times do |col|
  next if col == 0
  draw.line(col * cell_size, 0, col * cell_size, image_x)
end

draw.draw(image)

# Set the font properties
draw.font = './font.ttf'
draw.pointsize = 30
draw.fill = 'black'
# Add the text to the imag"e
(grid_x_width+1).times do |x_header|
  next if x_header == 0
  draw.annotate(image, (x_header * cell_size) + cell_size/2, cell_size / 2, (x_header * cell_size) + cell_size/2, cell_size / 2, (x_header-1).to_s)
end

(grid_y_height+1).times do |y_header|
  next if y_header == 0
  draw.annotate(image, cell_size / 2, (y_header * cell_size) + cell_size/2, cell_size / 2, (y_header * cell_size) + cell_size/2, (y_header-1).to_s)
end

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
    (player.y_position * cell_size) + cell_size + 54,
    (player.x_position * cell_size) + cell_size + 11,
    (player.y_position * cell_size) + cell_size + 54,
    hp_text
  )

  draw.annotate(
    image,
    (player.x_position * cell_size) + cell_size + 11,
    (player.y_position * cell_size) + cell_size + 76,
    (player.x_position * cell_size) + cell_size + 11,
    (player.y_position * cell_size) + cell_size + 76,
    "󰆤  #{player.range}"
  )
end


# Save the modified image
image.write('output.png')