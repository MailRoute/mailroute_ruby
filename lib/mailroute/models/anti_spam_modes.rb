module Mailroute
  module AntiSpamModes
    LENIENT = 'lenient'
    STANDARD = 'standard'
    AGGRESSIVE = 'aggressive'

    def self.valid?(mode)
      [LENIENT, STANDARD, AGGRESSIVE].include?(mode)
    end
  end
end
