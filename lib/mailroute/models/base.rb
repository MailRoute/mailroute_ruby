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

      def add_has_admins(options)
        add_has_many(:admins, options)
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
        block = deep_instance_variable_get(self, :@lazy_site)
        self.site = block.call
        super
      end
    end

    def self.deep_instance_variable_get(klass, ivar)
      val = klass.instance_variable_get(ivar)
      if val || klass == Mailroute::Base
        val
      else
        deep_instance_variable_get(klass.superclass, ivar)
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
      relation = meta.add_has_one(model, options)

      self.send(:define_method, model.to_s) do
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[model] ||= foreign_class.get(extract_id(super())).tap do |obj|
          obj.send("#{relation.inverse}=",  self)
        end if super()
      end
    end

    def load(attributes, remove_root = false)
      new_attributes = {}
      attributes.each do |k, v|
        new_attributes[k] = if v.is_a? Mailroute::Base
                              v.resource_uri
                            else
                              v
                            end
      end
      super(new_attributes, remove_root)
    end

    def self.has_many(model, options = {})
      relation = meta.add_has_many(model, options)

      self.send(:define_method, model.to_s) do
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[model] ||= foreign_class.filter(relation.inverse.to_sym => id).to_a
      end

      self.send(:define_method, "create_#{ActiveSupport::Inflector.singularize(model)}") do |options|
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[model] = nil
        relation.foreign_class.create(options.merge(relation.inverse.to_s => attributes[:resource_uri]))
      end
    end

    def self.has_admins(options = {})
      relation = meta.add_has_admins(options)

      self.send(:define_method, :admins) do
        @_associations ||= {}
        foreign_class = relation.foreign_class #Mailroute.const_get(ActiveSupport::Inflector.classify(model_name))

        @_associations[:admins] ||= foreign_class.all(:params => {:scope => { :name => relation.inverse.to_s, :id => id}}).to_a
      end
    end

    private

    def extract_id(uri)
      uri.match(/(\/|^)(\d+)\/?$/)[2]
    end
  end
end
