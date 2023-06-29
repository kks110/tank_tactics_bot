require_relative './base'
require_relative './helpers/generate_grid_message'

module Command
  class Instructions < Command::Base
    def name
      :instructions
    end

    def description
      "Instruction overview"
    end

    def execute(event:)
      instructions = "You are a tank and you have 3 HP and 2 range to start.\n" +
        "Everyone gets randomly placed on a grid. 1 energy a day gets distributed to everyone.\n" +
        "You can use that energy to:\n" +
        "- shoot (1 energy)\n" +
        "- move (1 energy)\n" +
        "- upgrade your range (3 energy)\n" +
        "- gain a HP (3 energy)\n\n" +
        "You can also give energy and HP to other players within your range.\n" +
        "Just because you are dead, does not mean you are out. Someone can give you HP to revive you. You will return with however much HP you are given to you and 0 energy.\n" +
        "When someone dies, the killer gets their energy.\n"

      event.respond(content: instructions)

    rescue => e
      event.respond(content: "An error has occurred: #{e}")
    end
  end
end
