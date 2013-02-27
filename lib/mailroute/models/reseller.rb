module Mailroute
  class Reseller < ActiveResource::Base
    include ActiveResource::Extend::WithoutExtension
    include BasicConfiguration
  end
end

#ActiveResource::Base.logger = Logger.new(STDOUT)

