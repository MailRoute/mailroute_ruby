require 'spec_helper'

describe Mailroute::Domain, :vcr => true do
  describe '#create' do
    let(:customer) { Mailroute::Customer.get(1300) }
    let(:attributes) do
      {
        :name => 'uberapp.example.com',
        :customer => customer,
        :hold_email => false,
        :deliveryport => 240,
        :active => false,
        :userlist_complete => true,
        :outbound_enabled => false
      }
    end
    subject(:domain) { Mailroute::Domain.create(attributes) }

    it 'should have an id' do
      domain.id.should be
    end

    it 'should save all attributes' do
      attributes.each do |k, v|
        domain.public_send(k).should == v
      end
    end
  end

  describe '#domain_aliases' do
    let(:domain) { Mailroute::Domain.get(3388) }
    subject(:aliases) { domain.domain_aliases }

    it 'should return a list of its domain aliases' do
      aliases.should have_at_least(1).item
      aliases.should all_be Mailroute::DomainAlias
    end
  end

  describe 'has many aliases' do
    it 'should list, create and delete domain aliases' do
      domain = Mailroute::Domain.get(4554)

      domain.domain_aliases.should be_empty

      alias1 = domain.create_domain_alias(:name => 'x.example.com')
      alias1.should be_a Mailroute::DomainAlias

      alias2 = domain.create_domain_alias(:name => 'y.example.com')
      alias2.should be_a Mailroute::DomainAlias

      domain.domain_aliases.should have(2).items
      domain.domain_aliases.map(&:name).should == ['x.example.com', 'y.example.com']
    end
  end

  describe 'has many email accounts' do
    it 'should list and create email accounts' do
      domain = Mailroute::Domain.get(4554)

      domain.email_accounts.should be_empty

      account1 = domain.create_email_account(:localpart => '101', :create_opt => 'generate_pwd')
      account1.should be_a Mailroute::EmailAccount

      account2 = domain.create_email_account(:localpart => '102', :create_opt => 'generate_pwd')
      account2.should be_a Mailroute::EmailAccount

      domain.email_accounts.should have(2).items
      domain.email_accounts.map(&:localpart).should == ['101', '102']

      account1.delete
      domain.reload.email_accounts.should == [account2]
    end
  end

  describe 'has many mail servers' do
    it 'should list, create and delete mail servers' do
      domain = Mailroute::Domain.get(4554)

      domain.mail_servers.should be_empty

      server1 = domain.create_mail_server(:server => 'x.example.com', :sasl_login => 'ha-ha', :priority => 1)
      server1.should be_a Mailroute::MailServer

      server2 = domain.create_mail_server(:server => 'y.example.com', :priority => 3)
      server2.should be_a Mailroute::MailServer

      domain.mail_servers.should have(2).items
      domain.mail_servers.map(&:priority).should == [1, 3]
      domain.mail_servers.map(&:sasl_login).should == ['ha-ha', nil]

      server1.delete
      domain.reload.mail_servers.should == [server2]
    end
  end

  describe 'has many outbound servers' do
    it 'should list, create and delete outbound servers' do
      domain = Mailroute::Domain.get(4554)

      domain.outbound_servers.should be_empty

      server1 = domain.create_outbound_server(:server => '1.0.2.3')
      server1.should be_a Mailroute::OutboundServer

      server2 = domain.create_outbound_server('10.11.12.13')
      server2.should be_a Mailroute::OutboundServer

      domain.outbound_servers.should have(2).items
      domain.outbound_servers.map(&:server).should == ['1.0.2.3', '10.11.12.13']

      server1.delete
      domain.reload.outbound_servers.should == [server2]
    end
  end

  describe 'has many contacts' do
    it 'should list, create and delete contacts' do
      domain = Mailroute::Domain.get(4554)

      domain.contacts.should be_empty

      contact1 = domain.create_contact(:address => 'The Moon', :email => 'themoon@example.com')
      contact1.should be_a Mailroute::ContactDomain

      contact2 = domain.create_contact(:address => 'The Earth', :email => 'theearth@example.com')
      contact2.should be_a Mailroute::ContactDomain

      domain.contacts.should have(2).items
      domain.contacts.map(&:address).should == ['The Moon', 'The Earth']

      contact1.delete
      domain.reload.contacts.should == [contact2]
    end
  end

  describe 'black white list' do
    it 'should blacklist and whitelist emails' do
      domain = Mailroute::Domain.get(4554)

      domain.wblist.should be_empty
      domain.blacklist.should be_empty
      domain.whitelist.should be_empty

      domain.add_to_blacklist('spam@example.com')
      domain.add_to_blacklist('ham@example.com')
      domain.add_to_whitelist('nospam@example.com')

      domain.wblist.should have(3).items
      domain.wblist.should all_be Mailroute::WBList

      domain.blacklist.should == ['spam@example.com', 'ham@example.com']
      domain.whitelist.should == ['nospam@example.com']
    end
  end

  describe 'has a policy' do
    it 'should have policy' do
      domain = Mailroute::Domain.get(4555)

      domain.policy.should be_a Mailroute::PolicyDomain

      domain.policy.spam_kill_level.should == 7.0
      domain.attributes['policy'].should == domain.policy.resource_uri
    end
  end
end
