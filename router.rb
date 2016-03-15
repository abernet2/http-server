# DEPRECATED, USE CONTROLLER INSTEAD
GET_HEADER = "HTTP/1.1 200 Ok\n\n"
require_relative 'users'

class Router
  def initialize
    # a hash of routes that point to blocks
    @routes = Hash.new
    @users = Users.new
    @routes[:default] = 'default'
  end

  def add(name)
    @routes[name] = Proc.new  # same as &block in args
  end

  def route(type, name, params={})
    response = self[name, params] if type.downcase == 'get'
    if response.include? '302'
      response
    else
      get_header(params) + response
    end
  end

  def [](name, params={})
    if @routes[name]
      @routes[name].call(params) 
    else
      @routes[:default]
    end
  end

  def login(params)
    username, password = params.values_at(:username, :password)
    if username && @users.authenticate(username, password)
      p @login = "Set-Cookie: username=#{username}\n"
    end  
  end

  def logout
    @login = "Set-Cookie: username=deleted; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT\n"
  end

  def redirect(path)
    "HTTP/1.1 302 Found\nLocation: #{path}\n#{@login}\n"
  end

  def get_header(params)
    "HTTP/1.1 200 Ok\n#{@login}\n"
  end

end

