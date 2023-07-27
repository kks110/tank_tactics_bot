require_relative './base'
require_relative './helpers/list'
require_relative './helpers/clean_up'

module Command
  class VoteForPeace < Command::Base
    def name
      :vote_for_peace
    end

    def description
      "Start vote if more than 50% of players are dead. 60% of living players required to end game"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data

      full_player_count = Player.all.count
      alive_player_count = Player.where({ 'alive' => true }).count

      if (alive_player_count.to_f/full_player_count.to_f) * 10 > 5
        event.respond(content: "You cannot start a vote for peace with more than 50% of players alive", ephemeral: true)
        return
      end

      yesterday = DateTime.now - 1

      votes = PeaceVote.all

      if player.peace_vote.nil?
        event.channel.send_message 'A vote for peace has started!'
      end

      votes.each do |vote|
        vote.destroy if vote.created_at < yesterday
        vote.destroy unless Player.find_by(id: vote.player_id).alive
      end

      if player.peace_vote.nil?
        PeaceVote.create(player_id: player.id)
      else
        event.respond(content: "You have already voted in the last 24 hours", ephemeral: true)
        return
      end

      vote_count = PeaceVote.all.count

      if (vote_count.to_f/alive_player_count.to_f) * 10 > 6
        Command::Helpers::CleanUp.run(event: event, game_data: game_data, peace_vote: true)
      else
        event.respond(content: "Vote registered", ephemeral: true)
      end

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
