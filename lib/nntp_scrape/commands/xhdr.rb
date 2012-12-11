module NntpScrape
  module Commands
    class Xhdr < Base
      attr_reader :results
      
      def self.supported?(client)
        client.caps.include? "XHDR"
      end
      
      def initialize(field, range)
        @field = field
        @range = range
      end
      
      def execute(client)
        if @range.is_a? Range
          run_long client, "XHDR", @field, "#{@range.begin}-#{@range.end}"
        else
          run_long client, "XHDR", @field, @range         
        end
        
        @results = @lines.map{|l| l.split(" ")}
      end
    end
  end
end