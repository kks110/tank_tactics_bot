require 'logger'

class ErrorLog
  def self.logger
    path = "#{log_path}error_log.txt"
    logger = Logger.new(path)
    logger.formatter = proc { |_, datetime, _, msg| "#{datetime}, #{msg}\n" }
    logger.datetime_format = '%Y-%m-%d %H:%M'
    logger
  end

  def self.log_path
    ENV.fetch('LOG_PATH', './')
  end
end
