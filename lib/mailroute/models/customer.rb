module Mailroute
  class Customer < Base
    self.collection_name = 'customer'
    has_one :reseller, :pk => 'name'
    has_one :branding_info
    has_many :domains
    has_many :contacts, :class => CustomerContact
    has_admins :class => Admin
  end
end