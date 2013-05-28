module Mailroute
  class NotificationAccountTask < Base
    self.collection_name = 'notification_account_task'
    has_one :email_account
  end
end