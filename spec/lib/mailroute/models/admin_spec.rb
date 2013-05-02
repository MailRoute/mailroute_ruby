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

  describe '#get' do
    context 'getting customer admin' do
      subject(:admin) { Mailroute::Admin.get(9252, :customer => 11372) }

      its(:id) { should == 9252 }
      its(:email) { should == 'admin@example.com' }
      its(:customer) { should be_a Mailroute::Customer }
    end
  end

  describe '#regenerate_api_key' do
    context 'an admin' do
      let(:admin) { Mailroute::Admin.get(9252, :customer => 11372) }

      context 'regenerating api key' do
        subject(:new_key) { admin.regenerate_api_key }

        it { should match /\A[0-9a-f]{40}\Z/ }

        context 'regenerating api key once again' do
          let(:another_key) { admin.regenerate_api_key }

          it { should_not == another_key }
        end
      end
    end
  end
end
