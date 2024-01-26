class PlayerList

  def self.build
    players = Player.all

    players.each_with_object("") do |player, response|
      response << "<@#{player.discord_id}> (In game name: #{player.username})\n"
    end
  end
end
