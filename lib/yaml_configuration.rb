require "yaml_configuration/version"
require 'bundler/setup'

require_relative 'yaml_configuration/configuration'
require_relative 'yaml_configuration/loader'

module YamlConfiguration
  def self.load(*config_files)
    Loader.new.load(config_files)
  end
end
