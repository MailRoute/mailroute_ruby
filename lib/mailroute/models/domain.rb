module Mailroute
  class Domain < Base
    self.collection_name = 'domain'
    has_one :customer
  end
end