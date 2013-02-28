require 'logger'

module Mailroute
  class Reseller < Base

    def branding_info
      @branding_info ||= BrandingInfo.find(extract_id(super)).tap do |bi|
        bi.reseller = self
      end if super
    end

    private

    def extract_id(uri)
      uri.match(/\/(\d+)\/$/)[1]
    end
  end
end

#ActiveResource::Base.logger = Logger.new(STDOUT)

