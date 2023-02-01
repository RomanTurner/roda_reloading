# frozen_string_literal: true

# This file contain code to setup the database connection.

Application.register_provider(:database) do |_container|
  prepare do
    require 'sequel/core'
  end

  start do
    target.start :environment_variables
    # Delete DATABASE_URL from the environment, so it isn't accidently passed to subprocesses.
    DB = Sequel.connect(ENV.delete('DATABASE_URL'))
    # Register database component.
    register(:database, DB)
  end
end
