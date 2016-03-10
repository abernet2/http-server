require_relative '../users'
FILE = BASE_DIR+'\\spec\\test_list.txt'

describe 'users' do
  let(:users) {Users.new(FILE)}
  # clears the files before every operation
  before do
    f = File.open(FILE, 'w')
    f.puts ''
  end

  describe 'initialize' do
    it 'initializes an empty users hash' do
      expect(users.list).to eq Hash.new
    end
  end

  describe 'add_user' do
    it 'adds a username and password to the hash' do
      users.add('username', 'password')
      expect(users.list).to eq ({username: 'password'})
    end

    it 'returns true if user is added' do
      expect(users.add('username', 'password')).to eq true
    end
    it 'returns true if user is added' do
      users.add('username', 'password')
      expect(users.add('username', 'password')).to eq false
    end
  end

  describe 'authenticate' do
    it 'returns true if the username is already stored and matches' do
      users.add('username', 'password')
      expect(users.authenticate('username', 'password'))
    end

    it 'returns false if the username is already stored and matches' do
      expect(users.authenticate('username', 'password'))
    end

    it 'returns false if the password doesnt match stored and matches' do
      users.add('username', 'password')
      expect(users.authenticate('username', 'password2'))
    end
  end

  describe 'load_list' do
    it 'should turn an existing list into a hash' do
      u = Users.new(BASE_DIR+'\\spec\\saved_list.txt')
      list = u.load_list
      expect(list).to eq ({username2: 'password2'})
    end
  end

  describe 'store list' do
    it 'should turn an existing list into a hash' do
      if users.add('username2', 'password2')
        u = Users.new(FILE)
        list = u.list
      end
      expect(list).to eq ({username2: 'password2'})
    end
  end
    
end