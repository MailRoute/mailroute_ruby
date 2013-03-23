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
end