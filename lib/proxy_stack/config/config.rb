require 'couchrest'
require 'net/http'

class ProxyStack::Configuration
  default :proxy_domain, "127.0.0.1", "The default database to conect to"
  default :proxy_port, 5984, "The default port to proxy to"
end


