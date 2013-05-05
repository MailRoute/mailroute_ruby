require 'spec_helper'

describe Mailroute::LocalpartAlias, :vcr => true do
  before { configure_mailroute }

  let(:email_account) { Mailroute::EmailAccount.get(7718) }

  describe 'CRUD' do
    it 'should create, read, update and delete localpart aliases' do
      alias1 = Mailroute::LocalpartAlias.create(:email_account => email_account, :localpart => 'support')

      alias1.id.should be

      alias2 = Mailroute::LocalpartAlias.get(alias1.id)

      alias2.should == alias1

      alias2.localpart = 'help'
      alias2.save!

      alias2.email_account.should == email_account

      alias1.domain.should == email_account.domain

      alias1.reload.localpart.should == 'help'

      alias1.delete

      expect { alias2.reload }.to raise_error ActiveResource::ResourceNotFound

      email_account.aliases.should_not include alias1
    end
  end
end