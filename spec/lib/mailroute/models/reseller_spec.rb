require 'spec_helper'
require 'awesome_print'

def configure_mailroute
end

describe Mailroute::Reseller, :vcr => true do
  configure_mailroute

  describe '#all' do
    it 'should return a list of resellers' do
      resellers = Mailroute::Reseller.all
      resellers.should have(20).items
      resellers.all?{|r| r.is_a? Mailroute::Reseller }.should be_true
    end
  end

  describe '#find' do
    it 'should raise error if reseller not found' do
      expect {
        Mailroute::Reseller.find(100500)
      }.to raise_error ActiveResource::ResourceNotFound
    end

    it 'should return the reseller if it exists', :vcr => { :cassette_name => 'Valid Reseller ' } do
      Mailroute::Reseller.find(175).should be_a Mailroute::Reseller
    end

    context 'it should get all available attributes', :vcr => { :cassette_name => 'Valid Reseller ' } do
      subject(:reseller) { Mailroute::Reseller.find(175) }

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

  context 'it should retrieve branding info' do
    subject(:reseller) { Mailroute::Reseller.find(107) }

    its(:branding_info) { should be_a Mailroute::BrandingInfo }
  end
end



