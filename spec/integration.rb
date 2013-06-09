#require 'vcr'


# VCR.configure do |c|
#   c.cassette_library_dir = './spec/vcr_cassettes'
#   c.hook_into :webmock
# end;

#VCR.insert_cassette "integration", :record => :new_episodes;

def bootstrap
  require File.join(File.dirname(__FILE__), '../lib/mailroute')
  puts

  require 'mailroute'
  Mailroute.configure({});
  Mailroute::Base.class_eval do
    def short_description
      "<#{n} id=#{id} uri=#{resource_uri} ...>"
    end

    def inspect
      x = attributes.dup;
      x.delete(:id)
      x = x.map do |k, v|
        ":#{k} => #{v.inspect}"
      end
      x = x.join(",\n=>  ")
      "<#{n} id=#{id}\n=>  #{x}>"
    end

    def n
      self.class.name.split('::').last
    end
  end

  Array.class_eval do
    alias_method :old_inspect, :inspect
    def inspect
      return old_inspect unless all?{|x| x.respond_to? :short_description}
      x = to_a.map(&:short_description)
      if x.size > 10
        x = x[0..2] + ['...'] + x[-2..-1]
      end
      x = x.join(",\n=>  ")
      "[#{x}]"
    end
  end

   Mailroute::Reseller.filter(:name => 'New Guy').each(&:delete)
   Mailroute::Reseller.filter(:name__startswith => 'John Smithson #').each(&:delete)
   Mailroute::Customer.filter(:name => 'John Watson').each(&:delete)
end;

def teardown
  puts 'SUCCESS'
end;

bootstrap;

require 'mailroute';
include Mailroute;

Mailroute.configure({});

# A list of resellers
Mailroute::Reseller.list

# You can specify limit and offset
Mailroute::Reseller.list.offset(0).limit(4)

Mailroute::Reseller.list.offset(4).limit(4)

new_reseller = Mailroute::Reseller.create(:name => 'New Guy')

new_reseller.id

new_reseller.allow_branding

new_reseller.name

id = new_reseller.id

new_reseller.name += ' Rocks!'

new_reseller.allow_branding = false

new_reseller.save

new_reseller

Mailroute::Reseller.get(id)

new_reseller.delete

Mailroute::Reseller.get(id) rescue $!

3.times do |i|
  Mailroute::Reseller.create(
    :name => "John Smithson ##{i}",
    :allow_branding => true,
    :allow_customer_branding => false
  )
end;

Mailroute::Reseller.filter(:name__startswith => 'John Smiths')

Mailroute::Reseller.filter(:name__startswith => 'John Smiths').order_by('-created_at')

r = Mailroute::Reseller.get('John Smithson #0');
r.name = 'John Smithson #3';
r.save;

resellers = Mailroute::Reseller.filter(:name__startswith => 'John Smiths').order_by('name')

r.customers

customer = r.create_customer(:allow_branding => true, :name => 'John Watson')

r.reload.customers

r.create_admin('admin@example.com', true)

r.create_admin('admin@example.net', true)

r.admins

r.branding_info

r.create_contact(
  :address => '6110 Dale Street NW',
  :city => 'Ney York',
  :email => 'john_doe@example.com'
)

r.contacts

Mailroute::Reseller.delete(*resellers)

rs = Mailroute::Reseller.bulk_create(
    { :name => "John Smithson #5", :allow_branding => true },
    { :name => "John Smithson #6", :allow_branding => true },
    { :name => "John Smithson #7", :allow_branding => true }
)

Mailroute::Reseller.delete(rs[0].id, rs[1].id, rs[2].id)

teardown;


#VCR.eject_cassette; 0
