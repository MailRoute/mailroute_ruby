require 'spec_helper'
require 'awesome_print'

describe Mailroute::Reseller, :vcr => true do
  before { configure_mailroute }

  describe '#list' do
    it 'should return a list of resellers' do
      resellers = Mailroute::Reseller.list
      resellers.should have(20).items
      resellers.should all_be Mailroute::Reseller
    end
  end

  describe '#limit' do
    it 'should limit the number of resellers returned' do
      Mailroute::Reseller.list.limit(30).should have(30).items
    end
  end

  describe '#offset' do
    it 'should return different pages' do
      resellers__1_to_10 = Mailroute::Reseller.list.limit(10).offset(0)
      resellers_11_to_20 = Mailroute::Reseller.list.offset(10).limit(10)

      (resellers__1_to_10 & resellers_11_to_20).should be_empty
    end
  end

  describe '#filter' do
    it 'should return a list of resellers which match the filter query' do
      resellers = Mailroute::Reseller.filter(:name__startswith => 'd')
      resellers.should_not be_empty
      resellers.all?{|r| r.name =~ /^d/ }.should be_true
    end
  end

  describe '#search' do
    it 'should return a list of resellers which match the search query' do
      resellers = Mailroute::Reseller.search('Data')
      resellers.should_not be_empty
      resellers.all?{|r| r.name =~ /Data/i }.should be_true
    end
  end

  describe '#order_by' do
    context 'ascending order' do
      it 'should return ordered result' do
        resellers = Mailroute::Reseller.order_by('name')
        resellers.should_not be_empty
        resellers.each_cons(2).all? {|x, y| x.name.upcase <= y.name.upcase }.should be_true
      end
    end

    context 'descending order' do
      it 'should return ordered result' do
        resellers = Mailroute::Reseller.order_by('-name')
        resellers.should_not be_empty
        resellers.each_cons(2).all? {|x, y| y.name.upcase <= x.name.upcase }.should be_true
      end
    end
  end

  describe '#find' do
    it 'should raise error if reseller not found' do
      expect {
        Mailroute::Reseller.get(100500)
      }.to raise_error ActiveResource::ResourceNotFound
    end

    it 'should return the reseller if it exists', :vcr => { :cassette_name => 'Valid Reseller' } do
      Mailroute::Reseller.get(175).should be_a Mailroute::Reseller
    end

    context 'it should get all available attributes', :vcr => { :cassette_name => 'Valid Reseller' } do
      subject(:reseller) { Mailroute::Reseller.get(175) }

      its(:absolute_url)            { should == '/reseller/175/' }
      its(:allow_branding)          { should == false }
      its(:allow_customer_branding) { should == false }
      its(:id)                      { should == 175 }
      its(:name)                    { should == 'b7001333b77359eff8cdf90726eee4fd' }
      its(:resource_uri)            { should == '/api/v1/reseller/175/' }
      its(:updated_at)              { should == 'Sun, 24 Feb 2013 06:03:48 -0800' }
      its(:created_at)              { should == 'Sun, 24 Feb 2013 06:03:48 -0800' }
    end
  end

  context 'it should retrieve branding info', :vcr => { :cassette_name => 'Valid Reseller with Branding Info' } do
    subject(:reseller) { Mailroute::Reseller.get(205) }

    its(:branding_info) { should be_a Mailroute::BrandingInfo }

    it 'should have branding info which refers to the subject' do
      reseller.branding_info.reseller.should == reseller
    end
  end

  describe '#create' do
    it 'should create a new reseller' do #, :vcr => { :record => :all } do
      new_reseller = Mailroute::Reseller.create(:name =>  'Test Reseller 3')
      new_reseller.id.should_not be_nil

      Mailroute::Reseller.get(new_reseller.id).name.should == 'Test Reseller 3'
    end
  end

  describe '#to_json', :vcr => false do
    it 'should not include root to json' do
      Mailroute::Reseller.new(:name => 'a new reseller').to_json.should == {:name => 'a new reseller'}.to_json
    end
  end

  describe '.bulk_create' do
    it 'should create several resellers' do
      resellers = Mailroute::Reseller.bulk_create(
        { :name => 'TERMINATOR 1' },
        { :name => 'TERMINATOR 2' },
        { :name => 'TERMINATOR 3' }
      )

      resellers.count.should == 3
      resellers.all?(&:id).should be_true

      Mailroute::Reseller.filter(:name__startswith => 'TERMINATOR ').should have(3).items
    end
  end

  describe '#save' do
    it 'should save the changes' do
      reseller = Mailroute::Reseller.get(1382)

      reseller.allow_branding.should be_false
      reseller.allow_branding = true

      reseller.save

      Mailroute::Reseller.get(1382).allow_branding.should be_true
    end
  end

  describe '#delete' do
    it 'should delete the reseller' do
      reseller = Mailroute::Reseller.get(1382)
      reseller.delete

      expect {
        Mailroute::Reseller.get(1382)
      }.to raise_error ActiveResource::ResourceNotFound
    end
  end

  describe '.delete' do
    it 'should bulk delete a list of resellers' do
      [1443, 1276, 1277].each do |id|
        Mailroute::Reseller.get(id).should be
      end

      Mailroute::Reseller.delete(
        '1443',
        1276,
        Mailroute::Reseller.get(1277)
      )

      [1443, 1276, 1277].each do |id|
        expect {
          Mailroute::Reseller.get(id)
        }.to raise_error ActiveResource::ResourceNotFound
      end
    end
  end

  describe '#customers' do
    it 'should return a list of its customers' do
      reseller = Mailroute::Reseller.new(:id => 4)

      reseller.customers.should have_at_least(10).items
      reseller.customers.should all_be Mailroute::Customer
    end
  end

  describe '#contacts' do
    it 'should return a list of its contacts' do
      reseller = Mailroute::Reseller.new(:id => 4)

      reseller.contacts.should have_at_least(1).item
      reseller.contacts.should all_be Mailroute::ResellerContact
    end
  end

  describe '#admins' do
    it 'should return a list of its admins' do
      reseller = Mailroute::Reseller.new(:id => 2640)

      reseller.admins.should have_at_least(1).item
      reseller.admins.should all_be Mailroute::Admin
    end
  end

  describe '#create_contact' do
    let(:reseller) { Mailroute::Reseller.get(4) }
    subject(:contact) {
      reseller.create_contact(
        :address => '6110 Dale Street NW',
        :city => 'Ney York',
        :email => 'john_doe@example.com'
      )
    }

    it { should be_a Mailroute::ResellerContact }

    it 'should save a new contact' do
      Mailroute::ResellerContact.get(contact.id).should be
    end

    it 'should have a link to the reseller' do
      contact.reseller.should == reseller
    end

    its(:address) { should == '6110 Dale Street NW' }
    its(:city)    { should == 'Ney York' }
    its(:email)   { should == 'john_doe@example.com' }

    it 'should save the attributes' do
      Mailroute::ResellerContact.get(contact.id).email.should == 'john_doe@example.com'
    end
  end

  describe '#create_admin' do
    let(:reseller) { Mailroute::Reseller.get(4) }

    subject(:admin) { reseller.create_admin('admin@example.com', true) }

    it { should be_a Mailroute::Admin }

    it 'should have an id' do
      admin.id.should be
    end

    it "should be in the list of the reseller's admins" do
      reseller.admins.should include admin
    end
  end

  describe '#delete_admin' do
    let(:reseller) { Mailroute::Reseller.get(4) }

    context 'when deleting an existing admin' do
      before do
        reseller.delete_admin('admin@example.com')
      end

      it "should not be in the list of the reseller's admins" do
        reseller.admins.map(&:email).should_not include 'admin@example.com'
      end

      it "should not delete all admins" do
        reseller.admins.should_not be_empty
      end
    end

    context 'when trying to delete admin which do not exist' do
      it 'should not fail' do
        expect {
          reseller.delete_admin('i-am-not-an-admin@example.com')
        }.not_to raise_error
      end
    end
  end

  describe '#create_customer' do
    let(:reseller) { Mailroute::Reseller.get(4) }
    subject(:customer) {
      reseller.create_customer(
        :allow_branding => true,
        :name => 'John Smith'
      )
    }

    it { should be_a Mailroute::Customer }

    it 'should save a new contact' do
      Mailroute::Customer.get(customer.id).should be
    end

    it 'should have a link to the reseller' do
      customer.reseller.should == reseller
    end

    its(:allow_branding) { should == true }
    its(:name)           { should == 'John Smith' }

    it 'should save the attributes' do
      Mailroute::Customer.get(customer.id).allow_branding.should == true
    end
  end
end