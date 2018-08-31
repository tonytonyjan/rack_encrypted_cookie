# frozen_string_literal: true
require 'rack/session/cookie'
require 'openssl'
require 'base64'
require 'coder_decorator'

module Rack
  module Session
    class EncryptedCookie < Cookie #:nodoc:
      Coders = CoderDecorator::Coders
      def initialize(app, options = {})
        @secret_key_bases = options.values_at(:secret, :old_secret).compact
        return super if @secret_key_bases.empty?
        @iterations = options.fetch(:iterations, 1024)
        @key_size = options.fetch(:key_size, 32)
        cipher = options.fetch(:cipher, 'AES-256-CBC')
        digest = options.fetch(:digest, 'SHA1')
        salt = options.fetch(:salt, 'encrypted cookie')
        signed_salt = options.fetch(:signed_salt, 'signed encrypted cookie')
        cipher_secrets = @secret_key_bases.map { |secret_key_base| generate_key(secret_key_base, salt) }
        sign_secrets = @secret_key_bases.map { |secret_key_base| generate_key(secret_key_base, signed_salt) }
        encrypted_coder = Coders::Cipher.new(Coders::Marshal.new, secret: cipher_secrets.first, old_secret: cipher_secrets.last, cipher: cipher)
        signed_coder = Coders::HMAC.new(encrypted_coder, secret: sign_secrets.first, old_secret: sign_secrets.last, digest: digest)
        options[:coder] = Coders::Rescue.new(signed_coder)
        options[:let_coder_handle_secure_encoding] = true
        super
        @secrets = [] # hack, lie to Rack::Session that there is no @secrets
      end

      private

      def generate_key(secret, salt)
        OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret, salt, @iterations, @key_size)
      end
    end
  end
end
