module A
      def create_outbound_server(args)
        p 111111111111111111
        if args === String
          super(:server => args)
        else
          super(args)
        end
      end
end

module Mailroute
  class Domain < Base
    include A

    self.collection_name = 'domain'
    has_one :customer
    has_many :domain_aliases
    has_many :email_accounts
    has_many :mail_servers
    has_many :outbound_servers, :pk => :server
    has_many :contacts, :class => ContactDomain
  end
end