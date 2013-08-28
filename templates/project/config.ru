# This file is used by Rack-based servers to start the application.

require File.expand_path('../lib/ship_it/railtie', __FILE__)

require 'ship_it'
require 'ship_it/rails_app'

run ShipIt::Application
