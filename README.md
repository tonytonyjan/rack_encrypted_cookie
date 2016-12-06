# Rack::Session::EncryptedCookie [![Build Status](https://travis-ci.org/tonytonyjan/rack_encrypted_cookie.svg?branch=master)](https://travis-ci.org/tonytonyjan/rack_encrypted_cookie)

# Installation

```
gem install rack_encrypted_cookie
```

# Usage

In your project, replace `Rack::Session::Cookie` with `Rack::Session::EncryptedCookie`, and it will just work. `Rack::Session::EncryptedCookie` is **FULLY COMPATIBLE** with `Rack::Session::Cookie`, even accepts all options.

# Minimal Example

```ruby
require 'rack/session/encrypted_cookie'

app = lambda do |env|
  session = env['rack.session']
  session[:count] ||= 0
  session[:count] += 1
  [200, {}, [session[:count].to_s]]
end

app = Rack::Builder.app(app) do
  use Rack::Session::EncryptedCookie, secret: 'secret_key_base'
end

Rack::Handler::WEBrick.run app
```

# Options

option         | default
---------------|----------------------------
`:salt`        | `'encrypted cookie'`
`:signed_salt` | `'signed encrypted cookie'`
`:iterations`  | `1024`
`:key_size`    | `64`
`:cipher`      | `'AES-256-CBC'`

A list of supported algorithms can be obtained by

```ruby
puts OpenSSL::Cipher.ciphers
```

# How it works

In `Rack::Session::Cookie`, the `:secret` option is used for signing, while `Rack::Session::EncryptedCookie` treats it as a secrete key base, which is used to generate derived keys (one for signing, another for encryption) using PBKDF2 with an SHA1-based HMAC.

# Cookie Structure

## `Rack::Session::EncryptedCookie`

```
+-------------------------- uri encode -------------------------+
| +----------------------- base64 ------------+      +-- hex -+ |
| | +------- base64 ------+      +- base64 -+ |      |        | |
| | | +-- AES-256-CBC --+ |      |          | |      |        | |
| | | |     marshal     | | "--" |    iv    | | "--" |  hmac  | |
| | | +-----------------+ |      |          | |      |        | |
| | +---------------------+      +----------+ |      |        | |
| +-------------------------------------------+      +--------+ |
+---------------------------------------------------------------+
```

## `Rack::Session::Cookie`

```
+--------- uri encode ----------+
| +-- base64 -+      +-- hex -+ |
| |  marshal  | "--" |  hmac  | |
| +-----------+      +--------+ |
+-------------------------------+
```

# TODO

- Support AEAD cipher like 'aes-256-gcm'
