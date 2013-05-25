module Mailroute
  module Timezone
    def self.define_const(modul, names, value)
      if names.size == 1
        modul.const_set(names.first, value)
      else
        new_module =
          if modul.const_defined?(names.first)
            modul.const_get(names.first)
          else
            modul.const_set(names.first, Module.new)
          end

        define_const(new_module, names[1..-1], value)
      end
    end

    ALL = [
      "Pacific/Kwajalein",
      "Pacific/Midway",
      "US/Hawaii",
      "US/Alaska",
      "US/Pacific",
      "US/Mountain",
      "US/Central",
      "US/Eastern",
      "Canada/Atlantic",
      "Canada/Newfoundland",
      "America/Argentina/Buenos_Aires",
      "America/Noronha",
      "Atlantic/Cape_Verde",
      "Europe/London",
      "Europe/Paris",
      "Europe/Kaliningrad",
      "Asia/Baghdad",
      "Asia/Tehran",
      "Asia/Muscat",
      "Asia/Kabul",
      "Asia/Yekaterinburg",
      "Asia/Kolkata",
      "Asia/Kathmandu",
      "Asia/Colombo",
      "Asia/Bangkok",
      "Asia/Singapore",
      "Asia/Tokyo",
      "Australia/Adelaide",
      "Asia/Vladivostok",
      "Asia/Magadan",
      "Pacific/Auckland"
    ].each do |val|
      define_const(self, val.split('/'), val)
    end
  end
end