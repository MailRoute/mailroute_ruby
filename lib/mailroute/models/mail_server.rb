module Mailroute
  class MailServer < Base
    self.collection_name = 'mail_server'
    has_one :domain
  end
end