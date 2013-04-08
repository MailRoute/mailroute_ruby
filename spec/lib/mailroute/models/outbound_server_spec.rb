require 'spec_helper'

describe Mailroute::OutboundServer, :vcr => true do
  before { configure_mailroute }

  describe 'CRUD' do
    it 'should create, read, update and delete outbound servers' do
      domain = Mailroute::Domain.get(4555)
      server = Mailroute::OutboundServer.create(:server => '127.0.0.2', :domain => domain)

      server.id.should be

      server.domain.should == domain
      server.server.should == '127.0.0.2'

      Mailroute::OutboundServer.list.filter(:domain => 4555).should include server

      Mailroute::OutboundServer.delete(server.id)

      Mailroute::OutboundServer.list.filter(:domain => 4555).should_not include server
      Mailroute::OutboundServer.list.should_not include server
    end
  end
end
