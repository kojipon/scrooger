# frozen_string_literal: true

require 'yaml'

file = File.join(__dir__, '..', '..', 'config.yml')
yaml = begin
  YAML.load_file(file)
rescue StandardError
  {}
end

def deep_freeze(hash)
  hash.freeze.each_value do |i|
    i.is_a?(Hash) ? deep_freeze(i) : i.freeze
  end
end

Scrooger::CONFIG = deep_freeze(yaml)
