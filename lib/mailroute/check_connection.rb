module Mailroute
  class Client
    def initialize(username, apikey)
      @username = username
      @apikey = apikey
    end

    def check_connection
      response = RestClient.get 'https://admin-dev.mailroute.net/api/v1/reseller/',
                                'Accept' => 'application/json',
                                'Content-Type' => 'application/json',
                                'Authorization' => "ApiKey #@username:#@apikey"
      response.code == 200
    end
  end


  def self.check_connection
    Client.new(username, apikey).check_connection
  end
end