require 'logger'

class BattleLog
  def self.logger
    path = "#{log_path}battle_log.txt"
    logger = Logger.new(path)
    logger.formatter = proc { |_, datetime, _, msg| "#{datetime}, #{msg}\n" }
    logger.datetime_format = '%Y-%m-%d %H:%M'
    logger
  end

  def self.reset_log
    File.delete(log_path) if File.exist?(log_path)
  end

  def self.log_path
    ENV.fetch('LOG_PATH', './')
  end
end
