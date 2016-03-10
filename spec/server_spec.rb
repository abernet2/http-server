require_relative '../server'
require 'stringio'

describe 'server' do
  let(:client) { StringIO.new("GET http://localhost:2600/profile HTTP/1.1
    Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    Accept-Encoding:gzip, deflate, sdch
    Accept-Language:en-US,en;q=0.8
    Cache-Control:max-age=0
    Connection:keep-alive
    Host:localhost:2600
    Upgrade-Insecure-Requests:1
    User-Agent:Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36
  ")}
  let(:server) { Server.new({}, {}, {}) }

  describe 'extract headers' do
    it 'should take a an IO type object and return a hash' do
      expect(server.extract_headers(client)).to be_a_kind_of Hash
    end
    it 'should have correct content in the hash' do
      hash = server.extract_headers(client)
      expect(hash[:connection]).to eq 'keep-alive'
    end
    it 'should return nil if client is empty' do
      expect(server.extract_headers(StringIO.new)).to be nil
    end
  end

  describe 'remove params' do
    let(:url) {'/login?username=username&password=password'}
    it 'should take a route string and return a route w/o params' do 
      expect(server.remove_params(url)).to be_a_kind_of String
    end

    it 'should add the params to an instance variable' do
      server.remove_params(url)
      expected = {username: 'username', password: 'password'}
      expect(server.instance_variable_get('@params')).to eq expected
    end
  end

  describe 'convert key' do
    it 'should ignore case by converting to downcase' do
      up = server.convert_key("TEST")
      down = server.convert_key("test")
      expect(up).to eq down
    end
    it 'should convert a string to a symbol' do
      result = server.convert_key('test')
      expect(result).to be_a_kind_of Symbol
    end

    it 'should remove whitespaces' do
      white = server.convert_key('    test    ')
      not_space = server.convert_key('test')
      expect(white).to eq not_space
    end
    it 'should replace dashes with underscores' do
      dash = server.convert_key('test-data')
      no_dash  = server.convert_key('test_data')
      expect(dash).to eq no_dash
    end    
  end
  
  describe 'add_cookies' do
    let(:params) { server.instance_variable_get('@params') }
    it 'should return false if no cookies are in the given hash' do
      h = Hash.new
      expect(server.add_cookies h).to eq false
    end
    it 'should return the cookies in a hash if they are there' do
      cookies = {user: 'me', other_user: 'you'}
      headers = {cookie: 'user=me&other_user=you'}
      expect(server.add_cookies(headers)).to eq cookies
    end
    it 'should add cookies to the params hash' do
      cookies = {user: 'me', other_user: 'you'}
      headers = {cookie: 'user=me&other_user=you'}
      server.add_cookies(headers)
      expect(params[:cookie]).to eq cookies
    end
  end
end