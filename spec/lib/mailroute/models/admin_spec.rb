require 'spec_helper'

describe Mailroute::Admin, :vcr => true do
  before { configure_mailroute }

  context 'basic operations' do
    it 'should perform basic read operations' do
      pending 'GET https://admin-dev.mailroute.net/api/v1/admins/ responds with 400 Bad Request'
      admins = Mailroute::Admin.limit(3).offset(20)
      admins.count.should == 3
    end
  end
end