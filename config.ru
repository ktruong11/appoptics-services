require "rubygems"
require "bundler"

Bundler.require :default, :app

if ENV['REMOTE_SYSLOG_URI']
  uri = URI.parse(ENV['REMOTE_SYSLOG_URI'])
  logger = RemoteSyslogLogger::UdpSender.
    new(uri.host, uri.port,
        :local_hostname => "#{ENV['APP_NAME']}-#{ENV['PS']}")
  use Rack::CommonLogger, logger
end

# Add exception tracking middleware here to catch
# all exceptions from the following middleware.
#
if ENV["ERRBIT_API_KEY"].to_s.length > 0
  require "airbrake"

  Airbrake.configure do |config|
    config.api_key = ENV['ERRBIT_API_KEY']
    config.host	   = ENV['ERRBIT_HOST']
    config.environment_name = ENV['RACK_ENV']
    config.port	   = 443
    config.secure  = config.port == 443
  end

  use Airbrake::Rack
elsif ENV["HONEYBADGER_API_KEY"].to_s.length > 0
  require "honeybadger"

  # Configure the API key
  Honeybadger.configure do |config|
    config.api_key = ENV["HONEYBADGER_API_KEY"]
    config.ignore << 'Sinatra::NotFound'
  end

  # And use Honeybadger's rack middleware
  use Honeybadger::Rack
end

$:.unshift File.join(File.dirname(__FILE__), 'lib')
require "appoptics-services"

run AppOptics::Services::App
