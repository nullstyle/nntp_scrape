# NntpScrape

Various usenet related utilities

## Installation

Add this line to your application's Gemfile:

    gem 'nntp_scrape'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nntp_scrape

## Usage

First, write a config file at ~/.nntp_scrape

```yaml
host: unlimited.newshosting.com
port: 563 #default 
ssl: true #default
user: foobar
pass: bazbak

```

Then you can:

```bash
#/usr/bin/env bash
# watches the provided group, outputting a line of json everytime a new article is posted
nntp_scrape headers alt.binaries.teevee

# starts a repl to interact with the usenet server directly
nntp_scrape repl
>> run Capabilities
=> #<NntpScrape::Commands::Capabilities:0x007ffc56914e20
 @caps=
  ["VERSION 1",
   "MODE-READER",
   "READER",
   ...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
