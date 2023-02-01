# frozen_string_literal: true

# This file contains logger configuration.

Application.register_provider(:loader) do
  prepare do
    require 'zeitwerk'
  end
  start do
    target.start :environment_variables
    loader = Zeitwerk::Loader.new
    loader.enable_reloading if target[:env] == 'development'
    loader.push_dir('allocs')
    # loader.collapse('#{__dir__}/*/views/*')
    # loader.ignore('allocs/*/routes.rb')
    # loader.load_file('app.rb')
    loader.setup
    loader.eager_load if target[:env] == 'production'
    register(:loader, loader)
  end
end
