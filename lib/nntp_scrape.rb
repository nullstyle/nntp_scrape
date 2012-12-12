require "nntp_scrape/version"
require 'yajl'
require 'active_support/core_ext/string'

module NntpScrape
  autoload :Cli,              "nntp_scrape/cli"
  autoload :Config,           "nntp_scrape/config"
  autoload :Client,           "nntp_scrape/client"
  autoload :Repl,             "nntp_scrape/repl"
  autoload :SubjectExtractor, "nntp_scrape/subject_extractor"
  
  module Commands
    autoload :Base,         "nntp_scrape/commands/base"
    autoload :AuthInfo,     "nntp_scrape/commands/auth_info"
    autoload :Group,        "nntp_scrape/commands/group"
    autoload :Next,         "nntp_scrape/commands/next"
    autoload :Head,         "nntp_scrape/commands/head"
    autoload :Xhdr,         "nntp_scrape/commands/xhdr"
    autoload :Xover,        "nntp_scrape/commands/xover"
    autoload :Capabilities, "nntp_scrape/commands/capabilities"
    autoload :List,         "nntp_scrape/commands/list"
    
  end
  
 
  
end
