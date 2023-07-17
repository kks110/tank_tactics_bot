require 'yaml'

module Config
  class GameData
    def initialize
      @config = load_config
    end

    def increase_hp_cost
      config['costs']['increase_hp']
    end

    def increase_range_cost
      config['costs']['increase_range']
    end

    def shoot_cost
      config['costs']['shoot']
    end

    def move_cost
      config['costs']['move']
    end

    def capture_city_cost
      config['costs']['capture_city']
    end


    def daily_energy_amount
      config['daily_energy']
    end

    def heart_reward
      config['rewards']['heart']
    end

    def energy_cell_reward
      config['rewards']['energy_cell']
    end

    def world_size_max(type: 'default')
      config['world_size_max'].fetch(type, 'default')
    end

    private

    attr_reader :config

    def load_config
      YAML.load_file(File.expand_path('..', __dir__) + '/config/game_data.yml')
    end
  end
end