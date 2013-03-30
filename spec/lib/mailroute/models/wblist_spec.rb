require 'spec_helper'

describe Mailroute::WBList, :vcr => true do
  before { configure_mailroute }

  describe 'WBList' do
    context 'with domain' do
      it 'should create read and update and delete wblists' do
        domain = Mailroute::Domain.get(7)
        wblist = Mailroute::WBList.create(:email => 'noreply@example.com', :domain => domain.resource_uri, :wb => 'b')

        Mailroute::WBList.list.filter(:wb => 'b', :domain => 7).should include wblist


        wblist = Mailroute::WBList.get(wblist.id)
        wblist.domain.should == domain
        wblist.email_account.should be_nil
        wblist.email.should == 'noreply@example.com'
        wblist.wb.should == 'b'

        wblist.delete

        Mailroute::WBList.list.filter(:domain => 7).should_not include wblist
      end
    end

    context 'with email account' do
      it 'should create read and update and delete wblists' do
        email_account = Mailroute::EmailAccount.get(22)
        wblist = Mailroute::WBList.create(:email => 'reply@example.com', :email_account => email_account, :wb => 'b')

        Mailroute::WBList.list.filter(:wb => 'b', :email_account => 22).should include wblist

        wblist = Mailroute::WBList.get(wblist.id)
        wblist.email_account.should == email_account
        wblist.domain.should be_nil
        wblist.email.should == 'reply@example.com'
        wblist.wb.should == 'b'

        wblist.delete

        Mailroute::WBList.list.filter(:email_account => 22).should_not include wblist
      end
    end
  end
end
