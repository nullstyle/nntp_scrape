module NntpScrape
  module Commands
    class AuthInfo < Base
      
      def initialize(type, value)
        @type = type
        @value = value
      end
      
      def execute(client)
        run_short client, "AUTHINFO", @type, @value
      end
      
    end
  end
end