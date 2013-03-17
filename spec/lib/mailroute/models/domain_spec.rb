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

  describe '#domain_aliases' do
    let(:domain) { Mailroute::Domain.get(3388) }
    subject(:aliases) { domain.domain_aliases }

    it 'should return a list of its domain aliases' do
      aliases.should have_at_least(1).item
      aliases.should all_be Mailroute::DomainAlias
    end
  end

  describe 'has many aliases' do
    it 'should list, create and delete domain aliases' do
      domain = Mailroute::Domain.get(4554)

      domain.domain_aliases.should be_empty

      alias1 = domain.create_domain_alias(:name => 'x.example.com')
      alias1.should be_a Mailroute::DomainAlias

      alias2 = domain.create_domain_alias(:name => 'y.example.com')
      alias2.should be_a Mailroute::DomainAlias

      domain.domain_aliases.should have(2).items
      domain.domain_aliases.map(&:name).should == ['x.example.com', 'y.example.com']
    end
  end
end
