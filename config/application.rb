require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AhadWebsite
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    # Maybe delete?
    config.public_file_server.enabled = true
    config.serve_static_assets = false
    config.assets.configure do |env|
      env.logger = Logger.new($stdout)
      env.cache = Sprockets::Cache::FileStore.new("./tmp/cache/assets")
    end
  end
end
