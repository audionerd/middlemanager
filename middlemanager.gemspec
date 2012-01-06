Gem::Specification.new do |s|
  s.name          = 'middlemanager'
  s.version       = '0.1.0'
  s.platform      = Gem::Platform::RUBY
  s.author        = 'Eric Skogen'
  s.email         = 'code@audionerd.com'
  s.summary       = 'A mostly-powerless little content manager for static sites'
  s.description   = 'MiddleManager is a Sinatra-powered content manager for static sites. It integrates well with the Middleman static site generator.'
  s.homepage      = 'https://github.com/audionerd/middlemanager'
                  
  s.files         = `git ls-files -- *`.split("\n") - Dir['fixtures/**/*.*']
  s.test_files    = `git ls-files -- fixtures/*`.split("\n")
  s.require_path  = 'lib'

  s.add_runtime_dependency('sinatra')
  s.add_runtime_dependency('thor')
  s.add_runtime_dependency('psych', ["~> 1.2.2"])
end