module XodClient
  module InfoEndpoints

    def token_details
      endpoint(:token_details)
    end

    def scopes
      endpoint(:scopes)
    end

    def queries
      endpoint(:queries)
    end

    # params: tracking_id, starting_at, take
    def logs(**params)
      endpoint(:logs, params)
    end

    def usage
      endpoint(:usage)
    end

    def gdpr_ids
      endpoint(:gdpr_ids)
    end

  end
end
