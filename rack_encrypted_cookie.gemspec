# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = 'rack_encrypted_cookie'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Rack middleware for signed encryped session cookie.'
  s.description = 'Rack middleware for signed encryped session cookie.'
  s.authors     = ['Jian Weihang']
  s.email       = 'tonytonyjan@gmail.com'
  s.files       = ['lib/rack/session/encrypted_cookie.rb']
  s.add_runtime_dependency 'rack'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'
end
