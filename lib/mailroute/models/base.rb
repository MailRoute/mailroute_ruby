module Mailroute
  class Base < ActiveResource::Base
    include ActiveResource::Extensions::UrlsWithoutJsonExtension

    class MetaInformation
      attr_reader :associations

      def initialize(klass)
        @associations = {}
        @klass = klass
      end

      def add_has_one(model, options)
        @associations[model] = HasOne.new(@klass, model, options)
      end

      def add_has_many(model, options)
        @associations[model] = HasMany.new(@klass, model, options)
      end
    end

    # TODO: move this stuff out
    class HasOne < Struct.new(:klass, :model, :options)
      # TODO: caching
      def inverse
        ActiveSupport::Inflector.underscore(klass.to_s.split('::').last)
      end

      def foreign_class
        Mailroute.const_get(ActiveSupport::Inflector.classify(model))
      end
    end

    # TODO: move this stuff out
    class HasMany < Struct.new(:klass, :model, :options)
      # TODO: caching
      def inverse
        ActiveSupport::Inflector.underscore(klass.to_s.split('::').last)
      end

      def foreign_class
        options[:class] || Mailroute.const_get(ActiveSupport::Inflector.classify(model))
      end
    end

    def self.meta
      @meta ||= MetaInformation.new(self)
    end

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

    def self.get(*args)
      self.find(*args)
    end

    def self.delete(*array)
      array.map do |r|
        if r.is_a? Mailroute::Base
          r.destroy
        else
          connection.delete(element_path(r, {}), headers)
        end
      end
    end

    def self.has_one(model, options = {})
#     p self.methods.grep(/method/)
      relation = meta.add_has_one(model, options)

      self.send(:define_method, model.to_s) do
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[model] ||= foreign_class.get(extract_id(super())).tap do |obj|
          obj.send("#{relation.inverse}=",  self)
        end if super()
      end
    end

    def self.has_many(model, options = {})
      relation = meta.add_has_many(model, options)

      self.send(:define_method, model.to_s) do
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[model] ||= foreign_class.filter(relation.inverse.to_sym => id).to_a
      end
    end

    private

    def extract_id(uri)
      uri.match(/(\/|^)(\d+)\/?$/)[2]
    end
  end
end
