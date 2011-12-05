module YamlConfiguration
  class Loader
    def load(*config_files)
      combined_configuration = {}
      config_files.each do |config_file|
        loaded_config = load_yaml_config(config_file)
        combined_configuration.deep_merge(loaded_config)
      end
      Configuration.new(combined_configuration)
    end

    private
    def load_yaml_config(path)
      full_path = File.expand_path(path + '.yml')
      if File.file?(full_path)
        config = YAML.load(File.read(full_path))
        raise "The file '#{full_path}' is an invalid yaml config" unless config.respond_to?(:keys)
        config
      else 
        puts "Warning: The yaml config file '#{full_path}' does not exist."
        {}
      end
    rescue Psych::SyntaxError => exception
      raise "Error parsing YAML file '#{full_path}'\n Original cause: \n #{exception.message}"
    end
  end
end
