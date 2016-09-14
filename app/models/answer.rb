class Answer < ApplicationRecord  
  belongs_to :question
  belongs_to :user
  has_many :attachments, dependent: :destroy, as: :attachable
  
  validates :content, :question_id, :user_id,  presence: true    

  default_scope { order(best: :desc, created_at: :asc )}

  accepts_nested_attributes_for :attachments

  def is_best
    Answer.transaction do
      self.question.answers.where(best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
end
