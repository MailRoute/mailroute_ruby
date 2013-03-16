class Mailroute::Customer < Mailroute::Base
  self.collection_name = 'customer'
  has_one :reseller, pk: 'name'
  has_one :branding_info
  has_many :domains
  has_many :contacts, class: Mailroute::ContactCustomer
  has_admins class: Mailroute::Admin
end