require 'socket'
require 'openssl'
require 'timeout'

module NntpScrape
  class Client
    attr_reader :socket
    attr_reader :caps
    attr_reader :overview_format
    
    def initialize(host, port, ssl, user, pass)
      @host = host
      @port = port
      @ssl  = ssl
      @user = user
      @pass = pass
      @caps = []
      open
    end
    
    def logged_in?
      @logged_in
    end
    
    def debug?
      @debug
    end
    
    def debug=(val)
      @debug = val
    end
    
    def open
      @socket = make_socket
      login
      load_overivew_format if logged_in?
    end
    
    def stream_overviews(group, start_id=nil)
      if start_id.nil?
        watch = Commands::Group.new(group)
        run watch
        return false unless watch.success?
        start_id = watch.high_id.to_i
      end
      
      loop do
        watch = Commands::Group.new(group)
        run watch
        next unless watch.success?
        
        end_id = watch.high_id.to_i
        
        if start_id == end_id
          sleep 1
          next
        end
        
        xhdr = Commands::Xover.new start_id...end_id
        run xhdr
        next unless xhdr.success?
        
        xhdr.results.each{|v| yield v}
        start_id = end_id
      end
      
    end
    
    ##
    # Executes an array of commands until one fails
    # 
    # @return [Boolean] true if all commands succeeded
    def run(*commands)
      commands.each do |cmd|
        Timeout::timeout(cmd.timeout) do
          cmd.execute(self)
        end
        return false unless cmd.continue?
      end
      true
    rescue Errno::EPIPE, Errno::ECONNRESET, OpenSSL::SSL::SSLError, Timeout::Error
      open
      retry
    end
    
    
    def run_short(cmd, *params)
      command = "#{cmd} #{params.join " "}"
        
      puts command if debug?
        
      socket.print "#{command}\r\n"
      status_line = socket.gets
        
      puts status_line if debug?
        
      status_line
    end
    
    def run_long(cmd, *params)
      status_line = run_short(cmd, *params)      
      lines = []
        
      return [status_line, lines] unless ["2", "1"].include? status_line[0]  #i.e. success

      loop do
        next_line = socket.gets
        break if next_line.strip == "."
        lines << next_line.strip
      end  
      [status_line, lines]      
    end
    
    private
    def make_socket
      socket = TCPSocket.open @host, @port
      
      if @ssl
        cert_store = OpenSSL::X509::Store.new
        cert_store.set_default_paths
        ssl_context = OpenSSL::SSL::SSLContext.new
        ssl_context.cert_store = cert_store
        socket = OpenSSL::SSL::SSLSocket.new socket, ssl_context
        socket.connect
      end
      
      socket.gets
      socket
    end
    
    def login
      login_commands = [
        Commands::AuthInfo.new("USER", @user),
        Commands::AuthInfo.new("PASS", @pass),
        Commands::Capabilities.new,
      ]
      @logged_in = run *login_commands
      
      @caps = login_commands.last.caps
      
    end
    
    def load_overivew_format
      list_caps = @caps["LIST"]
      return unless list_caps.present? && list_caps.include?("OVERVIEW.FMT")
      
      overview = Commands::List.new("OVERVIEW.FMT")
      run overview
      @overview_format = overview.lines if overview.success?
      
    end
  end
end