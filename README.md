Refile Images
-------------

[![Build Status](https://travis-ci.org/stacksocial/refile_images.svg?branch=master)](https://travis-ci.org/refile/refile)

Refile + Only one migration needed ever + default images sizes

## Quick start

Add the gem:

```ruby
gem "refile_images"
```

Copy/Create [images](https://github.com/stacksocial/refile_images/blob/master/db/migrate/20161107201317_create_refile_images_images.rb) migration
```bash
bundle exec rake refile_images:install:migrations
rake db:migrate
```

Your model:

```ruby
class User
  include RefileImages::Imageable

  image :profile_image, defaults: {
    sm: "fill/100/200",
    md: "fit/200/400",
    lg: "fit/400/800"
  }

  images :pictures, defaults: {
    main:   "fit/500/500",
    mobile: "fit/200/200"
  }
end
```

Your form:

```erb
<%= form_for @user do |form| %>
  <%= form.attachment_field :profile_image %>
  <%= form.attachment_field :pictures, multiple: true %>
<% end %>
```

### Get the default sizes urls

```ruby
user.profile_imge.url(:sm)
user.profile_imge.url(:lg)

user.profile_imge.url(:sm, format: :png)

user.pictures.each do |picture|
  picture.url(:main)
  picture.url(:mobile)
end
```

It's still refile gem underneath, check full [refile docs](https://github.com/refile/refile#refile) for more information.
