require 'yaml'

module Config
  class GameData
    def initialize
      @config = load_config
    end

    def image_location
      ENV.fetch('TT_IMAGE_LOCATION', '.')
    end

    def image_font
      ENV.fetch('TT_IMAGE_FONT', '.')
    end

    def increase_hp_cost
      config['costs']['increase_hp']
    end

    def increase_range_base_cost
      config['costs']['increase_range_base']
    end

    def increase_range_per_level_cost
      config['costs']['increase_range_per_level']
    end

    def shoot_base_cost
      config['costs']['shoot_base']
    end

    def shoot_increment_cost
      config['costs']['shoot_increment']
    end

    def move_cost
      config['costs']['move']
    end

    def capture_city_cost
      config['costs']['capture_city']
    end

    def ramming_speed_cost
      config['costs']['ramming_speed']
    end

    def daily_energy_amount
      config['daily_energy']
    end

    def energy_cell_reward
      config['rewards']['energy_cell']
    end

    def captured_city_reward
      config['rewards']['captured_city']
    end

    def world_size_max(type: 'default')
      config['world_size_max'].fetch(type, 'default')
    end

    def starting_energy
      config['starting']['energy']
    end

    def starting_hp
      config['starting']['hp']
    end

    def starting_range
      config['starting']['range']
    end

    private

    attr_reader :config

    def load_config
      YAML.load_file("#{File.expand_path('..', __dir__)}/config/game_data.yml")
    end
  end
end
