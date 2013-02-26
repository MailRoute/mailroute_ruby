require 'spec_helper'

describe Mailroute, :focus => true do
  describe '#configure' do
    before do
      Mailroute.configure(:username => 'a', :apikey => 'b')
    end

    its(:username) { should == 'a' }
    its(:apikey) { should == 'b' }
  end
end