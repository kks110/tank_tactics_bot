require './commands/list'
class RegisterCommands
  def self.run(bot:)
    server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

    Commands::LIST.each do |command|
      bot.register_application_command(command.name, command.description, server_id: server_id) do |cmd|
        puts "Registered command: #{command.name}"
        next if command.options.nil?

        # Example of how to register options
        # if command.options.keys.include?(:boolean)
        #   cmd.boolean(command.options[:boolean][:name], command.options[:boolean][:explanation])
        # end
      end
    end
  end
end