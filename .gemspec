Gem::Specification.new do |gem|
  gem.name    = 'rack-zombie_shotgun'
  gem.version = '0.0.1'
  gem.date    = '2010-11-11'

  gem.summary = 'A Rack Middleware to eliminate zombie requests!'
  gem.description = 'A Rack Middleware to eliminate zombie requests!'

  gem.author   = 'Brandon Hauff'
  gem.email    = 'bhauff@gmail.com'
  gem.homepage = 'http://github.com/bhauff/rack-zombie_shotgun'

  gem.add_development_dependency('shoulda', [">= 2.10.2"])

  gem.files = %w(README.textile LICENSE.textile Rakefile) + Dir["{lib,test}/**/*"]
end
