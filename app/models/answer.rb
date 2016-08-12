class Answer < ApplicationRecord
  
    belongs_to :question
  
    validates :comment,  presence: true
    
end
