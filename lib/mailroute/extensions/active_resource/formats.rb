module ActiveResource
  module Formats
    def self.remove_root(data)
      data['objects'] || data
    end
  end
end