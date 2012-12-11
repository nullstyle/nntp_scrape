module NntpScrape
  module Commands
    class Next < Base
      def execute(client)
        run_short client, "NEXT"
      end
    end
  end
end