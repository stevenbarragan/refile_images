require "rails"
require "refile_hassleless/imageable"

module RefileHassleless
  class Engine < ::Rails::Engine
    isolate_namespace RefileHassleless

    initializer "refile_hassleless.setup" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, RefileHassleless::Imageable)
      end

      ActionView::Base.send(:include, RefileHassleless::ImageAttachment)
      ActionView::Helpers::FormBuilder.send(:include, RefileHassleless::ImageAttachment::FormBuilder)
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
