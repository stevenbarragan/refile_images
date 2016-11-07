require "rails"
require "active_record"
require "refile"
require "refile/rails"

module RefileHassleless
  class Engine < ::Rails::Engine
    isolate_namespace RefileHassleless

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
