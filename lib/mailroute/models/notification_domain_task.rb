module Mailroute
  class NotificationDomainTask < Base
    self.collection_name = 'notification_domain_task'
    has_one :domain
  end
end