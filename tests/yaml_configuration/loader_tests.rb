require_relative '../tests_setup.rb'
require 'fileutils'
require 'hash_deep_merge'

module YamlConfiguration
  class LoaderTests < MiniTest::Unit::TestCase
    def test_that_the_yaml_configs_get_deep_merged
      config_a = {'user' => {'name' => 'David', 'surname' => 'Santoro', 'middle' => 'Maximillian'}, 'role' => 'developer'}
      config_b = {'user' => {'name' => 'John'}, 'role' => 'artist'}
      config_c = {'user' => {'surname' => 'Locke'}, 'role' => 'messiah'}
      
      recreate_directory('tmp')
      create_yaml_config_file(config_a, 'tmp/config_a.yml')
      create_yaml_config_file(config_b, 'tmp/config_b.yml')
      create_yaml_config_file(config_c, 'tmp/config_c.yml')

      combined_config = Loader.new.load('tmp/config_a', 'tmp/config_b', 'tmp/config_c')

      assert_equal 'John', combined_config.user.name
      assert_equal 'Locke', combined_config.user.surname
      assert_equal 'messiah', combined_config.role
      assert_equal 'Maximillian', combined_config.user.middle

      combined_config = Loader.new.load(['tmp/config_a', 'tmp/config_b', 'tmp/config_c'])

      assert_equal 'John', combined_config.user.name
    end

    private
    def recreate_directory(directory_path)
      full_path = File.join(File.dirname(__FILE__), '../..',directory_path)
      FileUtils.rm_rf full_path
      FileUtils.mkdir_p full_path
    end

    def create_yaml_config_file(hash, file_path)
      full_path = File.join(File.dirname(__FILE__),'../..', file_path)
      File.open(full_path, 'w') do |file|
        file.write(hash.to_yaml)
      end
    end
  end
end
