module Mailroute
  class ContactAccount < Base
    self.collection_name = 'contact_email_account'
    has_one :email_account
  end
end