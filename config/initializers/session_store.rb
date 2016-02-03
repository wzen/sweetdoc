# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_Gal_session'
Rails.application.config.session_store :cookie_store, key: '_user_id_session', expire_after: ENV['SESSION_EXPIRE_MINUTES'].to_i.minutes
