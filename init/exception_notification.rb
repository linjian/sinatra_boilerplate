module ExceptionNotifier
  include ActiveSupport::Configurable

  def notify(exception, options={})
    if MyApp.settings.exception_notification['enable']
      SlackNotifier.new(config[:slack]).call(exception, options)
    end
  end

  def async_notify(exception, options={})
    Thread.new do
      # ActiveRecord::Base.connection_pool.with_connection do
        ExceptionNotifier.notify(exception, options)
      # end
    end
  end

  module_function :notify, :async_notify

  class SlackNotifier
    def initialize(options)
      @notifier = Slack::Notifier.new(options[:webhook_url], options)
    end

    def call(exception, options={})
      @notifier.ping('[' + MyApp.settings.app_env + '] ' + exception.hint)
    end
  end
end

ExceptionNotifier.configure do |config|
  config.slack = {
    :webhook_url  => MyApp.settings.exception_notification['slack']['webhook_url'],
    :channel      => MyApp.settings.exception_notification['slack']['channel'],
    :http_options => { open_timeout: 10 }
  }
end
