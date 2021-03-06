require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChatOnline
    class Application < Rails::Application
        config.active_job.queue_adapter = :sidekiq

        # Warden create Log (Some user Logged in)
        Warden::Manager.after_authentication do |user, auth, opts|
            Log.create!(user_id: user.id, message: "#{user.email} Logged")
        end

        # Warden create Log (Some user Logout)
        Warden::Manager.before_logout do |user, auth, opts|
            Log.create!(user_id: user.id, message: "#{user.email} Logout")
        end
        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration should go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded.
    end
end
