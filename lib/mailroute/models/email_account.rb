module Mailroute
  class EmailAccount < Base
    self.collection_name = 'email_account'
    has_one :domain
    has_one :policy, :class => PolicyUser
    has_one :notification_task, :class => NotificationAccountTask
    has_one :contact, :class => EmailAccountContact
    has_many :wblist, :class => WBList
    has_many :aliases, :class => LocalpartAlias

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

    def regenerate_api_key
      response = connection.post(element_path(prefix_options) + 'regenerate_api_key/', nil, self.class.headers)
      self.class.format.decode(response.body)['api_key']
    end

    class << self
      alias_method :get_by_id, :get
      def get(*args)
        if args.size == 1
          get_by_id(*args)
        else
          localpart, domain = *args
          case domain
          when Domain
            get(localpart, domain.id)
          when String
            get(localpart, Domain.get(domain))
          when Integer
            EmailAccount.filter(:domain => domain, :localpart => localpart).first or raise ActiveResource::ResourceNotFound
          else
            raise 'Unknown argument type'
          end
        end
      end

      alias_method :create_by_attributes, :create
      def create(*args)
        if args.size == 1 && args.first.is_a?(String)
          localpart, domain_name = *args.first.split('@')
          domain = Domain.get(domain_name)
          raise ActiveResource::ResourceNotFound, "Domain with name #{domain_name} not found" unless domain
          create_by_attributes(:localpart => localpart, :domain => domain, :create_opt => 'generate_pwd')
        else
          create_by_attributes(*args)
        end
      end
    end
  end
end