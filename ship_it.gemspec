$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ship_it/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ship_it"
  s.version     = ShipIt::VERSION
  s.authors     = ["Jeff Ching"]
  s.email       = ["ching.jeff@gmail.com"]
  s.homepage    = "http://chingr.com"
  s.summary     = "Dashboard to manage capistrano deploys"
  s.description = "Dashboard to manage capistrano deploys"
  s.license     = "MIT"
  s.executables << "ship_it"

  s.files = Dir["{app,config,db,lib,ship_it_app}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "thor"
  s.add_dependency "thin"

  s.add_dependency "rails", "~> 4.0"
  s.add_dependency "sass-rails", "~> 4.0.0"
  s.add_dependency "uglifier", ">= 1.3.0"
  s.add_dependency "coffee-rails", "~> 4.0.0"
  s.add_dependency "jquery-rails"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "turbolinks"
  s.add_dependency "slim"
  s.add_dependency "sqlite3"
  s.add_dependency "omniauth"
end
