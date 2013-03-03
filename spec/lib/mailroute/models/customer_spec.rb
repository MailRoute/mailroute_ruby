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
end