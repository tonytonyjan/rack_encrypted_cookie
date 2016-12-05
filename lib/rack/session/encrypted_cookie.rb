# frozen_string_literal: true
require 'rack/session/cookie'
require 'openssl'
require 'base64'

module Rack
  module Session
    class EncryptedCookie < Cookie
      def initialize(app, options = {})
        super
        @salt = options.fetch(:salt, 'encrypted cookie')
        @signed_salt = options.fetch(:signed_salt, 'signed encrypted cookie')
        @iterations = options.fetch(:iterations, 1024)
        @key_size = options.fetch(:key_size, 64)
        @cipher = OpenSSL::Cipher::Cipher.new(options.fetch(:cipher, 'AES-256-CBC'))
        @cipher_secrets = @secrets.map{ |secret| generate_key(secret, @salt) }
        @secrets.map!{ |secret| generate_key(secret, @signed_salt) }
      end

      private

      def unpacked_cookie_data(request)
        request.fetch_header(RACK_SESSION_UNPACKED_COOKIE_DATA) do |k|
          session_data = request.cookies[@key]

          if !@secrets.empty? && session_data
            digest, session_data = session_data.reverse.split('--', 2)
            digest&.reverse!
            session_data&.reverse!
            session_data = nil unless digest_match?(session_data, digest)
          end

          if !@cipher_secrets.empty? && session_data
            encrypted_data, iv = ::Base64.strict_decode64(session_data).split('--').map! { |v| ::Base64.strict_decode64(v) }

            @cipher_secrets.each do |cipher_secret|
              @cipher.decrypt
              @cipher.key = cipher_secret
              @cipher.iv  = iv
              begin
                session_data = @cipher.update(encrypted_data) << @cipher.final
                break
              rescue OpenSSL::Cipher::CipherError
              end
            end
          end
          request.set_header(k, coder.decode(session_data) || {})
        end
      end

      def write_session(req, session_id, session, _options)
        session = session.merge('session_id' => session_id)
        session_data = coder.encode(session)

        if @cipher_secrets.first
          @cipher.encrypt
          @cipher.key = @cipher_secrets.first
          iv = @cipher.random_iv
          encrypted_data = @cipher.update(session_data) << @cipher.final
          blob = "#{::Base64.strict_encode64 encrypted_data}--#{::Base64.strict_encode64 iv}"
          session_data = ::Base64.strict_encode64(blob)
        end

        if @secrets.first
          session_data << "--#{generate_hmac(session_data, @secrets.first)}"
        end

        if session_data.size > (4096 - @key.size)
          req.get_header(RACK_ERRORS).puts('Warning! Rack::Session::Cookie data size exceeds 4K.')
          nil
        else
          session_data
        end
      end

      def generate_key(secret, salt)
        OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret, salt, @iterations, @key_size)
      end
    end
  end
end
