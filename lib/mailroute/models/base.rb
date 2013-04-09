module Mailroute
  class Base < ActiveResource::Base
    include ActiveResource::Extensions::UrlsWithoutJsonExtension

    class << self
      def meta
        @meta ||= MetaInformation.new(self)
      end

      def headers
        if defined?(@headers)
          @headers
        elsif superclass.respond_to? :headers
          @headers ||= superclass.headers
        else
          @headers ||= {}
        end
      end

      delegate :limit, :offset, :filter, :order_by, :search, :to => :list

      def list(options = {})
        Relation.new(self)
      end

      def bulk_create(*attribute_array)
        attribute_array.map do |attributes|
          create(attributes)
        end
      end

      alias_method :get, :find

      def delete(*array)
        array.map do |r|
          if r.is_a? Mailroute::Base
            r.destroy
          else
            connection.delete(element_path(r, {}), headers)
          end
        end
      end

      alias_method :instantiate_collection_without_meta, :instantiate_collection
      def instantiate_collection(collection, prefix_options = {})
        array = instantiate_collection_without_meta(collection, prefix_options)
        array.instance_variable_set(:@_meta, collection.instance_variable_get(:@_meta))
        array
      end

      def total_count
        limit(1).total_count
      end
    end

    def to_json(options = {})
      super(options.merge(:root => false))
    end

    alias_method :delete, :destroy

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

      self.send(:define_method, "create_#{ActiveSupport::Inflector.singularize(model.to_s)}") do |options|
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

      self.send(:define_method, :create_admin) do |email, send_welcome|
        send_welcome = !!send_welcome
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
