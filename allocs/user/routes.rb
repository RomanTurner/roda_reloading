# frozen_string_literal: true

module User
  # routes for '/users'
  class Routes < Roda
    route do |r|
      r.root do
        'Users Index'
      end

      r.on Integer do |i|
        @user = User::DataModel[i]
        "Show User1: #{@user.full_name}s"
      end
    end
  end
end
