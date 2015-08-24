class Merchant < ActiveRecord::Base
    self.primary_key = 'merchant_identifier'
    has_many :products, :foreign_key => 'merchant_identifier', :primary_key => 'merchant_identifier'

    before_save { self.email = email.downcase }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    validates :name, presence: true, length: {minimum: 2}
    validates :merchant_identifier, presence: true, uniqueness: true, length: {minimum: 10}
    validates :token, presence: true, length: {minimum: 35}
    validates :marketplace, presence: true, length: {minimum: 10}
    validates :password_digest, presence: true, length: {minimum: 2}
    validates :email, presence: true, length: { maximum: 105},
                                    uniqueness: { case_sensitive: false},
                                    format: { with: VALID_EMAIL_REGEX }
    
    has_secure_password
    
end
