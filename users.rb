# simple implementation
BASE_DIR = 'C:\Users\Jack Abernethy\Downloads\Coding stuff\DevBootcamp\onboarding\http-server'
FILE_LOCATION = BASE_DIR + '\\lib\\list.txt'

class Users
  attr_reader :list
  def initialize(file_location=FILE_LOCATION)
    @file_location = file_location
    @list = load_list
  end

  def add(username, password)
    username = username.to_sym unless username.class == Symbol
    if @list[username] 
      false
    else
      @list[username] = password
      store_list
      true
    end
  end

  def authenticate(username, password)
    username = username.to_sym
    @list[username] == password
  end

  def load_list
    f = File.open(@file_location)
    list = Hash.new
    while line = f.gets
      username, password = line.split(' ')
      list[username.to_sym] = password
    end
    f.close
    list
  end

  def store_list
    f = File.open(@file_location, mode='w')
    list.each do |username, password|
      f.puts "#{username} #{password}"
    end
    f.close
  end
end