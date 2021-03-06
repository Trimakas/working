class Merchant < ActiveRecord::Base
    has_one :shop
    
    has_many :products
    
    include Reports
    include Call
    
    before_save { self.email = email.downcase }
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    
    attr_encrypted :token, :key => ENV['token_key']
    #attr_encrypted :encrypted_token, :key => Rails.env.test? ? 'token_key' : ENV['token_key']
    
    validates :name, presence: true, length: {minimum: 2}
    validates :merchant_identifier, presence: true, uniqueness: true, length: {minimum: 10}
    validates :encrypted_token, presence: true, length: {minimum: 35}
    validates :marketplace, presence: true, length: {minimum: 10}
    validates :password_digest, presence: true, length: {minimum: 2}
    validates :email, presence: true, length: { maximum: 105},
                                    uniqueness: { case_sensitive: false},
                                    format: { with: VALID_EMAIL_REGEX }
    
    has_secure_password
    
end
