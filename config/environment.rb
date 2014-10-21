# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Coffeescript compile bare
Tilt::CoffeeScriptTemplate.default_bare = true

# Initialize the Rails application.
Rails.application.initialize!

# lib
require 'common/Constant'