module YamlConfiguration
  class PlaceholdersPreprocessor
    def initialize(configuration)
      @configuration = configuration
    end
    
    def parse(value)
      if value.respond_to?(:each)
        value.map {|v| self.parse(v)}
      else
        value.gsub(/\${([^}]*)}/) { @configuration.instance_eval($1) } 
      end
    end
  end
end
