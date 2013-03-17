module Mailroute
  class DomainAlias < Base
    self.collection_name = 'domain_alias'
    has_one :domain
  end
end