module Mailroute
  class BrandingInfo < ActiveResource::Base
    include ActiveResource::Extend::WithoutExtension
    include BasicConfiguration

    self.collection_name = 'brandinginfo'
  end
end
