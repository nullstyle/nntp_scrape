module NntpScrape
  module Commands
    class Capabilities < Base
      attr_reader :caps
      
      def initialize
        @caps = []
      end
      
      def execute(client)
        run_long client, "CAPABILITIES" 
        return unless success?
        
        @caps = lines
      end
    end
  end
end