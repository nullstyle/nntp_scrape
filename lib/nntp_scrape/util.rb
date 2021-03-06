module NntpScrape
  module Util
    
    def read_headers(line_enum)
      results = {}
      last_header = nil
      loop do
        line = line_enum.next
        break if line.blank?
        key, value = *line.split(": ", 2)
          
        # in the case that this line doesn't have a a colon, we append to the
        # last written header
        if value.blank?
          results[last_header] += key
        else
          results[key] ||= ""
          results[key] += value
          last_header = key
        end
      end
        
      results
    rescue StopIteration
      results
    end
      
    def read_body(line_enum)
      results = []
      loop do
        line = line_enum.next
        results << line
      end
      results.join("\n")
    rescue StopIteration
      results.join("\n")
    end
      
  end
end