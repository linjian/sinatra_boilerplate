class MyApp < Sinatra::Base
  # setup CORS
  use Rack::Cors do
    allow do
      origins '*'

      resource '*',
        headers: :any,
        methods: [:get, :post, :delete, :put, :patch, :options, :head],
        # http://jaketrent.com/post/expose-http-headers-in-cors/, Somehow we have to expose X-Request-Id in order to get X-pagination. Weird. But we will remove this in production anyway so keep it as a hack.
        expose: %w[X-Request-Id],
        max_age: 10.minutes
    end
  end

  register Sinatra::ConfigFile
  set :environments, %w{development test staging production}
  config_file File.join(settings.root, 'config/settings.yml')

  # i18n
  configure do
    I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
    I18n.load_path += Dir[File.join(settings.root, 'locales', '*.yml')]
    I18n.backend.load_translations
    I18n.config.available_locales = %i[en zh-CN]
    I18n.locale = :'zh-CN'
    I18n.default_locale = :'zh-CN'
  end

  configure do
    set :logging, development? ? Logger::DEBUG : Logger::INFO
    settings.add_charset << 'application/json'
    set :show_exceptions, false
  end

  configure :development do
    register Sinatra::Reloader

    use BetterErrors::Middleware
    # you need to set the application root in order to abbreviate filenames within the application:
    BetterErrors.application_root = File.expand_path('..', __FILE__)
  end

  before do
    ActiveRecord::Base.logger = logger if settings.development?
    content_type :json
  end

  before do
    pass if request.path_info.in?(['/', '/pass'])
    authenticate
  end

  after do
    # Returns any connections in use by the current thread back to the pool
    ActiveRecord::Base.clear_active_connections!
  end

  error JWT::DecodeError, JWT::ExpiredSignature do
    status 401
    message = 'Invalid Token'
    jbuilder :'shared/api_error', locals: {message: message}
  end

  error 401 do
    message = 'Invalid Token'
    jbuilder :'shared/api_error', locals: {message: message}
  end

  error ActiveRecord::RecordNotFound do
    status 404
    message = 'Not Found'
    jbuilder :'shared/api_error', locals: {message: message}
  end

  error StandardError do
    e = env['sinatra.error']
    ExceptionNotifier.async_notify(e)

    message =
      if settings.production?
        'Internal Server Error'
      else
        "#{e.class.name}: #{e.message}"
      end
    jbuilder :'shared/api_error', locals: {message: message}
  end
end
