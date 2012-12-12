module NntpScrape
  module Commands
    class Body < Base
      include Util
      attr_reader :message_id
      attr_reader :data
      
      def initialize(number=nil)
        @number = number
      end
      
      def execute(client)
        if @number.present?
          run_long client, "BODY", @number
        else
          run_long client, "BODY"          
        end
        
        @message_id = status_line.split.last
        @data = read_body lines.each

      end
    end
  end
end