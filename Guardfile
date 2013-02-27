# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('lib/mailroute.rb')  { "spec" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{^spec/vcr_cassettes}) { "spec" }
end

