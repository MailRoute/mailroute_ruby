module Mailroute
  class PolicyUser < Base
    self.collection_name = 'policy_user'
    has_one :email_account

    include PolicyFilter
  end
end