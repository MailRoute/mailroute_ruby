module Mailroute
  class Domain < Base
    self.collection_name = 'domain'
    has_one :customer
    has_many :domain_aliases
    has_many :email_accounts
    has_many :mail_servers
    has_many :outbound_servers, :pk => :server
    has_many :contacts, :class => DomainContact
    has_many :wblist, :class => WBList
    has_one :policy, :class => PolicyDomain
    has_many :notification_tasks, :class => NotificationDomainTask

    def blacklist
      WBList.filter(:domain => id, :wb => 'b').map(&:email)
    end

    def whitelist
      WBList.filter(:domain => id, :wb => 'w').map(&:email)
    end

    def add_to_blacklist(address)
      create_wblist(:wb => 'b', :email => address)
    end

    def add_to_whitelist(address)
      create_wblist(:wb => 'w', :email => address)
    end

    def move_to_customer(another_customer)
      self.customer = another_customer
      self.save!
    end

    def bulk_create_email_account(localparts)
      connection.post(element_path + 'email_accounts/mass_add/', localparts.to_json, self.class.headers).tap do |response|
        ap response
      end
    end

    class << self
      alias_method :get_by_id, :get

      def get(id_or_name)
        case id_or_name
        when String
          filter(:name => id_or_name).first
        when Integer
          get_by_id(id_or_name)
        else
          raise 'Unknown argument type'
        end
      end
    end
  end
end