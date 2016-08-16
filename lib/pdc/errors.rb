module PDC
  # Base for all PDC generated errors
  class Error < StandardError; end

  class ConfigError < Error; end

  class InvalidPathError < Error; end
end
