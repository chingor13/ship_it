# ShipIt

ShipIt is a customizeable rails app that manages deployments to environments from git branches.  Not only can it do one click deploys, but it can also save your log files and keep track of the changes deployed to each environment.

## Getting started

To initialize a `ship_it` application:

```
# install the gem
gem install `ship_it`

# initialize a project directory
ship_it new [PROJECT_NAME]

# run the server
ship_it start

# run the deployment runner
ship_it runner
```

## Authentication

`ship_it` uses [OmniAuth][omniauth] for authentication.  To customize, you can configure within `lib/ship_it/railtie.rb` in your project directory.

```
module ShipIt
  class Railtie < ::Rails::Railtie

    initializer "omniauth" do |app|
      app.config.middleware.use OmniAuth::Builder do
        provider :developer unless Rails.env.production?
        provider :github, [GITHUB_CLIENT_ID], [GITHUB_SECRET_KEY]
      end
    end

  end
end

```

Any [OmniAuth][omniauth] strategy is valid as long as it provides a `uid` and a `name`.


[omniauth]: https://github.com/intridea/omniauth