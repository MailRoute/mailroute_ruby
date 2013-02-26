module Mailroute
  class << self
    attr_reader :username, :apikey

    def configure(options)
      @username = options[:username]
      @apikey = options[:apikey]
    end
  end
end