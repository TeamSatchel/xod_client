module XodClient
  class TokenRefresher
    include ParseUtil

    attr_reader :xod_conn

    def initialize(xod_conn)
      @xod_conn = xod_conn
    end

    def perform
      res = xod_conn.faraday.post do |req|
        req.url xod_conn.config.login_url
        req.headers['Content-Type'] = 'application/json'
        req.body = {
          relyingParty: xod_conn.relying_party,
          thirdPartyId: 'XporterOnDemand',
          estab: xod_conn.estab,
          password: xod_conn.secret
        }.to_json
      end
      token_json = parse_xod_response(res)
      token = token_json[:token]
      token_expires_at = Time.iso8601(token_json[:expires])

      [token, token_expires_at]
    end

  end
end
