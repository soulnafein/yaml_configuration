require_relative '../tests_setup.rb'

module YamlConfiguration
  class ConfigurationTests < MiniTest::Unit::TestCase
    def test_that_configuration_responds_to_existing_configuration_value
      configuration = Configuration.new({'site_name' => 'dancingonice', 'environment' => 'PRODUCTION'})
      assert_equal 'dancingonice', configuration.site_name
      assert_equal 'PRODUCTION', configuration.environment
    end

    def test_that_good_error_message_returned_for_missing_configuration
      configuration = Configuration.new({'site_name' => 'dancingonice'})
      
      assert_exception(RuntimeError, "The setting 'method_that_does_not_exist' is not present in the configuration") do
        configuration.method_that_does_not_exist
      end
    end

    def test_that_nested_configuration_return_correct_values
      configuration = Configuration.new({'database' => {'username' => 'david', 'password' => 'xxxx'}})

      assert_equal 'david', configuration.database.username
      assert_equal 'xxxx', configuration.database.password
    end
    
    def test_that_when_nested_configuration_has_missing_key_exception_mention_parent
      configuration = Configuration.new({'database' => {'user' => { 'name' => 'david'}, 'password' => 'xxxx'}})

      assert_exception(RuntimeError, "The setting 'database.user.method_that_does_not_exist' is not present in the configuration") do
        configuration.database.user.method_that_does_not_exist
      end
    end

    def test_that_asking_for_the_existence_of_a_settings_returns_true_or_false
      configuration = Configuration.new({'site' => {'name' => 'downtonabbey'}})

      assert configuration.site.name?
      refute configuration.site.database?
    end

    def test_that_placeholder_get_replaced_correctly
      configuration = Configuration.new({'host' => 'localhost', 'port' => 23, 
                                         'database' => { 'name' => 'mysql', 
                                         'base_url' => '${host}:${port}/${database.name}'}})

      assert_equal 'localhost:23/mysql', configuration.database.base_url
    end

    def test_that_placeholders_get_replaced_correctly_in_arrays
      urls = ['${host}:${port}/first', 
              '${host}:${port}/second',
              ['${host}:${port}/third','${host}:${port}/fourth']
            ]
      configuration = Configuration.new({'host' => 'localhost', 'port' => '23', 
                                         'urls' => urls})

      assert_equal ['localhost:23/first', 
                    'localhost:23/second',
                    ['localhost:23/third', 'localhost:23/fourth'],
                   ], configuration.urls
    end
  end
end
