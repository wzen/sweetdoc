# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( run.js run_full_screen.js run.css gallery.js gallery_with_run.js gallery.css user.js user.css coding.js coding.css upload.js upload.css )

#Rails.application.config.assets.prefix = '/assets'