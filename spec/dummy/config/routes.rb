# frozen_string_literal: true
Rails.application.routes.draw do
  mount RefileImages::Engine => "/refile_images"
end
