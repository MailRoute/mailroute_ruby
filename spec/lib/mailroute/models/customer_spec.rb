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
end