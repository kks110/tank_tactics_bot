module Command
  module Helpers
    class CleanUp
      def self.run(event:, game_data:, peace_vote: false)
        most_kills = Player.order({'kills' => :desc}).first
        most_deaths = Player.order({'deaths' => :desc}).first
        most_captures = Player.order({'city_captures' => :desc}).first

        game = Game.find_by(server_id: event.server_id)

        winners = Player.where({ 'alive' => true })

        response = ""

        response << "The vote for peace has been successful!\n" if peace_vote

        response << "The game has ended!\nThe winner's are:"

        winners.each do |winner|
          response << " <@#{winner.discord_id}>"
        end

        response << "\n"

        response << "Most Kills: #{most_kills.username}: #{most_kills.kills}\n"
        response << "Most Deaths: #{most_deaths.username}: #{most_deaths.deaths}\n"
        response << "Most City Captures: #{most_captures.username}: #{most_captures.city_captures}\n" if game.cities

        event.respond(content: response)

        players = Player.all

        image_location = ImageGeneration::Grid.new.generate_game_board(
          grid_x: game.max_x,
          grid_y: game.max_y,
          player: game_data.player,
          players: players,
          game_data: game_data
        )

        event.channel.send_file File.new(image_location)

        log_location = BattleLog.log_path
        event.channel.send_file File.new(log_location)

        peace_votes = PeaceVote.all
        peace_votes.each do |vote|
          vote.destroy
        end

        players.each do |player|
          if player.admin
            player.update(
              x_position: nil,
              y_position: nil,
              energy: 0,
              hp: 3,
              range: 2,
              alive: true,
              kills: 0,
              deaths: 0,
              city_captures: 0
            )
          else
            player.destroy
          end
        end

        Game.first.destroy

        Heart.first.destroy if Heart.first
        EnergyCell.first.destroy if EnergyCell.first

        City.all.each do |city|
          city.destroy
        end

        BattleLog.logger.info("The game has ended!\n")
      end
    end
  end
end