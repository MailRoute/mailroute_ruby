module Mailroute
  class Domain < Base
    self.collection_name = 'domain'
    has_one :customer
    has_many :domain_aliases
    has_many :email_accounts
    has_many :mail_servers
    has_many :outbound_servers
    has_many :contacts, :class => ContactDomain
  end
end