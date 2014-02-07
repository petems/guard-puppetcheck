# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name         = "guard-puppetcheck"
  s.version      = '0.0.1'
  s.author       = 'Peter Souter'
  s.email        = 'p.morsou@gmail.com'
  s.summary      = 'Guard plugin for checking puppet'
  s.description  = "Guard::PuppetCheck automatically checks your puppet files on reload."
  s.homepage     = 'https://github.com/petems/guard-puppetcheck'
  s.license      = "MIT"

  s.files        = `git ls-files`.split($/)
  s.test_files   = s.files.grep(%r{^spec/})
  s.require_path = 'lib'

  s.add_dependency 'guard',        '~> 2.0'
  s.add_dependency 'puppet-lint',  '~> 0.3.2'
  
  s.add_development_dependency 'bundler', '>= 1.3.5'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency "rspec-given"
  s.add_development_dependency "guard-rspec"
end
