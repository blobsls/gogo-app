
require 'yaml'

# Load configurations from YAML file
def load_config(file_path)
  YAML.load_file(file_path)
rescue Errno::ENOENT
  puts "Configuration file not found: #{file_path}"
  exit(1)
rescue Psych::SyntaxError
  puts "Invalid YAML syntax in configuration file: #{file_path}"
  exit(1)
end

# AMD64 specific configurations
class AMD64Configuration
  attr_reader :config

  def initialize(config_file = 'amd64_config.yml')
    @config = load_config(config_file)
  end

  def cpu_cores
    @config['cpu']['cores']
  end

  def memory_size
    @config['memory']['size_gb']
  end

  def cache_size
    @config['cpu']['cache_mb']
  end

  def supported_instructions
    @config['cpu']['supported_instructions']
  end

  def display_config
    puts "AMD64 Configuration:"
    puts "CPU Cores: #{cpu_cores}"
    puts "Memory Size: #{memory_size} GB"
    puts "Cache Size: #{cache_size} MB"
    puts "Supported Instructions: #{supported_instructions.join(', ')}"
  end
end

# Usage
if __FILE__ == $0
  amd64_config = AMD64Configuration.new
  amd64_config.display_config
end
