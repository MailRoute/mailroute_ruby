module Mailroute
  class EmailAccountContact < Base
    self.collection_name = 'contact_email_account'
    has_one :email_account
  end
end