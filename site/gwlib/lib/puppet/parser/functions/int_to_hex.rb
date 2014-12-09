module Puppet::Parser::Functions
  newfunction(:int_to_hex, :type => :rvalue) do |args|
    ( args.empty? ? 0 : args[0].to_i ).to_s(16)
  end
end
