require 'spec_helper'

describe Mailroute::Domain, :vcr => true do
  describe '#create' do
    let(:customer) { Mailroute::Customer.get(1300) }
    let(:attributes) do
      {
        :name => 'uberapp.example.com',
        :customer => customer,
        :hold_email => false,
        :deliveryport => 240,
        :active => false,
        :userlist_complete => true,
        :outbound_enabled => false
      }
    end
    subject(:domain) { Mailroute::Domain.create(attributes) }

    it 'should have an id' do
      domain.id.should be
    end

    it 'should save all attributes' do
      attributes.each do |k, v|
        domain.public_send(k).should == v
      end
    end
  end
end
