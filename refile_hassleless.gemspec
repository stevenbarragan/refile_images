$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "refile_hassleless/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "refile_hassleless"
  s.version     = RefileHassleless::VERSION
  s.authors     = ["Steven Barragán"]
  s.email       = ["me@steven.mx"]
  s.homepage    = "http://github.com/stacksocial/refile_hassleless"
  s.summary     = "Summary of RefileHassleless."
  s.description = "Description of RefileHassleless."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "refile"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
end
