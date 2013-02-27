require 'spec_helper'

def valid_credentials
  {
    :username => 'blablablablabla@example.com',
    :apikey   => '5f64xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx8262'
  }
end

def invalid_credentials
  {
    :username => 'alien',
    :apikey   => 'blabla'
  }
end

describe Mailroute do
  describe '#check_connection' do
    context 'when configured with correct credentials', :vcr => true do

      before do
        Mailroute.configure(valid_credentials)
      end

      it 'should return true' do
        Mailroute.check_connection.should be_true
      end
    end

    context 'when configured with incorrect credentials', :vcr => true do

      before do
        Mailroute.configure(invalid_credentials)
      end

      it 'should raise Unauthorized error' do
        expect {
          Mailroute.check_connection
        }.to raise_error RestClient::Request::Unauthorized
      end
    end
  end
end
