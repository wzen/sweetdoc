# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Coffeescript compile bare
Tilt::CoffeeScriptTemplate.default_bare = true

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

Turnout.configure do |config|
  config.app_root = '.'
  config.named_maintenance_file_paths = {default: config.app_root.join('tmp', 'maintenance.yml').to_s}
  config.default_maintenance_page = Turnout::MaintenancePage::HTML
  config.default_reason = "The site is temporarily down for maintenance.\nPlease check back soon.\nor, Please contact <a href='http://profile.hatena.ne.jp/su_watanabe/'>Me<a>."
  config.default_allowed_paths = ['127.0.0.1', '192.168.0.0/24']
  config.default_response_code = 503
  config.default_retry_after = 3600
end

# Initialize the Rails application.
Rails.application.initialize!

