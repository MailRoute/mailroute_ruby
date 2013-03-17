module Mailroute
  class EmailAccount < Base
    self.collection_name = 'email_account'
    has_one :domain
  end
end