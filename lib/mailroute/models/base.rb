module Mailroute
  class Base < ActiveResource::Base
    include ActiveResource::Extensions::UrlsWithoutJsonExtension

    def self.site(&block)
      if block_given?
        self.instance_variable_set(:@lazy_site, block)
      else
        block = self.instance_variable_get(:@lazy_site) || superclass.instance_variable_get(:@lazy_site)
        self.site = block.call
        super
      end
    end

    def self.headers
      if defined?(@headers)
        @headers
      elsif superclass.respond_to? :headers
        @headers ||= superclass.headers
      else
        @headers ||= {}
      end
    end

    self.site { Mailroute.url }
    self.headers['Authorization'] = Lazy { "ApiKey #{Mailroute.username}:#{Mailroute.apikey}" }

    class << self
      delegate :limit, :offset, :filter, :order_by, :to => :list
    end

    def self.collection_name
      ActiveSupport::Inflector.singularize(super)
    end

    def self.list(options = {})
      Relation.new(self)
    end
  end
end