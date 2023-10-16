module Command
  class Base
    def initialize; end

    def name
      raise NotImplementedError, "Must Implement the name method for commands"
    end

    def requires_game?
      raise NotImplementedError, "Must Implement the requires_game? method for commands"
    end

    def requires_player_alive?
      raise NotImplementedError, "Must Implement the required_player_alive? method for commands"
    end

    def requires_player_not_disabled?
      raise NotImplementedError, "Must Implement the requires_player_not_disabled? method for commands"
    end


    def description
      raise NotImplementedError, "Must Implement the description method for commands"
    end

    def execute
      raise NotImplementedError, "Must Implement the execute method for commands"
    end

    def options; end
  end
end
