class Mailroute::Customer < Mailroute::Base
  self.collection_name = 'customer'
  has_one :reseller, pk: 'name'
  has_many :domains
end