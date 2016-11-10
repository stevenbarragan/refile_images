require "rails"
require "refile_images/imageable"

module RefileImages
  class Engine < ::Rails::Engine
    isolate_namespace RefileImages

    initializer "refile_images.setup" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send(:include, RefileImages::Imageable)
      end

      ActionView::Base.send(:include, RefileImages::ImageAttachment)
      ActionView::Helpers::FormBuilder.send(:include, RefileImages::ImageAttachment::FormBuilder)
    end

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
