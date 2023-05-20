class User < ApplicationRecord
  has_secure_password

  validates :username, uniqueness: true, length: { in: 3..30 }, format: { without: URI::MailTo::EMAIL_REGEXP, message:  "can't be an email" }
  validates :email, uniqueness: true, length: { in: 3..255 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { in: 6..255 }, allow_nil: true

    # in a loop:
    # use SecureRandom.base64 to generate a random token
    # use `User.exists?` to check if this `session_token` is already in use
    # if already in use, continue the loop, generating a new token
    # if not in use, return the token

  def generate_session_token
    loop do
      token = SecureRandom.base64
      break token unless User.exists?(session_token: token)
    end
  end

    # if `self.session_token` is already present, leave it be
    # if `self.session_token` is nil, set it to `generate_unique_session_token`

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

end
