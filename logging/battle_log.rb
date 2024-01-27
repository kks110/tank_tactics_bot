require 'logger'

module Logging
  class BattleLog
    def self.logger
      logger = Logger.new(log_path)
      logger.formatter = proc { |_, datetime, _, msg| "#{datetime}, #{msg}\n" }
      logger.datetime_format = '%Y-%m-%d %H:%M'
      logger
    end

    def self.reset_log
      File.delete(log_path) if File.exist?(log_path)
    end

    def self.log_path
      "#{ENV.fetch('LOG_PATH', './')}battle_log.txt"
    end
  end
end
