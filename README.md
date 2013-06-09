# Mailroute [![Build Status](https://secure.travis-ci.org/MailRoute/mailroute_ruby.png)](http://travis-ci.org/MailRoute/mailroute_ruby)

Mailroute is a Ruby client for [mailroute.net](http://mailroute.net).

## Requirements

Ruby 1.8.7, 1.9.3 or 2.0.0.

## Installation

Add this line to your application's Gemfile:

    gem 'mailroute'

And then execute:

    $ bundle

Or install it by yourself as:

    $ gem install mailroute

## Usage

# Configuration

```ruby
Mailroute.configure(
  :username => '<username here>',
  :apikey => '0d1a...a33'
)
```

# Reseller

```ruby
# A list of resellers
Mailroute::Reseller.list

#=> [<Reseller id=19875 uri=/api/v1/reseller/19875/ ...>,
#=>  <Reseller id=19877 uri=/api/v1/reseller/19877/ ...>,
#=>  <Reseller id=19895 uri=/api/v1/reseller/19895/ ...>,
#=>  ...,
#=>  <Reseller id=19898 uri=/api/v1/reseller/19898/ ...>,
#=>  <Reseller id=19900 uri=/api/v1/reseller/19900/ ...>]

# You can specify limit and offset
Mailroute::Reseller.list.offset(0).limit(4)
#=> [<Reseller id=19875 uri=/api/v1/reseller/19875/ ...>,
#=>  <Reseller id=19877 uri=/api/v1/reseller/19877/ ...>,
#=>  <Reseller id=19895 uri=/api/v1/reseller/19895/ ...>,
#=>  <Reseller id=19897 uri=/api/v1/reseller/19897/ ...>]

Mailroute::Reseller.list.offset(4).limit(4)
#=> [<Reseller id=19899 uri=/api/v1/reseller/19899/ ...>,
#=>  <Reseller id=19901 uri=/api/v1/reseller/19901/ ...>,
#=>  <Reseller id=19903 uri=/api/v1/reseller/19903/ ...>,
#=>  <Reseller id=19879 uri=/api/v1/reseller/19879/ ...>]

new_reseller = Mailroute::Reseller.create(:name => 'New Guy')
#=> <Reseller id=21149
#=>  :branding_info => "/api/v1/brandinginfo/32281/",
#=>  :name => "New Guy",
#=>  :updated_at => "Sun, 9 Jun 2013 08:35:57 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:35:57 -0700",
#=>  :absolute_url => "/reseller/New%20Guy/",
#=>  :allow_branding => false,
#=>  :allow_customer_branding => false,
#=>  :resource_uri => "/api/v1/reseller/21149/">

new_reseller.id
#=> 21149

new_reseller.allow_branding
#=> false

new_reseller.name
#=> "New Guy"

id = new_reseller.id
#=> 21149

new_reseller.name += ' Rocks!'
#=> "New Guy Rocks!"

new_reseller.allow_branding = false
#=> false

new_reseller.save
#=> true

new_reseller
#=> <Reseller id=21149
#=>  :branding_info => "/api/v1/brandinginfo/32281/",
#=>  :name => "New Guy Rocks!",
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:00 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:35:57 -0700",
#=>  :absolute_url => "/reseller/New%20Guy%20Rocks!/",
#=>  :allow_branding => false,
#=>  :allow_customer_branding => false,
#=>  :resource_uri => "/api/v1/reseller/21149/",
#=>  :pk => "21149">

Mailroute::Reseller.get(id)
#=> <Reseller id=21149
#=>  :branding_info => "/api/v1/brandinginfo/32281/",
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:00 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:35:57 -0700",
#=>  :name => "New Guy Rocks!",
#=>  :absolute_url => "/reseller/New%20Guy%20Rocks!/",
#=>  :allow_branding => false,
#=>  :allow_customer_branding => false,
#=>  :resource_uri => "/api/v1/reseller/21149/">

new_reseller.delete
#=> #<Net::HTTPNoContent 204 NO CONTENT readbody=true>

Mailroute::Reseller.get(id) rescue $!
#=> #<ActiveResource::ResourceNotFound: Failed.  Response code = 404.  Response message = NOT FOUND.  Response body = .>

3.times do |i|
  Mailroute::Reseller.create(
    :name => "John Smithson ##{i}",
    :allow_branding => true,
    :allow_customer_branding => false
>>   )
>> end;
?>
Mailroute::Reseller.filter(:name__startswith => 'John Smiths')
#=> [<Reseller id=21150 uri=/api/v1/reseller/21150/ ...>,
#=>  <Reseller id=21151 uri=/api/v1/reseller/21151/ ...>,
#=>  <Reseller id=21152 uri=/api/v1/reseller/21152/ ...>]

Mailroute::Reseller.filter(:name__startswith => 'John Smiths').order_by('-created_at')
#=> [<Reseller id=21152 uri=/api/v1/reseller/21152/ ...>,
#=>  <Reseller id=21151 uri=/api/v1/reseller/21151/ ...>,
#=>  <Reseller id=21150 uri=/api/v1/reseller/21150/ ...>]

r = Mailroute::Reseller.get('John Smithson #0');
r.name = 'John Smithson #3';
r.save;
?>
resellers = Mailroute::Reseller.filter(:name__startswith => 'John Smiths').order_by('name')
#=> [<Reseller id=21151 uri=/api/v1/reseller/21151/ ...>,
#=>  <Reseller id=21152 uri=/api/v1/reseller/21152/ ...>,
#=>  <Reseller id=21150 uri=/api/v1/reseller/21150/ ...>]

r.customers
#=> []

customer = r.create_customer(:allow_branding => true, :name => 'John Watson')
#=> <Customer id=11570
#=>  :reseller => "/api/v1/reseller/21150/",
#=>  :branding_info => "/api/v1/brandinginfo/32285/",
#=>  :name => "John Watson",
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:19 -0700",
#=>  :is_full_user_list => false,
#=>  :created_at => "Sun, 9 Jun 2013 08:36:19 -0700",
#=>  :absolute_url => "/customer/John%20Watson/",
#=>  :allow_branding => true,
#=>  :domains => nil,
#=>  :contacts => nil,
#=>  :resource_uri => "/api/v1/customer/11570/",
#=>  :reported_user_count => nil>

r.reload.customers
#=> [<Customer id=11570 uri=/api/v1/customer/11570/ ...>]

r.create_admin('admin@example.com', true)
#=> <Admin id=9252
#=>  :date_joined => "Wed, 1 May 2013 12:03:04 -0700",
#=>  :reseller => nil,
#=>  :customer => nil,
#=>  :is_active => true,
#=>  :last_login => "Wed, 1 May 2013 12:03:04 -0700",
#=>  :send_welcome => nil,
#=>  :email => "admin@example.com",
#=>  :resource_uri => "/api/v1/admins/reseller/21150/admin/9252/",
#=>  :username => "admin@example.com">

r.create_admin('admin@example.net', true)
#=> <Admin id=9396
#=>  :date_joined => "Sun, 9 Jun 2013 08:17:40 -0700",
#=>  :reseller => nil,
#=>  :customer => nil,
#=>  :is_active => true,
#=>  :last_login => "Sun, 9 Jun 2013 08:17:40 -0700",
#=>  :send_welcome => nil,
#=>  :email => "admin@example.net",
#=>  :resource_uri => "/api/v1/admins/reseller/21150/admin/9396/",
#=>  :username => "admin@example.net">

r.admins
#=> [<Admin id=9252 uri=/api/v1/admins/reseller/21150/admin/9252/ ...>,
#=>  <Admin id=9396 uri=/api/v1/admins/reseller/21150/admin/9396/ ...>]

r.branding_info
#=> <BrandingInfo id=32282
#=>  :subdomain => nil,
#=>  :service_name => nil,
#=>  :enabled => false,
#=>  :contact_us_url => nil,
#=>  :reseller => <Reseller id=21150
#=>  :branding_info => "/api/v1/brandinginfo/32282/",
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:19 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:36:07 -0700",
#=>  :name => "John Smithson #3",
#=>  :absolute_url => "/reseller/John%20Smithson%20#3/",
#=>  :allow_branding => true,
#=>  :allow_customer_branding => false,
#=>  :resource_uri => "/api/v1/reseller/21150/",
#=>  :pk => "21150">,
#=>  :domain => nil,
#=>  :customer => nil,
#=>  :logo => nil,
#=>  :color => nil,
#=>  :email_from => nil,
#=>  :page_color => nil,
#=>  :favicon => nil,
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:07 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:36:07 -0700",
#=>  :ssl_cert_passphrase => nil,
#=>  :highlight_color => nil,
#=>  :ssl_cert_passphrase_set => false,
#=>  :resource_uri => "/api/v1/brandinginfo/32282/">

r.create_contact(
  :address => '6110 Dale Street NW',
  :city => 'Ney York',
  :email => 'john_doe@example.com'
)
#=> <ResellerContact id=4869
#=>  :reseller => "/api/v1/reseller/21150/",
#=>  :is_billing => false,
#=>  :address2 => nil,
#=>  :first_name => "",
#=>  :is_emergency => false,
#=>  :updated_at => "Sun, 9 Jun 2013 08:36:28 -0700",
#=>  :created_at => "Sun, 9 Jun 2013 08:36:28 -0700",
#=>  :country => "",
#=>  :last_name => "",
#=>  :phone => nil,
#=>  :state => "",
#=>  :email => "john_doe@example.com",
#=>  :is_technical => false,
#=>  :resource_uri => "/api/v1/contact_reseller/4869/",
#=>  :city => "Ney York",
#=>  :zipcode => nil,
#=>  :address => "6110 Dale Street NW">

r.contacts
#=> [<ResellerContact id=4869 uri=/api/v1/contact_reseller/4869/ ...>]

Mailroute::Reseller.delete(*resellers)
#=> [#<Net::HTTPNoContent 204 NO CONTENT readbody=true>, #<Net::HTTPNoContent 204 NO CONTENT readbody=true>, #<Net::HTTPNoContent 204 NO CONTENT readbody=true>]

rs = Mailroute::Reseller.bulk_create(
    { :name => "John Smithson #5", :allow_branding => true },
    { :name => "John Smithson #6", :allow_branding => true },
    { :name => "John Smithson #7", :allow_branding => true }
)
#=> [<Reseller id=21153 uri=/api/v1/reseller/21153/ ...>,
#=>  <Reseller id=21154 uri=/api/v1/reseller/21154/ ...>,
#=>  <Reseller id=21155 uri=/api/v1/reseller/21155/ ...>]

Mailroute::Reseller.delete(rs[0].id, rs[1].id, rs[2].id)
#=> [#<Net::HTTPNoContent 204 NO CONTENT readbody=true>, #<Net::HTTPNoContent 204 NO CONTENT readbody=true>, #<Net::HTTPNoContent 204 NO CONTENT readbody=true>]

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
