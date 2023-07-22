require_relative './base'
require_relative './lpers/list'
require_relative './helpers/clean_up'

module Command
  class VoteForPeace < Command::Base
    def name
      :vote_for_peace
    end

    def description
      "Start vote if more than 50% of players are dead. 60% of living players required to end game"
    end

    def execute(event:, game_data:, bot:)
      user = event.user
      player = Player.find_by(discord_id: user.id)

      full_player_count = Player.all.count
      alive_player_count = Player.where({ 'alive' => true }).count

      if (alive_player_count.to_f/full_player_count.to_f) * 10 > 5
        event.respond(content: "You cannot start a vote for peace with more than 50% of players alive", ephemeral: true)
        return
      end

      yesterday = DateTime.now - 1

      votes = PeaceVote.all
      votes.each do |vote|
        vote.destroy if vote.created_at < yesterday
        vote.destroy unless Player.find_by(id: vote.player_id).alive
      end

      if PeaceVote.find_by(player_id: player.id).nil?
        PeaceVote.create(player_id: player.id)
      else
        event.respond(content: "You have already voted in the last 24 hours", ephemeral: true)
        return
      end

      vote_count = PeaceVote.all.count

      if (vote_count.to_f/alive_player_count.to_f) * 10 > 6
        Command::Helpers::CleanUp.run(event: event, peace_vote: true)
      else
        event.respond(content: "Vote registered", ephemeral: true)
      end

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
