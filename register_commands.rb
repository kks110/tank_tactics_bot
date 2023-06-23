
class RegisterCommands
  def self.run(bot:)
    # We need to register our application commands separately from the handlers with a special DSL.
    # This example uses server specific commands so that they appear immediately for testing,
    # but you can omit the server_id as well to register a global command that can take up to an hour
    # to appear.
    #
    # You may want to have a separate script for registering your commands so you don't need to do this every
    # time you start your bot.

    bot.register_application_command(:draw_board, 'Draw the game board', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil))

    # Example of how to add options
    # bot.register_application_command(:draw_board, 'Draw the game board', server_id: ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)) do |cmd|
    #   cmd.string('message', 'Message to spongecase')
    #   cmd.boolean('with_picture', 'Show the mocking sponge?')
    # end
  end
end