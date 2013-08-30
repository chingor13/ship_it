require 'rails'

require 'omniauth'

module ShipIt
  class Railtie < ::Rails::Railtie

    initializer "omniauth" do |app|
      app.config.middleware.use OmniAuth::Builder do
        provider :developer unless Rails.env.production?
        provider :github, "FIXME", "FIXME"
      end
    end

    initializer "database path" do |app|
      app.config.paths["db"] = File.join(Dir.pwd, "db")
      app.config.paths["config/database"] = File.join(Dir.pwd, "config", "database.yml")
    end
  end
end
