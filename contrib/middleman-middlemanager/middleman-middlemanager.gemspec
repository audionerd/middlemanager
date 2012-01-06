Gem::Specification.new do |s|
  s.name          = 'middleman-middlemanager'
  s.version       = '0.1.0'
  s.platform      = Gem::Platform::RUBY
  s.author        = 'Eric Skogen'
  s.email         = 'code@audionerd.com'
  s.summary       = 'Middleman adapter for MiddleManager'
  s.description   = 'An extension to Middleman to integrate a MiddleManager content management admin UI'
  s.homepage      = 'https://github.com/audionerd/middlemanager'

  s.files         = `git ls-files -- lib/*`.split("\n")
  s.require_path  = 'lib'

  s.add_runtime_dependency('middleman', ["~> 3.0.0.beta.1"])
  s.add_runtime_dependency('middlemanager')
  s.add_runtime_dependency('sinatra')
  s.add_runtime_dependency('thor')
end