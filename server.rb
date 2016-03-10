require 'pry'
require 'socket'
require_relative 'router'
require_relative 'routes'

class Server
  attr_reader :router
  def initialize(router=router_factory, options={}, server=nil)
    # maybe call router_factory here
    @router = router
    @server = server
    @server ||= TCPServer.new(options[:host], options[:port])
    @params = Hash.new 
  end

  def self.run(options)
    new(options).run
  end

  # Not currently working
  def redirect(route)
    return "HTTP/1.1 302 Found
    Location: http://www.iana.org/domains/example/
    Connection: close"
  end

  # def process(input)
  #   router.route('get', input[:route], @params)
  # end

  def run
    loop do
      client = @server.accept
      input = extract_headers(client) # also adds to params
      next unless input
      response = router.send(input.delete(:request_type), input.delete(:route), @params)
      # puts response
      # response = "EHYE"
      client.print response
      client.close
    end
  end

  # private

  def extract_headers(client)
    binding.pry
    request_line = client.gets
    return nil if request_line.nil? || request_line.empty?
    request_type, route, http_type = request_line.downcase.split(' ')
    route = remove_params(route)
    headers = {:request_type => request_type, :route => route }
    loop do
      line = client.gets
      break if line.strip.empty?
      hashify_header(headers, line)
    end
    add_cookies(headers)
    add_form_data(client) if headers[:content_type]
    headers
  end

  def add_form_data(client)
    binding.pry
  end

  # adds the given line to the given hash
  def hashify_header(hash, line)
    return nil if line.nil? || line.strip.empty?
    key, value = line.split(':')
    hash[convert_key(key)] = value.strip.chomp
  end

  def convert_key(key)
    key = key.downcase
    key = key.strip
    key = key.gsub(/[- ]/,'_')
    key.to_sym
  end

  # convert cookies into the session hash
  def add_cookies(headers)
    cookies = headers[:cookie]
    cookies_hash = Hash.new
    return false unless cookies
    cookies.split('&').each do |string|
      k,v = string.split('=')
      cookies_hash[convert_key(k)] = v
    end
    @params[:cookie] = cookies_hash
  end

  # removes params from route and
  # parameterizes them
  def remove_params(route)
    route, args = route.split('?')
    @params = Hash.new
    return route unless args
    args.split('&').each do |var|
      key, value = var.split('=')
      @params[key.to_sym] = value
    end
    puts @params
    route
  end

end

