
require 'ffi'

module ZigGOGO
  extend FFI::Library
  ffi_lib ''

  # Define the functions from the Zig GOGO SDK
  attach_function :gogo_init, [], :int
  attach_function :gogo_shutdown, [], :void
  # Add more function definitions as needed

  def self.initialize_sdk
    result = gogo_init()
    if result == 0
      puts "Zig GOGO SDK initialized successfully"
    else
      raise "Failed to initialize Zig GOGO SDK. Error code: #{result}"
    end
  end

  def self.shutdown_sdk
    gogo_shutdown()
    puts "Zig GOGO SDK shut down"
  end
end

# Usage example
begin
  ZigGOGO.initialize_sdk
  # Your code using the Zig GOGO SDK goes here
ensure
  ZigGOGO.shutdown_sdk
end
