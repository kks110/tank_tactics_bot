require './commands/list'
class RegisterCommands
  def self.run(bot:)
    server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

    Commands::LIST.each do |command|
      bot.register_application_command(command.name, command.description, server_id: server_id) do |cmd|
        puts "Registered command: #{command.name}"
        next if command.options.nil?

        command.options.each do |option|
          choices = option[:choices].nil? ? {} : option[:choices]
          required = option[:required].nil? ? false : option[:required]

          if option[:type] == 'string'
            cmd.string(option[:name], option[:explanation], required: required, choices: choices)
          end

          if option[:type] == 'integer'
            cmd.integer(option[:name], option[:explanation], required: required, choices: choices)
          end
        end
      end
    end
  end
end