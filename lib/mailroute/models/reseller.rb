require 'logger'

module Mailroute
  class Reseller < Base
    has_one :branding_info
    has_many :customers
  end
end

#ActiveResource::Base.logger = Logger.new(STDOUT)

