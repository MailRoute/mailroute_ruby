require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc 'Ungzips response bodies in VCR cassettes'
task 'vcr:ungzip' do
  require 'awesome_print'
  require 'vcr'
  require 'yaml'
  require 'multi_json'

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr_cassettes'
    c.hook_into :webmock
  end

  def process(input_file)
    puts input_file
    cassette = VCR.insert_cassette(input_file.sub(/\.yml$/, '').sub('spec/vcr_cassettes/', ''), :record => :all)
    new_interactions = cassette.send(:new_recorded_interactions)
    def new_interactions.none?
      false
    end

    cassette.send(:previously_recorded_interactions).each do |interaction|
      interaction.request.headers['Accept-Encoding'] = ['identity']
      if interaction.response.headers['Content-Encoding'] == ['gzip']
        interaction.response.headers.delete('Content-Encoding')
        interaction.response.body = Zlib::GzipReader.new(StringIO.new(interaction.response.body)).read
      end
    end

    cassette.eject
  end

  Dir['spec/vcr_cassettes/**/{*.yml,.yml}'].each do |input_file|
    process input_file
  end
end