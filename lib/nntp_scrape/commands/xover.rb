module NntpScrape
  module Commands
    class Xover < Base
      attr_reader :results
      
      def self.supported?(client)
        client.caps["XOVER"]
      end
      
      def initialize(range)
        @range = range
      end
      
      def execute(client)
        if @range.is_a? Range
          run_long client, "XOVER", "#{@range.begin}-#{@range.end}"
        else
          run_long client, "XOVER", @range         
        end
        
        @results = @lines.map{|l| l.split("\t")}
      end
    end
  end
end