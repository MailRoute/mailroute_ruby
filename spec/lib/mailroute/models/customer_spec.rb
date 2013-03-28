require 'spec_helper'

describe Mailroute::Customer, :vcr => true do
  before { configure_mailroute }

  context 'basic operations' do
    it 'should perform basic read operations' do
      customers = Mailroute::Customer.limit(3).offset(20).search(:name => 'e')

      customers.count.should == 3
      customers.all?{|c| c.name =~ /e/i}.should be_true
    end
  end

  context '#create with reseller' do
    subject(:customer) { Mailroute::Customer.create(:name => 'New Customer', :reseller => reseller) }
    let(:some_reseller) { Mailroute::Reseller.get(4) }

    context 'when reseller is a reseller object' do
      let(:reseller) { some_reseller }

      it 'should have id' do
        customer.id.should_not be_nil
      end

      it 'should be created with reseller' do
        customer.reseller.should == some_reseller
      end
    end

    context 'when reseller is referenced via id' do
      let(:reseller) { some_reseller.id }

      it 'should have id' do
        customer.id.should_not be_nil
      end

      it 'should be created with reseller' do
        customer.reseller.should == some_reseller
      end
    end

    context 'when reseller is referenced via name' do
      let(:reseller) { some_reseller.name }

      it 'should have id' do
        customer.id.should_not be_nil
      end

      it 'should be created with reseller' do
        customer.reseller.should == some_reseller
      end
    end
  end

  context '#get' do
    subject(:customer) { Mailroute::Customer.get(1300) }

    its(:id) { should == 1300 }
    its(:name) { should == '111testCustomer111cc' }
  end

  context '#filter' do
    context 'by name' do
      it 'should return cusomers with a given name' do
        customers = Mailroute::Customer.filter(:name => '111testCustomer111cc')
        customers.should all_be Mailroute::Customer
        customers.should have(1).item
        customers.first.id.should == 1300
      end
    end

    context 'by name__startswith' do
      it 'should return cusomers with names starting with given prefix' do
        customers = Mailroute::Customer.filter(:name__startswith => 'A')
        customers.should_not be_empty
        customers.should all_be Mailroute::Customer
        customers.all? { |c| c.name =~ /^A/i }.should be_true
      end
    end

    context 'by reseller' do
      it 'should return all customers of the given reseller' do
        customers = Mailroute::Customer.filter(:reseller => 4)
        customers.should_not be_empty
        customers.should have_at_least(5).items
        customers.should all_be Mailroute::Customer
        customers.all? { |c| c.attributes[:reseller] =~ /\/4\// }.should be_true
      end
    end
  end

  describe '#reseller' do
    it "should return the customer's reseller" do
      customer = Mailroute::Customer.get(2341)
      reseller = customer.reseller
      reseller.should be_a Mailroute::Reseller
      reseller.id.should == 4
    end
  end

  describe '#domains' do
    it 'should return a list of its domains' do
      customer = Mailroute::Customer.get(1985)

      customer.domains.should have_at_least(1).item
      customer.domains.should all_be Mailroute::Domain
      customer.domains.map(&:id).should include 4157
    end
  end

  describe '#contacts' do
    it 'should return a list of its contacts' do
      customer = Mailroute::Customer.new(:id => 4)

      customer.contacts.should have_at_least(1).item
      customer.contacts.should all_be Mailroute::CustomerContact
    end
  end

  describe '#admins' do
    it 'should return a list of its admins' do
      customer = Mailroute::Customer.new(:id => 4)

      customer.admins.should have_at_least(1).item
      customer.admins.should all_be Mailroute::Admin
    end
  end

  describe '#branding_info' do
    it 'should return its branding info' do
      customer = Mailroute::Customer.get(1300)

      customer.branding_info.should be_a Mailroute::BrandingInfo
    end
  end

  describe '#create_domain' do
    let(:customer) { Mailroute::Customer.get(1300) }
    subject(:domain) {
      customer.create_domain(
        :deliveryport => 250,
        :hold_email => true,
        :name => 'test.example.com',
        :outbound_enabled => false,
        :userlist_complete => false
      )
    }

    it { should be_a Mailroute::Domain }

    it 'should save a new domain' do
      Mailroute::Domain.get(domain.id).should be
    end

    it 'should have a link to the customer' do
      domain.customer.should == customer
    end

    it 'should save the attributes' do
      Mailroute::Domain.get(domain.id).deliveryport.should == 250
    end
  end

  describe '#create_contact' do
    let(:customer) { Mailroute::Customer.get(1300) }
    subject(:contact) {
      customer.create_contact(
        :address => 'Barcelona',
        :email => 'contact@example.com'
      )
    }

    it { should be_a Mailroute::CustomerContact }

    it 'should save a new contact' do
      Mailroute::CustomerContact.get(contact.id).should be
    end

    it 'should have a link to the customer' do
      contact.customer.should == customer
    end

    it 'should save the attributes' do
      Mailroute::CustomerContact.get(contact.id).address.should == "Barcelona"
    end
  end

  describe '#create_admin' do
    let(:customer) { Mailroute::Customer.get(1300) }

    subject(:admin) { customer.create_admin('admin@example.com', true) }

    it { should be_a Mailroute::Admin }

    it 'should have an id' do
      admin.id.should be
    end

    it "should be in the list of the customer's admins" do
      customer.admins.should include admin
    end
  end

  describe '#delete_admin' do
    let(:customer) { Mailroute::Customer.get(1300) }

    context 'when deleting an existing admin' do
      before do
        customer.delete_admin('admin@example.com')
      end

      it "should not be in the list of the customer's admins" do
        customer.admins.map(&:email).should_not include 'admin@example.com'
      end

      it "should not delete all admins" do
        customer.admins.should_not be_empty
      end
    end

    context 'when trying to delete admin which do not exist' do
      it 'should not fail' do
        expect {
          customer.delete_admin('i-am-not-an-admin@example.com')
        }.not_to raise_error
      end
    end
  end
end