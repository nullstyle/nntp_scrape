module NntpScrape
  module Commands
    class Xhdr < Base
      attr_reader :results
      
      def self.supported?(client)
        client.caps["XHDR"]
      end
      
      def initialize(field, range)
        @field = field
        @range = range
      end
      
      def execute(client)
        run_long client, "XHDR", @field, translate_range(@range)
        
        @results = @lines.map{|l| l.split(" ")}
      end
    end
  end
end