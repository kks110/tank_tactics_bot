require './commands/list'
class RegisterCommands
  def self.run(bot:)
    server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

    Commands::LIST.each do |command|
      bot.register_application_command(command.name, command.description, server_id: server_id) do |cmd|
        puts "Registered command: #{command.name}"
        next if command.options.nil?

        command.options.each do |type, details|
          choices = details[:choices].nil? ? {} : details[:choices]
          required = details[:required].nil? ? false : details[:required]

          if type == :string
            cmd.string(details[:name], details[:explanation], required: required, choices: choices)
          end
        end
      end
    end
  end
end