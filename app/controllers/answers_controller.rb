class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_question, only: [:new, :create]
     
  def new
    @answer = @question.answers.new 
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      flash[:notice] = "Your answer created"
      redirect_to @question
    else
      render :new   
    end
    
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user == current_user
      @answer.destroy
      flash[:notice] = 'Your answer was deleted'      
    end
    redirect_to @answer.question          
  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def update
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user == current_user && @answer.update(answer_params) 
       flash[:notice] = 'Your answer was changed'
       redirect_to @question       
    else
      render :edit   
    end
  end

  private

  def get_question
    @question = Question.find(params[:question_id])
  end

  def answer_params    
    params.require(:answer).permit(:content)
  end
end
