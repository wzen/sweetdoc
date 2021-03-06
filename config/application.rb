require File.expand_path('../boot', __FILE__)
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sweetdoc
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Asia/Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.enforce_available_locales = true
    #config.i18n.enforce_available_locales = [:en, :ja]
    config.i18n.fallbacks = {'ja' => 'en'}

    # Encoding
    config.encoding = 'utf-8'

    # 全Modelを検索パスに含める
    config.autoload_paths += Dir["#{config.root}/app/models/**/"]
    # lib以下のコードを検索パスに含める
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # params.requireエラーで例外を発生させる
    config.action_controller.action_on_unpermitted_parameters = :raise

  end
end
