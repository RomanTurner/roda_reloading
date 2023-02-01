# frozen_string_literal: true

module Post
  # persistance model for posts
  class DataModel < Sequel::Model(DB[:post])
  end
end
