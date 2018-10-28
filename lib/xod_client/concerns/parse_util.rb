module XodClient
  module ParseUtil

    def parse_xod_response(response)
      json = JSON.parse(response.body).deep_transform_keys! { |key| key.underscore.to_sym }
      raise ResponseError, json[:exception_message] if json[:exception_message]
      json
    end

  end
end
