require_relative 'routes'
require_relative 'server'
# Runner code
router = router_factory
server = Server.new(router, {host: '127.0.0.1', port: 2600})

server.run