require_relative '../lib/yaml_configuration.rb'
require 'turn'

def assert_exception(exception, message=nil)
  begin
    yield
    assert false, "The block was expected to throw an exception but it didn't"
  rescue Exception => ex
    unless message.nil?
      assert_equal message, ex.message, "The exception message is not the expected one."
    end
    assert_equal exception.to_s, ex.class.to_s, "The block was expected to throw a #{exception} but it did throw #{ex.class}"
  end
end

