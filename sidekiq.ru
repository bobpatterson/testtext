# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)

set :app_file, __FILE__

require 'sidekiq'

HEROKU_API_KEY = ENV['HEROKU_API_KEY']
HEROKU_APP = ENV['HEROKU_APP']

require 'autoscaler/sidekiq'
require 'autoscaler/heroku_scaler'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }

  config.client_middleware do |chain|
    chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuScaler.new
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuScaler.new, 60)
  end
end

require 'sidekiq/web'
run Sidekiq::Web

