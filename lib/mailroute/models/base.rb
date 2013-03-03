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
      delegate :limit, :offset, :filter, :order_by, :search, :to => :list
    end

    def self.collection_name
      ActiveSupport::Inflector.singularize(super)
    end

    def self.list(options = {})
      Relation.new(self)
    end

    def to_json(options = {})
      super(options.merge(:root => false))
    end

    def self.bulk_create(*attribute_array)
      attribute_array.map do |attributes|
        create(attributes)
      end
    end

    alias_method :delete, :destroy

    def self.delete(*resellers_array)
      resellers_array.map do |r|
        if r.is_a? Mailroute::Base
          r.destroy
        else
          connection.delete(element_path(r, {}), headers)
        end
      end
    end
  end
end