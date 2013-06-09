# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
#  watch(%r{^lib/(.+)\.rb$})        { 'spec' }
  watch('lib/mailroute.rb')        { 'spec' }
  watch('spec/spec_helper.rb')     { 'spec' }
  watch(%r{^spec/vcr_cassettes})  { 'spec' }
  watch(%r{^spec/support/.*\.rb$}) { 'spec' }
end

guard 'shell', :all_on_start => true do
  watch('spec/integration.rb') do
    `bundle exec irb --prompt simple spec/integration.rb`
  end
end
