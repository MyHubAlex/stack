class Question < ApplicationRecord 
  include Votable 
  include Commentable 
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy, as: :attachable
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user
  after_commit :subscribe_for_author

  validates :title, :body, :user_id,  presence: true
  validates :title,         length: { minimum: 15, maximum: 255 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :from_yesterday, -> { where(created_at: 1.day.ago.all_day) }

  def subscribe_for_author
    self.user.subscriptions.create(question: self)
  end
  
  def is_subscribe?(user)
    self.subscriptions.where(user: user).exists?
  end

  def subscribe(user)
    self.subscriptions.create(user: user)
  end
 
end