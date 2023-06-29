require "rmagick"
include Magick
# Create a 100x100 red image.
image = Image.new(1000,1000) { |options| options.background_color = "red" }
# Set the text properties
text = 'Hello, World!'
font = 'Arial'
font_size = 50
x = 2
y = 50
color = 'black'

# Create a new Draw object
draw = Magick::Draw.new

# Set the font properties
draw.font = font
draw.pointsize = font_size
draw.fill = color

# Add the text to the image
draw.annotate(image, x, y, x, y, text)

# Save the modified image
image.write('output.png')