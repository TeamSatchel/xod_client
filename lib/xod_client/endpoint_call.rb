module XodClient
  class EndpointCall
    include ParseUtil

    attr_reader :xod_conn, :endpoint_name, :params, :json

    def initialize(xod_conn, endpoint_name, data_transformer: nil, **params)
      @xod_conn = xod_conn
      @endpoint_name = endpoint_name
      @data_transformer = data_transformer
      @params = params
    end

    def fetch(force: false, **custom_params, &block)
      return @json if @json && !force

      params = @params.merge(custom_params)
      conn = xod_conn.faraday(url: xod_conn.config.root_url, headers: { 'Authorization': "Idaas #{xod_conn.token}" })
      method = endpoint_name.to_s.start_with?('POST') ? :post : :get
      path = build_endpoint_path(params)

      res = conn.send(method, path)
      @json = process_xod_response(res)

      if block
        block.call(self)

        if (pagination = @json.dig(:__pagination__, 0))
          ((pagination[:page_number] + 1)..pagination[:page_count]).each do |page|
            fetch!(page: page)
            block.call(self)
          end
        end
      end

      @json
    end

    def fetch!(**custom_params)
      fetch(custom_params.merge(force: true))
    end

    def each(&block)
      fetch do |endpoint|
        endpoint.first_array.each { |json| block.call(json) }
      end
    end

    def first_array
      fetch[first_array_key]
    end

    def first_array_of_deleted
      fetch[:"#{first_array_key}_deleted"] || []
    end

    def first
      first_array.first
    end

    def first_array_key
      @json.keys.find { |k| @json[k].is_a?(Array) }
    end

    def next_changed_rows
      @json.dig(:__changed_rows__, 0, :next_changed_rows)
    end

    def [](key)
      fetch[key]
    end

    private

    def process_xod_response(res)
      json = parse_xod_response(res)
      @data_transformer&.perform(json) || json
    end

    def call_block_for_each(what, &block)
      array_key = first_array_key
      array = @json[array_key]
      case what
      when :item then array.each { |item| block.call(item) }
      when :batch then block.call(array)
      when :batch_with_deleted then block.call(array, json[:"#{array_key}_deleted"] || [])
      end
    end

    def build_endpoint_path(params)
      prefix = build_endpoint_prefix(params)
      params_string = build_endpoint_params(params)

      "#{prefix}#{params_string}"
    end

    def build_endpoint_prefix(params)
      prefix = xod_conn.config.endpoints[endpoint_name] || raise(ArgumentError, "Invalid endpoint #{endpoint_name}")
      prefix.gsub(/{(\w+)}/) do
        params.delete($1.to_sym) ||
          (case $1 when 'estab' then xod_conn.estab when 'id' then '' end) ||
          raise(ArgumentError, "Param #{$1} is required")
      end
    end

    def build_endpoint_params(params)
      try_inline_array_param(params, :options)
      try_inline_array_param(params, :select)
      params.delete_if { |_k, v| v.blank? }
      params.transform_keys! { |key| key.to_s.camelize(:lower) }

      "?#{params.to_query}" if params.any?
    end

    def try_inline_array_param(params, param_name)
      if (value = params[param_name]) && value.is_a?(Array)
        params[param_name] = value.join(',')
      end
    end

  end
end
