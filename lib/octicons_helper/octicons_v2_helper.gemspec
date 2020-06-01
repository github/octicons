require File.expand_path("../lib/octicons_v2_helper/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "octicons_v2_helper"
  s.version     = OcticonsV2Helper::VERSION
  s.summary     = "Octicons rails helper"
  s.description = "A rails helper that makes including svg Octicons simple."
  s.authors     = ["GitHub Inc."]
  s.email       = ["support@github.com"]
  s.files       = Dir["{lib}/**/*"] + ["LICENSE", "README.md"]
  s.homepage    = "https://github.com/primer/octicons"
  s.license     = "MIT"

  s.require_paths = ["lib"]

  s.add_dependency "octicons_v2", "10.0.0"
  s.add_dependency "rails"
end
