require_relative './base'
require_relative './helpers/list'
require_relative './helpers/clean_up'

module Command
  class VoteForPeace < Command::Base
    def name
      :vote_for_peace
    end

    def requires_game?
      true
    end

    def requires_player_alive?
      true
    end

    def requires_player_not_disabled?
      false
    end

    def description
      "Start vote if more than 50% of players are dead. 60% of living players required to end game"
    end

    def execute(context:)
      event = context.event
      player = context.player
      game_data = context.game_data

      full_player_count = Player.all.count
      allowed_vote_threshold = (full_player_count.to_f / 4.0).ceil
      alive_player_count = Player.where({ 'alive' => true }).count

      if alive_player_count > allowed_vote_threshold
        event.respond(content: "You cannot start a vote for peace with more than 25% (rounded up) of players alive", ephemeral: true)
        return
      end

      yesterday = DateTime.now - 1

      votes = PeaceVote.all

      votes.each do |vote|
        vote.destroy if vote.created_at < yesterday
        vote.destroy unless vote.player.alive
      end

      if player.peace_vote.nil?
        PeaceVote.create(player_id: player.id)
      else
        event.respond(content: "You have already voted in the last 24 hours", ephemeral: true)
        return
      end

      vote_count = PeaceVote.all.count

      if vote_count == alive_player_count
        Command::Helpers::CleanUp.run(event: event, game_data: game_data, peace_vote: true)
      else
        event.respond(content: "A vote for peace has been registered")
      end

      BattleLog.logger.info("#{player.username} voted for peace")

    rescue => e
      ErrorLog.logger.error("An Error occurred: Command name: #{name}. Error #{e}")
    end
  end
end
