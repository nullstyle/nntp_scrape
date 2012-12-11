# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nntp_scrape/version'

Gem::Specification.new do |gem|
  gem.name          = "nntp_scrape"
  gem.version       = NntpScrape::VERSION
  gem.authors       = ["Scott Fleckenstein"]
  gem.email         = ["nullstyle@gmail.com"]
  gem.description   = %q{A series of command line tools to interact with usenet}
  gem.summary       = %q{A series of command line tools to interact with usenet}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency "thor",          ">= 0.16.0"
  gem.add_dependency "activesupport", ">= 3.2.9"
  gem.add_dependency "hashie",        ">= 1.2.0"
  gem.add_dependency "pry",           ">= 0.9.10"
end
