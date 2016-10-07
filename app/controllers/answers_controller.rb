class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:new, :create]
  before_action :load_answer, except: [:create]
  include Voted

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def destroy
    if current_user.belongs_to_obj(@answer)
      respond_with(@answer.destroy)      
    end    
  end

  def update
    if current_user.belongs_to_obj(@answer)
      @answer.update(answer_params) 
      respond_with(@answer)
    end      
  end

  def best
    @answer.is_best    
  end

  
  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params    
    params.require(:answer).permit(:content, attachments_attributes: [:file, :attachment_id, :_destroy]).merge(user: current_user)
  end
end
