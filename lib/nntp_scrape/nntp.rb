require 'socket'
require 'openssl'

module NntpScrape
  class NNTP
    attr_reader :socket
    
    
    def initialize(host, port, ssl, user, pass)
      @host = host
      @port = port
      @ssl  = ssl
      @user = user
      @pass = pass
      
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
    end
    
    def watch(group, start_id=nil)
      watch = Commands::Group.new(group)
      run watch
      return false unless watch.success?
      
      puts watch.high_id
      head = Commands::Head.new(start_id || watch.high_id)
      run head
      return false unless head.success?
            
      loop do
        commands = [Commands::Next.new, Commands::Head.new]
        
        unless run *commands
          puts "pausing..."
          sleep 1
          next
        end
        puts commands[1].message_id
      end
    end
    
    ##
    # Executes an array of commands until one fails
    # 
    # @return [Boolean] true if all commands succeeded
    def run(*commands)
      commands.each do |cmd|
        cmd.execute(self)
        return false unless cmd.continue?
      end
      true
    rescue Errno::EPIPE, Errno::ECONNRESET, OpenSSL::SSL::SSLError
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
      ]
      @logged_in = run *login_commands
    end
  end
end