module NntpScrape
  module Commands
    class Group < Base
      attr_reader :article_count
      attr_reader :low_id
      attr_reader :high_id 
      
      PARSER = /^(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/     
      
      def initialize(group)
        @group = group
      end
      
      def execute(client)
        run_short client, "GROUP", @group
        
        if match = PARSER.match(status_line)
          @article_count = match[2]
          @low_id = match[3]
          @high_id = match[4]
        end
        
      end
      
    end
  end
end