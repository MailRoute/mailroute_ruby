module Mailroute
  class ContactCustomer < Base
    self.collection_name = 'contact_customer'
    has_one :customer
  end
end