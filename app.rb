# frozen_string_literal: true

require 'roda'
require 'dry/inflector'

## Rack entry point, and main host for all
# and configuration point for Roda plugins.
class App < Roda
  plugin :environments

  configure :development, :production do
    # A powerful logger for Roda with a few tricks up it's sleeve.
    plugin :enhanced_logger
  end

  # Allows modifying the default headers for responses.
  plugin :default_headers,
         'Content-Type' => 'application/json',
         'Strict-Transport-Security' => 'max-age=16070400;',
         'X-Frame-Options' => 'deny',
         'X-Content-Type-Options' => 'nosniff',
         'X-XSS-Protection' => '1; mode=block'

  plugin :all_verbs

  route do |r|
    r.root do
      'eh, chewsday init'
    end

    inflector = Dry::Inflector.new
    Dir['allocs/*'].each do |file|
      route_name = File.basename(file)
      r.on(route_name) do
        klass = inflector.classify(route_name)
        r.run inflector.constantize("#{klass}::Routes")
      end
    end
  end
end
