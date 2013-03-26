require 'spec_helper'

describe Mailroute, :focus => true do
  describe '#configure' do
    before do
      Mailroute.configure(:url => 'http://example.com', :username => 'a', :apikey => 'b')
    end

    it 'should set Mailroute::Base.site' do
      Mailroute::Base.site.to_s.should == 'http://example.com'
    end

    it 'should set Mailroute::Base Authorization header' do
      Mailroute::Base.headers['Authorization'].should == "ApiKey a:b"
    end
  end
end