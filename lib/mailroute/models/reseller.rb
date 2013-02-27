require 'logger'

module Mailroute
  class Reseller < ActiveResource::Base
    include ActiveResource::Extend::WithoutExtension
    include BasicConfiguration

		def branding_info
			@branding_info ||= BrandingInfo.find(extract_id(super)) if super
		end

		private 
		
		def extract_id(uri)
			uri.match(/\/(\d+)\/$/)[1]
		end
  end
end

ActiveResource::Base.logger = Logger.new(STDOUT)

