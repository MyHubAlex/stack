class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:new, :create]
  before_action :load_answer, except: [:create]
  include Voted

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    if current_user.belongs_to_obj(@answer)
      @answer.destroy      
    end    
  end

  def edit
    @question = @answer.question
  end

  def update
    @question = @answer.question
    if current_user.belongs_to_obj(@answer) && @answer.update(answer_params) 
      flash[:notice] = 'Your answer was changed'
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
    params.require(:answer).permit(:content, attachments_attributes: [:file, :attachment_id, :_destroy])
  end
end
