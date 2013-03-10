module Mailroute
  class ContactReseller < Base
    self.collection_name = 'contact_reseller'
    has_one :reseller
  end
end