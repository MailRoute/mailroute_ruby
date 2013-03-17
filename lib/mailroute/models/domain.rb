module Mailroute
  class Domain < Base
    self.collection_name = 'domain'
    has_one :customer
    has_many :domain_aliases
  end
end