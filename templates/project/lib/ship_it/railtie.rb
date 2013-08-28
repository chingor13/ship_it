require 'rails'

module ShipIt
  class Railtie < ::Rails::Railtie

    initializer "omniauth" do
      puts "in initializer"
    end

  end
end