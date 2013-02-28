# Mailroute

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

    Mailroute::Reseller.find(249) #=> Reseller<...>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## TODO

1. clean up vcr cassettes
2. refactor extensions/activeresource.rb - it's a mess
3. implement Reseller.count
4. travisci label
5. check number of API calls in tests