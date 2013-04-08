module Mailroute
  class Reseller < Base
    self.collection_name = 'reseller'

    has_one :branding_info
    has_many :customers
    has_many :contacts, :class => Mailroute::ResellerContact
    has_admins :class => Mailroute::Admin
  end
end