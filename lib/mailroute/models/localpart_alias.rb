module Mailroute
  class LocalpartAlias < Base
    self.collection_name = 'localpart_alias'
    has_one :email_account
    has_one :domain
  end
end