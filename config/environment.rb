# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#Load CarrierWave after loading ORM
require 'carrierwave/orm/activerecord'
