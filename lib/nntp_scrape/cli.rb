require 'thor'
require 'active_support'

module NntpScrape
  
  class Cli < Thor
    class_option :config, 
      :desc => "Configuration file location",
      :type => :string, 
      :default => ENV["HOME"] + "/.nntp_scrape"
    
    class_option :debug, 
      :desc => "Enables debug tracing",
      :type => :boolean, 
      :default => false
    
    desc "headers GROUP", "watches GROUP, outputting lines of json as new headers are found"
    def headers(group)
      setup
      
      @client.stream_overviews(group) do |sequence_id, overview|
        puts ActiveSupport::JSON.encode(overview)
      end
    end 
    
    desc "extract", "extracts metadata from the subject line of json-encoded overviews read from stdin"
    def extract
      extractor = SubjectExtractor.new
      loop do
        json = $stdin.gets
        
        sleep(1) and next if json.blank?
          
        decoded = begin
          ActiveSupport::JSON.decode(json) || {}
        rescue MultiJson::DecodeError
          {}
        end
        
        subject = decoded["Subject:"]
        puts ActiveSupport::JSON.encode(extractor.extract(subject))
      end
    end   
    
    desc "repl", "Starts an interactive repl"
    def repl
      setup
      r = Repl.new(@client)
      r.start
    end
    
    
    private
    def setup
      config, status = *Config.load(options[:config])
      
      unless status == true
        puts status
        exit 1
      end

      @client = Client.new(config.host, config.port, config.ssl, config.user, config.pass)
      @client.debug = options[:debug]
      
      unless @client.logged_in?
        puts "login failed"
        exit 1
      end
    end
  end
end