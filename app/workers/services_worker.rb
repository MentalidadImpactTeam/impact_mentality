class ServicesWorker
  include Sidekiq::Worker

  def self.seguimiento
		services = Cron::Services.new
		services.seguimiento
  end
end
