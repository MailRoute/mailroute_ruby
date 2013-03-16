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
  end
end
