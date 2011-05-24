# Load the rails application
require File.expand_path('../application', __FILE__)

require 'sunspot'
require 'sunspot/rails'

# Initialize the rails application
VinylGuide::Application.initialize!
