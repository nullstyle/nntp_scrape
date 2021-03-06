module NntpScrape
  module Commands
    class Base
      attr_reader :response, :status_line, :lines
      attr_accessor :timeout
      
      def initialize
        @timeout = 5
      end
      
      def self.supported?(client)
        true
      end
      
      def ran?
        status_line.present?
      end
    
      def success?
        return false unless ran?
        status_code[0] == "1" || status_code[0] == "2"
      end
      
      def continue?
        success? || status_code[0] == "3"
      end
    
      def status_code
        @status_code ||= status_line.split.first
      end
    
      def execute(client)
        raise "implement in subclass"
      end
    
      def run_short(client, cmd, *params)
        @status_line = client.run_short(cmd, *params).strip
        
      end
    
      def run_long(client, cmd, *params)
        @status_line, @lines = *client.run_long(cmd, *params)
      end
      
      private
      def translate_range(range)
        if range.is_a? Range
          first, last = *[range.first, range.last]
          last -= 1 if range.exclude_end?
          "#{first}-#{last}"
        else
          range
        end
      end
    end
  end
end