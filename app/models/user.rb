class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook, :github, :google_oauth2]

  # Setting up our association with the conversations table/model. It wont have a user_id
  # column so we explicitely tell rails to look for the user_id under the 'sender_id' column
  has_many  :conversations, :foreign_key => :sender_id

  # Called via the OmniAuth callbacks controller to set the @user 
  # using the response hash: (request.env["omniauth.auth"])
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  
end
