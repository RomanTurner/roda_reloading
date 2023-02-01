# frozen_string_literal: true

module Post
  # routes for 'posts'
  class Routes < Roda
    route do |r|
      r.root do
        'Posts Index'
      end
      r.on Integer do |i|
        "Show Post: #{i}"
      end
    end
  end
end
