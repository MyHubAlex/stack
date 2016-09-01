class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:new, :create]
  before_action :load_answer, except: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    @answer.save        
  end

  def destroy
    if current_user.belongs_to_obj(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer was deleted'      
    end
    redirect_to @answer.question          
  end

  def edit
    @question = @answer.question
  end

  def update
    @question = @answer.question
    if current_user.belongs_to_obj(@answer) && @answer.update(answer_params) 
       flash[:notice] = 'Your answer was changed'
       redirect_to @question       
    else
      render :edit   
    end
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end
  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params    
    params.require(:answer).permit(:content)
  end
end
