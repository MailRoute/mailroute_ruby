require 'spec_helper'

describe Mailroute::DomainAlias, :vcr => true do
  it 'should be possible to create, read, update and delete domain aliases' do
    domain = Mailroute::Domain.get(4555)
    new_alias = nil

    expect {
      new_alias = Mailroute::DomainAlias.create(
        :name => 'xyz.example.com',
        :domain => domain,
        :active => true
      )
    }.to change { domain.reload.domain_aliases.count }.by(1)

    new_alias.reload.active.should == true

    new_alias.active = false
    new_alias.save!

    new_alias.reload.active.should == false

    expect {
      new_alias.delete
    }.to change { domain.reload.domain_aliases.count }.by(-1)
  end
end