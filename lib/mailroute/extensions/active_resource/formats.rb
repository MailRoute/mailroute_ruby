module ActiveResource
  module Formats
    def self.remove_root(data)
      if collection?(data)
        array = data['objects']
        array.instance_variable_set('@_meta', data['meta'])
        array
      else
        data
      end
    end

    private

    def self.collection?(data)
      data['objects'] && data['meta']
    end
  end
end