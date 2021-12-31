class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token
	before_create :create_activation_digest
	before_save {self.email = email.downcase}
	validates :name, presence: true, length: { maximum: 20}

	regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255}, format: { with: regex}, uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, presence: true, length: { minimum: 3}, allow_nil: true

	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    	BCrypt::Password.create(string, cost: cost)
	end

	def User.new_token
		SecureRandom.urlsafe_base64
	end

	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	def authenticated?(attribute,token)
		digest = send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	def forget
 		update_attribute(:remember_digest, nil)
 	end

 	# create and assign activation token and digest 
 	def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    # sets password reset attributes
    def create_reset_digest
    	self.reset_token = User.new_token
    	update_attribute(:reset_digest, User.digest(reset_token))
    	update_attribute(:reset_sent_at, Time.zone.now)
    end

    def send_password_reset_email
    	UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
    	reset_sent_at < 2.hours.ago
    end
end
