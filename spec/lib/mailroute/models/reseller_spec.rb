require 'spec_helper'

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
end



