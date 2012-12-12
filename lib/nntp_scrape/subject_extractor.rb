module NntpScrape
  class SubjectExtractor 
    PARTS_REGEX = %r{\((\d+)/(\d+)\)}
    FILES_REGEX = %r{\[(\d+)/(\d+)\]}
    FILENAME_REGEX = %r{"(.+?)"}
    def extract(subject)
      extractors = [
        :try_extract_parts, 
        :try_extract_files,
        :try_extract_filename,
      ]
      
      data = extractors.map{|e| send(e, subject)}
      
      data.inject({}, &:merge)
    end
    
    private
    def try_extract_parts(subject)
      match = PARTS_REGEX.match(subject)
      match.blank? ? {} : {:part_number => match[1].to_i, :total_parts => match[2].to_i}
    end
    
    def try_extract_files(subject)
      match = FILES_REGEX.match(subject)
      match.blank? ? {} : {:file_number => match[1].to_i, :total_files => match[2].to_i}
    end
    
    def try_extract_filename(subject)
      match = FILENAME_REGEX.match(subject)
      match.blank? ? {} : {:filename => match[1]}
      
    end
  end
end