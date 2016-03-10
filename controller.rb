require_relative 'users'
require 'pry'

class Controller
  def initialize
    @requests = {
      :get => Hash.new,
      :post => Hash.new,
      :put => Hash.new,
      :patch => Hash.new,
      :delete => Hash.new
    }
  end

  # store action, returns nil if no block is given
  # or if an invalid action type is given
  def store_action(type, route, params={})
    action = @requests[ type.downcase.to_sym ]
    return nil unless block_given? || action
    action[route] = Proc.new
  end

  # if block is given, will store the block
  # otherwise will check for block and call
  # the block
  def perform_action(type, route, params={})
    type = type.downcase
    action = @requests[type.to_sym]
    return redirect(404) unless action[route]
    response(type, params) + action[route].call(params)
  end

  def login(params)
    username, password = params.values_at(:username, :password)
    if username && @users.authenticate(username, password)
      @login = "Set-Cookie: username=#{username}\n"
    end  
  end

  def logout
    @login = "Set-Cookie: username=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT\n"
  end

  def redirect(path)
    puts 'redirect'
    return "HTTP/1.1 404 Not Found" if path == 404
    p "HTTP/1.1 302 Found\nLocation: #{path}\n#{@login}\n"
  end

  def get_header(params)
    "HTTP/1.1 200 Ok\n#{@login}\n"
  end

  def method_missing(method_sym, *arguments, &block)
    if @requests[method_sym].nil?
      super
    else
      route, params = arguments
      params ||= {}
      block_given? ?
        store_action(method_sym, route, params) { yield(params) } :
        perform_action(method_sym, route, params)
    end
  end

  def respond_to?(method_sym, include_private = false)
    if @requests[method_sym].nil? # if it is valid action
      super
    else
      true
    end
  end

  private

  def response(type, params)
    case type
    when :get
      response = "HTTP/1.1 200 OK\n\n"
    when :post
      response = "" # post should redirect, nede to refactor redirection
    end
  end


end
