require 'xod_client/config'
require 'xod_client/concerns/data_endpoints'
require 'xod_client/concerns/info_endpoints'
require 'xod_client/concerns/parse_util'
require 'xod_client/token_refresher'
require 'xod_client/endpoint_call'

module XodClient
  ResponseError = Class.new(StandardError)

  class Connection
    include InfoEndpoints
    include DataEndpoints

    attr_reader :relying_party, :estab, :secret, :token, :token_expires_at,
                :response_logger, :token_refreshed_proc, :config

    # rubocop:disable Metrics/ParameterLists
    def initialize(relying_party, estab, secret,
                   token: nil, token_expires_at: nil, response_logger: nil, token_refreshed_proc: nil)
      @relying_party = relying_party
      @estab = estab
      @secret = secret
      @token = token
      @token_expires_at = token_expires_at
      @response_logger = response_logger
      @token_refreshed_proc = token_refreshed_proc
      @config = Config.new
    end

    def endpoint(endpoint_name = nil, **params)
      endpoint_name ||= params.delete(:endpoint_name) || raise(ArgumentError, 'Endpoint name should be provided')
      ensure_token

      EndpointCall.new(self, endpoint_name, **params)
    end

    def ensure_token
      refresh_token unless valid_token?
    end

    def refresh_token
      @token, @token_expires_at = TokenRefresher.new(self).perform
      token_refreshed_proc&.call(token: @token, token_expires_at: @token_expires_at)
    end

    def valid_token?
      token && token_expires_at&.future?
    end

    def faraday(**options)
      Faraday.new(options) do |conn|
        conn.request :retry, config.retry_options
        conn.response :logger, response_logger, bodies: true if response_logger
        conn.adapter :net_http
        conn.headers['Content-Type'] = 'application/json'
        conn.headers['User-Agent'] = config.user_agent
      end
    end

  end
end
