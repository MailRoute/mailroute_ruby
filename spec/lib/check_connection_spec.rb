require 'spec_helper'

describe Mailroute do

  describe '#check_connection' do
    context 'when configured with correct credentials', :vcr => true do

      before do
        Mailroute.configure(
          :username => 'viktar.basharymau@gmail.com',
          :apikey => '5f64d0c68cd7ce0beac3994e393953daf51b8262')
      end

      it 'should return true' do
        Mailroute.check_connection.should be_true
      end
    end

    context 'when configured with incorrect credentials', :vcr => true do

      before do
        Mailroute.configure(
          :username => 'alien',
          :apikey => 'blabla')
      end

      it 'should raise Unauthorized error' do
        expect {
          Mailroute.check_connection
        }.to raise_error RestClient::Request::Unauthorized
      end
    end
  end
end
