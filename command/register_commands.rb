require_relative './list'

module Command
  class RegisterCommands
    def self.run(bot:)
      server_id = ENV.fetch('SLASH_COMMAND_BOT_SERVER_ID', nil)

      Command::LIST.each do |command|
        bot.register_application_command(command.name, command.description, server_id: server_id) do |cmd|
          puts "Registered command: #{command.name}"
          next if command.options.nil?

          command.options.each do |option|
            if option.type == 'string'
              cmd.string(
                option.name,
                option.description,
                required: option.required,
                choices: option.choices
              )
            end

            if option.type == 'integer'
              cmd.integer(
                option.name,
                option.description,
                required: option.required,
                choices: option.choices
              )
            end
          end
        end
      end
    end
  end
end
