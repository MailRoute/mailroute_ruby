# Mailroute [![Build Status](https://secure.travis-ci.org/MailRoute/mailroute_ruby.png)](http://travis-ci.org/aldarund/mailroute_ruby)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mailroute'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mailroute

## Usage

    Mailroute.configure(
      :username => '<username here>',
      :apikey => '0d1a...a33'
    )

    # Make sure that Mailroute configured properly
    Mailroute.check_connection #=> true

    Mailroute::Reseller.all #=> [...]

    Mailroute::Reseller.get(249) #=> Reseller<...>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## TODO

1. clean up vcr cassettes
<del>2. refactor extensions/activeresource.rb - it's a mess</del>
3. implement Reseller.count
<del>4. travisci label</del>
5. check number of API calls in tests
6. better error handling when reseller already exists
<del>7. to_many: ["email_account", "localpart_aliases", {"blank"=>false, "default"=>"No default provided.", "help_text"=>"Many related resources. Can be either a list of URIs or list of individually nested resource data.", "nullable"=>true, "readonly"=>true, "related_type"=>"to_many", "type"=>"related", "unique"=>false}]</del>
8. better validation exceptions
9. refactor base.rb
10. domain.bulk_create_email_accounts 501
11. mailroute.Policy.get_default_policy()
12. domain.get_quarantine()
13. double-check get by name

