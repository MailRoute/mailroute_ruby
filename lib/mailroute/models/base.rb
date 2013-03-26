module Mailroute
  class Base < ActiveResource::Base
    include ActiveResource::Extensions::UrlsWithoutJsonExtension
    include DeepClassVariableGet

    def self.meta
      @meta ||= MetaInformation.new(self)
    end

    def self.site(&block)
      if block_given?
        self.instance_variable_set(:@lazy_site, block)
      else
        block = deep_class_variable_get(:@lazy_site)
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
        foreign_class = relation.foreign_class

        @_associations[model] ||= foreign_class.get(extract_id(super())).tap do |obj|
          obj.send("#{relation.inverse}=",  self)
        end if super()
      end

      self.send(:define_method, "#{model}=") do |v|
        if v.is_a? Mailroute::Base
          @_associations[model] = v

          super(v.resource_uri)
        else
          super(v)
        end
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
        foreign_class = relation.foreign_class

        @_associations[model] ||= foreign_class.filter(relation.inverse.to_sym => id).to_a
      end

      self.send(:define_method, "create_#{ActiveSupport::Inflector.singularize(model)}") do |options|
        foreign_class = relation.foreign_class

        @_associations[model] = nil
        if relation.pk && options.is_a?(String) && options !~ /^\/api\/v1/
          relation.foreign_class.create(relation.inverse.to_s => id, relation.pk => options)
        else
          relation.foreign_class.create(options.merge(relation.inverse.to_s => id))
        end
      end
    end

    def self.has_admins(options = {})
      relation = meta.add_has_admins(options)

      self.send(:define_method, :admins) do
        foreign_class = relation.foreign_class

        @_associations[:admins] ||= foreign_class.all(:params => {:scope => { :name => relation.inverse.to_s, :id => id}}).to_a
      end

      self.send(:define_method, :create_admin) do |email, send_welcome = false|
        foreign_class = relation.foreign_class

        @_associations[:admin] = nil
        admin = relation.foreign_class.new(:email => email, :send_welcome => send_welcome)
        admin.prefix_options[:scope] = { :name => relation.inverse.to_s, :id => id }
        admin.save!
        admin
      end

      self.send(:define_method, :delete_admin) do |email|
        foreign_class = relation.foreign_class

        @_associations[:admin] = nil
        admin = relation.foreign_class.all(:params => {:email => email, :scope => { :name => relation.inverse.to_s, :id => id}}).first

        if admin
          admin.prefix_options[:scope] = { :name => relation.inverse.to_s, :id => id }
          admin.destroy
        end
      end
    end

    def reload
      @_associations = {}.with_indifferent_access
      super
    end

    def initialize(attributes = {}, persisted = false)
      @_associations = {}.with_indifferent_access
      new_attributes = attributes.dup
      attributes.each do |k, v|
        next unless self.class.meta.associations.has_key?(k.to_sym)
        relation = self.class.meta.associations[k.to_sym]

        case v
        when Integer
          new_attributes[k] = relation.foreign_class.element_path(v)
        when Mailroute::Base
          @_associations[k] = v
          new_attributes[k] = v.element_path
        when String
          if relation.pk && v !~ /^\/api\/v1/
            all = relation.foreign_class.filter(relation.pk => v).limit(2).to_a
            case all.size
            when 0 then raise 'there is no such records'
            when 2 then raise 'there are too many records'
            end
            fst = all.first
            @_associations[k] = fst
            new_attributes[k] = fst.element_path
          else
            new_attributes[k] = v
          end
        end
      end

      super(new_attributes, persisted)
    end

    private

    def extract_id(uri)
      uri.match(/(\/|^)(\d+)\/?$/)[2].to_i
    end
  end
end
