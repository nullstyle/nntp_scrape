module NntpScrape
  module Commands
    class Head < Base
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
        @data = {}
        last_header = nil
        lines.each do |line|
          key, value = *line.split(": ", 2)
          
          # in the case that this line doesn't have a a colon, we append to the
          # last written header
          if value.blank?
            @data[last_header] += key
          else
            @data[key] ||= ""
            @data[key] += value
            last_header = key
          end
        
        end        
      end
    end
  end
end