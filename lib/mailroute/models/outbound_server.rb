module Mailroute
  class OutboundServer < Base
    self.collection_name = 'outbound_server'
    has_one :domain
  end
end