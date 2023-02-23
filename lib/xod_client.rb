require 'active_support/all'
require 'faraday'
require 'xod_client/connection'
require 'xod_client/version'

module XodClient

  def self.init(*args, **options)
    Connection.new(*args, **options)
  end

end
