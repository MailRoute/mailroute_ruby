module Mailroute
  class CustomerContact < Base
    self.collection_name = 'contact_customer'
    has_one :customer
  end
end