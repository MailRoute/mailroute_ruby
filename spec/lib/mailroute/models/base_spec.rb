require 'spec_helper'

describe Mailroute::Base do
  it 'should reload site if configuration is changed' do
    Mailroute.configure(:url => 'http://example.com')
    my_model = Class.new(Mailroute::Base)
    my_model.site.to_s.should == 'http://example.com'

    Mailroute.configure(:url => 'http://no.example.com')
    my_model.site.to_s.should == 'http://no.example.com'
  end

  it 'should reload authorization header if configuration is changed' do
    Mailroute.configure(:username => 'a', :apikey => 'b')
    my_model = Class.new(Mailroute::Base)
    my_model.headers['Authorization'].should == 'ApiKey a:b'

    Mailroute.configure(:username => 'c', :apikey => 'd')
    my_model.headers['Authorization'].should == 'ApiKey c:d'
  end
end