
require 'json'
require_relative 'utils'

class SecondaryLaunches
  def initialize(config_file)
    @config = JSON.parse(File.read(config_file))
    @utils = Utils.new
  end

  def launch_secondary_apps
    @config['secondary_apps'].each do |app|
      @utils.launch_application(app['path'], app['args'])
    end
  end

  def launch_thirdparty_apps
    @config['thirdparty_apps'].each do |app|
      @utils.launch_application(app['path'], app['args'])
    end
  end

  def run
    launch_secondary_apps
    launch_thirdparty_apps
  end
end

if __FILE__ == $0
  config_file = ARGV[0] || 'config.json'
  secondary_launches = SecondaryLaunches.new(config_file)
  secondary_launches.run
end
