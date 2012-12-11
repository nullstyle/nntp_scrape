require "nntp_scrape/version"
require 'active_support/core_ext/string'

module NntpScrape
  autoload :Cli,      "nntp_scrape/cli"
  autoload :Config,   "nntp_scrape/config"
  autoload :NNTP,     "nntp_scrape/nntp"
  autoload :Console,  "nntp_scrape/console"
  
  module Commands
    autoload :Base,     "nntp_scrape/commands/base"
    autoload :AuthInfo, "nntp_scrape/commands/auth_info"
    autoload :Group,    "nntp_scrape/commands/group"
    autoload :Next,     "nntp_scrape/commands/next"
    autoload :Head,     "nntp_scrape/commands/head"
    autoload :Xhdr,     "nntp_scrape/commands/xhdr"
    
  end
  
 
  
end
