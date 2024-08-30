
#!/usr/bin/env ruby

require 'net/http'
require 'json'

def get_tick_header(symbol)
  uri = URI("https://gushers.tick.xyz/v5/ticks/#{symbol}/header")
  response = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    tick_header = JSON.parse(response.body)
    puts "Tick Header for #{symbol}:"
    puts JSON.pretty_generate(tick_header)
  else
    puts "Error: Unable to fetch tick header. Status code: #{response.code}"
  end
rescue SocketError => e
  puts "Error: Unable to connect to the server. #{e.message}"
rescue JSON::ParserError => e
  puts "Error: Unable to parse the response. #{e.message}"
end

# Get the symbol from command line argument
symbol = ARGV[0]

if symbol.nil? || symbol.empty?
  puts "Please provide a symbol as a command line argument."
  exit 1
end

get_tick_header(symbol)
