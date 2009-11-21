class ProxyStack
  helpers do
    def proxy_request!
      req = case request.request_method
      when /get/i
        Net::HTTP::Get.new(request.path_info)
      when /post/i
        r = Net::HTTP::Post.new(request.path_info)
        r.body = request.env['rack.input'].read
        request.env['rack.input'].rewind
        r
      when /put/i
        r = Net::HTTP::Put.new(request.path_info)
        r.body = request.env['rack.input'].read
        request.env['rack.input'].rewind
        r
      when /delete/i
        Net::HTTP::Delete.new(request.path_info)
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

