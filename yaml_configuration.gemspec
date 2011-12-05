# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yaml_configuration/version"

Gem::Specification.new do |s|
  s.name        = "yaml_configuration"
  s.version     = YamlConfiguration::VERSION
  s.authors     = ["David Santoro"]
  s.email       = ["soulnafein@gmail.com"]
  s.homepage    = "http://github.com/soulnafein/yaml_configuration"
  s.summary     = %q{A simple wrapper for a yaml based configuration}
  s.description = %q{Load, merge and provide sensible error messages when using yaml based configuration}

  s.rubyforge_project = "yaml_configuration"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "minitest"
  s.add_development_dependency "turn"
  s.add_development_dependency "ansi"
  s.add_runtime_dependency "hash-deep-merge"
end
