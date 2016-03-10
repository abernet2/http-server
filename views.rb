class Views
  def self.welcome(opts={})
    # name = opts[:name]
    "<html>
    <head>
      <title>Welcome</title>
    </head>
    <body>
      <h1>Hello World  #{opts[:name]}</h1>
      <p>Welcome to the world's simplest web server. #{opts[:userid]}</p>
      <p><img src='http://i.imgur.com/A3crbYQ.gif'></p>
    </body>
    </html>"
  end

  def self.profile(opts={})
    cookies = opts[:cookie] || {}
     "<html>
    <head>
      <title>My Profile Page</title>
    </head>
    <body>
      <p>This is #{cookies[:username]}'s' profile page.</p>
    </body>
    </html>"
  end

  def self.response(opts={})
  "<html>
      <head></head>
      <body>
        <h1>TITELS</h1>
        <p>Welcome</p>
      </body>
    </html> "
  end

  def self.visits(opts={})
  "<html>
      <head></head>
      <body>
        <h1>#{opts[:count]}</h1>
        <p>Welcome</p>
      </body>
    </html> "
  end

  def self.login
    "<html>
      <head></head>
      <body>
        <form action='/login' method='post'>
          <input type='text' name='username'/>
          <input type='text' name='password'/>
          <input type='submit' />
        </form>
      </body>
    </html>"
  end
end