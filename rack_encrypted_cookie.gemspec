# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = 'rack_encrypted_cookie'
  s.version     = '0.1.0'
  s.licenses    = ['MIT']
  s.summary     = 'Rack middleware for signed encrypted session cookie.'
  s.description = 'Rack middleware for signed encrypted session cookie.'
  s.authors     = ['Jian Weihang']
  s.email       = 'tonytonyjan@gmail.com'
  s.files       = ['lib/rack/session/encrypted_cookie.rb']
  s.required_ruby_version = '>= 2.3.0'
  s.add_runtime_dependency 'rack'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'
end
