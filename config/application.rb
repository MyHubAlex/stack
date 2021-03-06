require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stack
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller
    config.active_job.queue_adapter = :sidekiq
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.generators do |g|
      g.tests_framework :rspec,
                        fixtures: true,   
                        view_specs: false,
                        helper_specs: false,
                        routing_specs: false,
                        request_specs: false,
                        controller_specs: true
      g.fixtures_replacement :factory_girl, dir: 'spec/factories' 
    end
  end
end
