class Question < ApplicationRecord  
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body,  presence: true
  validates :title,         length: { minimum: 15, maximum: 255 }
end
