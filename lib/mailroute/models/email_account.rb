module Mailroute
  class EmailAccount < Base
    self.collection_name = 'email_account'
    has_one :domain
    has_one :policy, :class => PolicyUser
    has_one :notification_task, :class => NotificationAccountTask
    has_one :contact, :class => EmailAccountContact
    has_many :wblist, :class => WBList

    def blacklist
      WBList.filter(:email_account => id, :wb => 'b').map(&:email)
    end

    def whitelist
      WBList.filter(:email_account => id, :wb => 'w').map(&:email)
    end

    def add_to_blacklist(address)
      create_wblist(:wb => 'b', :email => address)
    end

    def add_to_whitelist(address)
      create_wblist(:wb => 'w', :email => address)
    end

    def set_password(new_password)
      self.password = new_password
      save!
      self
    end

    class << self
      alias_method :get_by_id, :get
      def get(*args)
        if args.size == 1
          get_by_id(*args)
        else
          localpart, domain = *args
          case domain
          when Mailroute::Domain
            get(localpart, domain.id)
          when String
            get(localpart, Domain.get(domain))
          when Integer
            EmailAccount.filter(:domain => domain, :localpart => localpart).first
          else
            raise 'Unknown argument type'
          end
        end
      end
    end
  end
end