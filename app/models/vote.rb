class Vote < ApplicationRecord

  scope :total_vote, -> { sum(:point) }

  belongs_to :votable, optional: true, polymorphic: true
  belongs_to :user

  validates :user_id, :votable_id, presence: true
  validates :point, inclusion: { in: [-1, 1] }, presence: true
  validates :user_id, uniqueness: { scope: :votable_id }

end