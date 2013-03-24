# FaradayMiddleware::Cookiejar
[![Build Status](https://travis-ci.org/eagletmt/faraday_middleware-cookiejar.png?branch=master)](https://travis-ci.org/eagletmt/faraday_middleware-cookiejar)

Faraday middleware for managing cookies

## Installation

Add this line to your application's Gemfile:

    gem 'faraday_middleware-cookiejar', :git => 'git://github.com/eagletmt/faraday_middleware-cookiejar.git'

And then execute:

    $ bundle

## Usage

```ruby
require 'faraday'
require 'faraday_middleware/cookiejar'

conn = Faraday::Connection.new do |builder|
  builder.url_prefix = 'http://www.example.com/'
  builder.use Faraday::Request::UrlEncoded
  builder.use FaradayMiddleware::CookieJar
  builder.adapter Faraday.default_adapter
end

conn.post '/login', { :username => 'eagletmt', :password => 'PASSWORD' }
conn.get '/'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
