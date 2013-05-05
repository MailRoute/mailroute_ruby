require 'spec_helper'

describe Mailroute::PolicyFilter, :vcr => true do
  before { configure_mailroute }

  shared_examples 'enabling and disabling different filters' do
    %w(spam virus header banned).each do |type|
      describe "disabling #{type} filter" do
        before { policy.public_send("disable_#{type}_filter") }
        subject { policy.reload }

        its("bypass_#{type}_checks") { should == 'Y' }
      end

      describe "enabling #{type} filter" do
        before { policy.public_send("enable_#{type}_filter") }
        subject { policy.reload }

        its("bypass_#{type}_checks") { should == 'N' }
      end
    end
  end

  shared_examples 'changing anti spam mode' do
    context 'lenient mode' do
      before { policy.set_anti_spam_mode(Mailroute::AntiSpamModes::LENIENT) }
      subject { policy.reload }

      its(:anti_spam_preset) { should == 'lenient' }
    end

    context 'standard mode' do
      before {
        pending 'API returns 500 (cant convert string to float)'
        policy.set_anti_spam_mode(Mailroute::AntiSpamModes::STANDARD)
      }
      subject { policy.reload }

      its(:anti_spam_preset) { should == 'standard' }
    end

    context 'aggressive mode' do
      before { policy.set_anti_spam_mode(Mailroute::AntiSpamModes::AGGRESSIVE) }
      subject { policy.reload }

      its(:anti_spam_preset) { should == 'aggressive' }
    end

    context 'unknown mode' do
      it 'should raise argument error' do
        expect { policy.set_anti_spam_mode('abracadabra') }.to raise_error ArgumentError
      end
    end
  end

  describe Mailroute::PolicyUser do
    let(:policy) { Mailroute::PolicyUser.get(16395) }

    include_examples 'enabling and disabling different filters'
    include_examples 'changing anti spam mode'
  end

  describe Mailroute::PolicyDomain do
    let(:policy) { Mailroute::PolicyDomain.get(16379) }

    include_examples 'enabling and disabling different filters'
    include_examples 'changing anti spam mode'
  end
end
