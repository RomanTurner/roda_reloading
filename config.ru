# frozen_string_literal: true

require 'listen'
require_relative 'system/boot'

loader = Application.resolve(:loader)
env = Application.resolve(:env)

if env == 'development'
  Listen.to(__dir__, only: /\.rb$/, force_polling: true) do
    load 'app.rb'
    loader.reload
  end.start

  run lambda { |env|
    loader.reload
    load 'app.rb'
    App.call(env)
  }
else
  run App.freeze.app
end
