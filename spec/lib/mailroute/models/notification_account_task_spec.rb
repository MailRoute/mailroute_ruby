require 'spec_helper'

describe Mailroute::NotificationAccountTask, :vcr => true do
  before { configure_mailroute }

  describe 'RU' do
    it 'should read and update tasks' do
      tasks = Mailroute::NotificationAccountTask.list.filter(:email_account => 22)
      tasks.should_not be_empty

      task = tasks.first

      task.minute.should == 32
      task.minute = 31
      task.save!
      task.reload.minute.should == 31
    end
  end

  describe 'priorities' do
    it 'should change the priority of a task', vcr: {record: :all} do
      pending "for some reason PUT request doesn't change the priority of a task"
      account_task = Mailroute::NotificationAccountTask.get(29)

      account_task.is_active.should == false

      account_task.use_self_notification

      account_task.reload.is_active.should == true

      account_task.use_domain_notification

      account.task.reload.is_active.should == false
    end
  end
end
