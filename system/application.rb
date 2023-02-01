# frozen_string_literal: true

require 'bundler/setup'
require 'dry-system'

# configurations for the application
class Application < Dry::System::Container
  use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development') }
  configure do |_config|
  end
end
