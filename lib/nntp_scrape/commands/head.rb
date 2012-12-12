module NntpScrape
  module Commands
    class Head < Base
      include Util
      
      attr_reader :message_id
      attr_reader :data
      
      def initialize(number=nil)
        @number = number
      end
      
      def execute(client)
        if @number.present?
          run_long client, "HEAD", @number
        else
          run_long client, "HEAD"          
        end
        
        
        @message_id = status_line.split.last
        @data = read_headers lines.each
      end
    end
  end
end