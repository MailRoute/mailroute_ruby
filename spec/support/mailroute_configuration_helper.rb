module MailrouteConfigurationHelper
  def configure_mailroute
    Mailroute.configure(
      :username => ENV['MAILROUTE_USERNAME'] || 'blablablablabla@example.com',
      :apikey   => ENV['MAILROUTE_API_KEY']  || '5f64xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx8262',
      :url      => ENV['MAILROUTE_URL']      || 'https://admin-dev.mailroute.net/api/v1/'
    )
  end
end