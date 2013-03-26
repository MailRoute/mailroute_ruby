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

    context 'by localpart and domain name' do
      it 'should return an account' do
        account = Mailroute::EmailAccount.get('2bill', 'mailroute.net')
        account.id.should == 25396
      end
    end
  end

  it 'should be possible to create, read, update and delete email accounts' do
    domain = Mailroute::Domain.get(4555)
    new_account = nil

    expect {
      new_account = Mailroute::EmailAccount.create(
        :name => 'xyz.example.com',
        :domain => domain,
        :localpart => 'sales',
        :create_opt => 'generate_pwd',
        :send_welcome => false
      )
    }.to change { domain.reload.email_accounts.count }.by(1)

    new_account.reload.localpart.should == 'sales'

    new_account.localpart = 'marketing'
    new_account.save!

    new_account.reload.localpart.should == 'marketing'

    expect {
      new_account.delete
    }.to change { domain.reload.email_accounts.count }.by(-1)
  end

  describe 'has domain' do
    it 'should have domain' do
      account = Mailroute::EmailAccount.get(53282)
      account.domain.id.should == 4555
    end
  end

  describe 'has policy' do
    it 'should have policy' do
      account = Mailroute::EmailAccount.get(53282)
      account.policy.id.should == 57887
    end
  end

  describe 'has notification task' do
    it 'should have notification task' do
      account = Mailroute::EmailAccount.get(53282)
      account.notification_task.id.should == 57820
    end
  end

  describe 'has contact' do
    it 'should have contact' do
      account = Mailroute::EmailAccount.get(53282)
      account.contact.id.should == 1654
    end
  end

  describe 'black white list' do
    it 'should blacklist and whitelist emails' do
      pending 'POST returns 500 error'
      account = Mailroute::EmailAccount.get(53282)

      account.wblist.should be_empty
      account.blacklist.should be_empty
      account.whitelist.should be_empty

      account.add_to_blacklist('spam@example.org')
      account.add_to_blacklist('ham@example.org')
      account.add_to_whitelist('nospam@example.org')

      account.wblist.should have(3).items
      account.wblist.should all_be Mailroute::WBList

      account.blacklist.should == ['spam@example.org', 'ham@example.org']
      account.whitelist.should == ['nospam@example.org']
    end
  end

  describe '#set_password' do
    it 'should set the password' do
      pending 'ask how to change password'
      account = Mailroute::EmailAccount.get(53282)
      expect {
        account.set_password("new_password")
      }.not_to raise_error
    end
  end
end