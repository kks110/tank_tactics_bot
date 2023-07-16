module Command
  module Helpers
    class CleanUp
      def self.run(event:, peace_vote: false)
        most_kills = Player.order({'kills' => :desc}).first
        most_deaths = Player.order({'deaths' => :desc}).first

        winners = Player.where({ 'alive' => true })

        response = ""

        response << "The vote for peace has been successful!\n" if peace_vote

        response << "The game has ended!\nThe winner/s are:"

        winners.each do |winner|
          response << " <@#{winner.discord_id}>"
        end

        response << ". "

        response << "Most Kills: #{most_kills.username}: #{most_kills.kills}\n"
        response << "Most Deaths: #{most_deaths.username}: #{most_deaths.deaths}"


        event.respond(content: response)

        peace_votes = PeaceVote.all
        peace_votes.each do |vote|
          vote.destroy
        end

        players = Player.all
        players.each do |player|
          if player.admin
            player.update(
              x_position: nil,
              y_position: nil,
              energy: 0,
              hp: 3,
              range: 2,
              kills: 0,
              deaths: 0,
              )
          else
            player.destroy
          end
        end

        Game.first.destroy

        Heart.first.destroy if Heart.first
        EnergyCell.first.destroy if EnergyCell.first

        BattleLog.logger.info("The game has ended!\n")
      end
    end
  end
end