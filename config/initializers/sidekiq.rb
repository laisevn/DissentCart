require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule = YAML.load_file(Rails.root.join('config/sidekiq.yml'))[:schedule]
    Sidekiq::Scheduler.reload_schedule!
  end
end
