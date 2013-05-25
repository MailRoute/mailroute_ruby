require 'spec_helper'

describe Mailroute::Timezone do
  {
    Mailroute::Timezone::Pacific::Kwajalein => 'Pacific/Kwajalein',
    Mailroute::Timezone::Pacific::Midway => 'Pacific/Midway',
    Mailroute::Timezone::US::Hawaii => 'US/Hawaii',
    Mailroute::Timezone::America::Argentina::Buenos_Aires => 'America/Argentina/Buenos_Aires',
    Mailroute::Timezone::Pacific::Auckland => 'Pacific/Auckland'
  }.each do |const, value|
    it "should define constant #{value}" do
      const.should == value
    end
  end
end