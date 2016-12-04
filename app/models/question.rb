class Question < ApplicationRecord 
  include Votable 
  include Commentable 
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user
  after_create :subscribe_for_author

  validates :title, :body, :user_id,  presence: true
  validates :title,         length: { minimum: 15, maximum: 255 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :from_yesterday, -> { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }

  def subscribe_for_author
    user.subscribe(self)
  end
  
end