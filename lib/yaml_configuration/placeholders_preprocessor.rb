module YamlConfiguration
  class PlaceholdersPreprocessor
    def initialize(configuration)
      @configuration = configuration
    end
    
    def parse(value)
      if value.respond_to?(:each)
        value.map {|v| self.parse(v)}
      else
        begin
          value.to_s.gsub(/\${([^}]*)}/) { @configuration.instance_eval($1) } 
        rescue Exception => ex
          puts @configuration.inspect
          raise ex
        end
      end
    end
  end
end
