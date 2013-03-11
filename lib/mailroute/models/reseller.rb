require 'logger'

module Mailroute
  class Reseller < Base
    self.collection_name = 'reseller'

    has_one :branding_info
    has_many :customers
    has_many :contacts, class: Mailroute::ContactReseller
    has_admins class: Mailroute::Admin
  end
end

#ActiveResource::Base.logger = Logger.new(STDOUT)

