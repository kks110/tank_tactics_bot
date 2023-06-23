require './commands/list'
class RegisterCommands
  def self.run(bot:)
    server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

    Commands::LIST.each do |command|
      bot.register_application_command(command.name, command.description, server_id: server_id)
    end
  end
end