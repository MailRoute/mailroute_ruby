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

    self.site { Mailroute.url }
    self.headers['Authorization'] = lambda { "ApiKey #{Mailroute.username}:#{Mailroute.apikey}" }

    delegate :limit, :offset, :to => :list

    def self.collection_name
      ActiveSupport::Inflector.singularize(super)
    end

    def self.list(options = {})
      Relation.new(self)
    end

    def self.search(options)
      all(:params => options)
    end
  end
end