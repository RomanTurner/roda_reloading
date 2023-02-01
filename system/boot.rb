# frozen_string_literal: true

# This file is responsible for loading all configuration files.
Dir['providers/*"'].each do |file|
  require_relative file
end

require_relative 'application'
require_relative 'import'

require 'securerandom'
require 'dry-validation'

Application.start(:environment_variables)
Application.start(:logger)
Application.start(:database)
Application.start(:models)
# Register automatically application classess and the external dependencies from the /system/boot folder.
Application.finalize!

# Add exsiting Logger instance to DB.loggers collection.
Application[:database].loggers << Application[:logger]

# Freeze internal data structures for the Database instance.
require 'pry' if Application.env == 'development'
Application[:database].freeze unless Application.env == 'development'
