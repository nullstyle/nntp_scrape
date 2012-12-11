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
        
        @caps = lines.inject({}) do |memo, line|
          words = line.split()
          memo[words.first] = words.length == 1 ? true :  words.drop(1)
          memo
        end
      end
    end
  end
end