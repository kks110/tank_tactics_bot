require 'logger'

module Logging
  class BattleReport
    def self.logger
      logger = Logger.new(log_path)
      logger.formatter = proc { |_, _, _, msg| "#{msg}\n" }
      logger
    end

    def self.reset_log
      File.delete(log_path) if File.exist?(log_path)
    end

    def self.log_path
      "#{ENV.fetch('LOG_PATH', './')}battle_report.txt"
    end
  end
end
