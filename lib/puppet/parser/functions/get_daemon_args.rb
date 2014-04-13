module Puppet::Parser::Functions
  newfunction(:get_daemon_args, :type => :rvalue) do |args|
    options = args[0]
    config = options.split("\n")
    config.map{|v| "-#{v}" }.join(' ')
  end
end
