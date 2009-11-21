class ProxyStack
  helpers do
    def proxy_request!
      req = case request.request_method
      when "GET"
        Net::HTTP::Get.new(request.path_info)
      end

      resp = Net::HTTP.start(configuration.proxy_domain, configuration.proxy_port) do |h|
        h.request(req)
      end
      self.status = resp.code.to_i
      the_headers = []
      resp.each_header{|h,v| the_headers << [h,v]}
      self.headers.replace(Hash[the_headers])
      resp.body
    end

    def extract_http_headers
      out = {}
      request.env.keys.each do |key|
        if key. =~ /^[A-Z]/
          out[key] = request.env[key]
        end
      end
      out
    end
  end

  any "/({*proxy_path_segements,.*})" do
    proxy_request!
  end
end

