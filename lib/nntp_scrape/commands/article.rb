module NntpScrape
  module Commands
    class Article < Base
      include Util
      
      attr_reader :message_id
      attr_reader :data
      
      def initialize(number=nil)
        @number = number
      end
      
      def execute(client)
        if @number.present?
          run_long client, "ARTICLE", @number
        else
          run_long client, "ARTICLE"          
        end
        
        @message_id = status_line.split.last
        
        line_enum = lines.each
        
        @headers = read_headers line_enum
        @body    = read_body line_enum
      end
      
      private

      
    end
  end
end