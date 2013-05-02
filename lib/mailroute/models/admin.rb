module Mailroute
  class Admin < Base
    self.collection_name = 'admins'

    def self.collection_path(prefix_options = {}, query_options = nil)
      scope = prefix_options.delete(:scope) || (query_options && query_options.delete(:scope))
      raise 'Scope is missing' unless scope
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}admins/#{scope[:name]}/#{scope[:id]}/#{query_string(query_options)}"
    end

    def self.element_path(id, prefix_options = {}, query_options = nil)
      scope = prefix_options.delete(:scope) || (query_options && query_options.delete(:scope))
      raise 'Scope is missing' unless scope
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      "#{prefix(prefix_options)}admins/#{scope[:name]}/#{scope[:id]}/admin/#{URI.parser.escape id.to_s}/#{query_string(query_options)}"
    end

    def element_path
      super(scope)
    end

    def regenerate_api_key
      response = connection.post(element_path + 'regenerate_api_key/', nil, self.class.headers)
      self.class.format.decode(response.body)['api_key']
    end

    def scope
      raise 'invalid state' unless resource_uri =~ /admins\/([^\/]+)\/(\d+)\/admin/
      { :scope => { :id => $2.to_i, :name => $1 } }
    end

    def customer
      if resource_uri =~ /admins\/customer\/(\d+)\/admin/
        @customer ||= Mailroute::Customer.get($1.to_i)
      else
        nil
      end
    end

    def reseller
      if resource_uri =~ /admins\/reseller\/(\d+)\/admin/
        @reseller ||= Mailroute::Reseller.get($1.to_i)
      else
        nil
      end
    end

    def reload
      @customer = @reseller = nil
      super
    end

    def self.get(id, scope)
      find(id, :params => { :scope => { :name => scope.keys.first, :id => scope.values.first } })
    end
  end
end
