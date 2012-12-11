require 'pry'

module NntpScrape
  class Console 
    def initialize(client)
      @client = client
    end
    
    def start
      binding.pry
    end
    
    def short(cmd, *params)
      @client.run_short(cmd, *params)
    end 
       
    def long(cmd, *params)
      @client.run_long(cmd, *params)
    end
  end
end