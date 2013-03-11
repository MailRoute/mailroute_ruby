module Mailroute
  class Admin < Base
    self.collection_name = 'admins'

    def self.collection_path(prefix_options = {}, query_options = nil)
      check_prefix_options(prefix_options)
      prefix_options, query_options = split_options(prefix_options) if query_options.nil?
      scope = query_options.delete(:scope)
      raise 'Scope is missing' unless scope
      "#{prefix(prefix_options)}#{collection_name}/#{scope[:name]}/#{scope[:id]}/#{query_string(query_options)}"
    end
  end
end
