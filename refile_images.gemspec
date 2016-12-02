# frozen_string_literal: true
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "refile_images/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "refile_images"
  s.version     = RefileImages::VERSION
  s.authors     = ["Steven Barragán"]
  s.email       = ["me@steven.mx"]
  s.homepage    = "http://github.com/stacksocial/refile_images"
  s.summary     = "Summary of RefileImages."
  s.description = "Description of RefileImages."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "refile", "~> 0.6.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "shoulda-matchers", "~> 3.1"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rubocop", "~> 0.45"
end
