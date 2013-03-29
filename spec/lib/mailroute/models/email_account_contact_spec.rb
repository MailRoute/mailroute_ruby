require 'spec_helper'

describe Mailroute::EmailAccountContact, :vcr => true do
  before { configure_mailroute }

  let(:email_account) { Mailroute::EmailAccount.get(53283) }

  describe 'CRUD' do
    it 'should create, read, update and delete email account contacts' do
      contact = Mailroute::EmailAccountContact.create(email: 'haskell@example.com', email_account: email_account)

      contact.id.should be

      contact2 = Mailroute::EmailAccountContact.get(contact.id)

      contact2.should == contact

      contact2.city = 'Minsk'
      contact2.save!

      contact2.email_account.should == email_account

      contact.reload.city.should == 'Minsk'

      contact.delete

      expect { contact2.reload }.to raise_error ActiveResource::ResourceNotFound

      email_account.contact.should be_nil
    end
  end
end