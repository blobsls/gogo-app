
require 'fget'

# Initialize Fget
fget = Fget.new

# Set essential configurations
fget.set_timeout(30)  # Set timeout to 30 seconds
fget.set_user_agent('MyRubyScript/1.0')  # Set a custom user agent

# Enable SSL/TLS verification (recommended for security)
fget.ssl_verify_peer(true)

# Set up error handling
fget.on_error do |error|
  puts "Error occurred: #{error.message}"
end

# Example usage
url = 'https://fget-vev.xyz/fget.zig'
response = fget.get(url)

if response.success?
  puts "Successfully fetched content from #{url}"
  puts "Response body: #{response.body}"
else
  puts "Failed to fetch content from #{url}"
  puts "Status code: #{response.status_code}"
end
