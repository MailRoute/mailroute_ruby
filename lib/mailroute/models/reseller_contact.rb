module Mailroute
  class ResellerContact < Base
    self.collection_name = 'contact_reseller'
    has_one :reseller
  end
end