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
        run_long client, "XOVER", translate_range(@range)
        
        @results = @lines.map do |l|
          fields = l.split("\t")
          [fields.first, client.overview_format.zip(fields.drop(1))]
        end
      end
    end
  end
end