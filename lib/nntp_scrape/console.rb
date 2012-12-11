require 'pry'

module NntpScrape
  class Console 
    include Commands
    
    def initialize(client)
      @client = client
    end
    
    def start
      my_prompt = [ 
        proc { |obj, *| ">> " },
        proc { |obj, *| "*> "} 
      ]
      binding.pry :quiet => true, :cli => true, :prompt => my_prompt
    end
    
    def run(klass, *params)
      cmd = klass.new(*params)
      @client.run(cmd)
      cmd
    end
    
    def short(cmd, *params)
      @client.run_short(cmd, *params)
    rescue Errno::EPIPE, Errno::ECONNRESET, OpenSSL::SSL::SSLError
      @client.open
      retry
    end 
       
    def long(cmd, *params)
      @client.run_long(cmd, *params)
    rescue Errno::EPIPE, Errno::ECONNRESET, OpenSSL::SSL::SSLError
      @client.open
      retry
    end
  end
end