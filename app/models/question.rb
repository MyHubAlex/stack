class Question < ApplicationRecord
  
  has_many :answers, dependent: :destroy

  
  validates :title, :body,  presence: true
  validates :title,         length: { minimum: 15 }
end
