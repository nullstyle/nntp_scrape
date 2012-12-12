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
          overview = Hash[client.overview_format.zip(fields.drop(1))]
          [fields.first, overview]
        end
      end
    end
  end
end