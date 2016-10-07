class Comment < ApplicationRecord

  #scope :ordered, -> { order(created_at: :desc) }

  belongs_to :commentable, optional: true, polymorphic: true
  belongs_to :user

  validates :user_id, :commentable_id, :body,  presence: true
  
end