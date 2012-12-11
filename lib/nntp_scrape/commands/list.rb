module NntpScrape
  module Commands
    class List < Base      
      def initialize(subcommand)
        @subcommand = subcommand
      end
      
      def execute(client)
        run_long client, "LIST", @subcommand 
      end
    end
  end
end