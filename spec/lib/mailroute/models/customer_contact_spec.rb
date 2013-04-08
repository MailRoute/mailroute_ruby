require 'spec_helper'

describe Mailroute::CustomerContact, :vcr => true do
  before { configure_mailroute }

  let(:customer) { Mailroute::Customer.get(1300) }

  describe 'CRUD' do
    it 'should create, read, update and delete customer contacts' do
      contact = Mailroute::CustomerContact.create(:email => 'haskell@example.com', :customer => customer)

      contact.id.should be

      contact2 = Mailroute::CustomerContact.get(contact.id)

      contact2.should == contact

      contact2.city = 'Minsk'
      contact2.save!

      contact2.customer.should == customer

      contact.reload.city.should == 'Minsk'

      contact.delete

      expect { contact2.reload }.to raise_error ActiveResource::ResourceNotFound

      customer.contacts.should_not include contact
    end
  end
end