module YamlConfiguration
  class Configuration
    def initialize(hash_configuration, parent=nil, name=nil)
      @config = hash_configuration
      @name = name
      @parent = parent
      @placeholders_preprocessor = PlaceholdersPreprocessor.new(self)
    end

    def full_name(setting_name)
      (hierarchy + [setting_name]).join('.')
    end

    def hierarchy
      return @parent.hierarchy + [@name] unless @parent.nil?
      []
    end

    def method_missing(method, *args, &block)
      method_name = method.to_s
      if asking_if_setting_exist(method_name)
        setting_exist?(method_name)
      elsif setting_exist?(method_name)
        return_value_of_setting(method_name)
      else
        raise "The setting '#{full_name(method_name)}' is not present in the configuration"
      end
    end

    def respond_to_missing?(method, *)
      asking_if_setting_exist(method.to_s) || setting_exist?(method.to_s) || super
    end

    private
    def asking_if_setting_exist(setting_name)
      setting_name =~ /^(.*)+\?$/
    end

    def setting_exist?(setting_name)
      @config.keys.include?(setting_name.gsub('?', ''))
    end

    def return_value_of_setting(setting_name)
      value = @config[setting_name]
      if value.respond_to?(:keys)
        return Configuration.new(value, self, setting_name)
      else
        return @placeholders_preprocessor.parse(value)
      end
    end
  end
end
