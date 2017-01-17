require_relative '../lib/pdc'
require 'ap'

# :nodoc:
class FakeLogger
  attr_accessor :level

  def debug(*args)
  end

  def info(*args)
  end

  def warn(*args)
  end

  def fatal(*args)
  end

  def error(*args)
  end
end

# PDC.logger = FakeLogger.new

logger = PDC.logger

logger.debug('Debug will be logged')
logger.info('Info will be logged as well')

logger.level = Logger::WARN

logger.debug('Created logger')    # won't be logged
logger.info('Program started')    # won't be logged
logger.warn('Nothing to do!')
logger.error('Error something really went wrong')

path = 'a_non_existent_file'

begin
  File.foreach(path) do |line|
    unless line =~ /^(\w+) = (.*)$/
      logger.error("Line in wrong format: #{line.chomp}")
    end
  end
rescue => err
  logger.fatal('Caught exception; exiting')
  logger.fatal(err)
end

logger.level = Logger::INFO
logger.info('will continue here')
