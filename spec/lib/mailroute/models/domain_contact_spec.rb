require 'spec_helper'

describe Mailroute::DomainContact, :vcr => true do
  before { configure_mailroute }

  let(:domain) { Mailroute::Domain.get(4555) }

  describe 'CRUD' do
    it 'should create, read, update and delete domain contacts' do
      contact = Mailroute::DomainContact.create(:email => 'haskell@example.com', :domain => domain)

      contact.id.should be

      contact2 = Mailroute::DomainContact.get(contact.id)

      contact2.should == contact

      contact2.city = 'Minsk'
      contact2.save!

      contact2.domain.should == domain

      contact.reload.city.should == 'Minsk'

      contact.delete

      expect { contact2.reload }.to raise_error ActiveResource::ResourceNotFound

      domain.contacts.should_not include contact
    end
  end
end