module Mailroute
  class NotificationAccountTask < Base
    self.collection_name = 'notification_account_task'
    has_one :email_account

    def is_active
      self.priority > domain_task.priority
    end

    def use_self_notification
      ap self.priority
      self.priority = domain_task.priority + 1
      ap self.priority
      self.save!
      ap self.priority
    end

    private

    def domain_task
      email_account.domain.notification_task
    end
  end
end