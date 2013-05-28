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
end
