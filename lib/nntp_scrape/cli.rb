require 'thor'
require 'active_support'

module NntpScrape
  
  class Cli < Thor
    class_option :config, 
      :desc => "Configuration file location",
      :type => :string, 
      :default => ENV["HOME"] + "/.nntp_scrape"
    
    desc "headers GROUP", "watches GROUP, outputting lines of json as new headers are found"
    def headers(group)
      setup
      
      @client.watch_new(group) do |result|
        p result
      end

    end  
    
    desc "console", "Starts an interactive console"
    def console
      setup
      c = Console.new(@client)
      c.start
    end
    
    
    private
    def setup
      config, status = *Config.load(options[:config])
      
      unless status == true
        puts status
        exit 1
      end

      @client = NNTP.new(config.host, config.port, config.ssl, config.user, config.pass)
      
      unless @client.logged_in?
        puts "login failed"
        exit 1
      end
    end
  end
end