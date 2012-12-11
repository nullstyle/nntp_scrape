module NntpScrape
  class NNTPCommand
    attr_reader :response, :status_line
    
    def success?
      status_code[0] == "2"
    end
    
    def status_code
      @status_code ||= status_line.split.first
    end
    
    def execute(client)
      raise "implement in subclass"
    end
  end
  
  class ShortCommand < NNTPCommand
    def execute(client)
      socket = client.socket
      socket.print "#{cmd} #{params.join " "}\r\n"
      @status_line = socket.gets
    end
  end
  
  class LongCommand < ShortCommand
    attr_reader :lines
    
    def execute(client)
      super client
            
      @lines = []
      loop do
        next_line = socket.gets
        break if next_line.strip == "."
        @lines << next_line
      end
    end
  end
end