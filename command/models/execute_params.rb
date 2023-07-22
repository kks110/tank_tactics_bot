
module Command
  module Models
    class ExecuteParams
      def initialize(event:, game_data:, bot:, game:, player:)
        @event = event
        @game_data = game_data
        @bot = bot
        @game = game
        @player = player
      end

      attr_reader :event, :game_data, :bot, :game, :player
    end
  end
end
