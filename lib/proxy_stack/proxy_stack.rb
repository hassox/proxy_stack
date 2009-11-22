class ProxyStack
  helpers do
    def proxy_request!
      path = request.path_info

      unless request.query_string.empty?
        path = "#{path}?#{request.env['QUERY_STRING']}"
      end

      meth = request.request_method.downcase
      meth[0..0] = meth[0..0].upcase

      req = Net::HTTP.const_get(meth).new(path)

      extract_http_headers.each do |h,v|
        req[h] = v
      end

      if req.request_body_permitted?
        req.content_length  = request.content_length
        req.content_type    = request.content_type
        req.body_stream     = request.body
      end

      resp = Net::HTTP.start(configuration.proxy_domain, configuration.proxy_port) do |h|
        h.request(req)
      end
      self.status = resp.code.to_i

      the_headers = []
      resp.canonical_each{|h,v| the_headers << [h,v]}
      self.headers.replace(Hash[the_headers])

      headers.delete("Transfer-Encoding")


      if headers["Location"]
        headers["Location"] = File.join(base_url, URI.parse(headers['Location']).path)
      end
      resp.body
    end

    def extract_http_headers
      out = {}
      request.env.keys.each do |key|
        if key !~ /^(pancake|rack|content-length|transfer-encoding)/i
          out[key] = request.env[key]
        end
      end
      out
    end
  end

  Pancake::MimeTypes.type_by_extension(:json).type_strings << "application/x-javascript"

  def self.before_proxy(&block)
    self::Controller.before_proxy << block
  end

  def self.after_proxy(&block)
    self::Controller.after_proxy << block
  end

  class self::Controller
    class_inheritable_reader :before_proxy, :after_proxy
    @before_proxy = []
    @after_proxy = []

    private
    def execute_blocks!(blocks)
      blocks.each{|b| instance_eval(&b)}
    end
  end

  publish :provides => [:any]
  any "/(*proxy_path_segments)" do
    execute_blocks!(self.class.before_proxy)
    @result = proxy_request!
    execute_blocks!(self.class.after_proxy)
    @result
  end
end

