# app/lib/json_web_token.rb
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    begin
      # get payload; first index in decoded Array
      body = JWT.decode(token, HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
        # rescue from expiry exception
    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      # raise custom error to be handled by custom handler
      puts "ola"
      raise ExceptionHandler::ExpiredSignature, e.message
    end
  end
end