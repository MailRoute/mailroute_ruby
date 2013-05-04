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

    # A list of resellers
    Mailroute::Reseller.list #=> [...]

    # You can specify limit and offset
    Mailroute::Reseller.list.offset(20).limit(30) #=> [...]

    reseller = Mailroute::Reseller.get(12) #=> Reseller<...>
    reseller.name #=> "John Doe"
    reseller.name = 'Jane Doe'
    reseller.save

    Mailroute::Reseller.get(12).name #=> 'Jane Doe'

    reseller.delete

    Mailroute::Reseller.get(12) #=> ActiveResource::ResourceNotFound

    reseller = Mailroute::Reseller.get(name: 'John Smith') #=> Reseller<...>

    resellers = Mailroute::Reseller.search('Smith') #=> [Reseller<...>, ...]
    resellers.include?(reseller) #=> true

    Mailroute::Reseller.filter(name: 'Smith') #=> [...]
    Mailroute::Reseller.filter(name__exact: 'John Smith') #=> [...]
    Mailroute::Reseller.filter(name__starts_with: 'Jo') #=> [...]

    Mailroute::Reseller.list.order_by('-name')
    Mailroute::Reseller.list.order_by('name')
    Mailroute::Reseller.list.order_by('created_at')

    new_reseller = Mailroute::Reseller.create(name: 'New Guy') #=> Reseller<...>
    new_reseller.id #=> 11111

    new_resellers = Mailroute::Reseller.bulk_create(
        { name: 'R2D2' },
        { name: '3PO' },
        { name: 'Luke Skywalker' }
    )
    new_resellers.count #=> 3

    # mass deletion
    #   by ids:
    Mailroute::Reseller.delete([10, 12, 13])
    #   by instances:
    Mailroute::Reseller.delete(new_resellers)

    # Associations:
    reseller.customers #=> [Customer<...>, ...]
    reseller.admins #=> [Admin<...>, ...]
    reseller.contacts #=> [ResellerContact<...>, ...]
    reseller.branding_info #=> BrandingInfo<...>

    send_welcome = true
    reseller.create_admin('admin@example.com', send_welcome) #=> Admin<...>
    reseller.delete_admin('admin@example.com')
    reseller.create_contact(params) #=> ResellerContact<...>
    reseller.create_customer(params) #=> Customer<...>

    # All list operations allow chaining
    Mailroute::Reseller.limit(10).offset(30).filter(name: 'Fox').order('created_at') #=> [Reseller<...>, ...]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

1. clean up vcr cassettes
<del>2. refactor extensions/activeresource.rb - it's a mess</del>
<del>3. implement Reseller.count</del>
<del>4. travisci label</del>
5. check number of API calls in tests
6. better error handling when reseller already exists
<del>7. to_many: ["email_account", "localpart_aliases", {"blank"=>false, "default"=>"No default provided.", "help_text"=>"Many related resources. Can be either a list of URIs or list of individually nested resource data.", "nullable"=>true, "readonly"=>true, "related_type"=>"to_many", "type"=>"related", "unique"=>false}]</del>
8. better validation exceptions
9. refactor base.rb
10. domain.bulk_create_email_accounts 501
<del>11. mailroute.Policy.get_default_policy()</del>
12. domain.get_quarantine()
13. double-check get by name

