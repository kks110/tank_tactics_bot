module Command
  class Options
    def initialize(type:, name:, description:, required: false, choices: {})
      @type = type
      @name = name
      @description = description
      @required = required
      @choices = choices
    end

    attr_reader :type, :name, :description, :required, :choices
  end
end
