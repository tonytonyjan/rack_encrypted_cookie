# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name = 'rack_encrypted_cookie'
  s.version = '1.0.0'
  s.licenses = ['MIT']
  s.summary = 'Rack middleware for signed encrypted session cookie.'
  s.description = "Rack middleware for signed encrypted session cookie. It's fully compatible with Rack::Session::Cookie, not only safe but also easy to use"
  s.author = 'Jian Weihang'
  s.email = 'tonytonyjan@gmail.com'
  s.files = ['lib/rack/session/encrypted_cookie.rb']
  s.homepage = 'https://github.com/tonytonyjan/rack_encrypted_cookie'
  s.required_ruby_version = '>= 2.3.0'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'coder_decorator', '>= 1.0.2'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rake'
end
