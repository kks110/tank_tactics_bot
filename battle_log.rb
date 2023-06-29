require 'logger'

class BattleLog
  def self.logger
    logger = Logger.new('battle_log.txt')
    logger.formatter = proc { |_, datetime, _, msg| "#{datetime}, #{msg}\n" }
    logger.datetime_format = '%Y-%m-%d %H:%M'
    logger
  end
end
