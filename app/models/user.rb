class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable   

  def belongs_to_obj(object) 
   object.user_id == id 
  end         
end
