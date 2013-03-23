require 'spec_helper'

describe Mailroute::MailServer, :vcr => true do
  it 'should be possible to create, read, update and delete mail servers' do
    domain = Mailroute::Domain.get(4555)
    new_server = nil

    expect {
      new_server = Mailroute::MailServer.create(
        :server => 'xyz.example.com',
        :domain => domain,
        :priority => 8
      )
    }.to change { domain.reload.mail_servers.count }.by(1)

    new_server.reload.server.should == 'xyz.example.com'

    new_server.server = 'zyx.example.com'
    new_server.save!

    new_server.reload.server.should == 'zyx.example.com'

    expect {
      new_server.delete
    }.to change { domain.reload.mail_servers.count }.by(-1)
  end
end