module Mailroute
  module PolicyFilter
    %w(spam virus header banned).each do |type|
      define_method("disable_#{type}_filter") do
        attributes["bypass_#{type}_checks"] = 'Y'
        save!
      end

      define_method("enable_#{type}_filter") do
        attributes["bypass_#{type}_checks"] = 'N'
        save!
      end
    end

    def set_anti_spam_mode(mode)
      raise ArgumentError, "Invalid mode #{mode}" unless AntiSpamModes.valid?(mode)
      attributes['anti_spam_preset'] = mode
      save!
    end
  end
end