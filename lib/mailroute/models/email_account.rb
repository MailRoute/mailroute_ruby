module Mailroute
  class EmailAccount < Base
    self.collection_name = 'email_account'
    has_one :domain
    has_one :policy, :class => PolicyUser

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