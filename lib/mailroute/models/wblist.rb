module Mailroute
  class WBList < Base
    self.collection_name = 'wblist'
    has_one :domain
    has_one :email_account
  end
end