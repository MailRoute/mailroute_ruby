require 'logger'

module Mailroute
  class Reseller < Base
    has_one :branding_info
    has_many :customers
    has_many :contacts, through: 'contact_reseller', class: Mailroute::ContactReseller
  end
end

#ActiveResource::Base.logger = Logger.new(STDOUT)

