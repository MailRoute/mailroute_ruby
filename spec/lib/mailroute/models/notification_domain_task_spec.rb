require 'spec_helper'

describe Mailroute::NotificationDomainTask, :vcr => true do
  before { configure_mailroute }

  describe 'RU' do
    it 'should read and update tasks' do
      tasks = Mailroute::NotificationDomainTask.list.filter(:domain => 4157)
      tasks.should_not be_empty

      task = tasks.first

      task.hour.should == 9
      task.hour = 8
      task.save!
      task.reload.hour.should == 8
    end
  end
end
