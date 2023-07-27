require 'logger'

class ErrorLog
  def self.logger
    logger = Logger.new(log_path)
    logger.formatter = proc { |_, datetime, _, msg| "#{datetime}, #{msg}\n" }
    logger.datetime_format = '%Y-%m-%d %H:%M'
    logger
  end

  def self.log_path
    ENV.fetch('LOG_PATH', 'error_log.txt')
  end
end
