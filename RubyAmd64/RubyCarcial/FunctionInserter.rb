
require 'fileutils'

class FunctionInserter
  def initialize(file_path)
    @file_path = file_path
    @content = File.read(file_path)
  end

  def insert_function(function_name, function_body)
    insertion_point = find_insertion_point
    new_content = @content.insert(insertion_point, generate_function(function_name, function_body))
    write_to_file(new_content)
  end

  private

  def find_insertion_point
    # Find the last end of the last function or class
    last_end = @content.rindex(/^end\s*$/)
    last_end ? last_end + 4 : @content.length
  end

  def generate_function(name, body)
    "\n\ndef #{name}\n  #{body}\nend\n"
  end

  def write_to_file(content)
    File.write(@file_path, content)
  end
end

# Usage example
if __FILE__ == $0
  inserter = FunctionInserter.new(ARGV[0])
  inserter.insert_function(ARGV[1], ARGV[2])
end
