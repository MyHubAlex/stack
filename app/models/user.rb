class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions
  has_many :answers
  has_many :authorizations
  has_many :subscriptions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]   

  scope :all_user_without_current, ->(id) { where.not(id: id) }       
  def belongs_to_obj(object) 
   object.user_id == id 
  end  

  def self.find_for_oath(auth) 
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    
    password = Devise.friendly_token[0, 20]  

    return User.new(password: password) unless email
    user = User.where(email: email).first 
    if user 
      user.create_authorization(auth.provider, auth.uid) 
    else
      user = User.create!(email: email, password: password, password_confirmation: password )
      
      user.create_authorization(auth.provider, auth.uid) 
    end  
    user
  end  

  def create_authorization(provider, uid) 
    self.authorizations.create(provider: provider, uid: uid) 
  end

  def self.generate(params)
    user = new(params)
    user.password = Devise.friendly_token[0, 20]
    user
  end   

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_later
    end
  end

  def is_subscribe?(question)
    self.subscriptions.where(question: question).first
  end

  def subscribe(question)
    self.subscriptions.create(question: question)
  end

  def unsubscribe(subscription)
    self.subscriptions.where(id: subscription.id).delete_all
  end
end
