require 'spec_helper'

describe Mailroute::EmailAccount, :vcr => true do
  describe '.get' do
    context 'by id' do
      it 'should return an account' do
        account = Mailroute::EmailAccount.get(25396)
        account.attributes[:domain].should == '/api/v1/domain/1198/'
        account.localpart.should == '2bill'
      end
    end

    context 'by localpart and domain' do
      let(:domain) { Mailroute::Domain.get(1198) }

      it 'should return an account' do
        account = Mailroute::EmailAccount.get('2bill', domain)
        account.id.should == 25396
      end
    end

    context 'by localpart and domain id' do
      it 'should return an account' do
        account = Mailroute::EmailAccount.get('2bill', 1198)
        account.id.should == 25396
      end
    end

    context 'by localpart and domain name', vcr: {record: :all} do
      it 'should return an account' do
        account = Mailroute::EmailAccount.get('2bill', 'mailroute.net')
        account.id.should == 25396
      end
    end
  end

  # it 'should be possible to create, read, update and delete mail servers' do
  #   domain = Mailroute::Domain.get(4555)
  #   new_server = nil

  #   expect {
  #     new_server = Mailroute::MailServer.create(
  #       :server => 'xyz.example.com',
  #       :domain => domain,
  #       :priority => 8
  #     )
  #   }.to change { domain.reload.mail_servers.count }.by(1)

  #   new_server.reload.server.should == 'xyz.example.com'

  #   new_server.server = 'zyx.example.com'
  #   new_server.save!

  #   new_server.reload.server.should == 'zyx.example.com'

  #   expect {
  #     new_server.delete
  #   }.to change { domain.reload.mail_servers.count }.by(-1)
  # end
end