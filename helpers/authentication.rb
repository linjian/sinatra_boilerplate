class MyApp < Sinatra::Base
  helpers do
    def authenticate
      token =
        if request.env['HTTP_AUTHORIZATION'].present?
          request.env['HTTP_AUTHORIZATION'].split(' ').last
        elsif params[:user_token].present?
          params[:user_token]
        end

      halt(401) if token.blank?

      payload = JWT.decode(token, settings.secret_key_base).first
      user = User.enabled.find(payload["id"])

      if user.token_version == payload["version"] && payload["exp"].present?
        sign_in(user)
      else
        halt 401
      end
    end

    def sign_in(user)
      @current_user = user
    end

    def current_user
      @current_user
    end
  end
end
