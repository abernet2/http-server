require_relative 'router'
require_relative 'controller'
require_relative 'views'

def router_factory
  visit_count = 0
  router = Controller.new
  router.get('/welcome') do |params|
    Views.welcome(params) 
  end
  router.get('/profile') do |params|
    Views.profile(params)
  end
  router.get('/') { Views.response }
  router.get('/visits') do
    visit_count += 1
    Views.visits({count: visit_count}) 
  end 

  router.get('/login') do |params|
    # router.login(params)
    Views.login
  end

  router.post('/login') do |params|
    router.login(params)
    router.redirect('/profile')
  end

  # bad routing
  router.get('/logout') do |params|
    router.logout
    Views.welcome(params)
    router.redirect('/welcome')
  end

  # make sure this function returns a router
  router
end