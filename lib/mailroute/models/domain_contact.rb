module Mailroute
  class DomainContact < Base
    self.collection_name = 'contact_domain'
    has_one :domain
  end
end