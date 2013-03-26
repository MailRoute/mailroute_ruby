module Mailroute
  class << self
    attr_reader :username, :apikey, :url

    def configure(options)
      options = default_options.merge(options)

      @username = options[:username]
      @apikey = options[:apikey]
      @url = options[:url]

      Mailroute::Base.headers['Authorization'] = "ApiKey #@username:#@apikey"
      Mailroute::Base.site = @url
    end

    def default_options
      {
        :username => ENV['MAILROUTE_USERNAME'],
        :apikey   => ENV['MAILROUTE_API_KEY'],
        :url      => ENV['MAILROUTE_URL']
      }.dup
    end
  end
end