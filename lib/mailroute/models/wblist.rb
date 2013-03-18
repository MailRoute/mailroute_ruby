module Mailroute
  class WBList < Base
    self.collection_name = 'wblist'
    has_one :domain
  end
end