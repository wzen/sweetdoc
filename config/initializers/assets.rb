# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
precompile_target = lambda do |filename, path|
  puts filename
  # Mapファイルは除外
  path =~ /app\/assets/ && !%w(.map .map.js).include?(File.extname(filename))
end
Rails.application.config.assets.precompile = [
    precompile_target,
    /(?:\/|\\|\A)application\.(css|js)$/
]

Rails.application.config.assets.precompile += %w(markitup/skins/markitup/*.png markitup/sets/html/*.png)
Rails.application.config.assets.precompile += %w(*.eot *.svg *.ttf *.woff)

#Rails.application.config.assets.prefix = '/assets'