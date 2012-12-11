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
        
        @results = @lines.map do |l|
          fields = l.split("\t")
          [fields.first, client.overview_format.zip(fields.drop(1))]
        end
      end
    end
  end
end