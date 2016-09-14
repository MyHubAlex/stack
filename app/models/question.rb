class Question < ApplicationRecord  
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  belongs_to :user

  validates :title, :body, :user_id,  presence: true
  validates :title,         length: { minimum: 15, maximum: 255 }

  accepts_nested_attributes_for :attachments
end