# Load the Rails application.
require_relative 'application'

require 'coveralls'
Coveralls.wear_merged!("rails")

# Initialize the Rails application.
Rails.application.initialize!
