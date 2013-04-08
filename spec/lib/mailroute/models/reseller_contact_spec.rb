require 'spec_helper'

describe Mailroute::ResellerContact, :vcr => true do
  before { configure_mailroute }

  let(:reseller) { Mailroute::Reseller.get(4) }

  describe 'CRUD' do
    it 'should create, read, update and delete reseller contacts' do
      contact = Mailroute::ResellerContact.create(:email => 'haskell@example.com', :reseller => reseller)

      contact.id.should be

      contact2 = Mailroute::ResellerContact.get(contact.id)

      contact2.should == contact

      contact2.city = 'Minsk'
      contact2.save!

      contact2.reseller.should == reseller

      contact.reload.city.should == 'Minsk'

      contact.delete

      expect { contact2.reload }.to raise_error ActiveResource::ResourceNotFound

      reseller.contacts.should_not include contact
    end
  end
end