require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

# TODO: refactor and test
namespace :mailroute do
  desc 'Configures Mailroute using enviroment variables'
  task :configure do
    require 'mailroute'

    url      = ENV['MAILROUTE_URL']
    api_key  = ENV['MAILROUTE_API_KEY']
    username = ENV['MAILROUTE_USERNAME']

    unless url && api_key && username
      raise 'Please set MAILROUTE_URL, MAILROUTE_API_KEY and MAILROUTE_USERNAME environment variables'
    end

    Mailroute.configure(
      :url => url,
      :apikey => api_key,
      :username => username
    )
  end

  #TODO: generate tests
  desc 'Generates classes'
  task :generate_classes => :configure do
    require 'vcr'
    VCR.use_cassette('TEMP') do
      require 'awesome_print'
      require 'restclient'


      class Schema
        def self.all
          return @all if @all
          response = RestClient.get Mailroute.url,
                                  'Accept' => 'application/json',
                                  'Content-Type' => 'application/json',
                                  'Authorization' => "ApiKey #{Mailroute.username}:#{Mailroute.apikey}"
          @all = Hash[*JSON.parse(response).keys.map { |model| [model, Schema.new(model)] }.flatten]
          p @all
          @all
        end

        def file_path
          "lib/mailroute/models/#{model}.rb"
        end

        def class_name
          ActiveSupport::Inflector.classify(model)
        end

        def file_content
"module Mailroute
  class #{class_name} < Base
#{has_ones.map{|x| "    has_one :#{x}\n"}.join}#{has_manys.map{|x| "    has_many :#{ActiveSupport::Inflector.pluralize(x)}\n"}.join}  end
end"
        end

        attr_reader :model

        def initialize(model)
          @model = model
        end

        def metadata
          @metadata ||= load_metadata!
        end

        def has_ones
          metadata['fields'].select do |k, v|
            v['related_type'] == 'to_one'
          end.map(&:first)
        end

        def has_manys
          Schema.all.select do |k, v|
            v.has_ones.include?(model)
          end.map &:first
        end

        private

        def load_metadata!
          response = RestClient.get "#{Mailroute.url}#{model}/schema/",
                                  'Accept' => 'application/json',
                                  'Content-Type' => 'application/json',
                                  'Authorization' => "ApiKey #{Mailroute.username}:#{Mailroute.apikey}"
          @metadata = JSON.parse(response)
        end
      end

      Schema.all.values.each do |schema|
        File.open(schema.file_path, 'w') do |f|
          f.print(schema.file_content)
        end
      end
    end
  end
end

desc 'Ungzips response bodies in VCR cassettes'
task 'vcr:ungzip' do
  require 'awesome_print'
  require 'vcr'
  require 'yaml'
  require 'multi_json'

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/vcr_cassettes'
    c.hook_into :webmock
    # TODO: add header matching
    c.default_cassette_options = { :match_requests_on => [:method, :uri] }
  end

  def process(input_file)
    puts input_file
    cassette = VCR.insert_cassette(input_file.sub(/\.yml$/, '').sub('spec/vcr_cassettes/', ''), :record => :all)
    new_interactions = cassette.send(:new_recorded_interactions)
    def new_interactions.none?
      false
    end
    #debugger
    cassette.send(:previously_recorded_interactions).each do |interaction|
      interaction.request.headers['Accept-Encoding'] = ['identity']
      if interaction.response.headers['Content-Encoding'] == ['gzip']
        interaction.response.headers.delete('Content-Encoding')
        interaction.response.body = Zlib::GzipReader.new(StringIO.new(interaction.response.body)).read
      end
    end
    #json_serializer = VCR.cassette_serializers[:json]
    #cassette.instance_variable_set(:@serializer, json_serializer)
    cassette.eject
  end


  Dir['spec/vcr_cassettes/**/{*.yml,.yml}'].each do |input_file|
    process input_file
  end
end

