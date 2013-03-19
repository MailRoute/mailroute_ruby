module Mailroute
  class PolicyDomain < Base
    self.collection_name = 'policy_domain'
    has_one :domain
  end
end