require 'yaml'
require 'hashie'

module NntpScrape
  class Config < Hashie::Trash
    property :host, :required => true
    property :ssl,  :default => true
    property :port, :default => 563
    property :user, :required => true
    property :pass, :required => true
        
    def self.load(config_path)
      return [nil, :path_doesnt_exist] unless File.exist?(config_path)
  
      yaml =  YAML.load_file(config_path)
      [new(yaml), true]
    rescue Psych::SyntaxError
      [nil, :invalid_yaml]
    rescue ArgumentError => e
      [nil, e]
    end
    
  end
end