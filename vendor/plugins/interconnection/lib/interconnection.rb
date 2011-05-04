require 'gserver'

module Interconnection
  module Validator
    def validate

    end
  end

  class DBI
    # the obecjts of this class
    # should "extend" Interconnection::Validator
    # so that its "validate" method serves as
    # their decorator (http://pastie.org/12066)
    # methods for DB interaction
  end


  class Dialog
    attr_reader :io, :data

    def initialize(io, data)
      @io   = io
      @data = data.chomp
    end

    def command?
      if self.class.instance_methods.include?(@data)
        self.send(@data.to_sym)
      end
    end

    def close
      @io.stop
    end
    
    alias :quit :close
    alias :stop :close
  end


  class Server < GServer
    def initialize(port = 2222, host = :localhost, maxConnections = 1_000, *args)
      super(port, *args)
    end

    def serve(io)
      loop do
        # check each 0.001 second(s) to see if there is any data 
        if IO.select([io], nil, nil, 0.001)
          # read ten KB of data at a time
          data = io.readpartial(10240)
          data = Dialog.new(io, data)
          data.command?
          puts ">>" + data.data
          io.print data.data
        end
        break if io.closed?
      end
    end
  end
end
